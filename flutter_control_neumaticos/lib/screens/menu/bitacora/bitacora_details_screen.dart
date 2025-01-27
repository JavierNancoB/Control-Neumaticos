import 'package:flutter/material.dart';
import '../../../models/usuario_alertas.dart';
import '../../../models/bitacora_models.dart';
import '../../../services/bitacora/bitacora_details.dart';
import '../../../../../widgets/bitacora/bitacora_details.dart';

class BitacoraDetailsScreen extends StatefulWidget {
  final int idBitacora;

  const BitacoraDetailsScreen({super.key, required this.idBitacora, required Map<String, dynamic> bitacora});

  @override
  _BitacoraDetailsScreenState createState() => _BitacoraDetailsScreenState();
}

class _BitacoraDetailsScreenState extends State<BitacoraDetailsScreen> {
  late Future<Bitacora> bitacoraData;
  late Future<Usuario> usuarioData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('Inicializando la pantalla de detalles con idBitacora: ${widget.idBitacora}');
    bitacoraData = BitacoraServices.fetchBitacoraData(widget.idBitacora);
  }

  Future<void> updateBitacoraState(int id, int estado) async {
    print('Actualizando estado de la bitácora con id: $id a estado: $estado');
    await BitacoraServices.updateBitacoraState(id, estado);
    setState(() {
      bitacoraData = BitacoraServices.fetchBitacoraData(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Construyendo la UI de BitacoraDetailsScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Bitácora'),
      ),
      body: FutureBuilder<Bitacora>(
        future: bitacoraData,
        builder: (context, snapshot) {
          print('Estado de la conexión de bitacora: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error al cargar la bitácora: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            print('No se encontró la bitácora');
            return const Center(child: Text('No hay datos disponibles'));
          }

          Bitacora bitacora = snapshot.data!;
          print('Bitácora obtenida: $bitacora');
          return FutureBuilder<Usuario>(
            future: BitacoraServices.fetchUsuarioData(bitacora.idUsuario),
            builder: (context, usuarioSnapshot) {
              print('Estado de la conexión del usuario: ${usuarioSnapshot.connectionState}');
              if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (usuarioSnapshot.hasError) {
                print('Error al cargar los datos del usuario: ${usuarioSnapshot.error}');
                return Center(child: Text('Error: ${usuarioSnapshot.error}'));
              } else if (!usuarioSnapshot.hasData) {
                print('No se pudo obtener la información del usuario');
                return const Center(child: Text('No se pudo obtener información del usuario'));
              }

              Usuario usuario = usuarioSnapshot.data!;
              print('Usuario obtenido: $usuario');
              return BitacoraDetailsWidget(
                bitacora: bitacora,
                usuario: usuario,
                onStateChange: updateBitacoraState,
              );
            },
          );
        },
      ),
    );
  }
}
