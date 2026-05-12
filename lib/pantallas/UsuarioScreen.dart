import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/UserProvider.dart';
import '../provider/voiceControler.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  @override
  Widget build(BuildContext context) {
    // Consumimos los datos del UserProvider (que vienen de Firestore en tiempo real)
    final userProvider = Provider.of<UserProvider>(context);
    final datos = context.watch<UserProvider>().userData;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Mi Perfil'), backgroundColor: Colors.amber, centerTitle: true, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.amber),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    datos?['correo'] ?? 'Cargando...',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tarjetas de detalles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.restaurant_menu,
                    title: "Platos Preparados totales",
                    value: "${datos?['platosPreparados'] ?? 0}",
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    icon: Icons.restaurant,
                    title: "Platos preparados hoy",
                    value: userProvider.platosHoy.toString(),
                    color: Colors.green,
                  ),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    icon: Icons.email,
                    title: "Correo Electrónico",
                    value: datos?['correo'] ?? '---',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Botón de Cerrar Sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    voiceController.stopService(); //Desactivamos el control por voz
                    await FirebaseAuth.instance.signOut();

                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', (route) => false);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Cerrar Sesión"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para construir las tarjetas de información
  Widget _buildInfoCard({required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis, // Si el título es muy largo, pone "..."
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  softWrap: true, // Permite que el texto baje a la siguiente línea
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
