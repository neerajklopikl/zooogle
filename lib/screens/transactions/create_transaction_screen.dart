import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/models/transaction_config.dart'; // Import the new config file
import 'package:zooogle/services/api_service.dart';
import 'add_item_screen.dart';

enum PaymentType { credit, cash }

class CreateTransactionScreen extends StatefulWidget {
  final TransactionType type;
  const CreateTransactionScreen({Key? key, required this.type}) : super(key: key);

  @override
  _CreateTransactionScreenState createState() => _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late TransactionConfig _config;
  bool _isLoadingNumber = true; // --- NEW: Loading state for number

  // Common Controllers
  final _numberController = TextEditingController();
  final _partyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Renamed & Modified Controllers
  final _subTotalController = TextEditingController(text: '0.00'); 
  final _discountController = TextEditingController(text: '0.00');
  final _amountPaidController = TextEditingController(text: '0.00');
  
  // Item-Based Controllers
  final _poNumberController = TextEditingController();
  // --- NEW: Controllers for Original Invoice (for Returns) ---
  final _originalNumberController = TextEditingController();
  
  final List<InvoiceLineItem> _lineItems = [];

  // Date & Time State
  DateTime _invoiceDate = DateTime.now();
  DateTime _invoiceTime = DateTime.now();
  DateTime _poDate = DateTime.now();
  // --- NEW: Date for Original Invoice ---
  DateTime _originalDate = DateTime.now();
  
  PaymentType _paymentType = PaymentType.cash;

  // Calculated State
  double _totalAfterDiscount = 0.0;
  double _balanceDue = 0.0;

  @override
  void initState() {
    super.initState();
    _config = TransactionConfig.fromType(widget.type);
    _fetchNextTransactionNumber(); // --- NEW: Fetch number on init

    // Add listeners to auto-calculate
    _subTotalController.addListener(_calculateAmounts);
    _discountController.addListener(_calculateAmounts);
    _amountPaidController.addListener(_calculateAmounts);
  }

