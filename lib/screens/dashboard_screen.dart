import 'package:flutter/material.dart';
import '../widgets/dashboard/desktop_header.dart';
import '../widgets/dashboard/transaction_party_toggle.dart';
import '../widgets/dashboard/transaction_details_content.dart';
import '../widgets/dashboard/party_details_content.dart';
import '../widgets/dashboard/document_section.dart';

class DashboardScreen extends StatefulWidget {
  // Made the callback optional
  final Function(int)? onToggleChanged; 

  const DashboardScreen({super.key, this.onToggleChanged});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedToggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 600;
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) const DesktopHeader(),
            
            TransactionPartyToggle(
              selectedIndex: _selectedToggleIndex,
              onToggle: (index) {
                setState(() {
                  _selectedToggleIndex = index;
                });
                // Only call the callback if it was provided
                widget.onToggleChanged?.call(index); 
              },
            ),
            const SizedBox(height: 16),
            
            if (_selectedToggleIndex == 0)
              const TransactionDetailsContent()
            else
              const PartyDetailsContent(),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            const DocumentSection(),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      );
    });
  }
}
