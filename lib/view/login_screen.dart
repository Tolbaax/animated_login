import 'dart:developer';

import 'package:animated_login/shared/animation_enum.dart';
import 'package:animated_login/shared/text_form_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerLookLeft;
  final formKey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();
  String testEmail = 'tolba@gmail.com';
  String testPassword = '123456';
  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    log('Idle');
  }

  void addHandsUppController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    log('Hands Up');
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    log('Hands Down');
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    log('Success');
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    log('Fail');
  }

  void addLookRightController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerLookRight);
    isLookingRight = true;
    log('Look Right');
  }

  void addLookLeftController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerLookLeft);
    isLookingLeft = true;
    log('Look Left');
  }

  void checkPasswordFocusNode() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUppController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);

    rootBundle.load('assets/animated_bear.riv').then(
      (value) {
        final file = RiveFile.import(value);
        final artboard = file.mainArtboard;
        artboard.addController(controllerIdle);
        setState(() {
          riveArtboard = artboard;
        });
      },
    );
    checkPasswordFocusNode();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(milliseconds: 750), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w / 20),
          child: Column(
            children: [
              SizedBox(
                height: h / 3.15,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(artboard: riveArtboard!),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    DefaultTextFormFiled(
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      label: 'email',
                      validator: (value) =>
                          value != testEmail ? 'Wrong email' : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !isLookingLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !isLookingRight) {
                          addLookRightController();
                        }
                      },
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    DefaultTextFormFiled(
                      focusNode: passwordFocusNode,
                      label: 'password',
                      obscureText: true,
                      validator: (value) =>
                          value != testPassword ? 'Wrong Password' : null,
                    ),
                    SizedBox(
                      height: h * 0.07,
                    ),
                    Container(
                      width: w * 1,
                      height: h * 0.07,
                      margin: EdgeInsets.symmetric(horizontal: w / 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blueGrey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          passwordFocusNode.unfocus();
                          validateEmailAndPassword();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
