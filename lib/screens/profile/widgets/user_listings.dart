import 'package:flutter/material.dart';
import '../../../models/item.dart';

class UserListings extends StatelessWidget {
  const UserListings({Key? key}) : super(key: key);

  // Mock data - in a real app this would come from a service
  List<RecycleItem> get _items => [
        RecycleItem(
          id: '1',
          name: 'Plastic Bottles',
          description: 'Collection of empty plastic bottles, cleaned and ready for recycling.',
          categoryId: '1',
          userId: 'current-user-id',
          imageUrls: ['assets/images/bottles.jpg'],
          isRecyclable: true,
          recyclableType: 'plastic',
          estimatedValue: 2.50,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        RecycleItem(
          id: '2',
          name: 'Cardboard Boxes',
          description: 'Flattened cardboard boxes from recent deliveries.',
          categoryId: '2',
          userId: 'current-user-id',
          imageUrls: ['assets/images/cardboard.jpg'],
          isRecyclable: true,
          recyclableType: 'paper',
          estimatedValue: 1.75,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return _items.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.recycling,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You haven\'t added any items yet',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForType(item.recyclableType),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    'Value: \$${item.estimatedValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit item screen
                    },
                  ),
                  onTap: () {
                    // Navigate to item details screen
                  },
                ),
              );
            },
          );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
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