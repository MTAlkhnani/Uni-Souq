import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisouq/components/adavtive_dailog.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/add_product/add_product.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'customer_screen';
  // Function to handle user sign-out
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to SignInScreen after signing out
    Navigator.popAndPushNamed(context, AppRoutes.signInScreen);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.signInScreen, (route) => false);

    // Clear the navigation stack so that the user can't navigate back to HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uni-Souq'),
        actions: [
          IconButton(icon: Icon(Icons.location_on), onPressed: () {}),
          IconButton(icon: Icon(Icons.category), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MyDialog(
                    title: "Sign Out",
                    content: "Are you sure you want to sign out?",
                    cancelText: "Cancel",
                    signOutText: " Sign Out",
                    titleTextStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    contentTextStyle: const TextStyle(fontSize: 16),
                    buttonTextStyle: const TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 165, 53, 46)),
                  );
                },
              )
            },
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
            'location': [
              'Medina Market',
              'Pathanville',
              'Downtown',
              'City Center'
            ][index],
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
                        Text('New',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      Text(item['name'] as String,
                          style: Theme.of(context).textTheme.bodyText1),
                      Text('\$ ${item['price']}',
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(item['location'] as String,
                          style: Theme.of(context).textTheme.bodyText2),
                      if (item['discount'] != null)
                        Text(item['discount'] as String,
                            style: TextStyle(color: Colors.red)),
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
        onPressed: () {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const RegistrationScreen()),
            );
            return;
          }
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => AddProductScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
