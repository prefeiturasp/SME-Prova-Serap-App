import 'package:appserap/utils/string_util.dart';
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

String formatDateddMM(DateTime dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd/MM", 'pt_BR').format(dateTime);
}

String formatEddMMyyyy(DateTime dateTime) {
  if (dateTime == null) return "-";
  return DateFormat("dd/MM", 'pt_BR').format(dateTime);
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
