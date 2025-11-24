import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String loadingText = 'Loading...';
  int retryCount = 0;
  static const int maxRetries = 3;

  void setupMockData() {
    // Mock JSON response as if it came from WorldTime API
    String mockResponse =
        '{"utc_offset":"+01:00","timezone":"Europe/Berlin","day_of_week":1,"day_of_year":328,"datetime":"2025-11-24T15:18:22.915102+01:00","utc_datetime":"2025-11-24T14:18:22.915102+00:00","unixtime":1763993902,"raw_offset":3600,"week_number":48,"dst":false,"abbreviation":"CET","dst_offset":0,"dst_from":null,"dst_until":null,"client_ip":"154.222.4.158"}';

    try {
      setState(() {
        loadingText = 'Processing mock data...';
      });

      Map data = jsonDecode(mockResponse);

      // get properties from json (same as real API)
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      // set the time property with formatted time
      String time = DateFormat.jm().format(now);
      bool isDaytime = now.hour > 6 && now.hour < 20;

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'location': 'Berlin (Mock)',
          'flag': 'germany.png',
          'time': time,
          'isDaytime': isDaytime
        });
      }
    } catch (e) {
      setState(() {
        loadingText = 'Failed to process mock data';
      });
    }
  }

  void setupWorldTime() async {
    try {
      WorldTime instance = WorldTime(
          location: 'Berlin', flag: 'germany.png', url: 'Europe/Berlin');

      // Update loading text from service messages
      instance.loadingMessage = 'Initializing WorldTime service...';
      setState(() => loadingText = instance.loadingMessage);

      await Future.delayed(Duration(milliseconds: 300));

      // Get time data - this will update instance.loadingMessage
      bool success = await instance.getTime();

      if (success && mounted) {
        // Success - reset counter and navigate to home
        retryCount = 0;
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'location': instance.location,
          'flag': instance.flag,
          'time': instance.time,
          'isDaytime': instance.isDaytime
        });
      } else {
        // Increment retry count
        retryCount++;

        if (retryCount < maxRetries) {
          // Handle errors - retry
          setState(() {
            loadingText =
                'Failed to load time data (Attempt ${retryCount}/${maxRetries})';
          });

          // Show error for 2 seconds, then retry
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              setState(() => loadingText =
                  'Retrying... (${retryCount + 1}/${maxRetries})');
              setupWorldTime(); // Retry
            }
          });
        } else {
          // Max retries reached - show final failure
          setState(() {
            loadingText =
                'Failed to load time data after ${maxRetries} attempts. Please check your connection.';
          });

          // Optional: Show error for a longer time, then maybe show a retry button
          Future.delayed(Duration(seconds: 5), () {
            if (mounted) {
              // Could add a retry button here or navigate to an error screen
              setState(() => loadingText = 'Tap to retry');
              // For now, just keep the failed message
            }
          });
        }
      }
    } catch (e) {
      // Increment retry count for exceptions too
      retryCount++;

      if (retryCount < maxRetries) {
        setState(() => loadingText =
            'Network error (Attempt ${retryCount}/${maxRetries}). Retrying...');

        // Retry after delay
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              loadingText = 'Retrying... (${retryCount + 1}/${maxRetries})';
            });
            setupWorldTime();
          }
        });
      } else {
        // Max retries reached - final failure
        setState(() {
          loadingText =
              'Failed to load time data after ${maxRetries} attempts. Please check your internet connection.';
        });

        // Optional: Show error for a longer time
        Future.delayed(Duration(seconds: 5), () {
          if (mounted) {
            setState(() => loadingText = 'Failed - Please restart the app');
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              ),
              SizedBox(height: 20.0),
              Text(
                loadingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.0),
              retryCount < maxRetries
                  ? Text(
                      'Getting time for Berlin',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                retryCount = 0;
                                loadingText = 'Retrying...';
                              });
                              setupWorldTime();
                            }
                          },
                          child: Text(
                            'Tap to retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            setupMockData();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              'Use Mock Data',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ));
  }
}
