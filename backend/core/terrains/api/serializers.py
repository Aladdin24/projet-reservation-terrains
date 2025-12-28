# terrains/api/serializers.py
from rest_framework import serializers
from terrains.models import Terrain, CreneauHoraire, Evaluation

class EvaluationSerializer(serializers.ModelSerializer):
    utilisateur_nom = serializers.CharField(source='utilisateur.get_full_name', read_only=True)

    class Meta:
        model = Evaluation
        fields = ('id', 'note', 'commentaire', 'date_creation', 'utilisateur_nom')

class CreneauHoraireSerializer(serializers.ModelSerializer):
    class Meta:
        model = CreneauHoraire
        fields = ('id', 'heure_debut', 'heure_fin', 'tarif', 'date', 'disponible')

class TerrainSerializer(serializers.ModelSerializer):
    creneaux = CreneauHoraireSerializer(many=True, read_only=True)
    evaluations = EvaluationSerializer(many=True, read_only=True)
    distance = serializers.FloatField(read_only=True)  # pour tri par distance (optionnel)
    note_moyenne = serializers.FloatField(
    source='note_moyenne_calculee',
    read_only=True
   )

    class Meta:
        model = Terrain
        fields = (
            'id', 'nom', 'adresse', 'latitude', 'longitude',
            'image_url', 'note_moyenne', 'creneaux', 'evaluations', 'distance'
        )