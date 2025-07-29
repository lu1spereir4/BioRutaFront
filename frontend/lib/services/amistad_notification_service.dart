import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'websocket_notification_service.dart';
import 'amistad_service.dart';
import '../config/confGlobal.dart';
import '../utils/token_manager.dart';

/// Servicio para manejar notificaciones de amistad
/// Hace polling a las rutas del backend para detectar cambios y mostrar notificaciones
class AmistadNotificationService {
  static Timer? _pollingTimer;
  static bool _isPolling = false;
  
  // Cache para detectar cambios
  static List<Map<String, dynamic>> _ultimasSolicitudes = [];
  static List<Map<String, dynamic>> _ultimosAmigos = [];
  
  // Configuración del polling
  static const Duration _pollingInterval = Duration(seconds: 10); // Cada 10 segundos
  
  /// Inicializar el servicio y comenzar polling
  static Future<void> initialize(String userRut) async {
    print('✅ AMISTAD NOTIFICATIONS - Servicio inicializado para usuario: $userRut');
    
    // Inicializar datos actuales sin notificar
    await _cargarDatosIniciales();
    
    // Comenzar polling
    _iniciarPolling();
  }
  
  /// Cargar datos iniciales (sin notificar)
  static Future<void> _cargarDatosIniciales() async {
    try {
      print('🔄 AMISTAD NOTIFICATIONS - Cargando datos iniciales...');
      
      // Cargar solicitudes pendientes
      final solicitudes = await _obtenerSolicitudesPendientes();
      _ultimasSolicitudes = List.from(solicitudes);
      
      // Cargar amigos actuales
      final amigos = await _obtenerAmigos();
      _ultimosAmigos = List.from(amigos);
      
      print('✅ AMISTAD NOTIFICATIONS - Datos iniciales cargados:');
      print('   - Solicitudes pendientes: ${_ultimasSolicitudes.length}');
      print('   - Amigos: ${_ultimosAmigos.length}');
      
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error cargando datos iniciales: $e');
    }
  }
  
