import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptography/cryptography.dart';

class PaymentService {
  final CollectionReference paymentCollection =
      FirebaseFirestore.instance.collection('PaymentCard');
  final algorithm = AesGcm.with256bits();

  Future<void> addPaymentCard({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
    required String userId,
    required String cardId,
  }) async {
    try {
      // Generate a random 256-bit secret key
      final secretKey = await algorithm.newSecretKey();

      // Generate a random 96-bit nonce
      final nonce = algorithm.newNonce();

      // Encrypt the payment card details
      final encryptedCardNumber = await algorithm.encrypt(
        cardNumber.codeUnits,
        secretKey: secretKey,
        nonce: nonce,
      );

      final encryptedExpiryDate = await algorithm.encrypt(
        expiryDate.codeUnits,
        secretKey: secretKey,
        nonce: nonce,
      );

      final encryptedCvvCode = await algorithm.encrypt(
        cvvCode.codeUnits,
        secretKey: secretKey,
        nonce: nonce,
      );

      // Store the encrypted data in Firestore with the provided cardId
      await paymentCollection.doc(cardId).set({
        'cardNumber': encryptedCardNumber.cipherText,
        'expiryDate': encryptedExpiryDate.cipherText,
        'cardHolderName': cardHolderName,
        'cvvCode': encryptedCvvCode.cipherText,
        'userId': userId,
        'cardId': cardId, // Include the cardId in the document
      });
    } catch (e) {
      print('Error adding payment card: $e');
      throw e; // Throw error for handling elsewhere
    }
  }

  Future<List<Map<String, dynamic>>?> getPaymentCardsByUserId(
    String userId,
  ) async {
    try {
      // Query the paymentCollection for the user ID
      final QuerySnapshot paymentSnapshot =
          await paymentCollection.where('userId', isEqualTo: userId).get();

      // Check if any documents were found
      if (paymentSnapshot.docs.isNotEmpty) {
        // Extract card details from each document and include the document ID as the cardId field
        List<Map<String, dynamic>> cards = paymentSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Include the document ID as the cardId field
          data['cardId'] = doc.id;
          return data;
        }).toList();
        return cards;
      } else {
        // If no payment card details found for the user, return null
        return null;
      }
    } catch (e) {
      print('Error retrieving payment cards: $e');
      throw e; // Throw error for handling elsewhere
    }
  }

  Future<void> deletePaymentCard(String cardId) async {
    try {
      await paymentCollection.doc(cardId).delete();
    } catch (e) {
      print('Error deleting payment card: $e');
      throw e; // Throw error for handling elsewhere
    }
  }
}
