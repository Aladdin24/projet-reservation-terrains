# terrains/api/serializers.py
from rest_framework import serializers
from terrains.models import Terrain, CreneauHoraire, Evaluation

class EvaluationSerializer(serializers.ModelSerializer):
    utilisateur_nom = serializers.CharField(source='utilisateur.get_full_name', read_only=True)
    commentaire = serializers.CharField(
        required=False,
        allow_blank=True
    )

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



class EvaluationCreateSerializer(serializers.ModelSerializer):
    terrain_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = Evaluation
        fields = ('terrain_id', 'note', 'commentaire')
        extra_kwargs = {
            'note': {'min_value': 1, 'max_value': 5},
        }

    def validate_terrain_id(self, value):
        try:
            terrain = Terrain.objects.get(id=value)
        except Terrain.DoesNotExist:
            raise serializers.ValidationError("Terrain invalide.")
        return value

    def validate(self, attrs):
        user = self.context['request'].user
        terrain_id = attrs['terrain_id']
        terrain = Terrain.objects.get(id=terrain_id)

        # Vérifier que l’utilisateur a réservé ce terrain
        from reservations.models import Reservation
        from django.utils import timezone
        now = timezone.now()

        reservation_exists = Reservation.objects.filter(
            utilisateur=user,
            creneau__terrain_id=terrain_id,
            creneau__date__lt=now.date(),  # la date est passée
            statut=Reservation.Statut.PAYEE  # ou CONFIRMEE si vous permettez sans paiement
        ).exists()

        if not reservation_exists:
            raise serializers.ValidationError(
                {"terrain_id": "Vous ne pouvez évaluer que les terrains que vous avez utilisés."}
            )

        # Vérifier qu’il n’a pas déjà évalué ce terrain
        if Evaluation.objects.filter(utilisateur=user, terrain=terrain).exists():
            raise serializers.ValidationError(
                {"terrain_id": "Vous avez déjà évalué ce terrain."}
            )

        return attrs

    def create(self, validated_data):
        terrain_id = validated_data.pop('terrain_id')
        terrain = Terrain.objects.get(id=terrain_id)
        evaluation = Evaluation.objects.create(
            utilisateur=self.context['request'].user,
            terrain=terrain,
            **validated_data
        )
        # Mettre à jour la note moyenne du terrain
        from django.db.models import Avg
        avg = Evaluation.objects.filter(terrain=terrain).aggregate(Avg('note'))['note__avg']
        terrain.note_moyenne = avg or 0.0
        terrain.save(update_fields=['note_moyenne'])
        return evaluation