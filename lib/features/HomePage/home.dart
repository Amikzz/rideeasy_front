import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_easy/features/BusShedule/busshedule.dart';
import 'package:ride_easy/features/BusTracking/bustracking.dart';
import 'package:ride_easy/features/LoginPage/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  String _currentCity = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getUser();
    _getCurrentLocation();
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentCity = "Location services are disabled.";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentCity = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentCity = "Location permissions are permanently denied";
      });
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the placemark from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    // Get the first placemark which contains the city name
    Placemark place = placemarks[0];
    setState(() {
      _currentCity = place.locality ?? "Unknown";
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or wherever appropriate after logout
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      // Handle error during logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _user != null ? 'Hello, \n${_user!.email}' : 'Hello, User',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'updateProfile') {
                        // Navigate to profile update page
                        Navigator.pushNamed(context, '/profileUpdate');
                      } else if (value == 'logout') {
                        _logout();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'updateProfile',
                          child: Text('Profile Update'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Log Out'),
                        ),
                      ];
                    },
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png',
                        scale: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Now',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  _currentCity,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.map_outlined)
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                children: [
                  _buildButton(
                    context: context,
                    title: 'Bus Tracking',
                    targetPage: const BusTrackingPage(),
                    image: const AssetImage('assets/images/track.png'),
                  ),
                  _buildButton(
                    context: context,
                    title: 'Bus Schedule',
                    image: const AssetImage('assets/images/shedule.png'),
                    targetPage: const BusSchedulePage(),
                  ),
                  _buildButton(
                    context: context,
                    title: 'Ticket Booking',
                    image: const AssetImage('assets/images/ticket.png'),
                    targetPage: const BusSchedulePage(),
                  ),
                  _buildButton(
                    context: context,
                    title: 'Bus Seat Reserve',
                    image: const AssetImage('assets/images/seat.png'),
                    targetPage: const BusSchedulePage(),
                  ),
                  _buildButton(
                    context: context,
                    title: 'Support',
                    image: const AssetImage('assets/images/support.png'),
                    targetPage: const BusSchedulePage(),
                  ),
                  _buildButton(
                    context: context,
                    title: 'Games',
                    image: const AssetImage('assets/images/games.png'),
                    targetPage: const BusSchedulePage(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  'Safety',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String title,
    required AssetImage image,
    required Widget targetPage,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shadowColor: Colors.green,
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: image, height: 100, width: 160),
          const SizedBox(height: 1),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
