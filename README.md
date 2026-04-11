# PeakProFit
Aplicación iOS de entrenamiento enfocada en consulta de ejercicios, detalle técnico y gestión local de favoritos con una arquitectura limpia y mantenible.

## 1) Título + tagline breve
**PeakProFit** — App iOS de fitness para descubrir ejercicios, consultar su detalle y gestionar favoritos con una arquitectura limpia.

## 2) Resumen / Overview
**PeakProFit** es una app iOS construida con **SwiftUI** para explorar ejercicios de fitness, visualizar su detalle y guardar favoritos por usuario autenticado.

El proyecto está estructurado para separar responsabilidades:
- Presentación (Views + ViewModels)
- Dominio de datos (Entities)
- Capa de transporte (DTOs)
- Mapeo entre capas (Mappers)
- Red y persistencia desacopladas

También incorpora autenticación con Firebase y configuración por entornos mediante `xcconfig` + `Info.plist` para evitar hardcode de parámetros sensibles.

## 3) Funcionalidades principales (Key Features)
- Listado de ejercicios con recarga (`pull-to-refresh`).
- Pantalla de detalle por ejercicio.
- Carga de imágenes remotas con soporte para contenido animado.
- Login, registro y recuperación de contraseña.
- Modo invitado para acceso sin autenticación.
- Guardado/eliminación de favoritos en persistencia local.
- Feedback visual con `Snackbar` reutilizable.
- Launch Screen e icono de app configurados para iOS.

## 4) Stack tecnológico
- **Lenguaje:** Swift
- **UI:** SwiftUI
- **Arquitectura de presentación:** View + ViewModel (MVVM pragmático)
- **Networking:** `URLSession` (cliente HTTP propio)
- **Persistencia local:** CoreData + caché en filesystem
- **Autenticación:** Firebase Auth
- **Gestión de dependencias:** Swift Package Manager (SPM)
- **Carga de imágenes:** SDWebImageSwiftUI

## 5) Estructura del proyecto
```text
PeakProFit/
├─ App/
│  ├─ Auth/
│  ├─ Exercises/
│  ├─ Profile/
│  ├─ ContentView.swift
│  ├─ MainTabView.swift
│  ├─ PeakProFitApp.swift
│  └─ LaunchScreen.storyboard
├─ Assets.xcassets/
├─ Config/
│  ├─ AppConfig.swift
│  ├─ Debug.xcconfig
│  ├─ Release.xcconfig
│  └─ Local.xcconfig.example
├─ Models/
│  ├─ Dto/
│  ├─ Entity/
│  └─ Mapper/
├─ Networking/
│  ├─ APIClient.swift
│  ├─ DataSourceProtocol.swift
│  └─ DataSourceImplement.swift
├─ Persistence/
│  ├─ PersistenceController.swift
│  └─ FavoritesStore.swift
├─ UI/
│  ├─ Components/
│  └─ ViewModifier/
├─ Utils/
├─ PeakProFit.xcdatamodeld/
└─ Info.plist
```

### Explicación breve de carpetas
- `App/`: pantallas, navegación y composición de flujo.
- `Models/`: contratos de datos separados por rol (DTO/Entity/Mapper).
- `Networking/`: cliente HTTP y datasource remoto.
- `Persistence/`: CoreData y operaciones de favoritos.
- `UI/`: componentes y estilos reutilizables.
- `Config/`: configuración por entorno sin hardcode.

## 6) Arquitectura y flujo de datos
El flujo principal está orientado a separación de concerns:

```text
API (JSON)
  -> DTO (Decodable)
  -> Mapper
  -> Entity (modelo de dominio)
  -> ViewModel
  -> View (SwiftUI)
```

### Decisiones relevantes
- **DTO y Entity separados:** evita acoplar UI al formato exacto de backend.
- **Mappers explícitos:** centralizan transformación y facilitan evolución del API.
- **Datasource por protocolo:** permite sustituir implementación remota por mock/local sin tocar las vistas.

