import 'package:flutter/material.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  // late _db;
  bool isSearchBarVisible = false;

  void toggleSearchBarVisibility() {
    setState(() {
      isSearchBarVisible = !isSearchBarVisible;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Files', style: TextStyle(fontSize: 28.0)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              toggleSearchBarVisibility();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          if (isSearchBarVisible)
            SearchBar(
              hintText: "Search for files",
              shadowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              onSubmitted: (value) {
                // search for the file
              },
              onChanged: (value) {
                // filter the list of files
              },
            ),
        ],
      ),
    );
  }
}
