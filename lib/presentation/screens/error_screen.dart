import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Utils.stringError(configProvider.idiomaActual),
              style: TextStyle(
                fontSize: 25,
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
                      'assets/images/LogoApp.png',
                      width: 120,
                      height: 120,
                    ),
          ],
        ),
      ),
    );
  }
}