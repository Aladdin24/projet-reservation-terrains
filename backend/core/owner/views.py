# owner/views.py
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView
from django.urls import reverse_lazy
from django import forms
from django.db.models import Sum   #from accounts import models
from accounts.models import User
from django.contrib import messages
from .forms import TerrainForm, CreneauHoraireForm
from terrains.models import Terrain, CreneauHoraire
from reservations.models import Reservation
from datetime import timedelta
from django.db import transaction
from calendar import weekday, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY

class OwnerLoginForm(forms.Form):
    telephone = forms.CharField(max_length=15)
    password = forms.CharField(widget=forms.PasswordInput)

def owner_login(request):
    error = None
    if request.method == "POST":
        form = OwnerLoginForm(request.POST)
        if form.is_valid():
            telephone = form.cleaned_data['telephone']
            password = form.cleaned_data['password']
            user = authenticate(request, username=telephone, password=password)
            if user and user.type_utilisateur == User.Type.PROPRIETAIRE:
                login(request, user)
                return redirect('owner:dashboard')
            else:
                error = "Numéro ou mot de passe invalide, ou vous n’êtes pas propriétaire."
    else:
        form = OwnerLoginForm()
    return render(request, 'owner/login.html', {'form': form, 'error': error})

def owner_logout(request):
    logout(request)
    return redirect('owner:login')

@login_required
def dashboard(request):
    terrains_count = request.user.terrain_set.count()
    reservations_count = request.user.terrain_set.filter(
        creneaux__reservation__isnull=False
    ).count()
    gains = request.user.terrain_set.filter(
        creneaux__reservation__statut='PAYEE'
    ).aggregate(total=Sum('creneaux__reservation__prix_total'))['total'] or 0

    return render(request, 'owner/dashboard.html', {
        'terrains_count': terrains_count,
        'reservations_count': reservations_count,
        'gains': gains,
    })



#--------------------CRUD pour les terrains--------------------
@login_required
def terrain_list(request):
    terrains = request.user.terrain_set.all()
    return render(request, 'owner/terrain_list.html', {'terrains': terrains})

@login_required
def terrain_create(request):
    if request.method == 'POST':
        form = TerrainForm(request.POST)
        if form.is_valid():
            terrain = form.save(commit=False)
            terrain.proprietaire = request.user
            terrain.save()
            messages.success(request, "Terrain ajouté avec succès.")
            return redirect('owner:terrain_list')
    else:
        form = TerrainForm()
    return render(request, 'owner/terrain_form.html', {'form': form, 'title': "Ajouter un terrain"})

@login_required
def terrain_update(request, pk):
    terrain = get_object_or_404(Terrain, pk=pk, proprietaire=request.user)
    if request.method == 'POST':
        form = TerrainForm(request.POST, instance=terrain)
        if form.is_valid():
            form.save()
            messages.success(request, "Terrain mis à jour.")
            return redirect('owner:terrain_list')
    else:
        form = TerrainForm(instance=terrain)
    return render(request, 'owner/terrain_form.html', {'form': form, 'title': "Modifier le terrain"})

@login_required
def terrain_delete(request, pk):
    terrain = get_object_or_404(Terrain, pk=pk, proprietaire=request.user)
    if request.method == 'POST':
        terrain.delete()
        messages.success(request, "Terrain supprimé.")
        return redirect('owner:terrain_list')
    return render(request, 'owner/terrain_confirm_delete.html', {'terrain': terrain})


#--------------------Réservations reçues--------------------
@login_required
def reservation_list(request):
    # Réservations liées aux terrains du propriétaire
    reservations = Reservation.objects.filter(
        creneau__terrain__proprietaire=request.user
    ).select_related(
        'utilisateur', 'creneau', 'creneau__terrain'
    ).order_by('-date_creation')

    return render(request, 'owner/reservation_list.html', {'reservations': reservations})




#--------------------CRUD pour les créneaux horaires--------------------
@login_required
def creneau_list(request, terrain_id):
    terrain = get_object_or_404(Terrain, pk=terrain_id, proprietaire=request.user)
    creneaux = terrain.creneaux.all().order_by('date', 'heure_debut')
    return render(request, 'owner/creneau_list.html', {
        'terrain': terrain,
        'creneaux': creneaux
    })

@login_required
def creneau_create(request, terrain_id):
    terrain = get_object_or_404(Terrain, pk=terrain_id, proprietaire=request.user)
    if request.method == 'POST':
        form = CreneauHoraireForm(request.POST)
        if form.is_valid():
            creneau = form.save(commit=False)
            creneau.terrain = terrain
            creneau.save()
            messages.success(request, "Créneau ajouté avec succès.")
            return redirect('owner:creneau_list', terrain_id=terrain.id)
    else:
        form = CreneauHoraireForm()
    return render(request, 'owner/creneau_form.html', {
        'form': form,
        'terrain': terrain,
        'title': "Ajouter un créneau"
    })

@login_required
def creneau_update(request, terrain_id, creneau_id):
    terrain = get_object_or_404(Terrain, pk=terrain_id, proprietaire=request.user)
    creneau = get_object_or_404(CreneauHoraire, pk=creneau_id, terrain=terrain)
    if request.method == 'POST':
        form = CreneauHoraireForm(request.POST, instance=creneau)
        if form.is_valid():
            form.save()
            messages.success(request, "Créneau mis à jour.")
            return redirect('owner:creneau_list', terrain_id=terrain.id)
    else:
        form = CreneauHoraireForm(instance=creneau)
    return render(request, 'owner/creneau_form.html', {
        'form': form,
        'terrain': terrain,
        'title': "Modifier le créneau"
    })

