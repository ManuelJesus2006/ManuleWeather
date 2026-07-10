import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/presentation/widgets/weather_hour_detail.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/navigation_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: IndexedStack(
          key: ValueKey(navigationProvider.indiceActual),
          index: navigationProvider.indiceActual,
          children: [
            _buildInicio(context, weatherProvider, screenWidth, configProvider),
            _buildPantallaPorDias(
              context,
              weatherProvider,
              navigationProvider,
              screenWidth,
              configProvider,
            ),
            _buildTiempoPorHoras(
              context,
              weatherProvider,
              screenWidth,
              configProvider,
              navigationProvider,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.indiceActual,
        onTap: (index) {
          navigationProvider.cambiarIndice(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Utils.stringHome(configProvider.idiomaActual),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: Utils.stringDaily(configProvider.idiomaActual),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: Utils.stringHourly(configProvider.idiomaActual),
          ),
        ],
      ),
    );
  }

  Widget _buildInicio(
    BuildContext context,
    WeatherProvider weatherProvider,
    double screenWidth,
    ConfigProvider configProvider,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final puntosUVA = Utils.getPuntosRayosUva(weatherProvider);

    Widget _infoCard({required String titulo, required Widget valor}) {
      return Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            valor,
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Utils.recibirFondoApp(
            weatherProvider.isDeDia,
            weatherProvider.tiempoActual!.current.weatherCode,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await weatherProvider.actualizarDatos(configProvider.idiomaActual);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => context.push('/settings'),
                      icon: Icon(Icons.settings, color: Colors.blueGrey),
                    ),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weatherProvider.isUbicacionUser!)
                        Icon(
                          LucideIcons.navigation,
                          color: Colors.white,
                          size: screenWidth * 0.04,
                        ),
                      Flexible(
                        child: Text(
                          weatherProvider.localizacion!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Utils.devolverCardAvisos(
                  screenWidth,
                  weatherProvider,
                  configProvider.idiomaActual,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '${Utils.stringUpdatedAt(configProvider.idiomaActual)} ${Utils.formatearHora(DateTime.parse(weatherProvider.tiempoActual!.current.time))}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${weatherProvider.tiempoActual!.current.temperature2M.round()}ºC',
                      style: TextStyle(
                        fontSize: screenWidth * 0.18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Icon(
                      Utils.obtenerSimbolo(
                        weatherProvider.tiempoActual!.current.weatherCode,
                        false,
                        weatherProvider.isDeDia,
                      ),
                      size: screenWidth * 0.13,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  Utils.obtenerTiempoText(
                    weatherProvider.tiempoActual!.current.weatherCode,
                    configProvider.idiomaActual,
                  ).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: screenWidth * 0.065,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  Utils.stringFeelsLike(configProvider.idiomaActual),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '${weatherProvider.tiempoActual!.current.apparentTemperature.round()}ºC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Utils.devolverPrevisionGraficaLluvia(screenWidth, weatherProvider, configProvider.idiomaActual),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.orange.withOpacity(0.6),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'MAX☀️',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${weatherProvider.tiempoDias!.temperature2MMax[0].round()}ºC',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue.withOpacity(0.6),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'MIN❄️',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${weatherProvider.tiempoDias!.temperature2MMin[0].round()}ºC',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              Utils.stringSunrise(configProvider.idiomaActual),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              Utils.formatearHora(weatherProvider.sunrise),
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        width: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              Utils.stringSunset(configProvider.idiomaActual),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              Utils.formatearHora(weatherProvider.sunset),
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                UV_home_widget(screenWidth: screenWidth, puntosUVA: puntosUVA),

                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringWind(configProvider.idiomaActual),
                  valor: Text(
                    '${weatherProvider.tiempoActual!.current.windSpeed10M.round()}km/h',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringMaxGust(configProvider.idiomaActual),
                  valor: Text(
                    weatherProvider.tiempoActual!.current.windGusts10M != null
                        ? '${weatherProvider.tiempoActual!.current.windGusts10M.round()} km/h'
                        : 'Sin ráfagas',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringWindOrientation(
                    configProvider.idiomaActual,
                  ),
                  valor: Text(
                    '${weatherProvider.tiempoActual!.current.windDirection10M}º',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringNubosity(configProvider.idiomaActual),
                  valor: Text(
                    '${weatherProvider.tiempoActual!.current.cloudCover}%',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringHumidity(configProvider.idiomaActual),
                  valor: Text(
                    '${weatherProvider.tiempoActual!.current.relativeHumidity2M}%',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringVisibility(configProvider.idiomaActual),
                  valor: Text(
                    weatherProvider.tiempoActual!.current.visibility != null
                        ? '${(weatherProvider.tiempoActual!.current.visibility) / 1000}kms'
                        : 'No disponible',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _infoCard(
                  titulo: Utils.stringPressure(configProvider.idiomaActual),
                  valor: Text(
                    '${weatherProvider.tiempoActual!.current.pressureMsl}hPa',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
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
    double screenWidth,
    ConfigProvider configProvider,
    NavigationProvider navigationProvider,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
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
                    IconButton(
                      onPressed: () => context.push('/settings'),
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weatherProvider.isUbicacionUser!)
                        Icon(LucideIcons.navigation, color: Colors.white),
                      Flexible(
                        child: Text(
                          weatherProvider.localizacion!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await weatherProvider.actualizarDatos(
                  configProvider.idiomaActual,
                );
              },
              child: ListView.builder(
                itemCount: weatherProvider.tiempoHoras!.time.length,
                itemBuilder: (context, i) {
                  bool isAbierto = false;
                  final hora = weatherProvider.tiempoHoras!.time[i];
                  final fecha = DateTime.parse(hora);
                  final temperatura =
                      weatherProvider.tiempoHoras!.temperature2M[i];
                  final weatherCode =
                      weatherProvider.tiempoHoras!.weatherCode[i];
                  bool isHoraDeDia =
                      fecha.hour > weatherProvider.sunrise.hour &&
                      fecha.hour < weatherProvider.sunset.hour;
                  final probLluvia =
                      weatherProvider.tiempoHoras!.precipitationProbability[i];

                  return Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      if (i == 0 && hora.substring(11, 16) != '00:00')
                        _fechaCompletaCard(fecha: fecha),
                      SizedBox(height: screenHeight * 0.01),
                      if (hora.substring(11, 16) == '00:00')
                        _fechaCompletaCard(fecha: fecha),
                      SizedBox(height: screenHeight * 0.015),

                      // Estado local por ítem
                      StatefulBuilder(
                        builder: (context, setStateItem) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 👇 TU TARJETA ORIGINAL (Al pulsarla, se despliega)
                              GestureDetector(
                                onTap: () {
                                  if (i != 0) {
                                    setStateItem(() {
                                      isAbierto = !isAbierto;
                                    });
                                  }else{
                                    navigationProvider.cambiarIndice(0);
                                  }
                                },
                                child: _cardTiempoHoras(
                                  hora: hora,
                                  weatherCode: weatherCode,
                                  isHoraDeDia: isHoraDeDia,
                                  temperatura: temperatura,
                                  probLluvia: probLluvia,
                                  i: i,
                                ),
                              ),

                              // 👇 EL DESPLEGABLE ANIMADO (Cero márgenes raros, 100% real)
                              AnimatedSize(
                                curve: Curves
                                    .fastOutSlowIn, // 👈 Arranca rápido para dar sensación de fluidez y frena suave
                                duration: const Duration(milliseconds: 450),

                                child: isAbierto
                                    ? WeatherHourDetail(indexTiempoHoras: i)
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
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
    double screenWidth,
    ConfigProvider configProvider,
  ) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await weatherProvider.actualizarDatos(configProvider.idiomaActual);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => context.push('/settings'),
                        icon: Icon(Icons.settings, color: Colors.blueGrey),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (weatherProvider.isUbicacionUser!)
                          Icon(LucideIcons.navigation),
                        Flexible(
                          child: Text(
                            weatherProvider.localizacion!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
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
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  navigationProvider.indiceTiempoDiasActual ==
                                      index
                                  ? configProvider.isDarkTheme
                                        ? Colors.blue[400]
                                        : Colors.blue[100]
                                  : configProvider.isDarkTheme
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${Utils.obtenerDiaSemana(fecha.weekday, configProvider.idiomaActual).toUpperCase().substring(0, 3)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${fecha.day} ${Utils.stringOf(configProvider.idiomaActual)} ${Utils.obtenerMes(fecha.month, configProvider.idiomaActual)}',
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
                  _tiempoDiaIndividualCards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _cardTiempoHoras extends StatelessWidget {
  const _cardTiempoHoras({
    super.key,
    required this.hora,
    required this.weatherCode,
    required this.isHoraDeDia,
    required this.temperatura,
    required this.probLluvia,
    required this.i,
  });

  final String hora;
  final int weatherCode;
  final bool isHoraDeDia;
  final double temperatura;
  final int probLluvia;
  final int i;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final configProvider = Provider.of<ConfigProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: configProvider.isDarkTheme
              ? Colors.grey[700]
              : Colors.grey[200],
        ),
        child: Row(
          children: [
            Text(
              i == 0
                  ? Utils.formatearHora(
                      DateTime.parse(
                        weatherProvider.tiempoActual!.current.time,
                      ),
                    )
                  : hora.substring(11, 16),
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Row(
                children: [
                  Utils.obtenerSimbolo(
                    i == 0
                        ? weatherProvider.tiempoActual!.current.weatherCode
                        : weatherCode,
                    true,
                    isHoraDeDia,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '${i == 0 ? weatherProvider.tiempoActual!.current.temperature2M.round() : temperatura.round()}ºC',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      Utils.obtenerTiempoText(
                        i == 0
                            ? weatherProvider.tiempoActual!.current.weatherCode
                            : weatherCode,
                        configProvider.idiomaActual,
                      ),
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "💧${probLluvia}%",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UV_home_widget extends StatelessWidget {
  const UV_home_widget({
    super.key,
    required this.screenWidth,
    required this.puntosUVA,
  });

  final double screenWidth;
  final List<FlSpot> puntosUVA;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //El bloque superior con el índice UV actual
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Utils.obtenerColorUV(
                  weatherProvider.tiempoActual!.current.uvIndex.round(),
                ).withOpacity(0.85),
              ),
              child: Column(
                children: [
                  Text(
                    Utils.stringUVRays(configProvider.idiomaActual),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    weatherProvider.tiempoActual!.current.uvIndex
                        .round()
                        .toString(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Utils.stringUvLevel(
                      weatherProvider.tiempoActual!.current.uvIndex.round(),
                      configProvider.idiomaActual,
                    ),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            //Gráfica de barras UV
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10.0,
                left: 10.0,
                right: 20.0,
              ),
              child: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: puntosUVA.length * 50.0,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: 15,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.black87,
                            tooltipMargin: 10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final index = group.x;
                              final uv = rod.toY;

                              if (index < 0 || index >= puntosUVA.length)
                                return null;

                              final horaReal = index == 0
                                  ? weatherProvider.tiempoActual!.current.time
                                        .substring(11, 13)
                                  : weatherProvider.tiempoHoras!.time[index]
                                        .substring(11, 13);

                              return BarTooltipItem(
                                '${Utils.stringHour(configProvider.idiomaActual)}: $horaReal:00\n',
                                const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${Utils.stringUVRaysScreen(configProvider.idiomaActual)}: $uv',
                                    style: TextStyle(
                                      color: Utils.obtenerColorUV(uv.toInt()),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 3,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= puntosUVA.length)
                                  return const SizedBox.shrink();

                                final horaReal = index == 0
                                    ? Utils.formatearHora(DateTime.parse(weatherProvider.tiempoActual!.current.time))
                                    : weatherProvider.tiempoHoras!.time[index]
                                          .substring(11, 13) + ":00";

                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '$horaReal',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.1),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: puntosUVA.map((punto) {
                          return BarChartGroupData(
                            x: punto.x.toInt(),
                            barRods: [
                              BarChartRodData(
                                toY: punto.y,
                                color: Utils.obtenerColorUV(punto.y.toInt()),
                                width: 14,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
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
    final configProvider = Provider.of<ConfigProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.025),
      decoration: BoxDecoration(
        color: configProvider.isDarkTheme ? Colors.grey[800] : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        '${Utils.obtenerDiaSemana(fecha.weekday, configProvider.idiomaActual)} - ${fecha.day} ${Utils.stringOf(configProvider.idiomaActual)} ${Utils.obtenerMes(fecha.month, configProvider.idiomaActual)} ${Utils.stringOf(configProvider.idiomaActual)} ${fecha.year}',
        style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.038),
      ),
    );
  }
}

class _tiempoDiaIndividualCards extends StatelessWidget {
  const _tiempoDiaIndividualCards({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    int indiceActual = navigationProvider.indiceTiempoDiasActual;
    DateTime sunrise = DateTime.parse(
      weatherProvider.tiempoDias!.sunrise[indiceActual],
    );
    DateTime sunset = DateTime.parse(
      weatherProvider.tiempoDias!.sunset[indiceActual],
    );
    IconData iconoActual =
        weatherProvider.tiempoDias!.iconosGenerales[indiceActual];
    String tempMax = weatherProvider.tiempoDias!.temperature2MMax[indiceActual]
        .round()
        .toString();
    String tempMin = weatherProvider.tiempoDias!.temperature2MMin[indiceActual]
        .round()
        .toString();
    String vientoMax = weatherProvider.tiempoDias!.windSpeed10MMax[indiceActual]
        .round()
        .toString();
    String rachasMax = weatherProvider.tiempoDias!.windGusts10MMax[indiceActual]
        .round()
        .toString();
    String desc = Utils.obtenerTiempoText(
      weatherProvider.tiempoDias!.weatherCode[indiceActual],
      configProvider.idiomaActual,
    );
    DateTime fecha = weatherProvider.tiempoDias!.time[indiceActual];
    double mmLluvia =
        weatherProvider.tiempoDias!.precipitationSum[indiceActual];
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '${Utils.obtenerDiaSemana(fecha.weekday, configProvider.idiomaActual)} - ${fecha.day} ${Utils.stringOf(configProvider.idiomaActual)} ${Utils.obtenerMes(fecha.month, configProvider.idiomaActual)} ${fecha.year}',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconoActual, size: 70),
              Text(' $tempMaxºC/$tempMinºC', style: TextStyle(fontSize: 30)),
            ],
          ),
          SizedBox(height: 10),
          Text(desc, style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey.withOpacity(0.8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Utils.stringSunrise(configProvider.idiomaActual),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        Utils.formatearHora(sunrise),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey.withOpacity(0.8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Utils.stringSunset(configProvider.idiomaActual),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        Utils.formatearHora(sunset),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _infoCard(
            color: Colors.blue[600]!.withOpacity(0.6),
            titulo: Utils.stringAmountOfRainSnow(configProvider.idiomaActual),
            valor: "$mmLluvia l/m²",
          ),
          SizedBox(height: 10),
          _infoCard(
            color: Colors.teal.shade300.withOpacity(0.8),
            titulo: Utils.stringMaxWindSpeed(configProvider.idiomaActual),
            valor: "$vientoMax km/h",
          ),
          SizedBox(height: 10),
          _infoCard(
            color: Colors.orange.shade300.withOpacity(0.8),
            titulo: Utils.stringMaxGust(configProvider.idiomaActual),
            valor: "$rachasMax km/h",
          ),
        ],
      ),
    );
  }
}

Widget _infoCard({
  required Color color,
  required String titulo,
  required String valor,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: color,
    ),
    child: Column(
      children: [
        Text(
          titulo,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
