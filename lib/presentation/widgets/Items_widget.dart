import 'package:breaking_project/constants/colors.dart';
import 'package:breaking_project/data/models/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemWidget extends StatelessWidget {
  final Items item;
  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.infinity,
    //   margin: EdgeInsetsDirectional.fromSTEB(
    //     8,
    //     8,
    //     8,
    //     8,
    //   ),
    //   padding: EdgeInsetsDirectional.all(4),
    //   decoration: BoxDecoration(
    //     color: AppColors.white,
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   child: GridTile(
    //     child: Container(
    //         color: AppColors.grey,
    //         child: SvgPicture.asset('assets/images/svg/plumber.svg')

    //         //  item.image.isNotEmpty
    //         //     ? FadeInImage.assetNetwork(
    //         //         width: double.infinity,
    //         //         height: double.infinity,
    //         //         fit: BoxFit.cover,
    //         //         placeholder: 'assets/images/gif/loading2.gif',
    //         //         placeholderFit: BoxFit.contain,
    //         //         image: item.image)
    //         //     : Image.asset('assets/images/png/whennotload.png')

    //         ),
    //     footer: Container(
    //       width: double.infinity,
    //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //       color: Colors.black54,
    //       alignment: Alignment.bottomCenter,
    //       child: Text(
    //         "${item.description}",
    //         style: TextStyle(
    //             height: 1.3,
    //             fontSize: 16,
    //             color: AppColors.white,
    //             fontWeight: FontWeight.bold),
    //         overflow: TextOverflow.ellipsis,
    //         maxLines: 2,
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ),
    // );

    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 98,
            height: 75,
            child: Transform.scale(
              scale: 0.6,
              child: SvgPicture.asset(
                'assets/images/svg/home.svg',

                // fit: BoxFit.cover,
              ),
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 222, 222),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
          ),
          Container(
            width: 98,
            height: 34,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: Center(
                child: Text(
              "Smart Home",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          )
        ],
      ),
    );
  }
}
