import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart';

void validateNotNull(Object value, String name) {
  if (value == null) {
    throw Exception(name + " não pode ser nulo.");
  }
}

bool isEmpty(dynamic value) {
  if (isNull(value)) return true;
  if (value is List) return value.isEmpty;
  if (value is String) return value.isEmpty;
  return false;
}

bool isNull(dynamic value) {
  if (value != null) {
    return false;
  } else {
    return true;
  }
}

bool isNotEmpty(dynamic value) {
  return !isEmpty(value);
}

bool isNotNull(dynamic value) {
  return !isNull(value);
}

bool isNullOrEmpty(dynamic value) {
  return value == null || isEmpty(value);
}

bool isNotNullOrEmpty(dynamic value) {
  return value != null && !isEmpty(value);
}

String getNextChaveIntegracao() {
  int numberRandom = 27061987;
  Random random = Random.secure();
  return random.nextInt(numberRandom).toString() + '-' + DateTime.now().toIso8601String();
}

String replaceLast(String string, String from, String to) {
  int lastIndex = string.lastIndexOf(from);
  if (lastIndex < 0) return string;
  String tail = string.substring(lastIndex).replaceFirst(from, to);
  return string.substring(0, lastIndex) + tail;
}

void prettyPrintJson(String input) {
  JsonDecoder decoder = JsonDecoder();
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  var object = decoder.convert(input);
  var prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((element) => print(element));
}

void prettyPrintMap(Map<String, dynamic> object) {
  print(object.toString().replaceAll(', ', ', \n\t').replaceAll("{", "{\n\t").replaceAll("}", "\n}"));
}

String normalize(var str) {
  var acentos = [
    "ç",
    "Ç",
    "á",
    "é",
    "í",
    "ó",
    "ú",
    "ý",
    "Á",
    "É",
    "Í",
    "Ó",
    "Ú",
    "Ý",
    "à",
    "è",
    "ì",
    "ò",
    "ù",
    "À",
    "È",
    "Ì",
    "Ò",
    "Ù",
    "ã",
    "õ",
    "ñ",
    "ä",
    "ë",
    "ï",
    "ö",
    "ü",
    "ÿ",
    "Ä",
    "Ë",
    "Ï",
    "Ö",
    "Ü",
    "Ã",
    "Õ",
    "Ñ",
    "â",
    "ê",
    "î",
    "ô",
    "û",
    "Â",
    "Ê",
    "Î",
    "Ô",
    "Û"
  ];
  var semAcento = [
    "c",
    "C",
    "a",
    "e",
    "i",
    "o",
    "u",
    "y",
    "A",
    "E",
    "I",
    "O",
    "U",
    "Y",
    "a",
    "e",
    "i",
    "o",
    "u",
    "A",
    "E",
    "I",
    "O",
    "U",
    "a",
    "o",
    "n",
    "a",
    "e",
    "i",
    "o",
    "u",
    "y",
    "A",
    "E",
    "I",
    "O",
    "U",
    "A",
    "O",
    "N",
    "a",
    "e",
    "i",
    "o",
    "u",
    "A",
    "E",
    "I",
    "O",
    "U"
  ];

  for (int i = 0; i < acentos.length; i++) {
    str = str.replaceAll(acentos[i], semAcento[i]);
  }

  return str;
}

String? formtNumberMask(String telefone, {bool useSpace = false}) {
  if (!isNullOrEmpty(telefone)) {
    String telefoneNotFormat = telefone.replaceAll("+", "").replaceAll(RegExp(r'[^0-9]'), '');
    String dd;

    if (telefoneNotFormat.length > 11) {
      dd = telefoneNotFormat.substring(2, 4);
    } else {
      dd = telefoneNotFormat.substring(0, 2);
    }

    String lastNumbers = telefone.substring(telefone.length - 4, telefone.length);

    if (useSpace) {
      return "(" + dd + ") " + " XXXXX-" + lastNumbers;
    }

    return dd + "XXXXX" + lastNumbers;
  }

  return null;
}
