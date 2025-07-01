import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evo Systems',
              style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          centerTitle: true,
          leading: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)
            ),
            child: SvgPicture.asset(
              'assets/icons/left-arrow-svgrepo-com.svg',
              height: 20,
              width: 20,
            )
          ),

          actions: [
            Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            // ignore: sort_child_properties_last
            child: SvgPicture.asset(
              'assets/icons/dots-horizontal-alt-svgrepo-com.svg',
              width: 37,
            ),
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)
            )
          )
          ],

        )
      );
    }
  }