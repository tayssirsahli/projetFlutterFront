import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tp70/service/classificationservice.dart';
import 'package:tp70/template/dialog/classificationdialog.dart';
import 'package:tp70/template/navbar.dart';
import 'package:tp70/entities/classification.dart';

class ClassificationScreen extends StatefulWidget {
  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  // Function to refresh the UI after an operation
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Classifications'),
      body: FutureBuilder<List<Classification>>(
        future: getAllClassifications(), // Ensure this now returns Classification data
        builder: (BuildContext context, AsyncSnapshot<List<Classification>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // Get the Classification object at index
                Classification classification = snapshot.data![index];

                return Slidable(
                  key: Key(classification.idClas.toString()),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          // Show edit dialog for the selected classification
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ClassDialog(
                                notifyParent: refresh,
                                classification: classification,
                              );
                            },
                          );
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      // Delete the classification and update the list
                      await deleteClassification(classification.idClas!);
                      setState(() {
                        snapshot.data!.removeAt(index);
                      });
                    }),
                    children: [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Classification: "),
                                Text(
                                  classification.name ?? "N/A", // Display nomClas
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Description: "),
                                Text(
                                  classification.descriptionClas ?? "N/A", // Display descriptionClas
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: const Text('No classifications found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          // Show dialog to add a new classification
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ClassDialog(
                notifyParent: refresh,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
