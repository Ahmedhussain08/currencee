import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool isChecked = false;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, // Change the color of the drawer icon here
          ),
          title: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: Text(
              'Curren\$ee',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2),
            ),
          ),
          centerTitle: true,
          actions: [
            Builder(
              builder: (BuildContext context) {
                User? user = FirebaseAuth.instance.currentUser;
                return IconButton(
                  onPressed: () {
                    if (user != null) {
                      // User is logged in, you can handle any specific action here
                    } else {
                      // User is not logged in, navigate to login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    }
                  },
                  icon: Icon(
                    user != null
                        ? Icons.person_outline_sharp
                        : Icons.person_outline_sharp,
                    // Replace Icons.person_outline_sharp with the appropriate icon for the logged-in user if needed
                    // You can also adjust the color, size, etc. based on your requirements
                  ),
                  tooltip: user != null ? user.email![0].toUpperCase() : 'Login',
                );
              },
            ),
          ]
      ),

      body: Center(
        child: Card(

          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // SizedBox(
                  //   height: 5,
                  // ),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Theme.of(context).primaryColor, Colors.orangeAccent], // Change colors as needed
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight, // Adjust the gradient direction as needed
                      ).createShader(bounds);
                    },
                    child: Center(
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23, // Adjust font size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ensure text color contrasts with gradient colors
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
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
                                  color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)
                          ))),
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
                                color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)
                        )),
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
                        label: Text('Confirm Password'),
                        hintText: 'Confirm Password',
                        prefixIcon: Icon(Icons.password,color: Theme.of(context).primaryColor,),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor, // Set the color here

                      ),
                      Text('I agree to the terms ',style: TextStyle(color: Theme.of(context).primaryColor),),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: isloading == false
                        ? ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && isChecked) {
                          setState(() {
                            isloading = true;
                          });
                          signup(email.text.toString(), password.text.toString());
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                 backgroundColor: Theme.of(context).primaryColor,
                                  content: Text('Plz check terms and conditions')
                              )
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent], // Change colors as needed
                              begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                              end: Alignment.centerRight, // Adjust the gradient direction as needed
                            ).createShader(bounds);
                          },child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.w800),)),

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
                          'Have an account?',
                          style: TextStyle(fontSize: 15),
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
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
