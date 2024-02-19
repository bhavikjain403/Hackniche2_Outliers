import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget(
      {Key? key,
      required this.assetName,
      required this.label,
      required this.subtitle})
      : super(key: key);
  final String assetName;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetName,
            semanticsLabel: 'No Data',
            height: 210,
            width: 210,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
