import 'package:flutter/material.dart';
import 'package:yolo_business/model/dataModel.dart';
import 'package:yolo_business/services/reservation_services.dart';
import 'package:yolo_business/widgets/carousel.dart';
import 'package:yolo_business/widgets/displayroomtypes.dart';
import 'package:yolo_business/widgets/divideline.dart';
import 'package:yolo_business/widgets/snackbar.dart';
import 'package:yolo_business/widgets/tiledisplayroomreservation.dart';

const kcolortextdisplayroom = TextStyle(
  color: Colors.white,
);

class DisplayRoomReservation extends StatefulWidget {
  const DisplayRoomReservation(
      {super.key,
      required this.screenType,
      required this.room,
      required this.ontap,
      required this.onremove});
  final bool screenType;
  final RoomReservation room;
  final void Function(String id) ontap;
  final void Function(String id) onremove;
  @override
  State<DisplayRoomReservation> createState() => _DisplayRoomReservationState();
}

class _DisplayRoomReservationState extends State<DisplayRoomReservation> {
  bool isExpanded = false;
  bool roomTypeExpanded = false;
  bool locationExpanded = false;
  @override
  Widget build(BuildContext context) {
    final roomObj = widget.room;
    return Scaffold(
      bottomNavigationBar: widget.screenType ? bottomAppBar() : null,
      appBar: AppBar(
        title: Text('id: ${roomObj.id}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(children: [
        Column(
          children: [
            Carousel(
              imageUrls: widget.room.image,
            ),
            DisplayRoomTileReservation(widget: widget, roomObj: roomObj),
            const DividerLine(),
            if (isExpanded == false)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: roomObj.amenities.length < 4
                              ? roomObj.amenities.length
                              : 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 40),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 4,
                              child: amenitiesIconsReservation[
                                  roomObj.amenities[index]],
                            );
                          },
                        )),
                    if (!(roomObj.amenities.length <= 4))
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 96, 104, 189),
                            foregroundColor: Colors.white,
                            child: Center(
                                child:
                                    Text('+ ${roomObj.amenities.length - 4}'))),
                      ))
                  ],
                ),
              ),
            if (isExpanded == true)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: roomObj.amenities.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 60),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                              child: amenitiesIconsReservation[
                                  roomObj.amenities[index]],
                            );
                          },
                        )),
                  ],
                ),
              ),
            const DividerLine(),
            if (roomTypeExpanded == false)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Room Types',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            roomTypeExpanded = !roomTypeExpanded;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 96, 104, 189),
                        ))
                  ],
                ),
              ),
            if (roomTypeExpanded == true)
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Room Types',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                roomTypeExpanded = !roomTypeExpanded;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 96, 104, 189),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'This Property has Two types of Sharing basis.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DisplayRoomTypes(
                          type: 'Private Room',
                          rent: roomObj.rent,
                          icon: Icons.person,
                        ),
                        DisplayRoomTypes(
                          type: 'Two Sharing',
                          rent: roomObj.rent ~/ 2,
                          icon: Icons.person_add,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const DividerLine(),
            if (locationExpanded == false)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Location And Maps',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            locationExpanded = !locationExpanded;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 96, 104, 189),
                        ))
                  ],
                ),
              ),
            if (locationExpanded == true)
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Location And Maps',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  locationExpanded = !locationExpanded;
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Color.fromARGB(255, 96, 104, 189),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(roomObj.address)),
                          const Icon(
                            Icons.location_city,
                            color: Color.fromARGB(255, 96, 104, 189),
                          )
                        ],
                      )
                    ],
                  )),
            const DividerLine()
          ],
        ),
      ]),
    );
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      color: const Color.fromARGB(255, 96, 104, 189),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              widget.ontap(widget.room.id);
              showSnackBar(context, 'Rejected Details');
              Navigator.pop(context);
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              ReservationServices service = ReservationServices();
              service.approvedRoom(widget.room, context);
              showSnackBar(context, 'Approved Details');
              widget.onremove(widget.room.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Approve',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
