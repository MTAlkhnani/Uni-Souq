// searchScreen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: theme.textTheme.headline6),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Discover More',
                style: theme.textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: <Widget>[
                  Chip(label: Text('Michael Jackson'), backgroundColor: theme.canvasColor,),
                  Chip(label: Text('Alan Walker'), backgroundColor: theme.canvasColor,),
                  Chip(label: Text('Best'), backgroundColor: theme.canvasColor,),
                  // Add more chips here
                ],
              ),
            ),
            // The rest of your screen content goes here
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          border: InputBorder.none,
          hintStyle: TextStyle(color: theme.hintColor),
        ),
        style: TextStyle(color: theme.textTheme.bodyText1?.color),
      ),
    );
  }
}
