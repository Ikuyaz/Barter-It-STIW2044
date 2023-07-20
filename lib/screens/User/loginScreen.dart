import 'dart:async';
import 'dart:convert';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/main/mainScreen.dart';
import 'package:barterit/screens/User/registrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.deepPurpleAccent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                color: Colors.teal,
                child: Image.asset(
                  'assets/images/barter5.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameEditingController,
                          validator: (val) => val!.isEmpty
                              ? "Username must not be empty"
                              : null,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passEditingController,
                          validator: (val) => val!.isEmpty
                              ? "Password must not be empty"
                              : null,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            icon: Icon(Icons.password),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: onLogin,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            onPrimary: Colors.white,
                            minimumSize: Size(screenWidth / 3, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: onGuest,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                minimumSize: Size(screenWidth / 3, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text('Login As Guest'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          saveremovepref(value!);
                          setState(() {
                            _isChecked = value;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: null,
                        child: const Text(
                          'Remember Me',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "First Time User? ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Add a vertical gap of 10 pixels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const registrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register Here",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLogin() {
    if (!_formkey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String name = _nameEditingController.text;
    String pass = _passEditingController.text;
    try {
      http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
          body: {
            "name": name,
            "password": pass,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: user,
                        )));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {});
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const registrationScreen()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = _nameEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formkey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('name', name);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      await prefs.setString('name', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _nameEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = (prefs.getString('name')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _nameEditingController.text = name;
        _passEditingController.text = password;
      });
    }
  }

  void onGuest() {
    User guestuser = User(
      id: "0",
      name: "Guest",
      email: "",
      phone: "",
      datereg: "",
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(
                  user: guestuser,
                )));
  }
}
