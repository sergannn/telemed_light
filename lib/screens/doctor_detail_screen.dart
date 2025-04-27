// screens/doctor_detail_screen.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_training/main.dart';
import 'package:flutter_application_training/utils/mysql.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen>
    with AwaitLogger {
  late Map<String, dynamic> doctor = {
    'id': 1,
    'name': 'Иванова Мария Петровна',
    'specialty': 'Терапевт',
    'rating': 4.8,
    'photo': 'assets/images/doctor_placeholder2.png',
    'description': 'Врач высшей категории, опыт работы более 15 лет'
  };
  var storage;

  @override
  void initState() {
    // TODO: implement initState

    storage = FlutterSecureStorage();

    getDoctor();

    super.initState();
  }

  Future<dynamic> getDoctor() async {
    storage = FlutterSecureStorage();
    var doctorData = await storage.read(key: 'doctor_data');
    setState(() {
      doctor = json.decode(doctorData!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Иванова Мария Петровна',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 103, 158),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                // Фото врача
                Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Text(
                          'photo') /*Image.asset(
                      doctor['photo'],
                      color: Colors.red,
                      width: double.infinity,
                      height: size.width * 0.6,
                      fit: BoxFit.contain,
                    ),*/
                      ),
                ),

                // Информация о враче
                Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Имя врача
                      Text(
                        doctor['name'],
                        style: TextStyle(
                          fontSize: size.width * 0.050,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 36, 103, 158),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // Специализация
                      Text(
                        doctor['specialty'],
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      // Рейтинг
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: size.width * 0.08,
                          ),
                          SizedBox(width: size.width * 0.03),
                          Text(
                            '${doctor['rating']} / 5',
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.03),

                      // Описание
                      Text(
                        doctor['description'],
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(height: size.height * 0.05),

                      // Кнопка чата
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // save doctor id to storage
                            await storage.write(
                                key: 'recipient_id',
                                value: doctor['id'].toString());
                            Navigator.pushNamed(context, '/chat_screen');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 36, 103, 158),
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                              horizontal: size.width * 0.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
                            'Начать чат',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            var role = await storage.read(key: 'role');
                            print(role);
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2025, 1, 1, 1),
                              lastDate: DateTime(2026, 1, 1),
                            );
                            await DatabaseHelper.insertUpData(
                                pickedDate.toString(),
                                role,
                                doctor['id'].toString());
                            // save doctor id to storage

                            await storage.write(
                                key: 'recipient_id',
                                value: doctor['id'].toString());
                            // Navigator.pushNamed(context, '/chat_screen');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 36, 103, 158),
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                              horizontal: size.width * 0.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
                            'Записаться',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
