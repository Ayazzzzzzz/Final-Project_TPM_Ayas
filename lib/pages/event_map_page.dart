import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ta_mobile_ayas/models/event_item_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventMapPage extends StatefulWidget {
  final EventItem event;
  const EventMapPage({super.key, required this.event});

  @override
  State<EventMapPage> createState() => _EventMapPageState();
}

class _EventMapPageState extends State<EventMapPage> {
  GoogleMapController? _mapController;
  Position? _userPosition;
  bool _isLoading = true;
  late LatLng _eventPosition;

  @override
  void initState() {
    super.initState();
    if (widget.event.latitude != null && widget.event.longitude != null) {
      _eventPosition = LatLng(widget.event.latitude!, widget.event.longitude!);
      _determineUserPosition();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _determineUserPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak.')));
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userPosition = position;
          _isLoading = false;
        });

        // Pusatkan kamera di tengah dua titik
        _zoomToFitBounds();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
      }
    }
  }

  void _zoomToFitBounds() {
    if (_userPosition == null || _mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(_userPosition!.latitude, _eventPosition.latitude),
        min(_userPosition!.longitude, _eventPosition.longitude),
      ),
      northeast: LatLng(
        max(_userPosition!.latitude, _eventPosition.latitude),
        max(_userPosition!.longitude, _eventPosition.longitude),
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  Future<void> _launchExternalMaps() async {
    final lat = widget.event.latitude;
    final lng = widget.event.longitude;
    if (lat == null || lng == null) return;

    final Uri uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak dapat membuka aplikasi peta.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event.latitude == null || widget.event.longitude == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.event.title)),
        body:
            const Center(child: Text("Acara ini tidak memiliki lokasi fisik.")),
      );
    }

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("event"),
        position: _eventPosition,
        infoWindow: InfoWindow(title: widget.event.title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    if (_userPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          infoWindow: const InfoWindow(title: "Lokasi Anda"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _eventPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text("Mencari Lokasi...",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchExternalMaps,
        label: const Text('Mulai Navigasi'),
        icon: const Icon(Icons.navigation_outlined),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
