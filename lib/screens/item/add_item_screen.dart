import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../models/item.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_indicator.dart';

class AddItemScreen extends StatefulWidget {
  final RecycleItem? itemToEdit; // Pass this if editing an existing item

  const AddItemScreen({Key? key, this.itemToEdit}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _imagePicker = ImagePicker();
  
  String _selectedCategory = '';
  String _recyclableType = '';
  bool _isRecyclable = true;
  bool _isLoading = false;
  bool _isEditing = false;
  
  final List<File> _imageFiles = [];
  final List<String> _existingImageUrls = [];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    // Check if we're editing an existing item
    if (widget.itemToEdit != null) {
      _isEditing = true;
      // Populate form with existing data
      _nameController.text = widget.itemToEdit!.name;
      _descriptionController.text = widget.itemToEdit!.description;
      _valueController.text = widget.itemToEdit!.estimatedValue.toString();
      _selectedCategory = widget.itemToEdit!.categoryId;
      _recyclableType = widget.itemToEdit!.recyclableType;
      _isRecyclable = widget.itemToEdit!.isRecyclable;
      _existingImageUrls.addAll(widget.itemToEdit!.imageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  void _removeImage(int index) {
    if (index < _imageFiles.length) {
      setState(() {
        _imageFiles.removeAt(index);
      });
    } else {
      // Remove from existing URLs if not a new local file
      final urlIndex = index - _imageFiles.length;
      if (urlIndex < _existingImageUrls.length) {
        setState(() {
          _existingImageUrls.removeAt(urlIndex);
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_imageFiles.isEmpty && _existingImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    
    if (_recyclableType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a recyclable type')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Upload images to storage service
      // TODO: Create or update item in database
      
      // Mock success after a delay for now
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.of(context).pop(true); // Return success to previous screen
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing 
                ? 'Item updated successfully'
                : 'Item added successfully'),
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
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Item' : 'Add Recycling Item'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Processing...')
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Images section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Item Images',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_imageFiles.isNotEmpty || _existingImageUrls.isNotEmpty)
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _imageFiles.length + _existingImageUrls.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: index < _imageFiles.length
                                                ? Image.file(
                                                    _imageFiles[index],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    _existingImageUrls[index - _imageFiles.length],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const Center(
                                                        child: Icon(Icons.broken_image),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: InkWell(
                                            onTap: () => _removeImage(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Gallery'),
                                  onPressed: _pickImage,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Camera'),
                                  onPressed: _takePhoto,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Basic information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Item Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'Item Name',
                            validator: (value) => Validators.validateRequired(
                              value,
                              'Item name',
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _descriptionController,
                            labelText: 'Description',
                            maxLines: 3,
                            validator: Validators.validateItemDescription,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _valueController,
                            labelText: 'Estimated Value (\$)',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an estimated value';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Recycling information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recycling Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedCategory.isEmpty ? null : _selectedCategory,
                            items: AppConstants.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'] as String,
                                child: Text(category['name'] as String),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Recyclable Type',
                              border: OutlineInputBorder(),
                            ),
                            value: _recyclableType.isEmpty ? null : _recyclableType,
                            items: const [
                              DropdownMenuItem(value: 'plastic', child: Text('Plastic')),
                              DropdownMenuItem(value: 'paper', child: Text('Paper')),
                              DropdownMenuItem(value: 'glass', child: Text('Glass')),
                              DropdownMenuItem(value: 'metal', child: Text('Metal')),
                              DropdownMenuItem(value: 'electronics', child: Text('Electronics')),
                              DropdownMenuItem(value: 'organic', child: Text('Organic')),
                              DropdownMenuItem(value: 'other', child: Text('Other')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _recyclableType = value ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Item is recyclable'),
                            subtitle: Text(
                              _isRecyclable
                                  ? 'This item can be recycled'
                                  : 'This item cannot be recycled',
                            ),
                            value: _isRecyclable,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (value) {
                              setState(() {
                                _isRecyclable = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Submit button
                  CustomButton(
                    text: _isEditing ? 'Update Item' : 'Add Item',
                    iconData: Icons.check_circle,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
    );
  }
}