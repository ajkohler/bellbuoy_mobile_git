import 'dart:developer';

import 'package:bellbuoy_mobile/dtos/document_dto.dart';
import 'package:bellbuoy_mobile/services/document_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/global.dart';
import 'nav_drawer.dart';

class _documentState extends State<Documents> {
  List<DocumentDto> documents = [];

  @override
  void initState() {
    super.initState();
    getLocalDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      drawer: NavDrawer(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return documents[index].name.isEmpty
                ? ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(
                      documents[index].title,
                    ),
                    onTap: () => {
                      //print(documents[index].path),
                      openDocument(documents[index].path),
                    },
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                : ListTile(
                    title: Text(
                      documents[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
          },
        ),
      ),
    );
  }

//Remove Region Begin
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

  void openDocument(String path) async {
    var url = Uri.parse('${Global.documentsUri}$path');
    log('${Global.documentsUri}$path');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (Exception) {
      _showAlertDialog();
    }
  }

  Future<void> _pullRefresh() async {
    await updateDocs();
  }

  Future<void> getLocalDocs() async {
    DocumentService().getDocuments().then((value) => {
          if (value.isNotEmpty)
            {
              setState(() {
                documents = value;
              })
            }
          else
            {updateDocs()}
        });
  }

  Future<void> updateDocs() async {
    await DocumentService().updateDocuments().then((value) => {
          setState(() {
            documents = value;
          })
        });
  }
}

class Documents extends StatefulWidget {
  const Documents({Key? key}) : super(key: key);

  @override
  State<Documents> createState() => _documentState();
}
