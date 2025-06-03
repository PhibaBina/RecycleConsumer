import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PickupSubscriptionScreen extends StatefulWidget {
  const PickupSubscriptionScreen({super.key});

  @override
  State<PickupSubscriptionScreen> createState() => _PickupSubscriptionScreenState();
}

class _PickupSubscriptionScreenState extends State<PickupSubscriptionScreen> {
  String _selectedPlan = '2-pickups/week';
  List<String> _selectedDays = [];

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _submitSubscription() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not logged in.")));
      return;
    }

    if (_selectedDays.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select exactly 2 pickup days.")),
      );
      return;
    }

    await _firestore.collection('subscriptions').doc(user.uid).set({
      'plan': _selectedPlan,
      'pickupDays': _selectedDays,
      'active': true,
      'startDate': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Subscription saved successfully!")),
    );
    Navigator.pop(context); // Go back to dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pickup Subscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Pickup Plan:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedPlan,
              items: ['1-pickup/week', '2-pickups/week']
                  .map((plan) => DropdownMenuItem(value: plan, child: Text(plan)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPlan = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text("Select Pickup Days (choose 2):", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: _days.map((day) {
                return FilterChip(
                  selectedColor: Colors.green[100],
                  label: Text(day),
                  selected: _selectedDays.contains(day),
                  onSelected: (_) => _toggleDay(day),
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _submitSubscription,
                icon: const Icon(Icons.check),
                label: const Text("Subscribe Now", style: TextStyle(color: Colors.white), ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }
}
