// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'package:sphoneshipping/model/shippingModel.dart';

Future<Shipping> getShipping(int orderId, String secretKey) async{
  final res = await http.get(Uri.parse('https://phone-s.herokuapp.com/api/shipping/'+orderId.toString()+'?secretKey='+secretKey));
  if(res.statusCode == 200){
    Map<String,dynamic> response = json.decode(utf8.decode(res.bodyBytes));
    Map<String,dynamic> shipping = response['data']['shipping'];

    String address = "";
    final resCommune =  await http.get(Uri.parse('https://provinces.open-api.vn/api/w/'+shipping['commune']));
    if(resCommune.statusCode == 200){
      Map<String,dynamic> responseCommune = json.decode(utf8.decode(resCommune.bodyBytes));
      address+=" , "+responseCommune['name'];
    }
    final resDistrict =  await http.get(Uri.parse('https://provinces.open-api.vn/api/d/'+shipping['district']));
    if(resDistrict.statusCode == 200){
      Map<String,dynamic> responseDistrict = json.decode(utf8.decode(resDistrict.bodyBytes));
      address+=" , "+responseDistrict['name'];
    }
    final resProvince =  await http.get(Uri.parse('https://provinces.open-api.vn/api/p/'+shipping['province']));
    if(resProvince.statusCode == 200){
      Map<String,dynamic> responseProvince = json.decode(utf8.decode(resProvince.bodyBytes));
      address+=" , "+responseProvince['name'];
    }
    shipping['address']= shipping['addressDetail']+address;
    return compute(parseShipping, shipping);
  }
  else{
    Fluttertoast.showToast(
        msg: "Order ID hoặc Secret Key bị sai. Vui lòng liên hệ với Quản trị viên để giải đáp",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 16.0
    );
    throw Exception('Request API error');
  }

}

Shipping parseShipping(Map<String,dynamic> resBody){
  Shipping shipping = Shipping.fromJson(resBody);
  return shipping;
}

