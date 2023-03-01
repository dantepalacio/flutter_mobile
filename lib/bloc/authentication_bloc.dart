// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:equatable/equatable.dart';

// import 'package:last/repository/user_repository.dart';
// import 'package:last/api_connection/api_connection.dart';

// part 'authentication_event.dart';

// part 'authentication_state.dart';

// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationState> {
//   // AuthenticationBloc(super.initialState);

//   Type createState() => AuthenticationState;
//   late final UserRepository _userRepository;

//   AuthenticationBloc({required UserRepository userRepository})
//       : assert(userRepository != null),
//       _userRepository = userRepository;


//   AuthenticationState get initialState => Uninitialized();

//   @override
//   Stream<AuthenticationState> mapEventToState(
//     AuthenticationEvent event,
//   ) async* {
//     // if (event is AppStarted) {
//     //   yield* _mapAppStartedToState();
//     // }
//     // if (event is LoggedIn) {
//     //   yield* _mapLoggedInToState();
//     // }
//     if (event is LoggedOut) {
//       yield* _mapLoggedOutToState();
//     }
//   }

//   // Stream<AuthenticationState> _mapAppStartedToState() async* {
//   //   final isSignedIn = await _userRepository.isSignedIn();
//   //   if (isSignedIn) {
//   //     final name = await _userRepository.getUser();
//   //     final sessionId = await createSession();
//   //     yield Authenticated(name, sessionId);
//   //   } else {
//   //     yield Unauthenticated();
//   //   }
//   // }

//   // Stream<AuthenticationState> _mapLoggedInToState() async* {
//   //   yield Authenticated(await _userRepository.getUser(), await createSession());
//   // }

//   Stream<AuthenticationState> _mapLoggedOutToState() async* {
//     _userRepository.signOut();
//     yield Unauthenticated();
//   }
// }
