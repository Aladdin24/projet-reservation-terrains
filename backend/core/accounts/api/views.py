# accounts/api/views.py
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import CustomTokenObtainPairSerializer, UserRegisterSerializer
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken


from drf_spectacular.utils import extend_schema, OpenApiExample

@extend_schema(
    summary="Se connecter (Utilisateur Standard)",
    description="Retourne un token JWT si les identifiants sont valides.",
    request={"application/json": {"telephone": "string", "password": "string"}},
    examples=[
        OpenApiExample(
            'Exemple de requête',
            value={
                "telephone": "0612345678",
                "password": "motdepasse123"
            },
            request_only=True,
        )
    ],
    responses={
        200: {
            "type": "object",
            "properties": {
                "access": {"type": "string"},
                "refresh": {"type": "string"},
                "user_id": {"type": "integer"},
                "telephone": {"type": "string"},
            }
        },
        401: {"description": "Identifiants invalides"}
    }
)
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer


@extend_schema(
    summary="S'inscrire (Utilisateur Standard)",
    description="Retourne l'information de l'utilisateur et les tokens JWT après une inscription réussie.",
    request={"application/json": {"first_name": "string", "last_name": "string", "telephone": "string", "password": "string", "password2": "string"}},
    examples=[
        OpenApiExample(
            'Exemple de requête',
            value={
                "first_name": "Jean",
                "last_name": "Dupont",
                "telephone": "0612345678",
                "password": "motdepasse123",
                "password2": "motdepasse123"
            },
            request_only=True,
        )
    ],
    responses={
        200: {
            "type": "object",
            "properties": {
                "access": {"type": "string"},
                "refresh": {"type": "string"},
                "user_id": {"type": "integer"},
                "telephone": {"type": "string"},
            }
        },
        401: {"description": "Identifiants invalides"}
    }
)
class RegisterView(APIView):
    permission_classes = []  # Pas besoin d’être authentifié
    authentication_classes = []

    def post(self, request):
        serializer = UserRegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Générer les tokens JWT automatiquement après inscription
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': {
                    'id': user.id,
                    'telephone': user.telephone,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                }
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)