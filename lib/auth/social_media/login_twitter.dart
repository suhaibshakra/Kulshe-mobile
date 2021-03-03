// import 'package:flutter/material.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
//
//
// class LoginTwitter extends StatefulWidget {
//   @override
//   _LoginTwitterState createState() => _LoginTwitterState();
// }
//
// class _LoginTwitterState extends State<LoginTwitter> {
//   static final TwitterLogin twitterLogin = TwitterLogin(
//     consumerKey: 'b2kq7YrCif82toVknRSyb8eDv',
//     consumerSecret: 'HlcA4ysniXgtuDeDPf1zanZpHc1lnFL4BBpmZAjLVx0yS1m3jj',
//   );
//
//   String _title="";
//
//   void _login() async {
//     final TwitterLoginResult result = await twitterLogin.authorize();
//     String Message;
//
//     switch (result.status) {
//       case TwitterLoginStatus.loggedIn:
//         Message = 'Logged in! username: ${result.session.username}';
//         break;
//       case TwitterLoginStatus.cancelledByUser:
//         Message = 'Login cancelled by user.';
//         break;
//       case TwitterLoginStatus.error:
//         Message = 'Login error: ${result.errorMessage}';
//         break;
//     }
//
//     setState(() {
//       _title = Message;
//     });
//   }
//
//   void _logout() async {
//     await twitterLogin.logOut();
//
//     setState(() {
//       _title = 'Logged out.';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF167F67),
//           title: Text('Twitter login sample'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(_title),
//               _title.isEmpty
//                   ? RaisedButton(
//                 child: Text('Log in'),
//                 onPressed: _login,
//               )
//                   : SizedBox(
//                 width: 0.0,
//               ),
//               _title.isNotEmpty?  RaisedButton(
//                 child: Text('Log out'),
//                 onPressed: _logout,
//               ):SizedBox(width: 0.0,),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }