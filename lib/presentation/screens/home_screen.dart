import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.tiempoActual,
    required this.localizacion,
    required this.tiempoHoras,
    required this.isUbicacionUser,
  });

  final bool isUbicacionUser;

  final Tiempo tiempoActual;
  final String localizacion;
  final TiempoHoras tiempoHoras;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime sunrise = DateTime.now();
  DateTime sunset = DateTime.now();
  DateTime ahoraCiudad = DateTime.now();

  int _indiceActual = 0;

  @override
  void initState() {
    super.initState();
    comprobarNocheDia();
  }

  void comprobarNocheDia() {
    final int offsetSegundos = widget.tiempoActual.timezone;

    sunrise = DateTime.fromMillisecondsSinceEpoch(
      widget.tiempoActual.sys.sunrise * 1000,
      isUtc: true,
    ).add(Duration(seconds: offsetSegundos));

    sunset = DateTime.fromMillisecondsSinceEpoch(
      widget.tiempoActual.sys.sunset * 1000,
      isUtc: true,
    ).add(Duration(seconds: offsetSegundos));

    ahoraCiudad = DateTime.now().toUtc().add(Duration(seconds: offsetSegundos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: [
          _buildInicio(context),
          _buildTiempoPorHoras(widget.tiempoHoras),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Por horas'),
        ],
      ),
    );
  }

  Widget _buildInicio(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ahoraCiudad.isAfter(sunrise) && ahoraCiudad.isBefore(sunset)
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
                        context.push('/search', extra: widget.isUbicacionUser),
                    icon: Icon(Icons.search, color: Colors.blueGrey),
                  ),
                ],
              ),
              Row(
                //Texto de la ciudad actual
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isUbicacionUser)
                    Icon(LucideIcons.navigation, color: Colors.white),
                  Flexible(
                    //Para que no sobresalga de la pantalla
                    child: Text(
                      widget.localizacion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.localizacion.length > 40 ? 18 : 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Hora local: ${formatearHora(ahoraCiudad)}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.tiempoActual.main.temp.round()}ºC',
                    style: TextStyle(fontSize: 65, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'clouds')
                    Icon(Icons.cloud, size: 50, color: Colors.white)
                  else if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'snow')
                    Icon(Icons.snowing, size: 50, color: Colors.white)
                  else if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'clear')
                    Icon(Icons.wb_sunny, size: 50, color: Colors.white)
                  else if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'rain')
                    Icon(Icons.umbrella, size: 50, color: Colors.white)
                  else if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'drizzle')
                    Icon(Icons.grain, size: 50, color: Colors.white)
                  else if (widget.tiempoActual.weather[0].main.toLowerCase() ==
                      'thunderstorm')
                    Icon(Icons.flash_on, size: 50, color: Colors.white)
                  else if ([
                    'mist',
                    'fog',
                    'haze',
                  ].contains(widget.tiempoActual.weather[0].main.toLowerCase()))
                    Icon(Icons.filter_drama, size: 50, color: Colors.white)
                  else
                    Icon(Icons.help_outline, size: 50, color: Colors.white),
                ],
              ),
              Text(
                widget.tiempoActual.weather[0].description.toUpperCase(),
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
                '${widget.tiempoActual.main.feelsLike.round()}ºC',
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
                            '${widget.tiempoActual.main.tempMax.round()}ºC',
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
                            '${widget.tiempoActual.main.tempMin.round()}ºC',
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
                            formatearHora(sunrise),
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
                            formatearHora(sunset),
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
                      '${widget.tiempoActual.wind.speed.round()}km/h',
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
                      widget.tiempoActual.wind.gust != null
                          ? '${widget.tiempoActual.wind.gust!.round()} km/h'
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
                      '${widget.tiempoActual.wind.deg}º',
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
                      '${widget.tiempoActual.clouds.all}%',
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
                      '${widget.tiempoActual.main.humidity}%',
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
                    widget.tiempoActual.visibility != null ?
                    Text(
                      '${(widget.tiempoActual.visibility)! / 1000}kms',
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
                      '${widget.tiempoActual.main.pressure}hPa',
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

  Widget _buildTiempoPorHoras(TiempoHoras tiempoHoras) {
    String obtenerMes(String mesNum) {
      switch (mesNum) {
        case '01':
          return 'enero';
        case '02':
          return 'febrero';
        case '03':
          return 'marzo';
        case '04':
          return 'abril';
        case '05':
          return 'mayo';
        case '06':
          return 'junio';
        case '07':
          return 'julio';
        case '08':
          return 'agosto';
        case '09':
          return 'septiembre';
        case '10':
          return 'octubre';
        case '11':
          return 'noviembre';
        case '12':
          return 'diciembre';
        default:
          return 'desconocido';
      }
    }

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
                        '/search',
                        extra: widget.isUbicacionUser,
                      ),
                      icon: Icon(Icons.search, color: Colors.blueGrey),
                    ),
                  ],
                ),
                Row(
                  //Texto de la ciudad actual
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isUbicacionUser)
                      Icon(LucideIcons.navigation, color: Colors.white),
                    Flexible(
                      //Para que no sobresalga de la pantalla
                      child: Text(
                        widget.localizacion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.localizacion.length > 40 ? 18 : 20,
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
              itemCount: tiempoHoras.time.length,
              itemBuilder: (context, i) {
                final hora = tiempoHoras.time[i];
                final temperatura = tiempoHoras.temperature2M[i];
                final weatherCode = tiempoHoras.weatherCode[i];
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
                          '${hora.substring(8, 10)} de ${obtenerMes(hora.substring(5, 7))} de ${hora.substring(0, 4)}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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

  String formatearHora(DateTime fecha) {
    // Añade un 0 a la izquierda si los minutos son menores de 10
    String minutos = fecha.minute < 10 ? '0${fecha.minute}' : '${fecha.minute}';
    return '${fecha.hour}:$minutos';
  }
}
