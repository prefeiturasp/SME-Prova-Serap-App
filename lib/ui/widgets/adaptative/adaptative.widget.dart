import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:flutter/material.dart';

enum AdaptativeWidgetMode { AUTO, ROW, COLUMN }

class AdaptativeWidget extends StatelessWidget {
  final List<Widget> children;
  final AdaptativeWidgetMode mode;

  const AdaptativeWidget({
    Key? key,
    required this.children,
    this.mode = AdaptativeWidgetMode.AUTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case AdaptativeWidgetMode.AUTO:
        if (kIsMobile) {
          return _buildColumn();
        } else {
          return _buildRow();
        }
      case AdaptativeWidgetMode.ROW:
        return _buildRow();
      case AdaptativeWidgetMode.COLUMN:
        return _buildColumn();
    }
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  _buildRow() {
    return Row(
      children: children,
    );
  }
}
