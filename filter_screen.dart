import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String vehicleSize = 'Standard';
  bool needsCharger = false;
  bool isCovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filters")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: vehicleSize,
              decoration: const InputDecoration(labelText: 'Vehicle Size'),
              items: ['Compact', 'Standard', 'Large']
                  .map((size) =>
                      DropdownMenuItem(value: size, child: Text(size)))
                  .toList(),
              onChanged: (value) => setState(() => vehicleSize = value!),
            ),
            SwitchListTile(
              title: const Text("Electric Charger Needed"),
              value: needsCharger,
              onChanged: (val) => setState(() => needsCharger = val),
            ),
            SwitchListTile(
              title: const Text("Covered Parking"),
              value: isCovered,
              onChanged: (val) => setState(() => isCovered = val),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmationScreen(
                      vehicleSize: vehicleSize,
                      needsCharger: needsCharger,
                      isCovered: isCovered,
                    ),
                  ),
                );
              },
              child: const Text("Show Best Match"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final String vehicleSize;
  final bool needsCharger;
  final bool isCovered;

  const ConfirmationScreen({
    super.key,
    required this.vehicleSize,
    required this.needsCharger,
    required this.isCovered,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Best Match")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("City Center Garage",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text("Size: $vehicleSize"),
            Text("Electric Charger: ${needsCharger ? 'Yes' : 'No'}"),
            Text("Covered: ${isCovered ? 'Yes' : 'No'}"),
            const SizedBox(height: 30),
            const Text("2 spots available - Est. 3 min drive"),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.check),
              label: const Text("Confirm & Start"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
