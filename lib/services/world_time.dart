import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for UI
  String time = ''; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime = false; // true or false if daytime or not

  // Loading state properties
  bool isLoading = false;
  String loadingMessage = 'Initializing...';
  String? error;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<bool> getTime() async {
    try {
      // Reset state
      isLoading = true;
      error = null;
      loadingMessage = 'Connecting to WorldTime API...';

      // Add a small delay to show loading state
      await Future.delayed(Duration(milliseconds: 500));

      loadingMessage = 'Fetching data for $location...';

      // make the request
      Response response = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/$url'),
      ).timeout(
        Duration(seconds: 10), // 10 second timeout
        onTimeout: () {
          throw Exception(
              'Request timeout - please check your internet connection');
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load data (Status: ${response.statusCode})');
      }

      loadingMessage = 'Processing time data...';

      Map data = jsonDecode(response.body);

      // get properties from json
      String datetime = data['datetime'];
      // parse the UTC offset (format: +HH:MM or -HH:MM)
      List<String> offsetParts = data['utc_offset'].split(':');
      int hours = int.parse(offsetParts[0]);
      int minutes = int.parse(offsetParts[1]);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: hours, minutes: minutes));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);

      loadingMessage = 'Complete!';
      isLoading = false;

      return true; // Success
    } catch (e) {
      print('Error in getTime(): $e');
      error = e.toString();
      time = 'Error loading time';
      isDaytime = true; // default to daytime on error
      isLoading = false;
      loadingMessage = 'Failed to load data';

      return false; // Failure
    }
  }
}
