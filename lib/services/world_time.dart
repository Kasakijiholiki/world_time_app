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
    // Reset state
    isLoading = true;
    error = null;
    loadingMessage = 'Connecting to WorldTime API...';

    // Add a small delay to show loading state
    await Future.delayed(Duration(milliseconds: 500));

    // Retry logic: try 3 times with exponential backoff
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        loadingMessage = 'Fetching data for $location... (Attempt ${attempt + 1}/3)';

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
        print('Error in getTime() attempt ${attempt + 1}: $e');
        
        if (attempt < 2) {
          // Wait before retry (exponential backoff: 1s, 2s)
          await Future.delayed(Duration(seconds: attempt + 1));
        } else {
          // All attempts failed, use mock data
          print('All API attempts failed, using mock data for $location');
          _setMockData();
          isLoading = false;
          loadingMessage = 'Using mock data';
          return false; // API failed but we have mock data
        }
      }
    }
    
    return false; // Should not reach here
  }

  void _setMockData() {
    // Create mock data based on current time with timezone offset
    DateTime now = DateTime.now().toUtc();
    
    // Add timezone offsets for mock data
    switch (url) {
      case 'Europe/London':
        now = now.add(Duration(hours: 0));
        break;
      case 'Europe/Berlin':
        now = now.add(Duration(hours: 1));
        break;
      case 'Africa/Cairo':
        now = now.add(Duration(hours: 2));
        break;
      case 'Africa/Nairobi':
        now = now.add(Duration(hours: 3));
        break;
      case 'America/Chicago':
        now = now.add(Duration(hours: -6));
        break;
      case 'America/New_York':
        now = now.add(Duration(hours: -5));
        break;
      case 'Asia/Seoul':
        now = now.add(Duration(hours: 9));
        break;
      case 'Asia/Jakarta':
        now = now.add(Duration(hours: 7));
        break;
      default:
        now = now.add(Duration(hours: 0));
    }

    isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
    time = DateFormat.jm().format(now);
  }
}
