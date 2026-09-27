import 'package:flutter/material.dart';

class CardHomeWidgetAlertWidget extends StatelessWidget {
  const CardHomeWidgetAlertWidget({required this.cuerpo, required this.color});

  final String cuerpo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, size: 20,),
          SizedBox(width: 4,),
          Text(cuerpo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}