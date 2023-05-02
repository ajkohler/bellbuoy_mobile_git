import 'dart:io';

import 'package:bellbuoy_mobile/services/statement_service.dart';
import 'package:bellbuoy_mobile/ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/global.dart';
import '../services/local_storage_service.dart';
import 'nav_drawer.dart';

class Statements extends StatefulWidget {
  const Statements({Key? key}) : super(key: key);

  @override
  State<Statements> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Statements> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  late DateTime startDate = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  late DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    startDateController.text = dateToText(startDate);
    endDateController.text = dateToText(endDate);
    return Scaffold(
      appBar: const CustomAppBar(title: "Statements", status: Status.Complete),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 198,
                    height: 60,
                    child: TextFormField(
                      controller: startDateController,
                      onTap: () {
                        _selectDate(context, true);
                      },
                      restorationId: 'start_date_field',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Start Date",
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 198,
                    height: 60,
                    child: TextFormField(
                      controller: endDateController,
                      onTap: () {
                        _selectDate(context, false);
                      },
                      restorationId: 'end_date_field',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "End Date",
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 35),
                      primary: Colors.lightBlue),
                  onPressed: () {
                    setDates(1);
                  },
                  child: const Text("Last Month")),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 35),
                      primary: Colors.lightGreen),
                  onPressed: () {
                    setDates(2);
                  },
                  child: const Text("Last 3 Months")),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 35),
                      primary: Colors.orangeAccent),
                  onPressed: () {
                    setDates(3);
                  },
                  child: const Text("Last Week")),
              Spacer(),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(400, 35),
              ),
              onPressed: () {
                openStatement();
              },
              child: const Text("Submit")),
          // ListView.builder(
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return const Text("Test");
          //     })
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isStartDate ? startDate : endDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2023));
    if (picked != null) {
      if (isStartDate) {
        if (picked.isAfter(endDate)) {
          showAlert("Start date cannot be after end date");
          return;
        }
      } else {
        if (startDate.isAfter(picked)) {
          showAlert("End date cannot be before start date");
          return;
        }
      }

      if (isStartDate) {
        startDate = picked;
        startDateController.text = dateToText(picked);
      } else {
        endDate = picked;
        endDateController.text = dateToText(picked);
      }
    }
  }

  void setDates(int timeframe) {
    switch (timeframe) {
      case 1:
        late DateTime date = DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
        var days = DateTime.now().difference(date).inDays;
        startDate = getDate(DateTime.now().subtract(Duration(days: days)));
        break;
      case 2:
        late DateTime date = DateTime(
            DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
        var days = DateTime.now().difference(date).inDays;
        startDate = getDate(DateTime.now().subtract(Duration(days: days)));
        break;
      case 3:
        startDate = getDate(DateTime.now().subtract(const Duration(days: 7)));
        break;
    }
    startDateController.text = dateToText(startDate);
    endDate = DateTime.now();
    endDateController.text = dateToText(endDate);
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void showAlert(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  String dateToText(DateTime date) {
    return '${date.day.toString().length == 1 ? '0${date.day}' : date.day}/'
        '${date.month.toString().length == 1 ? '0${date.month}' : date.month}/'
        '${date.year}';
  }

  Future<void> openStatement() async {
    String start =
        '${startDate.year}-${startDate.month.toString().length == 1 ? '0${startDate.month}' : startDate.month}-${startDate.day.toString().length == 1 ? '0${startDate.day}' : startDate.day}';

    String end =
        '${endDate.year}-${endDate.month.toString().length == 1 ? '0${endDate.month}' : endDate.month}-${endDate.day.toString().length == 1 ? '0${endDate.day}' : endDate.day}';
    //StatementService().openStatement(start, end);
    openStatement2(start, end);
  }

//REMOVE BELOW
  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Cannot launch URL'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Unfortunately you can not launch the url'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getUsername() async {
    return await LocalStorageService().username();
  }

  void openStatement2(String start, String end) async {
    String username = await getUsername();
    var url = Uri.parse(
        '${Global.invoiceUri}?customerNo=$username&dateFrom=$start&dateTo=$end&format=pdf');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      print("Can open url");
    } catch (Exception) {
      _showAlertDialog();
      print("Cannot open url");
      CupertinoAlertDialog(title: Text("Could not open URL"));
    }
  }
}
