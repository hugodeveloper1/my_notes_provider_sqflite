import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.value = '',
    this.width,
  });

  final double? width;
  final VoidCallback onPressed;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Colors.amberAccent.shade100,
        ),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        elevation: const MaterialStatePropertyAll(6),
        shadowColor: const MaterialStatePropertyAll(
          Colors.black12,
        ),
        fixedSize: MaterialStatePropertyAll(
          width != null ? Size(width!, 45) : const Size.fromHeight(45),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
      ),
    );
  }
}
