import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(MyApp());
}

class Post {
  final String category;
  final String link;

  Post({required this.category, required this.link});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'link': link,
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Post Saver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<Post>> categoryPosts = {};
  List<String> categories = [];
  String? selectedCategory;

  TextEditingController categoryController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPostsFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LinkedIn Post Saver',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCategory,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('Select a category'),
                          ),
                          ...categories.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null &&
                              categoryController.text.isEmpty) {
                            return 'Please select a category or enter a new one';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          labelText: 'New Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          selectedCategory = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: linkController,
                  decoration: InputDecoration(
                    labelText: 'LinkedIn Post Link',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a LinkedIn Post Link';
                    }
                    return null;
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String selectedCategoryValue =
                          selectedCategory ?? categoryController.text;
                      if (selectedCategoryValue.isNotEmpty) {
                        setState(() {
                          String link = linkController.text;
                          if (!categoryPosts
                              .containsKey(selectedCategoryValue)) {
                            categoryPosts[selectedCategoryValue] = [];
                            categories.add(selectedCategoryValue);
                          }
                          categoryPosts[selectedCategoryValue]!.add(Post(
                              category: selectedCategoryValue, link: link));
                          linkController.clear();
                          categoryController.clear();
                          selectedCategory = null;
                          _savePostsToJson(); // Save posts to JSON file
                        });
                      }
                    }
                  },
                  child: Text('Save Post'),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'All Posts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: categoryPosts.keys.length,
                itemBuilder: (context, index) {
                  String category = categoryPosts.keys.elementAt(index);
                  return ExpansionTile(
                    title: Text(category),
                    children: categoryPosts[category]!.map((post) {
                      return ListTile(
                        title: Text(post.category),
                        subtitle: Text(post.link),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  categoryPosts[post.category]!.remove(post);
                                  if (categoryPosts[post.category]!.isEmpty) {
                                    categoryPosts.remove(post.category);
                                    categories.remove(post.category);
                                  }
                                  _savePostsToJson(); // Save posts to JSON file
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.content_paste),
                              onPressed: _pasteFromClipboard,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to save posts to JSON file
  _savePostsToJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/posts.json');
    Map<String, dynamic> jsonMap = {};
    categoryPosts.forEach((category, posts) {
      jsonMap[category] = posts.map((post) => post.toJson()).toList();
    });
    file.writeAsString(json.encode(jsonMap));
  }

  // Function to load posts from JSON file
  _loadPostsFromJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/posts.json');
      if (await file.exists()) {
        final jsonMap = json.decode(await file.readAsString());
        jsonMap.forEach((category, postsJson) {
          List<Post> posts = (postsJson as List)
              .map((postJson) => Post(
                    category: postJson['category'],
                    link: postJson['link'],
                  ))
              .toList();
          categoryPosts[category] = posts;
          categories.add(category);
        });
        setState(() {});
      }
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  // Function to paste from clipboard
  _pasteFromClipboard() async {
    ClipboardData? clipboardText = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardText != null) {
      setState(() {
        linkController.text = clipboardText as String;
      });
    }
  }
}
