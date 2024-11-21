import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  int _currentImageIndex = 0;
  double _opacity = 1.0;
  Timer? _timer;

  final List<String> _backgroundImages = [
    'assets/K1.jpg', // First image
    'assets/K2.jpg', // Second image
    // Add more images here if you want
  ];

  @override
  void initState() {
    super.initState();
    _startImageTimer();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      setState(() {
        _opacity = 0.0; // Start fading out the current image
      });

      // Wait for the fade-out animation to complete
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          _currentImageIndex =
              (_currentImageIndex + 1) % _backgroundImages.length;
          _opacity = 1.0; // Fade in the next image
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Fast Food',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0), // Adjust height as needed
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Eat Pure, Gift Pure',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 1), // Fade duration
            child: Image.asset(
              _backgroundImages[_currentImageIndex],
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _outlinedText(
                  'Enjoy\n Fast Food and Indian Delicacies at \nJaipurs first Live Kitchen',
                  24,
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  iconSize: 30,
                  onPressed: () {
                    _launchURL('https://www.instagram.com/your_instagram_handle');
                  },
                ),
                _outlinedText(
                  'Instagram',
                  18,
                ),
              ],
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
            label: 'Google Maps: A-17A, Ganesh Nagar, Mansarovar',
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
                  "https://www.google.com/maps/place/26%C2%B850'08.0%22N+75%C2%B045'19.9%22E/@26.8354442,75.7554997,20z/data=!4m4!3m3!8m2!3d26.835552!4d75.755533?entry=ttu");
              break;
          }
        },
        selectedFontSize: 14.0, // Adjust as needed
        unselectedFontSize: 14.0, // Adjust as needed
        selectedItemColor: Colors.redAccent, // Example color
        unselectedItemColor: Colors.black, // Example color
        type: BottomNavigationBarType.fixed, // Adjust based on your design
        selectedLabelStyle:
        GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.montserrat(),
      ),
    );
  }

  Widget _outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        // Text with border
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.transparent, // Transparent text
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
        // Text without border
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
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
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _launchURL('https://www.swiggy.com/');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "Swiggy",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL('https://www.zomato.com/');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "Zomato",
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
    String phoneNumber = '0000000';
    String emailAddress = 'abc@abc.com';

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
              child: Text(
                'Close',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMenuDialog(BuildContext context) {
    List<String> vegetarianItems = [
      'Veggie Burger',
      'Vegetarian Pizza',
      'Vegetable Stir-fry',
      'Caprese Salad',
      'Falafel Wrap',
      'Grilled Veggie Panini',
      'Vegetarian Sushi Rolls',
      'Quinoa Salad',
      'Vegetarian Tacos',
      'Spinach and Cheese Quesadilla',
      'Vegetarian Spring Rolls',
      'Eggplant Parmesan',
      'Vegetarian Chili',
      'Vegetarian Lasagna',
      'Stuffed Bell Peppers'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Pure Vegetarian Menu",
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            color: Colors.redAccent,
            width: MediaQuery.of(context).size.width * 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (String item in vegetarianItems)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
