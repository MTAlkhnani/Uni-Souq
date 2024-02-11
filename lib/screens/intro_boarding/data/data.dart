import '../models/item.dart';

List<Item> items = [
  Item(
      title: 'Welcome to the world of Uni-Souq',
      lottie: lotties[0],
      description: desc[0]),
  Item(
      title: 'Select the \nPayment Methed.',
      lottie: lotties[1],
      description: desc[1]),
  Item(
      title: 'Contact directly \nwith the client.',
      lottie: lotties[2],
      description: desc[2]),
];
List<String> desc = [
  'Wellcome to a World of limitless Choices - Your perfect product Awaits!',
  'For Seamless Transaction, Choose Your Payment Path - Your Convenience, Our priority ',
  'Have a fast and  way to communicate with the client'
];

List<String> lotties = [
  'assets/lotties/prudect.json',
  'assets/lotties/security.json',
  'assets/lotties/massging.json',
];
