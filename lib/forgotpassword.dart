import 'package:currencee/homeScreen.dart';
import 'package:currencee/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
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

  Future<void> sendpass(String email) async {
    setState(() {
      isloading = true;
    });

    if (email == '') {
      setState(() {
        isloading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
              backgroundColor: Theme.of(context).primaryColor,
              content: Text('Plz Check your Inbox to reset password')
          )
      );

    } on FirebaseException catch (e) {
      print('Send Password Reset Email Error: $e');

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
                colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent], // Change colors as needed
                begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                end: Alignment.centerRight, // Adjust the gradient direction as needed
              ).createShader(bounds);
            },
            child: Text(
              'Curren\$ee',
              style: TextStyle(fontWeight: FontWeight.w800,),
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Theme.of(context).primaryColor,Colors.orange, Colors.deepOrangeAccent], // Change colors as needed
                    begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                    end: Alignment.centerRight, // Adjust the gradient direction as needed
                  ).createShader(bounds);
                },child: Text("Enter  Email to get link",style: Theme.of(context).textTheme.titleLarge,)),
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
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.email,  color: Theme.of(context).primaryColor,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),

                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          enabledBorder: OutlineInputBorder())),
                  SizedBox(
                    height: 25,
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
                          sendpass(email.text.toString(), );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.black,
                        foregroundColor: Colors.white,
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
                        },child: Text('Send Link')),
                    )
                        : Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60,
                        width: 60,
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


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
