import 'package:flutter/material.dart';
import 'package:yolo_business/model/dataModel.dart';
import 'package:yolo_business/widgets/displayroomreservation.dart';

class DisplayRoomTileReservation extends StatelessWidget {
  const DisplayRoomTileReservation({
    super.key,
    required this.widget,
    required this.roomObj,
  });
  final DisplayRoomReservation widget;
  final RoomReservation roomObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Card(
        color: const Color.fromARGB(255, 96, 104, 189),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 60, top: 5, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.room.roomType.name.toUpperCase(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Text(
                        widget.room.location[0],
                        textAlign: TextAlign.start,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      if (!(widget.room.location.length > 2 ||
                          widget.room.location.length == 1))
                        Text(
                          widget.room.location[1],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 18,
                        child: Center(child: Icon(sexIcons[roomObj.sex]))),
                    Text(
                      roomObj.sex.name.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
