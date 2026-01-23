import 'package:flutter/material.dart';

// Colores del branding
const terrasachaPrimaryColor = Color(0xFF6e6c35); // Verde Selva
const terrasachaSecondaryColor = Color(0xFF44482c); // Verde Bosques Nublados
const terrasachaAccentColor = Color(0xFF849b50); // Verde Pradera
const terrasachaLightColor = Color(0xFFb1c181); // Verde Claro
const terrasachaYellowColor = Color(0xFFe8d79a); // Amarillo Tierra

// Tema de texto con las fuentes reales
final terrasachaTextTheme = TextTheme(
  titleLarge: TextStyle(
    fontFamily: 'Typographica',
    fontWeight: FontWeight.bold,
    color: terrasachaPrimaryColor,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Typographica',
    color: terrasachaSecondaryColor,
  ),
  titleMedium: TextStyle(
    fontFamily: 'ChampagneLimousinesBold',
    fontWeight: FontWeight.bold,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'FuturaBold',
    fontWeight: FontWeight.bold,
  ),
);

// Tema general de la app
final terrasachaTheme = ThemeData(
  primaryColor: terrasachaPrimaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: terrasachaPrimaryColor),
  textTheme: terrasachaTextTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: terrasachaPrimaryColor,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: terrasachaSecondaryColor,
      textStyle: const TextStyle(fontFamily: 'Typographica'),
    ),
  ),
);

//Ojala en el futuro añadir una version oscura de la aplicacion (Organizar en una carpeta, theme_light.dart y theme_dark.dart)
//Crear branch para ver el desarrollo con amplify