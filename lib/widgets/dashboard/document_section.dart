import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'package:zooogle/widgets/dashboard/quotation_actions_bottom_sheet.dart';
import 'document_card.dart';
import 'grid_widgets.dart';

class DocumentSection extends StatelessWidget {
  const DocumentSection({super.key});

  void _showDocumentActionsBottomSheet(BuildContext context, String title) {
    Widget? bottomSheetContent;
    
    if (title == 'Quotation') {
      bottomSheetContent = const QuotationActionsBottomSheet();
    } else if (title == 'Invoices') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTransactionScreen(type: TransactionType.sale)), // Corrected
      );
      return; 
    } else if (title == 'Purchase') {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTransactionScreen(type: TransactionType.purchase)), // Corrected
      );
      return;
    }

    if (bottomSheetContent != null) {
        showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (BuildContext context) {
            return bottomSheetContent!;
        },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: DocumentCard(
                title: 'Invoices',
                icon: Icons.receipt_long,
                onTap: () => _showDocumentActionsBottomSheet(context, 'Invoices'),
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: DocumentCard(
                title: 'Quotation',
                icon: Icons.request_quote,
                onTap: () => _showDocumentActionsBottomSheet(context, 'Quotation'),
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: DocumentCard(
                title: 'Purchase',
                icon: Icons.shopping_cart_outlined,
                onTap: () => _showDocumentActionsBottomSheet(context, 'Purchase'),
              )),
            ],
          ),
          const SizedBox(height: 16),
          const SectionHeader('Other Documents'),
          const SizedBox(height: 12),
          DocumentsGrid(constraints: constraints),
          const SizedBox(height: 16),
          const SectionHeader('More'),
          const SizedBox(height: 12),
          MoreGrid(constraints: constraints),
        ],
      );
    });
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}