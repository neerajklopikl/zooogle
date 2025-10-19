import 'package:flutter/material.dart';
import 'quick_links_card.dart';
import 'party_card.dart';
import 'quick_links_bottom_sheet.dart';

class PartyDetailsContent extends StatelessWidget {
  const PartyDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickLinks = [
      {'icon': Icons.network_check, 'label': 'Network', 'color': Colors.blue.shade800},
      {'icon': Icons.description, 'label': 'Party State...', 'color': Colors.lightBlue},
      {'icon': Icons.settings, 'label': 'Party Settings', 'color': Colors.grey.shade600},
      {'icon': Icons.arrow_forward_ios, 'label': 'Show All', 'color': Colors.lightBlue},
    ];

    void _showQuickLinksBottomSheet(BuildContext context, String title) async {
      final Map<String, List<Map<String, dynamic>>> bottomSheetItems = {
        'Network': [
          {'label': 'Your Network', 'icon': Icons.group},
          {'label': 'Add Party', 'icon': Icons.person_add},
        ],
        'Party State...': [
          {'label': 'Party Statement', 'icon': Icons.description},
          {'label': 'Party Report', 'icon': Icons.assessment},
        ],
        'Party Settings': [
          {'label': 'Manage Parties', 'icon': Icons.people_alt},
          {'label': 'Party Settings', 'icon': Icons.settings},
        ],
        'Show All': [
          {'label': 'Your Network', 'icon': Icons.group},
          {'label': 'Add Party', 'icon': Icons.person_add},
          {'label': 'Party Statement', 'icon': Icons.description},
          {'label': 'Party Report', 'icon': Icons.assessment},
          {'label': 'Manage Parties', 'icon': Icons.people_alt},
          {'label': 'Party Settings', 'icon': Icons.settings},
        ]
      };

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return QuickLinksBottomSheet(
            title: title,
            items: bottomSheetItems[title] ?? [],
          );
        },
      );
    }

    return Column(
      children: [
        QuickLinksCard(
          links: quickLinks,
          onLinkTapped: (label) {
            _showQuickLinksBottomSheet(context, label);
          },
        ),
        const SizedBox(height: 16),
        const PartyCard(),
      ],
    );
  }
}
