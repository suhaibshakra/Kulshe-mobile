import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class FacebookPage extends StatefulWidget {
  @override
  _FacebookPageState createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {

  TextEditingController _emailControllerS = TextEditingController()..text;
  TextEditingController _phoneControllerS = TextEditingController()..text;
  TextEditingController _countryControllerS = TextEditingController()..text;




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => facebookLogin.isLoggedIn
                  .then((isLoggedIn) => isLoggedIn ? _logout() : {

              }),
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: isLoggedIn
                ? _displayUserData(profileData)
                : _displayLoginButton(),
          ),
        ),
      ),
    );
  }

  var facebookLogin = FacebookLogin();
  var profileData;
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult =
    await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        {
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult
                  .accessToken.token}');

          print('************************** ${facebookLoginResult
              .accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());

          onLoginStatusChanged(true, profileData: profile);
          print('NAME : ${profileData['name']}');
          print('EMAIL : ${profileData['email']}');
          print('TOKEN : ${facebookLoginResult.accessToken.token}');
          print('ID : ${facebookLoginResult.accessToken.userId}');
          // registerDialog(context: context,emailController:_emailControllerS,nickNameController: _nickNameControllerS,phoneController: _phoneControllerS,
          //     onPressed: (){
          //       print('Starting...');
          //       profileData['email'] == _emailControllerS.text.toString()?
          //       createAccountFunctionFacebook(
          //           '''{\r\n  "email": "${profileData['email']}",\r\n  "fbId": "${facebookLoginResult.accessToken.userId}",\r\n  "fbToken": "${facebookLoginResult.accessToken.token}",\r\n  "userImage": "${profileData['picture']['data']['url']}",\r\n  "mobileNumber": "${_phoneControllerS.text.toString()}"\r\n}'''
          //       ):viewToast(context,"Email must match facebook email !", Colors.red,Toast.CENTER);
          //     });
           break;
        }
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          "Logged in as: ${profileData['email']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  _displayLoginButton() {
    return RaisedButton(
      child: Text("Login with Facebook"),
      onPressed: () => initiateFacebookLogin(),
    );
  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}
