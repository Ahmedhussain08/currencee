import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'login.dart';

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
    // Set isloading to true before starting the signup operation
    setState(() {
      isloading = true;
    });

    if (email == '' || password == '') {
      // If email or password is empty, return early without performing signup
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);

      setState(() {
        isloading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    } on FirebaseException catch (e) {
      print('Signup Error: $e');

      setState(() {
        isloading = false;
      });

      // Show error dialog
      showErrorDialog(context, e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  Text("Sign Up",style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 30,),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),

                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          enabledBorder: OutlineInputBorder())),
                  SizedBox(
                    height: 30,
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
                  SizedBox(height: 30,),
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
                          setState(() {
                            isloading = true; // Set isloading to true before signup
                          });
                          // Call signup function
                          signup(email.text.toString(), password.text.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Signup'),
                    )
                        : Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60, // Adjust the height as needed
                        width: 60, // Adjust the width as needed
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballBeat,
                          colors: [Theme.of(context).primaryColor],
                        ),
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
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextButton(
                          onPressed:
                              () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => login(),));
                              }, // Placeholder function, replace with your login logic
                          child: Text(
                            'Login Here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
    );
  }
}
