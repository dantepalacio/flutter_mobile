// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:last/bloc/authentication_bloc.dart';
// import 'package:last/HomePage.dart';
// import 'package:last/login.dart';
// import 'package:last/repository/user_repository.dart';
// import 'package:last/simple_bloc_delegate.dart';
// // import 'package:last/splash_screen.dart';
// // import 'package:last/repository/chat_repository.dart';


// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   // BlocSupervisor.delegate = SimpleBlocDelegate();
//   final UserRepository userRepository = UserRepository();

//   runApp(
//     BlocProvider(
//       create: (context) =>
//           AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
//       child: App(userRepository: userRepository),
//     ),
//   );
// }

// class App extends StatelessWidget {
//   final UserRepository _userRepository;

//   App({Key key, @required UserRepository userRepository})
//       : assert(userRepository != null),
//         _userRepository = userRepository,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           if (state is Uninitialized) {
//             return SplashScreen();
//           }
//           if (state is Unauthenticated) {
//             return LoginScreen(
//               userRepository: _userRepository,
//             );
//           }
//           if (state is Authenticated) {
//             final ChatRepository _chatRepository =
//                 ChatRepository(state.sessionId);
//             return HomeScreen(
//                 name: state.displayName,
//                 sessionId: state.sessionId,
//                 chatRepository: _chatRepository);
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }