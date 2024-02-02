import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lottie/lottie.dart';
// import 'package:another_stepper/another_stepper.dart' as step;
// import '../components/app_drawer.dart';
// import '../components/in_transit_path.dart';
// import '../components/package_information.dart';
// import '../models/package.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class CustomerScreen extends StatefulWidget {
  static const String id = 'customer_screen';

  const CustomerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  // PackageData? packageData;
  // List<step.StepperData> steps = [
  //   step.StepperData(
  //     title: step.StepperText(
  //       "Order Phjf",
  //       textStyle: const TextStyle(
  //         color: Colors.grey,
  //       ),
  //     ),
  //     subtitle: step.StepperText("Your order has been placed"),
  //     iconWidget: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: const BoxDecoration(
  //           color: Colors.red,
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       child: const Icon(Icons.navigate_next_sharp, color: Colors.white),
  //     ),
  //   ),
  //   step.StepperData(
  //     title: step.StepperText(
  //       "Order Placed",
  //       textStyle: const TextStyle(
  //         color: Colors.grey,
  //       ),
  //     ),
  //     subtitle: step.StepperText("Your order has been placed"),
  //     iconWidget: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: const BoxDecoration(
  //           color: Colors.red,
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       child: const Icon(Icons.navigate_next_sharp, color: Colors.white),
  //     ),
  //   ),
  //   step.StepperData(
  //     title: step.StepperText(
  //       "Order Placed",
  //       textStyle: const TextStyle(
  //         color: Colors.grey,
  //       ),
  //     ),
  //     subtitle: step.StepperText("Your order has been placed"),
  //     iconWidget: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: const BoxDecoration(
  //           color: Colors.red,
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       child: const Icon(Icons.navigate_next_sharp, color: Colors.white),
  //     ),
  //   ),
  //   step.StepperData(
  //     title: step.StepperText(
  //       "Order Placed",
  //       textStyle: const TextStyle(
  //         color: Colors.grey,
  //       ),
  //     ),
  //     subtitle: step.StepperText("Your order has been placed"),
  //     iconWidget: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: const BoxDecoration(
  //           color: Colors.red,
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       child: const Icon(Icons.navigate_next_sharp, color: Colors.white),
  //     ),
  //   ),
  // ];
  @override
  void initState() {
    super.initState();
  }

  void getPackage(int packageID) async {
    User user = FirebaseAuth.instance.currentUser!;
    final instance = FirebaseFirestore.instance;
    var package = instance
        .collection('packages')
        .where('PackageID', isEqualTo: packageID)
        .where('CustomerEmail', isEqualTo: user.email);

    await package.get().then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          // packageData = null;
        });
        return;
      }

      var firebasePackge = value.docs.first;
      setState(() {
        // packageData = PackageData(
        //     firebasePackge.get('Cost'),
        //     firebasePackge.get('CustomerEmail'),
        //     firebasePackge.get('Destination'),
        //     firebasePackge.get('Dimension'),
        //     firebasePackge.get('FDD'),
        //     firebasePackge.get('Insurance'),
        //     firebasePackge.get('PackageID'),
        //     firebasePackge.get('Status'),
        //     firebasePackge.get('Type'),
        //     firebasePackge.get('Weight'),
        //     firebasePackge.get('LocatedAt'),
        //     firebasePackge.get('ArrivalDate'));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('WPMS'),
        backgroundColor: const Color.fromRGBO(0, 0, 139, 1),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  child: const Text(
                    "Track Your Shipment Now!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(0, 0, 139, 1),
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'e.g. #12345678'),
                  onSubmitted: (value) {
                    if (int.tryParse(value) != null) {
                      getPackage(int.parse(value));
                    } else {
                      setState(() {
                        // packageData = null;
                      });
                    }
                  },
                ),
              ),
            ),
            // if (packageData != null)
            //   PackageInformation(packageData: packageData!),
            // if (packageData != null) InTransitPath(packageData: packageData!),
            // if (packageData == null)
            //   Lottie.network(
            //       'https://assets2.lottiefiles.com/packages/lf20_t24tpvcu.json'),
          ],
        ),
      ),
    );
  }
}
