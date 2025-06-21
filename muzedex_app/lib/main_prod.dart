import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:muzedex_app/app.dart';

void main() {
  FlavorConfig(
    name: "PROD",
    variables: {
      "baseApiUrl": "https://ns-2024-sae5-y11-api-prod.labs.iut-larochelle.fr",
    },
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


