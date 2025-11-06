import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

Widget logoUnipar([double escala = 1]) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Gap para alinhamento ótico, visto que a logo da Unipar é mais densa na parte esquerda.
      SizedBox(width: (25 * escala)),
      ScalableImageWidget.fromSISource(
        si: ScalableImageSource.fromSvg(
          rootBundle,
          'assets/images/logo_unipar.svg',
        ),
        scale: escala,
      ),
    ],
  );
}
