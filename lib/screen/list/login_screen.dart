import 'package:elbazar_app/screen/list/auth_screen.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Log in to account',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            Text(
              'Enter your details below',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            TextFormField(
              decoration: InputDecoration(
                  label: Text(
                'Email',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              )),
            ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       label: Text(
            //     'Password',
            //     style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //         color: Theme.of(context).colorScheme.onBackground),
            //   )),
            // ),
            TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                label: Text(
                  'Password',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: const Color.fromRGBO(219, 68, 68, 1),
                        foregroundColor:
                            const Color.fromRGBO(250, 250, 250, 1)),
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => TabsScreen()));
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Haven\'t account?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ));
                    },
                    child: const Text('Register'))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
