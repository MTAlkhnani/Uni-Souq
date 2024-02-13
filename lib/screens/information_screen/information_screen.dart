import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/custom_icon_button.dart';
import 'package:unisouq/components/custom_image_view.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/customer_screen.dart';
import 'package:unisouq/screens/home_screen/home_screen.dart';
import 'package:unisouq/utils/file_upload_helper.dart';

import 'package:unisouq/utils/navigator_service.dart';
import 'package:unisouq/utils/permission_manager.dart';
import 'package:unisouq/utils/size_utils.dart';

import 'notifier/information_notifier.dart';
import 'package:flutter/material.dart';

class InformationScreen extends ConsumerStatefulWidget {
  static const String id = 'information_screen';
  const InformationScreen({Key? key}) : super(key: key);

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends ConsumerState<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.v),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 17.h,
              ),
              const Text(
                "Edit profile",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                  height: 105.v,
                  width: 92.h,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    CustomImageView(
                        imagePath: "assets/images/image_not_found.png",
                        height: 91.v,
                        width: 92.h,
                        radius: BorderRadius.circular(46.h),
                        alignment: Alignment.topCenter),
                    CustomIconButton(
                        height: 30.adaptSize,
                        width: 30.adaptSize,
                        padding: EdgeInsets.all(7.h),
                        decoration:
                            IconButtonStyleHelper.getOutlineWhiteA(context),
                        alignment: Alignment.bottomRight,
                        onTap: () {
                          onTapBtnIcon(context);
                        },
                        child: CustomImageView(
                            imagePath:
                                "assets/images/edit-button-svgrepo-com.svg"))
                  ])),
              SizedBox(height: 10.v),
              const Text(
                "full name",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 1.v),
              const Text(
                "fmsdf@gmail.com",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 18.v),
              _buildInputFieldWithName(context),
              SizedBox(height: 19.v),
              _buildInputFieldWithAddress(context),
              SizedBox(height: 19.v),
              _buildInputFieldWithMobileNumber(context),
              SizedBox(height: 50.v),
              _buildCompleteButton(context)
            ]),
          )),
    );
  }

  /// Section Widget
  Widget _buildInputFieldWithName(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: const Text("Account Name",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16
                // Customize text color here
                )),
      ),
      SizedBox(height: 8.v),
      Consumer(builder: (context, ref, _) {
        return MyTextField(
          controller: ref.watch(informationNotifier).nameController,
          hintText: "full name ",
          keyboardType: TextInputType.text,
        );
      })
    ]);
  }

  /// Section Widget
  Widget _buildInputFieldWithAddress(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: const Text("Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16
                // Customize text color here
                )),
      ),
      SizedBox(height: 8.v),
      Consumer(builder: (context, ref, _) {
        return MyTextField(
          controller: ref.watch(informationNotifier).addressController,
          hintText: "new_south_wales",
          keyboardType: TextInputType.streetAddress,
        );
      })
    ]);
  }

  /// Section Widget
  Widget _buildInputFieldWithMobileNumber(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: const Text("Mobile Number",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // Customize text color here
                fontSize: 16)),
      ),
      SizedBox(height: 8.v),
      Consumer(builder: (context, ref, _) {
        return MyTextField(
          controller: ref.watch(informationNotifier).mobileNumberController,
          hintText: "9999_999_999",
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
        );
      })
    ]);
  }

  /// Section Widget
  Widget _buildCompleteButton(BuildContext context) {
    return RoundedButton(
      text: "Complate",
      press: () {
        onTapCompleteButton(context);
      },
      color: Theme.of(context).primaryColor,
    );
  }

  /// Requests permission to access the camera and storage, and displays a model
  /// sheet for selecting images.
  ///
  /// Throws an error if permission is denied or an error occurs while selecting images.
  onTapBtnIcon(BuildContext context) async {
    try {
      // Request camera permission
      final cameraPermissionStatus = await Permission.camera.request();
      if (cameraPermissionStatus != PermissionStatus.granted) {
        throw Exception('Camera permission is required to select images.');
      }

      // Request storage permission
      final storagePermissionStatus = await Permission.storage.request();
      if (storagePermissionStatus != PermissionStatus.granted) {
        throw Exception('Storage permission is required to select images.');
      }

      // Show model sheet for selecting images
      await FileManager().showModelSheetForImage(
        getImages: (value) async {
          // Handle selected images here
        },
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// Navigates to the homeContainerScreen when the action is triggered.
  onTapCompleteButton(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.id);
  }
}
