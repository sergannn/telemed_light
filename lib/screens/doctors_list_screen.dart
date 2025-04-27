// screens/doctors_list_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final List<Map<String, dynamic>> doctors = [
    {'id': 1, 'name': 'Иванова Мария Петровна', 'specialty': 'Терапевт', 'rating': 4.8, 'photo': 'assets/images/doctor_placeholder.png', 'description': 'Врач высшей категории, опыт работы более 15 лет'},
    {
      'id': 2,
      'name': 'Петров Сергей Викторович',
      'specialty': 'Хирург',
      'rating': 4.9,
      'photo': 'assets/images/doctor_placeholder.png',
      'description': 'Доктор медицинских наук, специалист по малоинвазивной хирургии'
    },
    {
      'id': 3,
      'name': 'Сидорова Анна Михайловна',
      'specialty': 'Педиатр',
      'rating': 4.7,
      'photo': 'assets/images/doctor_placeholder.png',
      'description': 'Ведущий педиатр клиники, специалист по детским инфекциям'
    },
    {
      'id': 4,
      'name': 'Козлова Елена Алексеевна',
      'specialty': 'Кардиолог',
      'rating': 4.6,
      'photo': 'assets/images/doctor_placeholder.png',
      'description': 'Специалист по лечению сердечно-сосудистых заболеваний'
    },
    {
      'id': 5,
      'name': 'Николаев Дмитрий Иванович',
      'specialty': 'Невролог',
      'rating': 4.5,
      'photo': 'assets/images/doctor_placeholder.png',
      'description': 'Врач высшей категории, специалист по лечению неврологических заболеваний'
    },
    {'id': 6, 'name': 'Михайлова Наталья Сергеевна', 'specialty': 'Гинеколог', 'rating': 4.9, 'photo': 'assets/images/doctor_placeholder.png', 'description': 'Ведущий специалист по репродуктивному здоровью'},
    {
      'id': 7,
      'name': 'Смирнов Александр Петрович',
      'specialty': 'Ортопед',
      'rating': 4.7,
      'photo': 'assets/images/doctor_placeholder.png',
      'description': 'Специалист по лечению опорно-двигательного аппарата'
    },
    {'id': 8, 'name': 'Васильева Ольга Николаевна', 'specialty': 'Дерматолог', 'rating': 4.8, 'photo': 'assets/images/doctor_placeholder.png', 'description': 'Специалист по лечению кожных заболеваний'}
  ];

  var storage;

  @override
  void initState() {
    // TODO: implement initState

    storage = FlutterSecureStorage();
    super.initState();
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
          'Выберите врача',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 103, 158),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white, // Добавлен фоновый цвет
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await storage.write(key: 'recipient_id', value: doctor['id'].toString());
                      // convert doctor data to string
                      String doctorData = json.encode(doctor);

                      await storage.write(key: 'doctor_data', value: doctorData);
                      // get current role
                      String role = await storage.read(key: 'role') ?? '';
                      // if role is patient, go to patient detail screen
                      if (role == 'patient') {
                        Navigator.pushNamed(
                          context,
                          '/doctor-detail',
                        );
                      }
                      // if role is doctor, go to doctor chat screen
                      if (role == 'doctor') {
                        Navigator.pushNamed(
                          context,
                          '/chat_screen',
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Text(
                                "..."), /*Image.asset(
                              doctor['photo'],
                              width: size.width * 0.2,
                              height: size.width * 0.2,
                              fit: BoxFit.cover,
                            ),*/
                          ),
                          SizedBox(width: size.width * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  doctor['specialty'],
                                  style: TextStyle(
                                    fontSize: size.width * 0.035,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: size.width * 0.05,
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Text(
                                      '${doctor['rating']} / 5',
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
