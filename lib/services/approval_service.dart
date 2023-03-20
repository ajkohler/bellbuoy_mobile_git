import 'dart:convert';
import 'dart:io';

import 'package:bellbuoy_mobile/services/document_service.dart';
import 'package:bellbuoy_mobile/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../classes/global.dart';
import '../dtos/approval_dto.dart';

class ApprovalService {
  Future<List<ApprovalDto>> getApprovals() async {
    List<ApprovalDto> list = [];

    await LocalStorageService().getApprovals().then((value) => {
          value.forEach((element) {
            ApprovalDto approval = ApprovalDto(
              element['invoiceId'],
              element['createDate'],
              element['invoiceNumber'],
              element['amount'],
              element['status'],
              element['statusId'],
              element['documentId'],
              element['hasApproved'] == 1,
              element['approvers'],
              element['totalApprovers'],
            );
            //var approval = ApprovalDto.fromMap(element);
            list.add(approval);
          })
        });

    return list;
  }

  Future<List<ApprovalDto>> updateApprovals() async {
    int schemeId = await LocalStorageService().schemeId();
    var userId = await LocalStorageService().userId();
    var url = Uri.parse(
        '${Global.adminUri}api/Invoices/GetApprovalsMobileBySchemeId?schemeId=$schemeId&userId=$userId');

    var response = await http.get(url);
    List dto = json.decode(response.body);
    List<ApprovalDto> list = [];
    for (var element in dto) {
      ApprovalDto item = ApprovalDto(
        element["InvoiceId"],
        element['CreateDate'],
        element['InvoiceNumber'],
        element['TotalAmount'],
        element['Status'],
        element['StatusId'],
        element['Document'],
        element['hasApproved'],
        element['Approvers'],
        element['TotalApprovers'],
      );
      list.add(item);
    }
    return list;
  }

  Future<File> downloadFile(String url, String filename) async {
    var req = await http.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    Directory tempDir = await getTemporaryDirectory();

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> openDocument(int id) async {
    var url = Uri.parse('${Global.documentsUri}api/Documents/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dto = json.decode(response.body);
      DocumentService().openDocument("Documents/" + dto["Path"]);
    }
  }

  Future<int> approveInvoice(int id, String comment) async {
    var userId = await LocalStorageService().userId();
    String url =
        "${Global.schemeUri}api/Approvals/PostApprovalMobile?userId=$userId&invoiceId=$id";

    print(url);

    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
    });

    await LocalStorageService()
        .updateApprovalAction(id)
        .then((value) => print(value));
    return 1; //response.statusCode;
  }

  Future<int> declineInvoice(int id, String comment) async {
    var userId = LocalStorageService().userId();
    String url =
        "${Global.schemeUri}api/Approvals/PostDeclinationMobile?userId=$userId&invoiceId=$id&comment=$comment";

    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
    });
    await LocalStorageService()
        .updateApprovalAction(id)
        .then((value) => print(value));
    return 1; //response.statusCode;
  }
}