@login_required
def creneau_delete(request, terrain_id, creneau_id):
    terrain = get_object_or_404(Terrain, pk=terrain_id, proprietaire=request.user)
    creneau = get_object_or_404(CreneauHoraire, pk=creneau_id, terrain=terrain)
    if request.method == 'POST':
        creneau.delete()
        messages.success(request, "Créneau supprimé.")
        return redirect('owner:creneau_list', terrain_id=terrain.id)
    return render(request, 'owner/creneau_confirm_delete.html', {
        'creneau': creneau,
        'terrain': terrain
    })


@login_required
def creneau_duplicate(request, terrain_id, creneau_id):
    terrain = get_object_or_404(Terrain, pk=terrain_id, proprietaire=request.user)
    original_creneau = get_object_or_404(CreneauHoraire, pk=creneau_id, terrain=terrain)

    # Mapping jour → numéro (lundi=0, dimanche=6)
    JOURS = [
        ('lundi', 'Lundi', 0),
        ('mardi', 'Mardi', 1),
        ('mercredi', 'Mercredi', 2),
        ('jeudi', 'Jeudi', 3),
        ('vendredi', 'Vendredi', 4),
        ('samedi', 'Samedi', 5),
        ('dimanche', 'Dimanche', 6),
    ]

    if request.method == 'POST':
        frequence = request.POST.get('frequence', 'quotidien')
        duree = int(request.POST.get('duree', 7))
        jours_selectionnes = request.POST.getlist('jours')

        if frequence == 'quotidien':
            dates_a_creer = []
            for i in range(1, duree + 1):
                new_date = original_creneau.date + timedelta(days=i)
                dates_a_creer.append(new_date)
        else:  # hebdomadaire
            if not jours_selectionnes:
                messages.error(request, "Veuillez sélectionner au moins un jour de la semaine.")
                return render(request, 'owner/creneau_duplicate.html', {
                    'terrain': terrain,
                    'creneau': original_creneau,
                    'jours': JOURS,
                    'selected_jours': jours_selectionnes,
                    'frequence': frequence,
                    'duree': duree,
                })

            # Convertir les jours sélectionnés en numéros
            jours_numeros = []
            for jour_str in jours_selectionnes:
                for code, _, num in JOURS:
                    if code == jour_str:
                        jours_numeros.append(num)
                        break

            dates_a_creer = []
            current_date = original_creneau.date + timedelta(days=1)
            weeks_count = 0
            max_days = duree * 7  # pour éviter boucle infinie

            while weeks_count < duree and len(dates_a_creer) < max_days:
                if current_date.weekday() in jours_numeros:
                    dates_a_creer.append(current_date)
                current_date += timedelta(days=1)
                if current_date.weekday() == 0:  # Lundi = début de semaine
                    weeks_count += 1

        # Supprimer les doublons et les dates déjà existantes
        dates_uniques = []
        for d in dates_a_creer:
            if not CreneauHoraire.objects.filter(
                terrain=terrain,
                date=d,
                heure_debut=original_creneau.heure_debut
            ).exists():
                dates_uniques.append(d)

        # Créer les créneaux
        with transaction.atomic():
            for d in dates_uniques:
                CreneauHoraire.objects.create(
                    terrain=terrain,
                    date=d,
                    heure_debut=original_creneau.heure_debut,
                    heure_fin=original_creneau.heure_fin,
                    tarif=original_creneau.tarif,
                    disponible=True
                )

        messages.success(request, f"{len(dates_uniques)} créneaux créés avec succès.")
        return redirect('owner:creneau_list', terrain_id=terrain.id)

    # Prévisualisation en GET
    frequence = request.GET.get('frequence', 'quotidien')
    duree_param = request.GET.get('duree')

    try:
        duree = int(duree_param) if duree_param else 7
    except ValueError:
        duree = 7
    jours_selectionnes = request.GET.getlist('jours')

    # Générer les dates de prévisualisation
    dates_preview = []
    if frequence == 'quotidien':
        for i in range(1, duree + 1):
            dates_preview.append(original_creneau.date + timedelta(days=i))
    else:
        jours_numeros = []
        for jour_str in jours_selectionnes:
            for code, _, num in JOURS:
                if code == jour_str:
                    jours_numeros.append(num)
                    break

        current_date = original_creneau.date + timedelta(days=1)
        weeks_count = 0
        while weeks_count < duree:
            if current_date.weekday() in jours_numeros:
                dates_preview.append(current_date)
            current_date += timedelta(days=1)
            if current_date.weekday() == 0:
                weeks_count += 1

        # Limiter la prévisualisation à 30 dates max
        dates_preview = dates_preview[:30]

    return render(request, 'owner/creneau_duplicate.html', {
        'terrain': terrain,
        'creneau': original_creneau,
        'jours': JOURS,
        'selected_jours': jours_selectionnes,
        'frequence': frequence,
        'duree': duree,
        'dates_preview': dates_preview,
    })