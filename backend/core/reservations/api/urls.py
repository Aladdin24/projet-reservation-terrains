# reservations/api/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.create_reservation, name='reservation-create'),
    path('my-reservations/', views.reservation_list, name='my-reservations'),
    path('<int:reservation_id>/cancel/', views.cancel_reservation, name='reservation-cancel'),
]