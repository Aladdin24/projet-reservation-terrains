# admin_custom/views.py
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.db.models import Count
from accounts.models import User
from terrains.models import Terrain, Evaluation
from django.shortcuts import get_object_or_404
from django.contrib import messages
from django.utils import timezone
from reservations.models import Reservation


def admin_login(request):
    error = None
    if request.method == "POST":
        telephone = request.POST.get('telephone')
        password = request.POST.get('password')
        user = authenticate(request, username=telephone, password=password)
        if user and user.type_utilisateur == User.Type.ADMIN:
            login(request, user)
            return redirect('admin_custom:dashboard')
        else:
            error = "Accès réservé aux administrateurs."
    return render(request, 'admin_custom/login.html', {'error': error})

def admin_logout(request):
    logout(request)
    return redirect('admin_custom:login')

@login_required
def dashboard(request):
    if request.user.type_utilisateur != request.user.Type.ADMIN:
        return redirect('admin_custom:login')
    stats = {
        'terrains_total': Terrain.objects.count(),
        'terrains_a_valider': Terrain.objects.filter(valide=False).count(),
        'proprietaires': User.objects.filter(type_utilisateur=User.Type.PROPRIETAIRE).count(),
        'utilisateurs_standards': User.objects.filter(type_utilisateur=User.Type.STANDARD).count(),
        'evaluations': Evaluation.objects.count(),
    }
    return render(request, 'admin_custom/dashboard.html', {'stats': stats})



@login_required
def terrain_list(request):
    terrains = Terrain.objects.select_related('proprietaire').all()
    # Filtre optionnel
    statut = request.GET.get('statut')
    if statut == 'attente':
        terrains = terrains.filter(valide=False)
    elif statut == 'valide':
        terrains = terrains.filter(valide=True)
    return render(request, 'admin_custom/terrain_list.html', {'terrains': terrains})

@login_required
def terrain_validate(request, terrain_id):
    terrain = get_object_or_404(Terrain, id=terrain_id)
    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'valider':
            terrain.valide = True
            terrain.date_validation = timezone.now()
            terrain.save(update_fields=['valide', 'date_validation'])
            messages.success(request, f"Le terrain '{terrain.nom}' est maintenant validé.")
        elif action == 'rejeter':
            # Optionnel : supprimer ou garder non validé
            terrain.delete()
            messages.warning(request, "Le terrain a été supprimé.")
        return redirect('admin_custom:terrain_list')
    return render(request, 'admin_custom/terrain_detail.html', {'terrain': terrain})


@login_required
def user_list(request):
    role = request.GET.get('role')
    if role == 'PROPRIETAIRE':
        users = User.objects.filter(type_utilisateur=User.Type.PROPRIETAIRE)
        title = "Liste des Propriétaires"
    elif role == 'STANDARD':
        users = User.objects.filter(type_utilisateur=User.Type.STANDARD)
        title = "Liste des Utilisateurs Standards"
    else:
        users = User.objects.all()
        title = "Tous les Utilisateurs"

    return render(request, 'admin_custom/user_list.html', {
        'users': users,
        'title': title,
        'role': role
    })

@login_required
def evaluation_list(request):
    evaluations = Evaluation.objects.select_related('terrain', 'utilisateur').order_by('-date_creation')
    return render(request, 'admin_custom/evaluation_list.html', {
        'evaluations': evaluations
    })

@login_required
def evaluation_delete(request, evaluation_id):
    if request.method == 'POST':
        evaluation = get_object_or_404(Evaluation, id=evaluation_id)
        evaluation.delete()
        messages.success(request, "Évaluation supprimée.")
    return redirect('admin_custom:evaluation_list')

@login_required
def reservation_list(request):
    reservations = Reservation.objects.select_related(
        'utilisateur', 'creneau__terrain', 'groupe'
    ).order_by('-date_creation')
    
    # Filtre optionnel par statut
    statut = request.GET.get('statut')
    if statut:
        reservations = reservations.filter(statut=statut)

    return render(request, 'admin_custom/reservation_list.html', {
        'reservations': reservations
    })