import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  // 1. Definimos las instancias privadas
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? _user;
  Map<String, dynamic>? _userData;

  /// Contador de platos realizados en la sesión actual (hoy).
  int _platosHoy = 0;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  int get platosHoy => _platosHoy;

  bool get isLoading => _user != null && _userData == null;

  // 2. Constructor con Inyección de Dependencias
  // Si no se pasan instancias (como en la app real), usa las de por defecto.
  UserProvider({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {

    // Escuchamos los cambios de sesión usando la instancia inyectada
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _listenToUserData(user.uid);
      } else {
        _userData = null;
        _platosHoy = 0;
        notifyListeners();
      }
    });
  }

  /// Incrementa el contador de platos de la sesión actual.
  void incrementarPlatosHoy() {
    _platosHoy++;
    notifyListeners();
  }

  // 3. Usamos _firestore en lugar de FirebaseFirestore.instance
  void _listenToUserData(String uid) {
    _firestore.collection('usuarios').doc(uid).snapshots().listen((snapshot) {
      _userData = snapshot.data();
      notifyListeners();
    });
  }

  /// Método para iniciar sesión usando _auth
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "Correo o contraseña incorrectos";
      }
      return e.message ?? "Error al iniciar sesión";
    } catch (e) {
      return "Ocurrió un error inesperado";
    }
  }

  /// Método para registrar un nuevo usuario usando _auth y _firestore
  Future<String?> register(String email, String password, String nombre) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'nombre': nombre,
          'correo': email,
          'platosPreparados': 0,
        });
      }
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "El correo ya está en uso";
      } else if (e.code == 'weak-password') {
        return "La contraseña es muy débil";
      }
      return e.message ?? "Error en el registro";
    } catch (e) {
      return "Ocurrió un error inesperado";
    }
  }

  /// Método para cerrar sesión usando _auth
  Future<void> logout() async {
    await _auth.signOut();
  }
}