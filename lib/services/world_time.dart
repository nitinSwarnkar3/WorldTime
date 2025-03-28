import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  late String location; // Location name for UI
  late String time; // Time for that location
  late String flag; // URL to an asset flag icon
  late String url; // Location URL for API endpoint
  late bool isDaytime; // True or false if daytime

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // Fetch data from API
      final response = await http.get(Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);

        // Extract time details
        String dateTimeString = data['dateTime']; // ✅ Correct field
        DateTime now = DateTime.parse(dateTimeString);

        // ✅ Determine daytime status
        isDaytime = now.hour >= 6 && now.hour < 18;

        // ✅ Format time
        time = DateFormat.jm().format(now);
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to fetch time data');
      }
    } catch (e) {
      print('Caught error: $e');
      time = 'Could not get the data';
      isDaytime = true; // Provide a default value
    }
  }
}
