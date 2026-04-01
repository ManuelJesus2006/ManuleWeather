import 'package:flutter/material.dart';

//TODO: Traducir
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'HA OCURRIDO UN ERROR MAYOR, LAMENTAMOS LAS MOLESTIAS',
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}