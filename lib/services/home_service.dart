import 'dart:convert';
import 'dart:developer';

import 'package:bellbuoy_mobile/dtos/scheme_member_dto.dart';
import 'package:bellbuoy_mobile/dtos/token_dto.dart';
import 'package:http/http.dart' as http;

import '../classes/global.dart';
import '../dtos/authentication_dto.dart';
import '../dtos/portfolio_manager_dto.dart';
import 'local_storage_service.dart';

class HomeService {
  Future<List<SchemeMemberDto>> getHomeData() async {
    List<SchemeMemberDto> list = [];
    List<String> nameList = [];
    var members = await LocalStorageService().getGoverningBodyMembers();

    for (var item in members) {
      SchemeMemberDto member = SchemeMemberDto.fromMap(item);

      if (!nameList.contains(member.name)) {
        nameList.add(member.name);
        list.add(member);
      }
    }

    print(list);
    return list;
  }

  Future<void> updateHomeData() async {
    var branchId = await LocalStorageService().getBranchId();
    await updateSchemeMembers(branchId);
    await updatePortfolioManagers(branchId);
  }

  Future<List<PortfolioManagerDto>> getPortfolioManagers() async {
    List<PortfolioManagerDto> list = [];
    List<String> nameList = [];
    var managers = await LocalStorageService().getPortfolioManagers();
    for (var item in managers) {
      PortfolioManagerDto manager = PortfolioManagerDto.fromMap(item);
      if (!nameList.contains(manager.name)) {
        nameList.add(manager.name);
        list.add(manager);
      }
    }
    return list;
  }

  updateSchemeMembers(int branchId) async {
    var getLeadMembersUrl = Uri.parse(Global.getLeadMembersEndpoint);
    var membersResponse =
        await http.get(Uri.parse('$getLeadMembersUrl?schemeId=$branchId'));

    if (membersResponse.statusCode == 200) {
      List dto = json.decode(membersResponse.body);
      if (dto.isNotEmpty) {
        await LocalStorageService().deleteSchemeMembers();
        var list = await LocalStorageService().getGoverningBodyMembers();
        for (var element in dto) {
          SchemeMemberDto memberDto =
              SchemeMemberDto(element['name'], element['title']);
          if (!list.contains(memberDto)) {
            await LocalStorageService().insertSchemeMember(memberDto);
            log("Wright${memberDto.name}");
          }
        }
      }
    }
  }

  updatePortfolioManagers(int branchId) async {
    var getPortfolioManagersUrl =
        Uri.parse(Global.getPortfolioManagersEndpoint);
    var getManagerDescriptionUrl = Uri.parse(Global.getManagerDescriptionUrl);

    var managersResponse = await http
        .get(Uri.parse('$getPortfolioManagersUrl?branchId=$branchId'));

    if (managersResponse.statusCode == 200) {
      List dto = json.decode(managersResponse.body);
      if (dto.isNotEmpty) {
        String description = "";
        await LocalStorageService().deletePortfolioManagers();
        for (var element in dto) {
          var descriptionResponse = await http.get(
              Uri.parse('$getManagerDescriptionUrl?email=${element['Email']}'));
          if (descriptionResponse.statusCode == 200) {
            description = descriptionResponse.body.replaceAll('"', '');
          }
          PortfolioManagerDto managerDto = PortfolioManagerDto(
              element['Title'],
              element['FirstName'],
              element['Email'],
              element['TelHome'],
              description);
          if (!dto.contains(managerDto)) {
            await LocalStorageService().insertPortfolioManager(managerDto);
          }
        }
      }
    }
  }

  saveToken(TokenDto dto) async {
    String url = Global.saveNotificationToken;

    var response = await http.post(Uri.parse(url),
        // headers: <String, String>{
        //   'Content-Type': 'application/json',
        // },
        body: dto.toJson());

    print("====");
    print(response.statusCode);
    print("====");
  }
}
