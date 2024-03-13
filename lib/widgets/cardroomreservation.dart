import 'package:flutter/material.dart';
import 'package:yolo_business/model/dataModel.dart';

const kfontSizeDiscount = TextStyle(fontSize: 10);

class RoomCardResrvation extends StatelessWidget {
  const RoomCardResrvation(
      {super.key, required this.room, required this.onTap});
  final RoomReservation room;
  final void Function(RoomReservation room, BuildContext context) onTap;

  String _formatRent(int rent) {
    if (rent >= 10000) {
      return '${(rent ~/ 1000).toStringAsFixed(1)}k';
    } else {
      return rent.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(room, context);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 108, 117, 211)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 270,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: Image.network(
                  room.image[0],
                  height: 270,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.roomType.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: room.location.length > 2 ? 2 : 1,
                        itemBuilder: (context, index) {
                          return Text(
                            room.location[0],
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Divider(
                      thickness: 0.9,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Card(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        room.sex.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Monthly Rent '),
                      Row(
                        children: [
                          Text(
                            _formatRent(room.rent),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const Text(' Onwards'),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 138, 227, 141),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.discount,
                          size: 15,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Upto',
                          style: kfontSizeDiscount,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '20%',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Off',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
