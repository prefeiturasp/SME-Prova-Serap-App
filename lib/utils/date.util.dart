import 'package:appserap/utils/string.util.dart';
import 'package:intl/intl.dart';

String formatDate(String format, int timestamp) {
  return DateFormat(format, 'pt_BR').format(
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
  );
}

String formatDatedddeMMMdeyyykkmm(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd 'de' MMMM 'de' yyyy, kk:mm", 'pt_BR').format(dateTime);
}

String formatDateddMMyyykkmm(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd/MM/yyyy kk:mm", 'pt_BR').format(dateTime);
}

String formatDateddMMyyyy(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd/MM/yyyy", 'pt_BR').format(dateTime);
}

String formatDatedMMMMyyyy(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("d 'de' MMMM 'de ' yyyy", 'pt_BR').format(dateTime);
}

String formatDateddMM(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd/MM", 'pt_BR').format(dateTime);
}

String formatEddMMyyyy(DateTime? dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("E - dd/MM/yyyy", 'pt_BR').format(dateTime);
}

DateTime getDate([DateTime? dateTime]) {
  dateTime ??= DateTime.now();
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime? rawDateTime(t) {
  if (isNotNull(t)) {
    if (t is DateTime) {
      return t;
    } else {
      try {
        return DateTime.parse(t);
      } catch (err) {
        return DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
      }
    }
  }
  return null;
}

String fmtHora(num hora) {
  String horaStr = hora.toString();
  if (hora > 0) {
    return horaStr.substring(0, horaStr.length - 2) + ":" + horaStr.substring(horaStr.length - 2);
  } else {
    return "00:00";
  }
}

DateTime? getDateTime(int? time, {bool isInMillisecond = true, bool isInNum = false}) {
  if (time == null) {
    return null;
  }
  DateTime? dateTime;

  if (isInMillisecond) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  } else {
    dateTime = DateTime.fromMillisecondsSinceEpoch((time) * 1000);
  }

  return dateTime;
}

int getTicks(DateTime data) {
  const _epochTicks = 621355968000000000;
  return data.microsecondsSinceEpoch * 10 + _epochTicks;
}

extension TicksOnDateTime on DateTime {
  int get ticks {
    const _epochTicks = 621355968000000000;
    return microsecondsSinceEpoch * 10 + _epochTicks;
  }
}

/// Retorna uma string formatada com a Duration [d] e ignora caso for 0
String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('$days dias');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('$hours horas');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('$minutes min');
  }
  if (tokens.length < 2) {
    tokens.add('$seconds s');
  }

  return tokens.join(' ');
}
