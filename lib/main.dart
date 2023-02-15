// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const appTitle = 'Form Validation Demo';

//     return MaterialApp(
//       title: appTitle,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(appTitle),
//         ),
//         body: const MyCustomForm(),
//       ),
//     );
//   }
// }

// // Create a Form widget.
// class MyCustomForm extends StatefulWidget {
//   const MyCustomForm({super.key});

//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }

// // Create a corresponding State class.
// // This class holds data related to the form.
// class MyCustomFormState extends State<MyCustomForm> {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a GlobalKey<FormState>,
//   // not a GlobalKey<MyCustomFormState>.
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController loginController = TextEditingController();
//   bool apiCall = false; // New variable

//   // @override
//   // void dispose() {
//   //   // Clean up the controller when the widget is disposed.
//   //   loginController.dispose();
//   //   super.dispose();
//   // }

//   // void _callWeatherApi() {
//   //   // http.get(Uri.parse('http://192.168.192.205:8000/main/get_users'));

//   //   http.post(Uri.parse('http://192.168.192.205:8000/main/login_from_mobile'));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             // The validator receives the text that the user has entered.
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),

//           TextFormField(
//             controller: loginController,
//             // The validator receives the text that the user has entered.
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text2';
//               }
//               return null;
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 // showDialog(
//                 //     context: context,
//                 //     builder: (context) {
//                 //       return AlertDialog(content: Text(loginController.text));
//                 //     });
//                 // Validate returns true if the form is valid, or false otherwise.
//                 // if (_formKey.currentState!.validate()) {
//                 //   // If the form is valid, display a snackbar. In the real world,
//                 //   // you'd often call a server or save the information in a database.
//                 //   ScaffoldMessenger.of(context).showSnackBar(
//                 //     const SnackBar(content: Text('Processing Data')),
//                 //   );
//                 // }

//                 // setState(() {
//                 //   apiCall = true; // Set state like this
//                 // });
//                 _callWeatherApi();
//               },
//               child: const Text('Войти'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }