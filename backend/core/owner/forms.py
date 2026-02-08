# owner/forms.py
from django import forms
from terrains.models import Terrain, CreneauHoraire
from django.core.exceptions import ValidationError

class TerrainForm(forms.ModelForm):
    class Meta:
        model = Terrain
        fields = ['nom', 'adresse', 'latitude', 'longitude', 'image_url']
        widgets = {
            'nom': forms.TextInput(attrs={'class': 'form-control'}),
            'adresse': forms.TextInput(attrs={'class': 'form-control'}),
            'latitude': forms.NumberInput(attrs={'class': 'form-control', 'step': '0.000001'}),
            'longitude': forms.NumberInput(attrs={'class': 'form-control', 'step': '0.000001'}),
            'image_url': forms.URLInput(attrs={'class': 'form-control'}),
        }

class CreneauHoraireForm(forms.ModelForm):
    class Meta:
        model = CreneauHoraire
        fields = ['date', 'heure_debut', 'heure_fin', 'tarif']
        widgets = {
            'date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'heure_debut': forms.TimeInput(attrs={'class': 'form-control', 'type': 'time'}),
            'heure_fin': forms.TimeInput(attrs={'class': 'form-control', 'type': 'time'}),
            'tarif': forms.NumberInput(attrs={'class': 'form-control', 'step': '0.01'}),
        }

    def clean(self):
        cleaned_data = super().clean()
        heure_debut = cleaned_data.get('heure_debut')
        heure_fin = cleaned_data.get('heure_fin')

        if heure_debut and heure_fin:
            if heure_fin <= heure_debut:
                raise ValidationError("L’heure de fin doit être après l’heure de début.")
        return cleaned_data