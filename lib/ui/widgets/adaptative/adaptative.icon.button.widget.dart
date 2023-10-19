import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdaptativeSVGIcon extends StatelessWidget {
  AdaptativeSVGIcon(
    this.svgImage, {
    super.key,
    required this.icon,
    this.colorFilter,
  });

  final String svgImage;
  final ColorFilter? colorFilter;
  final Widget icon;

  final PrincipalStore principalStore = sl();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (principalStore.temConexao == false && kIsWeb) {
          return icon;
        }
        return SvgPicture.asset(
          svgImage,
          colorFilter: colorFilter,
        );
      },
    );
  }
}
