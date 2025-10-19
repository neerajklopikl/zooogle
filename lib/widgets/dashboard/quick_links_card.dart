import 'package:flutter/material.dart';

class QuickLinksCard extends StatelessWidget {
  final List<Map<String, dynamic>> links;
  final Function(String) onLinkTapped;
  const QuickLinksCard({super.key, required this.links, required this.onLinkTapped});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Links', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: links.map((link) => QuickLinkItem(
                icon: link['icon'],
                label: link['label'],
                color: link['color'],
                onTap: () => onLinkTapped(link['label']),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickLinkItem({super.key, required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isShowAll = label == 'Show All';
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isShowAll ? color.withOpacity(0.8) : color.withOpacity(0.1),
            child: Icon(icon, color: isShowAll ? Colors.white : color, size: isShowAll ? 18 : 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}