import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:to_do/Screens/auth/components/BodyRegister.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Body(),
    );
  }
}


