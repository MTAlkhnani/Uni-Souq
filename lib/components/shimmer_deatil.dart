import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmerload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for product images slider
            SizedBox(
              height: 250,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white, // Placeholder color
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for product title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200, // Placeholder width
                            height: 30, // Placeholder height
                            color: Colors.white, // Placeholder color
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 100, // Placeholder width
                            height: 30, // Placeholder height
                            color: Colors.white, // Placeholder color
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Placeholder for product price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100, // Placeholder width
                            height: 20, // Placeholder height
                            color: Colors.white, // Placeholder color
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Placeholder for product condition
                      Container(
                        width: 150, // Placeholder width
                        height: 20, // Placeholder height
                        color: Colors.white, // Placeholder color
                      ),
                      const SizedBox(height: 8),

                      // Placeholder for product description
                      Container(
                        width: double.infinity, // Placeholder width
                        height: 80, // Placeholder height
                        color: Colors.white, // Placeholder color
                      ),
                      const SizedBox(height: 8),

                      // Placeholder for product status
                      Container(
                        width: 100, // Placeholder width
                        height: 20, // Placeholder height
                        color: Colors.white, // Placeholder color
                      ),
                      const SizedBox(height: 16),

                      // Placeholder for seller profile button
                      Container(
                        width: double.infinity, // Placeholder width
                        height: 40, // Placeholder height
                        color: Colors.white, // Placeholder color
                      ),

                      const SizedBox(height: 16),

                      // Placeholder for comment input field
                      Container(
                        width: double.infinity, // Placeholder width
                        height: 50, // Placeholder height
                        color: Colors.white, // Placeholder color
                      ),
                    ]),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const Text(
                  'Comments', // Placeholder text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Placeholder color
                  ),
                ),
              ),
            ),

            // Placeholder for comment input field
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your comment...', // Placeholder text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 5),
                      Text(
                        'Request To Buy', // Placeholder text
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
