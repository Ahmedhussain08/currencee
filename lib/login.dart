import 'package:currencee/homeScreen.dart';
import 'package:currencee/signup.dart';
import 'package:currencee/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
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


  Future<void> login(String email, dynamic pass, ) async {
    // Set isloading to true before starting the signup operation
    setState(() {
      isloading = true;
    });

    if (email == '' || pass == '') {
      setState(() {
        isloading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

      setState(() {
        isloading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
    } on FirebaseException catch (e) {
      print('Login Error: $e');

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
            color: Theme.of(context).primaryColor,
          ),
          title: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent],
                begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                end: Alignment.centerRight, // Adjust the gradient direction as needed
              ).createShader(bounds);
            },
            child: Text(
              'Curren\$ee',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2),
            ),
          ),
          centerTitle: true,
          // actions: [
          //   Builder(
          //     builder: (BuildContext context) {
          //       User? user = FirebaseAuth.instance.currentUser;
          //       return IconButton(
          //         onPressed: () {
          //           if (user != null) {
          //             // User is logged in, you can handle any specific action here
          //           } else {
          //             // User is not logged in, navigate to login page
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => login()),
          //             );
          //           }
          //         },
          //         icon: Icon(
          //           user != null
          //               ? Icons.person_outline_sharp
          //               : Icons.person_outline_sharp,
          //           // Replace Icons.person_outline_sharp with the appropriate icon for the logged-in user if needed
          //           // You can also adjust the color, size, etc. based on your requirements
          //         ),
          //         tooltip: user != null ? user.email![0].toUpperCase() : 'Login',
          //       );
          //     },
          //   ),
          // ]
      ),

      body: Center(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.orangeAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },child: Text("Login Here",style: Theme.of(context).textTheme.titleLarge,)),
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
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.email,  color: Theme.of(context).primaryColor,),
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
                    height: 25,
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)
                        )),
                  ),
                  SizedBox(height: 25,),

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
                          login(email.text.toString(), password.text.toString());
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
                        },child: Text('Login',style: TextStyle(fontWeight: FontWeight.w800))),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          'Not have account',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextButton(
                          onPressed:
                              () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  signup(),));
                          }, // Placeholder function, replace with your login logic
                          child: Text(
                            'Sign Up',
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
                  TextButton(
                    onPressed:
                        () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => forgotpassword(),));
                    }, // Placeholder function, replace with your login logic
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
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
