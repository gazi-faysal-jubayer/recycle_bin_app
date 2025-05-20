import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const LoadingIndicator({
    Key? key,
    this.size = 32.0,
    this.color,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? Theme.of(context).colorScheme.primary,
              strokeWidth: 3.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}