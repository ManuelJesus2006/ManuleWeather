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
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('notifications') ?? false) {
      final AndroidNotificationDetails
      androidDetails = AndroidNotificationDetails(
        'canal_principal', // ID del canal (interno)
        'Notificaciones de la App', // Nombre del canal (lo ve el usuario en ajustes)
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        icon: 'ic_notifications_small',
        ongoing: id == 1, //Solo la notificacion del tiempo actual será la que se quede activa, las demás el usuario las podrá descartar
        autoCancel: id == 1 //La notificación del tiempo actual si se toca no se borrará automáticamente
      );

      NotificationDetails detalles = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.show(
        id: id, // ID de la notificación, 0 = Actualizaciones, 1 = Tiempo de hoy, del 2 para alante = Alertas
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
