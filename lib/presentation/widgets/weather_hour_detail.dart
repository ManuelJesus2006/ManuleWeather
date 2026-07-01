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
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    
    final tiempoHoras = weatherProvider.tiempoHoras;
    final fechaFormatted = DateTime.parse(tiempoHoras!.time[indexTiempoHoras]);
    
    bool isHoraDeDia = fechaFormatted.hour > weatherProvider.sunrise.hour &&
        fechaFormatted.hour < weatherProvider.sunset.hour;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Utils.obtenerSimbolo(
                    tiempoHoras.weatherCode[indexTiempoHoras],
                    false,
                    isHoraDeDia,
                  ),
                  size: 70,
                ),
                const SizedBox(width: 5),
                Text(
                  '${tiempoHoras.temperature2M[indexTiempoHoras].round()}ºC',
                  style: const TextStyle(fontSize: 30), // Tu tamaño original
                ),
              ],
            ),
            
            // 2. Descripción original
            const SizedBox(height: 10),
            Text(
              Utils.obtenerTiempoText(
                tiempoHoras.weatherCode[indexTiempoHoras],
                configProvider.idiomaActual,
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
        
            //Rayos UV y Nubosidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Utils.obtenerColorUV(
                        tiempoHoras.uvIndex[indexTiempoHoras].round(),
                      ).withOpacity(0.8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          Utils.stringUVRays(configProvider.idiomaActual),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tiempoHoras.uvIndex[indexTiempoHoras].round().toString(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Utils.stringUvLevel(
                            tiempoHoras.uvIndex[indexTiempoHoras].round(),
                            configProvider.idiomaActual,
                          ),
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey.withOpacity(0.8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          Utils.stringNubosity(configProvider.idiomaActual),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tiempoHoras.cloudCover[indexTiempoHoras].round()}%',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
        
            _infoCard(
              color: Colors.grey.withOpacity(0.8), //viento
              titulo: Utils.stringWind(configProvider.idiomaActual),
              valor: '${tiempoHoras.windSpeed10M[indexTiempoHoras].round()} km/h',
            ),
            const SizedBox(height: 10),
            _infoCard(
              color: Colors.grey.withOpacity(0.5), //viento
              titulo: Utils.stringMaxGust(configProvider.idiomaActual),
              valor: '${tiempoHoras.windGusts10M[indexTiempoHoras].round()} km/h',
            ),
            const SizedBox(height: 10),
            _infoCard(
              color: Colors.lightBlueAccent.withOpacity(0.8), //probabilidad de lluvia
              titulo: Utils.stringRainProbability(configProvider.idiomaActual),
              valor: '${tiempoHoras.precipitationProbability[indexTiempoHoras]}%',
            ),
            const SizedBox(height: 10),
            _infoCard(
              color: Colors.blue.withOpacity(0.6), //cantidad de lluvia
              titulo: Utils.stringAmountOfRainSnow(configProvider.idiomaActual),
              valor: '${tiempoHoras.precipitation[indexTiempoHoras]} l/m²',
            ),
            const SizedBox(height: 10),
            _infoCard(
              color: Colors.blueGrey[300]!.withOpacity(0.9), //humedad
              titulo: Utils.stringHumidity(configProvider.idiomaActual),
              valor: '${tiempoHoras.relativeHumidity2M[indexTiempoHoras]}%',
            ),
          ],
        ),
      ),
    );
  }
  Widget _infoCard({required Color color, required String titulo, required String valor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: color,
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}