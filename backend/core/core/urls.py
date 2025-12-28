from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # Web interfaces
    # path('owner/', include('owner.urls')),
    # path('admin-panel/', include('admin_custom.urls')),
    
    # API
    path('api/auth/', include('accounts.api.urls')),
    path('api/terrains/', include('terrains.api.urls')),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # path('api/reservations/', include('reservations.api.urls')),
]