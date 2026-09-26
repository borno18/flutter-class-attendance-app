import 'package:flutter/material.dart';
import 'data.dart';

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
