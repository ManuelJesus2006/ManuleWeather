import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
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
          _buildPantallaPorDias(context, weatherProvider, navigationProvider),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Por días',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Por horas'),
        ],
      ),
    );
  }

  Widget _buildInicio(BuildContext context, WeatherProvider weatherProvider) {
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
        child: RefreshIndicator(
          onRefresh: () async {
            await weatherProvider.actualizarDatos();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                      onPressed: () => context.push('/search'),
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
                          fontSize: weatherProvider.localizacion!.length > 40
                              ? 18
                              : 20,
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
                    Utils.obtenerSimboloTiempoActual(
                      weatherProvider.tiempoActual!.weather[0].icon,
                    ),
                  ],
                ),
                Text(
                  weatherProvider.tiempoActual!.weather[0].description
                      .toUpperCase(),
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
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
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
                              style: TextStyle(
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
                      weatherProvider.tiempoActual!.visibility != null
                          ? Text(
                              '${(weatherProvider.tiempoActual!.visibility)! / 1000}kms',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'No disponible',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
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
      ),
    );
  }

  Widget _buildTiempoPorHoras(
    BuildContext context,
    WeatherProvider weatherProvider,
  ) {
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
                      onPressed: () => context.push('/search'),
                      icon: Icon(Icons.search, color: Colors.white),
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
                          fontSize: weatherProvider.localizacion!.length > 40
                              ? 18
                              : 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await weatherProvider.actualizarDatos();
              },
              child: ListView.builder(
                itemCount: weatherProvider.tiempoHoras!.time.length,
                itemBuilder: (context, i) {
                  final hora = weatherProvider.tiempoHoras!.time[i];
                  final fecha = DateTime.parse(hora);
                  final temperatura =
                      weatherProvider.tiempoHoras!.temperature2M[i];
                  final weatherCode =
                      weatherProvider.tiempoHoras!.weatherCode[i];
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      if (i == 0) _fechaCompletaCard(fecha: fecha),
                      SizedBox(height: 8),
                      if (hora.substring(11, 16) == '00:00')
                        Divider(thickness: 1, color: Colors.grey),
                      if (hora.substring(11, 16) == '00:00')
                        _fechaCompletaCard(fecha: fecha),

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
                                Utils.obtenerSimbolo(weatherCode, true),
                                SizedBox(width: 10),
                                Text(
                                  '${temperatura.round().toString()}ºC',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),

                                Text(
                                  Utils.obtenerTiempoText(weatherCode),
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
          ),
        ],
      ),
    );
  }

  Widget _buildPantallaPorDias(
    BuildContext context,
    WeatherProvider weatherProvider,
    NavigationProvider navigationProvider,
  ) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await weatherProvider.actualizarDatos();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                        onPressed: () => context.push('/search'),
                        icon: Icon(Icons.search, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weatherProvider.isUbicacionUser!)
                        Icon(LucideIcons.navigation, color: Colors.black),
                      Flexible(
                        child: Text(
                          weatherProvider.localizacion!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: weatherProvider.localizacion!.length > 40
                                ? 18
                                : 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherProvider.tiempoDias!.time.length,
                      itemBuilder: (context, index) {
                        DateTime fecha =
                            weatherProvider.tiempoDias!.time[index];
                        double tempMax =
                            weatherProvider.tiempoDias!.temperature2MMax[index];
                        double tempMin =
                            weatherProvider.tiempoDias!.temperature2MMin[index];
                        IconData icono =
                            weatherProvider.tiempoDias!.iconosGenerales[index];
                        return GestureDetector(
                          onTap: () {
                            navigationProvider.cambiarIndiceTiempoDias(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      navigationProvider
                                              .indiceTiempoDiasActual ==
                                          index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${Utils.obtenerDiaSemana(fecha.weekday).toUpperCase().substring(0, 3)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${fecha.day} de ${Utils.obtenerMes(fecha.month)}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '${tempMax.round()}ºC',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${tempMin.round()}ºC',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Icon(icono, size: 30),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(thickness: 2),
                  _tiempoDiaIndividualCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _fechaCompletaCard extends StatelessWidget {
  const _fechaCompletaCard({super.key, required this.fecha});

  final DateTime fecha;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        '${Utils.obtenerDiaSemana(fecha.weekday)} - ${fecha.day} de ${Utils.obtenerMes(fecha.month)} de ${fecha.year}',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _tiempoDiaIndividualCard extends StatelessWidget {
  const _tiempoDiaIndividualCard({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    IconData iconoActual = weatherProvider
        .tiempoDias!
        .iconosGenerales[navigationProvider.indiceTiempoDiasActual];
    String tempMax = weatherProvider
        .tiempoDias!
        .temperature2MMax[navigationProvider.indiceTiempoDiasActual]
        .round()
        .toString();
    String tempMin = weatherProvider
        .tiempoDias!
        .temperature2MMin[navigationProvider.indiceTiempoDiasActual]
        .round()
        .toString();
    String vientoMax = weatherProvider
        .tiempoDias!
        .windSpeed10MMax[navigationProvider.indiceTiempoDiasActual]
        .round()
        .toString();
    String rachasMax = weatherProvider
        .tiempoDias!
        .windGusts10MMax[navigationProvider.indiceTiempoDiasActual]
        .round()
        .toString();
    String desc = weatherProvider
        .tiempoDias!
        .descripcionesCortas[navigationProvider.indiceTiempoDiasActual];
    DateTime fecha = weatherProvider
        .tiempoDias!
        .time[navigationProvider.indiceTiempoDiasActual];
    double mmLluvia = weatherProvider
        .tiempoDias!
        .precipitationSum[navigationProvider.indiceTiempoDiasActual];
    return SizedBox(
      height: 550,
      child: Container(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              '${Utils.obtenerDiaSemana(fecha.weekday)} - ${fecha.day} de ${Utils.obtenerMes(fecha.month)} de ${fecha.year}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconoActual, size: 70),
                Text('$tempMaxºC/$tempMinºC', style: TextStyle(fontSize: 30)),
              ],
            ),
            SizedBox(height: 30),
            Text(desc, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue[600]?.withOpacity(0.6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🌧️❄️Cantidad de precipitación/nieve",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("$mmLluvia l/m²", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.teal.shade300.withOpacity(0.8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🍃Vel viento máxima",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text("$vientoMax km/h", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.orange.shade300.withOpacity(0.8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🪁Rachas viento máximas",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text("$rachasMax km/h", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
