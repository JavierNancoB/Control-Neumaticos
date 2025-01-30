import 'package:flutter/material.dart';
import '../../../models/bitacora_models.dart';
import '../../../services/bitacora/bitacora_details.dart';
import '../../../widgets/diccionario.dart';

class BitacoraDetailsScreen extends StatefulWidget {
  final int idBitacora;

  const BitacoraDetailsScreen({super.key, required this.idBitacora});

  @override
  _BitacoraDetailsScreenState createState() => _BitacoraDetailsScreenState();
}

class _BitacoraDetailsScreenState extends State<BitacoraDetailsScreen> {
  late Future<Bitacora> bitacoraData;

  @override
  void initState() {
    super.initState();
    bitacoraData = BitacoraServices.fetchBitacoraData(widget.idBitacora);
  }

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
      await BitacoraServices.updateBitacoraState(id, 2);
      setState(() {
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error al cargar los datos'));
          }

          Bitacora bitacora = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem("Código Bitácora", Diccionario.obtenerDescripcion(Diccionario.bitacora, bitacora.codigo)),
                Divider(),
                _buildInfoItem("Fecha", bitacora.fecha),
                Divider(),
                _buildInfoItem("Usuario", bitacora.idUsuario.toString()),
                Divider(),
                _buildInfoItem("Estado", Diccionario.obtenerDescripcion(Diccionario.estadoUsuarios, bitacora.estado)),
                Divider(),
                _buildInfoItem("Observaciones", bitacora.observacion),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => confirmarDeshabilitacion(bitacora.id),
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
      ),
    );
  }

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
