import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.stringConfiguration(configProvider.idiomaActual)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 205, 206, 255)
                  ),
                  child: ListTile(
                    leading: Icon(LucideIcons.scroll),
                    title: Text(Utils.stringLicenses(configProvider.idiomaActual)),
                    onTap: () => context.push('/licenses'),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 205, 206, 255)
                  ),
                  child: ListTile(
                    leading: Icon(LucideIcons.languages),
                    trailing: Text(Utils.obtenerIdiomaText(configProvider.idiomaActual), style: TextStyle(fontWeight: FontWeight.bold),),
                    title: Text(Utils.stringLanguagesSettings(configProvider.idiomaActual)),
                    onTap: () => context.push('/languageSettings'),
                  ),
                ),
              ],
            )
          
          ],
        ),
      ),
    );
  }
}
