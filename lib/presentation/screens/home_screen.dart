import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/providers/navigation_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    
    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.indiceActual,
        children: [
          _buildInicio(context, weatherProvider),
          _buildTiempoPorHoras(context, weatherProvider),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.indiceActual,
        onTap: (index) {
          navigationProvider.cambiarIndice(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Por horas'),
        ],
      ),
    );
  }

  Widget _buildInicio(BuildContext context, WeatherProvider weatherProvider){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: weatherProvider.isDeDia
              ? AssetImage('assets/images/fondo_dia.png')
              : AssetImage('assets/images/fondo_noche.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/LogoApp.png',
                    width: 80,
                    height: 80,
                  ),
                  IconButton(
                    onPressed: () =>
                        context.push('/search'),
                    icon: Icon(Icons.search, color: Colors.blueGrey),
                  ),
                ],
              ),
              Row(
                //Texto de la ciudad actual
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (weatherProvider.isUbicacionUser!)
                    Icon(LucideIcons.navigation, color: Colors.white),
                  Flexible(
                    //Para que no sobresalga de la pantalla
                    child: Text(
                      weatherProvider.localizacion!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: weatherProvider.localizacion!.length > 40 ? 18 : 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Hora local: ${Utils.formatearHora(weatherProvider.ahoraCiudad)}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${weatherProvider.tiempoActual!.main.temp.round()}ºC',
                    style: TextStyle(fontSize: 65, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'clouds')
                    Icon(Icons.cloud, size: 50, color: Colors.white)
                  else if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'snow')
                    Icon(Icons.snowing, size: 50, color: Colors.white)
                  else if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'clear')
                    Icon(Icons.wb_sunny, size: 50, color: Colors.white)
                  else if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'rain')
                    Icon(Icons.umbrella, size: 50, color: Colors.white)
                  else if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'drizzle')
                    Icon(Icons.grain, size: 50, color: Colors.white)
                  else if (weatherProvider.tiempoActual!.weather[0].main.toLowerCase() ==
                      'thunderstorm')
                    Icon(Icons.flash_on, size: 50, color: Colors.white)
                  else if ([
                    'mist',
                    'fog',
                    'haze',
                  ].contains(weatherProvider.tiempoActual!.weather[0].main.toLowerCase()))
                    Icon(Icons.filter_drama, size: 50, color: Colors.white)
                  else
                    Icon(Icons.help_outline, size: 50, color: Colors.white),
                ],
              ),
              Text(
                weatherProvider.tiempoActual!.weather[0].description.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sensación térmica:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '${weatherProvider.tiempoActual!.main.feelsLike.round()}ºC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.orange.withOpacity(0.6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'MAX☀️',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${weatherProvider.tiempoActual!.main.tempMax.round()}ºC',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue.withOpacity(0.6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'MIN❄️',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${weatherProvider.tiempoActual!.main.tempMin.round()}ºC',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Amanecer
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Amanecer 🌅',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Utils.formatearHora(weatherProvider.sunrise),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Anochecer
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Anochecer 🌇',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Utils.formatearHora(weatherProvider.sunset),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                //Velocidad del viento
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Viento🍃',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherProvider.tiempoActual!.wind.speed.round()}km/h',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Racha máxima de viento
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Rachas máximas de viento🪁',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                     weatherProvider.tiempoActual!.wind.gust != null
                          ? '${weatherProvider.tiempoActual!.wind.gust!.round()} km/h'
                          : 'Sin ráfagas',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Orientación del viento
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Orientación del viento🧭',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherProvider.tiempoActual!.wind.deg}º',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Porcentaje de nubosidad
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Nubosidad☁️',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherProvider.tiempoActual!.clouds.all}%',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Porcentaje de humedad
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Humedad💧',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherProvider.tiempoActual!.main.humidity}%',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Visibilidad en kms
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Visibilidad👁️',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    weatherProvider.tiempoActual!.visibility != null ?
                    Text(
                      '${(weatherProvider.tiempoActual!.visibility)! / 1000}kms',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ) : Text(
                      'No disponible',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                //Presión atmosférica en hectopascales
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'Presión atmosférica🌍',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherProvider.tiempoActual!.main.pressure}hPa',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTiempoPorHoras(BuildContext context, WeatherProvider weatherProvider) {

    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/LogoApp.png',
                      width: 80,
                      height: 80,
                    ),
                    IconButton(
                      onPressed: () => context.push(
                        '/search',),
                      icon: Icon(Icons.search, color: Colors.blueGrey),
                    ),
                  ],
                ),
                Row(
                  //Texto de la ciudad actual
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (weatherProvider.isUbicacionUser!)
                      Icon(LucideIcons.navigation, color: Colors.white),
                    Flexible(
                      //Para que no sobresalga de la pantalla
                      child: Text(
                        weatherProvider.localizacion!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: weatherProvider.localizacion!.length > 40 ? 18 : 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weatherProvider.tiempoHoras!.time.length,
              itemBuilder: (context, i) {
                
                final hora = weatherProvider.tiempoHoras!.time[i];
                final fecha = DateTime.parse(hora);
                final temperatura = weatherProvider.tiempoHoras!.temperature2M[i];
                final weatherCode = weatherProvider.tiempoHoras!.weatherCode[i];
                return Column(
                  children: [
                    SizedBox(height: 8),
                    if (hora.substring(11, 16) == '00:00')
                      Divider(thickness: 1, color: Colors.grey),
                    if (hora.substring(11, 16) == '00:00')
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          '${Utils.obtenerDiaSemana(fecha.weekday)} - ${fecha.day} de ${Utils.obtenerMes(fecha.month)} de ${fecha.year}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),

                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            hora.substring(11, 16),
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (weatherCode == 0)
                                Icon(
                                  LucideIcons.sun,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si está despejado
                              else if (weatherCode == 1 ||
                                  weatherCode == 2 ||
                                  weatherCode == 3)
                                Icon(
                                  LucideIcons.cloudSun,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si esta algo nublado
                              else if (weatherCode == 45 || weatherCode == 48)
                                Icon(
                                  LucideIcons.cloudFog,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si hay neblina
                              else if (weatherCode >= 51 && weatherCode <= 65)
                                Icon(
                                  LucideIcons.cloudRain,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si esta lloviendo un poco
                              else if ([
                                71,
                                73,
                                75,
                                77,
                                85,
                                86,
                              ].contains(weatherCode))
                                Icon(
                                  LucideIcons.snowflake,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si esta nevando
                              else if (weatherCode >= 80 && weatherCode <= 82)
                                Icon(
                                  LucideIcons.cloudRainWind,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si esta lloviendo fuerte
                              else if (weatherCode >= 95 && weatherCode <= 99)
                                Icon(
                                  LucideIcons.cloudLightning,
                                  size: 30,
                                  color: Colors.black,
                                ) //Si hay tormenta
                              else
                                Icon(
                                  Icons.help_outline,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              SizedBox(width: 10),
                              Text(
                                '${temperatura.round().toString()}ºC',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              if (weatherCode == 0)
                                Text(
                                  "Despejado",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if (weatherCode == 1 ||
                                  weatherCode == 2 ||
                                  weatherCode == 3)
                                Text(
                                  "Nublado",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if (weatherCode == 45 || weatherCode == 48)
                                Text(
                                  "Niebla",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if (weatherCode >= 51 && weatherCode <= 65)
                                Text(
                                  "Lluvia",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if ([
                                71,
                                73,
                                75,
                                77,
                                85,
                                86,
                              ].contains(weatherCode))
                                Text(
                                  "Nevando",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if (weatherCode >= 80 && weatherCode <= 82)
                                Text(
                                  "Lluvia fuerte",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else if (weatherCode >= 95 && weatherCode <= 99)
                                Text(
                                  "Tormenta",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              else
                                Text(
                                  "Desconocido",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
}
