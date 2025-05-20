import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(category['name']),
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
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