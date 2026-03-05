import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future signUpUser() async{
    if(passwordController.text == confirmPasswordController.text){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());

    }
    else{
      print("Password do not match");
    }

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(width: size.width*2),
          SizedBox(height: size.height*0.1,),
          Text("Register" ,style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
          SizedBox(height:size.height*0.01),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
              
            ),
          ),
          SizedBox(height: size.height*0.01,),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                hintText: "conrifom password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(onPressed: signUpUser, child: Text("Register")),

        ],
      ),
    );
  }
}