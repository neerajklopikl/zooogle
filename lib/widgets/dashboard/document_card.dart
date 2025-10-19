import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))]),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: Colors.grey.shade100, radius: 18, child: Icon(icon, color: Colors.black87, size: 18)),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}