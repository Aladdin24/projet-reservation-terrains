# terrains/api/views.py
import math
from django.db.models import Q, Avg
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from terrains.models import Terrain, Evaluation
from .serializers import TerrainSerializer, EvaluationCreateSerializer, EvaluationSerializer
from drf_spectacular.utils import extend_schema
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

@extend_schema(
    summary="Liste des terrains validés",
    description="Retourne uniquement les terrains validés par l'administrateur.",
)
@api_view(['GET'])
def terrain_list(request):
    """
    Liste tous les terrains.
    Filtres possibles :
      - ?disponible_le=YYYY-MM-DD
      - ?longitude=...&latitude=... (optionnel, pour distance)
    """
    from django.db import connection

    # Seulement les terrains validés
    terrains = Terrain.objects.filter(valide=True).prefetch_related('creneaux', 'evaluations')

    # Filtre par date de disponibilité
    disponible_le = request.query_params.get('disponible_le')
    if disponible_le:
        terrains = terrains.filter(
            creneaux__date=disponible_le,
            creneaux__disponible=True,
        ).distinct()

    # Calcul de la note moyenne (déjà dans le modèle, mais on s'assure)
    terrains = terrains.annotate(note_moyenne_calculee=Avg('evaluations__note'))

    # Tri par distance (optionnel, MySQL/PostGIS recommandé pour prod)
    lat = request.query_params.get('latitude')
    lon = request.query_params.get('longitude')
    if lat and lon:
        try:
            lat = float(lat)
            lon = float(lon)
            # SQLite ne supporte pas les fonctions géo → approximation simple
            terrains = list(terrains)
            for t in terrains:
                t.distance = math.sqrt(
                    (float(t.latitude) - lat) ** 2 +
                    (float(t.longitude) - lon) ** 2
                ) * 111  # ≈ km
            terrains.sort(key=lambda t: t.distance)
        except ValueError:
            pass

    serializer = TerrainSerializer(terrains, many=True, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)

@extend_schema(
    summary="Détail d’un terrain",
    description="Retourne les détails d’un terrain spécifique.",
)
@api_view(['GET'])
def terrain_detail(request, pk):
    """
    Détail d’un terrain spécifique.
    """
    try:
        terrain = Terrain.objects.filter(valide=True).prefetch_related('creneaux', 'evaluations').get(pk=pk)
        terrain.note_moyenne = terrain.evaluations.aggregate(avg=Avg('note'))['avg'] or 0.0
        serializer = TerrainSerializer(terrain, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Terrain.DoesNotExist:
        return Response({"error": "Terrain non trouvé"}, status=status.HTTP_404_NOT_FOUND)
    

@extend_schema(
    summary="Créer une évaluation",
    description="Crée une évaluation pour un terrain.",
    request=EvaluationCreateSerializer,
    responses={
        201: EvaluationSerializer,
        400: {"description": "Données invalides"}
    }
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_evaluation(request):
    """
    Crée une évaluation pour un terrain.
    """
    serializer = EvaluationCreateSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        evaluation = serializer.save()
        output_serializer = EvaluationSerializer(evaluation)
        return Response(output_serializer.data, status=status.HTTP_201_CREATED,content_type="application/json; charset=utf-8")
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST, content_type="application/json; charset=utf-8")