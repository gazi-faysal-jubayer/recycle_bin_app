import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../../../models/item.dart';

class ItemCard extends StatelessWidget {
  final RecycleItem item;
  final VoidCallback? onTap;

  const ItemCard({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.pushNamed(
            context, 
            Routes.itemDetails,
            arguments: item,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.imageUrls.isNotEmpty
                  ? Image.network(
                      item.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(item.recyclableType),
                              size: 48,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(item.recyclableType),
                          size: 48,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
            ),
            
            // Item info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${item.estimatedValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Category and recyclable status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.recyclableType.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.isRecyclable)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Recyclable',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Brief description
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plastic':
        return Icons.local_drink;
      case 'paper':
        return Icons.article;
      case 'glass':
        return Icons.wine_bar;
      case 'metal':
        return Icons.settings;
      case 'electronics':
        return Icons.devices;
      case 'organic':
        return Icons.eco;
      default:
        return Icons.recycling;
    }
  }
}