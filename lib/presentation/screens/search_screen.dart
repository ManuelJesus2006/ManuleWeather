import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/widgets/home_widget/home_screen_widget_manager.dart';
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
  final TextEditingController controladorBusqueda = TextEditingController();
  Future<List<Localizacion>>? _futureBusqueda;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.weatherProvider.buscarUbicacionActual(
        widget.configProvider.idiomaActual,
      );
    });
  }

  @override
  void dispose() {
    controladorBusqueda.dispose();
    super.dispose();
  }

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
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            _futureBusqueda = LocalizacionService()
                                .getResultadosBusqueda(
                                  value,
                                  configProvider.idiomaActual,
                                );
                          } else {
                            _futureBusqueda = null;
                          }
                        });
                      },
                      controller: controladorBusqueda,
                      decoration: InputDecoration(
                        hintText: Utils.stringInputSearch(
                          configProvider.idiomaActual,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
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
                              const SearchHistoryModalBottomSheet(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: configProvider.isDarkTheme
                            ? Colors.grey[800]
                            : Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history),
                          const SizedBox(width: 10),
                          Text(
                            Utils.stringShowSearchHistory(
                              configProvider.idiomaActual,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                Divider(thickness: 5, color: Colors.grey[300]),
              ],
            ),
            if (controladorBusqueda.text.isNotEmpty && _futureBusqueda != null)
              FutureBuilder<List<Localizacion>>(
                future: _futureBusqueda,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<Localizacion>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              Utils.stringErrorApp(configProvider.idiomaActual),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return MostrarResultados(
                          lugares: snapshot.data!,
                          isUbicacionUser:
                              weatherProvider.isUbicacionUser ?? false,
                          controladorBusqueda: controladorBusqueda,
                        );
                      }
                      return const SizedBox.shrink();
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
    required this.controladorBusqueda,
  });

  final List<Localizacion> lugares;
  final bool isUbicacionUser;
  final TextEditingController controladorBusqueda;

  @override
  State<MostrarResultados> createState() => _MostrarResultadosState();
}

