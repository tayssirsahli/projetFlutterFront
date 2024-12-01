import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tp70/entities/cosmetique.dart';
import 'package:tp70/entities/classification.dart';


  final String baseUrl = "http://localhost:8081/cosmetiques"; // Base URL for the API

Future<List<Cosmetique>> getAllCosmetiques() async {
  final response = await http.get(Uri.parse("$baseUrl/api/all"));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Cosmetique.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load cosmetiques');
  }
}






Future<String> addCosmetique(Cosmetique cosmetique) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/addcos"),
    headers: {"Content-type": "application/json"},
    body: jsonEncode(<String, dynamic>{
      "nomCosmetique": cosmetique.nomCosmetique ?? "Unknown",
      "prixCosmetique": cosmetique.prixCosmetique?.toString() ?? "0.0",
      "dateCreation": DateFormat("yyyy-MM-dd").format(cosmetique.dateCreation ?? DateTime.now()),
      "classification": {
        "idClas": cosmetique.classification?.idClas // Add classification ID here
      } // Send classification ID if selected
    }),
  );
  return response.body;
}

Future<String> updateCosmetique(Cosmetique cosmetique) async {
  final response = await http.put(
    Uri.parse("$baseUrl/api/updatecos"),
    headers: {"Content-type": "application/json"},
    body: jsonEncode(<String, dynamic>{
      "idCosmetique": cosmetique.idCosmetique,
      "nomCosmetique": cosmetique.nomCosmetique ?? "Unknown",
      "prixCosmetique": cosmetique.prixCosmetique?.toString() ?? "0.0",
      "dateCreation": DateFormat("yyyy-MM-dd").format(cosmetique.dateCreation ?? DateTime.now()),
      "classification": {
        "idClas": cosmetique.classification?.idClas
      }
    }),
  );
  return response.body;
}


  // Delete a cosmetic by ID
  Future<void> deleteCosmetique(int id) async {
    await http.delete(Uri.parse("$baseUrl/api/delcos/?id=$id"));
  }

  // Get all classifications
  Future<List<Classification>> getClassifications() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/clas/all"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Classification.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load classifications");
      }
    } catch (e) {
      throw Exception("Error fetching classifications: $e");
    }
  }


  // Add a new classification
  Future<String> addClassification(Classification classification) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/clas/add"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "name": classification.name,
        "descriptionClas": classification.descriptionClas,
      }),
    );
    return response.body;
  }

  // Update an existing classification
  Future<String> updateClassification(Classification classification) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/clas/update"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        "idClas": classification.idClas,
        "name": classification.name,
      }),
    );
    return response.body;
  }

  // Delete a classification by ID
  Future<void> deleteClassification(int idClas) async {
    await http.delete(Uri.parse("$baseUrl/api/clas/delete/?idClas=$idClas"));
  }

