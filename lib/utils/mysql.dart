import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  //ф
  static Future<List> selectData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '79.174.88.242',
        port: 16206,
        user: 'sergannn',
        password: 'Leeendows87!',
        db: 'sergannn'));

    try {
      print('SELECT * FROM chat_messages');
      var results = await conn.query('SELECT * FROM chat_messages');
      print(results.length);
      for (var row in results) {
        print('Name: ${row[0]}, email: ${row[1]}');
      }

      print(results.toList());
      await conn.close();
      return results.toList();
      //return results;
    } catch (e) {
      print('Error: $e');
      await conn.close();
      return [];
    }
  }

  static Future<bool> insertData(String name, String email) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '79.174.88.242',
        port: 16206,
        user: 'sergannn',
        password: 'Leeendows87!',
        db: 'sergannn'));

    try {
      print(
          '  INSERT INTO chat_messages (name, _from,_to,_text) VALUES ("a","b","c","d" )');
      await conn.query(
          ' INSERT INTO chat_messages (name, _from,_to,_text) VALUES ("a","b","c","d" )');
      await conn.close();
      return true;
    } catch (e) {
      print('Error: $e');
      await conn.close();
      return false;
    }
  }
}
