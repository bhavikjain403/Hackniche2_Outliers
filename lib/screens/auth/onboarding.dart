import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nomnom/controller/login_controller.dart';
import 'package:nomnom/screens/home/home_screen.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/enums.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/form_item.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return FocusedLayout(
        isScrollable: true,
        child: Column(
          children: [
            Text(
              'NomNom.',
              style: TextStyle(
                  fontSize: 26,
                  color: AppColors.orangeAccent,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.pacifico().fontFamily),
            ),
            Lottie.asset('assets/images/anim1.json'),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Login & Explore The Best Dishes In Town 🍟🍕🌭🥪 ....',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    // fontFamily: GoogleFonts.pacifico().fontFamily),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FormItem(
                        icon: Icon(FluentIcons.mail_16_regular),
                        question: 'Email',
                        controller: controller.usernameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your username';
                          }
                          // Check if the entered email has the right format
                          // final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                          // if (!validCharacters.hasMatch(value)) {
                          //   return 'Username cannot have special characters';
                          // }
                          // Return null if the entered email is valid
                          return null;
                        },
                      ),
                      FormItem(
                        icon: Icon(FluentIcons.lock_closed_16_regular),
                        isPwd: true,
                        // obscureText: true,
                        controller: controller.pwdController,
                        //obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          // if (value.trim().length < 8) {
                          //   return 'Password must be at least 8 characters in length';
                          // }
                          // Return null if the entered password is valid
                          return null;
                        },
                        question: 'Password',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.orangeAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.login(
                                  username: controller.usernameController.text,
                                  password: controller.pwdController.text);
                            }
                          },
                          child: Center(
                              child: Obx(
                            () => controller.loginState.value ==
                                    OzoneState.loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                          )),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
