import 'dart:io';

import 'package:youbloom/const/urls.dart';
import 'package:youbloom/models/person.dart';
import 'package:youbloom/services/api_service.dart';

class PeopleRepository {
  Future<PeopleResponse> fetchPeople({
    int page = 1,
    //String? searchQuery,
  }) async {
    final people = <Person>[];
    try {
      final queryParams = {
        "page": page.toString(),
      };
      
      // if (searchQuery != null && searchQuery.isNotEmpty) {
      //   queryParams["search"] = searchQuery;
      // }

      final response = await ApiService.get(
        endPoint: AppUrls.people,
        query: queryParams,
      );

      if (response == null) {
        throw Exception('No response from server');
      }

      try {
        for (var element in (response["results"] as List)) {
          
          people.add(Person.fromJson(element));
        }
        int count = response["count"] as int;
        
        return PeopleResponse(
          count: count, 
          next: response["next"] as String? ?? "", 
          previous: response["previous"] as String? ?? "", 
          results: people
        );
        
      } catch (e) {
        throw Exception('Failed to parse people: ${e.toString()}');
      }
    } on HttpException catch (e) {
      throw Exception('Failed to load people: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}

class PeopleResponse {
  int count;
  String? next;
  String? previous;
  List<Person> results;
  PeopleResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}

