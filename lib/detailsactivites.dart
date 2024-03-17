import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart.dart';

class ActivitesDetailsPage extends StatefulWidget {
  final DocumentSnapshot activite;
  final String userId ;

  ActivitesDetailsPage({required this.activite, required this.userId});

  @override
  _ActivitesDetailsPageState createState() => _ActivitesDetailsPageState();
}

class _ActivitesDetailsPageState extends State<ActivitesDetailsPage> {
  Future<void> addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String activiteId = widget.activite.id;
    
    // Check if a similar document exists in the collection
    QuerySnapshot similarDocs = await FirebaseFirestore.instance
        .collection('Panier')
        .where('UserId', isEqualTo: userId)
        .where('ActiviteId', isEqualTo: activiteId)
        .get();
    print (similarDocs.docs);
    if (similarDocs.docs.isNotEmpty) {
      // Increment the quantity by 1
      DocumentSnapshot similarDoc = similarDocs.docs.first;
      int currentQuantity = similarDoc['Quantite'];
      await similarDoc.reference.update({'Quantite': currentQuantity + 1});
    } else {
      // Add a new document with quantity 1
      await FirebaseFirestore.instance
          .collection('Panier')
          .add({'UserId': userId, 'ActiviteId': activiteId, 'Quantite': 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.activite.data()! as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['Titre']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(data['Image']),
            Text(data['Titre'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Lieu: ${data['Lieu']}'),
            Text('Nombre de personnes minimum: ${data['Nb_personnes_min']}'),
            Text('Quantité : ${data['Quantite']}'), 
            Text('Prix: ${data['Prix']}€'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addToCart();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(
                    userId: widget.userId,
                  )),
                );
              },
              child: Text('Ajouter au panier'),
            ),
          ],
        ),
      ),
    );
  }
}