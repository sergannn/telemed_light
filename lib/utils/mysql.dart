import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

import 'package:http/http.dart' as http;

class DatabaseHelper {
  static Future<List<dynamic>> fetchMessages(String from, String to) async {
    final url = Uri.parse(
      'http://legendavolley.ru/telmedlight/select.php?from=$from&to=$to',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<List<dynamic>> fetchUps(String from, String to) async {
    final url = Uri.parse(
      'http://legendavolley.ru/telmedlight/selectup.php?from=$from&to=$to',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<List> selectData(String from, String to) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '79.174.88.242',
        port: 16206,
        user: 'sergannn',
        password: 'Leeendows87!',
        db: 'sergannn',
      ),
    );

    try {
      var query =
          'SELECT * FROM chat_messages WHERE ( _from = "$from" AND _to = "$to" ) OR ( _from = "$to" AND _to = "$from" )';
      // var query = 'SELECT * FROM chat_messages';

      if (kDebugMode) {
        print(query);
      }

      var results = await conn.query(query);
      for (var row in results) {
        print('Name: ${row[0]}, email: ${row[1]}');
      }
      inspect(results);
      print(results.toList());

      return results.toList();
    } catch (e) {
      print('Error: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  static Future<bool> insertUpData(
    String message,
    String from,
    String to,
  ) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '79.174.88.242',
        port: 16206,
        user: 'sergannn',
        password: 'Leeendows87!',
        db: 'sergannn',
      ),
    );
    try {
      var query =
          'INSERT INTO chat_appointments_clone (name, _from, _to, _text) VALUES ("a","$from","$to","$message" )';
      if (kDebugMode) {
        print(query);
      }
      await conn.query(query);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> insertData(String message, String from, String to) async {
    print("inserting");
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '79.174.88.242',
        port: 16206,
        user: 'sergannn',
        password: 'Leeendows87!',
        db: 'sergannn',
      ),
    );
    print("connected");
    try {
      var query =
          'INSERT INTO chat_messages (name, _from, _to, _text) VALUES ("a","$from","$to","$message" )';
      print(query);
      if (kDebugMode) {
        print(query);
      }
      await conn.query(query);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return false;
    } finally {
      await conn.close();
    }
  }
}
