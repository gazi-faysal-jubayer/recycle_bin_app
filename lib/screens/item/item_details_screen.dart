import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../core/utils/formatters.dart';
import '../../models/item.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import 'add_item_screen.dart';
import 'widgets/image_carousel.dart';

class ItemDetailsScreen extends StatefulWidget {
  final RecycleItem item;

  const ItemDetailsScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isOwner = false;
  
  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }
  
  Future<void> _checkOwnership() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _isOwner = currentUser.id == widget.item.userId;
        });
      }
    } catch (e) {
      // If there's an error, assume user is not the owner
      if (mounted) {
        setState(() {
          _isOwner = false;
        });
      }
    }
  }

  Future<void> _deleteItem() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false;
    
    if (!confirm) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Delete item implementation
      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate deletion
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _editItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(itemToEdit: widget.item),
      ),
    );
    
    // Refresh the screen if item was updated
    if (result == true) {
      // In a real app, you'd fetch the updated item from the API
      // For now, we'll just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<void> _contactOwner() async {
    // TODO: Implement chat initialization with item owner
    Navigator.pushNamed(context, Routes.chat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          if (_isOwner)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _editItem();
                } else if (value == 'delete') {
                  _deleteItem();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Processing...')
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  ImageCarousel(
                    imageUrls: widget.item.imageUrls,
                    aspectRatio: 16 / 9,
                  ),
                  
                  // Item details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '\$${widget.item.estimatedValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Recyclable type and status
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.item.recyclableType.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.item.isRecyclable)
                              Row(
                                children: [
                                  const Icon(
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
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Description card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.item.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Date and info
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  Icons.calendar_today,
                                  'Posted on',
                                  Formatters.formatDate(widget.item.createdAt),
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  Icons.category,
                                  'Category',
                                  widget.item.recyclableType.capitalize(),
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  Icons.recycling,
                                  'Recycling status',
                                  widget.item.isRecyclable ? 'Recyclable' : 'Not recyclable',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Contact/Edit button
                        if (!_isOwner)
                          CustomButton(
                            text: 'Contact Owner',
                            iconData: Icons.message,
                            onPressed: _contactOwner,
                          )
                        else
                          CustomButton(
                            text: 'Edit Item',
                            iconData: Icons.edit,
                            onPressed: _editItem,
                          ),
                          
                        if (_isOwner) ...[
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Delete Item',
                            iconData: Icons.delete,
                            color: Colors.red,
                            onPressed: _deleteItem,
                            isOutlined: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? this[0].toUpperCase() + substring(1) : '';
  }
}