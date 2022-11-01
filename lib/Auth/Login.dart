import 'dart:async';

import 'package:dyeus/Auth/Otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _phonesignin = TextEditingController();
  TextEditingController _phonesignup = TextEditingController();
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  bool _validate = false;
  var _formKey = GlobalKey<FormState>();
  var _formKey1 = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: HexColor('#E2E2E2'),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TabBar(
                  splashFactory: InkRipple.splashFactory,
                  splashBorderRadius: BorderRadius.all(Radius.circular(20)),
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontFamily:
                        GoogleFonts.inter(fontWeight: FontWeight.w700).fontFamily,
                    color: Colors.black,
                    fontSize: 10.sp,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily:
                        GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
                    color: Colors.black,
                    fontSize: 10.sp,
                  ),
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: HexColor('#BFFB62'),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  controller: _tabController,
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: <Widget>[
                    const Tab(text: 'Signin'),
                    const Tab(text: 'Signup'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  //signin
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          'Welcome Back!!',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 28.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Please login with your phone number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: AssetImage('assets/img.png'),
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: HexColor('#9B9B9B'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 35,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 1,
                                    color: HexColor('#9B9B9B'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: _phonesignin,
                                      focusNode: _focusNode,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: HexColor('#9B9B9B')),
                                      ),
                                      maxLines: 1,
                                      minLines: 1,
                                      validator: (input) {
                                        if (input!.isEmpty ||
                                            input!.length < 10) {
                                          return 'Enter proper phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        RoundedLoadingButton(
                          width: 500,
                          color: HexColor('#BFFB62'),
                          child: Text('Continue',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                          controller: _btnController1,
                          onPressed: () {
                            Timer(Duration(seconds: 1), () {
                              _btnController1.success();
                            });
                            if (_formKey.currentState!.validate()) {
                              // sendsigninOTP(_phonesignin.text.toString(),context);
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(_phonesignin.text.toString())));
                            }
                          },
                          successColor: HexColor('#BFFB62'),
                          resetDuration: Duration(seconds: 3),
                          resetAfterDuration: true,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '  --------------------------------  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#E2E2E2')),
                            ),
                            Text(
                              '  OR  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: HexColor('#2C3234'),
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '   ---------------------------------',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#E2E2E2')),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#F5FFF3'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 22.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_1.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                Text(
                                  ' Metamask',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#F5FFF3'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_2.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                Text(
                                  ' Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#100F0F'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 26.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_3.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                Text(
                                  ' Apple',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#2C3234')),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                _tabController
                                    .animateTo((_tabController.index + 1) % 2);
                              },
                              child: Text(
                                'Signup',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: HexColor('#BFFB62')),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          'Welcome to App',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 28.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Please signup with your phone number to get registered',
                          textScaleFactor: 1.1,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: AssetImage('assets/img.png'),
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: HexColor('#9B9B9B'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 35,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 1,
                                    color: HexColor('#9B9B9B'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Form(
                                    key: _formKey1,
                                    child: TextFormField(
                                      controller: _phonesignup,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: HexColor('#9B9B9B')),
                                      ),
                                      maxLines: 1,
                                      minLines: 1,
                                      validator: (input) {
                                        if (input!.isEmpty ||
                                            input!.length < 10) {
                                          return 'Enter proper phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        RoundedLoadingButton(
                          width: 500,
                          color: HexColor('#BFFB62'),
                          child: Text('Continue',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                          controller: _btnController2,
                          onPressed: () {
                            Timer(Duration(seconds: 1), () {
                              _btnController2.success();
                            });
                            if (_formKey1.currentState!.validate()) {
                              sendsignupOTP();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(_phonesignup.text.toString())));
                            }
                          },
                          successColor: HexColor('#BFFB62'),
                          resetDuration: Duration(seconds: 3),
                          resetAfterDuration: true,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '  --------------------------------  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#E2E2E2')),
                            ),
                            Text(
                              '  OR  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: HexColor('#2C3234'),
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '   ---------------------------------',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#E2E2E2')),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#F5FFF3'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 22.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_1.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                Text(
                                  ' Metamask',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#F5FFF3'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_2.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 14),
                                ),
                                Text(
                                  ' Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: HexColor('#100F0F'),
                                border: Border.all(
                                  color: HexColor('#E2E2E2'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 26.w,
                                ),
                                Image(
                                  image: AssetImage('assets/img_3.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Connect to',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                Text(
                                  ' Apple',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have an account?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, color: HexColor('#2C3234')),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                _tabController
                                    .animateTo((_tabController.index - 1) % 2);
                              },
                              child: Text(
                                'Signin',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: HexColor('#BFFB62')),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // signup
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
  // sendsigninOTP(String phone, BuildContext context) async{
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       verificationCompleted: _onVerificationCompleted,
  //       verificationFailed: _onVerificationFailed,
  //       codeSent: _onCodeSent,
  //       codeAutoRetrievalTimeout: _onCodeTimeout);
  // }
  //
  // _onVerificationCompleted(PhoneAuthCredential authCredential) async {
  //   print("verification completed ${authCredential.smsCode}");
  //   User? user = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     this.otpCode.text = authCredential.smsCode!;
  //   });
  //   if (authCredential.smsCode != null) {
  //     try{
  //       UserCredential credential =
  //       await user!.linkWithCredential(authCredential);
  //     }on FirebaseAuthException catch(e){
  //       if(e.code == 'provider-already-linked'){
  //         await _auth.signInWithCredential(authCredential);
  //       }
  //     }
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, Constants.homeNavigate, (route) => false);
  //   }
  // }
  //
  // _onVerificationFailed(FirebaseAuthException exception) {
  //   if (exception.code == 'invalid-phone-number') {
  //     showMessage("The phone number entered is invalid!");
  //   }
  // }
  //
  // _onCodeSent(String verificationId, int? forceResendingToken) {
  //   this.verificationId = verificationId;
  //   print(forceResendingToken);
  //   print("code sent");
  // }
  //
  // _onCodeTimeout(String timeout) {
  //   return null;
  // }

  // void showMessage(String errorMessage) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext builderContext) {
  //         return AlertDialog(
  //           title: Text("Error"),
  //           content: Text(errorMessage),
  //           actions: [
  //             TextButton(
  //               child: Text("Ok"),
  //               onPressed: () async {
  //                 Navigator.of(builderContext).pop();
  //               },
  //             )
  //           ],
  //         );
  //       }).then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  //
  // }
}


sendsignupOTP() async{

}
