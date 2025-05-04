import 'package:flutter/material.dart';
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
      return 'ok';
    } on AuthException catch (error) {
      return error.message;
    }
    //  print(res);
    //AuthResponse
    // await fetch();
  }

  Future<String> register(email, pass) async {
    print(email);
    print(pass);

    final supabase = Supabase.instance.client;
    try {
      var res = await supabase.auth.signUp(
        email: email,
        password: pass,
        data: {'cat': 'Стоматолог', 'age': '03.09.1987'},
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
