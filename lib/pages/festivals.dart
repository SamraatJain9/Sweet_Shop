import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(Page3App());

class Page3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page3(),
    );
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, dynamic>> _pastFestivals = [];
  List<Map<String, dynamic>> _upcomingFestivals = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadFestivalData();
    _startAutoUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showOrderMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Delivery Service",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Adjust padding as needed
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery Partner 1",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery Partner 2",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showContactUsDialog(BuildContext context) {
    String phoneNumber = '0000000000'; // Replace with actual random generator
    String emailAddress = 'abc@abc.com'; // Replace with actual random generator

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Us", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Phone: $phoneNumber', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              Text('Email: $emailAddress', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _startAutoUpdate() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _loadFestivalData();
    });
  }

  Future<void> _loadFestivalData() async {
    try {
      final String response =
      await rootBundle.loadString('assets/festivals.json');
      final List<dynamic> data = json.decode(response);

      DateTime now = DateTime.now();
      List<Map<String, dynamic>> pastFestivals = [];
      List<Map<String, dynamic>> upcomingFestivals = [];

      for (var item in data) {
        DateTime festivalDate = _parseDate(item['date']);
        if (festivalDate.isBefore(now)) {
          pastFestivals.add(item);
        } else {
          upcomingFestivals.add(item);
        }
      }

      setState(() {
        _pastFestivals = pastFestivals;
        _upcomingFestivals = upcomingFestivals;
      });
    } catch (e) {
      print('Error loading festival data: $e');
    }
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  List<Map<String, dynamic>> _getTodayFestivals() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<Map<String, dynamic>> todayFestivals = _upcomingFestivals
        .where((festival) {
      DateTime festivalDate = _parseDate(festival['date']);
      DateTime festivalDay = DateTime(festivalDate.year, festivalDate.month, festivalDate.day);
      return festivalDay.isAtSameMomentAs(today);
    }).toList();

    todayFestivals.addAll(_pastFestivals
        .where((festival) {
      DateTime festivalDate = _parseDate(festival['date']);
      DateTime festivalDay = DateTime(festivalDate.year, festivalDate.month, festivalDate.day);
      return festivalDay.isAtSameMomentAs(today);
    }));

    return todayFestivals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Festival Timeline', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Slogan',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
              ),
              const SizedBox(height: 16),
              // Today's Festivals
              Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Today\'s Festivals',
                        style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ),
                    if (_getTodayFestivals().isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No festivals today', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _getTodayFestivals().length,
                        itemBuilder: (context, index) {
                          var festival = _getTodayFestivals()[index];
                          return ListTile(
                            title: Text(festival['name'], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                            subtitle: Text(festival['date'], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Upcoming Festivals
              Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Upcoming Festivals',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ),
                    if (_upcomingFestivals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No upcoming festivals', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _upcomingFestivals.length,
                        itemBuilder: (context, index) {
                          var festival = _upcomingFestivals[index];
                          return ListTile(
                            title: Text(festival['name'], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                            subtitle: Text(festival['date'], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Order Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Address',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              _showContactUsDialog(context);
              break;
            case 1:
              _showOrderMethodDialog(context);
              break;
            case 2:
              _launchURL("Google_map_link");
              break;
          }
        },
        selectedFontSize: 14.0, // Adjust as needed
        unselectedFontSize: 14.0, // Adjust as needed
        selectedItemColor: Colors.redAccent, // Example color
        unselectedItemColor: Colors.black, // Example color
        type: BottomNavigationBarType.fixed, // Adjust based on your design
        selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.montserrat(),
      ),
    );
  }
}
