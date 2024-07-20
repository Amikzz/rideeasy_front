import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ride_easy/common/customappbar.dart';
import 'package:ride_easy/features/HomePage/home.dart';

class BusSchedulePage extends StatefulWidget {
  const BusSchedulePage({super.key});

  @override
  _BusSchedulePageState createState() => _BusSchedulePageState();
}

class _BusSchedulePageState extends State<BusSchedulePage> {
  List<String> towns = ['ANY'];
  List<Map<String, dynamic>> data = [];
  String src = 'ANY', des = 'ANY';

  @override
  void initState() {
    super.initState();
    fetchTowns(); // Fetch towns when the widget is first initialized
  }

  void setSrc(String? t) {
    setState(() {
      src = t ?? towns[0];
    });
  }

  void setDes(String? t) {
    setState(() {
      des = t ?? towns[0];
    });
  }

  Future<void> fetchTowns() async {
    try {
      final response = await http.get(Uri.parse(''));
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body) as List;
        setState(() {
          towns.clear();
          towns.add('ANY');
          for (Map<String, dynamic> item in result) {
            String? townName = item['start_location'];
            if (townName != null) towns.add(townName);
          }
        });
      } else {
        // Handle error
        throw Exception('Failed to load towns');
      }
    } catch (e) {
      print('Error fetching towns: $e');
    }
  }

  Future<void> search() async {
    String url = 'https://rideeasy2024.infinityfreeapp.com/api/view-bus-schedule';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          data.clear();
          List items = jsonDecode(response.body) as List;
          for (Map<String, dynamic> item in items) {
            data.add(item);
          }
        });
      } else {
        // Handle error
        throw Exception('Failed to load bus schedules');
      }
    } catch (e) {
      print('Error searching bus schedules: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: ClipPath(
          clipper: CustomAppBar(),
          child: Container(
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
                            builder: (context) => const HomePage(),
                          ),
                        ); // Navigate back
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Back',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SOURCE'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: src,
                      items: towns.map((element) {
                        return DropdownMenuItem(
                            value: element, child: Text(element));
                      }).toList(),
                      onChanged: setSrc,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DESTINATION'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: des,
                      items: towns.map((element) {
                        return DropdownMenuItem(
                            value: element, child: Text(element));
                      }).toList(),
                      onChanged: setDes,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton.icon(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: search,
            label: const Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) => BusCard(data: data[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const BusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SOURCE',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      data['start_location']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '→',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'DESTINATION',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      data['end_location']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.directions,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Date: ${data['date']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  'Departure: ${data['departure_time']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  'Arrival: ${data['arrival_time']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  'Bus No: ${data['bus_license_plate_no']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}