import 'dart:convert';

import 'package:currencee/currencyapi.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  String baseCurrency='USD';
  List<String> baseDropdownItems = ["PKR", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"];
  String otherCurrency = 'PKR';
  List<String> otherDropdownItems = ["PKR", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMW", "ZWL"];
  final amountController=TextEditingController();
  double d1=0;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 3),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
          }, icon: Icon(Icons.person_outline_sharp))
        ] ),
        body:FutureBuilder(
        future: CurrencyConvert.currencyapi(baseCurrency),
    builder: (context, snapshot) {
    if(snapshot.hasData)
    {
    Map map= jsonDecode(snapshot.data);
    double total_value=map["rates"][otherCurrency]*d1;



    return Center(
      child: FractionallySizedBox(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: amountController,
                  onChanged: (value)
                  {
                    parseTextToDouble();
                    setState(() {
                      if(d1==0 || amountController.text.isEmpty || amountController.text=='')
                      {
                        total_value=0;
                      }
                      total_value=total_value*d1;
                    });
                  },


                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: FractionallySizedBox(
                        widthFactor:1,
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
                          dropdownButtonProps: DropdownButtonProps(color: Colors.purple,),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),

                          selectedItem: baseCurrency,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: ()
                        {
                          setState(() {
                            String temp = baseCurrency;
                            baseCurrency = otherCurrency;
                            otherCurrency = temp;
                          });

                        },
                        child: Icon(Icons.swap_horizontal_circle_outlined,color: Theme.of(context).primaryColor, size: 40,)),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                      child: FractionallySizedBox(
                        widthFactor:1,
                        child: DropdownSearch<dynamic>(  //  to make
                          // sure that the list of items are string like this List<String>
                          items: otherDropdownItems,
                          onChanged: (newValue) {
                            setState(() {
                              otherCurrency = newValue.toString();
                              Map<String, dynamic> currencyHistory = {
                                "baseCurrency" : baseCurrency,
                                "convertCurrency" : otherCurrency,
                                "value" : "$total_value"
                              };
                              // FirebaseFirestore.instance.collection("History").add(currencyHistory);
                            });
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                          ),
                          dropdownButtonProps: DropdownButtonProps(color: Colors.purple,),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            textAlignVertical: TextAlignVertical.center,
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          selectedItem: otherCurrency,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.attach_money),
                   Text('$total_value',style: TextStyle(fontSize: 23),),
                 ],
               ),
                Text(
                  ' 1  ${baseCurrency} = ${total_value} ${otherCurrency} '),

                SizedBox(height: 20,),
                // GestureDetector(
                //     onTap: (){
                //       showModalBottomSheet(context: context, builder: (context) {
                //         return BottomSheet(onClosing: (){},enableDrag: true, builder: (context) {
                //           return StreamBuilder(
                //             stream: FirebaseFirestore.instance.collection('History').snapshots(),
                //             builder: (context, snapshot) {
                //               if(snapshot.hasData)
                //               {
                //                 var data_lenght=snapshot.data!.docs.length;
                //                 return ListView.builder(
                //                   itemCount: data_lenght,
                //                   itemBuilder: (context, index) {
                //                     return ListTile(
                //                       title: Text('${snapshot.data!.docs[index]['baseCurrency']} - ${snapshot.data!.docs[index]['convertCurrency']}'),
                //                       subtitle: Text('${snapshot.data!.docs[index]['value']}'),
                //                     );
                //                   },);
                //               }
                //               else if(snapshot.hasError)
                //               {
                //                 return Center(
                //                   child: Icon(Icons.error_outline),
                //                 );
                //               }
                //               else
                //               {
                //                 return Center(child: CircularProgressIndicator());
                //               }
                //             },);
                //         },);
                //       },);
                //     },
                //     child: Text('View History',style: TextStyle(
                //         color: Colors.purple
                //     ),))

              ],
            ),
          ),
        ),
      ),
    );

    }
    else if(snapshot.hasError)
    {
      return Center(
        child: Icon(Icons.error_outline),
      );
    }
    else
    {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    },
        ),
    );
  }
}
