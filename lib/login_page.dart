import 'package:flutter/material.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Kullanıcı adı ve şifre doğrulama işlemleri
      final username = _usernameController.text;
      final password = _passwordController.text;

      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [username, password],
      );

      if (result.isNotEmpty) {
        // Başarılı giriş işlemi
        // Örnek olarak kullanıcı listesini gösterelim
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListPage()),
        );
      } else {
        // Geçersiz giriş
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('Geçersiz kullanıcı adı veya şifre.'),
              actions: [
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kullanıcı adı boş olamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Şifre boş olamaz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Giriş'),
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Listesi'),
      ),
      body: Center(
        child: Text('Kullanıcı listesi burada görüntülenecek'),
      ),
    );
  }
}
