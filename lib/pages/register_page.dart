import 'package:flutter/material.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(width: size.width*2),
          SizedBox(height: size.height*0.1,),
          Text("Register" ,style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)

        ],
      ),
    );
  }
}