import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/machine_iot/widget/ticket_info_cart_widget.dart';
import 'package:flutter/material.dart';

class AssignTechnicianScreen extends StatelessWidget {
  const AssignTechnicianScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assign Technician',
          style: TextStyle(fontFamily: "Mulish", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 152, 165, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Row(children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'TicketNumber :',
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(21, 147, 159, 1)),
                    ),
                  )),
              SizedBox(width: 10.0),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      '12356789',
                      style:
                          TextStyle(fontFamily: "Mulish", color: Colors.black),
                    ),
                  ))
            ]),
            const Row(children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Issue :',
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(21, 147, 159, 1)),
                    ),
                  )),
              SizedBox(width: 10.0),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Drill bit Broken',
                      style:
                          TextStyle(fontFamily: "Mulish", color: Colors.black),
                    ),
                  ))
            ]),
            const SizedBox(height: 10.0),
            SizedBox(
              width: width,
              height: height - 220,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 100,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      color: Colors.white, //
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,

                                  value:
                                      false, // Set the initial value of checkbox
                                  onChanged: (bool? value) {
                                    // Implement your logic here
                                  },
                                ),
                                Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red)),

                                const SizedBox(
                                    width:
                                        8), // Add some space between checkbox and image
                                const Text(
                                  'Shanmugam',
                                  style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            TicketInfoCardWidget(
                                title: 'Skill set  :', value: '--'),
                            const SizedBox(height: 8),
                            TicketInfoCardWidget(
                                title: 'Department :', value: 'IOL'),
                            const SizedBox(height: 8),
                            TicketInfoCardWidget(
                                title: 'Completed  :', value: '3'),
                            const SizedBox(height: 8),
                            TicketInfoCardWidget(
                                title: 'Accept     :', value: '2'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (ctx) => const BottomNavScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(21, 147, 159, 1)),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontFamily: "Mulish", color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
