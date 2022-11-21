import 'package:flutter/material.dart';
import 'package:ssoft_estoque/util/Util.dart';

class WidgetProgress extends StatefulWidget {
  const WidgetProgress({Key? key}) : super(key: key);

  @override
  State<WidgetProgress> createState() => _WidgetProgressState();
}

class _WidgetProgressState extends State<WidgetProgress> {
  @override
  Widget build(BuildContext context) {
    Util cores = Util();
    return CircularProgressIndicator(
      color: cores.cor_app_bar,
      backgroundColor: cores.laranja_teccel,
    );
  }
}
