# terrains/admin.py
from django.contrib import admin
from .models import Terrain, CreneauHoraire, Evaluation

@admin.register(Terrain)
class TerrainAdmin(admin.ModelAdmin):
    list_display = ('nom', 'adresse', 'proprietaire', 'note_moyenne', 'date_ajout')
    list_filter = ('proprietaire', 'note_moyenne')
    search_fields = ('nom', 'adresse')
    readonly_fields = ('note_moyenne',)
    autocomplete_fields = ('proprietaire',)

    def date_ajout(self, obj):
        return obj.evaluations.first().date_creation if obj.evaluations.exists() else "–"
    date_ajout.short_description = "Date d'ajout (approx.)"

@admin.register(CreneauHoraire)
class CreneauHoraireAdmin(admin.ModelAdmin):
    list_display = ('terrain', 'date', 'heure_debut', 'heure_fin', 'tarif', 'disponible')
    list_filter = ('date', 'disponible', 'terrain__nom')
    search_fields = ('terrain__nom',)
    autocomplete_fields = ('terrain',)

@admin.register(Evaluation)
class EvaluationAdmin(admin.ModelAdmin):
    list_display = ('terrain', 'utilisateur', 'note', 'date_creation', 'commentaire_preview')
    list_filter = ('note', 'date_creation', 'terrain')
    search_fields = ('terrain__nom', 'utilisateur__telephone', 'commentaire')
    autocomplete_fields = ('terrain', 'utilisateur')

    def commentaire_preview(self, obj):
        if obj.commentaire:
            return obj.commentaire[:50] + ('...' if len(obj.commentaire) > 50 else '')
        return "–"
    commentaire_preview.short_description = "Commentaire"