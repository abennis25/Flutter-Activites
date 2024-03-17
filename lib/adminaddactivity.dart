import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddActivity extends StatefulWidget {
  @override
  _AdminAddActivityState createState() => _AdminAddActivityState();
}

class _AdminAddActivityState extends State<AdminAddActivity> {
  final _formKey = GlobalKey<FormState>();
  String _titre = '';
  String _categorie = 'Art';
  String _lieu = '';
  double _prix = 0.0;
  String _image = '';

  void _submitActivity() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Ajouter ici la logique pour envoyer les données à Firestore
      FirebaseFirestore.instance.collection('Activites').add({
        'Titre': _titre,
        'Categorie': _categorie,
        'Lieu': _lieu,
        'Prix': _prix,
        'Image': _image,
      });
      // Ensuite, afficher une notification ou revenir en arrière
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activité ajoutée avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une activité"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
              onSaved: (value) {
                _titre = value!;
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
              value: _categorie,
              items: const [
                DropdownMenuItem(
                  value: 'Art',
                  child: Text('Art'),
                ),
                DropdownMenuItem(
                  value: 'Sport',
                  child: Text('Sport'),
                ),
                DropdownMenuItem(
                  value: 'Éducation',
                  child: Text('Éducation'),
                ),
                DropdownMenuItem(
                  value: 'Ludique',
                  child: Text('Ludique'),
                ),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une catégorie';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _categorie = value!;
                });
              },
              onSaved: (value) {
                _categorie = value!;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un lieu';
                }
                return null;
              },
              onSaved: (value) {
                _lieu = value!;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Prix',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prix';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              },
              onSaved: (value) {
                _prix = double.parse(value!);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une URL d\'image';
                }
                return null;
              },
              onSaved: (value) {
                _image = value!;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitActivity,
              child: Text('Valider'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
