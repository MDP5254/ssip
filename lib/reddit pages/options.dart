import 'package:flutter/material.dart';
import 'package:ssip/reddit pages/dataredi.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class RedditOptions extends StatelessWidget {
  const RedditOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/redditbg.png'),
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
                'Track your Reddit in seconds!',
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
                    builder: (context) => RedditLoginPopUp1(),
                  );
                },
                child: const Text('Track SubReddit'),
              ),
              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}

class RedditLoginPopUp extends StatefulWidget {
  @override
  _RedditLoginPopUpState createState() => _RedditLoginPopUpState();
}

class _RedditLoginPopUpState extends State<RedditLoginPopUp> {
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
Using this app may involve certain risks and can lead to actions taken by Reddit, including the suspension or banning of your account. Please proceed with caution and ensure that you comply with Reddit's terms of service and community guidelines.

Remember to use this app responsibly and respect the privacy and terms of use of other users on Reddit. Your digital safety and online reputation are important. 
''',
            style: TextStyle(fontSize: 16.0),
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
                    builder: (context) =>RedditSubReddit(),
                  ));
                }
              : null,
          child: Text('Continue'),
        ),
      ],
    );
  }
}

class RedditLoginPopUp1 extends StatefulWidget {
  @override
  _RedditLoginPopUp1State createState() => _RedditLoginPopUp1State();
}

class _RedditLoginPopUp1State extends State<RedditLoginPopUp1> {
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
Using this app may involve certain risks and can lead to actions taken by Reddit, including the suspension or banning of your account. Please proceed with caution and ensure that you comply with Reddit's terms of service and community guidelines.

Remember to use this app responsibly and respect the privacy and terms of use of other users on Reddit. Your digital safety and online reputation are important. 
''',
            style: TextStyle(fontSize: 16.0),
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
                    builder: (context) => RedditSubReddit(),
                  ));
                }
              : null,
          child: Text('Continue'),
        ),
      ],
    );
  }
}


class RedditSubReddit extends StatefulWidget {
  @override
  _RedditSubRedditState createState() => _RedditSubRedditState();
}

class _RedditSubRedditState extends State<RedditSubReddit> {
  final TextEditingController _controller1 = TextEditingController();
  bool _isLoading = false;
  var _loginStatus = '';

  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String SubRedditval = _controller1.text;

    final response = await http.post(
      Uri.parse('http://192.168.0.109:5000/reddit-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'subreddit_name': SubRedditval},
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
        MaterialPageRoute(builder: (context) => ApiImageList()),);
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
          image: AssetImage('assets/images/redditbg.png'),
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
                    labelText: 'SubReddit',
                    hintText: 'Enter SubReddit Name',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => login(context),
                  child: const Text('Submit'),
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
