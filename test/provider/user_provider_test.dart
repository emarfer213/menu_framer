import 'package:flutter_test/flutter_test.dart';
import 'package:menu_framer/provider/UserProvider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late UserProvider userProvider;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    userProvider = UserProvider(auth: auth, firestore: firestore);
  });

  group('UserProvider Tests', () {
    test('El contador platosHoy debe iniciar en 0', () {
      expect(userProvider.platosHoy, 0);
    });

    test('incrementarPlatosHoy debe aumentar el contador en 1', () {
      userProvider.incrementarPlatosHoy();
      expect(userProvider.platosHoy, 1);
    });

    test('incrementarPlatosHoy debe notificar a los oyentes', () {
      bool notified = false;
      userProvider.addListener(() {
        notified = true;
      });

      userProvider.incrementarPlatosHoy();
      expect(notified, true);
    });

    test('login exitoso debe actualizar el usuario', () async {
      //1. Preparamos el simulador: registramos al usuario primero para que "exista"
      auth = MockFirebaseAuth();
      await auth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123'
      );
      // Cerramos sesión para que el UserProvider empiece con el usuario en null
      await auth.signOut();

      // 2. Ahora inicializamos el Provider con ese Auth que ya conoce al usuario
      userProvider = UserProvider(auth: auth, firestore: firestore);

      // 3. Ejecutamos el login que antes fallaba
      final result = await userProvider.login('test@example.com', 'password123');

      // 4. Esperamos a que los Streams se sincronicen
      await Future.delayed(Duration.zero);

      // Verificaciones
      expect(result, null, reason: "El login debería ser exitoso");
      expect(userProvider.user, isNotNull, reason: "El usuario en el provider no debería ser null");
      expect(userProvider.user!.email, 'test@example.com');
    });

    test('register debe crear un usuario y guardar en Firestore', () async {
      final result = await userProvider.register('new@example.com', 'password123', 'Nuevo Usuario');

      expect(result, null);
      expect(auth.currentUser, isNotNull);

      // Verificar que se guardó en la colección 'usuarios' de FakeFirestore
      final snapshot = await firestore.collection('usuarios').doc(auth.currentUser!.uid).get();
      expect(snapshot.exists, true);
      expect(snapshot.data()!['nombre'], 'Nuevo Usuario');
    });

    test('logout debe limpiar el usuario y reiniciar platosHoy', () async {
      // Primero hacemos login
      await userProvider.register('test@example.com', 'password123', 'Test');
      userProvider.incrementarPlatosHoy();

      expect(userProvider.platosHoy, 1);
      expect(userProvider.user, isNotNull);

      await userProvider.logout();

      expect(userProvider.user, isNull);
      expect(userProvider.platosHoy, 0);
    });
  });
}
