class Utils{
    static String formatearHora(DateTime fecha) {
    // Añade un 0 a la izquierda si los minutos son menores de 10
    String minutos = fecha.minute < 10 ? '0${fecha.minute}' : '${fecha.minute}';
    return '${fecha.hour}:$minutos';
  }
  
  static String obtenerDiaSemana(int weekday) {
      switch(weekday){
        case 1:
          return 'Lunes';
        case 2:
          return 'Martes';
        case 3:
          return 'Miércoles';
        case 4:
          return 'Jueves';
        case 5:
          return 'Viernes';
        case 6:
          return 'Sábado';
        case 7:
          return 'Domingo';
        default: return 'Desconocido';
      }
    }

    static String obtenerMes(int mesNum) {
      switch (mesNum) {
        case 1:
          return 'enero';
        case 2:
          return 'febrero';
        case 3:
          return 'marzo';
        case 4:
          return 'abril';
        case 5:
          return 'mayo';
        case 6:
          return 'junio';
        case 7:
          return 'julio';
        case 8:
          return 'agosto';
        case 9:
          return 'septiembre';
        case 10:
          return 'octubre';
        case 11:
          return 'noviembre';
        case 12:
          return 'diciembre';
        default:
          return 'desconocido';
      }
    }
}