import 'package:flutter/material.dart';



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = 'Welcome to Flutter Intern Blog!';
  void changeMessage(){
    setState((){
      message='Welcome to Intern Blog!';
    });
  }
  void changeMessage2(){
    setState((){
      message='Welcome Blog!';
    });
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Intern Blog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          )
        )
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
              message,
              
              style : const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
             ),
             SizedBox(height: 100),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  'Aung Aung',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: 20),
              Text('Admin'),
              ],
             ),
             SizedBox(height: 30),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  'Mg Mg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
              Text('User'),
              ],
             ),
             SizedBox(height: 30),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  'Ko Ko',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
              Text('Moderator'),
              ],
             ),
             SizedBox(height: 30),
             Row(
              mainAxisAlignment:MainAxisAlignment.center,
               children: [
                 ElevatedButton(
                  onPressed: changeMessage,
                  child: const Text(
                    'Click Me',
                    style: TextStyle(fontSize : 20),
                  ),
                 ),
                 ElevatedButton(
              onPressed: changeMessage2,
              child: const Text(
                'Another Click',
                style: TextStyle(fontSize: 20),
              ),
             ),
               ],
             ),
          
             
            ],
          ),
        ),
      ),
    );
  }
}