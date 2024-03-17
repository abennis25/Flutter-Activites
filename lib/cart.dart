import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  final String userId;
  
  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
Future<List<Map<String, dynamic>>> _getCartItems() async {
  List<Map<String, dynamic>> cartItems = [];
  
  QuerySnapshot userCart = await FirebaseFirestore.instance
      .collection('Panier')
      .where('UserId', isEqualTo: widget.userId)
      .get();

  for (var cartItem in userCart.docs) {
    String activityId = cartItem['ActiviteId'];
    int quantity = cartItem['Quantite'];

    DocumentSnapshot activitySnapshot = await FirebaseFirestore.instance.collection('Activites').doc(activityId).get();
    Map<String, dynamic> activityData = activitySnapshot.data() as Map<String, dynamic>;

    cartItems.add({
      'id': cartItem.id,
      'Quantite': quantity,
      ...activityData,
    });
  }

  return cartItems;
}

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId').toString();
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          } else {
            final items = snapshot.data!;
          double total = items.fold(0, (sum, item) => sum + (item['Prix'] * item['Quantite']));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = items[index];
                      return ListTile(
                        leading: Image.network(item['Image']),
                        title: Text(item['Titre']),
                        subtitle: Text("${item['Lieu']} - ${item['Prix']}€ x ${item['Quantite']}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('Panier').doc(item['id']).delete().then((_) => setState(() {}));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Total: $total€', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
