import 'package:flutter/material.dart';
import '../../../models/menu/bitacora_models.dart';
import '../../../models/admin/usuario_alertas.dart';  // Asegúrate de tener el modelo de Usuario
import '../../../services/bitacora/bitacora_details.dart';
import '../../../widgets/diccionario.dart';

// Pantalla de detalles de Bitácora
class BitacoraDetailsScreen extends StatefulWidget {
  final int idBitacora;

  const BitacoraDetailsScreen({super.key, required this.idBitacora});

  @override
  _BitacoraDetailsScreenState createState() => _BitacoraDetailsScreenState();
}

class _BitacoraDetailsScreenState extends State<BitacoraDetailsScreen> {
  late Future<Bitacora> bitacoraData; // Variable para almacenar los datos de la bitácora
  late Future<Usuario> usuarioData; // Variable para almacenar los datos del usuario

  @override
  void initState() {
    super.initState();
    // Obtener los datos de la bitácora
    bitacoraData = BitacoraServices.fetchBitacoraData(widget.idBitacora);
    // Una vez obtenidos los datos de la bitácora, obtener los datos del usuario
    bitacoraData.then((bitacora) {
      usuarioData = BitacoraServices.fetchUsuarioData(bitacora.idUsuario);
    });
  }

  // Función para confirmar la deshabilitación de un evento
  Future<void> confirmarDeshabilitacion(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Deshabilitar Evento"),
        content: Text("¿Estás seguro que deseas deshabilitar este evento? No se mostrará en la bitacora del neumatico."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // Actualizar el estado de la bitácora
      await BitacoraServices.updateBitacoraState(id, 2);
      setState(() {
        // Volver a obtener los datos de la bitácora
        bitacoraData = BitacoraServices.fetchBitacoraData(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de Bitácora')),
      body: FutureBuilder<Bitacora>(
        future: bitacoraData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Mostrar un indicador de carga mientras se obtienen los datos
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error al cargar los datos')); // Mostrar un mensaje de error si no se pueden obtener los datos
          }

          Bitacora bitacora = snapshot.data!; // Obtener los datos de la bitácora
          
          return FutureBuilder<Usuario>(
            future: usuarioData,
            builder: (context, usuarioSnapshot) {
              if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Mostrar un indicador de carga mientras se obtienen los datos del usuario
              } else if (usuarioSnapshot.hasError || !usuarioSnapshot.hasData) {
                return Center(child: Text('Error al cargar los datos del usuario')); // Mostrar un mensaje de error si no se pueden obtener los datos del usuario
              }

              Usuario usuario = usuarioSnapshot.data!; // Obtener los datos del usuario
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mostrar los detalles de la bitácora
                    _buildInfoItem("Código Bitácora", Diccionario.obtenerDescripcion(Diccionario.bitacora, bitacora.codigo)),
                    Divider(),
                    _buildInfoItem("Fecha", bitacora.fecha),
                    Divider(),
                    _buildInfoItem("Usuario que ingreso la información", "${usuario.nombres} ${usuario.apellidos}"),  // Aquí mostramos el nombre y apellido
                    Divider(),
                    _buildInfoItem("Estado", Diccionario.obtenerDescripcion(Diccionario.estadoUsuarios, bitacora.estado)),
                    Divider(),
                    _buildInfoItem("Observaciones", bitacora.observacion),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => confirmarDeshabilitacion(bitacora.id), // Llamar a la función para confirmar la deshabilitación del evento
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Deshabilitar Evento"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Función para construir un elemento de información
  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
