import 'dart:convert';

import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/User/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class registrationScreen extends StatefulWidget {
  const registrationScreen({Key? key}) : super(key: key);

  @override
  State<registrationScreen> createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  String eula = '';
  final formKey = GlobalKey<FormState>();
  bool _isCheck = false;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController pass2EditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.blue,
              child: Image.asset(
                'assets/images/barter4.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameEditingController,
                            validator: (val) => val!.isEmpty || val.length < 5
                                ? "Name must be longer than 5 characters"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailEditingController,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Enter a valid email"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: phoneEditingController,
                            // validator: (val) => val!.isEmpty ||
                            //         !val.contains("@") ||
                            //         !val.contains(".")
                            //     ? "Enter a valid email"
                            //     : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.phone),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordEditingController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.password),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: pass2EditingController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Re-enter Password",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _isCheck,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCheck = value!;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: _showEULA,
                                child: const Text(
                                  'Agree with terms',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: onRegisterDialog,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                            ),
                            child: const Text("Register"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Already Registered?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const loginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Click Here Back to Login Page",
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
      ),
    );
  }

  void onRegisterDialog() {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check your input")),
      );
      return;
    }
    if (!_isCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree with terms and conditions"),
        ),
      );
      return;
    }
    String pass = passwordEditingController.text;
    String pass2 = pass2EditingController.text;
    if (pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please check your password")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String phone = phoneEditingController.text;
    String passa = passwordEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": passa,
        }).then((response) {
      //  print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _goLogin() {}

  void loadEula() async {
    eula = await rootBundle.loadString('assets/eula/eula.txt');
  }

  void _showEULA() async {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue, // Specify the desired color
                        ),
                        text: eula,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
