import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../resource/auth_methods.dart';
import '../responsive/responsive_layout.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import '../widgets/textfield_widget.dart';
import 'mobile_screen_layout.dart';
import 'signup_screen.dart';
import 'web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _email = "".obs;
  final _password = "".obs;
  bool _isLoading = false;
  final isVisible = false.obs;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _email.value, password: _password.value);
    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                // TextFieldInput(
                //   hintText: 'Enter your email',
                //   textInputType: TextInputType.emailAddress,
                //   textEditingController: _emailController,
                // ),
                Obx(
                  () => TextFieldWidget(
                    hintText: 'Email',
                    obscureText: false,
                    prefixIconData: Icons.mail_outline,
                    suffixIconData: _email.value.validEmail() ? Icons.check : null,
                    onChanged: (value) {
                      _email.value = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                // TextFieldInput(
                //   hintText: 'Enter your password',
                //   textInputType: TextInputType.text,
                //   textEditingController: _passwordController,
                //   isPass: true,
                // ),
                Obx(
                  () => TextFieldWidget(
                    hintText: 'Password',
                    obscureText: !isVisible.isFalse,
                    prefixIconData: Icons.lock_outline,
                    suffixIconData: isVisible.isTrue
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onChanged: (value) {
                      // model.isValidEmail(value);
                      _password.value = value;
                    },
                    onTapPostfixIcon: () {
                      isVisible.value = !isVisible.value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    alignment: Alignment.center,
                    // margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: !_isLoading
                        ? const Text('Log in', style: TextStyle(fontWeight: FontWeight.bold))
                        : const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(color: primaryColor, strokeWidth: 3.0),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/logo_instagram.png',
                    height: 64,
                    width: 64,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Don't have an account?",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: const Text(
                          ' Sign Up.',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
