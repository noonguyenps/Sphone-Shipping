// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:sphoneshipping/login_page.dart';
import '../model/shippingModel.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmShippingScreen extends StatefulWidget {

  const ConfirmShippingScreen(
      {super.key, required this.shipping, required this.secretKey});

  final Shipping shipping;
  final String secretKey;

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState(shipping,secretKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận giao hàng"),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}
class _UploadImageScreenState extends State<ConfirmShippingScreen> {

  final Shipping shipping;
  final String secretKey;
  File? image,image2,image3;
  List<String>? urls = [];

  final _picker = ImagePicker();
  bool showSpinner = false;

  _UploadImageScreenState(this.shipping, this.secretKey);

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 10);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
      });
    } else {
      print('no image selected');
    }
  }
  Future getImage2() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 10);
    if (pickedFile != null) {
      image2 = File(pickedFile.path);
      setState(() {
      });
    } else {
      print('no image selected');
    }
  }

  Future getImage3() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 10);
    if (pickedFile != null) {
      image3 = File(pickedFile.path);
      setState(() {
      });
    } else {
      print('no image selected');
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var uri = Uri.parse(
        'https://phone-s.herokuapp.com/api/shipping/uploadImg/' +
            shipping.orderID.toString() + '?secretKey=' + secretKey);

    if (image == null && image2 == null && image3 == null) {
      Fluttertoast.showToast(msg: "Thêm ít nhất 1 hình ảnh",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (image != null) {
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes(
          'file', image!.readAsBytesSync(), filename: 'image.jpg',));
        final response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.toBytes();
          var responseString = json.decode(utf8.decode(responseData));
          urls?.add(responseString['data']['url']);
        }
      }
      if (image2 != null) {
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes(
          'file', image2!.readAsBytesSync(), filename: 'image.jpg',));
        final response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.toBytes();
          var responseString = json.decode(utf8.decode(responseData));
          urls?.add(responseString['data']['url']);
        }
      }
      if (image3 != null) {
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes(
          'file', image3!.readAsBytesSync(), filename: 'image.jpg',));
        final response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.toBytes();
          var responseString = json.decode(utf8.decode(responseData));
          urls?.add(responseString['data']['url']);
        }
      }
    }

    String updateUrl = 'https://phone-s.herokuapp.com/api/shipping/update/'+shipping.orderID.toString()+'?secretKey='+secretKey;
    for(int i = urls!.length;i>0;i--){
      if(i==3) updateUrl+='&img3='+Uri.encodeComponent(urls![i-1]);
      else if(i==2) updateUrl+='&img2='+Uri.encodeComponent(urls![i-1]);
      else if(i==1) updateUrl+='&img1='+Uri.encodeComponent(urls![i-1]);
    }
    print(updateUrl);
    final res = await http.put(Uri.parse(updateUrl));
    if(res.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Giao hàng thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
    else {
      Fluttertoast.showToast(
          msg: "Giao hàng thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    setState(() {
        showSpinner = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Xác nhận giao hàng'),
        ),
        body: SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:Text("Hình ảnh giao hàng thứ nhất :",style: TextStyle(color: Colors.black, fontSize: 18))),
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  child: image == null ? Center(
                    child: Container(
                      height: 250,
                      width: 250,
                      child: ButtonTheme(
                        height: 50,
                        minWidth: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () { getImage(); },
                          child:Text('Chọn hình ảnh',style: TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      )
                    ),
                  ):
                        Container(
                            child: Center(
                              child: Image.file(
                                File(image!.path).absolute,
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                      ),
              ),

              SizedBox(height: 10,),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child:Text("Hình ảnh giao hàng thứ hai :",style: TextStyle(color: Colors.black, fontSize: 18))),

              GestureDetector(
                onTap: () {
                  getImage2();
                },
                child: Container(
                  child: image2 == null ? Center(
                    child: Container(
                        height: 250,
                        width: 250,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            onPressed: () { getImage2(); },
                            child:Text('Chọn hình ảnh',style: TextStyle(color: Colors.black, fontSize: 18)),
                          ),
                        )
                    ),
                  ):
                  Container(
                    child: Center(
                      child: Image.file(
                        File(image2!.path).absolute,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child:Text("Hình ảnh giao hàng thứ ba :",style: TextStyle(color: Colors.black, fontSize: 18))),

              GestureDetector(
                onTap: () {
                  getImage3();
                },
                child: Container(
                  child: image3 == null ? Center(
                    child: Container(
                        height: 250,
                        width: 250,
                        child: ButtonTheme(
                          height: 50,
                          minWidth: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            onPressed: () { getImage3(); },
                            child:Text('Chọn hình ảnh',style: TextStyle(color: Colors.black, fontSize: 18)),
                          ),
                        )
                    ),
                  ):
                  Container(
                    child: Center(
                      child: Image.file(
                        File(image3!.path).absolute,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.green,
                  child: ButtonTheme(child: Center(
                    child: Text('Xác nhận giao hàng',style: TextStyle(color: Colors.white, fontSize: 20))),
                  )
                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}