import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final WeatherProvider weatherProvider;
  final ConfigProvider configProvider;
  const SearchScreen({
    super.key,
    required this.weatherProvider,
    required this.configProvider,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    widget.weatherProvider.buscarUbicacionActual(
      widget.configProvider.idiomaActual,
    );
    super.initState();
  }

  final TextEditingController controladorBusqueda = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controladorBusqueda,
                      decoration: InputDecoration(
                        hintText: Utils.stringInputSearch(
                          configProvider.idiomaActual,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _widgetUbicacion(weatherProvider: weatherProvider),
                if (configProvider.historialBusqueda.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 40,
                    ),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) =>
                              SearchHistoryModalBottomSheet(),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 10),
                          Text(
                            Utils.stringShowSearchHistory(
                              configProvider.idiomaActual,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: configProvider.isDarkTheme
                            ? Colors.grey[800]
                            : Colors.blue,
                      ),
                    ),
                  ),
                Divider(thickness: 5, color: Colors.grey[300]),
              ],
            ),
            if (controladorBusqueda.text.isNotEmpty)
              FutureBuilder(
                future: LocalizacionService().getResultadosBusqueda(
                  controladorBusqueda.text,
                  configProvider.idiomaActual,
                ),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<Localizacion>> snapshot,
                    ) {
                      return snapshot.hasData
                          ? MostrarResultados(
                              lugares: snapshot.data!,
                              isUbicacionUser: weatherProvider.isUbicacionUser!,
                            )
                          : Center(child: CircularProgressIndicator());
                    },
              ),
          ],
        ),
      ),
    );
  }
}

class MostrarResultados extends StatefulWidget {
  const MostrarResultados({
    super.key,
    required this.lugares,
    required this.isUbicacionUser,
  });

  final List<Localizacion> lugares;
  final bool isUbicacionUser;

  @override
  State<MostrarResultados> createState() => _MostrarResultadosState();
}

class _MostrarResultadosState extends State<MostrarResultados> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.lugares.length,
        itemBuilder: (context, i) {
          final lugar = widget.lugares[i];
          return !lugar.placeName!.contains(RegExp(r'\d'))
              ? _widgetLugarBusqueda(lugar: lugar, isHistorial: false)
              : Container();
        },
      ),
    );
  }
}

class _widgetUbicacion extends StatelessWidget {
  const _widgetUbicacion({super.key, required this.weatherProvider});

  final WeatherProvider weatherProvider;
  void mostrarCargando(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // No se puede quitar tocando fuera
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white, // O el color que prefieras
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    if (weatherProvider.nombreUbi != '' && weatherProvider.tempUbi != 0) {
      return GestureDetector(
        onTap: () async {
          weatherProvider
              .comprobarUbicacionUser(); //Comprueba que la ubicación encontrada sea diferente a
          //la localización actual
          if (!weatherProvider.isUbicacionUser!) {
            mostrarCargando(context);
            Position position = weatherProvider.geolocalizacion!;

            Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
              position.latitude,
              position.longitude,
            );
            TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
              position.latitude,
              position.longitude,
            );
            TiempoDias? tiempoDias = await TiempoService().getTiempoPorDias(
              position.latitude,
              position.longitude,
            );
            weatherProvider.cambiarDatos(
              tiempoUbi!,
              weatherProvider.nombreUbi,
              tiempoHoras!,
              tiempoDias!,
              true,
              position.latitude,
              position.longitude,
            );
            weatherProvider.comprobarNocheDia();
            weatherProvider.inicializarTiempoDias(configProvider.idiomaActual);
            DateTime horaActual = weatherProvider.ahoraCiudad;
            int elementosAEliminar = horaActual.hour;
            weatherProvider.eliminarHorasPasadas(elementosAEliminar);
            context.go('/home');
          } else {
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: configProvider.isDarkTheme
                  ? Colors.grey[800]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.navigation),
                    Text(
                      Utils.stringCurrentLocation(configProvider.idiomaActual),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      weatherProvider.iconoUbi,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${weatherProvider.tempUbi.round().toString()}ºC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        weatherProvider.nombreUbi,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: configProvider.isDarkTheme
                ? Colors.grey[800]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Utils.stringObtainingLocation(configProvider.idiomaActual),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 30),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
  }
}

class _widgetLugarBusqueda extends StatelessWidget {
  const _widgetLugarBusqueda({
    super.key,
    required this.lugar,
    required this.isHistorial,
  });

