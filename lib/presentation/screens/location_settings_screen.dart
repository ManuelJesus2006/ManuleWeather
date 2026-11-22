import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key, required this.isPrimeraVez});

  final bool isPrimeraVez;

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPrimeraVez
              ? Utils.stringLocationOnboardingTitle(configProvider.idiomaActual)
              : Utils.stringLocationSettings(configProvider.idiomaActual),
        ),
        centerTitle: true,
        automaticallyImplyLeading: isPrimeraVez ? false : true,
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
                    value: configProvider.isUbiActive,
                    onChanged: (value) =>
                        configProvider.changeLocation(value, context),
                  ),
                ),
              ),
              SizedBox(height: 8),
              !configProvider.isUbiActive ? _locationSelector(configProvider: configProvider) : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

class _locationSelector extends StatelessWidget {
  const _locationSelector({
    super.key,
    required this.configProvider,
  });

  final ConfigProvider configProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: configProvider.isDarkTheme
              ? Colors.grey[800]
              : Color.fromARGB(255, 205, 206, 255),
        ),
        child: Text(Utils.stringAdvisoryLocationNotEnabled(configProvider.idiomaActual)),
    );
  }
}
