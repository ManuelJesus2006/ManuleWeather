import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init({bool pedirPermisos = true}) async {
    // Usa el icono por defecto de tu app
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notifications');

    // Si tuvieras iOS, lo añadirías aquí. De momento solo Android.
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings: settings);

    // 👇 ESTO ABRE LA VENTANITA DE "Permitir a la app enviar notificaciones"
    // 👇 SOLO pedimos permiso si estamos en primer plano
    if (pedirPermisos) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> mostrarNotificacion({
  required String titulo,
  required String cuerpo,
  required int id,
}) async {
  const List<int> idNotisAMostrar = [0,2,5,8,11,14,17,20];
  final preferences = await SharedPreferences.getInstance();
  if ((preferences.getBool('notifications') ?? false) || idNotisAMostrar.contains(id)) {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_principal_v2', // Cambia el ID del canal para que Android aplique la nueva importancia
      'Notificaciones de la App',
      importance: Importance.defaultImportance, // No lanza banner intrusivo en pantalla
      priority: Priority.defaultPriority,
      onlyAlertOnce: true, // Suena la primera vez de cada ID y luego se actualiza en silencio
      icon: 'ic_notifications_small',
      ongoing: id == 1,
      autoCancel: id != 1,
    );

    final NotificationDetails detalles = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: titulo,
      body: cuerpo,
      notificationDetails: detalles,
    );
  }
}

  static Future<bool> estanPermitidas() async {
    final bool? concedido = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.areNotificationsEnabled();

    // Si devuelve null, asumimos false por seguridad
    return concedido ?? false;
  }

  static Future<void> borrarTodasLasNotificaciones() async {
    await _notificationsPlugin.cancelAll();
  }
}
