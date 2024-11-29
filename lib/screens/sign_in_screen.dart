import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // TODO 1:. Deklarasikan variabel
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordCintroller = TextEditingController();
  late String _errorText ='';
  late bool _isSignnedIn = false;
  bool _obscurePassword = true;

  void _signIn()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedUsername = prefs.getString('username')?? '';
    final String savedPassword = prefs.getString('password')?? '';
    final String enteredUsername = _usernameController.text.trim();
    final String enteredPassword = _passwordCintroller.text.trim();

    if (enteredUsername == savedUsername && enteredPassword == savedPassword){
      setState(() {
        _errorText = "";
        _isSignnedIn = true;
        prefs.setBool('isSignnedIn', true);
      });
      //   pemanggilan untuk menghapus semua halaman dalam tumpulkan navigasi
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).popUntil((route)=>route.isFirst);
      });
      //   sign in berhasil, navigasi ke layar utama
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacementNamed(context, '/');
      });

    }
    if(savedUsername.isEmpty || savedPassword.isEmpty){
      setState(() {
        _errorText = 'Pengguna belum terdaftar. silakan daftar terlebih dahulu';
      });
    }

    else {
      setState(() {
        _errorText = 'Nama pengguna atau kata sandi salah';
      });
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO : 2. Pasang AppBar
      appBar: AppBar(title: Text('Sign In'),),
      // TODO : 3. Pasang body
      body: Center(
        child:SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  // TODO : 4. Atur MainAxisAlignment dan crossAxisAlignment
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TODO : 5. Pasang TextFromField Nama Pengguna
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Nama Pengguna",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // TODO : 6. Pasang TextFromField Kata Sandi
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordCintroller,
                      decoration: InputDecoration(
                          labelText: "Kata Sandi",
                          errorText: _errorText.isNotEmpty ? _errorText: null,
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off
                                  : Icons.visibility,
                            ),)
                      ),
                      obscureText: _obscurePassword,
                    ),
                    // TODO : 7. Pasang ElevatedButton Sign In
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: (){}, child: Text('Sign In')),
                    // TODO: 8. Pasang TextButton Sign up
                    SizedBox(height: 10),
                    //TextButton(onPressed: (){}, child: Text('Belum Punya Akun? Daftar di sini'))
                    RichText(
                        text: TextSpan(
                            text: 'Belum punya akun?',
                            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Daftar di sini',
                                style: TextStyle(
                                    color: Colors.blue, //Warna untuk text yang bisa di tekan
                                    decoration: TextDecoration.underline,
                                    fontSize: 16
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                  Navigator.pushNamed(context, '/signup');
                                  },
                              )
                            ]
                        ))
                  ],
                ),
              ),
            )),
      ),
    );

  }
}
