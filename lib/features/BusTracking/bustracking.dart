import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/customappbar.dart';
import '../HomePage/home.dart';

class BusTrackingPage extends StatefulWidget {
  const BusTrackingPage({super.key});

  @override
  State<BusTrackingPage> createState() => _BusTrackingPageState();
}

class _BusTrackingPageState extends State<BusTrackingPage> {
  static const LatLng _initialLocation = LatLng(6.9271, 79.8612); // Replace with your desired location
  static const double _initialZoomLevel = 11.0; // Adjust zoom level as needed

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: _initialLocation,
    zoom: _initialZoomLevel,
  );

  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen sized Google Map
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          // Custom app bar positioned on top (choose one approach)
          // Option 1: Using ClipPath and Container
          PreferredSize(
            preferredSize: const Size.fromHeight(200), // Adjust height as needed
            child: ClipPath(
              clipper: CustomAppBar(),
              child: Container(
                height: 200, // Adjust height for app bar
                width: double.infinity,
                color: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePage())); // Navigate back
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Text(
                          'Bus Tracking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    const SizedBox(width: 50), // Adjust spacing as needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}