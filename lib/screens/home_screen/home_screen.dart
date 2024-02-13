import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisouq/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'customer_screen';
  // Function to handle user sign-out
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to LoginScreen after signing out
    Navigator.of(context).pushReplacementNamed(AppRoutes.signInScreen); // Use the route from AppRoutes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uni-Souq'),
        actions: [
          IconButton(icon: Icon(Icons.location_on), onPressed: () {}),
          IconButton(icon: Icon(Icons.category), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          // Example item data
          final item = {
            'name': ['Shirt', 'Pant', 'Watch', 'Shoes'][index],
            'price': ['40.5', '35.5', '120', '80'][index],
            'location': ['Medina Market', 'Pathanville', 'Downtown', 'City Center'][index],
            'isNew': [true, false, false, true][index],
            'discount': [null, null, '35% OFF', null][index],
          };

          return Card(
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // Placeholder for images
                    color: Theme.of(context).hoverColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['isNew'] as bool)
                        Text('New', style: TextStyle(color: Theme.of(context).primaryColor)),
                      Text(item['name'] as String, style: Theme.of(context).textTheme.bodyText1),
                      Text('\$ ${item['price']}', style: Theme.of(context).textTheme.bodyText2),
                      Text(item['location'] as String, style: Theme.of(context).textTheme.bodyText2),
                      if (item['discount'] != null)
                        Text(item['discount'] as String, style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            SizedBox(width: 48), // The middle part is for the floating button
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
