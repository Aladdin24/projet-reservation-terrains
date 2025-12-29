# terrains/api/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.terrain_list, name='terrain-list'),
    path('<int:pk>/', views.terrain_detail, name='terrain-detail'),
    path('evaluations/', views.create_evaluation, name='create-evaluation'),
]