import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lastpractice/Homescreen.dart';
import 'package:lastpractice/biopage.dart';
import 'package:lastpractice/loginscreen.dart';

Future<void> SignupUser(String name, String email, String password, String country, String role, BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'country': country,
      'email': email,
      'role': role,
    });

    log("✅ User signed up: Name: $name, Role: $role, Email: $email");

    if (role == 'huffadh' || role == 'masjid') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BioFormPage(userRole: role, userId: uid)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: uid)),
      );
    }
  } catch (e) {
    log("❌ Signup Failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Failed: ${e.toString()}")));
  }
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otherCountryController = TextEditingController();

  String selectedRole = 'user';
  String selectedCountry = 'Pakistan';

  final List<String> roles = ['user', 'huffadh', 'masjid'];

  final List<String> countries = [
    'Pakistan',
    'India',
    'Bangladesh',
    'Saudi Arabia',
    'United Arab Emirates',
    'Malaysia',
    'United Kingdom',
    'United States',
    'Indonesia',
    'Turkey',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xffB81736), Color(0xff281537)]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Welcome\nSign up!',
                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Foreground Form
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildTextField(nameController, 'Name', Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(emailController, 'Email', Icons.email),
                      const SizedBox(height: 15),
                      _buildTextField(passwordController, 'Password', Icons.lock, obscure: true),
                      const SizedBox(height: 15),

                      // Country Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'Select Country',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value!;
                          });
                        },
                      ),

                      // Show text field if "Others" is selected
                      if (selectedCountry == 'Others')
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextField(
                            controller: otherCountryController,
                            decoration: const InputDecoration(
                              labelText: 'Enter your Country',
                              labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffB81736)),
                              suffixIcon: Icon(Icons.flag, color: Colors.grey),
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      // Role Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Select Role',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                        items: roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role[0].toUpperCase() + role.substring(1)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          String finalCountry = selectedCountry == 'Others'
                              ? otherCountryController.text.trim()
                              : selectedCountry;

                          SignupUser(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text,
                            finalCountry,
                            selectedRole,
                            context,
                          );

                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          otherCountryController.clear();
                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ]),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          const Text("Already have an account?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera, color: Colors.red), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, color: Colors.red), label: ''),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: Colors.grey),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xffB81736)),
        ),
      ),
    );
  }
}
