// lib/utils/cluster_manager.dart
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class TerrainCluster {
  final LatLng position;
  final List<gmaps.Marker> markers;
  final int count;

  TerrainCluster(this.position, this.markers) : count = markers.length;
}

class ClusterManager {
  static List<gmaps.Marker> clusterMarkers(
    List<gmaps.Marker> markers,
    double zoom,
  ) {
    if (zoom < 10) {
      // Zoom arrière → regrouper
      return _createClusterMarkers(markers);
    } else {
      // Zoom avant → afficher tous les marqueurs
      return markers;
    }
  }

  static List<gmaps.Marker> _createClusterMarkers(List<gmaps.Marker> markers) {
    final clusters = <TerrainCluster>[];
    final processed = <gmaps.Marker>{};

    for (var marker in markers) {
      if (processed.contains(marker)) continue;

      final clusterMarkers = <gmaps.Marker>[marker];
      processed.add(marker);

      // Rechercher les marqueurs proches (dans un rayon de 1 km)
      for (var other in markers) {
        if (processed.contains(other)) continue;
        final distance = _calculateDistance(marker.position as LatLng, other.position as LatLng);
        if (distance < 1.0) { // en kilomètres
          clusterMarkers.add(other);
          processed.add(other);
        }
      }

      final center = _computeClusterCenter(clusterMarkers);
      clusters.add(TerrainCluster(center, clusterMarkers));
    }

    // Convertir les clusters en marqueurs
    return clusters.map((cluster) {
      return gmaps.Marker(
        markerId: gmaps.MarkerId('cluster_${clusters.indexOf(cluster)}'),
        position: gmaps.LatLng(cluster.position.latitude, cluster.position.longitude),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueAzure,
        ),
        infoWindow: gmaps.InfoWindow(
          title: '${cluster.count} terrains',
          snippet: 'Cliquez pour zoomer',
        ),
        onTap: () {
          // Optionnel : zoomer sur le cluster
        },
      );
    }).toList();
  }

  static double _calculateDistance(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    ) / 1000; // en km
  }

  static LatLng _computeClusterCenter(List<gmaps.Marker> markers) {
    double latSum = 0, lngSum = 0;
    for (var m in markers) {
      latSum += m.position.latitude;
      lngSum += m.position.longitude;
    }
    return LatLng(latSum / markers.length, lngSum / markers.length);
  }
}