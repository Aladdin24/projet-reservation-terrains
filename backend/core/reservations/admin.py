# reservations/admin.py
from django.contrib import admin
from .models import Reservation, Paiement, Groupe

@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = ('id', 'utilisateur', 'terrain', 'date_reservation', 'heure_debut', 'type_reservation', 'statut', 'prix_total')
    list_filter = ('statut', 'type_reservation', 'creneau__date')
    search_fields = ('utilisateur__telephone', 'creneau__terrain__nom')
    readonly_fields = ('date_creation', 'date_modification')
    autocomplete_fields = ('utilisateur', 'groupe')

    def terrain(self, obj):
        return obj.creneau.terrain.nom
    terrain.short_description = "Terrain"

    def date_reservation(self, obj):
        return obj.creneau.date
    date_reservation.short_description = "Date"

    def heure_debut(self, obj):
        return obj.creneau.heure_debut
    heure_debut.short_description = "Heure début"

@admin.register(Paiement)
class PaiementAdmin(admin.ModelAdmin):
    list_display = ('reservation', 'montant', 'methode', 'reference_transaction', 'date_paiement')
    list_filter = ('methode', 'date_paiement')
    search_fields = ('reference_transaction', 'reservation__utilisateur__telephone')
    autocomplete_fields = ('reservation',)

@admin.register(Groupe)
class GroupeAdmin(admin.ModelAdmin):
    list_display = ('nom', 'createur', 'date_creation', 'membres_count')
    search_fields = ('nom', 'createur__telephone')
    autocomplete_fields = ('createur', 'membres')

    def membres_count(self, obj):
        return obj.membres.count()
    membres_count.short_description = "Nb membres"