import 'package:flutter/material.dart';
import 'data.dart';
import 'calling_screen.dart';
import 'analytics_screen.dart';

class ClassScreen extends StatefulWidget {
  final String className;
  const ClassScreen({super.key, required this.className});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
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
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
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
                      setState(() {});
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
