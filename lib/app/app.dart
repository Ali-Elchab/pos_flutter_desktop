import 'package:flutter/material.dart';
import 'package:pos_flutter_desktop/app/router.dart';
import 'package:pos_flutter_desktop/app/theme.dart';

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'POS Desktop',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
