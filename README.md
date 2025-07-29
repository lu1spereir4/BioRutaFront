# BioRuta GPS-G7
**Solución Integral de Transporte Estudiantil Universitario**

Proyecto desarrollado para la asignatura de Gestión de Proyectos de Software del primer semestre 2025, Universidad del Bío Bío.

<img width="128" alt="BioLogo" src="https://github.com/user-attachments/assets/4780cda8-801e-48c8-bc65-76d0ef1f41eb">

## 📋 Descripción del Proyecto

BioRuta es una aplicación móvil innovadora diseñada para optimizar el transporte estudiantil en la Universidad del Bío Bío. La plataforma conecta conductores y pasajeros de manera segura y eficiente, promoviendo la movilidad sostenible y reduciendo costos de transporte para la comunidad universitaria.

## 🚀 Características Principales

### 👥 Sistema de Usuarios
- **Registro y autenticación** con validación universitaria
- **Perfiles completos** con información de contacto y emergencia
- **Sistema de amistades** para construir redes de confianza
- **Ranking de usuarios** basado en calificaciones y comportamiento

### 🗺️ Gestión de Viajes
- **Publicación de viajes** con origen, destino y detalles
- **Búsqueda avanzada** por ubicación, fecha y precio
- **Solicitudes de unión** con sistema de aprobación
- **Tracking en tiempo real** durante el viaje
- **Historial completo** de viajes realizados

### 💬 Comunicación Integrada
- **Chat grupal** para coordinación de viajes
- **Chat personal** entre usuarios
- **Notificaciones push** para eventos importantes
- **Sistema de mensajería** en tiempo real

### 🔒 Seguridad y Confianza
- **Verificación universitaria** obligatoria
- **Contactos de emergencia** configurables
- **Sistema SOS** con alertas automáticas
- **Calificaciones y comentarios** post-viaje

### 💳 Gestión Financiera
- **Cálculo automático** de costos compartidos
- **Historial de transacciones** detallado
- **Diferentes métodos de pago** disponibles

## 🛠️ Arquitectura Tecnológica

### Frontend
- **Flutter**: Framework multiplataforma para desarrollo móvil
- **Dart**: Lenguaje de programación principal
- **Android Studio**: Entorno de desarrollo integrado
- **Material Design**: Sistema de diseño para UI/UX consistente

### Backend
- **Node.js**: Runtime de JavaScript del lado servidor
- **Express.js**: Framework web minimalista y flexible
- **Socket.io**: Comunicación en tiempo real
- **JWT**: Autenticación basada en tokens

### Base de Datos
- **PostgreSQL**: Sistema de gestión de base de datos relacional
- **MongoDB**: Sistema de gestión NOSQL 
- **TypeORM**: ORM para manejo de entidades y relaciones
- **Migraciones**: Control de versiones de esquema de BD

### APIs y Servicios Externos
- **OpenStreetMap**: Mapas y geolocalización
- **Nominatum¨**: Sugerencias de lugares

### DevOps y Deployment
- **Git**: Control de versiones
- **GitHub**: Repositorio y colaboración

## 📱 Funcionalidades por Módulo

### Autenticación y Perfiles
- ✅ Registro con validación de correo universitario
- ✅ Login seguro con JWT
- ✅ Gestión de perfiles personales
- ✅ Configuración de contactos de emergencia
- ✅ Sistema de verificación de identidad

### Gestión de Amistades
- ✅ Envío y recepción de solicitudes
- ✅ Administración de lista de amigos
- ✅ Sistema de notificaciones para solicitudes
- ✅ Búsqueda de usuarios por RUT/nombre

### Publicación y Búsqueda de Viajes
- ✅ Crear viajes con detalles completos
- ✅ Búsqueda geográfica avanzada
- ✅ Filtros por fecha, precio y disponibilidad
- ✅ Vista de mapa interactiva
- ✅ Gestión de solicitudes de pasajeros

### Comunicación
- ✅ Chat grupal por viaje
- ✅ Chat personal entre usuarios
- ✅ Notificaciones push en tiempo real
- ✅ Historial de conversaciones

### Seguridad
- ✅ Botón SOS con alertas automáticas
- ✅ Contactos de emergencia configurables
- ✅ Sistema de reporte de usuarios
- ✅ Moderación de contenido

### Pagos y Finanzas
- 🔄 Integración con WebPay (en desarrollo)
- 🔄 Cálculo automático de costos
- 🔄 Historial de transacciones
- 🔄 Sistema de reembolsos

## 🏗️ Estructura del Proyecto

