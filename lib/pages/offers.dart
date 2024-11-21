import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final ScrollController _scrollController = ScrollController();
  final List<String> offers = [
    'Coming Soon...',
    'Coming Soon...',
    'Coming Soon...',
    'Coming Soon...',
    'Coming Soon...',
  ];

  @override
  void initState() {
    super.initState();
    _autoScroll();
  }

  void _autoScroll() {
    Timer.periodic(Duration(seconds: 8), (timer) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentScrollPosition = _scrollController.position.pixels;
        final screenHeight = MediaQuery.of(context).size.height;

        if (currentScrollPosition < maxScrollExtent) {
          _scrollController.animateTo(
            currentScrollPosition + screenHeight,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            0.0,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          title: Text(
            "Choose Delivery Service",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          contentPadding:
          EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Adjust padding as needed
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "Delivery Partner 1",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "Delivery partner 2",
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
          title: Text(
            "Contact Us",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Phone: $phoneNumber',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $emailAddress',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = 450.0; // Fixed width for the cards

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Offers',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Center the appbar title
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // Add some space between the app bar and the text
          Text(
            'Slogan',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return Container(
                  height: screenHeight,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Container(
                          width: cardWidth,
                          child: ListTile(
                            title: Center(
                              child: Text(
                                offers[index],
                                style: GoogleFonts.montserrat(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
              _launchURL(
          "Google_Map_Link");
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

void main() {
  runApp(MaterialApp(
    home: Page2(),
  ));
}
