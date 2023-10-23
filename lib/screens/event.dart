import 'package:flutter/material.dart';

import '../models/event_model.dart';
import 'event_details.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  int selectedYear = DateTime.now().year;
  bool isMonthSelected = false;
  bool isYearSelected = false;
  String? selectedMonthName;

  List<Event> events = [];
  @override
  void initState() {
    selectedMonthName = _getMonthName(DateTime.now().month);
    super.initState();
  }

  void _selectYear() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: <Widget>[
                const Text("Year"),
                const Divider(),
                for (int year = 2016; year <= 2025; year++)
                  Column(
                    children: [
                      ListTile(
                        title: Center(child: Text(year.toString())),
                        onTap: () {
                          Navigator.pop(context, year);
                        },
                      ),
                      const Divider(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    ).then((newYear) {
      if (newYear != null) {
        setState(() {
          selectedYear = newYear;
          isYearSelected = true;
        });
      }
    });
  }

  void _selectMonth() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<String> months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Month"),
                const Divider(),
                for (String month in months)
                  Center(
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(child: Text(month)),
                          onTap: () {
                            Navigator.pop(context, month);
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ).then((selectedMonth) {
      if (selectedMonth != null) {
        setState(() {
          selectedMonthName = selectedMonth;
          isMonthSelected = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var myHeight = MediaQuery.of(context).size.height;
    List<Event> filteredEvents = events.where((event) {
      final eventDate = _getFormattedDate(event.date);
      return eventDate.year == selectedYear &&
          eventDate.month == _getMonthNumber(selectedMonthName!);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Events",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  height: myHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: _selectYear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      textStyle:
                          const TextStyle(fontSize: 12, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isYearSelected == false
                        ? const Text(
                            "Year",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '$selectedYear',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: SizedBox(
                  height: myHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectMonth,
                    child: isMonthSelected == false
                        ? const Text(
                            "Month",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '$selectedMonthName',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(
                            events: events,
                          ),
                        ),
                      );
                    },
                    child: const Center(child: Text(" + Create event",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20))),
                  )
                : ListView.builder(
                    itemCount: isYearSelected && isMonthSelected
                        ? filteredEvents.length
                        : 0,
                    itemBuilder: (context, index) {
                      final eventListItem = filteredEvents[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          onTap: () async {
                            dynamic returnedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetails(events: events),
                              ),
                            );

                            if (returnedData != null) {
                              setState(() {
                                events.add(returnedData);
                              });
                            }
                          },
                          title: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(" ${eventListItem.date.toString().substring(0, 2)}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              _getMonthAbbreviation(
                                                selectedMonthName!,
                                              ),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        const VerticalDivider(
                                          color: Colors.grey,
                                          thickness: 2,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${eventListItem.time} ${eventListItem.date}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              eventListItem.description
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }

  String _getMonthName(int month) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  int _getMonthNumber(String monthName) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months.indexOf(monthName) + 1;
  }

  String _getMonthAbbreviation(String monthName) {
    return monthName.substring(0, 3);
  }

  DateTime _getFormattedDate(String dateStr) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final parts = dateStr.split('-');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = months.indexOf(parts[1]) + 1;
      final year = int.tryParse(parts[2]);

      if (day != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return DateTime.now(); // Return the current date as a fallback
  }
}
