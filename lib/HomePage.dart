import 'package:ERA/HomeScreen/homescreen.dart';
import 'package:ERA/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  Future<void> checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Start(),
          ),
        );
      }
    });
  }

  Future<void> getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    this.checkAuthentification();
    this.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = Text(
      " you are Logged in as \n${user.email}",
      style: TextStyle(
        color: Colors.amber,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Merriweather',
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          child: !isloggedin
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(
                      height: 300,
                      child: Image(
                        image: AssetImage("assets/images/logopng.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Welcome To ERA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff03258C),
                                    fontFamily: 'Merriweather',
                                    fontSize: 24),
                              ),
                            ),
                            text,
                          ],
                        )),
                      ],
                    ),
                    Spacer(),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Color(0xff03258C),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
