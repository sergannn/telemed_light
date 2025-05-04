import 'package:flutter/material.dart';
import 'package:flutter_application_training/screens/doctors_list_screen.dart';
//import '../second_screen.dart';
import '../utils/auth.dart';

Widget emailField({required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    onChanged: (value) {
      //print(controller.text);
    },
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Enter your email',
    ),
  );
}

Widget passField({required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Enter your pass',
    ),
  );
}

Widget regButton(loader, email, pass, scaffoldMess, context) {
  return ElevatedButton(
    onPressed: () async {
      loader.show();
      var res = await Auth().register(email.text, pass.text);

      scaffoldMess.showSnackBar(
        SnackBar(
          backgroundColor: res == 'ok' ? Colors.green : Colors.red,
          content: Text(res),
        ),
      );
      loader.hide();
      if (res == 'ok') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorsListScreen()),
        );
      }
    },
    child: Text("зарегистрироваться"),
  );
}

Widget loginButton(loader, email, pass, scaffoldMess, context) {
  return ElevatedButton(
    onPressed: () async {
      loader.show();
      var res = await Auth().login(email.text, pass.text);

      scaffoldMess.showSnackBar(
        SnackBar(
          backgroundColor: res == 'ok' ? Colors.green : Colors.red,
          content: Text(res),
        ),
      );
      loader.hide();
      if (res == 'ok') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorsListScreen()),
        );
      }
    },
    child: Text("войти"),
  );
}
