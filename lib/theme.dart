import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Paleta Terrasacha (terrasacha-design.json) ──────────────────────────────
/// Verde Selva — color primario de marca
const terrasachaPrimaryColor = Color(0xFF6E6C35);

/// Verde Bosques Nublados — secundario / énfasis fuerte
const terrasachaSecondaryColor = Color(0xFF44482C);

/// Verde Pradera — acento / acciones secundarias
const terrasachaAccentColor = Color(0xFF849B50);

/// Verde Claro — fondos suaves / chips
const terrasachaLightColor = Color(0xFFB1C181);

/// Amarillo Tierra — highlights / avisos suaves
const terrasachaYellowColor = Color(0xFFE8D79A);

/// Fondo de pantallas (derivado de la paleta clara)
const terrasachaBackgroundColor = Color(0xFFF7F8F4);

/// Superficie de cards / paneles
const terrasachaCardColor = Color(0xFFEEF2E6);

/// Alias usados en pantallas existentes
const terrasachaBrand = terrasachaPrimaryColor;

/// Tipografía legible para inputs (correo, contraseñas, códigos).
/// Typographica es display y renderiza mal glifos como `@`.
const terrasachaInputTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontFamilyFallback: <String>['sans-serif', 'Arial'],
  color: terrasachaSecondaryColor,
  fontSize: 16,
  height: 1.3,
  letterSpacing: 0.15,
);

/// Teclado: primera letra de cada oración en mayúscula.
const terrasachaCapitalizacionTexto = TextCapitalization.sentences;

/// Fuerza mayúscula en la primera letra alfabética del campo (aunque el
/// teclado envíe minúscula).
class TerrasachaPrimeraMayusculaFormatter extends TextInputFormatter {
  const TerrasachaPrimeraMayusculaFormatter();

  static final _letra = RegExp(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (!_letra.hasMatch(ch)) continue;
      final upper = ch.toUpperCase();
      if (upper == ch) return newValue;
      return TextEditingValue(
        text: text.replaceRange(i, i + 1, upper),
        selection: newValue.selection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

/// Formatters por defecto para inputs de texto libre.
List<TextInputFormatter> terrasachaFormattersTexto([
  List<TextInputFormatter> extra = const [],
]) {
  return <TextInputFormatter>[
    const TerrasachaPrimeraMayusculaFormatter(),
    ...extra,
  ];
}

final terrasachaColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: terrasachaPrimaryColor,
  onPrimary: Colors.white,
  primaryContainer: terrasachaLightColor,
  onPrimaryContainer: terrasachaSecondaryColor,
  secondary: terrasachaSecondaryColor,
  onSecondary: Colors.white,
  secondaryContainer: terrasachaAccentColor.withValues(alpha: 0.25),
  onSecondaryContainer: terrasachaSecondaryColor,
  tertiary: terrasachaAccentColor,
  onTertiary: Colors.white,
  tertiaryContainer: terrasachaYellowColor,
  onTertiaryContainer: terrasachaSecondaryColor,
  error: const Color(0xFFB3261E),
  onError: Colors.white,
  surface: Colors.white,
  onSurface: terrasachaSecondaryColor,
  surfaceContainerHighest: terrasachaCardColor,
  outline: terrasachaLightColor,
  outlineVariant: const Color(0xFFD5D9C8),
);

final terrasachaTextTheme = TextTheme(
  titleLarge: const TextStyle(
    fontFamily: 'Typographica',
    fontWeight: FontWeight.bold,
    color: terrasachaPrimaryColor,
  ),
  titleMedium: const TextStyle(
    fontFamily: 'ChampagneLimousinesBold',
    fontWeight: FontWeight.bold,
    color: terrasachaSecondaryColor,
  ),
  headlineSmall: const TextStyle(
    fontFamily: 'FuturaBold',
    fontWeight: FontWeight.bold,
    color: terrasachaSecondaryColor,
  ),
  // Cuerpo / inputs: fuente de sistema (Typographica falla con @ y dígitos).
  bodyLarge: terrasachaInputTextStyle,
  bodyMedium: terrasachaInputTextStyle.copyWith(fontSize: 14),
  labelLarge: const TextStyle(
    fontFamily: 'Typographica',
    fontWeight: FontWeight.w600,
    color: terrasachaPrimaryColor,
  ),
);

final terrasachaTheme = ThemeData(
  useMaterial3: true,
  primaryColor: terrasachaPrimaryColor,
  scaffoldBackgroundColor: terrasachaBackgroundColor,
  colorScheme: terrasachaColorScheme,
  textTheme: terrasachaTextTheme,
  // Tipografía de marca solo en títulos; el cuerpo usa bodyLarge/bodyMedium.
  appBarTheme: const AppBarTheme(
    backgroundColor: terrasachaPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: terrasachaPrimaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontFamily: 'Typographica',
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: terrasachaPrimaryColor,
      side: const BorderSide(color: terrasachaPrimaryColor),
      textStyle: const TextStyle(fontFamily: 'Typographica'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: terrasachaPrimaryColor,
    foregroundColor: Colors.white,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: terrasachaPrimaryColor,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: terrasachaPrimaryColor,
    unselectedItemColor: Color(0xFF8A8E7A),
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: terrasachaCardColor,
    selectedColor: terrasachaLightColor,
    labelStyle: const TextStyle(fontFamily: 'Typographica'),
    secondaryLabelStyle: const TextStyle(fontFamily: 'Typographica'),
    side: BorderSide.none,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: terrasachaInputTextStyle.copyWith(
      color: const Color(0xFF9AA08A),
      fontSize: 15,
    ),
    labelStyle: terrasachaInputTextStyle.copyWith(fontSize: 14),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: terrasachaPrimaryColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD5D9C8)),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  cardTheme: CardThemeData(
    color: terrasachaCardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
);
