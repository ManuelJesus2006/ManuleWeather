import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:manule_weather/models/lluvia_level_model.dart';
import 'package:manule_weather/models/snow_level_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';

class HomeScreenWidgetManager {
  static const String _androidWidgetName = 'ManuleWeatherWidgetProvider';
  static const String _iosWidgetName = 'ManuleWeatherWidget';

  static Future<void> actualizarDatos({
    required String ciudad,
    required String idioma,
    required bool fondoOscuro,
    required Tiempo tiempoActual,
    required List<LluviaLevelModel> rainData,
    required List<SnowLevelModel> snowData,
    required TiempoHoras tiempoHoras,
  }) async {
    try {
      // 1. Renderizamos el Widget de Flutter como una imagen
      // 'widget_imagen' es la clave que recibirá el contenedor nativo
      await HomeWidget.renderFlutterWidget(
        Material(
          color: Colors.transparent,
          child: FutureBuilder(
            // Mantenemos la precarga por si acaso decides volver a usar imágenes en el futuro,
            // pero ahora el contenedor se pinta directamente con tus colores planos.
            future: Future.value(true),
            builder: (context, snapshot) {
              final avisos = Utils.devolverWidgetCardAvisos(idioma, tiempoHoras);
              final hayNieve = tiempoHoras.weatherCode
                  .take(8)
                  .any((code) => Utils.isNevando(code));
              final hayLluvia = tiempoHoras.weatherCode
                  .take(8)
                  .any((code) => Utils.isLloviendo(code));
              return Container(
                width: 500,
                height: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    24,
                  ), // Bordes curvados modernos
                  // 🎨 Volvemos a tu fondo original según el modo oscuro
                  color: fondoOscuro ? Colors.grey[900] : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //LOCALIZACIÓN O HORA
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              // Cambia el color del icono según el fondo para que no se vuelva invisible
                              child: Icon(
                                Icons.navigation,
                                color: fondoOscuro
                                    ? Colors.white
                                    : Colors.black87,
                                size: 24,
                              ),
                            ),
                            Text(
                              ciudad,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: fondoOscuro
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${Utils.stringUpdatedAt(idioma)} ${Utils.formatearHora(DateTime.parse(tiempoActual.current.time))}',
                          style: TextStyle(
                            color: fondoOscuro
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black54,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),

                    // 2. TEMPERATURA E ICONO PRINCIPAL (Parte central)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${tiempoActual.current.temperature2M.round()}ºC',
                          style: TextStyle(
                            fontSize: 84,
                            fontWeight: FontWeight.w600,
                            color: fondoOscuro ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Utils.obtenerSimbolo(
                            tiempoActual.current.weatherCode,
                            false,
                            tiempoActual.current.isDay == 0 ? false : true,
                          ),
                          size: 72,
                          color: fondoOscuro ? Colors.white : Colors.black87,
                        ),
                      ],
                    ),

                    // 3. ESTADO DEL TIEMPO Y SENSACIÓN TÉRMICA (Parte inferior)
                    Column(
                      children: [
                        Text(
                          hayNieve
                              ? Utils.mensajeSnowDinamico(snowData, idioma)
                              : hayLluvia
                              ? Utils.mensajeLluviaDinamico(rainData, idioma)
                              : '',
                          style: TextStyle(
                            fontSize: 26,
                            color: fondoOscuro ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          Utils.obtenerTiempoText(
                            tiempoActual.current.weatherCode,
                            idioma,
                          ).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: fondoOscuro ? Colors.white : Colors.black87,
                            fontSize: 35,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${Utils.stringFeelsLike(idioma)}: ',
                              style: TextStyle(
                                color: fondoOscuro
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black54,
                                fontSize: 27,
                              ),
                            ),
                            Text(
                              '${tiempoActual.current.apparentTemperature.round()}ºC',
                              style: TextStyle(
                                color: fondoOscuro
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Separación extra antes de los avisos
                    if (avisos.isNotEmpty)
                    Wrap(
                      spacing: 8.0, // Espacio horizontal entre las tarjetas
                      runSpacing:
                          8.0, // Espacio vertical cuando salta a la línea de abajo
                      alignment: WrapAlignment
                          .center, // Centra las tarjetas si sobran huecos
                      children: avisos
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        key: 'ManuleWeather_Widget',
        logicalSize: const Size(500, 500),
      );

      // 2. Le pegamos el toque al sistema operativo para que refresque la pantalla
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );

      print("¡Widget renderizado y actualizado desde Flutter!");
    } catch (e) {
      print("Error al renderizar el widget: $e");
    }
  }
}
