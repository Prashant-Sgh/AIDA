import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationViewModelProvider =
    StateNotifierProvider<AuthenticationViewModel, AuthenticationState>(
  (ref) => AuthenticationViewModel(),
);

class AuthenticationViewModel extends StateNotifier<AuthenticationState> {
  AuthenticationViewModel() : super(AuthenticationState());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  void setEmail(String value) {
    final isValid = isValidEmail(value);

    _emailController.text = value;

    state = state.copyWith(
      email: value,
      isEmailValid: isValid,
    );
  }

  void setPassword(String value) {
    _passwordController.text = value;
    state = state.copyWith(password: value);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> login() async {
    // Perform authentication logic here
    // You can use the email and password variables for authentication
    // Update the authentication status in the state
    state = state.copyWith(authenticated: true);
  }
}

class AuthenticationState {
  AuthenticationState({
    this.email = '',
    this.password = '',
    this.authenticated = false,
    this.isEmailValid = false,
  });

  final String email;
  final String password;
  final bool authenticated;
  final bool isEmailValid;

  AuthenticationState copyWith({
    String? email,
    String? password,
    bool? authenticated,
    bool? isEmailValid,
  }) {
    return AuthenticationState(
      email: email ?? this.email,
      password: password ?? this.password,
      authenticated: authenticated ?? this.authenticated,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}
