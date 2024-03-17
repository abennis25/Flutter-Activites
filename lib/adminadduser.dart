import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Pour les options de TextInputFormatter

class AdminAddUser extends StatefulWidget {
  @override
  _AdminAddUserState createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  final _formKey = GlobalKey<FormState>();
  String _adresse = '';
  DateTime _anniversaire = DateTime.now();
  String _cp = '';
  bool _isAdmin = false;
  String _password = '';
  String _username = '';
  String _ville = '';
  final List<String> _villes = ['Marseille', 'Nice', 'Toulon', 'Montpellier', 'Avignon', 'Nîmes', 'Perpignan', 'Cannes'];

  void _submitUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Ajouter ici la logique pour envoyer les données à Firestore
      FirebaseFirestore.instance.collection('Utilisateurs').add({
        'adresse': _adresse,
        'anniversaire': _anniversaire,
        'cp': _cp,
        'isAdmin': _isAdmin,
        'password': _password,  // Attention: stocker les mots de passe en clair n'est pas sécurisé.
        'username': _username,
        'ville': _ville,
      });
      // Ensuite, afficher une notification ou revenir en arrière
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur ajouté avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un utilisateur"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom d\'utilisateur';
                }
                return null;
              },
              onSaved: (value) {
                _username = value!;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une adresse';
                }
                return null;
              },
              onSaved: (value) {
                _adresse = value!;
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Ville',
                border: OutlineInputBorder(),
              ),
              value: _ville.isNotEmpty ? _ville : null, // Assurez-vous que _ville est une valeur valide ou null.
              items: _villes.map<DropdownMenuItem<String>>((String ville) {
                return DropdownMenuItem<String>(
                  value: ville,
                  child: Text(ville),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _ville = newValue ?? ''; // Assurez-vous de gérer la valeur null correctement.
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une ville';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Code postal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un code postal';
                }
                return null;
              },
              onSaved: (value) {
                _cp = value!;
              },
            ),
            SizedBox(height: 16.0),
            // Date de naissance - considérer l'ajout d'un sélecteur de date
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Anniversaire (AAAA-MM-JJ)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une date d\'anniversaire';
                }
                return null;
              },
              onSaved: (value) {
                _anniversaire = DateTime.parse(value!);
              },
            ),
            SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('Est administrateur'),
              value: _isAdmin,
              onChanged: (bool value) { setState(() { _isAdmin = value; }); },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitUser,
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
