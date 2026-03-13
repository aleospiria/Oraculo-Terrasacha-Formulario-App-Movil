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
- Amplify CLI
- Cuenta AWS

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

## Instalación de Amplify CLI

Amplify CLI es la herramienta que permite configurar y desplegar los servicios backend utilizados por la aplicación.

### Instalar Amplify CLI

Se instala usando npm:

```bash
npm install -g @aws-amplify/cli
```
Verificar instalación:
```bash
amplify --version
```

## Configuración del Proyecto

Clonar este repositorio:

```bash
git clone https://github.com/aleospiria/Oraculo-Terrasacha-Formulario-App-Movil
```

Entra a la carpeta del proyecto:

```bash
cd Oraculo-Terrasacha-Formulario-App-Movil
```

Obtén las dependencias:

```bash
flutter pub get
```
## Configurar Amplify (por primera vez, una vez por máquina)

Si nunca se a configurado amplify en la maquina actual, se debe configurar:

```bash
amplify configure
```

Crear usuario o iniciar sesion con las credenciales (Access key y Secret access key) si ya se tiene.

## Traer el backend existente

Se ejecuta un pull para traer archivos como el **amplifyconfiguratio.dart**:

```bash
amplify pull
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