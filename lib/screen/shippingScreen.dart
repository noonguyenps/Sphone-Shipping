// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/shippingModel.dart';
import 'package:intl/intl.dart';

import 'confirmShippingScreen.dart';

class ShippingScreen extends StatelessWidget{

  const ShippingScreen({super.key, required this.shipping, required this.secretKey});
  final Shipping shipping;
  final String secretKey;
  final bool showSpinner = false;


  @override
  Widget build(BuildContext context) {
    final container = Container(
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0)),
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Row(
              children: <Widget>[
                new Expanded (
                  flex:6,
                  child : Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      new Text("Đang giao hàng",textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize: 24,fontFamily: 'RaleWay')),
                      SizedBox(height: 10,),
                      new Text("Thanh toán bằng phương thức Thanh toán khi nhận hàng. Đơn hàng đang trên đường vận chuyển",textAlign: TextAlign.start,style: TextStyle(color: Colors.black, fontSize: 16,fontFamily: 'RaleWay')),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                new Expanded(
                  flex :2,
                  child: Column(
                    children: <Widget>[
                      Hero(
                          tag: 'hero',
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.amber,
                            child: Image.asset('assets/shipper.png'),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );

    final address = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Row(
            children: <Widget>[
              new Expanded (
                flex:2,
                child : Column(
                  children: <Widget>[
                    Hero(
                        tag: 'hero1',
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/address.png'),
                        )
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.only(right: 10),),
              new Expanded(
                flex :8,
                child: Column(
                  children: <Widget>[
                    new Text("Tên : "+shipping.customerName.toString(),style: TextStyle(color: Colors.black, fontSize: 18,fontFamily: 'RaleWay')),
                    new Text("SĐT : "+shipping.customerPhone.toString(), style: TextStyle(color: Colors.grey, fontSize: 18,fontFamily: 'RaleWay')),
                    new Text("Địa chỉ : "+shipping.address.toString(), style: TextStyle(color: Colors.grey, fontSize: 16,fontFamily: 'RaleWay')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


    final listViewInfo = Card(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child:Text('Hình ảnh',textAlign: TextAlign.center,)),
                new Expanded(
                  flex: 6,
                  child: Text('Tên sản phẩm',textAlign: TextAlign.center,),
                ),
                new Expanded(
                  flex: 1,
                  child: Text('Số lượng',textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
      ),
    );

    final listView = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: shipping.carts?.length,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Row(
                children: <Widget>[
                  new Expanded(
                    flex: 3,
                    child:Hero(
                        tag: '21456'+position.toString(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Image.network(shipping.carts?.elementAt(position)['productImage']),
                        )
                    ),
                  ),
                  new Expanded(
                    flex: 6,
                    child: Text(shipping.carts?.elementAt(position)['productName'],textAlign: TextAlign.center,),
                  ),
                  new Expanded(
                    flex: 1,
                    child: Text((shipping.carts?.elementAt(position)['quantity']).toString(),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );


    final padding = Padding(padding: EdgeInsets.only(bottom: 10),);

    String total(String a){
      dynamic b = double.parse(a);
      var formatter = NumberFormat('###,###,000');
      return formatter.format(b);
    }

    final confirmButton = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 70,
        child: ElevatedButton(
          child: Text('Tiến hành giao hàng', style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed:() => {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfirmShippingScreen(shipping:shipping,secretKey: secretKey,)))
            }),
        ),
      );

    // Use the Todo to create the UI.
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child:Scaffold(
        appBar: AppBar(
          title: Text("Chi tiết đơn hàng"),
        ),
        body:SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    container,
                    padding,
                    address,
                    padding,
                    Text('Danh sách sản phẩm',textAlign: TextAlign.left,),
                    listViewInfo,
                    listView,
                    SizedBox(height: 20,),
                    Text('Tổng : '+total((shipping?.total).toString())+" VND",style: TextStyle(color: Colors.red, fontSize: 20,fontFamily: 'RaleWay') ,),
                    SizedBox(height: 20,),
                    confirmButton,
                ],
              ),
            ),
        ),
      ),
    );
  }

  setState(Null Function() param0) {}
}