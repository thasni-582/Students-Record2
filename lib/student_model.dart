class Student {
  final int? id;
  final String firstName;
  final String secondName;
  final String course;
  final String age;
  final String phone;
  final String imagePath;

  Student({
    this.id,
    required this.firstName,
    required this.secondName,
    required this.course,
    required this.age,
    required this.phone,
    required this.imagePath,
  });
  String getfullName() {
    return "$firstName $secondName";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'course': course,
      'age': age,
      'phone': phone,
      'imagePath': imagePath,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      course: map['course'],
      age: map['age'],
      phone: map['phone'],
      imagePath: map['imagePath'],
    );
  }
}
