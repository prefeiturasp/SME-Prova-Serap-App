import 'package:appserap/main.route.gr.dart';
import 'package:appserap/utils/router.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ErrorPage extends StatelessWidget {
  final String? error;
  const ErrorPage({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_PAGE.ERRO.toTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? ""),
            TextButton(
              onPressed: () {
                context.router.navigate(HomeViewRoute());
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