class _MostrarResultadosState extends State<MostrarResultados> {
  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              '${Utils.stringShowingResultsFor(configProvider.idiomaActual)}: ${widget.controladorBusqueda.text}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: configProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.lugares.length,
              itemBuilder: (context, i) {
                final lugar = widget.lugares[i];
                return !lugar.placeName!.contains(RegExp(r'\d'))
                    ? _widgetLugarBusqueda(
                        key: ValueKey('${lugar.id}_${lugar.placeName}'),
                        lugar: lugar,
                        isHistorial: false,
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
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
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    bool ubicacionDisponible = (weatherProvider.nombreUbi != '' && weatherProvider.tempUbi != 0) &&
        (weatherProvider.nombreUbi != "N/A" &&
            weatherProvider.tempUbi != -100);
    if (ubicacionDisponible) {
      return GestureDetector(
        onTap: () async {
          weatherProvider.comprobarUbicacionUser();
          if (weatherProvider.isUbicacionUser != true) {
            final Position? position = weatherProvider.geolocalizacion;
            if (position == null) return;

            mostrarCargando(context);
            bool exito = false;

            try {
              final resultadosPeticion = await Future.wait([
                TiempoService().getTiempoLatLon(
                  position.latitude,
                  position.longitude,
                ),
                TiempoService().getTiempoPorHoras(
                  position.latitude,
                  position.longitude,
                ),
                TiempoService().getTiempoPorDias(
                  position.latitude,
                  position.longitude,
                ),
              ]).timeout(const Duration(seconds: 10));

              Tiempo tiempoUbi = resultadosPeticion[0] as Tiempo;
              TiempoHoras tiempoHoras = resultadosPeticion[1] as TiempoHoras;
              TiempoDias tiempoDias = resultadosPeticion[2] as TiempoDias;

              weatherProvider.cambiarDatos(
                tiempoUbi,
                weatherProvider.nombreUbi,
                tiempoHoras,
                tiempoDias,
                true,
                position.latitude,
                position.longitude,
              );

              HomeScreenWidgetManager.actualizarDatos(
                ciudad: weatherProvider.nombreUbi,
                idioma: configProvider.idiomaActual,
                fondoOscuro: configProvider.isDarkTheme,
                tiempoActual: tiempoUbi,
                rainData: Utils.getRainLevelData(null, tiempoHoras),
                snowData: Utils.getSnowLevelData(null, tiempoHoras),
                tiempoHoras: tiempoHoras,
              );

              int tempMax = tiempoDias.temperature2MMax[0].round();
              int tempMin = tiempoDias.temperature2MMin[0].round();
              await Utils.mandarNotificacionTiempoActual(
                tempMax,
                tempMin,
                tiempoUbi,
                weatherProvider.nombreUbi,
                configProvider.idiomaActual,
              );

              exito = true;
            } on TimeoutException {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Utils.stringErrorTimeout(configProvider.idiomaActual),
                    ),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted && e is HttpException) {
                context.go(
                  '/error',
                  extra: Utils.stringErrorServerDown(
                    configProvider.idiomaActual,
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Utils.stringErrorApp(configProvider.idiomaActual),
                    ),
                  ),
                );
              }
            } finally {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }

            if (!exito || !context.mounted) return;

            weatherProvider.comprobarNocheDia();
            weatherProvider.inicializarTiempoDias(configProvider.idiomaActual);
            int elementosAEliminar = weatherProvider.ahoraCiudad.hour;
            weatherProvider.eliminarHorasPasadas(elementosAEliminar);
            weatherProvider.cambiarFaseLunar();
            context.go('/home');
          } else {
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(13),
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
                    const Icon(LucideIcons.navigation),
                    Text(
                      Utils.stringCurrentLocation(configProvider.idiomaActual),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      weatherProvider.iconoUbi,
                      size: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${weatherProvider.tempUbi.round().toString()}ºC',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        weatherProvider.nombreUbi,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else if (weatherProvider.nombreUbi == "N/A" &&
        weatherProvider.tempUbi == -100) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(13),
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
                  const Icon(LucideIcons.navigation),
                  Text(
                    Utils.stringCurrentLocation(configProvider.idiomaActual),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.cloud_off, size: 30, color: Colors.white70),
                  const SizedBox(width: 8),
                  const Text(
                    '--ºC',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Utils.stringErrorTimeoutUbiSearchScreen(
                        configProvider.idiomaActual,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(13),
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
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
  }
}

class _widgetLugarBusqueda extends StatefulWidget {
  const _widgetLugarBusqueda({
    super.key,
    required this.lugar,
    required this.isHistorial,
  });

  final Localizacion lugar;
  final bool isHistorial;

  @override
  State<_widgetLugarBusqueda> createState() => _widgetLugarBusquedaState();
}

class _widgetLugarBusquedaState extends State<_widgetLugarBusqueda> {
  Future<Tiempo>? _futureTiempo;
  late bool isLoading;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    isLoading = !widget.isHistorial;
    if (!widget.isHistorial) {
      _futureTiempo = _cargarPreview();
    }
  }

  @override
  void didUpdateWidget(covariant _widgetLugarBusqueda oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lugar.id != widget.lugar.id ||
        oldWidget.isHistorial != widget.isHistorial) {
      isError = false;
      isLoading = !widget.isHistorial;
      if (!widget.isHistorial) {
        _futureTiempo = _cargarPreview();
      } else {
        _futureTiempo = null;
      }
    }
  }

  Future<Tiempo> _cargarPreview() async {
    try {
      final responsePreview = await TiempoService()
          .getTiempoLatLon(widget.lugar.center![1], widget.lugar.center![0])
          .timeout(const Duration(seconds: 10));
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = false;
        });
      }
      return responsePreview!;
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
      rethrow;
    }
  }

  void mostrarCargando(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WeatherProvider weatherProvider = Provider.of<WeatherProvider>(
      context,
      listen: false,
    );
    final configProvider = Provider.of<ConfigProvider>(context);

    final bool deshabilitado = isError || isLoading;
    final Color baseColor = configProvider.isDarkTheme
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final Color colorContainer = deshabilitado
        ? baseColor.withValues(alpha: 0.3)
        : baseColor;

    return GestureDetector(
      onTap: deshabilitado
          ? null
          : () async {
              mostrarCargando(context);
              bool exito = false;

              try {
                final resultadosPeticion = await Future.wait([
                  TiempoService().getTiempoLatLon(
                    widget.lugar.center![1],
                    widget.lugar.center![0],
                  ),
                  TiempoService().getTiempoPorHoras(
                    widget.lugar.center![1],
                    widget.lugar.center![0],
                  ),
                  TiempoService().getTiempoPorDias(
                    widget.lugar.center![1],
                    widget.lugar.center![0],
                  ),
                ]).timeout(const Duration(seconds: 10));

                Tiempo tiempoUbi = resultadosPeticion[0] as Tiempo;
                TiempoHoras tiempoHoras = resultadosPeticion[1] as TiempoHoras;
                TiempoDias tiempoDias = resultadosPeticion[2] as TiempoDias;

                weatherProvider.cambiarDatos(
                  tiempoUbi,
                  widget.lugar.placeName!,
                  tiempoHoras,
                  tiempoDias,
                  false,
                  widget.lugar.center![1],
                  widget.lugar.center![0],
                );
                exito = true;
              } on TimeoutException {
                if (mounted) {
                  setState(() => isError = true);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Utils.stringErrorTimeout(configProvider.idiomaActual),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => isError = true);
                }
                if (context.mounted && e is HttpException) {
                  context.go(
                    '/error',
                    extra: Utils.stringErrorServerDown(
                      configProvider.idiomaActual,
                    ),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Utils.stringErrorApp(configProvider.idiomaActual),
                      ),
                    ),
                  );
                }
              } finally {
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }

              if (!exito || !context.mounted) return;

              weatherProvider.comprobarNocheDia();
              weatherProvider.inicializarTiempoDias(
                configProvider.idiomaActual,
              );
              int elementosAEliminar = weatherProvider.ahoraCiudad.hour;
              weatherProvider.eliminarHorasPasadas(elementosAEliminar);
              weatherProvider.cambiarFaseLunar();
              if (!widget.isHistorial) {
                configProvider.actualizarHistorialBusqueda(widget.lugar);
              }
              context.go('/home');
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: colorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (!widget.isHistorial)
                FutureBuilder<Tiempo>(
                  future: _futureTiempo,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Utils.obtenerSimbolo(
                              snapshot.data!.current.weatherCode,
                              false,
                              snapshot.data!.current.isDay == 1,
                            ),
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${snapshot.data!.current.temperature2M.round().toString()}ºC',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      final e = snapshot.error;
                      if (e is HttpException) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            context.go(
                              '/error',
                              extra: Utils.stringErrorServerDown(
                                configProvider.idiomaActual,
                              ),
                            );
                          }
                        });
                        return const SizedBox.shrink();
                      }
                      return const _generalWeatherStatusNotAvailable();
                    }
                    return const _generalWeatherStatusNotAvailable();
                  },
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.lugar.placeName!,
                            style: const TextStyle(fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (widget.isHistorial)
                          IconButton(
                            onPressed: () {
                              configProvider.eliminarDelHistorial(
                                widget.lugar.id,
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    if (isError)
                      Text(
                        Utils.stringAdviceWeatherLocationNotAvailable(
                          configProvider.idiomaActual,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.amberAccent,
                        ),
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

class _generalWeatherStatusNotAvailable extends StatelessWidget {
  const _generalWeatherStatusNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_off, size: 30, color: Colors.white),
        SizedBox(width: 8),
        Text(
          '--ºC',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
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
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Utils.stringSearchHistory(configProvider.idiomaActual),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Divider(thickness: 5, color: Colors.grey[300]),
            const SizedBox(height: 10),
            if (configProvider.historialBusqueda.isNotEmpty)
              Center(
                child: Text(
                  Utils.stringLimitSearchHistoryAdvisory(
                    configProvider.idiomaActual,
                    configProvider.limitSearchHistory,
                  ),
                ),
              ),
            configProvider.historialBusqueda.isEmpty
                ? Center(
                    child: Text(
                      Utils.stringNoSearchHistoryYet(
                        configProvider.idiomaActual,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: configProvider.historialBusqueda.length,
                    itemBuilder: (context, i) {
                      final lugar = configProvider.historialBusqueda[i];
                      return _widgetLugarBusqueda(
                        key: ValueKey('hist_${lugar.id}_${lugar.placeName}'),
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