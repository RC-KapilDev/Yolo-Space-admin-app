import 'dart:async';
import 'package:flutter/material.dart';

import 'package:yolo_business/model/dataModel.dart';
import 'package:yolo_business/services/reservation_services.dart';

import 'package:yolo_business/widgets/carousel.dart';
import 'package:yolo_business/widgets/displayroomtypes.dart';
import 'package:yolo_business/widgets/divideline.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  bool visible = false;
  Duration duration = const Duration(seconds: 10);
  Timer? timer;
  List<RoomReservation> reservedRoom = [];
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(
          Uri.parse('https://odd-red-perch-ring.cyclic.app/validate/rooms'));
      if (response.statusCode == 200) {
        setState(() {
          reservedRoom = parseReservationFromJson(response.body);

          visible = true;
        });
        timer?.cancel();
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void displayScreen(RoomReservation room, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayRoomReservation(
                  room: room,
                  ontap: removeFav,
                  onremove: removeitem,
                )));
  }

  void checkEmptyList() {
    if (reservedRoom.isEmpty) {
      setState(() {});
    }
  }

  void removeFav(String id) async {
    try {
      final response = await http.delete(
          Uri.parse('https://odd-red-perch-ring.cyclic.app/validate/$id'));
      if (response.statusCode == 200) {
        setState(() {
          reservedRoom.removeWhere((room) => room.id == id); // Remove from list
        });
        showSnackBar(context, 'Deleted');
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void removeitem(String id) {
    setState(() {
      reservedRoom.removeWhere((room) => room.id == id); // Remove from list
    });
  }

  @override
  Widget build(BuildContext context) {
    timer ??= Timer.periodic(duration, (timer) {
      fetch();
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('Room Upload Requests'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Colors.white,
        ),
        body: Scaffold(
          body: Visibility(
              visible: visible,
              replacement: Container(
                margin: const EdgeInsets.symmetric(vertical: 100),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              child: reservedRoom.isEmpty
                  ? const Center(
                      child: Text(
                        'Oh Nothing Found Here!!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: reservedRoom.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          key: ValueKey(reservedRoom[index].id),
                          onDismissed: (direction) =>
                              removeFav(reservedRoom[index].id),
                          background: Container(
                            color: Colors.red,
                          ),
                          child: RoomCardResrvation(
                            room: reservedRoom[index],
                            onTap: displayScreen,
                          ),
                        ),
                      ),
                    )),
        ));
  }
}

const kfontSizeDiscount = TextStyle(fontSize: 10);

class RoomCardResrvation extends StatelessWidget {
  const RoomCardResrvation(
      {super.key, required this.room, required this.onTap});
  final RoomReservation room;
  final void Function(RoomReservation room, BuildContext context) onTap;

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
                      Text(
                        room.location[0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        room.location[1],
                        style: const TextStyle(color: Colors.black),
                      ),
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
                            room.rent.toString(),
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

const kcolortextdisplayroom = TextStyle(
  color: Colors.white,
);

class DisplayRoomReservation extends StatefulWidget {
  const DisplayRoomReservation(
      {super.key,
      required this.room,
      required this.ontap,
      required this.onremove});
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
      bottomNavigationBar: bottomAppBar(),
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
              'Approved',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

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
                child: Column(
                  children: [
                    Text(
                      widget.room.roomType.name.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      widget.room.location[1],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ],
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
