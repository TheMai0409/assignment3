import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(
          image: NetworkImage(
              'https://media.istockphoto.com/photos/shopping-cart-full-of-food-on-yellow-background-grocery-and-food-picture-id1316968335?k=20&m=1316968335&s=170667a&w=0&h=UuwMp7I9IMqbsMGfkVm4s7Q5v5VFveW3NyjWnlPvKPA='),
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            child: const Text(
              "ĐI CHỢ TIỆN \n LỢI HƠN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.grey,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
