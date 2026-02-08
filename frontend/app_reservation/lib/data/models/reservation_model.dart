class Reservation {
  final int id;
  final String terrain;
  final DateTime date;
  final String time;
  final String sport;

  Reservation({
    required this.id,
    required this.terrain,
    required this.date,
    required this.time,
    required this.sport,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // Extraire heure_debut au format "HH:mm"
    final heureDebut = json['heure_debut'];
    final timeStr = heureDebut is String
        ? heureDebut.split(':').take(2).join(':')
        : '00:00';

    // Sport : à déduire ou à ajouter dans le backend
    String sport = 'foot';
    if (json['terrain_nom']?.toLowerCase().contains('basket')) sport = 'basket';
    if (json['terrain_nom']?.toLowerCase().contains('tennis')) sport = 'tennis';

    return Reservation(
      id: json['id'],
      terrain: json['terrain_nom'] ?? 'Terrain',
      date: DateTime.parse(json['date_reservation']),
      time: timeStr,
      sport: sport,
    );
  }
}
