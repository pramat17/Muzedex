import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:muzedex_app/app.dart';

void main() {
  // Détection de la plateforme
  final String baseApiUrl = !kIsWeb && Platform.isAndroid
      ? "http://10.0.2.2:8000" // Adresse pour Android Emulator
      : "http://localhost:8000"; // Adresse pour les autres plateformes

  FlavorConfig(
    name: "DEV",
    variables: {
      "baseApiUrl": baseApiUrl,
    },
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
