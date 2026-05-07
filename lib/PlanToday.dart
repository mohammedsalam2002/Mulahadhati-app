import 'package:flutter/material.dart';
import 'iconscustoms.dart';
import 'textcustom.dart';

class PlanToday extends StatelessWidget {
  const PlanToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F6),
                ), // عرض محدد لمربع البحث
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).hintColor,
                      hintText: "search",
                      hintStyle: const TextStyle(
                        fontSize: 20,
                        letterSpacing: -1,
                        color: Color(0xFF9B9B9B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search, size: 26),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            //text hello kathren
            Textcustom(
              text: "hello",
              fontweight: FontWeight.w600,
              fontsize: 28,
              fontcolor: Colors.black,
            ),

            Textcustom(
              text: "Kathren",
              fontweight: FontWeight.w400,
              fontsize: 28,
              fontcolor: Colors.black,
            ),
            SizedBox(height: 5),

            //stack, texts inside container
            Stack(
              clipBehavior: Clip.none, // يسمح بخروج الصورة من حدود الكونتينر
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Color(0xFFF3F6C8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 52, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Textcustom(
                          text: "your plan\nfor today",
                          fontweight: FontWeight.w600,
                          fontsize: 18,
                          fontcolor: Color(0xFF0A0909),
                        ),
                        const SizedBox(height: 3),
                        Textcustom(
                          text: "1 of 4 completed",
                          fontweight: FontWeight.w400,
                          fontsize: 11,
                          fontcolor: Color(0xFFEC7669),
                        ),
                        const SizedBox(height: 30),
                        Textcustom(
                          text: "show more",
                          fontweight: FontWeight.w600,
                          fontsize: 13,
                          fontcolor: Color(0xFFEC7669),
                        ),
                        const Text(
                          "__________ ",
                          style: TextStyle(color: Color(0xFFEC7669)),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✨ الصورة هنا بمكانها
                Positioned(
                  bottom: 20, // المسافة من الأعلى
                  right: -30, // سالب يعني تطلع برا الكونتينر من الجهة اليمنى
                  child: Image.asset(
                    'assets/images/Group 21.png',
                    width: 248,
                    height: 251,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20), //text daily review
            Textcustom(
              text: "Daily Review",
              fontweight: FontWeight.w500,
              fontsize: 17,
              fontcolor: Color(0xFF0A0909),
            ),

            //listview.builder
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFFF8F8F6),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.pix_outlined, size: 20),
                      title: Text("oxcone"),
                      subtitle: Text("data"),
                      trailing: Icon(Icons.arrow_right_outlined),
                    ),
                  );
                },
              ),
            ),

            //container icons
            Container(
              height: 80,
              width: double.infinity,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xFFF8F8F6),
                    ),
                    child: Icon(Icons.home, size: 20, color: Colors.green),
                  ),

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.piano,
                      size: 20,
                      color: const Color.fromARGB(255, 167, 170, 167),
                    ),
                  ),

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) => AddPlanScreen()),
                        );
                      },
                      icon: Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  ),

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 20,
                      color: const Color.fromARGB(255, 167, 170, 167),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.chat_rounded,
                      size: 20,
                      color: const Color.fromARGB(255, 167, 170, 167),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
