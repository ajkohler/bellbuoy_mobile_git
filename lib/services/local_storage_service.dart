import 'package:bellbuoy_mobile/dtos/document_dto.dart';
import 'package:bellbuoy_mobile/dtos/notification_dto.dart';
import 'package:bellbuoy_mobile/dtos/portfolio_manager_dto.dart';
import 'package:bellbuoy_mobile/dtos/scheme_member_dto.dart';
import 'package:bellbuoy_mobile/dtos/user_dto.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../dtos/approval_dto.dart';

class LocalStorageService {
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'main_database.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, token TEXT, firstName TEXT, '
            'surname TEXT, email TEXT, username TEXT, userId TEXT, '
            'schemeId INTEGER, branchId INTEGER, schemeName TEXT); ');
        await db.execute(
            'CREATE TABLE documents(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, title TEXT, path TEXT);');
        await db.execute(
            'CREATE TABLE scheme_members(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, title TEXT);');
        await db.execute(
            'CREATE TABLE notifications(id INTEGER PRIMARY KEY, message TEXT, date TEXT);');
        await db.execute(
            'CREATE TABLE approvals(id INTEGER PRIMARY KEY, invoiceId int, createDate TEXT, '
            'invoiceNumber TEXT, amount TEXT, status TEXT, statusId int, hasApproved bool, '
            'approvers int, totalApprovers int, documentId int);');
        await db.execute(
            'CREATE TABLE portfolio_managers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, title TEXT, email TEXT, tel TEXT, description TEXT);');
      },
      version: 3,
    );
  }

  Future<void> insertUser(UserDto user) async {
    final db = await database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> username() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['username'];
  }

  Future<String> schemeName() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['schemeName'];
  }

  Future<String> userId() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['userId'];
  }

  Future<bool> userExists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('users');
  }

  Future<String> firstname() async {
    final db = await database;
    var username = await LocalStorageService().username();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['firstName'];
  }

  Future<String> surname() async {
    final db = await database;
    var username = await LocalStorageService().username();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['surname'];
  }

  Future<String> emailAddress() async {
    final db = await database;
    var username = await LocalStorageService().username();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['email'];
  }

  Future<String> authToken() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['token'];
  }

  Future<int> schemeId() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['schemeId'];
  }

  Future<void> insertDocument(DocumentDto document) async {
    final db = await database;
    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('documents');
    return maps;
  }

  Future<void> deleteDocuments() async {
    final db = await database;
    await db.delete('documents');
  }

  Future<List<Map<String, dynamic>>> getApprovals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('approvals');
    return maps;
  }

  Future<int> getBranchId() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps[0]['branchId'];
  }

  Future<Map<String, dynamic>> getChairperson() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("scheme_members",
        where: "title = ?", whereArgs: ['Chairperson']);
    return maps[0];
  }

  Future<void> insertSchemeMember(SchemeMemberDto member) async {
    final db = await database;
    await db.insert(
      'scheme_members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getGoverningBodyMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("scheme_members");
    return maps;
  }

  Future<void> deleteSchemeMembers() async {
    final db = await database;
    await db.delete('scheme_members');
  }

  Future<void> insertPortfolioManager(PortfolioManagerDto manager) async {
    final db = await database;
    await db.insert(
      'portfolio_managers',
      manager.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePortfolioManagers() async {
    final db = await database;
    await db.delete('portfolio_managers');
  }

  Future<List<Map<String, dynamic>>> getPortfolioManagers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('portfolio_managers');
    return maps;
  }

  Future<void> insertNotification(NotificationDto notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertApproval(ApprovalDto item) async {
    final db = await database;
    await db.insert(
      'approvals',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNotification() async {
    final db = await database;
    await db.delete('notifications');
  }

  // Future<void> updateNotificationStatus() async {
  //   final db = await database;
  //   await db.delete('notifications');
  // }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notifications');
    return maps;
  }

  Future<Map<String, dynamic>> getPMDetails() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query("portfolio_managers", where: "title = ?", whereArgs: ['PM']);
    return maps[0];
  }

  Future<void> deleteApprovals() async {
    final db = await database;
    //await db.execute('DROP TABLE approvals');
    await db.delete('approvals');
  }

  Future<Map<String, dynamic>> getApproval(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query("approvals", where: "invoiceId = ?", whereArgs: [id]);
    return maps[0];
  }

  Future<Map<String, dynamic>> updateApprovalAction(int id) async {
    Map<String, dynamic> element = await getApproval(id);
    final newElement = {...element, 'hasApproved': 1};
    final db = await database;
    await db.update('approvals', newElement,
        where: "invoiceId = ?", whereArgs: [id]);
    return await getApproval(id);
  }
}
