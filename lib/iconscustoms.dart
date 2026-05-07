import 'package:flutter/material.dart';
import 'textcustom.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  int days = 0;
  int pills = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Textcustom(
              text: "add plan",
              fontweight: FontWeight.w600,
              fontsize: 28,
              fontcolor: Color(0xFF0A0909),
            ),
            SizedBox(height: 20),

            // Pills Name
            Textcustom(
              text: "Pill Name",
              fontweight: FontWeight.w500,
              fontsize: 15,
              fontcolor: Color(0xFF0A0909),
            ), SizedBox(height: 15,),
            TextField(
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 230, 230, 227),
                filled: true,

                prefixIcon: Icon(Icons.medication),
                hintText: "Oxycodone",
                suffixIcon: Icon(
                  Icons.qr_code,
                  
                  color: Color(0xFF1BD15D),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 167, 167, 165),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Amount & How long
            Textcustom(
              text: "Amount& How long ?",
              fontweight: FontWeight.w500,
              fontsize: 15,
              fontcolor: Color(0xFF0A0909),
            ),

            /// first container
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    width: 152,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.medical_information,
                          size: 20,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 10),
                        Textcustom(
                          text: "$pills",
                          fontweight: FontWeight.w600,
                          fontsize: 15,
                          fontcolor: Colors.black,
                        ),
                        Spacer(),
                        Textcustom(
                          text: "pills",
                          fontweight: FontWeight.w500,
                          fontsize: 13,
                          fontcolor: Colors.black,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(minHeight: 1),
                              icon: Icon(
                                Icons.arrow_drop_up,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (pills > 0) pills--;
                                });
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  pills++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // container 2
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 48,
                    width: 152,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 10),
                        Textcustom(
                          text: "$days",
                          fontweight: FontWeight.w600,
                          fontsize: 15,
                          fontcolor: Colors.black,
                        ),
                        Spacer(),
                        Textcustom(
                          text: "days",
                          fontweight: FontWeight.w500,
                          fontsize: 13,
                          fontcolor: Colors.black,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(minHeight: 1),
                              icon: Icon(
                                Icons.arrow_drop_up,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (days > 0) days--;
                                });
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (days < 31) days++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Food & Pills
            Textcustom(
              text: "Food & Pills",
              fontweight: FontWeight.w500,
              fontsize: 15,
              fontcolor: Color(0xFF0A0909),
            ),
            Row(
              children: [
                //container 1
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 90,
                    width: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 5, color: Color(0xFF9B9B9B)),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/Group.png',
                          width: 8.45,
                          height: 36.89,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/Group 8.png',
                          width: 17.6,
                          height: 17.66,
                          color: Color(0xFF9B9B9B),
                        ),
                      ],
                    ),
                  ),
                ),
                //cointainer 2
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 90,
                    width: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Image.asset(
                          'assets/images/Group.png',
                          width: 8.45,
                          height: 36.89,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 4),
                         Icon(Icons.circle, size: 5, color: Color(0xFF9B9B9B)),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/Group 8.png',
                          width: 17.6,
                          height: 17.66,
                          color: Color(0xFF9B9B9B),
                        ),
                      ],
                    ),
                  ),
                ),
                //container 3
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 90,
                    width: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Image.asset(
                          'assets/images/Group.png',
                          width: 8.45,
                          height: 36.89,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/Group 8.png',
                          width: 17.6,
                          height: 17.66,
                          color: Color(0xFF9B9B9B),
                        ),
                        SizedBox(width: 4,),
                         Icon(Icons.circle, size: 5, color: Color(0xFF9B9B9B)),
                      
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Notification
            Textcustom(
              text: "notifaction",
              fontweight: FontWeight.w500,
              fontsize: 15,
              fontcolor: Colors.black,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Expanded(
                  child: Container(
                    
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 230, 230, 227),
                    ),
                    child: Row(
                      children: [SizedBox(width: 10,),
                        Icon(Icons.alarm, size: 20, color: Color(0xFF9B9B9B)),
                  SizedBox(width: 5,),
                        Textcustom(
                          text: "10:00 AM",
                          fontweight: FontWeight.w600,
                          fontsize: 17,
                          fontcolor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80,),

            // Done Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Done", style: TextStyle(fontSize: 18,color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
