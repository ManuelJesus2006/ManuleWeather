import 'package:go_router/go_router.dart';
import 'package:manule_weather/presentation/screens/error_screen.dart';
import 'package:manule_weather/presentation/screens/home_screen.dart';
import 'package:manule_weather/presentation/screens/search_screen.dart';
import 'package:manule_weather/presentation/screens/splash_screen.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(path: '/search', builder: (context, state){
      final WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
      return SearchScreen(weatherProvider: weatherProvider,);
    }),
    GoRoute(path: '/error', builder: (context, state) => ErrorScreen()),
  ],
);
