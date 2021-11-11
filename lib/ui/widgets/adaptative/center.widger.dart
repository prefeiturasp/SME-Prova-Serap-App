import 'package:flutter/widgets.dart';

class AdaptativeCenter extends StatelessWidget {
  final bool center;
  final Widget child;

  const AdaptativeCenter({
    Key? key,
    required this.center,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (center) {
      return Center(
        child: child,
      );
    } else {
      return child;
    }
  }
}
