import 'package:flutter/material.dart';
import 'package:tp70/entities/classification.dart';
import 'package:tp70/service/classificationservice.dart';

class ClassDialog extends StatefulWidget {
  final Function()? notifyParent;
  final Classification? classification;

  ClassDialog({super.key, required this.notifyParent, this.classification});

  @override
  _ClassDialogState createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController descriptionCtrl;
  String title = "Ajouter Classification";
  bool isEditMode = false;
  late double idClassification;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    descriptionCtrl = TextEditingController();

    if (widget.classification != null) {
      isEditMode = true;
      title = "Modifier Classification";
      nameCtrl.text = widget.classification!.name!;
      descriptionCtrl.text = widget.classification!.descriptionClas ?? '';
      idClassification = widget.classification!.idClas!;
    }
  }

  bool isValidForm() {
    return nameCtrl.text.isNotEmpty;
  }

  Future<void> _submitForm() async {
    if (!isValidForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le nom est obligatoire")),
      );
      return;
    }

    final classification = Classification(
      idClas: isEditMode ? idClassification : null,
      name: nameCtrl.text,
      descriptionClas: descriptionCtrl.text.isEmpty ? null : descriptionCtrl.text,
    );

    if (isEditMode) {
      await updateClassification(classification);
    } else {
      await addClassification(classification);
    }

    widget.notifyParent!();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 10),
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (value) => value!.isEmpty ? "Le nom est obligatoire" : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEditMode ? "Modifier" : "Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}
