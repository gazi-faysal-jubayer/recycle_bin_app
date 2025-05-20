import 'package:flutter/material.dart';
import 'widgets/category_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const CategoryList(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Recent Items',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              // TODO: Add item list here
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recycling Tips',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Remember to clean containers before recycling! Rinse bottles and jars to remove food residue.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add item screen
        },
        child: const Icon(Icons.add),
        tooltip: 'Add recycling item',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
        onTap: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }
}