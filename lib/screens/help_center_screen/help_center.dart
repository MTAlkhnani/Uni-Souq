import 'package:flutter/material.dart';
import 'package:unisouq/screens/help_center_screen/chat_room.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle(context, 'FAQs'),
            _buildFAQs(context),
            const SizedBox(height: 20.0),
            _buildSectionTitle(context, 'Contact Us'),
            _buildContactInfo(context),
            const SizedBox(height: 20.0),
            _buildSectionTitle(context, 'Customer Support'),
            _buildCustomerSupport(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFAQs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFAQItem(
          context,
          question: 'How can I place an order?',
          answer:
              'To place an order, simply browse our products, select the items you want to purchase, add them to your cart, and proceed to checkout. Follow the prompts to provide shipping and payment information, and confirm your order.',
        ),
        _buildFAQItem(
          context,
          question: 'What payment methods do you accept?',
          answer:
              'We accept various payment methods including credit/debit cards, PayPal, and bank transfers. You can view the available payment options during checkout.',
        ),
        _buildFAQItem(
          context,
          question: 'How do I track my order?',
          answer:
              'Once your order has been shipped, you will receive a tracking number via email or SMS. You can use this tracking number to monitor the status of your delivery on our website or the courier\'s website.',
        ),
        _buildFAQItem(
          context,
          question: 'What is your return policy?',
          answer:
              'We have a hassle-free return policy. If you are not satisfied with your purchase, you can return the item(s) within 30 days for a refund or exchange. Please refer to our Returns & Exchanges page for more details.',
        ),
        // Add more FAQs as needed
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context,
      {required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email: support@unisoq.com',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10.0),
        Text(
          'Phone: +966 583 50 6564',
          style: TextStyle(fontSize: 16.0),
        ),
        // Add more contact information as needed
      ],
    );
  }

  Widget _buildCustomerSupport(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(),
          ),
        );
      },
      child: const Text(
        'Chat with Customer Support',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
