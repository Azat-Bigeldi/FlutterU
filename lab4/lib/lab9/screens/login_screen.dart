import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/settings/settings_cubit.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  /// Экран каталога, который открывается после успешного входа.
  final WidgetBuilder catalogBuilder;

  const LoginScreen({super.key, required this.catalogBuilder});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthCubit>();
    if (_isRegister) {
      auth.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      );
    } else {
      auth.login(_emailController.text, _passwordController.text);
    }
  }

  void _toggleMode() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _passwordController.clear();
    _confirmController.clear();
    setState(() => _isRegister = !_isRegister);
  }

  // Разовые побочные эффекты: SnackBar и навигация.
  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: FlipColors.red,
            content: Text(state.message),
          ),
        );
    } else if (state is AuthSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (_isRegister) {
        context.read<SettingsCubit>().updateDisplayName(state.username);
      }
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: widget.catalogBuilder));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 72,
                  color: FlipColors.blue,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Flip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: FlipColors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isRegister
                      ? 'Создайте аккаунт'
                      : 'Войдите, чтобы открыть каталог',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: FlipColors.grey),
                ),
                const SizedBox(height: 32),
                if (_isRegister) ...[
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: _isRegister
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onSubmitted: _isRegister ? null : (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Повторите пароль',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: _onAuthStateChanged,
                    // builder только строит виджеты.
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: FlipColors.yellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          _isRegister ? 'Зарегистрироваться' : 'Войти',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) => TextButton(
                    onPressed: state is AuthLoading ? null : _toggleMode,
                    child: Text(
                      _isRegister
                          ? 'Уже есть аккаунт? Войти'
                          : 'Нет аккаунта? Зарегистрироваться',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
