import 'package:flutter/material.dart';
import 'package:sweets/pages/bakery.dart';
import 'package:sweets/pages/saltines.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../main.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
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
                  child: Text("Delivery Partner1",
                    style: GoogleFonts.montserrat(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL('Link');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Delivery Partner2",
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0), bottom: Radius.circular(15.0)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.scaleDown,
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
                  child: const Text('Ghee Sweets'),
                ),
              ),
              Tab(
                child: DefaultTextStyle(
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Dry Fruit & Mawa'),
                ),
              ),
              Tab(
                child: DefaultTextStyle(
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Bengali Sweets'),
                ),
              ),
            ],
          ),

        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Row(
              children: [
                Container(
                  width: 160,
                  color: Colors.redAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MySaltyPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {
                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Namkeen",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBakeryPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {

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
                Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          buildCard('https://images.slurrp.com/prod/recipe_images/transcribe/sweet/Moong-Dalki-Barfi.webp', 'Moong Barfi\nShelf Life: '),
                          buildCard('https://www.shutterstock.com/image-photo/moti-pak-mithai-called-boondi-600nw-2142444889.jpg', 'Moti Pak\nShelf Life:'),
                          buildCard('https://www.shutterstock.com/image-photo/indian-sweet-besan-laddu-full-600nw-1736964029.jpg', 'Besan Ladoo\nShelf Life:'),
                          buildCard('https://img1.exportersindia.com/product_images/bc-full/dir_192/5731992/kanpuri-laddu-sweet-1529645748-4004998.jpeg', 'Kanpuri Ladoo\nShelf Life:'),
                          buildCard('https://thumbs.dreamstime.com/b/indian-sweet-kale-boondi-ke-laddoo-made-besan-gram-flour-clarified-butter-sugar-jodhpur-rajasthan-truffles-80097328.jpg', 'Dudh ladoo\nShelf Life:'),
                          buildCard('https://t3.ftcdn.net/jpg/04/60/79/30/360_F_460793066_kFmSdrFRNraNsLeARfcxuEjiuO3GLo22.jpg', 'Ghewar\nShelf Life:'),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 160,
                  color: Colors.redAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MySaltyPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {

                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Namkeen",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBakeryPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {

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
                Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          buildCard('https://t4.ftcdn.net/jpg/01/70/39/05/360_F_170390588_KAmillOqlXoct5CsmZBHQM1kFVWEX0Qi.jpg', 'Kaju Katli\nShelf Life:'),
                          buildCard('https://www.shutterstock.com/image-photo/kaju-pista-roll-cashew-pistachio-600nw-2188790837.jpg', 'Kaju Roll\nShelf Life:'),
                          buildCard('https://media.istockphoto.com/id/1371885630/photo/milkcake-kalakand-burfi-or-alwar-ka-mawa-barfi-mithai-is-made-of-khoya-mawa-malai-badam-khoa.jpg?s=612x612&w=0&k=20&c=OgDIMtGcvi5CYGQ-3OV0WN9MSpv1cUcQK7R8mRsuDZo=', 'Milk Cake\nShelf Life:'),
                          buildCard('https://t4.ftcdn.net/jpg/01/67/29/09/360_F_167290919_aIAxnOxrbtcwDkcL1E22itq5SFRA2ZsT.jpg', 'Kalakand\nShelf Life:'),
                          buildCard('https://media.istockphoto.com/id/521803129/photo/gulab-jamun-11.webp?b=1&s=170667a&w=0&k=20&c=Ir8N51FhWmAN_bQNKiscp0wvPgju9yaqN3Lj9-13NSQ=', 'Gulab Jamun\nShelf Life:'),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 160,
                  color: Colors.redAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MySaltyPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {

                              _scrollController.animateTo(
                                0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Text(
                            "Namkeen",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBakeryPage(title: 'Eat Pure, Gift Pure')),
                            );
                            setState(() {

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
                Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          buildCard('https://t4.ftcdn.net/jpg/03/64/73/37/360_F_364733792_kGTfRUnoPLIX0PPgO0zFmV2Ao2exg8bH.jpg', 'Rasgulla\nShelf Life:'),
                          buildCard('https://st3.depositphotos.com/5653638/15692/i/450/depositphotos_156928342-stock-photo-angoori-rasmalai-or-anguri-ras.jpg', 'Rasmalai\nShelf Life:'),
                          buildCard('https://t3.ftcdn.net/jpg/05/19/11/60/360_F_519116067_n4PKLBrdeC49osFl0ZVul7x5l5DQvAex.jpg', 'Sondesh\nShelf Life:'),
                          buildCard('https://www.shutterstock.com/image-photo/indian-sweet-food-chena-toast-600nw-2433576209.jpg', 'Chena Toast\nShelf Life:'),
                          buildCard('https://www.shutterstock.com/image-photo/indian-traditional-sweet-food-long-600nw-1299068719.jpg', 'Cham-Cham\nShelf Life:'),
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
    home: MyHomePage(title: 'Shop Offers'),
  ));
}
