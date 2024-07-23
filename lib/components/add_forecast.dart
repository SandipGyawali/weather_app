import "package:flutter/material.dart";

class AdditionalForeCast extends StatelessWidget {
  final String mode;
  final String val;
  final IconData icon;

  const AdditionalForeCast(this.mode, this.val, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(
            height: 8,
          ),
          Text(mode),
          const SizedBox(
            height: 8,
          ),
          Text(
            val,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
