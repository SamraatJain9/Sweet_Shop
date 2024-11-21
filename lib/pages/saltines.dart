import 'package:flutter/material.dart';
import 'package:sweets/pages/bakery.dart';
import 'package:sweets/pages/sweets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../main.dart';
import 'package:google_fonts/google_fonts.dart';

class MySaltyPage extends StatefulWidget {
  const MySaltyPage({super.key, required this.title});

  final String title;

  @override
  State<MySaltyPage> createState() => _MySaltyPageState();
}

class _MySaltyPageState extends State<MySaltyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _autoScroll();
  }

  void _autoScroll() {
    Timer.periodic(Duration(seconds: 3), (timer) {
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
    _tabController.dispose();
    super.dispose();
  }

  void _onMenuSelected(String choice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $choice')),
    );
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
                  child: Text("Delivery partner 1",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery partner 2",
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
    String phoneNumber = '000000000'; // Replace with actual random generator
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
              child: Text('Close', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }


  Widget buildCard(String imageUrl, String title) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.7; // Adjust the ratio as needed

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: cardHeight,
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: cardHeight - 60, // Adjust the height of the image
                    width: double.infinity,
                  ),
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],

          bottom: TabBar(
            controller: _tabController,
              tabs: [
                Tab(
                  child: DefaultTextStyle(
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Salty'),
                  ),
                ),
                Tab(
                  child: DefaultTextStyle(
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Salty'),
                  ),
                ),
              ]
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Row(
              children: [
                // Side panel
                Container(
                  width: 160, // Adjust the width as needed
                  color: Colors.redAccent, // Example background color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the buttons vertically
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Slogan')),
                            );
                            setState(() {
                               // Set to 1 for Type1
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Sweets",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBakeryPage(title: 'Slogan')),
                            );
                            setState(() {
                               // Set to 3 for Type3
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Bakery",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // List of sweets cards
                Expanded(
                    child: Scrollbar(
                      thumbVisibility: true, // Ensure the scrollbar is always visible
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          buildCard('https://media.istockphoto.com/id/609815010/photo/healthy-homemade-plantain-chips.jpg?s=2048x2048&w=is&k=20&c=N3-E7uvZZ99yPSLFk4zG__KKUf89EaK5SpP_FV1TzyI=', 'Coming Soon...'),
                          buildCard('https://media.istockphoto.com/id/609815010/photo/healthy-homemade-plantain-chips.jpg?s=2048x2048&w=is&k=20&c=N3-E7uvZZ99yPSLFk4zG__KKUf89EaK5SpP_FV1TzyI=', 'Coming Soon...'),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                // Side panel
                Container(
                  width: 160, // Adjust the width as needed
                  color: Colors.redAccent, // Example background color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the buttons vertically
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Slogan')),
                            );
                            setState(() {
                               // Set to 1 for Type1
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Sweets",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust horizontal padding as needed
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBakeryPage(title: 'Slogan')),
                            );
                            setState(() {
                              // Set to 3 for Type3
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Bakery",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // List of sweets cards
                Expanded(
                    child: Scrollbar(
                      thumbVisibility: true, // Ensure the scrollbar is always visible
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          buildCard('https://media.istockphoto.com/id/609815010/photo/healthy-homemade-plantain-chips.jpg?s=2048x2048&w=is&k=20&c=N3-E7uvZZ99yPSLFk4zG__KKUf89EaK5SpP_FV1TzyI=', 'Coming Soon...'),
                          buildCard('https://media.istockphoto.com/id/609815010/photo/healthy-homemade-plantain-chips.jpg?s=2048x2048&w=is&k=20&c=N3-E7uvZZ99yPSLFk4zG__KKUf89EaK5SpP_FV1TzyI=', 'Coming Soon...'),
                        ],
                      ),
                    )
                ),
              ],
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
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: MySaltyPage(title: 'Shop Offers'),
  ));
}