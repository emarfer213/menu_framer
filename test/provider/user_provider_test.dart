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
    test('login debe iniciar sesión correctamente', () async {
      final result = await userProvider.login('new@example.com', 'password123');
      expect(result, null);
      expect(auth.currentUser, isNotNull);
    });

    test('register debe crear un usuario y guardar en Firestore', () async {
      final result = await userProvider.register('new@example.com', 'password123', 'Nuevo Usuario');

      expect(result, null);
      expect(auth.currentUser, isNotNull);

      // Verificar que se guardó en la colección 'usuarios' de FakeFirestore
      final snapshot = await firestore.collection('usuarios').doc(auth.currentUser!.uid).get();
      expect(snapshot.exists, true);
      expect(snapshot.data()!['nombre'], 'Nuevo Usuario');
      expect(snapshot.data()!['correo'], 'new@example.com');
      expect(snapshot.data()!['platosPreparados'], 0);
    });
  });
}
