from django.contrib.auth.models import AbstractUser
from django.db import models
from .managers import UserManager

class User(AbstractUser):

    class Type(models.TextChoices):
        ADMIN = "ADMIN", "Administrateur"
        PROPRIETAIRE = "PROPRIETAIRE", "Propriétaire de terrain"
        STANDARD = "STANDARD", "Utilisateur standard"

    username = None  # 🔥 supprimé
    telephone = models.CharField(max_length=15, unique=True)
    type_utilisateur = models.CharField(
        max_length=20,
        choices=Type.choices,
        default=Type.STANDARD
    )

    USERNAME_FIELD = 'telephone'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    objects = UserManager()  # 🔥 OBLIGATOIRE

    def __str__(self):
        return self.telephone
