# accounts/api/serializers.py
from django.contrib.auth import authenticate
from django.utils.translation import gettext_lazy as _
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from accounts.models import User
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Remplace le username par le telephone.
    """
    # def __init__(self, *args, **kwargs):
    #     super().__init__(*args, **kwargs)
    #     # Remplacer 'username' par 'telephone'
    #     self.fields['telephone'] = self.fields.pop('username')

    def validate(self, attrs):
        # Récupère le téléphone et le mot de passe
        telephone = attrs.get('telephone')
        password = attrs.get('password')

        if telephone and password:
            user = authenticate(request=self.context.get('request'),
                                username=telephone,  # car USERNAME_FIELD = 'telephone'
                                password=password)
            if not user:
                raise serializers.ValidationError(
                    _('Les identifiants sont invalides.'),
                    code='authorization'
                )
            # Vérifie que c'est un Utilisateur Standard
            if user.type_utilisateur != User.Type.STANDARD:
                raise serializers.ValidationError(
                    _('Seuls les utilisateurs standards peuvent se connecter ici.'),
                    code='authorization'
                )
        else:
            raise serializers.ValidationError(
                _('Vous devez fournir un téléphone et un mot de passe.'),
                code='authorization'
            )

        # Appel à la méthode parent pour générer les tokens
        data = super().validate(attrs)
        # Optionnel : ajouter des infos dans le token
        data['user_id'] = self.user.id
        data['telephone'] = self.user.telephone
        data['first_name'] = self.user.first_name
        data['last_name'] = self.user.last_name
        return data
    

class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})
    password2 = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)

    class Meta:
        model = User
        fields = ('telephone', 'first_name', 'last_name', 'password', 'password2')
        extra_kwargs = {
            'telephone': {'required': True},
        }

    def validate_telephone(self, value):
        if User.objects.filter(telephone=value).exists():
            raise serializers.ValidationError("Un compte existe déjà avec ce numéro.")
        return value

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password2": "Les mots de passe ne correspondent pas."})
        
        # Valider la solidité du mot de passe (optionnel mais recommandé)
        try:
            validate_password(attrs['password'])
        except ValidationError as e:
            raise serializers.ValidationError({"password": e.messages})
        
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(
            telephone=validated_data['telephone'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name'],
            password=validated_data['password'],
            type_utilisateur=User.Type.STANDARD  # ← Important !
        )
        return user