# terrains/models.py
from django.db import models
from accounts.models import User

class Terrain(models.Model):
    nom = models.CharField(max_length=100)
    adresse = models.CharField(max_length=255)
    latitude = models.DecimalField(max_digits=9, decimal_places=6)
    longitude = models.DecimalField(max_digits=9, decimal_places=6)
    proprietaire = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'type_utilisateur': User.Type.PROPRIETAIRE}
    )
    image_url = models.URLField(blank=True)
    note_moyenne = models.FloatField(default=0.0)
    valide = models.BooleanField(default=False, verbose_name="Validé par l'admin")
    date_validation = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.nom

class CreneauHoraire(models.Model):
    terrain = models.ForeignKey(Terrain, related_name='creneaux', on_delete=models.CASCADE)
    heure_debut = models.TimeField()
    heure_fin = models.TimeField()
    tarif = models.DecimalField(max_digits=10, decimal_places=2)
    date = models.DateField()
    disponible = models.BooleanField(default=True)

    class Meta:
        unique_together = ('terrain', 'date', 'heure_debut')
        verbose_name = "Créneau Horaire"
        verbose_name_plural = "Créneaux Horaires"

    def __str__(self):
        return f"{self.terrain.nom} - {self.date} {self.heure_debut}-{self.heure_fin}"

class Evaluation(models.Model):
    terrain = models.ForeignKey(Terrain, related_name='evaluations', on_delete=models.CASCADE)
    utilisateur = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'type_utilisateur': User.Type.STANDARD}
    )
    note = models.PositiveSmallIntegerField()  # 1 à 5
    commentaire = models.TextField(blank=True)
    date_creation = models.DateTimeField(auto_now_add=True)