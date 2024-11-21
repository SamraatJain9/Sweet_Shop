import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Page6 extends StatelessWidget {
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
          title: Text("Choose Delivery Service"),
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Adjust padding as needed
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // Launch Uber Eats link
                    _launchURL('Link');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('clicked')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery partner 1"),
                ),
                TextButton(
                  onPressed: () {
                    // Launch Deliveroo link
                    _launchURL('Link');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('clicked')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery partner 2"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showContactUsDialog(BuildContext context) {
    // Generate random phone number and email
    String phoneNumber = '0000000000'; // Replace with actual random generator
    String emailAddress = 'abc@abc.com'; // Replace with actual random generator

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Phone: $phoneNumber'),
              SizedBox(height: 10),
              Text('Email: $emailAddress'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Instagram, Facebook, Youtube'),
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
            label: 'Google Maps: 123 Blecker Street',
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
              _launchURL('https://www.google.com/maps/search/?api=1&query=Shop+Location');
              break;
          }
        },
      ),
    );
  }
}
