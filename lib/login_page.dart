import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sphoneshipping/model/shippingModel.dart';
import 'package:sphoneshipping/screen/shippingScreen.dart';

import 'network/networkApi.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  bool _isObscure = false;
  late String orderID;
  late String secretKey;
  late Future<Shipping> shipping;
  late Shipping shipping1;
  bool showSpinner = false;


  @override
  void initState(){
    super.initState();
    _isObscure=true;
  }


  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            radius: 56.0,
            child: Image.asset('assets/S-Phone_cpfelx.png'),
          )
      ),
    );
    final labelInfo = Padding(padding: EdgeInsets.only(bottom: 10),child: TextButton(child: Text('SPhone Shipping', style: TextStyle(color: Colors.black, fontSize: 24,fontFamily: 'RaleWay'),),onPressed: null,),);
    final inputOrderId = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value)=> orderID = value,
        decoration: InputDecoration(
            hintText: 'Order ID',
            labelText: 'Order ID',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );
    final inputSecretKey = Padding(
      padding: EdgeInsets.only(bottom: 10),
        child: TextField(
          obscureText: _isObscure,
          textAlign: TextAlign.center,
          onChanged: (value)=> secretKey = value,
          decoration: InputDecoration(
            border:OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            hintText: "Secret Key",
            labelText: "Secret Key",
            helperStyle:TextStyle(color:Colors.green),
            suffixIcon: IconButton(
              icon: Icon(_isObscure
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(
                      () {
                    _isObscure = !_isObscure;
                  },
                );
              },
            ),
            alignLabelWithHint: false,
            filled: true,
          ),
        ),
    );
    final buttonVerifi = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 70,
        child: ElevatedButton(
          child: Text('Xác thực', style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed:() => {
            setState(() {
              showSpinner = true;
            }),
            getShipping(int.parse(orderID), secretKey).then((value) => {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShippingScreen(shipping:value,secretKey:secretKey))),
            }),
            setState(() {
              showSpinner = false;
            }),
          },
        ),
      ),
    );
    final buttonForgotKey = TextButton(
      onPressed: () {  },
      child: Center(
        child: Text('Liên hệ với người quản trị SPhone để nhận Order ID và Secret Key', style: TextStyle(color: Colors.grey, fontSize: 16),textAlign: TextAlign.center,),
      )
    );
    return SafeArea(
      child:ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                logo,
                labelInfo,
                inputOrderId,
                inputSecretKey,
                buttonVerifi,
                buttonForgotKey
              ],
            ),
          ),
        ),
      ),
    );
  }
}