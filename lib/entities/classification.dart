class Classification {
  double? idClas;
  String? name;
  String? descriptionClas;

  Classification({this.idClas, this.name, this.descriptionClas});

  // Factory method to create a Classification from JSON
  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      idClas: json['idClas'],  // Mapping idClas from the 'classification' object
      name: json['nomClas'],  // Mapping nomClas
      descriptionClas: json['descriptionClas'],  // Mapping descriptionClas
    );
  }

  // Optional: toJson method if you need to convert Classification back to JSON
  Map<String, dynamic> toJson() {
    return {
      'idClas': idClas,
      'nomClas': name,
      'descriptionClas': descriptionClas,
    };
  }
}
