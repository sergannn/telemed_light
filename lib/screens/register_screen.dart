// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_training/widgets/auth.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isDoctor = false;
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController catCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var loader = context.loaderOverlay;
    var scaffoldMessanger = ScaffoldMessenger.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("назад"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Регистрация',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),
                    emailField(controller: emailCont),
                    /*  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Имя',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите имя';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: size.height * 0.03),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: size.height * 0.03),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Телефон',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите телефон';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: size.height * 0.03),

                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Пароль',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Пароль должен быть не менее 6 символов';
                        }
                        return null;
                      },
                    ),
*/
                    passField(controller: passCont),
                    isDoctor ? catField(controller: catCont) : Container(),
                    ageField(controller: ageCont),
                    //SelectableText("aaa"),
                    Row(
                      children: [
                        Text("Врач?"),
                        Checkbox(
                          value: isDoctor,
                          onChanged: (bool? value) {
                            setState(() {
                              isDoctor = value ?? false;
                            });
                            print(value);
                          },
                        ),
                      ],
                    ),
                    regButton(
                      loader,
                      emailCont,
                      passCont,
                      scaffoldMessanger,
                      context,
                      isDoctor,
                      catCont,
                      ageCont,
                    ) /*
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(context, '/doctors');
                        }
                      },
                      child: const Text('Зарегистрироваться'),
                    ),*/,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
