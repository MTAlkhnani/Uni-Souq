import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:unisouq/components/green_intro_widget.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'package:uuid/uuid.dart';

import 'package:unisouq/service/payment_service.dart';

class AddPaymentCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPaymentCardScreenState();
  }
}

class AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  late String currentUserId;
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
    getCurrentUserId();
  }

  final PaymentService _paymentService = PaymentService();

  Future<void> getCurrentUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void onSaveButtonPressed() async {
    if (formKey.currentState!.validate()) {
      print('valid!');
      try {
        final cardId = const Uuid().v4(); // Generate random cardId
        await _paymentService.addPaymentCard(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          userId: currentUserId,
          cardId: cardId,
        );
        print('Payment card details saved successfully!');
      } catch (e) {
        print('Error saving payment card: $e');
        // Handle error
      }
    } else {
      print('invalid!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IntroWidgetWithoutLogos(title: 'Add Card', context: context),
          Column(
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor:
                    Theme.of(context).primaryColor, // Change the color here
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: const <CustomCardTypeIcon>[],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                        themeColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            print('valid!');

                            onSaveButtonPressed();
                            Navigator.of(context).pop();

                            // Add your logic to store the card details
                          } else {
                            print('invalid!');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Save the Card',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber!;
      expiryDate = creditCardModel.expiryDate!;
      cardHolderName = creditCardModel.cardHolderName!;
      cvvCode = creditCardModel.cvvCode!;
      isCvvFocused = creditCardModel.isCvvFocused!;
    });
  }
}
