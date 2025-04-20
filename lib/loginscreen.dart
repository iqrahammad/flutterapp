import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lastpractice/Homescreen.dart';
import 'package:lastpractice/signup.dart';
import 'package:flutter/material.dart';

Future<void> Signin( String Email , String Password , BuildContext context) async{
  try{
    UserCredential userCredential = await FirebaseAuth.instance.
  signInWithEmailAndPassword(email: Email, password: Password);
    String uid = userCredential.user!.uid;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(userId: uid)));
  }
  catch(e){
    log('Failed $e');
  }
}
class Loginscreen extends StatelessWidget {
   Loginscreen({Key? key}) : super(key: key);
TextEditingController emailcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffB81736),
                  Color(0xff281537),
                ]),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Hello\nSign in!',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child:  Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       TextField(
                        controller: emailcontroller ,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.check,color: Colors.grey,),
                            label: Text('Gmail',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color(0xffB81736),
                            ),)
                        ),
                      ),
                       TextField(
                         controller: passwordcontroller,
                        decoration: InputDecoration(

                            suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                            label: Text('Password',style: TextStyle(


                              fontWeight: FontWeight.bold,
                              color:Color(0xffB81736),
                            ),)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password?',style: TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),),
                      ),
                      const SizedBox(height: 70,),
                      GestureDetector(
                        onTap: () {
                          Signin(emailcontroller.text,passwordcontroller.text,context);
                          emailcontroller.clear();
                          passwordcontroller.clear();

                        },
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xffB81736),
                                  Color(0xff281537),
                                ]
                            ),
                          ),
                          child: const Center(child: Text('SIGN IN',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                          ),),),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Don't have account?",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                                },
                                child: Text("Sign up",style: TextStyle(

                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black
                                ),),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
}