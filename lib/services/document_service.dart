import 'dart:convert';
import 'dart:developer';

import 'package:bellbuoy_mobile/dtos/document_dto.dart';
import 'package:bellbuoy_mobile/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../classes/global.dart';
import '../classes/user.dart';

class DocumentService {
  Future<List<DocumentDto>> getDocuments() async {
    List<DocumentDto> list = [];
    await LocalStorageService().getDocuments().then((value) => {
          value.forEach((element) {
            var document = DocumentDto.fromMap(element);
            list.add(document);
          })
        });
    return list;
  }

  Future<List<DocumentDto>> updateDocuments() async {
    int schemeId = await User().schemeId;
    var url = Uri.parse(
        '${Global.documentsUri}api/Documents/GetDocumentsBySchemeId?schemeId=$schemeId');
    var response = await http.get(url);
    List dto = json.decode(response.body);
    List<DocumentDto> list = [];
    LocalStorageService().deleteDocuments();
    for (var element in dto) {
      DocumentDto item = DocumentDto(element['Name'], '', '');
      LocalStorageService().insertDocument(item);
      list.add(item);
      List docs = element['Documents'];
      for (var element in docs) {
        item = DocumentDto('', element['Title'], element['Path']);
        LocalStorageService().insertDocument(item);
        list.add(item);
      }
    }
    return list;
  }

  void openDocument(String path) async {
    var url = Uri.parse('${Global.documentsUri}$path');
    log('${Global.documentsUri}$path');
    if (await canLaunchUrl(url)) {
      log("Launch Document");
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      log("LaunchUrl Failed");
      throw 'Could not launch $url';
    }
  }
}
