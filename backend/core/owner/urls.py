# owner/urls.py
from django.urls import path
from . import views

app_name = 'owner'

urlpatterns = [
    path('login/', views.owner_login, name='login'),
    path('logout/', views.owner_logout, name='logout'),
    path('dashboard/', views.dashboard, name='dashboard'),

    # Terrains
    path('terrains/', views.terrain_list, name='terrain_list'),
    path('terrains/add/', views.terrain_create, name='terrain_add'),
    path('terrains/<int:pk>/edit/', views.terrain_update, name='terrain_edit'),
    path('terrains/<int:pk>/delete/', views.terrain_delete, name='terrain_delete'),

    # Réservations
    path('reservations/', views.reservation_list, name='reservation_list'),

    # Créneaux horaires
    path('terrains/<int:terrain_id>/creneaux/', views.creneau_list, name='creneau_list'),
    path('terrains/<int:terrain_id>/creneaux/add/', views.creneau_create, name='creneau_add'),
    path('terrains/<int:terrain_id>/creneaux/<int:creneau_id>/edit/', views.creneau_update, name='creneau_edit'),
    path('terrains/<int:terrain_id>/creneaux/<int:creneau_id>/delete/', views.creneau_delete, name='creneau_delete'),
    path(
        'terrains/<int:terrain_id>/creneaux/<int:creneau_id>/duplicate/',
        views.creneau_duplicate,
        name='creneau_duplicate'
    ),
]