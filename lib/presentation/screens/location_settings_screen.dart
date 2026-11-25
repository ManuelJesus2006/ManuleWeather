import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key, required this.isPrimeraVez});

  final bool isPrimeraVez;

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    bool ubiCorrect =
        configProvider.defaultUbiID.isNotEmpty ||
        configProvider.isUbiActive == true;
    return PopScope(
      canPop: ubiCorrect,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isPrimeraVez
                ? Utils.stringLocationOnboardingTitle(
                    configProvider.idiomaActual,
                  )
                : Utils.stringLocationSettings(configProvider.idiomaActual),
          ),
          centerTitle: true,
          automaticallyImplyLeading: (isPrimeraVez || !ubiCorrect)
              ? false
              : true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: configProvider.isDarkTheme
                        ? Colors.grey[800]
                        : Color.fromARGB(255, 205, 206, 255),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(
                      Utils.stringLocationText(configProvider.idiomaActual),
                    ),
                    trailing: Switch(
                      value: configProvider.isUbiActive ?? false,
                      onChanged: (value) async =>
                          await configProvider.changeLocation(value, context),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                configProvider.isUbiActive != true
                    ? _locationSelector()
                    : const SizedBox.shrink(),

                FilledButton.icon(
                  onPressed: ubiCorrect
                      ? () {
                          context.pop();
                        }
                      : null,
                  label: Text(
                    Utils.stringSaveChanges(configProvider.idiomaActual),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    backgroundColor: ubiCorrect
                        ? Colors.deepPurple
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _locationSelector extends StatefulWidget {
  const _locationSelector({super.key});

  @override
  State<_locationSelector> createState() => __locationSelectorState();
}

class __locationSelectorState extends State<_locationSelector> {
  TextEditingController inputBusquedaController = TextEditingController();
  Future<List<Localizacion>>? _futureBusqueda;

  @override
  void dispose() {
    inputBusquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: configProvider.isDarkTheme
                ? Colors.grey[800]
                : Color.fromARGB(255, 205, 206, 255),
          ),
          child: Text(
            Utils.stringAdvisoryLocationNotEnabled(configProvider.idiomaActual),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        //SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  _futureBusqueda = LocalizacionService().getResultadosBusqueda(
                    value,
                    configProvider.idiomaActual,
                  );
                } else {
                  _futureBusqueda = null;
                }
              });
            },
            controller: inputBusquedaController,
            decoration: InputDecoration(
              hintText: Utils.stringInputSearch(configProvider.idiomaActual),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
        if (_futureBusqueda != null && inputBusquedaController.text.isNotEmpty)
          FutureBuilder(
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
                    return MostrarResultadosBusqueda(lugares: snapshot.data!);
                  }
                  return const SizedBox.shrink();
                },
          ),
      ],
    );
  }
}

class MostrarResultadosBusqueda extends StatelessWidget {
  const MostrarResultadosBusqueda({super.key, required this.lugares});

  final List<Localizacion> lugares;

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return ListView.builder(
      shrinkWrap: true, // Se adapta a la altura de sus elementos
      physics:
          const NeverScrollableScrollPhysics(), // Delega el scroll al SingleChildScrollView
      itemCount: lugares.length,
      itemBuilder: (context, i) {
        final lugar = lugares[i];
        return !lugar.placeName!.contains(RegExp(r'\d'))
            ? _widgetLugarSelector(
                key: ValueKey('${lugar.id}_${lugar.placeName}'),
                lugar: lugar,
                configProvider: configProvider,
                context: context,
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _widgetLugarSelector({
    required Key key,
    required Localizacion lugar,
    required ConfigProvider configProvider,
    required BuildContext context,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: configProvider.isDarkTheme
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                lugar.placeName!,
                style: const TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                configProvider.cambiarUbiDefault(
                  lugar.placeName!,
                  lugar.id!,
                  lugar.center!.last,
                  lugar.center!.first,
                );
                await configProvider.changeLocation(false, context);
              },
              icon: (configProvider.defaultUbiID == lugar.id)
                  ? Icon(Icons.check_rounded, size: 20)
                  : null,
              label: Text(
                (configProvider.defaultUbiID == lugar.id)
                    ? Utils.stringChoosen(configProvider.idiomaActual)
                    : Utils.stringChoose(configProvider.idiomaActual),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
