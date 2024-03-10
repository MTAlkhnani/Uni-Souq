import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

final List<String> popularCategories = [
  'All Items',
  'Electronics',
  'Clothing',
  'Books',
  'Furniture',
  'Home'
  // Add more categories as needed
];

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Placeholder for the "Categories" section
          Padding(
            padding: EdgeInsets.only(
                left: isArabic() ? 0 : 10, top: 5, right: isArabic() ? 15 : 0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[500]!,
              highlightColor: Colors.grey[500]!,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.grey[500]!,
                      Colors.grey[400]!,
                      Colors.grey[500]!,
                    ],
                    stops: [0.4, 0.5, 0.6],
                  ),
                ),
              ),
            ),
          ),

          // Placeholder for the "Popular categories" section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: popularCategories.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Colors.grey[500], // Adjust color as needed
                        child: Icon(
                          Icons.category, // Placeholder icon
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3), // Adjust spacing as needed
                      Shimmer.fromColors(
                        baseColor: Colors.grey[500]!,
                        highlightColor: Colors.grey[500]!,
                        child: Container(
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.grey[500]!,
                                Colors.grey[400]!,
                                Colors.grey[500]!,
                              ],
                              stops: [0.4, 0.5, 0.6],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Placeholder for the "Items" section
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: 6, // Adjust the number of shimmering items as needed
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.grey[500]!,
                          Colors.grey[400]!,
                          Colors.grey[500]!,
                        ],
                        stops: [0.4, 0.5, 0.6],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}
