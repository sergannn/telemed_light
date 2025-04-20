import 'dart:convert';
import 'dart:math';

import '/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:flutter_application_training/services/graphql_setup.dart';
import 'package:http/http.dart' as http;

Future<bool> authUser(
    BuildContext context, String username, String password) async {
  // try {

  // String loginString = '''
  //       mutation LoginUser {

  //         login(input: {username: "$username", password: "$password"}) {

  String loginString = '''

            mutation {
                loginwithuserresult(input: {
                    email: "$username"
                    password: "$password"
                }) {
                    token
                    user {
                        user_id: id
                        username: full_name
                        email
                        first_name
                        last_name
                        photo: profile_image
                        patient_id
                        doctor_id
                    }

                }
            }
            
      ''';
  const String kApiDomain = 'https://onlinedoctor.su';
  MyAppAuthLib graphqlAPI = MyAppAuthLib(kApiDomain);
  print(loginString);
  final MutationOptions options = MutationOptions(
    document: gql(loginString),
  );
  GraphQLClient graphqlClient = await graphqlAPI.noauthClient();

  final QueryResult result = await graphqlClient.mutate(options);

  print("\nResponse Details:");
  print("Status: ${result.hasException ? "Error" : "Success"}");
  print("Data: ${jsonEncode(result.data)}");
//  print("Errors: ${result.ex .errors?.map((e) => jsonEncode(e)).toList() ?? []}");

  if (result.hasException) {
    print(result.exception.toString());
    //УДАЛЕНИЕ ТУТ И ТАМ и проверить что всякое такое как популярные категории удалилось
    final errorMessages = {
      'incorrect_password': 'Неверный пароль.',
      'invalid_email': 'Неверный email.',
      'Internal server error': 'Ошибка сети или сервера.',
    };
    print(result.exception.toString());

    return false;
  }

  Map<String, dynamic> json = result.data!["loginwithuserresult"];
  print(json);

  return true;
}
