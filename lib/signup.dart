import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  bool isloading = false;

  void showErrorDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error!',
            style: TextStyle(color: Colors.red.shade900),
          ),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signup(String email, dynamic pass) async {
    if (email == '' || password == '') {
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
      } on FirebaseAuthException catch (e) {
        return showErrorDialog(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: Text('Enter Email'),
                            hintText: 'Enetr Email',
                            prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            enabledBorder: OutlineInputBorder())),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 8) {
                          return 'Please enter atleast 8 character';
                        }
                        return null;
                      },
                      controller: password,
                      decoration: InputDecoration(
                          label: Text('Enter Password'),
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.password,color: Theme.of(context).primaryColor,),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          enabledBorder: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if ( value!= password.text ) {
                          return 'Password Did not match';
                        }
                        return null;
                      },
                      controller: confirmpassword,
                      decoration: InputDecoration(
                          label: Text('Enter Password'),
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.password,color: Theme.of(context).primaryColor,),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          enabledBorder: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                        child: isloading == false
                          ? ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signup(email.text.toString(),
                                      password.text.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(fontSize: 20),
                                  padding: EdgeInsets.all(17),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Text('Signup'))
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 60, // Adjust the height as needed
                                width: 60, // Adjust the width as needed
                                // child: LoadingIndicator(
                                //   indicatorType: Indicator.ballBeat,
                                //   colors: [Colors.blue],
                                // ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            'Already have account',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextButton(
                            onPressed:
                                () {}, // Placeholder function, replace with your login logic
                            child: Text(
                              'Login Here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
