# Terrasacha - App de Captura Forestal.

Este proyecto es una aplicación móvil desarrollada en Flutter para la captura de datos forestales en campo, con sincronización con backend AWS y futura trazabilizacion con .

---

## Contenido

- [Introducción](#introducción)
- [Requisitos](#requisitos)
- [Instalación de Flutter](#instalación-de-flutter)
- [Configuración del Proyecto](#configuración-del-proyecto)
- [Ejecución](#ejecución)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Documentación Técnica](#documentación-técnica)

---

## Introducción

Terrasacha es una app multiplataforma (Android/iOS) que permite registrar datos de arboles segun su proyecto, predio y parcela, garantizando la integridad de la información mediante blockchain(futuro). Los datos se sincronizan con un backend AWS para asegurar trazabilidad y auditoría.

---

## Requisitos

- Flutter SDK (versión 3.38.5 o superior)
- Android Studio o Visual Studio Code (O cualquier otro IDE que tenga soporte con Flutter)
- Java JDK (17 o superior)
- Android SDK
- Dispositivo o emulador Android/iOS

---

## Instalación de Flutter

Flutter es un framework UI multiplataforma desarrollado por Google para crear aplicaciones nativas para móvil, web y escritorio desde una única base de código.

Para instalar Flutter:

1. Visita la página oficial: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Sigue las instrucciones específicas para el sistema operativo correcto (Windows, macOS, Linux).
3. Verifica la instalación ejecutando en terminal:

Hay que poner el PATH para que "flutter" funcione en cualquier terminal

### Windows

Ir a "Variables de entorno" y en PATH, se selecciona la carpeta /bin de flutter en donde se haya instalado

### Linux/macOs

Abrir en algun editor de texto (En este ejemplo nano) 

```bash
nano ~/.bashrc
```

y al final del archivo, añadir esta linea:

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```
Comandos para guardar Nano:
Ctrl+O = Guardar cambios
Enter = Confirmar
Ctrl+X = Salir

Y se reinicia la terminal.

## Verificacion

```bash
flutter doctor
```

Este comando te indicará si tienes todo configurado correctamente.

## Configuración del Proyecto

Clona este repositorio:

```bash
git clone https://github.com/tu-usuario/terrasacha.git
```

Entra a la carpeta del proyecto:

```bash
cd terrasacha
```

Obtén las dependencias:

```bash
flutter pub get
```
(Opcional) Genera código adicional si se usa build_runner:

```bash
flutter pub run build_runner build
```
## Ejecución

Para correr en modo debug(pruebas):

```bash
flutter run
```

Para generar APK (producción):

```bash
flutter build apk --release
```

## Estructura del Proyecto

```
terrasacha/
├── lib/
│ ├── models/ # Modelos de datos (Predio, Parcela, etc.)
│ ├── screens/ # Pantallas (Formulario, Historial, Menús)
│ ├── db/ # Helper de SQLite / Data access
│ ├── amplifyconfiguration.dart # Configuracion de amplify
│ └── main.dart # Punto de entrada de la app
├── android/ # Configuración nativa Android
├── ios/ # Configuración nativa iOS
├── assets/ # Recursos estáticos (imágenes, fuentes)
├── pubspec.yaml # Dependencias y assets
├── README.md # Instrucciones generales (este archivo)
└── DOCUMENTACION.md # Documentación técnica
```