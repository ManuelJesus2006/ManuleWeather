import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class WeatherHourDetail extends StatelessWidget {
  const WeatherHourDetail({super.key, required this.indexTiempoHoras});

  final int indexTiempoHoras;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final tiempoHoras = weatherProvider.tiempoHoras;
    final fechaFormatted = DateTime.parse(tiempoHoras!.time[indexTiempoHoras]);
    bool isHoraDeDia =
        fechaFormatted.hour > weatherProvider.sunrise.hour &&
        fechaFormatted.hour < weatherProvider.sunset.hour;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${fechaFormatted.day} ${Utils.stringOf(configProvider.idiomaActual)} ${Utils.obtenerMes(fechaFormatted.month, configProvider.idiomaActual)} ${Utils.stringOf(configProvider.idiomaActual)} ${fechaFormatted.year} ${Utils.stringAt(configProvider.idiomaActual)} ${Utils.formatearHora(fechaFormatted)}',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Utils.obtenerSimbolo(
                    tiempoHoras.weatherCode[indexTiempoHoras],
                    false,
                    isHoraDeDia,
                  ),
                  size: mediaQuery.size.width * 0.15,
                ),
                SizedBox(width: 5),
                Text(
                  '${tiempoHoras.temperature2M[indexTiempoHoras].round().toString()}ºC',
                  style: TextStyle(fontSize: mediaQuery.size.width * 0.07),
                ),
              ],
            ),
            Text(Utils.obtenerTiempoText(tiempoHoras.weatherCode[indexTiempoHoras], configProvider.idiomaActual), style: TextStyle(fontSize: mediaQuery.size.width * 0.05),),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Utils.obtenerColorUV(
                      tiempoHoras.uvIndex[indexTiempoHoras].round(),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Utils.stringUVRays(configProvider.idiomaActual),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mediaQuery.size.width * 0.045,
                        ),
                      ),
                      Text(
                        tiempoHoras.uvIndex[indexTiempoHoras]
                            .round()
                            .toString(),
                        style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Utils.stringUvLevel(
                          tiempoHoras.uvIndex[indexTiempoHoras].round(),
                          configProvider.idiomaActual,
                        ),
                        style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: Column(
                    children: [
                      Text(
                        Utils.stringNubosity(configProvider.idiomaActual),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: mediaQuery.size.width * 0.045,
                        ),
                      ),
                      Text(
                        '${tiempoHoras.cloudCover[indexTiempoHoras]
                            .round()
                            .toString()}%',
                        style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            Utils.stringWind(configProvider.idiomaActual),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.size.width * 0.045,
                            ),
                          ),
                          Text(
                            '${tiempoHoras.windSpeed10M[indexTiempoHoras]
                                .round()
                                .toString()}km/h',
                            style: TextStyle(
                              fontSize: mediaQuery.size.width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Column(
                        children: [
                          Text(
                            Utils.stringRainProbability(configProvider.idiomaActual),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.size.width * 0.045,
                            ),
                          ),
                          Text(
                            '${tiempoHoras.precipitationProbability[indexTiempoHoras]}%',
                            style: TextStyle(
                              fontSize: mediaQuery.size.width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
