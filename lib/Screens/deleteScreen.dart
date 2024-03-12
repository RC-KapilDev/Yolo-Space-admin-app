import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yolo_business/model/dataModel.dart';
import 'package:yolo_business/utils/constants.dart';
import 'package:yolo_business/widgets/cardroomreservation.dart';
import 'package:yolo_business/widgets/displayroomreservation.dart';
import 'package:http/http.dart' as http;
import 'package:yolo_business/widgets/searchdelegate.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
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
      final response = await http.get(Uri.parse('${Constants.uri}/yolo/rooms'));
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
                  screenType: false,
                )));
  }

  void checkEmptyList() {
    if (reservedRoom.isEmpty) {
      setState(() {});
    }
  }

  void removeFav(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('${Constants.uri}/yolo/$id'));
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
          title: const Text('Room Details Delete'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: MySearchDelegate(
                          roomList: reservedRoom,
                          onrem: removeitem,
                          onta: removeFav));
                },
                icon: const Icon(Icons.search))
          ],
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
