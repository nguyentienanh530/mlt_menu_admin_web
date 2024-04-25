import 'package:mlt_menu_admin/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class PrintSetting extends StatelessWidget {
  const PrintSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Cài đặt máy in',
          style:
              context.textStyleMedium!.copyWith(fontWeight: FontWeight.bold)));
}
