import 'package:flutter/material.dart';
import 'package:yolo_business/model/dataModel.dart';
import 'package:yolo_business/widgets/cardroomreservation.dart';
import 'package:yolo_business/widgets/displayroomreservation.dart';

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate(
      {required this.roomList, required this.onrem, required this.onta});
  final List<RoomReservation> roomList;
  final void Function(String id) onta;
  final void Function(String id) onrem;

  void displayScreen(RoomReservation room, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayRoomReservation(
                  room: room,
                  onremove: onrem,
                  ontap: onta,
                  screenType: false,
                )));
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    final Set<String> uniqueLocations = <String>{};
    final List<RoomReservation> suggestions = query.isEmpty
        ? []
        : roomList.where((room) {
            final input = query.toLowerCase();
            final containsInput = room.location
                .any((location) => location.toLowerCase().contains(input));
            if (containsInput) {
              uniqueLocations
                  .addAll(room.location); // Add all unique locations to the set
            }
            return containsInput;
          }).toList();

    return ListView.builder(
      itemCount: uniqueLocations.length,
      itemBuilder: (context, index) {
        final location = uniqueLocations.elementAt(index);
        return ListTile(
          title: Text(location),
          onTap: () {
            query = location; // Set the query to the selected location
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<RoomReservation> searchResults = roomList.where((room) {
      final input = query.toLowerCase();
      return room.location
          .any((location) => location.toLowerCase().contains(input));
    }).toList();

    if (searchResults.isEmpty) {
      return Center(
        child: Text('No results found for "$query"'),
      );
    } else {
      return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final RoomReservation room = searchResults[index];
          return Dismissible(
              key: ValueKey(room.id),
              onDismissed: (direction) => onta(room.id),
              background: Container(
                color: Colors.red,
              ),
              child: RoomCardResrvation(room: room, onTap: displayScreen));
        },
      );
    }
  }
}
