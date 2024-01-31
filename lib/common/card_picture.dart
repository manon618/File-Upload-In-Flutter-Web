import 'dart:io';
import 'package:flutter/material.dart';

class CardPicture extends StatelessWidget {
  CardPicture({this.onTap, this.imagePath, this.onRemove});

  final Function()? onTap;
  final Function()? onRemove;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (imagePath != null) {
      return Card(
        child: Container(
          height: 50,
          padding: EdgeInsets.all(10.0),
          width: size.width * .70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(File(imagePath as String)),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 2.0,
                    )
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    if (onRemove != null) {
                      onRemove!();
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
          width: size.width * .70,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attach student photo',
                style: TextStyle(fontSize: 17.0, color: Colors.grey[600]),
              ),
              Icon(
                Icons.photo_camera,
                color: Colors.indigo[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
