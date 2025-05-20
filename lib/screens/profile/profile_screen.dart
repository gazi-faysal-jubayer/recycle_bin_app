import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/user_listings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading profile...')
          : _user == null
              ? const Center(child: Text('Failed to load profile'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: _user!.profileImage != null
                                  ? null // Image would go here
                                  : Text(
                                      _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '?',
                                      style: const TextStyle(fontSize: 32, color: Colors.white),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _user!.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              _user!.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Recycling Points'),
                                  Text(
                                    '${_user!.recyclePoints} pts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: _user!.recyclePoints / 1000, // Assuming 1000 is the max
                                color: Theme.of(context).colorScheme.primary,
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Keep recycling to earn more points!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Favorite Categories',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _user!.favoriteCategories.map((category) {
                          return Chip(
                            label: Text(category),
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'My Recycling Items',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const UserListings(),
                    ],
                  ),
                ),
    );
  }
}