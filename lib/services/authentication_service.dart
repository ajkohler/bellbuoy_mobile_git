import 'dart:convert';
import 'dart:io';

import 'package:bellbuoy_mobile/dtos/authentication_dto.dart';
import 'package:bellbuoy_mobile/dtos/user_dto.dart';
import 'package:bellbuoy_mobile/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

import '../classes/global.dart';
import '../helpers/enums/authentication_results.dart';

// Please send us a message below. Your Bellbuoy portfolio manager will respond as soon as possible.
class AuthenticationService {
  Future<AuthResults> authenticateUser(AuthenticationDto dto) async {
    var url = Uri.parse(Global.tokenEndpoint);
    var userDetailsUrl = Uri.parse(Global.getUserDetailsByTokenEndpoint);
    var schemeDetailsUrl = Uri.parse(Global.getSchemeDetailsEndPoint);
    try {
      var response = await http.post(url, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      }, body: <String, String>{
        'grant_type': 'password',
        'username': dto.username,
        'password': dto.password
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> user = jsonDecode(response.body);
        var userDetailsResponse = await http.get(userDetailsUrl,
            headers: <String, String>{
              'Authorization': 'Bearer ${user['access_token']}'
            });
        if (userDetailsResponse.statusCode == 200) {
          Map<dynamic, dynamic> userDetails =
              jsonDecode(userDetailsResponse.body);
          var schemeDetailsResponse = await http.get(
            Uri.parse('$schemeDetailsUrl/${userDetails['SchemeId']}'),
          );
          if (schemeDetailsResponse.statusCode == 200) {
            Map<dynamic, dynamic> schemeDetails =
                jsonDecode(schemeDetailsResponse.body);
            UserDto userDto = UserDto(
                userDetails["Id"].toString(),
                user['access_token'],
                userDetails['Firstname'],
                userDetails['Surname'],
                userDetails['Email'],
                userDetails['Username'],
                1,
                userDetails['SchemeId'],
                schemeDetails['_etblBranch_idBranch'],
                schemeDetails['Name']);
            await LocalStorageService().insertUser(userDto);
            return AuthResults.SUCCESS;
          } else {
            return AuthResults.FAIL;
          }
        } else {
          return AuthResults.FAIL;
        }
      } else if (response.statusCode == 400) {
        return AuthResults.INVALID;
      } else {
        return AuthResults.FAIL;
      }
    } on SocketException catch (_) {
      return AuthResults.INTERNETCONNECTION;
    } catch (_) {
      return AuthResults.FAIL;
    }
  }

  void logoutUser() {
    LocalStorageService().deleteUser();
    LocalStorageService().deleteDocuments();
    LocalStorageService().deleteSchemeMembers();
  }

  Future<bool> isUserLoggedIn() async {
    return await LocalStorageService().userExists();
  }
}
