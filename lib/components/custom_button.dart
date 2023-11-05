import 'package:flutter/material.dart';
import '../utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          ApiConfig.apiConfigChange();
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              return Utils.themeColor;
            },
          ),
          side: MaterialStateProperty.all(
              const BorderSide(color: Colors.grey, width: 1)),
        ),
        child: const Text('换源'),
      ),
    );
  }
}
