# Script de création de structure Flutter - App Réservation Terrains
# Exécution: .\create_flutter_structure.ps1

Write-Host "🚀 Création de la structure du projet Flutter..." -ForegroundColor Cyan

# Créer le dossier racine lib s'il n'existe pas
New-Item -ItemType Directory -Force -Path "lib" | Out-Null

# Fichiers racine
$rootFiles = @(
    "lib/main.dart",
    "lib/themes.dart",
    "lib/initial_bindings.dart"
)

# Dossiers et fichiers routes
$routesFiles = @(
    "lib/routes/app_routes.dart",
    "lib/routes/app_pages.dart"
)

# Dossiers et fichiers api
$apiFiles = @(
    "lib/api/api_constants.dart",
    "lib/api/dio_client.dart",
    "lib/api/interceptors.dart"
)

# Dossiers et fichiers data/models
$modelsFiles = @(
    "lib/data/models/user_model.dart",
    "lib/data/models/terrain_model.dart",
    "lib/data/models/reservation_model.dart",
    "lib/data/models/paiement_model.dart",
    "lib/data/models/evaluation_model.dart",
    "lib/data/models/creneau_horaire_model.dart",
    "lib/data/models/enums/type_reservation.dart",
    "lib/data/models/enums/statut_reservation.dart",
    "lib/data/models/enums/type_terrain.dart",
    "lib/data/models/enums/statut_paiement.dart",
    "lib/data/models/enums/methode_paiement.dart"
)

# Dossiers et fichiers data/services
$servicesFiles = @(
    "lib/data/services/auth_service.dart",
    "lib/data/services/storage_service.dart",
    "lib/data/services/terrain_service.dart",
    "lib/data/services/reservation_service.dart",
    "lib/data/services/paiement_service.dart",
    "lib/data/services/evaluation_service.dart"
)

# Module auth
$authFiles = @(
    "lib/modules/auth/controllers/login_controller.dart",
    "lib/modules/auth/controllers/register_controller.dart",
    "lib/modules/auth/views/login_view.dart",
    "lib/modules/auth/views/register_view.dart",
    "lib/modules/auth/widgets/auth_button.dart",
    "lib/modules/auth/widgets/auth_text_field.dart",
    "lib/modules/auth/bindings.dart"
)

# Module core
$coreFiles = @(
    "lib/modules/core/controllers/home_controller.dart",
    "lib/modules/core/controllers/search_terrain_controller.dart",
    "lib/modules/core/controllers/terrain_details_controller.dart",
    "lib/modules/core/controllers/reservation_controller.dart",
    "lib/modules/core/controllers/mes_reservations_controller.dart",
    "lib/modules/core/controllers/evaluation_controller.dart",
    "lib/modules/core/controllers/profile_controller.dart",
    "lib/modules/core/controllers/notification_controller.dart",
    "lib/modules/core/controllers/settings_controller.dart",
    "lib/modules/core/views/home_view.dart",
    "lib/modules/core/views/search_terrain_view.dart",
    "lib/modules/core/views/terrain_details_view.dart",
    "lib/modules/core/views/reservation_view.dart",
    "lib/modules/core/views/mes_reservations_view.dart",
    "lib/modules/core/views/evaluation_view.dart",
    "lib/modules/core/views/profile_view.dart",
    "lib/modules/core/views/notifications_view.dart",
    "lib/modules/core/views/settings_view.dart",
    "lib/modules/core/widgets/custom_appbar.dart",
    "lib/modules/core/widgets/custom_drawer.dart",
    "lib/modules/core/widgets/terrain_card.dart",
    "lib/modules/core/widgets/reservation_card.dart",
    "lib/modules/core/widgets/rating_widget.dart",
    "lib/modules/core/widgets/custom_button.dart",
    "lib/modules/core/widgets/loading_widget.dart",
    "lib/modules/core/bindings.dart"
)

# Combiner tous les fichiers
$allFiles = $rootFiles + $routesFiles + $apiFiles + $modelsFiles + $servicesFiles + $authFiles + $coreFiles

# Créer tous les fichiers
foreach ($file in $allFiles) {
    # Créer le dossier parent si nécessaire
    $directory = Split-Path -Path $file -Parent
    if ($directory -and !(Test-Path $directory)) {
        New-Item -ItemType Directory -Force -Path $directory | Out-Null
    }
    
    # Créer le fichier avec un commentaire
    $fileName = Split-Path -Path $file -Leaf
    $comment = "// TODO: Implement $fileName"
    Set-Content -Path $file -Value $comment
    
    Write-Host "✓ Créé: $file" -ForegroundColor Green
}

Write-Host ""
Write-Host "✨ Structure créée avec succès!" -ForegroundColor Green
Write-Host "📂 Total de fichiers créés: $($allFiles.Count)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Prochaines étapes:" -ForegroundColor Cyan
Write-Host "  1. cd lib" -ForegroundColor White
Write-Host "  2. Ouvrir le projet dans VS Code" -ForegroundColor White
Write-Host "  3. Installer les dépendances: flutter pub get" -ForegroundColor White
Write-Host ""
