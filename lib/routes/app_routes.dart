import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/presentation/screens/error_screen.dart';
import 'package:manule_weather/presentation/screens/home_screen.dart';
import 'package:manule_weather/presentation/screens/language_selector_screen.dart';
import 'package:manule_weather/presentation/screens/onboarding_screen.dart';
import 'package:manule_weather/presentation/screens/search_screen.dart';
import 'package:manule_weather/presentation/screens/settings_screen.dart';
import 'package:manule_weather/presentation/screens/splash_screen.dart';
import 'package:manule_weather/presentation/screens/weather_hour_detail.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return _buildPageConTransicion(HomeScreen(), state);
      },
    ),
    GoRoute(
      path: '/hourDetail',
      pageBuilder: (context, state) {
        int indexTiempoHoras = state.extra as int;
        return _buildPageConTransicion(
          WeatherHourDetail(indexTiempoHoras: indexTiempoHoras),
          state,
        );
      },
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        final WeatherProvider weatherProvider = Provider.of<WeatherProvider>(
          context,
        );
        final ConfigProvider configProvider = Provider.of<ConfigProvider>(
          context,
        );
        return _buildPageConTransicion(
          //Le pasamos el weatherProvider y el configProvider para poder hacer initState a la hora de buscar 
          //la ubicación actual
          SearchScreen(
            weatherProvider: weatherProvider,
            configProvider: configProvider,
          ),
          state,
        );
      },
    ),
    GoRoute(path: '/licenses', pageBuilder: (context, state) => _buildPageConTransicion(LicensePage(), state)),
    GoRoute(path: '/settings', pageBuilder: (context, state) => _buildPageConTransicion(SettingsScreen(), state)),
    GoRoute(
      path: '/languageSettings',
      pageBuilder: (context, state) => _buildPageConTransicion(LanguageSelectorScreen(), state)
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _buildPageConTransicion(OnboardingScreen(), state),
    ),
    GoRoute(path: '/error', pageBuilder: (context, state) => _buildPageConTransicion(ErrorScreen(), state)),
  ],
);

Page _buildPageConTransicion(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn, // 👈 curva más natural
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn), // 👈 fade solo al principio
      ));

      final scaleAnimation = Tween<double>(
        begin: 0.95, // 👈 pequeño zoom al entrar
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ));

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}