  /// Iniciar polling para detectar cambios
  static void _iniciarPolling() {
    if (_isPolling) {
      print('⚠️ AMISTAD NOTIFICATIONS - Polling ya está activo');
      return;
    }
    
    _isPolling = true;
    print('🔄 AMISTAD NOTIFICATIONS - Iniciando polling cada ${_pollingInterval.inSeconds} segundos');
    
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) async {
      await _verificarCambios();
    });
  }
  
  /// Detener polling
  static void detenerPolling() {
    if (_pollingTimer != null) {
      _pollingTimer!.cancel();
      _pollingTimer = null;
      _isPolling = false;
      print('🛑 AMISTAD NOTIFICATIONS - Polling detenido');
    }
  }
  
  /// Verificar cambios en solicitudes y amigos
  static Future<void> _verificarCambios() async {
    try {
      // Verificar nuevas solicitudes de amistad
      await _verificarNuevasSolicitudes();
      
      // Verificar nuevos amigos
      await _verificarNuevosAmigos();
      
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error verificando cambios: $e');
    }
  }
  
  /// Verificar nuevas solicitudes de amistad
  static Future<void> _verificarNuevasSolicitudes() async {
    try {
      final solicitudesActuales = await _obtenerSolicitudesPendientes();
      
      // Buscar solicitudes nuevas comparando con las anteriores
      for (final solicitud in solicitudesActuales) {
        final yaExistia = _ultimasSolicitudes.any((s) => s['id'] == solicitud['id']);
        
        if (!yaExistia) {
          print('👋 AMISTAD NOTIFICATIONS - Nueva solicitud detectada de RUT: ${solicitud['rutEmisor']}');
          
          // Obtener información del usuario emisor
          String nombreEmisor = 'Usuario desconocido';
          try {
            final infoUsuario = await AmistadService.obtenerUsuarioPorRut(solicitud['rutEmisor']);
            if (infoUsuario['success'] == true && infoUsuario['data'] != null) {
              nombreEmisor = infoUsuario['data']['nombreCompleto'] ?? 
                           '${infoUsuario['data']['nombre'] ?? ''} ${infoUsuario['data']['apellido'] ?? ''}'.trim();
              if (nombreEmisor.isEmpty) {
                nombreEmisor = infoUsuario['data']['nombre'] ?? 'Usuario desconocido';
              }
            }
          } catch (e) {
            print('⚠️ AMISTAD NOTIFICATIONS - Error obteniendo info del usuario ${solicitud['rutEmisor']}: $e');
          }
          
          print('👋 AMISTAD NOTIFICATIONS - Nueva solicitud de: $nombreEmisor (${solicitud['rutEmisor']})');
          
          // Mostrar notificación con el nombre del usuario
          await WebSocketNotificationService.showLocalNotification(
            title: '👋 Nueva solicitud de amistad',
            body: '$nombreEmisor te ha enviado una solicitud de amistad',
            payload: jsonEncode({
              'tipo': 'solicitud_amistad',
              'rutEmisor': solicitud['rutEmisor'],
              'nombreEmisor': nombreEmisor,
              'idSolicitud': solicitud['id'],
              'mensaje': solicitud['mensaje'],
            }),
          );
        }
      }
      
      // Actualizar cache
      _ultimasSolicitudes = List.from(solicitudesActuales);
      
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error verificando nuevas solicitudes: $e');
    }
  }
  
  /// Verificar nuevos amigos
  static Future<void> _verificarNuevosAmigos() async {
    try {
      final amigosActuales = await _obtenerAmigos();
      
      // Buscar amigos nuevos comparando con los anteriores
      for (final amigo in amigosActuales) {
        // El objeto tiene la estructura: { id, amigo: { rut, nombre, ... }, fechaAmistad }
        final rutAmigo = amigo['amigo']?['rut'];
        if (rutAmigo == null) {
          print('⚠️ AMISTAD NOTIFICATIONS - Amigo sin RUT válido: $amigo');
          continue;
        }
        
        final yaExistia = _ultimosAmigos.any((a) => a['amigo']?['rut'] == rutAmigo);
        
        if (!yaExistia) {
          print('🎉 AMISTAD NOTIFICATIONS - Nuevo amigo detectado RUT: $rutAmigo');
          
          // Obtener información del usuario amigo
          String nombreAmigo = 'Usuario desconocido';
          try {
            // Primero intentar usar los datos que ya vienen en la respuesta
            if (amigo['amigo'] != null) {
              final amigoData = amigo['amigo'];
              nombreAmigo = amigoData['nombreCompleto'] ?? 
                           '${amigoData['nombre'] ?? ''} ${amigoData['apellido'] ?? ''}'.trim();
              if (nombreAmigo.isEmpty) {
                nombreAmigo = amigoData['nombre'] ?? 'Usuario desconocido';
              }
            }
            
            // Si no obtuvimos un nombre válido, hacer consulta adicional
            if (nombreAmigo == 'Usuario desconocido') {
              final infoUsuario = await AmistadService.obtenerUsuarioPorRut(rutAmigo);
              if (infoUsuario['success'] == true && infoUsuario['data'] != null) {
                nombreAmigo = infoUsuario['data']['nombreCompleto'] ?? 
                            '${infoUsuario['data']['nombre'] ?? ''} ${infoUsuario['data']['apellido'] ?? ''}'.trim();
                if (nombreAmigo.isEmpty) {
                  nombreAmigo = infoUsuario['data']['nombre'] ?? 'Usuario desconocido';
                }
              }
            }
          } catch (e) {
            print('⚠️ AMISTAD NOTIFICATIONS - Error obteniendo info del usuario $rutAmigo: $e');
          }
          
          print('🎉 AMISTAD NOTIFICATIONS - Nueva amistad con: $nombreAmigo ($rutAmigo)');
          
          // Mostrar notificación con el nombre del usuario
          await WebSocketNotificationService.showLocalNotification(
            title: '🎉 ¡Nueva amistad!',
            body: 'Ahora eres amigo de $nombreAmigo',
            payload: jsonEncode({
              'tipo': 'amistad_aceptada',
              'rutAmigo': rutAmigo,
              'nombreAmigo': nombreAmigo,
            }),
          );
        }
      }
      
      // Actualizar cache
      _ultimosAmigos = List.from(amigosActuales);
      
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error verificando nuevos amigos: $e');
    }
  }
  
  /// Obtener solicitudes pendientes del backend
  static Future<List<Map<String, dynamic>>> _obtenerSolicitudesPendientes() async {
    try {
      final token = await TokenManager.getValidToken();
      if (token == null) return [];
      
      final response = await http.get(
        Uri.parse('${confGlobal.baseUrl}/amistad/solicitudes-pendientes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      
      return [];
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error obteniendo solicitudes: $e');
      return [];
    }
  }
  
  /// Obtener amigos del backend
  static Future<List<Map<String, dynamic>>> _obtenerAmigos() async {
    try {
      final token = await TokenManager.getValidToken();
      if (token == null) return [];
      
      final response = await http.get(
        Uri.parse('${confGlobal.baseUrl}/amistad/mis-amigos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      
      return [];
    } catch (e) {
      print('❌ AMISTAD NOTIFICATIONS - Error obteniendo amigos: $e');
      return [];
    }
  }
  
  /// Enviar solicitud de amistad (usa el servicio original)
  /// Las notificaciones WebSocket se manejan automáticamente por el backend
  static Future<Map<String, dynamic>> enviarSolicitudAmistadConNotificacion({
    required String rutReceptor,
    String? mensaje,
    String? nombreReceptor,
  }) async {
    print('📤 AMISTAD NOTIFICATIONS - Enviando solicitud de amistad a $rutReceptor');
    
    // Simplemente usar el servicio original
    // El backend se encarga de enviar la notificación WebSocket
    final resultado = await AmistadService.enviarSolicitudAmistad(
      rutReceptor: rutReceptor,
      mensaje: mensaje,
    );
    
    if (resultado['success'] == true) {
      print('✅ AMISTAD NOTIFICATIONS - Solicitud enviada. El backend enviará la notificación WebSocket.');
    } else {
      print('❌ AMISTAD NOTIFICATIONS - Error enviando solicitud: ${resultado['message']}');
    }
    
    return resultado;
  }
  
  /// Responder solicitud de amistad (usa el servicio original)
  /// Las notificaciones WebSocket se manejan automáticamente por el backend
  static Future<Map<String, dynamic>> responderSolicitudAmistadConNotificacion({
    required int idSolicitud,
    required String respuesta,
    required String rutEmisor,
    String? nombreEmisor,
  }) async {
    print('📥 AMISTAD NOTIFICATIONS - Respondiendo solicitud: $respuesta');
    
    // Simplemente usar el servicio original
    // El backend se encarga de enviar la notificación WebSocket
    final resultado = await AmistadService.responderSolicitudAmistad(
      idSolicitud: idSolicitud,
      respuesta: respuesta,
    );
    
    if (resultado['success'] == true) {
      print('✅ AMISTAD NOTIFICATIONS - Respuesta enviada. El backend enviará la notificación WebSocket.');
    } else {
      print('❌ AMISTAD NOTIFICATIONS - Error respondiendo solicitud: ${resultado['message']}');
    }
    
    return resultado;
  }
  
  /// Crear una notificación inmediata de solicitud de amistad
  /// Este método puede ser llamado directamente para mostrar notificaciones
  static Future<void> mostrarNotificacionSolicitudAmistad({
    required String nombreEmisor,
    required String rutEmisor,
    String? mensaje,
    int? idSolicitud,
  }) async {
    print('🔔 AMISTAD NOTIFICATIONS - Mostrando notificación inmediata de $nombreEmisor ($rutEmisor)');
    
    String bodyText = '$nombreEmisor te ha enviado una solicitud de amistad';
    if (mensaje != null && mensaje.isNotEmpty) {
      bodyText += '\n"$mensaje"';
    }
    
    await WebSocketNotificationService.showLocalNotification(
      title: '👋 Nueva solicitud de amistad',
      body: bodyText,
      payload: jsonEncode({
        'tipo': 'solicitud_amistad',
        'rutEmisor': rutEmisor,
        'nombreEmisor': nombreEmisor,
        'mensaje': mensaje,
        'idSolicitud': idSolicitud,
      }),
    );
  }
  
  /// Crear una notificación inmediata de amistad aceptada
  static Future<void> mostrarNotificacionAmistadAceptada({
    required String nombreReceptor,
    required String rutReceptor,
  }) async {
    print('🔔 AMISTAD NOTIFICATIONS - Mostrando notificación amistad aceptada de $nombreReceptor ($rutReceptor)');
    
    await WebSocketNotificationService.showLocalNotification(
      title: '🎉 ¡Solicitud aceptada!',
      body: '$nombreReceptor ha aceptado tu solicitud de amistad',
      payload: jsonEncode({
        'tipo': 'amistad_aceptada',
        'rutReceptor': rutReceptor,
        'nombreReceptor': nombreReceptor,
      }),
    );
  }
  
  /// Crear una notificación inmediata de amistad rechazada
  static Future<void> mostrarNotificacionAmistadRechazada({
    required String nombreReceptor,
    required String rutReceptor,
  }) async {
    print('🔔 AMISTAD NOTIFICATIONS - Mostrando notificación amistad rechazada de $nombreReceptor ($rutReceptor)');
    
    await WebSocketNotificationService.showLocalNotification(
      title: '😔 Solicitud rechazada',
      body: '$nombreReceptor rechazó tu solicitud de amistad',
      payload: jsonEncode({
        'tipo': 'amistad_rechazada',
        'rutReceptor': rutReceptor,
        'nombreReceptor': nombreReceptor,
      }),
    );
  }
}
