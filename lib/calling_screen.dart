import 'package:flutter/material.dart';
import 'data.dart';

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
      Navigator.pop(context);
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
