import 'package:flutter/material.dart';

class CustomImageDetails extends StatelessWidget {
  const CustomImageDetails({super.key, required this.image, required this.label});
  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.label),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          this.image,
        ),
      ),
    );
  }
}
