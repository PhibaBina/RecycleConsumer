import 'package:flutter/material.dart';
import 'package:recycle_bazaar_consumer/screens/old_clothes.dart';

import 'book_pickup.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = [
      _DashboardItem(title: 'Book Pickup', icon: Icons.local_shipping),
      _DashboardItem(title: 'Old Clothes', icon: Icons.sell),
       _DashboardItem(title: 'Thrift Store', icon: Icons.storage),
      _DashboardItem(title: 'Track Order', icon: Icons.track_changes),
      _DashboardItem(title: 'My Wallet', icon: Icons.account_balance_wallet),
      _DashboardItem(title: 'My Rewards', icon: Icons.star),
      _DashboardItem(title: 'Profile', icon: Icons.person),
      _DashboardItem(title: 'Settings', icon: Icons.settings),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bazaar'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
             onTap: () {
                  if (item.title == 'Book Pickup') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookPickupScreen()),
                    );
                  }
                  if (item.title == 'Donate') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OldClothesForm()),
                    );
                  }
                },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.green.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 50, color: Colors.green),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;

  _DashboardItem({required this.title, required this.icon});
}
