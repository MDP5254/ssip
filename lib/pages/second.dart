import 'package:flutter/material.dart';
import 'package:ssip/pages/insta.dart';
import 'package:ssip/reddit pages/options.dart';
import 'package:ssip/tele pages/login.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homebg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            child: Column(children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginForm()));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15)),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RedditOptions()));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15)),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Color.fromRGBO(255, 69, 0, 1),
                  ),
                  child: const Center(
                    child: Text(
                      'Reddit',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginForm1()));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15)),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Color.fromRGBO(0, 136, 204, 1),
                  ),
                  child: const Center(
                    child: Text(
                      'Telegram',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }
}
