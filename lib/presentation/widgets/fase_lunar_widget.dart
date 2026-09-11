import 'package:flutter/material.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class FaseLunarWidget extends StatelessWidget {
  const FaseLunarWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.faseLunarAPintar,
  });

  final double screenWidth;
  final double screenHeight;
  final double faseLunarAPintar;

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      width: screenWidth * 0.9,
      //Evita que el contenedor estire la luna a lo ancho
      alignment: Alignment.center,
      // Corta cualquier cosa que intente salirse de los bordes redondeados
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: configProvider.isDarkTheme ? Colors.grey[900] : Colors.grey[300],
      ),
      child: Column(
        children: [
          Text(
            faseLunarAPintar == weatherProvider.faseLunar ? Utils.stringActualMoonPhase(configProvider.idiomaActual) : Utils.stringMoonPhase(configProvider.idiomaActual),
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              color: configProvider.isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            //Tamaño cuadrado perfecto para que no se deforme el radio
            width: 150,
            height: 150,
            child: LunaWidget2D(fase: faseLunarAPintar),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            Utils.stringFaseLunarDinamica(
              faseLunarAPintar,
              configProvider.idiomaActual,
            ),
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: configProvider.isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          //Si es la faseActual y no es la de tiempoDias ponemos la fecha de la próxima luna llena o nueva
          if (faseLunarAPintar == weatherProvider.faseLunar)
            Text(
              Utils.adviseOfTheNextFullOrNewMoon(
                faseLunarAPintar,
                configProvider.idiomaActual,
                weatherProvider,
              ),
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: configProvider.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class LunaWidget2D extends StatelessWidget {
  final double fase;

  const LunaWidget2D({super.key, required this.fase});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // Se adapta automáticamente al 150x150 del SizedBox que tienes fuera
      size: const Size(150, 150),
      painter: _LunaPainter2D(fase),
    );
  }
}

class _LunaPainter2D extends CustomPainter {
  final double fase;
  _LunaPainter2D(this.fase);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Recortamos en círculo para que nada se salga
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    // Fondo oscuro (cara oculta de la luna, no es negra pura para mantener volumen)
    final paintSombra = Paint()..color = const Color(0xFF151525);
    canvas.drawCircle(center, radius, paintSombra);

    // Textura base de la luna (con gradiente para dar sensación de esfera)
    final paintLuna = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: [
          Color(0xFFFFFDE7), // Centro del impacto de luz
          Color(0xFFE8E5B0),
          Color(0xFF9E9D7A),
          Color(0xFF2A2A2A), // Borde oscuro para el volumen
        ],
        stops: [0.0, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Dibujamos la fase usando la matemática de curvatura
    _dibujarFase(canvas, center, radius, paintLuna, paintSombra, size);

    // Detalles (Cráteres) - Los dibujamos antes del toque final 3D
    _dibujarCrateres(canvas, center);

    // EL TOQUE 3D: Sombra interior (Inner Shadow) para redondear toda la esfera
    final shadowPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [Colors.transparent, Colors.black87],
        stops: [0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.multiply; // Oscurece solo los bordes
    canvas.drawCircle(center, radius, shadowPaint);

    // EL TOQUE 3D: Brillo especular (Corona de luz en la parte superior izquierda)
    final specularPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.6, -0.6),
        radius: 0.6,
        colors: [Colors.white30, Colors.transparent],
        stops: [0.0, 0.6],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.screen; // Ilumina simulando el reflejo del sol
    canvas.drawCircle(center, radius, specularPaint);
  }

  void _dibujarFase(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paintLuna,
    Paint paintSombra,
    Size size,
  ) {
    if (fase < 0.5) {
      canvas.drawRect(
        Rect.fromLTRB(center.dx, 0, size.width, size.height),
        paintLuna,
      );
      double t = 1.0 - (fase * 4.0);
      if (t > 0) {
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2 * t,
            height: radius * 2,
          ),
          paintSombra,
        );
      } else {
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2 * (-t),
            height: radius * 2,
          ),
          paintLuna,
        );
      }
    } else {
      canvas.drawRect(Rect.fromLTRB(0, 0, center.dx, size.height), paintLuna);
      double t = 1.0 - ((fase - 0.5) * 4.0);
      if (t > 0) {
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2 * t,
            height: radius * 2,
          ),
          paintLuna,
        );
      } else {
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2 * (-t),
            height: radius * 2,
          ),
          paintSombra,
        );
      }
    }
  }

  void _dibujarCrateres(Canvas canvas, Offset center) {
    final paintCrater = Paint()..color = Colors.black.withOpacity(0.15);
    canvas.drawCircle(center + const Offset(-20, -15), 12, paintCrater);
    canvas.drawCircle(center + const Offset(15, 20), 8, paintCrater);
    canvas.drawCircle(center + const Offset(25, -25), 6, paintCrater);
    canvas.drawCircle(center + const Offset(-30, 20), 5, paintCrater);
  }

  @override
  bool shouldRepaint(_LunaPainter2D oldDelegate) => oldDelegate.fase != fase;
}
