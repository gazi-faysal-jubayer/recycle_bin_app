import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_indicator.dart';

enum AuthMode { login, register }

class AuthForm extends StatefulWidget {
  final AuthMode authMode;
  final bool isLoading;
  final String? errorMessage;
  final Function(String email, String password, [String? name]) onSubmit;
  final VoidCallback onToggleAuthMode;

  const AuthForm({
    Key? key,
    required this.authMode,
    required this.isLoading,
    this.errorMessage,
    required this.onSubmit,
    required this.onToggleAuthMode,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    if (widget.authMode == AuthMode.login) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = widget.authMode == AuthMode.login;
    final isRegister = widget.authMode == AuthMode.register;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Center(
            child: Icon(
              Icons.recycling,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isLogin ? 'Welcome Back!' : 'Join Recycle Bin',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (isRegister)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                validator: Validators.validateName,
                prefixIcon: Icons.person,
              ),
            ),
          CustomTextField(
            controller: _emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            obscureText: true,
            validator: Validators.validatePassword,
            prefixIcon: Icons.lock,
          ),
          if (isRegister)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
                validator: _validateConfirmPassword,
                prefixIcon: Icons.lock_outline,
              ),
            ),
          if (isLogin)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password logic
                },
                child: const Text('Forgot Password?'),
              ),
            ),
          const SizedBox(height: 24),
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          widget.isLoading
              ? const LoadingIndicator()
              : CustomButton(
                  text: isLogin ? 'Login' : 'Sign Up',
                  onPressed: _submit,
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isLogin ? "Don't have an account?" : 'Already have an account?'),
              TextButton(
                onPressed: widget.onToggleAuthMode,
                child: Text(isLogin ? 'Sign Up' : 'Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}