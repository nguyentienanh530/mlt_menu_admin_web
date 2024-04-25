import 'package:flutter/material.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';

class ItemChildOfOrderInfo extends StatelessWidget {
  const ItemChildOfOrderInfo({super.key, this.icon, this.title, this.value});
  final IconData? icon;
  final String? title;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(children: [
          Container(
              // margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: context.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: context.colorScheme.secondary.withOpacity(0.8))),
              child: Icon(icon, color: context.colorScheme.secondary)),
          const SizedBox(width: 16),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title ?? '',
                    style: context.textStyleMedium!
                        .copyWith(color: Colors.white.withOpacity(0.3))),
                Text(value ?? '',
                    style: context.titleStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold))
              ])
        ]));
  }
}
