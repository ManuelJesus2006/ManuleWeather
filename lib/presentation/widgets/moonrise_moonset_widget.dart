import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class MoonRiseMoonSetWidget extends StatelessWidget {
  const MoonRiseMoonSetWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.indexDay,
  });

  final double screenWidth;
  final double screenHeight;
  final int indexDay;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    String? indexMoonrise =
        weatherProvider.tiempoDias!.moonrise[indexDay] != null
        ? Utils.formatearHora(
            DateTime.parse(weatherProvider.tiempoDias!.moonrise[indexDay]!),
          )
        : null;

    String? indexMoonset = weatherProvider.tiempoDias!.moonset[indexDay] != null
        ? Utils.formatearHora(
            DateTime.parse(weatherProvider.tiempoDias!.moonset[indexDay]!),
          )
        : null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: configProvider.isDarkTheme
                    ? Colors.grey[900]
                    : Colors.grey[200],
              ),
              child: Column(
                children: [
                  Text(
                    Utils.stringMoonrise(configProvider.idiomaActual),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: configProvider.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    indexDay == 0
                        ? Utils.formatearHora(weatherProvider.moonrise)
                        : indexMoonrise ??
                              Utils.stringNotAvailable(
                                configProvider.idiomaActual,
                              ),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: configProvider.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: configProvider.isDarkTheme
                    ? Colors.grey[900]
                    : Colors.grey[200],
              ),
              child: Column(
                children: [
                  Text(
                    Utils.stringMoonset(configProvider.idiomaActual),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: configProvider.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    indexDay == 0
                        ? Utils.formatearHora(weatherProvider.moonset)
                        : indexMoonset ??
                              Utils.stringNotAvailable(
                                configProvider.idiomaActual,
                              ),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: configProvider.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
