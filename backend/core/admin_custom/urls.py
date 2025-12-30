# admin_custom/urls.py
from django.urls import path
from . import views

app_name = 'admin_custom'

urlpatterns = [
    path('login/', views.admin_login, name='login'),
    path('logout/', views.admin_logout, name='logout'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('terrains/', views.terrain_list, name='terrain_list'),
    path('terrains/<int:terrain_id>/validate/', views.terrain_validate, name='terrain_validate'),
    path('users/', views.user_list, name='user_list'),
    path('evaluations/', views.evaluation_list, name='evaluation_list'),
    path('evaluations/<int:evaluation_id>/delete/', views.evaluation_delete, name='evaluation_delete'),
    path('reservations/', views.reservation_list, name='reservation_list'),
]