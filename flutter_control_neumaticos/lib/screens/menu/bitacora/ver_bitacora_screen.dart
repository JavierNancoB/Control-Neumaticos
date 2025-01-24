import 'package:flutter/material.dart';
import '../../../services/ver_bitacora_services.dart';
import '../../../widgets/bitacora/bitcora_item.dart';

class VerBitacoraScreen extends StatefulWidget {
  final int idNeumatico;

  const VerBitacoraScreen({super.key, required this.idNeumatico});

  @override
  _VerBitacoraScreenState createState() => _VerBitacoraScreenState();
}

class _VerBitacoraScreenState extends State<VerBitacoraScreen> {
  late Future<List<Map<String, dynamic>>> bitacoras;

  @override
  void initState() {
    super.initState();
    bitacoras = VerBitacoraServices.getBitacoraByNeumatico(widget.idNeumatico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bitácora del Neumático"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: bitacoras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay bitácoras disponibles'));
          }

          List<Map<String, dynamic>> bitacorasData = snapshot.data!;

          return ListView.builder(
            itemCount: bitacorasData.length,
            itemBuilder: (context, index) {
              var bitacora = bitacorasData[index];
              return BitacoraItem(bitacora: bitacora);
            },
          );
        },
      ),
    );
  }
}