  final Localizacion lugar;
  final bool isHistorial;

  void mostrarCargando(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WeatherProvider weatherProvider = Provider.of<WeatherProvider>(
      context,
    );
    final configProvider = Provider.of<ConfigProvider>(context);
    return GestureDetector(
      onTap: () async {
        mostrarCargando(context);
        Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
          lugar.center![1],
          lugar.center![0],
        );
        TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
          lugar.center![1],
          lugar.center![0],
        );
        TiempoDias? tiempoDias = await TiempoService().getTiempoPorDias(
          lugar.center![1],
          lugar.center![0],
        );
        weatherProvider.cambiarDatos(
          tiempoUbi!,
          lugar.placeName!,
          tiempoHoras!,
          tiempoDias!,
          false,
          lugar.center![1],
          lugar.center![0],
        );
        weatherProvider.comprobarNocheDia();
        weatherProvider.inicializarTiempoDias(configProvider.idiomaActual);
        //Lógica previa para obtener el día actual y sobre esa hora limitar el array de tiempo horas
        DateTime horaActual = weatherProvider.ahoraCiudad;
        int elementosAEliminar = horaActual.hour;
        //Eliminamos las horas pasadas del tiempoHoras
        weatherProvider.eliminarHorasPasadas(elementosAEliminar);
        if (!isHistorial) configProvider.actualizarHistorialBusqueda(lugar);
        context.go('/home');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: configProvider.isDarkTheme
                ? Colors.grey[800]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              FutureBuilder(
                future: TiempoService().getTiempoLatLon(
                  lugar.center![1],
                  lugar.center![0],
                ),
                builder: (BuildContext context, snapshot) {
                  return snapshot.hasData
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Utils.obtenerSimbolo(
                                snapshot.data!.current.weatherCode,
                                false,
                                snapshot.data!.current.isDay == 1
                                    ? true
                                    : false,
                              ),
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${snapshot.data!.current.temperature2M.round().toString()}ºC',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : CircularProgressIndicator();
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  //Row principal mantiene el texto y el botón alineados
                  children: [
                    Expanded(
                      //Forzamos al texto a ocupar SOLO el espacio que sobre
                      child: Text(
                        lugar.placeName!,
                        style: const TextStyle(fontSize: 17),
                        overflow: TextOverflow
                            .ellipsis, //Si es muy largo, añade "..." en vez de petar
                        maxLines:
                            1, //Evita que salte a otra línea desconfigurando la altura
                      ),
                    ),
                    if (isHistorial)
                      //Botón de eliminar del historial
                      IconButton(
                        onPressed: () {
                          configProvider.eliminarDelHistorial(lugar.id);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
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
}

class SearchHistoryModalBottomSheet extends StatelessWidget {
  const SearchHistoryModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double
            .infinity, //obliga a todo el bloque a ocupar el 100% del ancho
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Utils.stringSearchHistory(configProvider.idiomaActual),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(thickness: 5, color: Colors.grey[300]),
            SizedBox(height: 10),
            if (configProvider.historialBusqueda.isNotEmpty)
              Center(
                child: Text(
                  Utils.stringLimitSearchHistoryAdvisory(
                    configProvider.idiomaActual,
                  ),
                ),
              ),
            configProvider.historialBusqueda.isEmpty
                ? Center(
                    child: Text(
                      Utils.stringNoSearchHistoryYet(
                        configProvider.idiomaActual,
                      )
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true, //Se encoge al tamaño real de tus items
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: configProvider.historialBusqueda.length,
                    itemBuilder: (context, i) {
                      final lugar = configProvider.historialBusqueda[i];
                      return _widgetLugarBusqueda(
                        lugar: lugar,
                        isHistorial: true,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