```
BioRuta/
├── backend/                 # Servidor Node.js + Express
│   ├── src/
│   │   ├── controllers/     # Lógica de controladores
│   │   ├── entities/        # Modelos de base de datos
│   │   ├── routes/          # Definición de rutas API
│   │   ├── services/        # Lógica de negocio
│   │   ├── middlewares/     # Middlewares personalizados
│   │   ├── config/          # Configuraciones del sistema
│   │   └── utils/           # Utilidades generales
│   └── package.json         # Dependencias backend
│
├── frontend/                # Aplicación Flutter
│   ├── lib/
│   │   ├── auth/            # Módulo de autenticación
│   │   ├── mapa/            # Módulo de mapas y geolocalización
│   │   ├── viajes/          # Gestión de viajes
│   │   ├── chat/            # Sistema de mensajería
│   │   ├── perfil/          # Gestión de perfiles
│   │   ├── services/        # Servicios API y WebSocket
│   │   ├── widgets/         # Componentes reutilizables
│   │   └── utils/           # Utilidades y helpers
│   ├── android/             # Configuración Android
│   ├── ios/                 # Configuración iOS
│   └── pubspec.yaml         # Dependencias Flutter
│
└── README.md                # Documentación del proyecto
```

## 🔧 Configuración y Desarrollo

### Prerrequisitos
- **Node.js** (v16 o superior)
- **Flutter SDK** (v3.0 o superior)
- **PostgreSQL** (v12 o superior)
- **Android Studio** y **VS Code**
- **Git** para control de versiones

### Instalación Backend
```bash
cd backend/
npm install
npm run dev
```

### Instalación Frontend
```bash
cd frontend/
flutter pub get
flutter run
```

## 🏆 Reconocimientos

Este proyecto representa el esfuerzo colaborativo de un equipo multidisciplinario comprometido con la innovación en movilidad estudiantil y el desarrollo de software de calidad empresarial.

**Universidad del Bío Bío - Facultad de Ciencias Empresariales** 
**Gestión de Proyectos de software** 
**Ingeniería Civil en Informática - 2025**

---

## 🏅 Roles y Responsabilidades

<table>
  <tr>
    <th>Foto</th>
    <th>Integrante</th>
    <th>Rol Principal</th>
    <th>Especialización</th>
    <th>Contribuciones Clave</th>
  </tr>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/JoMULLOA" width="60px;" alt="JoMULLOA"/>
    </td>
    <td><a href="https://github.com/JoMULLOA"><strong>José Manríquez</strong></a></td>
    <td>Project Manager & Full-Stack Developer</td>
    <td>Gestión de usuarios y flujo de autenticación</td>
    <td>
      Gestión de usuarios, vehículos y reportes, sistema de amistades,<br>
      login/logout, registro con Nodemailer
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/Joaqomv" width="60px;" alt="Joaqomv"/>
    </td>
    <td><a href="https://github.com/Joaqomv"><strong>Joaquín Maureira</strong></a></td>
    <td>Full-Stack Developer</td>
    <td>Ranking, métricas y lógica de negocio</td>
    <td>
      Ranking y sistema de puntuación, estadísticas para administrador,<br>
      cálculo automático de pasajes
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/KrozJGG" width="60px;" alt="KrozJGG"/>
    </td>
    <td><a href="https://github.com/KrozJGG"><strong>Christian Jamett</strong></a></td>
    <td>Full-Stack Developer</td>
    <td>Interfaz de usuario y funcionalidades de viaje</td>
    <td>
      Gestión de pagos, solicitud de viaje con notificación,<br>
      unión/cancelación/salida de viaje, detalles de viaje,<br>
      integración con API OpenStreetMap
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/lu1spereir4" width="60px;" alt="lu1spereir4"/>
    </td>
    <td><a href="https://github.com/lu1spereir4"><strong>Luis Pereira</strong></a></td>
    <td>Full-Stack Developer</td>
    <td>Búsqueda, publicación y servicios en tiempo real</td>
    <td>
      Publicación y búsqueda dinámica de viajes, sistema SOS para pasajeros,<br>
      sugerencias de búsqueda con API Nominatim
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/Sternen-prince" width="60px;" alt="Sternen-prince"/>
    </td>
    <td><a href="https://github.com/Sternen-prince"><strong>Francisco Cisterna</strong></a></td>
    <td>Full-Stack Developer</td>
    <td>Chat y control de mensajes</td>
    <td>
      Chat grupal e individual, edición y eliminación de mensajes,<br>
      pruebas de calidad y documentación técnica
    </td>
  </tr>
</table>


## 📜 Licencia y Términos

**BioRuta** es un proyecto académico desarrollado bajo supervisión universitaria. El código fuente está disponible para fines educativos y de investigación.

### Derechos de Autor
© 2025 - Equipo GPS-G7, Universidad del Bío Bío. Todos los derechos reservados.

### Términos de Uso Académico
- ✅ Uso para investigación y educación
- ✅ Referencia y citación permitida
- ✅ Contribuciones de la comunidad bienvenidas
- ❌ Uso comercial sin autorización

---

<div align="center">
  <h3>🎓 Universidad del Bío Bío - 2025</h3>
  <p><em>"Innovando en movilidad estudiantil para una universidad más conectada"</em></p>
  
  [![GitHub Stars](https://img.shields.io/github/stars/JoMULLOA/BioRuta?style=social)](https://github.com/JoMULLOA/BioRuta)
  [![GitHub License](https://img.shields.io/github/license/JoMULLOA/BioRuta)](https://github.com/JoMULLOA/BioRuta/blob/main/LICENSE)
</div>
