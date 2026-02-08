// lib/data/models/terrain_model.dart
class Terrain {
  final int id;
  final String name;
  final String sport; // ← vous devrez ajouter ce champ dans le backend
  final double price;
  final String imageUrl;
  final String adresse;

  Terrain({
    required this.id,
    required this.name,
    required this.sport,
    required this.price,
    required this.imageUrl,
    required this.adresse,
  });

  factory Terrain.fromJson(Map<String, dynamic> json) {
    // ⚠️ Le backend ne retourne pas "sport" → à ajouter (voir note ci-dessous)
    String sport = 'foot'; // valeur par défaut temporaire
    if (json['nom'].toLowerCase().contains('basket')) sport = 'basket';
    if (json['nom'].toLowerCase().contains('tennis')) sport = 'tennis';

    return Terrain(
      id: json['id'],
      name: json['nom'],
      sport: sport,
      price: json['creneaux']?.isNotEmpty == true
          ? (json['creneaux'][0]['tarif'] as num).toDouble()
          : 0.0,
      imageUrl: json['image_url'] ?? '',
      adresse: json['adresse'] ?? '',
    );
  }
}
