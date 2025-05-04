import 'package:flutter/material.dart';
import 'package:flutter_application_training/screens/doctors_list_screen.dart';
//import '../second_screen.dart';
import '../utils/auth.dart';

Widget emailField({required TextEditingController controller}) {
  return TextFormField(
    //initialValue: controller.text,
    controller: controller,
    onChanged: (value) {
      //print(controller.text);
    },
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Введите почту',
    ),
  );
}

Widget catField({required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Введите специализацию',
    ),
  );
}

Widget ageField({required TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Введите дату рождения',
    ),
  );
}

Widget passField({required TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Введите пароль',
    ),
  );
}

Widget regButton(
  loader,
  email,
  pass,
  scaffoldMess,
  context,
  isDoctor,
  catCont,
  ageCont,
) {
  return ElevatedButton(
    onPressed: () async {
      loader.show();
      var res = await Auth().register(
        email.text,
        pass.text,
        isDoctor,
        catCont.text,
        ageCont.text,
      );

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