## 7) Networking
La capa de red se organiza alrededor de `APIClient`:
- `get<T: Decodable>(_ path: String)` genérico para decodificar respuestas.
- `getData(_ path:)` para descarga binaria (imágenes) con guardado en caché.
- Construcción de `URLRequest` y cabeceras en un único punto.
- Validación de status code y mapeo a errores de dominio (`APIClientError`).
- Logging básico en debug para diagnóstico de requests y respuestas.

### Estrategia de decoding
- Uso de `JSONDecoder` con `keyDecodingStrategy = .convertFromSnakeCase`.

### Errores centralizados
Errores representados en un enum propio (ej.: URL inválida, status inesperado, server error, not found, etc.), lo que simplifica mensajes y control de estados en ViewModels.

## 8) Configuración (xcconfig + Info.plist)
La app utiliza `xcconfig` para inyectar configuración en `Info.plist` y leerla desde `AppConfig`.

### Variables esperadas (placeholder seguro)
```text
API_BASE_URL = <API_BASE_URL>
RAPID_API_KEY = <RAPID_API_KEY>
```

### Ejemplo seguro de `Info.plist`
```xml
<key>API_BASE_URL</key>
<string>$(API_BASE_URL)</string>
<key>RAPID_API_KEY</key>
<string>$(RAPID_API_KEY)</string>
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>
```

### Recomendación operativa
- Mantener secretos en fichero local no versionado (por ejemplo `Local.xcconfig`).
- No hardcodear claves en código fuente.

## 9) Persistencia
Actualmente existe persistencia real en dos niveles:

1. **CoreData**
- `PersistenceController` inicializa `NSPersistentContainer`.
- `FavoritesStore` encapsula operaciones CRUD de ejercicios favoritos.
- Se publica notificación de cambios para refrescar vistas.

2. **Filesystem (caché)**
- Descargas de imagen se guardan en carpeta de caché para reutilización.

## 10) Dependencias de terceros
- FirebaseAuth
- FirebaseFirestore (integrada a nivel de dependencia; preparada para uso ampliado)
- SDWebImageSwiftUI

## 11) Cómo ejecutar
### Requisitos
- Xcode (versión reciente compatible con SwiftUI del proyecto)
- iOS Simulator (recomendado iPhone y iPad para validar layout universal)
- Configuración válida de Firebase para autenticación

### Pasos
1. Abrir `PeakProFit.xcodeproj` en Xcode.
2. Configurar valores de entorno en archivo local de configuración:
   - `API_BASE_URL`
   - `RAPID_API_KEY`
3. Verificar que `GoogleService-Info.plist` esté presente y adecuado para el entorno de ejecución.
4. Seleccionar esquema `PeakProFit`.
5. Ejecutar en simulador (iPhone + iPad).

## 12) Testing y calidad
En el estado actual no se observan targets de tests automatizados en el repositorio.

### Propuesta de mejora
- Añadir tests unitarios para:
  - Mappers (`DTO -> Entity`)
  - `APIClient` con `URLProtocol` mock
  - lógica de ViewModels (estados de loading/error/success)
- Añadir tests de UI para flujos críticos:
  - autenticación
  - listado/detalle
  - guardar/eliminar favoritos

## 13) Seguridad y privacidad
- Este README **no incluye** claves, IDs, tokens ni valores sensibles.
- Las configuraciones sensibles deben inyectarse por entorno (`xcconfig`) y nunca hardcodearse.
- Cualquier valor sensible detectado debe sustituirse por placeholders como:
  - `<API_BASE_URL>`
  - `<RAPID_API_KEY>`
  - `<FIREBASE_ENABLED>`

## 14) Roadmap
- Mejorar cobertura de tests (unit + UI).
- Introducir repositorio/interactor para desacoplar aún más casos de uso.
- Añadir estrategia de caché/expiración más robusta para recursos remotos.
- Consolidar sistema de diseño (tokens de color, tipografía y componentes).
- Preparar pipeline de CI (build + tests + lint).

## 15) Licencia
```text
<DEFINE_LICENSE_HERE>
```
