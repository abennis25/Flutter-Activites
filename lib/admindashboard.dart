import 'package:activity/adminaddactivity.dart';
import 'package:activity/adminadduser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _numberOfActivities = 0;
  int _numberOfUsers = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final activitiesSnapshot = await FirebaseFirestore.instance.collection('activities').get();
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    
    setState(() {
      _numberOfActivities = activitiesSnapshot.docs.length;
      _numberOfUsers = usersSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord Administrateur"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Nombre d'activités", style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 10),
                      Text("$_numberOfActivities", style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Nombre d'utilisateurs", style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 10),
                      Text("$_numberOfUsers", style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.green)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // double.infinity is the width and 50 is the height
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminAddActivity()));
                },
                child: Text("Ajouter Activité"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  primary: Colors.green, // Button color
                  onPrimary: Colors.white, // Text color
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminAddUser()));
                },
                child: Text("Ajouter Utilisateur"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
