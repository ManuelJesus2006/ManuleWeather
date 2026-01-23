import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.isUbicacionUser});

  final bool isUbicacionUser;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String nombreUbi = '';
  double tempUbi = 0;
  String estadoUbi = '';
  Position? ubiActual;

  @override
  void initState() {
    super.initState();
    buscarUbicacionActual();
  }

  void buscarUbicacionActual() async {
    Position position = await Geolocator.getCurrentPosition();

    //Verificamos si el widget sigue vivo antes de seguir para evitar el crasheo
    if (!mounted) return;

    Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
      position.latitude,
      position.longitude,
    );
    String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(
      position.longitude,
      position.latitude,
    );

    //Verificamos si el widget sigue vivo antes de seguir para evitar el crasheo
    if (!mounted) return;

    setState(() {
      nombreUbi = nombreCiudad!;
      tempUbi = tiempoUbi!.main.temp;
      estadoUbi = tiempoUbi.weather[0].main;
      ubiActual = position;
    });
  }

  final TextEditingController controladorBusqueda = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Busque un lugar',
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
                _widgetUbicacion(
                  nombreUbi: nombreUbi,
                  tempUbi: tempUbi,
                  estadoUbi: estadoUbi,
                  isUbiActual: widget.isUbicacionUser,
                  ubiActual: ubiActual,
                ),
                Divider(thickness: 5, color: Colors.grey[300]),
              ],
            ),
            if (controladorBusqueda.text.isNotEmpty)
              FutureBuilder(
                future: LocalizacionService().getResultadosBusqueda(
                  controladorBusqueda.text,
                ),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<Localizacion>> snapshot,
                    ) {
                      return snapshot.hasData
                          ? MostrarResultados(
                              lugares: snapshot.data!,
                              isUbicacionUser: widget.isUbicacionUser,
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
          return !lugar.placeNameEs!.contains(RegExp(r'\d'))
              ? _widgetLugarBusqueda(lugar: lugar)
              : Container();
        },
      ),
    );
  }
}

class _widgetUbicacion extends StatelessWidget {
  const _widgetUbicacion({
    super.key,
    required this.nombreUbi,
    required this.tempUbi,
    required this.estadoUbi,
    required this.isUbiActual,
    required this.ubiActual,
  });

  final String nombreUbi;
  final double tempUbi;
  final String estadoUbi;
  final bool isUbiActual;
  final Position? ubiActual;
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
    if (nombreUbi != '' && tempUbi != 0 && estadoUbi != '') {
      return GestureDetector(
        onTap: () async {
          if (!isUbiActual) {
            mostrarCargando(context);
            Position position = ubiActual!;

            Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
              position.latitude,
              position.longitude,
            );
            TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
              position.latitude,
              position.longitude,
            );
            tiempoUbi != null
                ? context.pushReplacement(
                    '/home',
                    extra: [tiempoUbi, nombreUbi, tiempoHoras, true],
                  )
                : context.push('/error');
          } else {
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.navigation),
                    Text(
                      'Ubicación actual',
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
                    if (estadoUbi.toLowerCase() == 'clouds')
                      const Icon(Icons.cloud, size: 30, color: Colors.white)
                    else if (estadoUbi.toLowerCase() == 'snow')
                      const Icon(Icons.snowing, size: 30, color: Colors.white)
                    else if (estadoUbi.toLowerCase() == 'clear')
                      const Icon(Icons.wb_sunny, size: 30, color: Colors.white)
                    else if (estadoUbi.toLowerCase() == 'rain')
                      const Icon(Icons.umbrella, size: 30, color: Colors.white)
                    else if (estadoUbi.toLowerCase() == 'drizzle')
                      const Icon(Icons.grain, size: 30, color: Colors.white)
                    else if (estadoUbi.toLowerCase() == 'thunderstorm')
                      const Icon(Icons.flash_on, size: 30, color: Colors.white)
                    else if ([
                      'mist',
                      'fog',
                      'haze',
                    ].contains(estadoUbi.toLowerCase()))
                      const Icon(
                        Icons.filter_drama,
                        size: 30,
                        color: Colors.white,
                      )
                    else
                      const Icon(
                        Icons.help_outline,
                        size: 30,
                        color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    Text(
                      tempUbi.round().toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        nombreUbi,
                        style: TextStyle(color: Colors.black, fontSize: 17),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Obteniendo ubicación...', style: TextStyle(fontSize: 18)),
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
  const _widgetLugarBusqueda({super.key, required this.lugar});

  final Localizacion lugar;

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
        tiempoUbi != null
            ? context.pushReplacement(
                '/home',
                extra: [tiempoUbi, lugar.placeNameEs, tiempoHoras, false],
              )
            : context.push('/error');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Container(
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.grey[300],
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
                            if (snapshot.data!.weather[0].main.toLowerCase() ==
                                'clouds')
                              const Icon(
                                Icons.cloud,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (snapshot.data!.weather[0].main
                                    .toLowerCase() ==
                                'snow')
                              const Icon(
                                Icons.snowing,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (snapshot.data!.weather[0].main
                                    .toLowerCase() ==
                                'clear')
                              const Icon(
                                Icons.wb_sunny,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (snapshot.data!.weather[0].main
                                    .toLowerCase() ==
                                'rain')
                              const Icon(
                                Icons.umbrella,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (snapshot.data!.weather[0].main
                                    .toLowerCase() ==
                                'drizzle')
                              const Icon(
                                Icons.grain,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (snapshot.data!.weather[0].main
                                    .toLowerCase() ==
                                'thunderstorm')
                              const Icon(
                                Icons.flash_on,
                                size: 30,
                                color: Colors.white,
                              )
                            else if (['mist', 'fog', 'haze'].contains(
                              snapshot.data!.weather[0].main.toLowerCase(),
                            ))
                              const Icon(
                                Icons.filter_drama,
                                size: 30,
                                color: Colors.white,
                              )
                            else
                              const Icon(
                                Icons.help_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                            SizedBox(width: 8),
                            Text(
                              snapshot.data!.main.temp.round().toString(),
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
                child: Text(
                  lugar.placeNameEs!,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
