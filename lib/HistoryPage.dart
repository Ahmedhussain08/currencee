import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currencee/login.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  void deleteConversionHistory(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('History').doc(documentId).delete();
      // Show a success message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text('Conversion history deleted successfully!'),
        ),
      );
    } catch (error) {
      // Handle potential errors
      print('Error deleting conversion history: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Error deleting history. Please try again later.'),
        ),
      );
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

      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.active) {
            if (authSnapshot.hasData) {
              User? user = FirebaseAuth.instance.currentUser;
              String userId = user!.uid;
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('History').where('userId', isEqualTo: userId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> historyDocs = snapshot.data!.docs;
                    if (historyDocs.isEmpty) {
                      return Center(child: Text('No history available'));
                    }
                    return SingleChildScrollView( // Wrap with SingleChildScrollView
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Conversion History',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: historyDocs.length,
                            itemBuilder: (context, index) {
                              var historyData = historyDocs[index];
                              return Card(
                                elevation: 8,
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                color: Colors.black,
                                shadowColor: Colors.orange.shade900,
                                child: ListTile(
                                  title: Text(
                                    '${historyData['baseCurrency']} - ${historyData['convertCurrency']}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.limeAccent,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Value: ${historyData['value']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Date: ${DateFormat('dd-MM-yyyy (HH:mm:ss)').format((historyData['timestamp'] as Timestamp).toDate())}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteConversionHistory(historyData.id);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching history: ${snapshot.error}'));
                  } else {
                    return Center(child: Text('No history available'));
                  }
                },
              );
            } else {
              return Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login To See History',
                        style: TextStyle( color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed:
                            () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => login(),));
                        }, // Placeholder function, replace with your login logic
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Theme.of(context).primaryColor,Colors.orange, Colors.limeAccent], // Change colors as needed
                              begin: Alignment.centerLeft, // Adjust the gradient direction as needed
                              end: Alignment.centerRight, // Adjust the gradient direction as needed
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Login Here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 20),
                          padding: EdgeInsets.all(17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),

              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }
}
