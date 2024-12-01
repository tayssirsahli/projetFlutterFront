import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../entities/classification.dart';
import '../../service/classificationservice.dart';
import '../../entities/cosmetique.dart';
import '../../service/cosmetiqueservice.dart';

class CosmetiqueDialog extends StatefulWidget {
  final Function? notifyParent;
  final Cosmetique? cosmetique;

  CosmetiqueDialog({this.notifyParent, this.cosmetique});

  @override
  _CosmetiqueDialogState createState() => _CosmetiqueDialogState();
}

class _CosmetiqueDialogState extends State<CosmetiqueDialog> {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController prixCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController classCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String title = "Ajouter Cosmetique";
  bool modif = false;
  late double idCosmetique;
  Classification? selectedClassification;  // Variable to store selected classification

  // A list of classifications to choose from, fetched from your backend
  List<Classification> classifications = [];

  // Method to fetch all classifications from the backend
  Future<void> getAllClassifications() async {
    var response = await http.get(Uri.parse('http://localhost:8081/cosmetiques/api/clas/all'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        classifications = data.map((e) => Classification.fromJson(e)).toList();
        if (widget.cosmetique != null && widget.cosmetique!.classification != null) {
          selectedClassification = widget.cosmetique!.classification;
        }
      });
    }
  }

  // Method to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateCtrl.text = DateFormat("yyyy-MM-dd").format(picked);
        selectedDate = picked;
      });
    }
  }

  // Method to delete a cosmetique
  Future<void> deleteCosmetique(double idCosmetique) async {
    var response = await http.delete(
      Uri.parse('http://localhost:8081/cosmetiques/delcos/$idCosmetique'),
    );
    if (response.statusCode == 200) {
      widget.notifyParent!();
      Navigator.of(context).pop();  // Close the dialog
    } else {
      print('Failed to delete cosmetique');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllClassifications();

    if (widget.cosmetique != null) {
      modif = true;
      title = "Modifier Cosmetique";
      nomCtrl.text = widget.cosmetique!.nomCosmetique!;
      prixCtrl.text = widget.cosmetique!.prixCosmetique!.toString();
      dateCtrl.text = DateFormat("yyyy-MM-dd").format(
          DateTime.parse(widget.cosmetique!.dateCreation.toString()));
      idCosmetique = widget.cosmetique!.idCosmetique!;
      selectedClassification = widget.cosmetique!.classification;  // Set the selected classification
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: nomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nom Cosmetique"),
            ),
            TextFormField(
              controller: prixCtrl,
              keyboardType: TextInputType.number,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Prix Cosmetique"),
            ),
            TextFormField(
              controller: dateCtrl,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Date de création"),
              onTap: () {
                _selectDate(context);
              },
            ),
            // Show dropdown with or without a selected classification based on mode (modif)
            DropdownButtonFormField<Classification>(
              value: modif ? null : selectedClassification, // In modif mode, no value set
              items: classifications.map((Classification classification) {
                return DropdownMenuItem<Classification>(
                  value: classification,
                  child: Text(classification.name ?? 'N/A'),
                );
              }).toList(),
              onChanged: (Classification? newValue) {
                setState(() {
                  selectedClassification = newValue;
                  classCtrl.text = newValue?.name ?? 'N/A';  // Update the text controller
                });
              },
              decoration: const InputDecoration(labelText: 'Classification'),
              validator: (value) {
                if (value == null) {
                  return 'Veuillez sélectionner une classification';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (modif == false) {
                  if (nomCtrl.text.isNotEmpty && prixCtrl.text.isNotEmpty && selectedClassification != null) {
                    await addCosmetique(Cosmetique(
                      nomCosmetique: nomCtrl.text,
                      prixCosmetique: double.tryParse(prixCtrl.text),
                      dateCreation: DateTime.parse(dateCtrl.text),
                      classification: selectedClassification,  // Include classification
                    ));
                    widget.notifyParent!();
                    Navigator.of(context).pop();  // Close the dialog
                  } else {
                    print("Les champs sont incomplets");
                  }
                } else {
                  if (nomCtrl.text.isNotEmpty && prixCtrl.text.isNotEmpty && selectedClassification != null) {
                    await updateCosmetique(Cosmetique(
                      idCosmetique: idCosmetique,
                      nomCosmetique: nomCtrl.text,
                      prixCosmetique: double.tryParse(prixCtrl.text),
                      dateCreation: DateTime.parse(dateCtrl.text),
                      classification: selectedClassification,  // Include classification
                    ));
                    widget.notifyParent!();
                    Navigator.of(context).pop();  // Close the dialog
                  } else {
                    print("Les champs sont incomplets");
                  }
                }
              },
              child: Text(modif ? "Modifier" : "Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}
