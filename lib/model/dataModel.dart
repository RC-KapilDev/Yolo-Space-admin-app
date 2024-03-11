import 'package:flutter/material.dart';
import 'dart:convert';

enum RoomType { basic, medium, premium, luxury }

enum Amenities {
  parking,
  ac,
  wifi,
  refrigerator,
  almirah,
  bedsheet,
  cctv,
  housekeeping,
  pillow,
  drinkingwater,
  bathroom,
  wash
}

enum Sex { male, female, unisex }

final amenitiesIconsReservation = {
  Amenities.parking: Image.asset('lib/icons/parking.png'),
  Amenities.ac: Image.asset('lib/icons/air-conditioning.png'),
  Amenities.wifi: Image.asset('lib/icons/wifi.png'),
  Amenities.refrigerator: Image.asset('lib/icons/cold.png'),
  Amenities.almirah: Image.asset('lib/icons/clothing-rack.png'),
  Amenities.bedsheet: Image.asset('lib/icons/sheet.png'),
  Amenities.cctv: Image.asset('lib/icons/cctv-camera.png'),
  Amenities.housekeeping: Image.asset('lib/icons/maid.png'),
  Amenities.pillow: Image.asset('lib/icons/pillow.png'),
  Amenities.drinkingwater: Image.asset('lib/icons/water-bottle.png'),
  Amenities.bathroom: Image.asset('lib/icons/bathtub.png'),
  Amenities.wash: Image.asset('lib/icons/laundry-machine.png'),
};

const sexIcons = {
  Sex.male: Icons.male,
  Sex.female: Icons.female,
  Sex.unisex: Icons.roundabout_left,
};

class RoomReservation {
  RoomReservation(
      {required this.id,
      required this.roomType,
      required this.location,
      required this.sex,
      required this.amenities,
      required this.rent,
      required this.address,
      required this.image});
  final RoomType roomType;
  final String id;
  final List<String> location;
  final Sex sex;
  final int rent;
  final List<Amenities> amenities;
  final String address;
  final List<String> image;

  factory RoomReservation.fromJson(Map<String, dynamic> json) =>
      RoomReservation(
        id: json['_id'],
        roomType:
            RoomType.values.firstWhere((type) => type.name == json['roomtype']),
        location: List<String>.from(json['location']),
        sex: Sex.values.firstWhere((sex) => sex.name == json['sex']),
        amenities: (json['amenities'] as List<dynamic>)
            .map((amenity) =>
                Amenities.values.firstWhere((a) => a.name == amenity))
            .toList(),
        rent: json['rent'],
        address: json['address'],
        image: List<String>.from(json['image']),
      );
}

List<RoomReservation> parseReservationFromJson(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
  return jsonList.map((json) => RoomReservation.fromJson(json)).toList();
}
