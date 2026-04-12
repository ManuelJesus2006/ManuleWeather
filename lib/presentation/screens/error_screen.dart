import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LogoApp.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Icon(
                  LucideIcons.alertCircle,
                  color: Colors.red,
                  size: 60,
                ),
              ),
              SizedBox(height: 20),
              Text(
                Utils.stringError(configProvider.idiomaActual),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                configProvider.idiomaActual == 'es'
                    ? 'Comprueba tu conexión a internet e inténtalo de nuevo'
                    : 'Check your internet connection and try again',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                //TODO: Lógica botón pantalla error
                onPressed: (){} /* => context.go('/') */,
                icon: Icon(LucideIcons.refreshCw),
                label: Text(
                  configProvider.idiomaActual == 'es' ? 'Reintentar' : 'Retry',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}