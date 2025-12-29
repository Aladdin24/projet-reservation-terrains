# accounts/admin.py
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import Group
from .models import User

class UserAdmin(BaseUserAdmin):
    list_display = ('telephone', 'first_name', 'last_name', 'type_utilisateur', 'is_active', 'date_joined')
    list_filter = ('type_utilisateur', 'is_active', 'is_staff')
    fieldsets = (
        (None, {'fields': ('telephone', 'password')}),
        ('Informations personnelles', {'fields': ('first_name', 'last_name')}),
        ('Permissions', {'fields': ('type_utilisateur', 'is_active', 'is_staff', 'is_superuser')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('telephone', 'first_name', 'last_name', 'type_utilisateur', 'password1', 'password2'),
        }),
    )
    search_fields = ('telephone', 'first_name', 'last_name')
    ordering = ('telephone',)
    filter_horizontal = ()

# Désactiver le groupe par défaut (optionnel)
admin.site.unregister(Group)

# Enregistrer le modèle personnalisé
admin.site.register(User, UserAdmin)