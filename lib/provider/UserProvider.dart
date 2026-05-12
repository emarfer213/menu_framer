import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;

  /// Contador de platos realizados en la sesión actual (hoy).
  /// Esta variable es volátil y se reinicia al cerrar sesión o cerrar la app.
  int _platosHoy = 0;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  int get platosHoy => _platosHoy;

  bool get isLoading => _user != null && _userData == null;

  UserProvider() {
    // Escuchamos los cambios de sesión (Login/Logout)
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        // Si hay usuario, escuchamos sus datos de Firestore en tiempo real
        _listenToUserData(user.uid);
      } else {
        _userData = null;
        // Reiniciamos el contador de la sesión al cerrar sesión
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

  void _listenToUserData(String uid) {
    FirebaseFirestore.instance.collection('usuarios').doc(uid).snapshots().listen((snapshot) {
      _userData = snapshot.data();
      notifyListeners();
    });
  }

  /// Método para iniciar sesión
  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
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

  /// Método para registrar un nuevo usuario
  Future<String?> register(String email, String password, String nombre) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
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

  /// Método para cerrar sesión
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
