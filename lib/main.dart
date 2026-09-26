import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}

// Simple Student model
class Student {
  String name;
  String status; // 'Not Marked', 'Present', 'Absent'

  Student(this.name, {this.status = 'Not Marked'});
}

// Global data for classes and their students
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

// 1. Welcome Page
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Attendance App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherScreen()),
                );
              },
              child: const Text('Go to Classes'),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Teacher Page (List of Classes)
class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> classNames = classData.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Page')),
      body: ListView.builder(
        itemCount: classNames.length,
        itemBuilder: (context, index) {
          String name = classNames[index];
          int count = classData[name]!.length;
          return ListTile(
            title: Text(name),
            subtitle: Text('$count students'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassScreen(className: name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 3. Class Page (List of Students, Add Student, Analytics)
class ClassScreen extends StatefulWidget {
  final String className;
  const ClassScreen({super.key, required this.className});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  // Option to create and add student
  void addStudentDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter student name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  classData[widget.className]!.add(
                    Student(controller.text.trim()),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Student> students = classData[widget.className]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        actions: [
          // Button to open Analytics
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Analytics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyticsScreen(
                    className: widget.className,
                    students: students,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallingScreen(
                            className: widget.className,
                            students: students,
                          ),
                        ),
                      );
                      setState(() {}); // refresh list
                    },
                    child: const Text('Start Calling Names'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalyticsScreen(
                          className: widget.className,
                          students: students,
                        ),
                      ),
                    );
                  },
                  child: const Text('Analytics'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                Student s = students[index];
                return ListTile(
                  title: Text(s.name),
                  trailing: Text(
                    s.status,
                    style: TextStyle(
                      color: s.status == 'Present'
                          ? Colors.green
                          : s.status == 'Absent'
                              ? Colors.red
                              : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addStudentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 4. Calling Names Page (Mark Present / Absent)
class CallingScreen extends StatefulWidget {
  final String className;
  final List<Student> students;

  const CallingScreen({
    super.key,
    required this.className,
    required this.students,
  });

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  int index = 0;

  void mark(String status) {
    widget.students[index].status = status;
    if (index < widget.students.length - 1) {
      setState(() {
        index++;
      });
    } else {
      Navigator.pop(context); // finished calling
    }
  }

  @override
  Widget build(BuildContext context) {
    Student currentStudent = widget.students[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Calling Names')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calling: ${currentStudent.name}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Student ${index + 1} of ${widget.students.length}'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => mark('Absent'),
                  child: const Text('Absent'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => mark('Present'),
                  child: const Text('Present'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 5. Analytics Screen (Shows who is present and who is not)
class AnalyticsScreen extends StatelessWidget {
  final String className;
  final List<Student> students;

  const AnalyticsScreen({
    super.key,
    required this.className,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    List<Student> presentList =
        students.where((s) => s.status == 'Present').toList();
    List<Student> absentList =
        students.where((s) => s.status == 'Absent').toList();
    List<Student> notMarkedList =
        students.where((s) => s.status == 'Not Marked').toList();

    return Scaffold(
      appBar: AppBar(title: Text('$className Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Present Students (${presentList.length}):',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (presentList.isEmpty) const Text('None'),
            for (var s in presentList) Text('• ${s.name}'),
            const SizedBox(height: 20),
            Text(
              'Absent Students (${absentList.length}):',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            if (absentList.isEmpty) const Text('None'),
            for (var s in absentList) Text('• ${s.name}'),
            const SizedBox(height: 20),
            Text(
              'Not Marked (${notMarkedList.length}):',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            if (notMarkedList.isEmpty) const Text('None'),
            for (var s in notMarkedList) Text('• ${s.name}'),
          ],
        ),
      ),
    );
  }
}