  // --- NEW: Function to fetch the number from the API ---
  Future<void> _fetchNextTransactionNumber() async {
    setState(() {
      _isLoadingNumber = true;
    });
    try {
      final nextNumber = await _apiService.getNextTransactionNumber(widget.type.toJson());
      setState(() {
        _numberController.text = nextNumber;
        _isLoadingNumber = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNumber = false;
        // Show an error or set a default
        _numberController.text = "Error"; 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not fetch next transaction number: $e")),
        );
      });
    }
  }


  @override
  void dispose() {
    _numberController.dispose();
    _partyNameController.dispose();
    _phoneController.dispose();
    _subTotalController.dispose();
    _poNumberController.dispose();
    _discountController.dispose();
    _amountPaidController.dispose();
    _originalNumberController.dispose();
    super.dispose();
  }

  void _calculateAmounts() {
    // For item-based layouts
    if (_config.hasItems) {
      // 1. Get Subtotal
      double subTotal;
      if (_lineItems.isNotEmpty) {
        subTotal = _lineItems.fold(0, (sum, item) => sum + item.total);
        _subTotalController.text = subTotal.toStringAsFixed(2);
      } else {
        subTotal = double.tryParse(_subTotalController.text) ?? 0.0;
      }

      // 2. Get Discount
      double discount = double.tryParse(_discountController.text) ?? 0.0;

      // 3. Get Amount Paid/Received
      double amountPaid = double.tryParse(_amountPaidController.text) ?? 0.0;

      // 4. Calculate final values
      setState(() {
        _totalAfterDiscount = subTotal - discount;
        
        if (_paymentType == PaymentType.cash) {
          _amountPaidController.text = _totalAfterDiscount.toStringAsFixed(2);
          _balanceDue = 0.0;
        } else { 
          _balanceDue = _totalAfterDiscount - amountPaid;
        }
      });
    } else {
      // For simple layouts (Payment In/Out), total is just the subtotal
      setState(() {
         _totalAfterDiscount = double.tryParse(_subTotalController.text) ?? 0.0;
      });
    }
  }

  Future<void> _addItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
          onSave: (item) {
            if (_lineItems.isEmpty) {
              _subTotalController.text = '0.00';
            }
            setState(() {
              _lineItems.add(item);
              _calculateAmounts();
            });
          },
        ),
      ),
    );
  }

  // --- MODIFIED: Save logic to reset and fetch new number ---
  Future<void> _saveTransaction({bool saveAndNew = false}) async {
    if (_formKey.currentState!.validate()) {
      final transactionData = {
        'type': widget.type.toJson(),
        'partyName': _partyNameController.text,
        'phoneNumber': _phoneController.text,
        'transactionNumber': _numberController.text,
        'invoiceDate': _invoiceDate.toIso8601String(),
        'items': _lineItems.map((item) => item.toJson()).toList(),
        'subTotal': double.tryParse(_subTotalController.text) ?? 0.0,
        'discount': double.tryParse(_discountController.text) ?? 0.0,
        'totalAmount': _totalAfterDiscount,
        'amountPaid': double.tryParse(_amountPaidController.text) ?? 0.0,
        'balanceDue': _balanceDue,
        'paymentType': _paymentType.toString().split('.').last,
      };

      try {
        await _apiService.createTransaction(transactionData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved successfully')),
        );
        if (saveAndNew) {
          _resetFormForNewTransaction();
        } else {
          Navigator.pop(context, true); // Go back on success
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save transaction: $e')),
        );
      }
    }
  }

  // --- NEW: Helper to reset the form ---
  void _resetFormForNewTransaction() {
    _formKey.currentState!.reset();
    _partyNameController.clear();
    _phoneController.clear();
    _subTotalController.text = '0.00';
    _discountController.text = '0.00';
    _amountPaidController.text = '0.00';
    _poNumberController.clear();
    _originalNumberController.clear();
    
    // 
    // ***** THIS IS THE FIX *****
    //
    _numberController.clear(); // <-- THIS LINE WAS MISSING
    //
    // **************************
    //

    setState(() {
      _lineItems.clear();
      _invoiceDate = DateTime.now();
      _invoiceTime = DateTime.now();
      _poDate = DateTime.now();
      _originalDate = DateTime.now();
      _paymentType = PaymentType.cash;
    });
    // Fetch the next number from the server instead of incrementing locally
    _fetchNextTransactionNumber(); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _config.hasItems ? _buildItemBasedLayout() : _buildSimpleLayout(),
              ),
            ),
            // Only show total bar for item-based transactions
            if (_config.hasItems) _buildTotalAmountBar(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_config.title),
      automaticallyImplyLeading: true, // <-- Explicitly ensuring the back arrow is shown
      actions: [
        if (_config.hasPaymentToggle)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ToggleButtons(
              isSelected: [_paymentType == PaymentType.credit, _paymentType == PaymentType.cash],
              onPressed: (index) {
                setState(() => _paymentType = index == 0 ? PaymentType.credit : PaymentType.cash);
                _calculateAmounts(); 
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Theme.of(context).primaryColor,
              color: Theme.of(context).primaryColor,
              constraints: const BoxConstraints(minHeight: 32, minWidth: 60),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Credit')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Cash')),
              ],
            ),
          ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
      ],
    );
  }

  // --- LAYOUTS ---

  Widget _buildItemBasedLayout() {
    return Column(
      children: [
        _buildTransactionDetailsRow(),
        const SizedBox(height: 16),
        _buildPartyDetails(),
        const SizedBox(height: 16),
        
        // Conditional logic for PO / Original Invoice
        if (_config.hasPoDetails) ...[
          _buildPoDetailsRow(),
          const SizedBox(height: 16),
        ],
        
        if (_config.originalInvoiceNumberLabel != null) ...[
          _buildOriginalInvoiceDetailsRow(),
          const SizedBox(height: 16),
        ],

        _buildItemsSection(),
        const SizedBox(height: 16),
        _buildPaymentDetails(),
      ],
    );
  }

  // --- MODIFIED: This now includes the Phone Number ---
  Widget _buildSimpleLayout() { // For Payment In/Out
    return Column(
      children: [
        _buildTransactionDetailsRow(showTime: false),
        const SizedBox(height: 16),
        _buildPartyDetails(), // <-- REUSED from item-based layout
        const SizedBox(height: 16),
        TextFormField(
          controller: _subTotalController,
          decoration: InputDecoration(labelText: _config.amountLabel, border: const OutlineInputBorder(), prefixText: '₹ '),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
  // --- END MODIFICATION ---

  // --- WIDGET BUILDERS ---

  Widget _buildTransactionDetailsRow({bool showTime = true}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          // --- MODIFIED: Show a loading indicator ---
          child: _isLoadingNumber 
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2.0))
              : TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(labelText: _config.numberLabel, border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(context: context, initialDate: _invoiceDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (pickedDate != null) setState(() => _invoiceDate = pickedDate);
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Date', border: InputBorder.none),
              child: Text(DateFormat('dd/MM/yyyy').format(_invoiceDate)),
            ),
          ),
        ),
        if (showTime) ...[
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_invoiceTime));
                if (pickedTime != null) setState(() => _invoiceTime = DateTime(_invoiceDate.year, _invoiceDate.month, _invoiceDate.day, pickedTime.hour, pickedTime.minute));
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Time', border: InputBorder.none),
                child: Text(DateFormat('hh:mm a').format(_invoiceTime)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPartyDetails() {
    return Column(
      children: [
        TextFormField(controller: _partyNameController, decoration: InputDecoration(labelText: _config.partyLabel, border: const OutlineInputBorder())),
        const SizedBox(height: 16),
        TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', border: const OutlineInputBorder()), keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildPoDetailsRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(context: context, initialDate: _poDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (pickedDate != null) setState(() => _poDate = pickedDate);
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'PO Date', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today_outlined)),
              child: Text(DateFormat('dd/MM/yyyy').format(_poDate)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: TextFormField(controller: _poNumberController, decoration: const InputDecoration(labelText: 'PO Number', border: OutlineInputBorder()))),
      ],
    );
  }

  Widget _buildOriginalInvoiceDetailsRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(context: context, initialDate: _originalDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
              if (pickedDate != null) setState(() => _originalDate = pickedDate);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: _config.originalInvoiceDateLabel ?? 'Original Date',
                border: const OutlineInputBorder(), 
                prefixIcon: const Icon(Icons.calendar_today_outlined)
              ),
              child: Text(DateFormat('dd/MM/yyyy').format(_originalDate)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _originalNumberController, 
            decoration: InputDecoration(
              labelText: _config.originalInvoiceNumberLabel ?? 'Original No.', 
              border: const OutlineInputBorder()
            )
          )
        ),
      ],
    );
  }

  Widget _buildItemsSection() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
          label: const Text('Add Items (Optional)'),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), foregroundColor: Theme.of(context).primaryColor),
        ),
        if (_lineItems.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lineItems.length,
            itemBuilder: (context, index) {
              final item = _lineItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.quantity} ${item.unit} x ₹${item.rate.toStringAsFixed(2)}'),
                  trailing: Text('₹${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onLongPress: () => setState(() {
                    _lineItems.removeAt(index);
                    _calculateAmounts();
                  }),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      children: [
        // 1. Subtotal (Amount) Field
        TextFormField(
          controller: _subTotalController,
          readOnly: _lineItems.isNotEmpty,
          decoration: InputDecoration(
            labelText: 'Subtotal Amount',
            border: const OutlineInputBorder(),
            prefixText: '₹ ',
            filled: _lineItems.isNotEmpty,
            fillColor: _lineItems.isNotEmpty ? Colors.grey.shade100 : null,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        
        // 2. Discount Field
        TextFormField(
          controller: _discountController,
          decoration: const InputDecoration(
            labelText: 'Discount',
            border: const OutlineInputBorder(),
            prefixText: '₹ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        
        // 3. Amount Received/Paid (Only show in Credit mode)
        if (_paymentType == PaymentType.credit) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountPaidController,
            decoration: InputDecoration(
              labelText: _config.amountReceivedLabel, 
              border: const OutlineInputBorder(),
              prefixText: '₹ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalAmountBar() {
    String totalText = _totalAfterDiscount.toStringAsFixed(2);
    String balanceText = _balanceDue.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Show "Balance Due" in Credit mode
          if (_paymentType == PaymentType.credit)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Balance Due', style: Theme.of(context).textTheme.titleSmall),
                Text('₹$balanceText', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.red.shade700)),
              ],
            )
          // Show "Cash Paid" in Cash mode
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Cash Paid', style: Theme.of(context).textTheme.titleSmall),
                Text('₹$totalText', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ],
            ),
          
          // Always show the "Total" amount (after discount)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text('₹$totalText', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _saveTransaction(saveAndNew: true),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              child: const Text('Save & New'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _saveTransaction(),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}