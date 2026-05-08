// ignore_for_file: prefer_const_constructors, use_super_parameters, unnecessary_null_comparison
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:Everis_Fridays_Pubs/models/pubs.dart';
import 'pub_card.dart';
import 'dart:convert';
import 'affordable_pubs_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Everis Fridays Pub',
      home: EverisFridayApp(),
    ),
  );
}

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({Key? key}) : super(key: key);

  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = <Pubs>[];
  late Future<String> futurePubs;

  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Everis Fridays Pub'),
          backgroundColor: Color(0xff9aae04),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildPubs()),

            // Bottone
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AffordablePubsScreen(),
                    ),
                  );
                },
                child: Text('Show Affordable Pubs'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPubs() {
    return FutureBuilder<String>(
      future: futurePubs,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: _listPubs.length,
            itemBuilder: (context, index) {
              final pub = _listPubs[index];
              return PubCard(pub);
            },
          );
        }
      },
    );
  }

  Future<String> getPubs(_listPubs) async {
  final Response response = await get(
    Uri.parse('http://localhost:1337/api/pubs'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> pubsListRaw = jsonDecode(response.body);

     for (var i = 0; i < pubsListRaw.length; i++) {
       _listPubs.add(Pubs.fromJson(pubsListRaw[i]));
    }

    return "Success!";
  } else {
    throw Exception('Failed to load data');
  }}}