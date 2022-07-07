import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    this.onPressed,
  });

  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onPressed,
        title: Center(
          child: Text(
            text ?? '',
            style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
