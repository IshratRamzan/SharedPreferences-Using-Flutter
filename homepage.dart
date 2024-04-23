import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Home Page'))),
      body: FutureBuilder<String>(
        future: getEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final email = snapshot.data ?? '';
            return Container(
              color: Colors.blue.shade100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back, $email',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate back to the login page and clear shared preferences
                        final sharedPref = await SharedPreferences.getInstance();
                        sharedPref.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> getEmail() async {
    var sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('email') ??'';
  }
}
