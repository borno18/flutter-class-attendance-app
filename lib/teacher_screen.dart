import 'package:flutter/material.dart';
import 'data.dart';
import 'class_screen.dart';

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
