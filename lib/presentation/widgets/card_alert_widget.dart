import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class CardAlertWidget extends StatelessWidget {
  CardAlertWidget({super.key, required this.text, required this.color, this.componentsColor = Colors.white});

  String text;
  Color color;
  Color componentsColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final configProvider = Provider.of<ConfigProvider>(context);
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: componentsColor),
              Text(
                Utils.stringDanger(configProvider.idiomaActual),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: componentsColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: componentsColor),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
