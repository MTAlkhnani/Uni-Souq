import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:unisouq/screens/payment_page/payment_card_add.dart';
import 'package:unisouq/service/payment_service.dart';

class CardPaymentView extends StatelessWidget {
  final String userId;

  CardPaymentView({
    required this.userId,
  });

  final PaymentService paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: paymentService.getPaymentCardsByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final cardDataList = snapshot.data;
              if (cardDataList != null && cardDataList.isNotEmpty) {
                return ListView.builder(
                  itemCount: cardDataList.length,
                  itemBuilder: (context, index) {
                    final cardData = cardDataList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // Show a confirmation dialog before deleting the card
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure you want to delete this card?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    // Remove the item from the data source.
                                    paymentService
                                        .deletePaymentCard(cardData['cardId']);
                                    // Show a snackbar.
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Card deleted'),
                                    ));
                                  },
                                  isDestructiveAction: true,
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: CreditCardWidget(
                          cardNumber: '',
                          expiryDate: '',
                          cardHolderName: cardData['cardHolderName'],
                          cvvCode: '',
                          showBackView: false,
                          obscureCardNumber: false,
                          obscureCardCvv: false,
                          isHolderNameVisible: true,
                          cardBgColor: Theme.of(context).primaryColor,
                          isSwipeGestureEnabled: false,
                          onCreditCardWidgetChange:
                              (CreditCardBrand creditCardBrand) {},
                          customCardTypeIcons: const <CustomCardTypeIcon>[],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No cards added',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen for adding a new card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPaymentCardScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
