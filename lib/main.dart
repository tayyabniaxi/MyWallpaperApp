import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper_app/provider/categoryViewmodel-provider.dart';
import 'package:my_wallpaper_app/provider/favorite_toggle.dart';
import 'package:provider/provider.dart';
import 'viewmodels/subcategory_view_model.dart';
import 'viewmodels/theme_view_model.dart';
import 'views/home_page.dart';
import 'package:google_api_availability/google_api_availability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MultiProvider(
    providers: [
       ChangeNotifierProvider(create: (_) => FavoriteProvider()),
       ChangeNotifierProvider(create: (_) => CategoryViewModel()),
    ],
    child: MyApp()));

  await checkGooglePlayServicesAvailability();
}

Future<void> checkGooglePlayServicesAvailability() async {
  GoogleApiAvailability apiAvailability = GoogleApiAvailability.instance;
  final status = await apiAvailability.checkGooglePlayServicesAvailability();

  if (status == GooglePlayServicesAvailability.success) {
    print("Google Play Services is available.");
  } else {
    print("Google Play Services is not available: $status");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ThemeViewModel>(

      create: (context) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return ChangeNotifierProvider<SubcategoryViewModel>(
            create: (context) => SubcategoryViewModel(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Wallpaper App',
              theme: themeViewModel.currentTheme,
              home: HomePage(),
            ),
          );
        },
      ),
    );
  }
}




