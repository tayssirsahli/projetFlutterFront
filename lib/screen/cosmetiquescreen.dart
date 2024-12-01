import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/cosmetique.dart';
import 'package:tp70/service/cosmetiqueservice.dart';
import 'package:tp70/template/navbar.dart';
import '../template/dialog/cosmetiquedialog.dart';

class CosmetiqueScreen extends StatefulWidget {
  @override
  _CosmetiqueScreenState createState() => _CosmetiqueScreenState();
}

class _CosmetiqueScreenState extends State<CosmetiqueScreen> {
  double _currentFontSize = 0;
  TextEditingController _searchController = TextEditingController();
  List<Cosmetique> _filteredCosmetiques = [];
  List<Cosmetique> _allCosmetiques = [];

  // Refresh method to reload the data
  refresh() {
    setState(() {});
  }

  // Search method to filter the cosmetiques list
  void _filterCosmetiques() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCosmetiques = _allCosmetiques
          .where((cosmetique) =>
          cosmetique.nomCosmetique!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Cosmetiques'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterCosmetiques(),
              decoration: InputDecoration(
                labelText: 'Search Cosmetique',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cosmetique>>(
              future: getAllCosmetiques(),
              builder: (BuildContext context, AsyncSnapshot<List<Cosmetique>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('An error occurred!'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No cosmetiques available.'));
                }

                // Set all cosmetiques when the data is loaded for the first time
                if (_allCosmetiques.isEmpty) {
                  _allCosmetiques = snapshot.data!;
                  _filteredCosmetiques = _allCosmetiques;
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredCosmetiques.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cosmetique = _filteredCosmetiques[index];

                    return Slidable(
                      key: Key(cosmetique.idCosmetique.toString()),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CosmetiqueDialog(
                                    notifyParent: refresh,
                                    cosmetique: cosmetique,
                                  );
                                },
                              );
                            },
                            backgroundColor: Colors.blueAccent,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () async {
                          await deleteCosmetique(cosmetique.idCosmetique!.toInt());
                          setState(() {
                            _filteredCosmetiques.removeAt(index);
                          });
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListTile(
                            title: Text(
                              cosmetique.nomCosmetique!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Prix : ${cosmetique.prixCosmetique} dt'),
                                Text(
                                  'Date de création: ${DateFormat("dd-MM-yyyy").format(cosmetique.dateCreation!)}',
                                ),
                                Text(
                                  'Classification: ${cosmetique.classification != null ? cosmetique.classification!.name : "N/A"}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CosmetiqueDialog(
                notifyParent: refresh,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
