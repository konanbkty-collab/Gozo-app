import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GozoLivraisonApp());
}

class GozoLivraisonApp extends StatelessWidget {
  const GozoLivraisonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gozo Livraison',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A), // Bleu
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFFACC15), // Jaune
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _lat1Controller = TextEditingController(text: '6.1319');
  final TextEditingController _lon1Controller = TextEditingController(text: '-5.9506');
  final TextEditingController _lat2Controller = TextEditingController(text: '6.1450');
  final TextEditingController _lon2Controller = TextEditingController(text: '-5.9300');

  double? _distanceKm;
  double? _priceFcfa;

  // Formule de Haversine pour calculer la distance en km
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Pi / 180
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Calcul du tarif : 500 FCFA pour les 4.5 premiers km, puis 200 FCFA/km supplémentaire
  double calculatePrice(double distanceInKm) {
    double basePrice = 500.0;
    double baseDistance = 4.5; // Ajusté à 4.5 km
    double pricePerExtraKm = 200.0;

    if (distanceInKm <= baseDistance) {
      return basePrice;
    } else {
      double extraKm = distanceInKm - baseDistance;
      return basePrice + (extraKm * pricePerExtraKm);
    }
  }

  void _calculate() {
    setState(() {
      double? lat1 = double.tryParse(_lat1Controller.text);
      double? lon1 = double.tryParse(_lon1Controller.text);
      double? lat2 = double.tryParse(_lat2Controller.text);
      double? lon2 = double.tryParse(_lon2Controller.text);

      if (lat1 != null && lon1 != null && lat2 != null && lon2 != null) {
        _distanceKm = calculateDistance(lat1, lon1, lat2, lon2);
        _priceFcfa = calculatePrice(_distanceKm!);
      } else {
        _distanceKm = null;
        _priceFcfa = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOZO LIVRAISON - Gagnoa', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFACC15), // Jaune
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intégration de votre logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/logo.png',
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A), // Bleu
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Vous commandez. Gozo Livraison récupère. Gozo Livraison livre.',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Coordonnées du Point de Départ (GPS)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            Row(
              children: [
                Expanded(child: TextField(controller: _lat1Controller, decoration: const InputDecoration(labelText: 'Latitude Départ'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _lon1Controller, decoration: const InputDecoration(labelText: 'Longitude Départ'))),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Coordonnées du Point d\'Arrivée (GPS)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            Row(
              children: [
                Expanded(child: TextField(controller: _lat2Controller, decoration: const InputDecoration(labelText: 'Latitude Arrivée'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _lon2Controller, decoration: const InputDecoration(labelText: 'Longitude Arrivée'))),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFACC15), // Jaune
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _calculate,
              child: const Text('Estimer la course', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            if (_distanceKm != null && _priceFcfa != null) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Résultat de l\'estimation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text('Distance estimée : ${_distanceKm!.toStringAsFixed(2)} km', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text('Tarif de base : 500 FCFA (4.5 premiers km)', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      const SizedBox(height: 15),
                      Text(
                        'Total à payer : ${_priceFcfa!.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