/*

// Import necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload and Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadImagePage(),
    );
  }
}

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {

  String? selectedCategory;
  String? selectedSubCategory;

  final List<String> categories = [
    'Wallpaper',
    'Technology',
    'Animals',
    'Sports',
    'Art',
    'Food',
    'Qaiser'
  ];

  final Map<String, List<String>> subCategories = {
    'Technology': [
      'AI',
      'Gadgets',
      'Robots',
      'Coding',
      'VR',
      'AR',
      'Blockchain',
      'Drones',
    ],
    'Animals': [
      'Cats',
      'Dogs',
      'Birds',
      'Wildlife',
      'Aquatic',
      'Insects',
      'Pets',
      'Horses',
    ],
    'Qaiser':[
      'Farooq'
    ],
    'Sports': [
      'Football',
      'Basketball',
      'Tennis',
      'Swimming',
      'Running',
      'Cycling',
      'Baseball',
      'Boxing',
    ],
    'Art': [
      'Painting',
      'Photography',
      'Design',
      'Fashion',
      'Digital Art',
      'Calligraphy',
      'Illustration',
      'Typography',
    ],
    'Food': [
      'Fruits',
      'Fast Food',
      'Desserts',
      'Drinks',
      'Seafood',
      'Meat',
      'Baking',
      'Dairy',
    ],
  };
  File? _image;
  final _nameController = TextEditingController();
  // final _categoryController = TextEditingController();  // New field for category
  // final _subcategoryController = TextEditingController();  // New field for subcategory
  bool _isUploading = false; // Track upload state

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null ||
        _nameController.text.isEmpty ||
        selectedCategory!.isEmpty ||
        selectedSubCategory!.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields and pick an image.');
      return;
    }

    setState(() {
      _isUploading = true; // Start upload
    });

    try {
      // Upload image to Firebase Storage with category and subcategory
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('categories/${selectedCategory}/${selectedSubCategory}/${_nameController.text}.jpg');
      await storageRef.putFile(_image!);

      // Get the image URL
      final url = await storageRef.getDownloadURL();

      // Save image data in Firestore under category and subcategory
      final docRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategory)
          .collection('subcategories')
          .doc(selectedSubCategory);

      // Check if the document exists
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // If it exists, update the existing data
        await docRef.update({
          'images': FieldValue.arrayUnion([
            {'url': url, 'key': _nameController.text}
          ]),
        });
      } else {
        // If it doesn't exist, create a new document with the image data
        await docRef.set({
          'images': [
            {'url': url, 'key': _nameController.text}
          ],
        });
      }

      // Clear fields
      setState(() {
        _image = null;
        _nameController.clear();
        selectedCategory="";
        selectedSubCategory="";
      });

      Fluttertoast.showToast(
          msg: 'Image uploaded successfully!'); // Show toast message
    } catch (e) {
      Fluttertoast.showToast(msg: 'Upload failed: $e'); // Show error message
    } finally {
      setState(() {
        _isUploading = false; // End upload
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Image Name'),
              ),
              SizedBox(height: 16),
              // TextField(
              //   // controller: _categoryController,
              //   onChanged: (v){
              //     setState(() {
              //       selectedCategory=v;
              //     });
              //   },
              //   decoration: InputDecoration(labelText: 'Category'),
              // ),
              // SizedBox(height: 16),
              // TextField(
              //   // controller: _subcategoryController,
              //   onChanged: (v){
              //     setState(() {
              //       selectedSubCategory=v;
              //     });
              //   },
              //   decoration: InputDecoration(labelText: 'Subcategory'),
              // ),
              DropdownButton<String>(
                hint: Text('Select Category'),
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    selectedSubCategory = null; // Reset subcategory
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              if (selectedCategory != null) // Show only if a category is selected
                DropdownButton<String>(
                  hint: Text('Select Subcategory'),
                  value: selectedSubCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSubCategory = newValue;
                    });
                  },
                  items: subCategories[selectedCategory]!.map((subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16),
              _image != null ? Image.file(_image!) : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadImage, // Disable button during upload
                child: Text('Upload Image'),
              ),
              if (_isUploading) CircularProgressIndicator(), // Show progress indicator
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageListPage()),
                  );
                },
                child: Text('View Uploaded Images'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ImageListPage extends StatefulWidget {
  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {

  final List<String> categories = [
    'Wallpaper',
    'Technology',
    'Animals',
    'Sports',
    'Art',
    'Food',
    'Qaiser'
  ];

  final Map<String, List<String>> subCategories = {
    'Technology': [
      'AI',
      'Gadgets',
      'Robots',
      'Coding',
      'VR',
      'AR',
      'Blockchain',
      'Drones',
    ],
    'Animals': [
      'Cats',
      'Dogs',
      'Birds',
      'Wildlife',
      'Aquatic',
      'Insects',
      'Pets',
      'Horses',
    ],
    'Qaiser':[
      'Farooq'
    ],
    'Sports': [
      'Football',
      'Basketball',
      'Tennis',
      'Swimming',
      'Running',
      'Cycling',
      'Baseball',
      'Boxing',
    ],
    'Art': [
      'Painting',
      'Photography',
      'Design',
      'Fashion',
      'Digital Art',
      'Calligraphy',
      'Illustration',
      'Typography',
    ],
    'Food': [
      'Fruits',
      'Fast Food',
      'Desserts',
      'Drinks',
      'Seafood',
      'Meat',
      'Baking',
      'Dairy',
    ],
  };

  String? selectedCategory;
  String? selectedSubCategory;


  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController();  // For category input
  // final TextEditingController _subcategoryController = TextEditingController();  // For subcategory input

  Future<List<Map<String, dynamic>>> _fetchImages(String category, String subcategory) async {
    try {
      if (category.isEmpty || subcategory.isEmpty) {
        Fluttertoast.showToast(msg: 'Please enter both category and subcategory.');
        return [];
      }

      // Fetching document from Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(category)
          .collection('subcategories')
          .doc(subcategory)
          .get();

      if (docSnapshot.exists) {
        // Cast the data to Map<String, dynamic>
        final data = docSnapshot.data() as Map<String, dynamic>;
        final images = List<Map<String, dynamic>>.from(data['images'] ?? []);
        return images;
      } else {
        Fluttertoast.showToast(msg: 'No images found for the given category and subcategory.');
        return [];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching images: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded Images'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(140.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // TextField(
                //   controller: _categoryController,
                //   decoration: InputDecoration(hintText: 'Enter Category'),
                // ),
                // SizedBox(height: 8),
                // TextField(
                //   controller: _subcategoryController,
                //   decoration: InputDecoration(hintText: 'Enter Subcategory'),
                // ),
                DropdownButton<String>(
                  hint: Text('Select Category'),
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                      selectedSubCategory = null; // Reset subcategory
                    });
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                if (selectedCategory != null) // Show only if a category is selected
                  DropdownButton<String>(
                    hint: Text('Select Subcategory'),
                    value: selectedSubCategory,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubCategory = newValue;
                      });
                    },
                    items: subCategories[selectedCategory]?.map((subCategory) {
                      return DropdownMenuItem<String>(
                        value: subCategory,
                        child: Text(subCategory),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: 'Search by image name'),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchImages(selectedCategory??'', selectedSubCategory??''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final images = snapshot.data ?? [];
          final filteredImages = images
              .where((img) => img['key'].toLowerCase().contains(_searchQuery))
              .toList();

          if (filteredImages.isEmpty) {
            return Center(child: Text('No images found.'));
          }

          return ListView.builder(
            itemCount: filteredImages.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  filteredImages[index]['url'],
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(filteredImages[index]['key']),
              );
            },
          );
        },
      ),
    );
  }
}




 */