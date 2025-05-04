import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Auth {
  Future<String> login(email, pass) async {
    print(email);
    print(pass);

    final supabase = Supabase.instance.client;
    try {
      var res = await supabase.auth.signInWithPassword(
        email: email,
        password: pass,
      );
      var storage = FlutterSecureStorage();

      //      await storage.write(key: 'recipient_id', value: user['id'].toString());
      final User? user = res.user;
      print(user?.userMetadata);
      user?.userMetadata?.forEach((key, value) {
        print(key);
        print(value);
        print("<<<");
        storage.write(key: key, value: value.toString());
      });
      return 'ok';
    } on AuthException catch (error) {
      return error.message;
    }
    //  print(res);
    //AuthResponse
    // await fetch();
  }

  Future<String> register(email, pass, isDoctor, cat, age) async {
    print(email);
    print(pass);

    final supabase = Supabase.instance.client;
    try {
      var res = await supabase.auth.signUp(
        email: email,
        password: pass,
        data: {'cat': cat, 'age': age, 'doctor': isDoctor},
      );
      return 'ok';
    } on AuthException catch (error) {
      return error.message;
    }
    //  print(res);
    //AuthResponse
    // await fetch();
  }

  Future<void> fetch() async {
    final supabase = Supabase.instance.client;
    //    final data = await supabase.from('users').select();
    final List<User> users = await supabase.auth.admin.listUsers();
    print(users);
    print("useres");
  }
}
