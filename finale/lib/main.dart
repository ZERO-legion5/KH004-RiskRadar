import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchData(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
    return jsonData;
  } else {
    throw Exception('Failed to load data');
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String enteredUsername = usernameController.text;
              String enteredPassword = passwordController.text;

              if (enteredUsername == 'a' && enteredPassword == 'a') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Authentication Failed'),
                    content: Text('Invalid username or password.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Page'),
      ),
      body: Center(
        child: Text('This is the Feed page.'),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _selectedIndex = 0;
  List<dynamic>? names;

  List<String> jsonUrls = [
    'https://awaited-troll-privately.ngrok-free.app/requestall/',
    'https://awaited-troll-privately.ngrok-free.app/requestall/',
  ];

  Future<List<dynamic>> fetchDataFromUrl(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> refreshData() async {
    try {
      List<dynamic>? newData = await fetchDataFromUrl(jsonUrls[0]);
      setState(() {
        names = newData;
      });
    } catch (error) {
      print('Error refreshing data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraud Detection'),
        actions: [
          IconButton(
            onPressed: refreshData,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            if (names != null)
              Expanded(
                child: ListView.builder(
                  itemCount: names!.length,
                  itemBuilder: (context, index) {
                    var trans_num = names?[index]['trans_num'];
                    var class_ = names?[index]['class'];
                    var datetime = names?[index]['datetime'];
                    var prediction = names?[index]['prediction'];
                    var textColor = class_ == 0 ? Colors.green : Colors.red;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Trx No : $trans_num\nTime : $datetime',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Prediction : $prediction',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            if (names == null) Text('No data available'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: 'Validation',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              if (_selectedIndex == index) {
                return;
              }
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FeedPage()),
                );
              } else if (_selectedIndex == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ValidationPage()),
                );
              }
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 251, 237, 237),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('This is the Home page.'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text('This is the Settings page.'),
      ),
    );
  }
}

class ValidationPage extends StatefulWidget {
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  TextEditingController inputController = TextEditingController();
  String output = '';
  late Timer _timer; // Timer for auto-refresh

  Future<void> sendInputToApi(String input) async {
    String apiUrl = 'https://awaited-troll-privately.ngrok-free.app/request/?trans_num=' + input;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"accept":"application/json"},
        body: {},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          output = responseData['prediction'];
        });
      } else {
        throw Exception('Failed to communicate with the API');
      }
    } catch (error) {
      print('Error sending input to API: $error');
      // Handle the error accordingly
    }
  }

  // Function to refresh data
  Future<void> refreshData() async {
    try {
      String input = inputController.text;
      await sendInputToApi(input);
    } catch (error) {
      print('Error refreshing data: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize timer to auto-refresh every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      refreshData();
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the page is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: inputController,
            decoration: InputDecoration(labelText: 'Enter Input'),
          ),
          ElevatedButton(
            onPressed: () {
              String input = inputController.text;
              sendInputToApi(input);
            },
            child: Text('Send Input to API'),
          ),
          SizedBox(height: 20),
          Text('Output from API: $output'),
          Expanded(child: Container()), // Expanded to take remaining space
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            child: Text('Return to Feed Page'),
          ),
        ],
      ),
    );
  }
}
