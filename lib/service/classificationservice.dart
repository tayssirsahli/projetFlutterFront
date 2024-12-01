import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tp70/entities/classification.dart';

Future<List<Classification>> getAllClassifications() async {
  Response response = await http.get(Uri.parse("http://localhost:8081/cosmetiques/api/clas/all"));

  if (response.statusCode == 200) {
    // Parse the response body into a List of Classification objects
    List<dynamic> data = jsonDecode(response.body);

    // Mapper directement chaque élément de la liste en un objet Classification
    return data.map((item) {
      return Classification.fromJson(item); // Utiliser le JSON directement
    }).toList();
  } else {
    throw Exception('Failed to load classifications');
  }
}



Future deleteClassification(double idClas) async {
  final response = await http.delete(
    Uri.parse("http://localhost:8081/cosmetiques/api/clas/delete/$idClas"),
  );

  if (response.statusCode == 200) {
    // Successfully deleted
    print('Classification deleted');
  } else {
    // Failed to delete
    print('Failed to delete classification');
  }
}


Future addClassification(Classification classification) async {
  Response response = await http.post(
    Uri.parse("http://localhost:8081/cosmetiques/api/clas/add"),
    headers: {"Content-type": "Application/json"},
    body: jsonEncode(<String, dynamic>{
      "nomClas": classification.name,   // Ensure this field matches the backend
      "descriptionClas": classification.descriptionClas,  // Include descriptionClas here
    }),
  );

  if (response.statusCode == 200) {
    print("Successfully added classification");
  } else {
    print("Failed to add classification: ${response.body}");
  }

  return response.body;
}


Future updateClassification(Classification classification) async {
  Response response = await http.put(
    Uri.parse("http://172.20.10.2:8081/cosmetiques/api/clas/update"),
    headers: {"Content-type": "Application/json"},
    body: jsonEncode(<String, dynamic>{
      "idClas": classification.idClas, // Backend expects idClas for update
      "nomClas": classification.name,
      "descriptionClas": classification.descriptionClas,
    }),
  );

  return response.body;
}
