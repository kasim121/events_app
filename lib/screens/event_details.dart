import 'package:event_app/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  //final String selectedDateLabel;
  final List<Event> events; // Add events parameter

  const EventDetails({super.key, required this.events});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String eventName = '';
  String eventDescription = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool isTimeSelected = false;
  bool isDateSelected = false;
  TextEditingController textTitleController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        isDateSelected = true;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
        isTimeSelected = true;
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dateTime); // Format as "14:00"
  }

  String formatDate(DateTime date) {
    return DateFormat('d-MMM-y').format(date); // Format as "1-Feb-2023"
  }

  @override
  void initState() {
    textTitleController.text = "";
    textDescriptionController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            );
          },
        ),
        title: const Text(
          "Events Detail",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Date & Time:'),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: myHeight * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(
                            227, 212, 200, 200), 
                      ),
                      borderRadius: BorderRadius.circular(
                          8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: isTimeSelected == true
                          ? Text(formatTime(_selectedTime,),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal))
                          : const Text("HH:MM",style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: isDateSelected == true
                        ? Text(formatDate(_selectedDate),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal))
                        : const Text("dd-mm-yy",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("title"),
                  const SizedBox(
                    width: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        )),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: textTitleController,
                      decoration: const InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Description"),
              const SizedBox(height: 16),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(223, 238, 244, 1),
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                height: myHeight * 0.20,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    readOnly: false,
                    controller: textDescriptionController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blueAccent,
        height: 50,
        child: SizedBox(
          height: myHeight * 0.07,
          child: ElevatedButton(
            onPressed: () {
              Event eventData = Event(
                title: textTitleController.text,
                time: formatTime(_selectedTime),
                date: formatDate(_selectedDate),
                description: textDescriptionController.text,
              );

              widget.events.add(eventData);

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(fontSize: 12, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
