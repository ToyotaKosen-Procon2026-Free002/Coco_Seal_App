import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final Map<String, String> errorMessage = {
    "email-already-in-use": "指定したメールアドレスは登録済みです",
    "invalid-email": "メールアドレスのフォーマットが正しくありません",
    "operation-not-allowed": "指定したメールアドレス・パスワードは現在使用できません",
    "weak-password": "パスワードは6文字以上にしてください",
    "user-disabled": "そのメールアドレスは利用できません",
    "user-not-found": "メールアドレスまたはパスワードが違います",
    "wrong-password": "メールアドレスまたはパスワードが違います",
    "channel-error": "入力が不正です",
    "invalid-credential": "メールアドレスまたはパスワードが違います"
  };

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;


  void login() async {
    setState(() {
      loading = true;
    });
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage[e.code] ?? e.code),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }

    setState(() {
      loading = false;
    });
  }


  void signup() async {
    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage[e.code] ?? e.code),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }

    setState(() {
      loading = false;
    });
  }


  void signInWithGoogle() async {
    setState(() {
      loading = true;
    });

    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage[e.code] ?? e.code),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    } on GoogleSignInException {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Googleアカウントでのログインを取り消しました"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text("ログイン"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "メールアドレス"),
              enabled: !loading,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "パスワード"),
              enabled: !loading,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading ? null : login,
              child: const Text("ログイン"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: loading ? null : signup,
              child: const Text("サインアップ"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: loading ? null : signInWithGoogle,
              child: const Text("Googleアカウントでログイン"),
            )
          ],
        ),
      )
    );
  }
}
