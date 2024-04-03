import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Post {
  final String category;
  final String link;

  Post({required this.category, required this.link});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Post Saver-Ayush Naik',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LinkedIn Post Saver- Ayush Naik',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Color.fromARGB(255, 251, 251, 251)),
        ),
        backgroundColor: Color.fromARGB(255, 47, 107, 197),
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              categoryPosts[post.category]!.remove(post);
                              if (categoryPosts[post.category]!.isEmpty) {
                                categoryPosts.remove(post.category);
                                categories.remove(post.category);
                              }
                            });
                          },
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
}
