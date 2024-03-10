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

final amenitiesIcons = {
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

class Room {
  Room(
      {required this.roomType,
      required this.location,
      required this.sex,
      required this.amenities,
      required this.rent,
      required this.address,
      required this.image});
  final RoomType roomType;

  final List<String> location;
  final Sex sex;
  final int rent;
  final List<Amenities> amenities;
  final String address;
  final List<String> image;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
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

List<Room> parseRoomsFromJson(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
  return jsonList.map((json) => Room.fromJson(json)).toList();
}

// List<Room> Rooms = [
//   Room(
//       roomType: RoomType.premium,
//       location: ['Chennai', 'Adambakkam'],
//       sex: Sex.male,
//       amenities: [
//         Amenities.ac,
//         Amenities.almirah,
//         Amenities.cctv,
//         Amenities.parking,
//         Amenities.drinkingwater
//       ],
//       rent: 16200,
//       address: '  No 4/5 1st Floor, Hello Colony , Adambakkam ,Chennai-600056 ',
//       image: [
//         'https://images.livspace-cdn.com/plain/https://jumanji.livspace-cdn.com/magazine/wp-content/uploads/sites/2/2022/06/10183457/small-bedroom-ideas.jpg',
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSajn8L1P4PAvH_vr1aW2-2wuXlmal6qPWqajQIRxQAKg&s'
//       ]),
//   Room(
//       roomType: RoomType.premium,
//       location: ['Chennai', 'Adambakkam'],
//       sex: Sex.male,
//       amenities: [
//         Amenities.ac,
//         Amenities.almirah,
//         Amenities.cctv,
//         Amenities.parking,
//         Amenities.drinkingwater
//       ],
//       rent: 16200,
//       address: '  No 4/5 1st Floor, Hello Colony , Adambakkam ,Chennai-600056 ',
//       image: [
//         'https://images.livspace-cdn.com/plain/https://jumanji.livspace-cdn.com/magazine/wp-content/uploads/sites/2/2022/06/10183457/small-bedroom-ideas.jpg',
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSajn8L1P4PAvH_vr1aW2-2wuXlmal6qPWqajQIRxQAKg&s'
//       ]),
// ];


// factory Room.fromJson(Map<String, dynamic> json) {
//     List<String> locationList = List<String>.from(json['location']);
//     List<String> imageList = List<String>.from(json['image']);

//     dynamic va = Room(
//       roomType: RoomType.values
//           .firstWhere((type) => type.toString() == json['roomtype']),
//       location: locationList,
//       sex: Sex.values.firstWhere((sex) => sex.toString() == json['sex']),
//       rent: json['rent'],
//       amenities: (json['amenities'] as List<dynamic>)
//           .map((amenity) => Amenities.values
//               .firstWhere((value) => value.toString() == amenity))
//           .toList(),
//       address: json['address'],
//       image: imageList,
//     );
//     print(va);
//     return va;
//   }
// }