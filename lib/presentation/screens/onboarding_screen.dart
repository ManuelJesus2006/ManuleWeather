import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

//TODO: Traducir
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.stringWelcome(configProvider.idiomaActual)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(
                Utils.stringChooseLanguageText(configProvider.idiomaActual),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: configProvider.idiomasActuales.length,
                  itemBuilder: (context, index) {
                    String idiomaActualBucle = configProvider.idiomasActuales[index];
                    return GestureDetector(
                      onTap: () {
                        configProvider.cambiarIdioma(idiomaActualBucle);
                        configProvider.validarPrimeraVez();
                        context.pop();
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.lime[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            Utils.obtenerIdiomaText(
                              idiomaActualBucle,
                            ),
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                          ),
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 8,); },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
