import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

/// Logo oficial Terrasacha (`assets/Icons/logo.svg`).
///
/// El favicon (`assets/Icons/favicon.ico`) se conserva como referencia visual
/// del isotype para un futuro icono de launcher; no se usa en runtime.
class TerrasachaLogo extends StatelessWidget {
  final double height;
  final bool showSlogan;
  final Alignment alignment;
  final Color? color;

  const TerrasachaLogo({
    super.key,
    this.height = 40,
    this.showSlogan = false,
    this.alignment = Alignment.centerLeft,
    this.color,
  });

  /// Variante compacta para AppBars claras.
  const TerrasachaLogo.appBar({super.key, this.color})
      : height = 26,
        showSlogan = false,
        alignment = Alignment.centerLeft;

  /// Variante hero para login / splash.
  const TerrasachaLogo.hero({super.key})
      : height = 52,
        showSlogan = true,
        alignment = Alignment.center,
        color = null;

  static const assetPath = 'assets/Icons/logo.svg';

  @override
  Widget build(BuildContext context) {
    final logo = SvgPicture.asset(
      assetPath,
      height: height,
      fit: BoxFit.contain,
      semanticsLabel: 'Terrasacha',
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );

    if (!showSlogan) {
      return Align(alignment: alignment, child: logo);
    }

    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo,
          const SizedBox(height: 10),
          Text(
            'Pioneros del Mañana',
            style: TextStyle(
              fontFamily: 'ChampagneLimousinesBold',
              fontSize: 14,
              letterSpacing: 0.6,
              color: terrasachaSecondaryColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
