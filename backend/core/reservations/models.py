from django.db import models
from accounts.models import User
from terrains.models import CreneauHoraire

class Groupe(models.Model):
    nom = models.CharField(max_length=100)
    createur = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'type_utilisateur': User.Type.STANDARD}
    )
    membres = models.ManyToManyField(
        User,
        related_name='groupes',
        limit_choices_to={'type_utilisateur': User.Type.STANDARD}
    )
    date_creation = models.DateTimeField(auto_now_add=True)

class Reservation(models.Model):
    class Type(models.TextChoices):
        INDIVIDUELLE = "INDIVIDUELLE"
        GROUPE = "GROUPE"
        ORGANISATION = "ORGANISATION"

    class Statut(models.TextChoices):
        EN_ATTENTE = "EN_ATTENTE"
        CONFIRMEE = "CONFIRMEE"
        ANNULEE = "ANNULEE"
        PAYEE = "PAYEE"
        REMBOURSEE = "REMBOURSEE"

    utilisateur = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'type_utilisateur': User.Type.STANDARD}
    )
    creneau = models.ForeignKey(CreneauHoraire, on_delete=models.CASCADE)
    groupe = models.ForeignKey(Groupe, on_delete=models.SET_NULL, null=True, blank=True)
    type_reservation = models.CharField(max_length=20, choices=Type.choices)
    statut = models.CharField(max_length=20, choices=Statut.choices, default=Statut.EN_ATTENTE)
    prix_total = models.DecimalField(max_digits=10, decimal_places=2)
    date_creation = models.DateTimeField(auto_now_add=True)
    date_modification = models.DateTimeField(auto_now=True)

class Paiement(models.Model):
    class Methode(models.TextChoices):
        CARTE = "CARTE"
        MOBILE = "MOBILE"
        TRANSFERT = "TRANSFERT"

    reservation = models.OneToOneField(Reservation, on_delete=models.CASCADE)
    montant = models.DecimalField(max_digits=10, decimal_places=2)
    methode = models.CharField(max_length=20, choices=Methode.choices)
    reference_transaction = models.CharField(max_length=100, unique=True)
    date_paiement = models.DateTimeField(auto_now_add=True)