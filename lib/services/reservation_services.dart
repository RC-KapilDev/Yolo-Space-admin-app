import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/model/dataModel.dart';

class ReservationServices {
  List<RoomReservation> roomRes = [];
  void approvedRoom(RoomReservation room, BuildContext context) async {
    try {
      final List<String> amenities =
          room.amenities.map((amenity) => amenity.name).toList();

      Map<String, dynamic> resevation = {
        '_id': room.id,
        'sex': room.sex.name,
        'amenities': amenities,
        'roomtype': room.roomType.name,
        'location': room.location,
        'rent': room.rent,
        'address': room.address,
        'image': room.image
      };

      http.Response response = await http.delete(
        Uri.parse(
            'https://sore-jade-jay-wig.cyclic.app/validate/approve/${room.id}'),
        body: json.encode(resevation),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Reservation successful');
      } else {
        print('Reservation failed: ${response.body}');
      }
    } catch (e) {
      print('Error making reservation: $e');
    }
  }
}
