class Student {
  String name;
  String status;

  Student(this.name, {this.status = 'Not Marked'});
}

Map<String, List<Student>> classData = {
  'Class 10-A': [
    Student('John'),
    Student('Alice'),
    Student('Bob'),
    Student('David'),
  ],
  'Class 10-B': [
    Student('Emma'),
    Student('Sam'),
    Student('Lucas'),
  ],
};
