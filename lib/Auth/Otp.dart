import 'dart:async';

import 'package:dyeus/Auth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  String phone;
  OtpScreen(this.phone);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with SingleTickerProviderStateMixin{
  bool firstStateEnabled = false;
  final CountdownController controller = CountdownController();
  final int seconds = 2;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController _mpinController = TextEditingController();
  bool validateOTP = false;
  bool _visible = false;
  bool _onCLick = true;
  String? _verificationCode;
  int? _resendToken;
  late AnimationController _animationController;
  late Animation _colorTween;
  FocusNode _focusNode = FocusNode();
  bool hidePIN = true;
  bool validatePIN = false;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(30, 60, 87, 1);

    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 70, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            SizedBox(
              height: 5.h,
            ),
            Text(
              '  Enter OTP',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28.sp),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                'A six digit code has been sent to +91 ' + widget.phone,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  Incorrect number?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: HexColor('#2C3234')),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Change',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: HexColor('#BFFB62')),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: AnimatedBuilder(
            //         animation: _colorTween,
            //         builder: (context, child) {
            //           return Pinput(
            //             focusNode: _focusNode,
            //             obscureText: hidePIN,
            //             controller: _mpinController,
            //             length: 6,
            //             closeKeyboardWhenCompleted: true,
            //             androidSmsAutofillMethod:
            //             AndroidSmsAutofillMethod.smsUserConsentApi,
            //             listenForMultipleSmsOnAndroid: true,
            //             pinAnimationType: PinAnimationType.scale,
            //             defaultPinTheme: defaultPinTheme,
            //             showCursor: true,
            //             cursor: cursor,
            //             preFilledWidget: preFilledWidget,
            //             autofocus: true,
            //             onChanged: (value) {},
            //             onCompleted: (value) {
            //               setState(() {
            //                 validatePIN = true;
            //               });
            //             },
            //           );
            //         },
            //       ),
            //     ),
            //     SizedBox(width: 8,),
            //     Container(
            //       height: 40,
            //       width: 40,
            //       decoration: BoxDecoration(
            //         color: Colors.transparent,
            //         borderRadius: BorderRadius.circular(5),
            //         border: Border.all(
            //           color: Colors.transparent,
            //           width: 1,
            //         ),
            //       ),
            //       child: Center(
            //         child: IconButton(
            //           icon: Icon(
            //             hidePIN
            //                 ? Icons.visibility_rounded
            //                 : Icons.visibility_off_rounded,
            //             color: const Color(0xFF222744),
            //             size: 24,
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               hidePIN = !hidePIN;
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            OtpTextField(
              numberOfFields: 6,
              autoFocus: true,
              fieldWidth: 50,
              borderColor: HexColor('#9B9B9B'),
              disabledBorderColor: HexColor('#2C3234'),
              focusedBorderColor: HexColor('#2C3234'),
              showFieldAsBox: false,
              borderWidth: 2.0,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here if necessary
              },
              //runs when every textfield is filled
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Otp verified')));
                      // Timer(Duration(seconds: 3), () {
                      //   Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => LoginScreen()),
                      //           (route) => false);
                      // });
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
                setState(() {
                  validateOTP = true;
                });

              },
            ),
            SizedBox(
              height: 7.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      onTap: () {
                        print('tapped');
                        _verifyPhone();
                        Fluttertoast.showToast(
                          msg: 'OTP sent successfully',
                          textColor: Colors.white,
                          backgroundColor: const Color(0xFF222744),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                        );
                        // _onCLick
                        //     ? null
                        //     : () {
                        //   setState(() { _onCLick = false;
                        //     print('tapped');
                        //   Fluttertoast.showToast(
                        //     msg: 'OTP sent successfully',
                        //     textColor: Colors.white,
                        //     backgroundColor: const Color(0xFF222744),
                        //     toastLength: Toast.LENGTH_LONG,
                        //     gravity: ToastGravity.BOTTOM,
                        //   );
                        //   }
                        //   ); //
                        // };
                      },
                      child: Container(
                          height: 60,
                          width: 350,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: HexColor('#BFFB62')),
                          child: Center(
                              child: Text(
                            'Resend OTP',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ))),
                    )
                    ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resend OTP in  ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TweenAnimationBuilder(
                  tween: Tween(begin: 30.0, end: 0.0),
                  duration: Duration(seconds: 30),
                  builder: (_, dynamic value, child) => Text(
                    "00:${value.toInt()}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onEnd: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("user ${value.user}");
              // Timer(Duration(seconds: 3), () {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (context) => LoginScreen()),
              //           (route) => false);
              // });
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
            _resendToken = resendToken;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout:const Duration(seconds: 30),
      forceResendingToken: _resendToken,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    _verifyPhone();
  }
}
