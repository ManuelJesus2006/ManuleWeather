import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionService {
  String url_version =
      "https://raw.githubusercontent.com/ManuelJesus2006/ManuleWeather/main/version.json";

  Future<void> comprobarActualizacion(String idiomaActual, BuildContext context) async {
    Uri uri = Uri.parse(url_version);
    final response = await get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final versionServer = data['version'];
      final urlDescarga = data['url'];

      final info = await PackageInfo.fromPlatform();
      final versionActual = info.version;

      if (versionServer != versionActual) {
        await showDialog(context: context, builder: (context) => AlertDialog(
          title: Text(Utils.stringNewUpdate(idiomaActual, versionServer)),
          content: Text(Utils.stringUpdateWarningContent(idiomaActual)),
          actions: [
            TextButton(onPressed: () {Navigator.pop(context);}, child: Text(Utils.stringNotYet(idiomaActual))),
            TextButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(urlDescarga),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Text(Utils.stringUpdate(idiomaActual)),
            ),
          ],
        ));
        
      }
    }
  }
}
