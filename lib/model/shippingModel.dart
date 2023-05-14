// ignore_for_file: file_names

class Shipping{


  String? shipperName, shipperID, shipperPhone, image1, image2, image3, customerName, customerPhone, address, orderName;
  double? total;
  bool? statusPayment;
  int? state, orderID;
  List<dynamic>? carts;

  Shipping.fromJson(Map<String, dynamic> json){
    shipperName = json['shipperName'];
    shipperID = json['shipperID'];
    shipperPhone = json['shipperID'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    state = json['state'];
    orderID = json['orderID'];
    carts = json['carts'];
    orderName = json['orderName'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    address = json['address'];
    statusPayment = json['statusPayment'];
    total = json['total'];
  }

  Map<String, dynamic> toJson(){
    final Map< String, dynamic> data = new Map<String, dynamic>();
    data['shipperName'] = this.shipperName;
    return data;
  }
}

class Cart{
  String? productName, productImage;
  int? quantity;

  Cart.fromJson(Map<String, dynamic> json){
    productName = json['productName'];
    productImage = json['productImage'];
    quantity = json['quantity'];
  }
}