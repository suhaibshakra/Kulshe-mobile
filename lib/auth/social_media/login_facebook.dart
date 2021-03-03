// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'package:kulshe/api/api_functions.dart';
// import 'package:kulshe/utilities/app_helpers/my_widgets.dart';
//
// class FacebookPage extends StatefulWidget {
//   @override
//   _FacebookPageState createState() => _FacebookPageState();
// }
//
// class _FacebookPageState extends State<FacebookPage> {
//   TextEditingController _nickNameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//   bool isLoggedIn = false;
//   var profileData;
//   var facebookLogin = FacebookLogin();
//
//
//   void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
//     setState(() {
//       this.isLoggedIn = isLoggedIn;
//       this.profileData = profileData;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Facebook Login"),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 Icons.exit_to_app,
//                 color: Colors.white,
//               ),
//               onPressed: () => facebookLogin.isLoggedIn
//                   .then((isLoggedIn) => isLoggedIn ? _logout() : {
//
//               }),
//             ),
//           ],
//         ),
//         body: Container(
//           child: Center(
//             child: isLoggedIn
//                 ? _displayUserData(profileData)
//                 : _displayLoginButton(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void initiateFacebookLogin() async {
//     var facebookLoginResult =
//     await facebookLogin.logIn(['email']);
//
//     switch (facebookLoginResult.status) {
//       case FacebookLoginStatus.error:
//         onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         onLoginStatusChanged(false);
//         break;
//       case FacebookLoginStatus.loggedIn:
//         {
//           var graphResponse = await http.get(
//               'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult
//                   .accessToken.token}');
//
//           print('************************** ${facebookLoginResult
//               .accessToken.token}');
//
//           var profile = json.decode(graphResponse.body);
//           print(profile.toString());
//
//           onLoginStatusChanged(true, profileData: profile);
//           print('NAME : ${profileData['name']}');
//           print('EMAIL : ${profileData['email']}');
//           print('TOKEN : ${facebookLoginResult.accessToken.token}');
//           print('ID : ${facebookLoginResult.accessToken.userId}');
//           // registerDialog(context: context,emailController:_emailController,nickNameController: _nickNameController,phoneController: _phoneController,
//           //     onPressed: (){
//           //       print('Starting...');
//           //       profileData['email'] == _emailController.text.toString()?
//           //   createAccountFunctionFacebook(
//           //       '''{\r\n  "email": "${profileData['email']}",\r\n  "fbId": "${facebookLoginResult.accessToken.userId}",\r\n  "fbToken": "${facebookLoginResult.accessToken.token}",\r\n  "nickName": "${profileData['name']}",\r\n  "comeFrom": "m",\r\n  "userImage": "${profileData['picture']['data']['url']}",\r\n  "mobileNumber": "${_phoneController.text.toString()}",\r\n  "mobileCountryPhoneCode": "962",\r\n  "mobileCountryIsoCode": "JO",\r\n  "countryId": "110"\r\n}'''
//           //      // '''{\n  "email": "${profileData['email']}",\n  "fbId": "${facebookLoginResult.accessToken.userId}",\n  "fbToken": "${facebookLoginResult.accessToken.token}",\n  "nickName": "${profileData['name']}",\n  "comeFrom": "m",\n  "userImage": "${facebookLoginResult.accessToken.token}",\n  "mobileNumber": "${_phoneController.text.toString()}",\n  "mobileCountryPhoneCode": "962",\n  "mobileCountryIsoCode": "JO",\n  "countryId": '110'\n}\n'''
//           //   ):viewToast("Email must match facebook email !", Colors.red);
//           // });
//           print('Email ${_emailController.text.toString()} \nName : ${_nickNameController.text.toString()} \nphone:${_phoneController.text.toString()}\nid: ${facebookLoginResult.accessToken.userId}\n'
//               '');
//           break;
//         }
//     }
//   }
//
//   _displayUserData(profileData) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           height: 200.0,
//           width: 200.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image: NetworkImage(
//                 profileData['picture']['data']['url'],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 28.0),
//         Text(
//           "Logged in as: ${profileData['name']}",
//           style: TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//         Text(
//           "Logged in as: ${profileData['email']}",
//           style: TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//       ],
//     );
//   }
//
//   _displayLoginButton() {
//     return RaisedButton(
//       child: Text("Login with Facebook"),
//       onPressed: () => initiateFacebookLogin(),
//     );
//   }
//
//   _logout() async {
//     await facebookLogin.logOut();
//     onLoginStatusChanged(false);
//     print("Logged out");
//   }
// }
// // import 'dart:async';
// //
// // import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// // import 'package:flutter/material.dart';
// //
// // class FacebookPage extends StatefulWidget {
// //   @override
// //   _FacebookPageState createState() => new _FacebookPageState();
// // }
// //
// // class _FacebookPageState extends State<FacebookPage> {
// //   static final FacebookLogin facebookSignIn = new FacebookLogin();
// //
// //   String _message = 'Log in/out by pressing the buttons below.';
// //
// //   Future<Null> _login() async {
// //     final FacebookLoginResult result =
// //     await facebookSignIn.logIn(['email']);
// //     switch (result.status) {
// //       case FacebookLoginStatus.loggedIn:
// //         final FacebookAccessToken accessToken = result.accessToken;
// //         _showMessage('''
// //          Logged in!
// //
// //          Token: ${accessToken.token}
// //          User id: ${accessToken.userId}
// //          User name: ${accessToken.userId}
// //          Expires: ${accessToken.expires}
// //          Permissions: ${accessToken.permissions}
// //          Declined permissions: ${accessToken.declinedPermissions}
// //          ''');
// //         break;
// //       case FacebookLoginStatus.cancelledByUser:
// //         _showMessage('Login cancelled by the user.');
// //         break;
// //       case FacebookLoginStatus.error:
// //         _showMessage('Something went wrong with the login process.\n'
// //             'Here\'s the error Facebook gave us: ${result.errorMessage}');
// //         break;
// //     }
// //   }
// //
// //   Future<Null> _logOut() async {
// //     await facebookSignIn.logOut();
// //     _showMessage('Logged out.');
// //   }
// //
// //   void _showMessage(String message) {
// //     setState(() {
// //       _message = message;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return new MaterialApp(
// //       home: new Scaffold(
// //         appBar: new AppBar(
// //           title: new Text('Plugin example app'),
// //         ),
// //         body: new Center(
// //           child: new Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               new Text(_message),
// //               new RaisedButton(
// //                 onPressed: _login,
// //                 child: new Text('Log in'),
// //               ),
// //               new RaisedButton(
// //                 onPressed: _logOut,
// //                 child: new Text('Logout'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }