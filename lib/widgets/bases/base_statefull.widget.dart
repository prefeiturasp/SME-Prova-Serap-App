import 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  final String? title;
  const BaseStatefulWidget({Key? key, this.title}) : super(key: key);
}
