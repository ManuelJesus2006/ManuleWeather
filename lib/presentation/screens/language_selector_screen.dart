import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.stringLanguagesSettings(configProvider.idiomaActual)),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.stringChooseLanguageText(configProvider.idiomaActual),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: configProvider.idiomasActuales.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  String idiomaActualBucle = configProvider.idiomasActuales[index];
                  bool isSeleccionado = idiomaActualBucle == configProvider.idiomaActual;

                  return GestureDetector(
                    onTap: () {
                      configProvider.cambiarIdioma(idiomaActualBucle);
                      context.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: isSeleccionado ? Colors.blue[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSeleccionado ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            Utils.getFlagEmoji(idiomaActualBucle),
                            style: TextStyle(fontSize: screenWidth * 0.07),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Text(
                            Utils.obtenerIdiomaText(idiomaActualBucle),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.045,
                              color: isSeleccionado ? Colors.blue[700] : Colors.black87,
                            ),
                          ),
                          Spacer(),
                          if (isSeleccionado)
                            Icon(LucideIcons.check, color: Colors.blue, size: screenWidth * 0.05),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}