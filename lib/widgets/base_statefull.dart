import 'package:flutter/material.dart';

abstract class BaseStateful extends StatefulWidget {
  final String? title;
  const BaseStateful({Key? key, this.title}) : super(key: key);
}
