import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;


class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);
  @override
  _ShopState createState() => _ShopState();
}
class _ShopState extends State<Shop> {

  getData() async {
    await firestore.collection('product').add({ 'name' : '바지' });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임!!'),
    );
  }
}



