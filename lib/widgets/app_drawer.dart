import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/public/public_screens.dart';
import '../screens/private/private_screens.dart';
import '../services/api_service.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class AppDrawer extends StatelessWidget {
  final bool logged;
  const AppDrawer({super.key, required this.logged});

  Future<void> _logout(BuildContext context) async {
    await ApiService.clearToken();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                SizedBox(width: 12),
                // Usamos Expanded para que el texto se ajuste
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ministerio de Medio Ambiente',
                        style: TextStyle(
                          fontSize: 16, // reducido para evitar overflow
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2, // permite saltar a otra línea si es necesario
                        overflow: TextOverflow.ellipsis, // agrega "..." si aún se pasa
                      ),
                      SizedBox(height: 8),
                      Text(
                        'República Dominicana',
                        style: TextStyle(color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🌍 Secciones públicas
          ListTile(
            title: const Text('Inicio'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Sobre Nosotros'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SobreNosotrosScreen()));
            },
          ),
          ListTile(
            title: const Text('Servicios'),
            leading: const Icon(Icons.handshake),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ServiciosScreen()));
            },
          ),
          ListTile(
            title: const Text('Noticias Ambientales'),
            leading: const Icon(Icons.newspaper),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NoticiasScreen()));
            },
          ),
          ListTile(
            title: const Text('Videos Educativos'),
            leading: const Icon(Icons.video_library),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VideosEducativosScreen()));
            },
          ),
          ListTile(
            title: const Text('Áreas Protegidas'),
            leading: const Icon(Icons.park),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AreasProtegidasScreen()));
            },
          ),
          ListTile(
            title: const Text('Mapa Áreas Protegidas'),
            leading: const Icon(Icons.map),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MapaAreasScreen()));
            },
          ),
          ListTile(
            title: const Text('Medidas Ambientales'),
            leading: const Icon(Icons.checklist),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MedidasScreen()));
            },
          ),
          ListTile(
            title: const Text('Equipo del Ministerio'),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EquipoScreen()));
            },
          ),
          ListTile(
            title: const Text('Voluntariado'),
            leading: const Icon(Icons.volunteer_activism),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VoluntariadoScreen()));
            },
          ),
          ListTile(
            title: const Text('Acerca de'),
            leading: const Icon(Icons.badge),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AcercaDeScreen()));
            },
          ),

          const Divider(),

          // 🔒 Opciones dependiendo del login
          if (logged) ...[
            ListTile(
              title: const Text('Normativas'),
              leading: const Icon(Icons.gavel),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NormativasScreen()));
              },
            ),
            ListTile(
              title: const Text('Reportar Daño Ambiental'),
              leading: const Icon(Icons.report),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportarScreen()));
              },
            ),
            ListTile(
              title: const Text('Mis Reportes'),
              leading: const Icon(Icons.list_alt),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MisReportesScreen()));
              },
            ),
            ListTile(
              title: const Text('Mapa de Reportes'),
              leading: const Icon(Icons.pin_drop),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MapaReportesScreen()));
              },
            ),
            ListTile(
              title: const Text('Cambiar Contraseña'),
              leading: const Icon(Icons.lock_reset),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CambiarPasswordScreen()));
              },
            ),
            ListTile(
              title: const Text('Cerrar Sesión'),
              leading: const Icon(Icons.logout),
              onTap: () => _logout(context),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Iniciar Sesión"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Registrarse"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
