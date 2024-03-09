// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  // skipped getter for the 'onboard page ' key

  /// `Just browsing?`
  String get Justbrowsing {
    return Intl.message(
      'Just browsing?',
      name: 'Justbrowsing',
      desc: '',
      args: [],
    );
  }

  /// `Continue as a Guest`
  String get Guest {
    return Intl.message(
      'Continue as a Guest',
      name: 'Guest',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get Skip {
    return Intl.message(
      'Skip',
      name: 'Skip',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get GetStarted {
    return Intl.message(
      'Get Started',
      name: 'GetStarted',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'sign-u' key

  /// `Hello There!`
  String get HelleThere {
    return Intl.message(
      'Hello There!',
      name: 'HelleThere',
      desc: '',
      args: [],
    );
  }

  /// `Register below with your detail`
  String get reg {
    return Intl.message(
      'Register below with your detail',
      name: 'reg',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get hint {
    return Intl.message(
      'First Name',
      name: 'hint',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in this field`
  String get if1 {
    return Intl.message(
      'Please fill in this field',
      name: 'if1',
      desc: '',
      args: [],
    );
  }

  /// `Name too long`
  String get if_else1 {
    return Intl.message(
      'Name too long',
      name: 'if_else1',
      desc: '',
      args: [],
    );
  }

  /// `Name too short`
  String get if_else2 {
    return Intl.message(
      'Name too short',
      name: 'if_else2',
      desc: '',
      args: [],
    );
  }

  /// ` Last Name`
  String get hintL {
    return Intl.message(
      ' Last Name',
      name: 'hintL',
      desc: '',
      args: [],
    );
  }

  /// `05xxxxxxxx`
  String get hintn {
    return Intl.message(
      '05xxxxxxxx',
      name: 'hintn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number.`
  String get numv {
    return Intl.message(
      'Please enter a valid phone number.',
      name: 'numv',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number.`
  String get emailv {
    return Intl.message(
      'Please enter a valid phone number.',
      name: 'emailv',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get pass {
    return Intl.message(
      'Password',
      name: 'pass',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid password`
  String get passv {
    return Intl.message(
      'Please enter a valid password',
      name: 'passv',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sginup {
    return Intl.message(
      'Sign Up',
      name: 'sginup',
      desc: '',
      args: [],
    );
  }

  /// `I am a member!`
  String get member {
    return Intl.message(
      'I am a member!',
      name: 'member',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get login {
    return Intl.message(
      'Login now',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Account Created Succussfully`
  String get succmassage {
    return Intl.message(
      'Account Created Succussfully',
      name: 'succmassage',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please check your credentials!`
  String get massage {
    return Intl.message(
      'An error occurred, please check your credentials!',
      name: 'massage',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'sign-on' key

  /// `Login Succussfully`
  String get loginsucc {
    return Intl.message(
      'Login Succussfully',
      name: 'loginsucc',
      desc: '',
      args: [],
    );
  }

  /// `Transforming Campus Life`
  String get trans {
    return Intl.message(
      'Transforming Campus Life',
      name: 'trans',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back, you've been missed!`
  String get welcome {
    return Intl.message(
      'Welcome back, you\'ve been missed!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get REMMBER {
    return Intl.message(
      'Remember me',
      name: 'REMMBER',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get passforget {
    return Intl.message(
      'Forgot password?',
      name: 'passforget',
      desc: '',
      args: [],
    );
  }

  /// `Not a member? `
  String get notmember {
    return Intl.message(
      'Not a member? ',
      name: 'notmember',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get regsternow {
    return Intl.message(
      'Register now',
      name: 'regsternow',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'home-s' key

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `All Items`
  String get popularCategories1 {
    return Intl.message(
      'All Items',
      name: 'popularCategories1',
      desc: '',
      args: [],
    );
  }

  /// `Electronics`
  String get popularCategories2 {
    return Intl.message(
      'Electronics',
      name: 'popularCategories2',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get popularCategories3 {
    return Intl.message(
      'Clothing',
      name: 'popularCategories3',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get popularCategories4 {
    return Intl.message(
      'Books',
      name: 'popularCategories4',
      desc: '',
      args: [],
    );
  }

  /// `Furniture`
  String get popularCategories5 {
    return Intl.message(
      'Furniture',
      name: 'popularCategories5',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get popularCategories6 {
    return Intl.message(
      'Home',
      name: 'popularCategories6',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get Categories {
    return Intl.message(
      'Categories',
      name: 'Categories',
      desc: '',
      args: [],
    );
  }

  /// `No items found.`
  String get Noitemsfound {
    return Intl.message(
      'No items found.',
      name: 'Noitemsfound',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get search {
    return Intl.message(
      'search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get Order {
    return Intl.message(
      'Order',
      name: 'Order',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Required`
  String get SignInRequired {
    return Intl.message(
      'Sign In Required',
      name: 'SignInRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in or sign up to access this feature.`
  String get maslog {
    return Intl.message(
      'Please sign in or sign up to access this feature.',
      name: 'maslog',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get SignIn {
    return Intl.message(
      'Sign In',
      name: 'SignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message(
      'Sign Up',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `information_screen`
  String get information {
    return Intl.message(
      'information_screen',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get Editprofile {
    return Intl.message(
      'Edit profile',
      name: 'Editprofile',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get AccountName {
    return Intl.message(
      'Account Name',
      name: 'AccountName',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get FullName {
    return Intl.message(
      'Full Name',
      name: 'FullName',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get MobileNumber {
    return Intl.message(
      'Mobile Number',
      name: 'MobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get University {
    return Intl.message(
      'University',
      name: 'University',
      desc: '',
      args: [],
    );
  }

  /// `Select University`
  String get SelectUniversity {
    return Intl.message(
      'Select University',
      name: 'SelectUniversity',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get Address {
    return Intl.message(
      'Address',
      name: 'Address',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get Complete {
    return Intl.message(
      'Complete',
      name: 'Complete',
      desc: '',
      args: [],
    );
  }

  /// `Pick Profile Picture`
  String get PickProfilePicturec {
    return Intl.message(
      'Pick Profile Picture',
      name: 'PickProfilePicturec',
      desc: '',
      args: [],
    );
  }

  /// `profile_screen`
  String get myprofile {
    return Intl.message(
      'profile_screen',
      name: 'myprofile',
      desc: '',
      args: [],
    );
  }

  /// `Phone: $phone`
  String get Phone {
    return Intl.message(
      'Phone: \$phone',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get Rating {
    return Intl.message(
      'Rating',
      name: 'Rating',
      desc: '',
      args: [],
    );
  }

  /// `Number of Ratings: $numRatings`
  String get NumberofRatings {
    return Intl.message(
      'Number of Ratings: \$numRatings',
      name: 'NumberofRatings',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get Collection {
    return Intl.message(
      'Collection',
      name: 'Collection',
      desc: '',
      args: [],
    );
  }

  /// `request_page`
  String get request {
    return Intl.message(
      'request_page',
      name: 'request',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get Accept {
    return Intl.message(
      'Accept',
      name: 'Accept',
      desc: '',
      args: [],
    );
  }

  /// `Request`
  String get Request {
    return Intl.message(
      'Request',
      name: 'Request',
      desc: '',
      args: [],
    );
  }

  /// `Client ID: $clientId`
  String get ClientID {
    return Intl.message(
      'Client ID: \$clientId',
      name: 'ClientID',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get Reject {
    return Intl.message(
      'Reject',
      name: 'Reject',
      desc: '',
      args: [],
    );
  }

  /// `Contact Client`
  String get ContactClient {
    return Intl.message(
      'Contact Client',
      name: 'ContactClient',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get Accepted {
    return Intl.message(
      'Accepted',
      name: 'Accepted',
      desc: '',
      args: [],
    );
  }

  /// `Select or enter a reason for rejection`
  String get Selectrejection {
    return Intl.message(
      'Select or enter a reason for rejection',
      name: 'Selectrejection',
      desc: '',
      args: [],
    );
  }

  /// `Enter custom reason`
  String get Entercustomreason {
    return Intl.message(
      'Enter custom reason',
      name: 'Entercustomreason',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a reason or select from the list.`
  String get Pleaselist {
    return Intl.message(
      'Please enter a reason or select from the list.',
      name: 'Pleaselist',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `AddProductScreen`
  String get AddProductScreen {
    return Intl.message(
      'AddProductScreen',
      name: 'AddProductScreen',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get AddProduct {
    return Intl.message(
      'Add Product',
      name: 'AddProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add Pictures`
  String get AddPictures {
    return Intl.message(
      'Add Pictures',
      name: 'AddPictures',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get ProductName {
    return Intl.message(
      'Product Name',
      name: 'ProductName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the product name`
  String get Pleaseentername {
    return Intl.message(
      'Please enter the product name',
      name: 'Pleaseentername',
      desc: '',
      args: [],
    );
  }

  /// `Select Category`
  String get SelectCategory {
    return Intl.message(
      'Select Category',
      name: 'SelectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get Pleaseselectacategory {
    return Intl.message(
      'Please select a category',
      name: 'Pleaseselectacategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Condition`
  String get SelectCondition {
    return Intl.message(
      'Select Condition',
      name: 'SelectCondition',
      desc: '',
      args: [],
    );
  }

  /// `Please select a condition`
  String get Pleaseselectacondition {
    return Intl.message(
      'Please select a condition',
      name: 'Pleaseselectacondition',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get Description {
    return Intl.message(
      'Description',
      name: 'Description',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get Pleaseenteradescription {
    return Intl.message(
      'Please enter a description',
      name: 'Pleaseenteradescription',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get Price {
    return Intl.message(
      'Price',
      name: 'Price',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the price`
  String get Pleaseprice {
    return Intl.message(
      'Please enter the price',
      name: 'Pleaseprice',
      desc: '',
      args: [],
    );
  }

  /// `Discounted Price`
  String get DiscountedPrice {
    return Intl.message(
      'Discounted Price',
      name: 'DiscountedPrice',
      desc: '',
      args: [],
    );
  }

  /// `Submit Product`
  String get SubmitProduct {
    return Intl.message(
      'Submit Product',
      name: 'SubmitProduct',
      desc: '',
      args: [],
    );
  }

  /// `Not Signed In`
  String get NotSignedIn {
    return Intl.message(
      'Not Signed In',
      name: 'NotSignedIn',
      desc: '',
      args: [],
    );
  }

  /// `Product added successfully`
  String get Productaddedsuccessfully {
    return Intl.message(
      'Product added successfully',
      name: 'Productaddedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Some error happened: ${e.toString()}`
  String get Someerrorhappened {
    return Intl.message(
      'Some error happened: \${e.toString()}',
      name: 'Someerrorhappened',
      desc: '',
      args: [],
    );
  }

  /// `Pick Profile Picture`
  String get PickProfilePicture {
    return Intl.message(
      'Pick Profile Picture',
      name: 'PickProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Edit Product_Screen`
  String get EditProductscreen {
    return Intl.message(
      'Edit Product_Screen',
      name: 'EditProductscreen',
      desc: '',
      args: [],
    );
  }

  /// `Edit Product`
  String get EditProduct {
    return Intl.message(
      'Edit Product',
      name: 'EditProduct',
      desc: '',
      args: [],
    );
  }

  /// `add new pictures`
  String get addnewpictures {
    return Intl.message(
      'add new pictures',
      name: 'addnewpictures',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get SaveChanges {
    return Intl.message(
      'Save Changes',
      name: 'SaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Product updated successfully`
  String get Productupdatedsuccessfully {
    return Intl.message(
      'Product updated successfully',
      name: 'Productupdatedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No product found with the specified itemID.`
  String get NoproductitemID {
    return Intl.message(
      'No product found with the specified itemID.',
      name: 'NoproductitemID',
      desc: '',
      args: [],
    );
  }

  /// `Item deleted successfully`
  String get Itemdeletedsuccessfully {
    return Intl.message(
      'Item deleted successfully',
      name: 'Itemdeletedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `forgetscreen_Screen`
  String get forgetscreen {
    return Intl.message(
      'forgetscreen_Screen',
      name: 'forgetscreen',
      desc: '',
      args: [],
    );
  }

  /// `We need your registration email to send you password reset code!`
  String get weneed {
    return Intl.message(
      'We need your registration email to send you password reset code!',
      name: 'weneed',
      desc: '',
      args: [],
    );
  }

  /// `send Code`
  String get sendCode {
    return Intl.message(
      'send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Reset code has been sent to your email`
  String get restemail {
    return Intl.message(
      'Reset code has been sent to your email',
      name: 'restemail',
      desc: '',
      args: [],
    );
  }

  /// `fcontentscreen_Screen`
  String get contentscreen {
    return Intl.message(
      'fcontentscreen_Screen',
      name: 'contentscreen',
      desc: '',
      args: [],
    );
  }

  /// `No messages available`
  String get Nomessagesavailable {
    return Intl.message(
      'No messages available',
      name: 'Nomessagesavailable',
      desc: '',
      args: [],
    );
  }

  /// `No clients are contacting you.`
  String get Noclientyou {
    return Intl.message(
      'No clients are contacting you.',
      name: 'Noclientyou',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get Usernotfound {
    return Intl.message(
      'User not found',
      name: 'Usernotfound',
      desc: '',
      args: [],
    );
  }

  /// `massagescreen_Screen`
  String get massagescreen {
    return Intl.message(
      'massagescreen_Screen',
      name: 'massagescreen',
      desc: '',
      args: [],
    );
  }

  /// `Last seen: Not available`
  String get lastseen {
    return Intl.message(
      'Last seen: Not available',
      name: 'lastseen',
      desc: '',
      args: [],
    );
  }

  /// `Active now`
  String get Activenow {
    return Intl.message(
      'Active now',
      name: 'Activenow',
      desc: '',
      args: [],
    );
  }

  /// `Type Something...`
  String get TypeSomething {
    return Intl.message(
      'Type Something...',
      name: 'TypeSomething',
      desc: '',
      args: [],
    );
  }

  /// `mycollection_screen`
  String get mycollection_screen {
    return Intl.message(
      'mycollection_screen',
      name: 'mycollection_screen',
      desc: '',
      args: [],
    );
  }

  /// `My Network`
  String get MyNetwork {
    return Intl.message(
      'My Network',
      name: 'MyNetwork',
      desc: '',
      args: [],
    );
  }

  /// `My Collection`
  String get MyCollection {
    return Intl.message(
      'My Collection',
      name: 'MyCollection',
      desc: '',
      args: [],
    );
  }

  /// `My Clients`
  String get MyClients {
    return Intl.message(
      'My Clients',
      name: 'MyClients',
      desc: '',
      args: [],
    );
  }

  /// `No items found in your collection.`
  String get Nofoundollection {
    return Intl.message(
      'No items found in your collection.',
      name: 'Nofoundollection',
      desc: '',
      args: [],
    );
  }

  /// `Item ID: ${item['itemID']}`
  String get ItemID {
    return Intl.message(
      'Item ID: \${item[\'itemID\']}',
      name: 'ItemID',
      desc: '',
      args: [],
    );
  }

  /// `Item not available`
  String get Itemnotavailable {
    return Intl.message(
      'Item not available',
      name: 'Itemnotavailable',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Price:' key

  /// `myorder_screen`
  String get myorder_screen {
    return Intl.message(
      'myorder_screen',
      name: 'myorder_screen',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get MyOrders {
    return Intl.message(
      'My Orders',
      name: 'MyOrders',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get Nonotifications {
    return Intl.message(
      'No notifications',
      name: 'Nonotifications',
      desc: '',
      args: [],
    );
  }

  /// `Product: $title`
  String get Product {
    return Intl.message(
      'Product: \$title',
      name: 'Product',
      desc: '',
      args: [],
    );
  }

  /// `Seller ID: $sellerID, \nTitle: $title`
  String get SellerID {
    return Intl.message(
      'Seller ID: \$sellerID, \nTitle: \$title',
      name: 'SellerID',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get OrderDetails {
    return Intl.message(
      'Order Details',
      name: 'OrderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Hide Rating`
  String get HideRating {
    return Intl.message(
      'Hide Rating',
      name: 'HideRating',
      desc: '',
      args: [],
    );
  }

  /// `Rate Seller`
  String get RateSeller {
    return Intl.message(
      'Rate Seller',
      name: 'RateSeller',
      desc: '',
      args: [],
    );
  }

  /// `Seller Rating`
  String get SellerRating {
    return Intl.message(
      'Seller Rating',
      name: 'SellerRating',
      desc: '',
      args: [],
    );
  }

  /// `Rating submitted successfully`
  String get Ratingsubmittedsuccessfully {
    return Intl.message(
      'Rating submitted successfully',
      name: 'Ratingsubmittedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit rating: $error`
  String get Failedtosubmitrating {
    return Intl.message(
      'Failed to submit rating: \$error',
      name: 'Failedtosubmitrating',
      desc: '',
      args: [],
    );
  }

  /// `Error submitting rating: $error`
  String get Errorsubmittingrating {
    return Intl.message(
      'Error submitting rating: \$error',
      name: 'Errorsubmittingrating',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating before submitting.`
  String get Pleaseselectaratingbeforesubmitting {
    return Intl.message(
      'Please select a rating before submitting.',
      name: 'Pleaseselectaratingbeforesubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Submit {
    return Intl.message(
      'Submit',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `Hello, \nI have a problem with the product that I purchased from you`
  String get prodectissue {
    return Intl.message(
      'Hello, \nI have a problem with the product that I purchased from you',
      name: 'prodectissue',
      desc: '',
      args: [],
    );
  }

  /// `Product Issue`
  String get ProductIssue {
    return Intl.message(
      'Product Issue',
      name: 'ProductIssue',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Order Details`
  String get RejectedOrderDetails {
    return Intl.message(
      'Rejected Order Details',
      name: 'RejectedOrderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get Close {
    return Intl.message(
      'Close',
      name: 'Close',
      desc: '',
      args: [],
    );
  }

  /// `Contact Seller`
  String get ContactSeller {
    return Intl.message(
      'Contact Seller',
      name: 'ContactSeller',
      desc: '',
      args: [],
    );
  }

  /// `myorderconf_screen`
  String get myordericonf_screen {
    return Intl.message(
      'myorderconf_screen',
      name: 'myordericonf_screen',
      desc: '',
      args: [],
    );
  }

  /// `Order Accepted`
  String get OrderAccepted {
    return Intl.message(
      'Order Accepted',
      name: 'OrderAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been accepted!`
  String get Yourorderhasbeenaccepted {
    return Intl.message(
      'Your order has been accepted!',
      name: 'Yourorderhasbeenaccepted',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get Back {
    return Intl.message(
      'Back',
      name: 'Back',
      desc: '',
      args: [],
    );
  }

  /// `myorderinfo_screen`
  String get myorderinfo_screen {
    return Intl.message(
      'myorderinfo_screen',
      name: 'myorderinfo_screen',
      desc: '',
      args: [],
    );
  }

  /// `Order Information`
  String get OrderInformation {
    return Intl.message(
      'Order Information',
      name: 'OrderInformation',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get Location {
    return Intl.message(
      'Location',
      name: 'Location',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a location`
  String get loc {
    return Intl.message(
      'Please enter a location',
      name: 'loc',
      desc: '',
      args: [],
    );
  }

  /// `Pickup Time`
  String get PickupTime {
    return Intl.message(
      'Pickup Time',
      name: 'PickupTime',
      desc: '',
      args: [],
    );
  }

  /// `Please select a pickup time`
  String get selectpick {
    return Intl.message(
      'Please select a pickup time',
      name: 'selectpick',
      desc: '',
      args: [],
    );
  }

  /// `Final Price`
  String get FinalPrice {
    return Intl.message(
      'Final Price',
      name: 'FinalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price`
  String get procev {
    return Intl.message(
      'Please enter a valid price',
      name: 'procev',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get ConfirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'ConfirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Receipt`
  String get Receipt {
    return Intl.message(
      'Receipt',
      name: 'Receipt',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Order confirmed: \nLocation: $location \nPickup Time: $pickupTime \nFinal Price: $finalPrice \n$itemDetails`
  String get massageconf {
    return Intl.message(
      'Order confirmed: \nLocation: \$location \nPickup Time: \$pickupTime \nFinal Price: \$finalPrice \n\$itemDetails',
      name: 'massageconf',
      desc: '',
      args: [],
    );
  }

  /// `CardPaymentView`
  String get CardPaymentView {
    return Intl.message(
      'CardPaymentView',
      name: 'CardPaymentView',
      desc: '',
      args: [],
    );
  }

  /// `Payment cards`
  String get Paymentcards {
    return Intl.message(
      'Payment cards',
      name: 'Paymentcards',
      desc: '',
      args: [],
    );
  }

  /// `No cards added`
  String get Nocardsadded {
    return Intl.message(
      'No cards added',
      name: 'Nocardsadded',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this card?`
  String get carddele {
    return Intl.message(
      'Are you sure you want to delete this card?',
      name: 'carddele',
      desc: '',
      args: [],
    );
  }

  /// `Card deleted`
  String get Carddeleted {
    return Intl.message(
      'Card deleted',
      name: 'Carddeleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `CardPaymentView`
  String get AddPaymentCardScreen {
    return Intl.message(
      'CardPaymentView',
      name: 'AddPaymentCardScreen',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get c1 {
    return Intl.message(
      'New',
      name: 'c1',
      desc: '',
      args: [],
    );
  }

  /// `Used - Like New`
  String get c2 {
    return Intl.message(
      'Used - Like New',
      name: 'c2',
      desc: '',
      args: [],
    );
  }

  /// `Used - Good`
  String get c3 {
    return Intl.message(
      'Used - Good',
      name: 'c3',
      desc: '',
      args: [],
    );
  }

  /// `Used - Acceptable`
  String get c4 {
    return Intl.message(
      'Used - Acceptable',
      name: 'c4',
      desc: '',
      args: [],
    );
  }

  /// `Payment card details saved successfully!`
  String get payss {
    return Intl.message(
      'Payment card details saved successfully!',
      name: 'payss',
      desc: '',
      args: [],
    );
  }

  /// `Error saving payment card: $e`
  String get errorpay {
    return Intl.message(
      'Error saving payment card: \$e',
      name: 'errorpay',
      desc: '',
      args: [],
    );
  }

  /// `invalid!`
  String get invalid {
    return Intl.message(
      'invalid!',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `Add Card`
  String get AddCard {
    return Intl.message(
      'Add Card',
      name: 'AddCard',
      desc: '',
      args: [],
    );
  }

  /// `Save the Card`
  String get SavetheCard {
    return Intl.message(
      'Save the Card',
      name: 'SavetheCard',
      desc: '',
      args: [],
    );
  }

  /// `PaymentPage`
  String get PaymentPage {
    return Intl.message(
      'PaymentPage',
      name: 'PaymentPage',
      desc: '',
      args: [],
    );
  }

  /// `Enter Price and Payment Method`
  String get method {
    return Intl.message(
      'Enter Price and Payment Method',
      name: 'method',
      desc: '',
      args: [],
    );
  }

  /// `Current Price: ${widget.currentPrice.toStringAsFixed(2)} SAR`
  String get curr {
    return Intl.message(
      'Current Price: \${widget.currentPrice.toStringAsFixed(2)} SAR',
      name: 'curr',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Listing Price`
  String get listprice {
    return Intl.message(
      'Enter New Listing Price',
      name: 'listprice',
      desc: '',
      args: [],
    );
  }

  /// `Prefer Payment Method:`
  String get prefcard {
    return Intl.message(
      'Prefer Payment Method:',
      name: 'prefcard',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get PaymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'PaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Submit the Request`
  String get SubmittheRequest {
    return Intl.message(
      'Submit the Request',
      name: 'SubmittheRequest',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get Success {
    return Intl.message(
      'Success',
      name: 'Success',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been sent successfully.`
  String get suumassage {
    return Intl.message(
      'Your request has been sent successfully.',
      name: 'suumassage',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get Error {
    return Intl.message(
      'Error',
      name: 'Error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send request. Please try again later.`
  String get errormassagge {
    return Intl.message(
      'Failed to send request. Please try again later.',
      name: 'errormassagge',
      desc: '',
      args: [],
    );
  }

  /// `product_Detail`
  String get product_Detail {
    return Intl.message(
      'product_Detail',
      name: 'product_Detail',
      desc: '',
      args: [],
    );
  }

  /// `Product Detail`
  String get ProductDetail {
    return Intl.message(
      'Product Detail',
      name: 'ProductDetail',
      desc: '',
      args: [],
    );
  }

  /// `Product not found`
  String get Productnotfound {
    return Intl.message(
      'Product not found',
      name: 'Productnotfound',
      desc: '',
      args: [],
    );
  }

  /// `Now: ${discountedPrice.toStringAsFixed(0)} SAR`
  String get now {
    return Intl.message(
      'Now: \${discountedPrice.toStringAsFixed(0)} SAR',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Check out this product: $productTitle for $productPrice SAR on Uni-Souq!`
  String get check {
    return Intl.message(
      'Check out this product: \$productTitle for \$productPrice SAR on Uni-Souq!',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `Before: ${price.toStringAsFixed(2)} SAR`
  String get befoer {
    return Intl.message(
      'Before: \${price.toStringAsFixed(2)} SAR',
      name: 'befoer',
      desc: '',
      args: [],
    );
  }

  /// `Condition: ${productData['condition']}`
  String get condtion {
    return Intl.message(
      'Condition: \${productData[\'condition\']}',
      name: 'condtion',
      desc: '',
      args: [],
    );
  }

  /// `Status : ${productData['status']}`
  String get state {
    return Intl.message(
      'Status : \${productData[\'status\']}',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get Comments {
    return Intl.message(
      'Comments',
      name: 'Comments',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment...`
  String get write {
    return Intl.message(
      'Write a comment...',
      name: 'write',
      desc: '',
      args: [],
    );
  }

  /// `You Are The Seller`
  String get YouAreTheSeller {
    return Intl.message(
      'You Are The Seller',
      name: 'YouAreTheSeller',
      desc: '',
      args: [],
    );
  }

  /// `This item is sold`
  String get Thisitemissold {
    return Intl.message(
      'This item is sold',
      name: 'Thisitemissold',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get InProgress {
    return Intl.message(
      'In Progress',
      name: 'InProgress',
      desc: '',
      args: [],
    );
  }

  /// `Request In Progress`
  String get RequestInProgress {
    return Intl.message(
      'Request In Progress',
      name: 'RequestInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Request To Buy`
  String get RequestToBuy {
    return Intl.message(
      'Request To Buy',
      name: 'RequestToBuy',
      desc: '',
      args: [],
    );
  }

  /// `View Seller Profile`
  String get ViewSellerProfile {
    return Intl.message(
      'View Seller Profile',
      name: 'ViewSellerProfile',
      desc: '',
      args: [],
    );
  }

  /// `drawer`
  String get drawer {
    return Intl.message(
      'drawer',
      name: 'drawer',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get ResetPassword {
    return Intl.message(
      'Reset Password',
      name: 'ResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Language/Theme`
  String get Language {
    return Intl.message(
      'Language/Theme',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `My Collection`
  String get MyCollectiond {
    return Intl.message(
      'My Collection',
      name: 'MyCollectiond',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get HelpCenter {
    return Intl.message(
      'Help Center',
      name: 'HelpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get Payment {
    return Intl.message(
      'Payment',
      name: 'Payment',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get Security {
    return Intl.message(
      'Security',
      name: 'Security',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get SignOut {
    return Intl.message(
      'Sign Out',
      name: 'SignOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sign out?`
  String get SignOutb {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'SignOutb',
      desc: '',
      args: [],
    );
  }

  /// `languagepage`
  String get languagepage {
    return Intl.message(
      'languagepage',
      name: 'languagepage',
      desc: '',
      args: [],
    );
  }

  /// `select Language`
  String get selectLanguage {
    return Intl.message(
      'select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get Theme {
    return Intl.message(
      'Theme',
      name: 'Theme',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message(
      'Arabic',
      name: 'Arabic',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme`
  String get SelectTheme {
    return Intl.message(
      'Select Theme',
      name: 'SelectTheme',
      desc: '',
      args: [],
    );
  }

  /// `System Theme`
  String get SystemTheme {
    return Intl.message(
      'System Theme',
      name: 'SystemTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get LightTheme {
    return Intl.message(
      'Light Theme',
      name: 'LightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get DarkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'DarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `language/Theme`
  String get Langtheme {
    return Intl.message(
      'language/Theme',
      name: 'Langtheme',
      desc: '',
      args: [],
    );
  }

  /// `How is your Product?`
  String get howitwas {
    return Intl.message(
      'How is your Product?',
      name: 'howitwas',
      desc: '',
      args: [],
    );
  }

  /// `Add detailed review`
  String get reviewd {
    return Intl.message(
      'Add detailed review',
      name: 'reviewd',
      desc: '',
      args: [],
    );
  }

  /// `Enter here`
  String get enter {
    return Intl.message(
      'Enter here',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `No review submitted by the client.`
  String get rev {
    return Intl.message(
      'No review submitted by the client.',
      name: 'rev',
      desc: '',
      args: [],
    );
  }

  /// `No review submitted by the client.`
  String get no {
    return Intl.message(
      'No review submitted by the client.',
      name: 'no',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
