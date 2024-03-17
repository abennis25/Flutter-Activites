import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _username = '';
  String _password = '';
  DateTime _birthday = DateTime.now();
  String _address = '';
  int _postalCode = 0;
  String _city = '';
  String _image = '';
  List<String> _avatars = [
    'https://cdn.iconscout.com/icon/free/png-512/free-avatar-370-456322.png?f=webp&w=256',
    'https://cdn.iconscout.com/icon/free/png-512/free-avatar-372-456324.png?f=webp&w=256',
    'https://cdn.iconscout.com/icon/free/png-512/free-avatar-369-456321.png?f=webp&w=256',
    'https://cdn.iconscout.com/icon/free/png-512/free-avatar-373-456325.png?f=webp&w=256',
    'https://cdn.iconscout.com/icon/free/png-512/free-avatar-367-456319.png?f=webp&w=256'
  ];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Utilisateurs').doc(widget.userId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    setState(() {
      _isLoading = false;
      _username = userData['username'];
      _password = userData['password'];
      _birthday = userData['anniversaire'].toDate();
      _address = userData['adresse'];
      _postalCode = userData['cp'];
      _city = userData['ville'];
      _image = userData['image'] ?? _avatars[0];
    });
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance.collection('Utilisateurs').doc(widget.userId).update({
        'anniversaire': _birthday,
        'adresse': _address,
        'cp': _postalCode,
        'ville': _city,
        'password': _password,
        'username': _username,
        'image': _image,
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  Widget _buildAvatarPicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _avatars.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _image = _avatars[index];
            });
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                color: _image == _avatars[index] ? Colors.blue : Colors.grey[300]!,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_avatars[index]),
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de l\'utilisateur'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text("Sélectionnez votre avatar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      _buildAvatarPicker(),
                      SizedBox(height: 20),
                      _buildTextField("Nom d'utilisateur", _username, readOnly: true),
                      _buildTextField("Mot de passe", _password, isPassword: true),
                      _buildTextField("Adresse", _address),
                      _buildTextField("Code Postal", _postalCode.toString(), isNumeric: true),
                      _buildTextField("Ville", _city),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                        onPressed: _updateUserInfo,
                        child: Text('Mettre à jour'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text('Se déconnecter'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool isPassword = false, bool readOnly = false, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        obscureText: isPassword,
        readOnly: readOnly,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        onSaved: (newValue) {
          switch (label) {
            case "Nom d'utilisateur":
              _username = newValue!;
              break;
            case "Mot de passe":
              _password = newValue!;
              break;
            case "Adresse":
              _address = newValue!;
              break;
            case "Code Postal":
              _postalCode = int.tryParse(newValue!) ?? 0;
              break;
            case "Ville":
              _city = newValue!;
              break;
          }
        },
      ),
    );
  }
}
