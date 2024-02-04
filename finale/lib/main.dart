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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: refreshData,
              child: Text('Refresh'),
            ),
            SizedBox(height: 10),
            if (names != null)
              Expanded(
                child: ListView.builder(
                  itemCount: names!.length,
                  itemBuilder: (context, index) {
                    var trans_num = names?[index]['trans_num'];
                    var class_ = names?[index]['class'];
                    var prediction = names?[index]['prediction'];
                    var textColor = class_ == 0 ? Colors.green : Colors.red;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Trx No : $trans_num',
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
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else if (_selectedIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
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
