import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatTime(timestamp),
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}