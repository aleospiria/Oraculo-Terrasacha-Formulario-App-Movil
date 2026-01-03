# Oráculo Terrasacha – Formulario App Móvil

## 🎯 Objetivo de la App

Desarrollar un nuevo proyecto en **Flutter (multiplataforma)** para crear una herramienta tipo formulario que permita:

- Capturar datos
- Guardarlos localmente
- Sincronizarlos posteriormente con la nube

---

## ⚙️ Requisitos Funcionales

- Por definir

---

## 🔒 Requisitos No Funcionales

- Por definir

---

## 🏗️ Arquitectura del Proyecto

Por completar. Actualmente se contemplan los siguientes componentes:

### 📱 Cliente

Corresponde a todo lo que ve y usa el usuario en el dispositivo móvil:

- Peticiones
- Vistas
- Exportaciones a CSV
- Interacción general con la aplicación

### 💾 Backend Local

Encargado de la lógica interna de la aplicación:

- Construcción de *schemas*
- Almacenamiento local de datos
- Sincronización con la nube cuando haya conexión

### ☁️ Backend Externo

Destino final de los datos ya estructurados, donde se completa la sincronización mediante **GraphQL**.

---

## 🔄 Diagrama de Flujo del Proyecto

Se construyó un diagrama de flujo que modela el comportamiento de la aplicación tipo formulario, mostrando el ciclo completo desde la captura de datos hasta la sincronización con la nube.

<img width="719" height="781" alt="DiagramaFlujoFormularioOraculo drawio" src="https://github.com/user-attachments/assets/2555c834-b5d0-4594-b478-ba08518e79f4" />


El diagrama se divide en dos flujos:

- **Lado izquierdo:** Interacción del usuario con la aplicación
- **Lado derecho:** Proceso de sincronización automática de la app

---

## 📝 Flujo de Captura de Datos (Lado Izquierdo)

1. **Inicio de la aplicación**  
   El usuario abre la aplicación móvil e inicia el flujo.

2. **Menú Proyectos**
    - Crear un nuevo proyecto (nombre o ID único)
    - Seleccionar un proyecto existente  
      Al finalizar, se accede al **Menú de Parcelas**.

3. **Menú Parcelas**
    - Crear una nueva parcela
    - Seleccionar una parcela existente

4. **Captura de datos**
   El usuario diligencia un formulario con:
    - Fecha
    - Coordenadas
    - Observaciones
    - Mediciones
    - Otros datos relevantes

5. **Validación de datos**
    - El sistema valida integridad y formato
    - Si hay errores, el usuario debe corregirlos

6. **Almacenamiento local**
    - Los datos se guardan en el dispositivo
    - La app funciona **offline**
    - Los registros quedan marcados como *pendientes de sincronización*

---

## ☁️ Flujo de Sincronización con la Nube (Lado Derecho)

1. **Inicio de sincronización**
    - El usuario inicia la sincronización desde el menú

2. **Verificación de conexión**
    - Se valida conexión WiFi o datos móviles
    - Si no hay conexión, se muestra un error

3. **Verificación de datos pendientes**
    - Se comprueba si existen registros por sincronizar
    - Si no existen, se notifica al usuario

4. **Envío de datos**
    - Los datos se envían a la nube mediante una petición **API**

5. **Validación del envío**
    - Si ocurre un error, los datos permanecen en local
    - Se muestra un mensaje de fallo

6. **Gestión de datos locales**
    - Si el envío es exitoso, los datos se marcan como sincronizados
    - Se conservan por **7 días** como respaldo
    - Luego se eliminan automáticamente

---

##  Avances del Proyecto (MVP - 29/12/2025)

- Implementación del formulario de captura de datos con validaciones y obtención de coordenadasFalsas.
- Diseño y aplicación del tema visual personalizado según el branding de Terrasacha.
- Actualización del framework Flutter a la versión más reciente para compatibilidad con dependencias.
- Recepción y análisis del endpoint y API Key de AWS AppSync para consumo de la API GraphQL.
- Estudio y comprensión del esquema GraphQL (`schema.graphql`) para planear la integración.
- Decisión estratégica de consumir la API GraphQL directamente con `graphql_flutter`, descartando el uso de Amplify CLI y DataStore para simplificar el desarrollo.
- Implementación de manejo básico de errores en navegación para facilitar la depuración.
- Eliminación temporal de la configuración de Amplify para estabilizar la aplicación y evitar errores críticos.

<div align="center">
  <img src="https://github.com/user-attachments/assets/cc4d3082-1408-448a-bf33-101458860894" alt="CapturaDatosNuevo" width="300" />
</div>

>Screen de captura de datos actualmente


> Se añadio un instalador para Android (Se esta trabajando en el de Iphone por motivos de licencia de Apple)

---

##  Avances del Proyecto (v0.2.0 - 03/01/2026)

- Implementación completa de base de datos local para guardado de registros offline, con creacion de nuevas Pantallas para Logica y navegacion:
   - **CapturaDatosScreen**: formulario para crear y editar registros con validación y guardado local en estado 'pendiente'.

<div align="center" style="margin: 20px 0;">
  <img src="https://github.com/user-attachments/assets/3e3455b4-2eae-4560-97b0-2dec14804f9c" alt="CapturaDatosNuevo" width="300" style="margin: 10px 20px;" />
  <img src="https://github.com/user-attachments/assets/81febc98-cf8d-4a4b-af7f-f141fa72efd3" alt="CapturaDatosNuevo" width="300" style="margin: 10px 20px;" /> 
</div>



- **RevisionScreen**: pantalla de revisión en modo solo lectura con opción a editar registros en estado 'pendiente'.

<div align="center" style="margin: 20px 0;">
  <img src="https://github.com/user-attachments/assets/27f26f35-e787-4c5a-9314-82cb67407120" alt="CapturaDatosNuevo" width="300" />
</div>


- **RegistrosGuardadosScreen**: listado de registros guardados localmente, con navegación a revisión y actualización automática al volver.

<div align="center" style="margin: 20px 0;">
  <img src="https://github.com/user-attachments/assets/d7a4692b-3aa2-4595-acdb-3bfc20b2f259" alt="CapturaDatosNuevo" width="300" />
</div>


- Desarrollo de persistencia local usando SQLite a través de la clase `LocalDatabase`, con métodos para insertar, consultar y **editar** registros.

<div align="center" style="margin: 20px 0;">
  <img src="https://github.com/user-attachments/assets/2dac9255-26d5-4ee9-aa12-609cde5304a5" alt="CapturaDatosNuevo" width="300" />
</div>


- Integración de navegación entre pantallas para permitir crear, revisar, editar y listar registros de forma fluida y consistente.
- Manejo del estado 'pendiente' para diferenciar registros editables de los sincronizados (futuros avances).
- Preparación del código para futura sincronización con backend en nube.
- Corrección de errores de compilación y mejora en la estructura del código para escalabilidad.

---

