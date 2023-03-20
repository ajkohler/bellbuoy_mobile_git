import 'package:bellbuoy_mobile/dtos/approval_dto.dart';
import 'package:bellbuoy_mobile/services/document_service.dart';
import 'package:bellbuoy_mobile/ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/approval_service.dart';
import 'nav_drawer.dart';

class Approvals extends StatefulWidget {
  const Approvals({Key? key}) : super(key: key);

  @override
  State<Approvals> createState() => _ApprovalState();
}

class _ApprovalState extends State<Approvals> {
  List<ApprovalDto> approvals = [];
  late Status _updatingStatus;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = true;
    // _updatingStatus = Status.Updating;
    //getLocalApprovals();
    updateApprovals();
    // _updatingStatus = Status.Complete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Approvals', status: _updatingStatus),
      drawer: const NavDrawer(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView.builder(
          itemCount: approvals.length,
          itemBuilder: (context, index) {
            switch (approvals[index].statusId) {
              case 1:
                //var date = DateTime.parse(approvals[index].createDate);
                var date = approvals[index].createDate;

                return Card(
                  child: Column(
                    children: [
                      ExpansionTile(
                          key: Key(index.toString()),
                          initiallyExpanded: !approvals[index].hasApproved,
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ApprovalService()
                                    .openDocument(approvals[index].documentId);
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: const Text('View Invoice'),
                          ),
                          title: ListTile(
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.approval_rounded),
                            ),
                            title: Text(approvals[index].invoiceNumber),
                            subtitle: Text(
                              dateToText1(date),
                              //date,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          children: [
                            ListTile(
                              leading: const SizedBox(
                                width: 60,
                              ),
                              dense: true,
                              title: Text(
                                'R${approvals[index].amount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            !approvals[index].hasApproved
                                ? ButtonBar(
                                    alignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          approveInvoice(
                                              approvals[index].invoiceId,
                                              index);
                                          // Perform some action
                                        },
                                        child: const Text(
                                          'APPROVE',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print(approvals.length);
                                          declineInvoice(
                                              approvals[index].invoiceId,
                                              index);
                                          // Perform some action
                                        },
                                        child: const Text(
                                          'DECLINE',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 20,
                                  ),
                          ]),
                    ],
                  ),
                );
                break;

              case 2:
                //var date = DateTime.parse(approvals[index].createDate);
                var date = approvals[index].createDate;

                return Card(
                  color: Colors.lightGreen[100],
                  child: Column(
                    children: [
                      ExpansionTile(
                          key: Key(index.toString()),
                          initiallyExpanded: false,
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ApprovalService()
                                    .openDocument(approvals[index].documentId);
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: const Text('View Invoice'),
                          ),
                          title: ListTile(
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.check),
                            ),
                            title: Text(approvals[index].invoiceNumber),
                            subtitle: Text(
                              dateToText1(date),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          children: [
                            ListTile(
                              leading: const SizedBox(
                                width: 60,
                              ),
                              dense: true,
                              title: Text(
                                'R${approvals[index].amount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ]),
                    ],
                  ),
                );
                break;

              case 3:
                //var date = DateTime.parse(approvals[index].createDate);
                var date = approvals[index].createDate;

                return Card(
                  color: Colors.deepOrange[100],
                  child: Column(
                    children: [
                      ExpansionTile(
                          key: Key(index.toString()),
                          initiallyExpanded: false,
                          trailing: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              ApprovalService()
                                  .openDocument(approvals[index].documentId);
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: const Text('View Invoice'),
                          ),
                          title: ListTile(
                            leading: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.close),
                            ),
                            title: Text(approvals[index].invoiceNumber),
                            subtitle: Text(
                              dateToText1(date),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          children: [
                            ListTile(
                              leading: const SizedBox(
                                width: 60,
                              ),
                              dense: true,
                              title: Text(
                                'R${approvals[index].amount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    approveInvoice(
                                        approvals[index].invoiceId, index);
                                    // Perform some action
                                  },
                                  child: const Text(
                                    'APPROVE',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ]),
                    ],
                  ),
                );
                break;
              default:
                return Text("");
                break;
            }
          },
        ),
      ),
    );
  }

  Future<void> openDocument(String path) async {
    await DocumentService().updateDocuments().then((value) => {
          setState(() {
            //approvals = value;
          })
        });
  }

  Future<void> _pullRefresh() async {
    setStatus(Status.Updating);
    // setState(() {
    //   _updatingStatus = Status.Updating;
    // });
    await updateApprovals();
    setState(() {
      _updatingStatus = Status.Complete;
    });
  }

  Future<void> getLocalApprovals() async {
    setStatus(Status.Updating);

    await ApprovalService().getApprovals().then((value) => {
          if (value.isNotEmpty)
            {
              setState(() {
                approvals = value;
              })
            }
        });

    setStatus(Status.Complete);
  }

  Future<void> updateApprovals() async {
    setStatus(Status.Updating);
    await ApprovalService().updateApprovals().then((value) => {
          setState(() {
            approvals = value;
          })
        });
    setStatus(Status.Complete);
  }

  void setStatus(status) {
    setState(() {
      _updatingStatus = status;
    });
  }

  String dateToText(DateTime date) {
    return '${date.day.toString().length == 1 ? '0${date.day}' : date.day}/'
        '${date.month.toString().length == 1 ? '0${date.month}' : date.month}/'
        '${date.year}';
  }

  String dateToText1(String date) {
    return date;
  }

  void approveInvoice(int id, int index) {
    showAlert("Approve Invoice", id, index);
  }

  void declineInvoice(int id, int index) {
    showAlert("Decline Invoice", id, index);
  }

  void showAlert(String title, int id, int index) {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: title == "Decline Invoice"
            ? TextFormField(
                controller: commentController,
                //obscureText: true,
                restorationId: 'comment_field',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Comment",
                ),
                maxLines: 5,
              )
            : Text("Are you sure you want to approve?"),
        actions: <Widget>[
          TextButton(
            onPressed: () async => {
              if (title == "Decline Invoice")
                {
                  await ApprovalService()
                      .declineInvoice(id, commentController.text),
                }
              else
                {
                  await ApprovalService()
                      .approveInvoice(id, commentController.text),
                },
              setState(() {
                approvals[index].hasApproved = true;
              }),
              Navigator.pop(context, 'Submit')
            },
            child: title == "Decline Invoice"
                ? const Text('Submit')
                : const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Close'),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
// INA18672
