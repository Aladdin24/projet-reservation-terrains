# reservations/api/views.py
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import ReservationCreateSerializer, ReservationSerializer
from reservations.models import Reservation
from django.db import transaction
from django.utils import timezone
from datetime import datetime, time
from reservations.models import Reservation
from terrains.models import CreneauHoraire
from drf_spectacular.utils import extend_schema

@extend_schema(
    summary="Créer une réservation",
    description="Crée une nouvelle réservation.",
    request=ReservationCreateSerializer,
    responses={
        201: ReservationSerializer,
        400: {"description": "Données invalides"}
    }
)
@api_view(['POST'])
def create_reservation(request):
    """
    Crée une nouvelle réservation.
    Le paiement est fourni dans la requête.
    """
    serializer = ReservationCreateSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        reservation = serializer.save()
        output_serializer = ReservationSerializer(reservation)
        return Response(output_serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@extend_schema(
    summary="Liste des réservations",
    description="Retourne la liste des réservations de l’utilisateur connecté.",
)
@api_view(['GET'])
def reservation_list(request):
    """
    Liste les réservations de l’utilisateur connecté.
    """
    reservations = Reservation.objects.filter(utilisateur=request.user).select_related(
        'creneau', 'creneau__terrain'
    ).order_by('-date_creation')
    serializer = ReservationSerializer(reservations, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)



@extend_schema(
    summary="Annuler une réservation",
    description="Annule une réservation existante.",
)
@api_view(['POST'])
def cancel_reservation(request, reservation_id):
    """
    Annule une réservation.
    - Si statut = PAYEE → passe à REMBOURSEE (simulé)
    - Si statut = EN_ATTENTE/CONFIRMEE → passe à ANNULEE
    - Le créneau est remis à disponible **seulement si la date n’est pas passée**
    """
    try:
        reservation = Reservation.objects.select_related('creneau').get(
            id=reservation_id,
            utilisateur=request.user
        )
    except Reservation.DoesNotExist:
        return Response(
            {"error": "Réservation non trouvée ou non autorisée"},
            status=status.HTTP_404_NOT_FOUND
        )

    # Vérifier si la réservation est déjà annulée
    if reservation.statut in [Reservation.Statut.ANNULEE, Reservation.Statut.REMBOURSEE]:
        return Response(
            {"error": "Cette réservation est déjà annulée"},
            status=status.HTTP_400_BAD_REQUEST
        )

    # Vérifier si la date du créneau est déjà passée
    creneau = reservation.creneau
    now = timezone.now()
    creneau_datetime = timezone.make_aware(
    datetime.combine(creneau.date, creneau.heure_debut)
    )
    if creneau_datetime < now:
        return Response(
            {"error": "Vous ne pouvez pas annuler une réservation passée"},
            status=status.HTTP_400_BAD_REQUEST
        )

    with transaction.atomic():
        # Mettre à jour le statut
        if reservation.statut == Reservation.Statut.PAYEE:
            reservation.statut = Reservation.Statut.REMBOURSEE
            # ICI : déclencher un remboursement réel (Stripe, etc.) → simulé pour l’instant
        else:
            reservation.statut = Reservation.Statut.ANNULEE

        reservation.save(update_fields=['statut'])

        # Remettre le créneau à disponible (car la date n’est pas passée)
        creneau.disponible = True
        creneau.save(update_fields=['disponible'])

    serializer = ReservationSerializer(reservation)
    return Response(serializer.data, status=status.HTTP_200_OK)