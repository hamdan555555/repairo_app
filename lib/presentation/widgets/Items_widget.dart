import 'package:breaking_project/constants/colors.dart';
import 'package:breaking_project/data/models/items.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Items item;
  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(
        8,
        8,
        8,
        8,
      ),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridTile(
        child: Container(
            color: AppColors.grey,
            child: item.image.isNotEmpty
                ? FadeInImage.assetNetwork(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/gif/loading.gif',
                    image: item.image)
                : Image.asset('assets/images/png/whennotload.png')),
        footer: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: Text(
            "${item.description}",
            style: TextStyle(
                height: 1.3,
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
