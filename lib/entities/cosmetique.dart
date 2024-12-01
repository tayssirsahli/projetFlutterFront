import 'package:tp70/entities/classification.dart';

class Cosmetique {
  double? idCosmetique;
  String? nomCosmetique;
  double? prixCosmetique;
  DateTime? dateCreation;
  Classification? classification;

  Cosmetique({this.idCosmetique, this.nomCosmetique, this.prixCosmetique, this.dateCreation, this.classification});

  factory Cosmetique.fromJson(Map<String, dynamic> json) {
    return Cosmetique(
      idCosmetique: json['idCosmetique'],
      nomCosmetique: json['nomCosmetique'],
      prixCosmetique: json['prixCosmetique'],
      dateCreation: DateTime.parse(json['dateCreation']),  // Ensure proper DateTime parsing
      classification: json['classification'] != null
          ? Classification.fromJson(json['classification'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCosmetique': idCosmetique,
      'nomCosmetique': nomCosmetique,
      'prixCosmetique': prixCosmetique,
      'dateCreation': dateCreation?.toIso8601String(), // Convert DateTime to string
      'classification': classification?.toJson(),
    };
  }

}
