import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'student_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

class AddStudentPage extends StatefulWidget {
  final Student? student;

  const AddStudentPage({super.key, this.student});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _secondNameController.text = widget.student!.secondName;
      _courseController.text = widget.student!.course;
      _ageController.text = widget.student!.age;
      _phoneController.text = widget.student!.phone;

      selectedImagePath = widget.student!.imagePath;
    }
  }

  final _formKey = GlobalKey<FormState>(); // Step 1: Form Key
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  String selectedImagePath = "";

  final ImagePicker _picker = ImagePicker();

  //get imagePath => null;

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Student",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color.fromARGB(255, 233, 235, 236),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            // Step 2: Wrap with Form
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _secondNameController,
                  decoration: InputDecoration(
                    labelText: 'Second Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _courseController,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Course';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Phone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DottedBorder(
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    alignment: Alignment.center,
                    child:
                        selectedImagePath.isEmpty
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 50, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "No image selected.",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(selectedImagePath),
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text("Pick Image"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () async {
                    print("✅ Save button pressed");

                    if (_formKey.currentState!.validate()) {
                      print("✅ Form is valid");

                      final student = Student(
                        id: widget.student?.id,
                        firstName: _firstNameController.text,
                        secondName: _secondNameController.text,
                        course: _courseController.text,
                        age: _ageController.text,
                        phone: _phoneController.text,
                        imagePath: selectedImagePath,

                        // ✅ FIXED
                      );

                      if (widget.student == null) {
                        await DbHelper().insertStudent(student);
                      } else {
                        await DbHelper().updateStudent(student);
                      }

                      Navigator.pop(context, true);
                    } else {}
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
