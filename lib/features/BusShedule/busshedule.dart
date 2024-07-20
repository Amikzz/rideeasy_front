import 'package:flutter/material.dart';

import '../HomePage/home.dart';

class BusSchedulePage extends StatefulWidget {
  const BusSchedulePage({super.key});

  @override
  _BusSchedulePageState createState() => _BusSchedulePageState();
}

class _BusSchedulePageState extends State<BusSchedulePage> {
  // Dummy JSON data
  final List<Map<String, dynamic>> dummyData = [
    {
      "trip_id": "1SdMUdIO8s-3",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "10:02:31",
      "arrival_time": "12:02:31"
    },
    {
      "trip_id": "1SdMUdIO8s-4",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "12:02:31",
      "arrival_time": "14:02:31"
    },
    {
      "trip_id": "1SdMUdIO8s-5",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "14:02:31",
      "arrival_time": "16:02:31"
    },
    {
      "trip_id": "1SdMUdIO8s-6",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "16:02:31",
      "arrival_time": "18:02:31"
    },
    {
      "trip_id": "1SdMUdIO8s-8",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "20:02:31",
      "arrival_time": "22:02:31"
    },
    {
      "trip_id": "1SdMUdIO8s-9",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "22:02:31",
      "arrival_time": "00:02:31"
    },
    {
      "trip_id": "9v2H0WfjwP-1",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "05:38:21",
      "arrival_time": "07:38:21"
    },
    {
      "trip_id": "9v2H0WfjwP-10",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "23:38:21",
      "arrival_time": "01:38:21"
    },
    {
      "trip_id": "9v2H0WfjwP-2",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "07:38:21",
      "arrival_time": "09:38:21"
    },
    {
      "trip_id": "9v2H0WfjwP-3",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "09:38:21",
      "arrival_time": "11:38:21"
    },
    {
      "trip_id": "9v2H0WfjwP-4",
      "bus_license_plate_no": "ABC-123",
      "start_location": "Colombo Fort",
      "end_location": "Kottawa",
      "date": "2024-07-18",
      "departure_time": "11:38:21",
      "arrival_time": "13:38:21"
    },
  ];

  List<String> startLocations = ['ANY'];
  List<String> endLocations = ['ANY'];
  List<Map<String, dynamic>> data = [];
  String src = 'ANY', des = 'ANY';
  String startTime = '', endTime = '', date = '';

  @override
  void initState() {
    super.initState();
    fetchTowns(); // Fetch towns when the widget is first initialized
  }

  void setSrc(String? t) {
    setState(() {
      src = t ?? startLocations[0];
    });
  }

  void setDes(String? t) {
    setState(() {
      des = t ?? endLocations[0];
    });
  }

  void setStartTime(String? t) {
    setState(() {
      startTime = t ?? '';
    });
  }

  void setEndTime(String? t) {
    setState(() {
      endTime = t ?? '';
    });
  }

  void setDate(String? t) {
    setState(() {
      date = t ?? '';
    });
  }

  void fetchTowns() {
    try {
      // Use dummy data instead of HTTP request
      List<Map<String, dynamic>> result = dummyData;
      setState(() {
        startLocations.clear();
        endLocations.clear();
        startLocations.add('ANY');
        endLocations.add('ANY');
        for (Map<String, dynamic> item in result) {
          String? startLocation = item['start_location'];
          String? endLocation = item['end_location'];
          if (startLocation != null && !startLocations.contains(startLocation)) {
            startLocations.add(startLocation);
          }
          if (endLocation != null && !endLocations.contains(endLocation)) {
            endLocations.add(endLocation);
          }
        }
      });
    } catch (e) {
      print('Error fetching towns: $e');
    }
  }

  void search() {
    try {
      // Use dummy data instead of HTTP request
      List<Map<String, dynamic>> result = dummyData;
      setState(() {
        data.clear();
        for (Map<String, dynamic> item in result) {
          bool matches = true;
          if (src != 'ANY' && item['start_location'] != src) {
            matches = false;
          }
          if (des != 'ANY' && item['end_location'] != des) {
            matches = false;
          }
          if (date.isNotEmpty && item['date'] != date) {
            matches = false;
          }
          if (startTime.isNotEmpty && !item['departure_time']!.startsWith(startTime)) {
            matches = false;
          }
          if (endTime.isNotEmpty && !item['arrival_time']!.startsWith(endTime)) {
            matches = false;
          }
          if (matches) {
            data.add(item);
          }
        }
      });
    } catch (e) {
      print('Error searching bus schedules: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipPath(
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: DropdownButton<String>(
                      value: src,
                      items: startLocations.map((element) {
                        return DropdownMenuItem<String>(
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
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: DropdownButton<String>(
                      value: des,
                      items: endLocations.map((element) {
                        return DropdownMenuItem<String>(
                            value: element, child: Text(element));
                      }).toList(),
                      onChanged: setDes,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: setStartTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: setEndTime,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              onChanged: setDate,
            ),
          ),
          const SizedBox(height: 10),
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