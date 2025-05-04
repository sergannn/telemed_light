// screens/doctors_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  List<Map<String, dynamic>> doctors =
      []; // Make it mutable for dynamic updates
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final supabase = SupabaseClient(
        'https://ctoyoovkqoawoeszdjqk.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0b3lvb3ZrcW9hd29lc3pkanFrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTg0MDMwOCwiZXhwIjoyMDYxNDE2MzA4fQ.DaW5JVWmKv-ijFPTC_8RmAaIHbytxbvPe7A01MWum48',
      );

      // Properly await the user list
      final usersResponse = await supabase.auth.admin.listUsers();
      print(usersResponse);
      print("Fetched users: ${usersResponse.length}");
      var storage = FlutterSecureStorage();
      var isDoctor = await storage.read(key: 'doctor');
      //      await storage.write(key: 'recipient_id', value: user['id'].toString());
      // Convert users to your doctor format
      final fetchedDoctors =
          usersResponse
              .where((user) => user.email != null && user.email!.isNotEmpty)
              .where(
                (user) => user.userMetadata?['doctor'].toString() != isDoctor,
              ) // Filter
              .map((user) {
                return {
                  'id': user.id,
                  'name': user.email, // Or use user.userMetadata?['name']
                  'specialty':
                      user.userMetadata?['cat'], // Default or get from user_metadata
                  'isDoctor':
                      user.userMetadata?['doctor'], // Default or get from user_metadata

                  'rating': 4.5, // Default
                  'photo': 'assets/images/doctor_placeholder.png',
                  'description': 'User since ${user.createdAt}',
                  'age': user.userMetadata?['age'],
                };
              })
              .toList();

      setState(() {
        doctors = fetchedDoctors;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching users: $e");
      setState(() => isLoading = false);
      // Fallback to your default doctors if needed
      doctors = [
        {
          'id': 1,
          'name': 'Иванова Мария Петровна',
          // ... keep your default doctors data
        },
        // ... other default doctors
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // ... keep your existing app bar
      ),
      body: SafeArea(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                  color: Colors.white,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(doctor: doctor, size: size);
                      // ... keep your existing item builder
                    },
                  ),
                ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final Size size;

  const DoctorCard({required this.doctor, required this.size, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onTap:
              () => Navigator.pushNamed(
                context,
                '/doctor-detail',
                arguments: doctor,
              ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    doctor['photo'] ?? 'assets/images/doctor_placeholder.png',
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),*/
                SizedBox(width: size.width * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text(doctor['id']),
                      Text(
                        doctor['name'] ?? 'No name',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        doctor['specialty'] ?? 'отсутствует',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        doctor['age'] ?? 'отсутствует',
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: size.width * 0.05,
                          ),
                          SizedBox(width: size.width * 0.03),
                          Text(
                            '${doctor['rating'] ?? 0} / 5',
                            style: TextStyle(fontSize: size.width * 0.035),
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
  }
}
