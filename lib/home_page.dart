import 'package:flutter/material.dart';
import 'package:students_records/student_detail_page.dart';
import 'db_helper.dart';
import 'student_model.dart';
import 'add_student_page.dart';
import 'dart:io';

//HomePage Class

class HomePage extends StatefulWidget {
  //it's a stateful Widget
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = []; //storing of students record

  List<Student> filteredStudents = []; //store search result
  TextEditingController searchController =
      TextEditingController(); //handled textField Value
  bool isGrid = false; //list view or grid veiw

  @override
  void initState() {
    super.initState();
    _loadStudents(); //fetching student from Db
  }

  void _loadStudents() async {
    final data = await DbHelper().getAllStudents(); //get students from db
    print("📦 Loaded ${data.length} students");
    setState(() {
      //update state

      students = data;
      filteredStudents = data; //stored data
    });
  }

  void _deleteStudent(int id) async {
    //the function received id of deleted student
    await DbHelper().deleteStudent(id);
    _loadStudents(); // Refresh list after delete
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Delete Student"),
            content: Text("Are you sure you want to delete this student?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteStudent(id);
                },
              ),
            ],
          ),
    );
  }

  void _filterStudents(String query) {
    final results =
        students
            .where(
              (student) =>
                  student.getfullName().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  student.course.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    setState(() {
      filteredStudents = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Records"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                //Refresh ui

                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterStudents,
              decoration: InputDecoration(
                hintText: 'Search by name or course',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredStudents.isEmpty
                    ? Center(child: Text("No students found"))
                    : isGrid
                    ? GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => StudentDetailPage(student: student),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(
                                    File(student.imagePath),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(student.getfullName()),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            StudentDetailPage(student: student),
                                  ),
                                ),
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                File(student.imagePath),
                              ),
                            ),
                            title: Text(student.getfullName()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => AddStudentPage(
                                              student: student,
                                            ),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadStudents();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(student.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddStudentPage()),
          );
          if (result == true) {
            _loadStudents();
          }
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
