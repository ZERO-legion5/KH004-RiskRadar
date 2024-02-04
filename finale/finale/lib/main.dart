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
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String apiUrl = "YOUR_API_ENDPOINT"; // Replace with your API endpoint

    try {
      final http.Response response = await http.post(
        apiUrl as Uri,
        body: jsonEncode({"username": username, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Successful login, extract and use data from the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Process your data here

        // Navigate to the next screen or perform other actions
      } else {
        // Handle login failure
        print("Login failed. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle network errors
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}