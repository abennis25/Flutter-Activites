import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Pour les options de TextInputFormatter

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _adresse = '';
  DateTime _anniversaire = DateTime.now();
  String _cp = '';
  String _password = '';
  // Remove the unused field
  // String _confirmPassword = '';
  String _username = '';
  String _ville = '';
  final List<String> _villes = ['Marseille', 'Nice', 'Toulon', 'Montpellier', 'Avignon', 'Nîmes', 'Perpignan', 'Cannes'];

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance.collection('Utilisateurs').add({
        'adresse': _adresse,
        'anniversaire': Timestamp.fromDate(_anniversaire), // convertir DateTime en Timestamp
        'cp': _cp,
        'isAdmin': false, // les nouveaux utilisateurs ne sont normalement pas des administrateurs
        'password': _password, // Note: En pratique, ne stockez pas de mots de passe en clair.
        'username': _username,
        'ville': _ville,
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("S'inscrire", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nom d'utilisateur",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
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
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    _password = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirmer le mot de passe",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _password) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Adresse",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.home, color: Colors.blue),
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
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.location_city, color: Colors.blue),
                  ),
                  value: _ville.isNotEmpty ? _ville : null,
                  items: _villes.map<DropdownMenuItem<String>>((String ville) {
                    return DropdownMenuItem<String>(
                      value: ville,
                      child: Text(ville),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _ville = newValue ?? '';
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une ville';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Code postal",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.local_post_office, color: Colors.blue),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _registerUser,
                  child: const Text("S'inscrire", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
