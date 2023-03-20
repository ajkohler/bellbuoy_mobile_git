import 'package:bellbuoy_mobile/dtos/document_dto.dart';
import 'package:bellbuoy_mobile/services/document_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      DocumentService().openDocument(documents[index].path),
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

  Future<void> openDocument(String path) async {
    DocumentService().updateDocuments().then((value) => {
          setState(() {
            documents = value;
          })
        });
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
