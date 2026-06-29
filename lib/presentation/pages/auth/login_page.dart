import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dkg_icons.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _pw = '';
  bool _showPw = false;
  bool _gLoading = false;

  bool get _valid => _email.contains('@') && _pw.length >= 4;

  Future<void> _loginWithGoogle() async {
    setState(() => _gLoading = true);
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _gLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null && mounted) {
        context.read<AuthBloc>().add(AuthLoginWithFirebase(idToken));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Google gagal'), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _gLoading = false);
    }
  }

  Future<void> _loginWithEmail() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _pw,
      );
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null && mounted) {
        context.read<AuthBloc>().add(AuthLoginWithFirebase(idToken));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login gagal.'), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthNeedsVerification) {
          context.go('/2fa/smtp');
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Gradient header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    24, MediaQuery.of(context).padding.top + 24, 24, 40,
                  ),
                  child: Column(
                    children: [
                      const AppLogo(size: 64, light: true, withText: true),
                      const SizedBox(height: 20),
                      const Text(
                        'Selamat datang kembali',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Google button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final loading = state is AuthLoading || _gLoading;
                          return AppButton(
                            label: 'Lanjut dengan Google',
                            onPressed: loading ? null : _loginWithGoogle,
                            variant: AppButtonVariant.outline,
                            icon: _GoogleIcon(),
                            isLoading: loading,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(children: [
                        const Expanded(child: Divider(color: AppColors.line)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('atau email',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate400,
                              )),
                        ),
                        const Expanded(child: Divider(color: AppColors.line)),
                      ]),
                      const SizedBox(height: 20),
                      AppField(
                        label: 'Email',
                        value: _email,
                        onChanged: (v) => setState(() => _email = v),
                        placeholder: 'nama@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(DkgIcons.mail, size: 20),
                      ),
                      const SizedBox(height: 14),
                      AppField(
                        label: 'Kata sandi',
                        value: _pw,
                        onChanged: (v) => setState(() => _pw = v),
                        obscureText: !_showPw,
                        placeholder: '••••••••',
                        prefixIcon: const Icon(DkgIcons.lock, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_showPw ? DkgIcons.eyeOff : DkgIcons.eye,
                              size: 20, color: AppColors.slate400),
                          onPressed: () => setState(() => _showPw = !_showPw),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Lupa kata sandi?',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              )),
                        ),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) => AppButton(
                          label: 'Masuk',
                          onPressed: _valid ? _loginWithEmail : null,
                          isLoading: state is AuthLoading,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? ',
                              style: TextStyle(fontSize: 14, color: AppColors.slate500)),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: const Text('Daftar',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                )),
                          ),
                        ],
                      ),
                    ],
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

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.g_mobiledata_rounded, size: 24, color: Colors.red),
      ),
    );
  }
}
