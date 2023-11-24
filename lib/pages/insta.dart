import 'package:flutter/material.dart';
import 'package:ssip/pages/data.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Track your Instagram in seconds!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => LoginPopUp(),
                  );
                },
                child: const Text('Login with Instagram'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPopUp extends StatefulWidget {
  @override
  _LoginPopUpState createState() => _LoginPopUpState();
}

class _LoginPopUpState extends State<LoginPopUp> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('⚠️Warning⚠️'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '''
Using this app may involve certain risks and can lead to actions taken by Instagram, including the suspension or banning of your account. Please proceed with caution and ensure that you comply with Instagram's terms of service and community guidelines.

Remember to use this app responsibly and respect the privacy and terms of use of other users on Instagram. Your digital safety and online reputation are important. 
''',
            style: TextStyle(fontSize: 15.0),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Checkbox(
                value: _accepted,
                onChanged: (value) {
                  setState(() {
                    _accepted = value!;
                  });
                },
              ),
              const Text(
                  'By continuing, you accept\n the risks and agree to\n responsible usage.'),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _accepted
              ? () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UsernamePassword(),
                  ));
                }
              : null,
          child: Text('Continue'),
        ),
      ],
    );
  }
}

class UsernamePassword extends StatefulWidget {
  @override
  _UsernamePasswordState createState() => _UsernamePasswordState();
}

class _UsernamePasswordState extends State<UsernamePassword> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool _isLoading = false;
  var _loginStatus = '';

  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String usernameval = _controller1.text;
    final String passwordval = _controller2.text;

    final response = await http.post(
      Uri.parse('http://192.168.0.109:5200/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'username': usernameval, 'password': passwordval},
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _loginStatus = 'Login successful';
      });
      // Handle navigation or other actions here
      // print('Login successful');

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataScreen()),
      );
    } else {
      setState(() {
        _loginStatus = 'Login failed';
        throw Exception('Failed to load data');
      });
      // Show an error message or navigate back
      Navigator.pop(context);
      // print('Login failed');
      AlertDialog(
        title: const Text('Login failed'),
        content: const Text('Please try again'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller2,
                  obscureText: true,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => login(context),
                  child: const Text('Login'),
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Text(_loginStatus, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
