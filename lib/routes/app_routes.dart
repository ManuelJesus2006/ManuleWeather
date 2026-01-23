import 'package:go_router/go_router.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/screens/error_screen.dart';
import 'package:manule_weather/presentation/screens/home_screen.dart';
import 'package:manule_weather/presentation/screens/search_screen.dart';
import 'package:manule_weather/presentation/screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        List<dynamic> extras = state.extra! as List<dynamic>;
        final Tiempo tiempoUbi = extras[0] as Tiempo;
        final String nombreCiudad = extras[1] as String;
        final TiempoHoras tiempoHoras = extras[2] as TiempoHoras;
        bool isUbicacionUser = extras[3] as bool;
        return HomeScreen(tiempoActual: tiempoUbi, localizacion: nombreCiudad, tiempoHoras: tiempoHoras, isUbicacionUser: isUbicacionUser,);
      },
    ),
    GoRoute(path: '/search', builder: (context, state){
      bool isUbicacionUser = state.extra! as bool;
      return SearchScreen(isUbicacionUser: isUbicacionUser);
    }),
    GoRoute(path: '/error', builder: (context, state) => ErrorScreen()),
  ],
);
