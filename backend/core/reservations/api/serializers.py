# reservations/api/serializers.py
from django.utils import timezone
from django.db import transaction
from rest_framework import serializers
from terrains.models import CreneauHoraire
from reservations.models import Reservation, Paiement, Groupe
from accounts.models import User

class ReservationCreateSerializer(serializers.Serializer):
    creneau_id = serializers.IntegerField()
    type_reservation = serializers.ChoiceField(choices=Reservation.Type.choices)
    groupe_id = serializers.IntegerField(required=False, allow_null=True)
    methode_paiement = serializers.ChoiceField(choices=Paiement.Methode.choices)
    reference_transaction = serializers.CharField(max_length=100)

    def validate_creneau_id(self, value):
        try:
            creneau = CreneauHoraire.objects.select_related('terrain').get(id=value)
        except CreneauHoraire.DoesNotExist:
            raise serializers.ValidationError("Créneau introuvable.")
        
        # Vérifier que le terrain est validé
        if not creneau.terrain.valide:
            raise serializers.ValidationError("Ce terrain n’est pas encore validé par l’administrateur.")
        
        if not creneau.disponible:
            raise serializers.ValidationError("Ce créneau n’est plus disponible.")
        
        if creneau.date < timezone.now().date():
            raise serializers.ValidationError("Vous ne pouvez pas réserver un créneau dans le passé.")
        
        return value

    def validate(self, attrs):
        user = self.context['request'].user
        creneau_id = attrs['creneau_id']
        type_reservation = attrs['type_reservation']
        groupe_id = attrs.get('groupe_id')

        # Vérifier le groupe si nécessaire
        if type_reservation == Reservation.Type.GROUPE:
            if not groupe_id:
                raise serializers.ValidationError({"groupe_id": "Le groupe est requis pour une réservation de groupe."})
            try:
                groupe = Groupe.objects.get(id=groupe_id, createur=user)
                attrs['groupe'] = groupe
            except Groupe.DoesNotExist:
                raise serializers.ValidationError({"groupe_id": "Groupe invalide ou non autorisé."})
        elif groupe_id:
            raise serializers.ValidationError({"groupe_id": "Le groupe ne peut être spécifié que pour une réservation de groupe."})

        return attrs

    @transaction.atomic
    def create(self, validated_data):
        user = self.context['request'].user
        creneau = CreneauHoraire.objects.select_for_update().get(id=validated_data['creneau_id'])

        # Vérification finale de disponibilité (en cas de concurrence)
        if not creneau.disponible:
            raise serializers.ValidationError("Ce créneau vient d’être réservé par un autre utilisateur.")

        # Marquer le créneau comme non disponible
        creneau.disponible = False
        creneau.save(update_fields=['disponible'])

        # Créer la réservation
        reservation = Reservation.objects.create(
            utilisateur=user,
            creneau=creneau,
            type_reservation=validated_data['type_reservation'],
            groupe=validated_data.get('groupe'),
            statut=Reservation.Statut.PAYEE,  # car paiement fourni
            prix_total=creneau.tarif
        )

        # Créer le paiement
        Paiement.objects.create(
            reservation=reservation,
            montant=creneau.tarif,
            methode=validated_data['methode_paiement'],
            reference_transaction=validated_data['reference_transaction']
        )

        return reservation


class ReservationSerializer(serializers.ModelSerializer):
    terrain_nom = serializers.CharField(source='creneau.terrain.nom', read_only=True)
    terrain_id = serializers.IntegerField(source='creneau.terrain.id', read_only=True)
    date_reservation = serializers.DateField(source='creneau.date', read_only=True)
    heure_debut = serializers.TimeField(source='creneau.heure_debut', read_only=True)
    heure_fin = serializers.TimeField(source='creneau.heure_fin', read_only=True)

    class Meta:
        model = Reservation
        fields = (
            'id', 'terrain_nom', 'terrain_id', 'date_reservation', 'heure_debut', 'heure_fin',
            'type_reservation', 'statut', 'prix_total', 'date_creation'
        )