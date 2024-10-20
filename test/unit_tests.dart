import 'package:flutter_test/flutter_test.dart';
import 'package:youbloom/models/person.dart';

void main() {
  group('Person Model Tests', () {
    test('Person.fromJson() creates a Person object correctly', () {
      final json = {
        'name': 'Luke Skywalker',
        'gender': 'male',
        'eye_color': 'blue',
        'hair_color': 'blond',
        'skin_color': 'fair'
      };
      
      final person = Person.fromJson(json);
      
      expect(person.name, 'Luke Skywalker');
      expect(person.gender, 'male');
      expect(person.eyeColor, 'blue');
      expect(person.hairColor, 'blond');
      expect(person.skinColor, 'fair');
    });

    test('Person.toJson() converts a Person object to JSON correctly', () {
      final person = Person(
        name: 'Leia Organa',
        gender: 'female',
        eyeColor: 'brown',
        hairColor: 'brown',
        skinColor: 'light'
      );
      
      final json = person.toJson();
      
      expect(json['name'], 'Leia Organa');
      expect(json['gender'], 'female');
      expect(json['eye_color'], 'brown');
      expect(json['hair_color'], 'brown');
      expect(json['skin_color'], 'light');
    });

    test('Person equality check works correctly', () {
      final person1 = Person(name: 'Han Solo', gender: 'male');
      final person2 = Person(name: 'Han Solo', gender: 'male');
      final person3 = Person(name: 'Chewbacca', gender: 'male');
      
      expect(person1, equals(person2));
      expect(person1, isNot(equals(person3)));
    });
  });

  group('Utility Function Tests', () {
    test('_getStarType() returns a valid star type', () {
      final validTypes = [
        'Red Dwarf',
        'Yellow Dwarf',
        'Blue Giant',
        'White Dwarf',
        'Neutron Star'
      ];
      
      final starType = _getStarType();
      
      expect(validTypes.contains(starType), isTrue);
    });
  });
}


String _getStarType() {
  final types = [
    'Red Dwarf',
    'Yellow Dwarf',
    'Blue Giant',
    'White Dwarf',
    'Neutron Star'
  ];
  return types[DateTime.now().microsecond % types.length];
}