
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:currencee/login.dart';
import 'package:currencee/currencyapi.dart';
import 'package:currencee/HistoryPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  String baseCurrency='PKR';
  List<String> baseDropdownItems = ["PKR", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"];
  String otherCurrency = 'USD';
  List<String> otherDropdownItems = ["PKR", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"];
  final amountController=TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey for the Form
  double d1=0;
  double totalValue=0;
  bool showTotalValue = false ;
  String selectedChoice = "";

  void parseTextToDouble() {
    String inputValue = amountController.text.trim();
    try {
      d1 = double.parse(inputValue);
      print('Parsed double value: $d1');
    } catch (e) {
      print('Error parsing double: $e');
      print('Invalid input value: $inputValue');
    }

  }
  void sendFeedbackToFirestore( String feedback) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userEmail = user != null ? user.email ?? 'Anonymous' : 'Anonymous';

      // Add the feedback to Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'feedback': feedback,
        'user_email': userEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text('Thank you for your feedback: $feedback'),
          duration: Duration(seconds: 2), // Adjust as needed
        ),
      );

      Navigator.pop(context); // Close the feedback form dialog
    } catch (e) {
      print('Error sending feedback: $e');
      // Handle error here if needed
    }
  }
  void showFeedbackForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent], // Change colors as needed
                  begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                  end: Alignment.centerRight, // Adjust the gradient direction as needed
                ).createShader(bounds);
              },child: const Text('Give Feedback', style: TextStyle(fontWeight: FontWeight.w800), textAlign: TextAlign.center, )),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  'How was your experience ?',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                const SizedBox(height: 15),
                ListTile(

                  title: const Text('Fantastic!', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sentiment_very_satisfied, color: Colors.green),
                  onTap: () => sendFeedbackToFirestore('Fantastic!'),
                ),
                ListTile(
                  title: const Text('Good', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
                  onTap: () => sendFeedbackToFirestore('Good'),
                ),
                ListTile(
                  title: const Text('Fine', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sentiment_neutral, color: Colors.yellow),
                  onTap: () => sendFeedbackToFirestore('Fine'),
                ),
                ListTile(
                  title: const Text('Below Average', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sentiment_dissatisfied, color: Colors.orange),
                  onTap: () => sendFeedbackToFirestore('Below Average'),
                ),
                ListTile(
                  title: const Text('Very Bad', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
                  onTap: () => sendFeedbackToFirestore('Very Bad'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
            PopupMenuButton(
              color: Colors.black,
              // icon: const Icon(Icons.feedback), // Replace with relevant icon
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.feedback,color: Colors.limeAccent,), // Can be same or different icon
                    title: const Text('Give Feedback',style: TextStyle(color: Colors.limeAccent),),
                    onTap: showFeedbackForm, // Call your function here
                  ),
                ),
              ],
            ),

          ]
      ),
      drawer: Padding(
        padding: const EdgeInsets.all( 5.0),
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.black,
          child: Column(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          return UserAccountsDrawerHeader(
                            decoration: BoxDecoration(color: Colors.black),
                            margin: EdgeInsets.zero,
                            accountEmail: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [Theme.of(context).primaryColor, Colors.orange, Colors.orangeAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                user.email ?? '',
                                style: TextStyle(fontSize: 19, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            accountName: null,
                            currentAccountPicture: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                user.displayName?.isNotEmpty == true ? user.displayName![0].toUpperCase() : user.email![0].toUpperCase(),
                                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        } else {
                          return UserAccountsDrawerHeader(
                            decoration: BoxDecoration(color: Colors.black),
                            margin: EdgeInsets.zero,
                            accountEmail: Text('Not Logged In', style: TextStyle(color: Colors.white)),
                            accountName: null,
                            currentAccountPicture: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 40),
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.deepOrange),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => history()),
                  );
                },
                leading: Icon(Icons.history, size: 25, color: Theme.of(context).primaryColor),
                title: Text(
                  'History',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                ),
              ),
              Divider(),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                leading: Icon(Icons.logout_outlined, size: 25, color: Theme.of(context).primaryColor),
                title: Text('Logout', style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => homeScreen()),
                  );
                },
              )
                  : ListTile(
                leading: Icon(Icons.login_outlined, size: 25, color: Theme.of(context).primaryColor),
                title: Text('Login', style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: FutureBuilder(

        future: CurrencyConvert.currencyapi(baseCurrency),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map map = jsonDecode(snapshot.data);
            double totalValue = map["rates"][otherCurrency] * d1;

            return Center(
              child: FractionallySizedBox(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                            ],
                            controller: amountController,
                            onChanged: (value) {
                              parseTextToDouble();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount to convert.';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.orange),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              prefixIcon: Icon(Icons.calculate,color: Colors.deepOrangeAccent,),

                              hintText: 'Enter Amount To Convert',
                                 hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),                            ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent,
                                  width: 2
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 130, // Adjust the height as needed
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.38,
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      child: DropdownSearch<dynamic>(
                                        items: baseDropdownItems,
                                        onChanged: (value) {
                                          setState(() {
                                            baseCurrency = value.toString();
                                          });
                                        },
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                        ),
                                        dropdownButtonProps: DropdownButtonProps(
                                          highlightColor: Colors.deepOrange,
                                          color: Colors.deepOrange,),
                                        dropdownDecoratorProps: DropDownDecoratorProps(

                                          baseStyle: TextStyle(
                                            color: Colors.deepOrange,fontSize: 15,
                                            fontWeight: FontWeight.w800,

                                          ),
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          dropdownSearchDecoration: InputDecoration(
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Colors.deepOrange,width: 2)
                                            ),
                                              hintText: "Select base currency",
                                              hintStyle: TextStyle(color: Colors.deepOrange,),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.deepOrange,width: 2)
                                            ),
                                          ),
                                        ),
                                        selectedItem: baseCurrency,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        String temp = baseCurrency;
                                        baseCurrency = otherCurrency;
                                        otherCurrency = temp;
                                      });
                                    },
                                    child: Icon(Icons.swap_horizontal_circle_outlined, color: Colors.black,size: 40,),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.38,
                                    child: FractionallySizedBox(
                                      widthFactor: 1,
                                      child: DropdownSearch<dynamic>(
                                        items: otherDropdownItems,
                                        onChanged: (newValue) {
                                          setState(() {
                                            otherCurrency = newValue.toString();
                                          });
                                        },
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                        ),

                                        dropdownButtonProps: DropdownButtonProps(
                                          highlightColor: Colors.deepOrange,
                                          color: Colors.deepOrange,),
                                        dropdownDecoratorProps: DropDownDecoratorProps(

                                          baseStyle: TextStyle(
                                              color: Colors.deepOrange,fontSize: 15,
                                            fontWeight: FontWeight.w800,

                                          ),
                                          textAlignVertical: TextAlignVertical.center,
                                          textAlign: TextAlign.center,
                                          dropdownSearchDecoration: InputDecoration(
                                            hintText: "Select Convert currency",
                                            hintStyle: TextStyle(color: Colors.orange),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Colors.deepOrange,width: 2)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Colors.deepOrange,width: 2)
                                            ),
                                          ),
                                        ),
                                        selectedItem: otherCurrency,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.95,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Text field has a value, perform conversion
                                  performConversion(map);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
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
                                },
                                child: Text('Convert',style: TextStyle(fontWeight: FontWeight.w800))),
                            ),
                          ),
                          SizedBox(height: 20),
                          if (showTotalValue)
                            Column(
                              children: [
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.money_off_csred_sharp),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          colors: [Theme.of(context).primaryColor,Colors.orange, Colors.amberAccent], // Change colors as needed
                                          begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                                          end: Alignment.centerRight, // Adjust the gradient direction as needed
                                        ).createShader(bounds);
                                      },child: Text('$totalValue', style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900))),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '1 $baseCurrency = ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' ${map["rates"][otherCurrency]} $otherCurrency ',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),
                              ],
                            ),


              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.active) {
                    if (authSnapshot.hasData) {
                      // User is authenticated, return a widget that will trigger navigation
                      return TextButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => history()),
                          );
                        },
                        child: Text(
                          'View history',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                      );
                    } else {
                      // User is not authenticated, return a login button
                      return TextButton(
                        onPressed: () {
                          // Navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        child: Text(
                          'Log in to view history',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                      );

                    }
                  } else {
                    // Authentication state is still loading
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.error_outline),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void performConversion(Map map) {
    setState(() {
      double amount = double.tryParse(amountController.text) ?? 0;
      double rate = map["rates"][otherCurrency];
      totalValue = amount * rate;
      showTotalValue = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        print(user);

        Map<String, dynamic> currencyHistory = {
          "userId": userId,
          "baseCurrency": baseCurrency,
          "convertCurrency": otherCurrency,
          "value": totalValue.toString(),
          "timestamp": Timestamp.now(),
        };

        FirebaseFirestore.instance.collection("History").add(currencyHistory);
      }
    });
  }





}
