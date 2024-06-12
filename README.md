# Gestor

## Introducción

Gestor es un proyecto inicial (starter) desarrollado con Flutter para crear aplicaciones multiplataforma. Disponible en iOS, Android y Web, Gestor proporciona una base sólida y funcional para gestionar tareas y proyectos.

## Características

- **Gestión de Tareas**: Crea, edita y elimina tareas.
- **Proyectos**: Organiza tareas en proyectos.
- **Notificaciones**: Recibe recordatorios de tareas.
- **Multiplataforma**: Compatible con iOS, Android y Web.
- **Modo Oscuro**: Interfaz adaptable a tus preferencias.

## Instalación

### Requisitos Previos

- Flutter SDK: [Instrucciones de instalación](https://flutter.dev/docs/get-started/install)
- Dart SDK: Incluido con Flutter.
- Android Studio / Xcode: Para ejecutar en dispositivos Android y iOS.

### Ejecución del Proyecto

0. **extras**
   1. flutter pub cache repair
1. **Instalar dependencias::**
   `flutter pub get`
2. **Ejecutar en dispositivos:**

```
***web***
- flutter run -d chrome --web-port=3000
***movile***
- flutter emulators --launch Pixel 3a API 32 (flutter devices to show)
- flutter run
```

4. **how to create a build**

- for web: `flutter build web --output ./web-prod`
- for android:`.`
- for ios:`.`

3. Estructura del Proyecto
   Para mantener el proyecto organizado y escalable, utilizamos la siguiente estructura de carpetas:

```
gestor
├── lib
│   ├── src
│   │   ├── models            // Modelos de datos
│   │   ├── screens           // Pantallas de la aplicación
│   │   ├── widgets           // Componentes reutilizables
│   │   ├── services          // Servicios y lógica de negocio
│   │   ├── providers         // Providers para manejo de estado
│   │   └── utils             // Utilidades y helpers
│   ├── main.dart             // Punto de entrada de la aplicación
├── test                      // Pruebas unitarias y de integración
├── pubspec.yaml              // Archivo de configuración de Flutter
└── README.md                 // Archivo README


```

