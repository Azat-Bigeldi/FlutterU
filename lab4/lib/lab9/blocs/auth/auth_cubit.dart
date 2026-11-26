import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/account_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static const String validEmail = 'student@narxoz.kz';
  static const String validPassword = '123456';

  /// Имитация задержки сети.
  final Duration delay;

  final AccountStorage accounts;

  AuthCubit({this.delay = const Duration(seconds: 2), AccountStorage? accounts})
    : accounts = accounts ?? AccountStorage(),
      super(const AuthInitial());

  Future<void> login(String email, String password) async {
    // Повторное нажатие во время запроса игнорируется.
    if (state is AuthLoading) return;

    emit(const AuthLoading());
    await Future<void>.delayed(delay);
    if (isClosed) return;

    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty || password.isEmpty) {
      emit(const AuthError('Введите email и пароль'));
    } else if (cleanEmail == validEmail && password == validPassword) {
      emit(
        AuthSuccess(username: cleanEmail.split('@').first, email: cleanEmail),
      );
    } else {
      final name = await accounts.findName(cleanEmail, password);
      if (isClosed) return;
      emit(
        name == null
            ? const AuthError('Неверный email или пароль')
            : AuthSuccess(username: name, email: cleanEmail),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());
    await Future<void>.delayed(delay);
    if (isClosed) return;

    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();

    String? error;
    if (cleanName.isEmpty || cleanEmail.isEmpty || password.isEmpty) {
      error = 'Заполните все поля';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(cleanEmail)) {
      error = 'Некорректный email';
    } else if (password.length < 6) {
      error = 'Пароль должен быть не короче 6 символов';
    } else if (password != confirmPassword) {
      error = 'Пароли не совпадают';
    } else if (cleanEmail == validEmail || await accounts.exists(cleanEmail)) {
      error = 'Такой email уже зарегистрирован';
    }
    if (isClosed) return;
    if (error != null) {
      emit(AuthError(error));
      return;
    }

    await accounts.save(name: cleanName, email: cleanEmail, password: password);
    if (isClosed) return;
    emit(AuthSuccess(username: cleanName, email: cleanEmail));
  }
}
