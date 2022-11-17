import 'package:flutter/material.dart';
import 'package:iou/ui/i_tab.dart';
import 'package:iou/ui/o_tab.dart';
import 'package:iou/ui/u_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'I'),
              Tab(text: 'O'),
              Tab(text: 'U'),
            ],
          ),
          title: const Text('Track your IOUs'),
        ),
        body: TabBarView(
          children: [
            ITab(),
            OTab(),
            UTab(),
          ],
        ),
      ),
    );
  }
}
