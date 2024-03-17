import 'package:activity/cart.dart';
import 'package:activity/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailsactivites.dart';
class ActivitiesPage extends StatefulWidget {
  final String userId;

  const ActivitiesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Toutes'),
    Tab(text: 'Art'),
    Tab(text: 'Sport'),
    Tab(text: 'Ludique'),
    Tab(text: 'Éducation'),
    Tab(text: 'Musique'),
    Tab(text: 'Nature'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités'),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(112.0), // Adjust the height if necessary
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: myTabs,
                indicatorColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String category = tab.text!;
          return StreamBuilder<QuerySnapshot>(
            stream: category == 'Toutes' 
              ? FirebaseFirestore.instance.collection('Activites').snapshots()
              : FirebaseFirestore.instance.collection('Activites').where('Categorie', isEqualTo: category).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.network(
                          data['Image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['Titre']} - ${data['Prix']}€',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('Jaime').where('ActiviteId', isEqualTo: document.id).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  int likesCount = snapshot.data!.docs.length;
                                  return Row(
                                    children: [
                                      Text(
                                        '$likesCount j\'aimes',
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite),
                                        color: Colors.white,
                                        onPressed: () {
                                          // Ajouter le code pour enregistrer le "J'aime" dans la collection "j'aime" de Firebase
                                          FirebaseFirestore.instance.collection('Jaime').add({
                                            'ActiviteId': document.id,
                                            'UserId': widget.userId,
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        color: Colors.white,
                                        onPressed: () {
                                          // Ajouter le code pour naviguer vers la page de détails de l'activité
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ActivitesDetailsPage(userId: widget.userId, activite: document),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(userId: widget.userId),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(userId: widget.userId),
              ),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
