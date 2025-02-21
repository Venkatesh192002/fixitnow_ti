import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                  width: 3, color: Color.fromARGB(255, 221, 221, 221))),
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        width: 100,
                        height: 100,
                        'images/3d_avator.jpg',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: "Mulish",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            fontFamily: "Mulish",
                            color: Color.fromARGB(255, 131, 131, 131),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // GestureDetector(
                //   onTap: () {
                //     SqliteDb().deleteItem(id);
                //   },
                //   child: SvgPicture.asset(
                //     width: 40,
                //     height: 40,
                //     'images/delete_icon.svg',
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
