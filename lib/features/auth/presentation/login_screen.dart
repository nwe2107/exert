import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../domain/repositories/auth_repository.dart';

const String _demoEmailHint = 'demo@exert.app';
const String _demoPasswordHint = 'exert1234';

const loginEmailFieldKey = Key('login_email_field');
const loginPasswordFieldKey = Key('login_password_field');
const loginConfirmPasswordFieldKey = Key('login_confirm_password_field');
const loginSubmitButtonKey = Key('login_submit_button');
const loginSignInModeButtonKey = Key('login_sign_in_mode_button');
const loginSignUpModeButtonKey = Key('login_sign_up_mode_button');

enum _AuthFormMode { signIn, signUp }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;
  _AuthFormMode _mode = _AuthFormMode.signIn;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usingFirebaseAuth = ref.watch(usingFirebaseAuthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _mode == _AuthFormMode.signIn
                              ? 'Sign in to continue'
                              : 'Create your account',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonal(
                                key: loginSignInModeButtonKey,
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _switchMode(_AuthFormMode.signIn),
                                child: const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.tonal(
                                key: loginSignUpModeButtonKey,
                                onPressed: _isSubmitting
                                    ? null
                                    : () => _switchMode(_AuthFormMode.signUp),
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (usingFirebaseAuth)
                          Text(
                            'Use your Firebase account credentials.',
                            style: theme.textTheme.bodyMedium,
                          )
                        else ...[
                          Text(
                            'Demo login: $_demoEmailHint',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'Password: $_demoPasswordHint',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 20),
                        TextFormField(
                          key: loginEmailFieldKey,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return 'Email is required.';
                            }
                            if (!email.contains('@')) {
                              return 'Enter a valid email.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          key: loginPasswordFieldKey,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            final password = value?.trim() ?? '';
                            if (password.isEmpty) {
                              return 'Password is required.';
                            }
                            return null;
                          },
                        ),
                        if (_mode == _AuthFormMode.signUp) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            key: loginConfirmPasswordFieldKey,
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (_mode != _AuthFormMode.signUp) {
                                return null;
                              }
                              final confirmPassword = value?.trim() ?? '';
                              if (confirmPassword.isEmpty) {
                                return 'Please confirm your password.';
                              }
                              if (confirmPassword !=
                                  _passwordController.text.trim()) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                          ),
                        ],
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          key: loginSubmitButtonKey,
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Submitting...'),
                                  ],
                                )
                              : Text(
                                  _mode == _AuthFormMode.signIn
                                      ? 'Sign In'
                                      : 'Create Account',
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(authRepositoryProvider);
      if (_mode == _AuthFormMode.signIn) {
        await repository.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await repository.signUpWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Failed to sign in. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _switchMode(_AuthFormMode nextMode) {
    if (nextMode == _mode) {
      return;
    }
    setState(() {
      _mode = nextMode;
      _errorMessage = null;
      _confirmPasswordController.clear();
    });
  }
}
