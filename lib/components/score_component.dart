// libs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

//pages
import 'package:main_project/components/layout_component.dart ';
import 'package:main_project/components/layout_component_header.dart';
import 'package:main_project/components/score_gauge.dart';



class ScoreComponent extends StatefulWidget {
  final int gameId;

  const ScoreComponent({super.key, required this.gameId});

  @override
  State<ScoreComponent> createState() => _ScoreComponentState();
}

class _ScoreComponentState extends State<ScoreComponent> {
  double fetchedScore = 0;
  String fetchedName = "";

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('data_files/Data.json');
    final data = await jsonDecode(response);

    setState(() {
      fetchedScore = data["games"][widget.gameId]["score"];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Expanded(
        child: LayoutComponent(
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const LayoutComponentHeader(),

              ScoreGauge(value: fetchedScore),
            ],
          ),
        )
    );
  }
}
