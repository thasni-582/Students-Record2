import 'dart:io';
import 'package:flutter/material.dart';
import 'student_model.dart';
import 'db_helper.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  // delete method
  void _deleteStudent(BuildContext context) async {
    await DbHelper().deleteStudent(student.id!);
    Navigator.pop(context, true); // Refresh after delete
  }

  // Ui build method
  @override
  Widget build(BuildContext context) {
    //use build method for making ui page
    return Scaffold(
      appBar: AppBar(
        title: Text(student.getfullName()),
        actions: [
          //A delete icon button in the top bar to remove the student
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              //Delet confirmation Dailoge
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Delete Student"),
                      content: const Text(
                        "Are you sure you want to delete this student?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                _deleteStudent(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child:
                  student.imagePath.isNotEmpty &&
                          File(student.imagePath).existsSync()
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(student.imagePath),
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                      //Display image or Icon
                      //if not, show a default person icon
                      : const Icon(Icons.person, size: 150),
            ),
            const SizedBox(height: 20),

            //display text fields
            Text(
              "Name: ${student.getfullName()}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text(
              "Course: ${student.course}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text("Age: ${student.age}", style: const TextStyle(fontSize: 18)),
            Text(
              "Phone: ${student.phone}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
