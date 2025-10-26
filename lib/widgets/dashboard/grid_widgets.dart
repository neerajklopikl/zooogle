import 'package:flutter/material.dart';
import 'package:zooogle/screens/business/expenses_screen.dart';
import 'package:zooogle/screens/documents/credit_notes_screen.dart';
import 'package:zooogle/screens/documents/debit_notes_screen.dart';
import 'package:zooogle/screens/documents/delivery_challans_screen.dart';
import 'package:zooogle/screens/documents/digital_signature_screen.dart';
import 'package:zooogle/screens/documents/gstr_filing_screen.dart';
import 'package:zooogle/screens/documents/ledgers_screen.dart';
import 'package:zooogle/screens/documents/payment_receipts_screen.dart';
import 'package:zooogle/screens/documents/payments_made_screen.dart';
import 'package:zooogle/screens/documents/proforma_invoices_screen.dart';
import 'package:zooogle/screens/documents/purchase_orders_screen.dart';
import 'package:zooogle/screens/documents/refund_vouchers_screen.dart';
import 'package:zooogle/screens/e_invoice/e_invoice_login_screen.dart';
import 'package:zooogle/screens/e_way_bill/e_way_bill_login_screen.dart';
import 'package:zooogle/screens/items_screen.dart';
import 'package:zooogle/screens/reports_screen.dart';
import 'quick_links_bottom_sheet.dart';

class DocumentsGrid extends StatelessWidget {
  final BoxConstraints constraints;
  const DocumentsGrid({super.key, required this.constraints});

  void _navigateToScreen(BuildContext context, String title) {
    Widget? destination;

    switch (title) {
      case 'e-Invoice':
        destination = const EInvoiceLoginScreen();
        break;
      case 'e-Way Bills':
        destination = const EWayBillLoginScreen();
        break;
      case 'Reports':
        destination = const ReportsScreen();
        break;
      case 'Inventory':
        destination = const ItemsScreen();
        break;
      case 'Expenses':
        destination = const ExpensesScreen();
        break;
      case 'Proforma Invoices':
        destination = const ProformaInvoicesScreen();
        break;
      case 'Payment Receipts':
        destination = const PaymentReceiptsScreen();
        break;
      case 'Payments Made':
        destination = const PaymentsMadeScreen();
        break;
      case 'Debit Notes':
        destination = const DebitNotesScreen();
        break;
      case 'Credit Notes':
        destination = const CreditNotesScreen();
        break;
      case 'Digital Signature':
        destination = const DigitalSignatureScreen();
        break;
      case 'Delivery Challans':
        destination = const DeliveryChallansScreen();
        break;
      case 'Ledgers':
        destination = const LedgersScreen();
        break;
      case 'Refund Voucher':
        destination = const RefundVouchersScreen();
        break;
      case 'Purchase Orders':
        destination = const PurchaseOrdersScreen();
        break;
      case 'GSTR Filing':
        destination = const GstrFilingScreen();
        break;
    }

    if (destination != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => destination!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title feature is coming soon!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.qr_code_scanner, 'label': 'e-Invoice', 'color': Colors.purple},
      {'icon': Icons.local_shipping, 'label': 'e-Way Bills', 'color': Colors.blue},
      {'icon': Icons.description, 'label': 'Proforma Invoices', 'color': Colors.black87},
      {'icon': Icons.receipt, 'label': 'Payment Receipts', 'color': Colors.red},
      {'icon': Icons.payment, 'label': 'Payments Made', 'color': Colors.orange},
      {'icon': Icons.money_off, 'label': 'Debit Notes', 'color': Colors.teal},
      {'icon': Icons.add_card, 'label': 'Credit Notes', 'color': Colors.green},
      {'icon': Icons.badge, 'label': 'Digital Signature', 'color': Colors.indigo, 'isNew': true},
      {'icon': Icons.delivery_dining, 'label': 'Delivery Challans', 'color': Colors.blueGrey},
      {'icon': Icons.inventory, 'label': 'Inventory', 'color': Colors.lightBlue},
      {'icon': Icons.book, 'label': 'Ledgers', 'color': Colors.brown},
      {'icon': Icons.assessment, 'label': 'Reports', 'color': Colors.green},
      {'icon': Icons.wallet_giftcard, 'label': 'Expenses', 'color': Colors.cyan},
      {'icon': Icons.local_offer, 'label': 'Refund Voucher', 'color': Colors.pink},
      {'icon': Icons.sticky_note_2, 'label': 'Purchase Orders', 'color': Colors.orange},
      {'icon': Icons.g_mobiledata, 'label': 'GSTR Filing', 'color': Colors.indigo},
    ];

    final int crossAxisCount = _getCrossAxisCount(constraints);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GridItem(
          icon: items[index]['icon'],
          label: items[index]['label'],
          color: items[index]['color'],
          isNew: items[index]['isNew'] ?? false,
          onTap: () => _navigateToScreen(context, items[index]['label']),
        );
      },
    );
  }
}

class MoreGrid extends StatelessWidget {
  final BoxConstraints constraints;
  const MoreGrid({super.key, required this.constraints});
  void _showMoreActionsBottomSheet(BuildContext context, String title) {/*...*/}
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.card_giftcard, 'label': 'Festive Greetings', 'color': Colors.green},
      {'icon': Icons.article, 'label': 'HSN/SAC', 'color': Colors.red},
      {'icon': Icons.qr_code, 'label': 'E-Invoice QR', 'color': Colors.blue},
    ];
    final int crossAxisCount = _getCrossAxisCount(constraints);
    return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 0.9), itemCount: items.length, itemBuilder: (context, index) {return GridItem(icon: items[index]['icon'], label: items[index]['label'], color: items[index]['color'], onTap: () => _showMoreActionsBottomSheet(context, items[index]['label']));});
  }
}

int _getCrossAxisCount(BoxConstraints constraints) {
  if (constraints.maxWidth > 1200) return 8;
  if (constraints.maxWidth > 900) return 7;
  if (constraints.maxWidth > 600) return 5;
  return 4;
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isNew;
  final VoidCallback? onTap;
  const GridItem({super.key, required this.icon, required this.label, required this.color, this.isNew = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 22)
                ),
                if (isNew)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                    )
                  )
              ]
            ),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)
          ]
        )
      )
    );
  }
}
