import 'package:flutter/material.dart';

class AddNewMasterScreen extends StatefulWidget {
  final String masterType;
  const AddNewMasterScreen({super.key, required this.masterType});

  @override
  State<AddNewMasterScreen> createState() => _AddNewMasterScreenState();
}

class _AddNewMasterScreenState extends State<AddNewMasterScreen> {
  final _formKey = GlobalKey<FormState>();

  // A map to hold all form controllers for easy access
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'alias': TextEditingController(),
    'printName': TextEditingController(),
    'opBal': TextEditingController(text: '0.00'),
    'prevYearBal': TextEditingController(text: '0.00'),
    'address1': TextEditingController(),
    'address2': TextEditingController(),
    'address3': TextEditingController(),
    'address4': TextEditingController(),
    'gstin': TextEditingController(),
    'aadhaarNo': TextEditingController(),
    'itPan': TextEditingController(),
    'email': TextEditingController(),
    'mobileNo': TextEditingController(),
    'telNo': TextEditingController(),
    'contactPerson': TextEditingController(),
    'station': TextEditingController(),
    'distance': TextEditingController(text: '0'),
    'tin': TextEditingController(),
    'ward': TextEditingController(),
    'whatsappNo': TextEditingController(),
    'fax': TextEditingController(),
    'transport': TextEditingController(),
    'pinCode': TextEditingController(),
    'cstNo': TextEditingController(),
    'lstNo': TextEditingController(),
    'lbtNo': TextEditingController(),
    'bankName': TextEditingController(),
    'bankAcNo': TextEditingController(),
    'ifscCode': TextEditingController(),
    'swiftCode': TextEditingController(),
  };

  String? _selectedGroup;
  String _opBalType = 'Dr';
  String _prevYearBalType = 'Dr';
  String? _selectedCountry;
  String? _selectedState;
  bool _enableEmailQuery = false;
  bool _enableSmsQuery = false;

  final List<String> _accountGroups = [
    'Sundry Debtors', 'Sundry Creditors', 'Sales Accounts', 'Purchase Accounts',
    'Direct Expenses', 'Indirect Expenses', 'Duties & Taxes', 'Bank Accounts', 'Capital Account',
  ];
  final List<String> _countries = ['India', 'USA', 'Canada', 'UK']; // Sample data
  final List<String> _states = ['Haryana', 'Delhi', 'Maharashtra', 'Karnataka']; // Sample data

  @override
  void dispose() {
    // Dispose all controllers
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _onSave({bool saveAndNew = false}) {
    if (_formKey.currentState!.validate()) {
      // Collect all data into a map
      final result = {
        'type': widget.masterType,
        'name': _controllers['name']!.text,
        'alias': _controllers['alias']!.text,
        'printName': _controllers['printName']!.text,
        'group': _selectedGroup,
        'opBal': {'amount': double.tryParse(_controllers['opBal']!.text) ?? 0.0, 'type': _opBalType},
        'prevYearBal': {'amount': double.tryParse(_controllers['prevYearBal']!.text) ?? 0.0, 'type': _prevYearBalType},
        'address1': _controllers['address1']!.text,
        'address2': _controllers['address2']!.text,
        'address3': _controllers['address3']!.text,
        'address4': _controllers['address4']!.text,
        'country': _selectedCountry,
        'state': _selectedState,
        'gstin': _controllers['gstin']!.text,
        'aadhaarNo': _controllers['aadhaarNo']!.text,
        'itPan': _controllers['itPan']!.text,
        'email': _controllers['email']!.text,
        'mobileNo': _controllers['mobileNo']!.text,
        'whatsappNo': _controllers['whatsappNo']!.text,
        'bankName': _controllers['bankName']!.text,
        'bankAcNo': _controllers['bankAcNo']!.text,
        'ifscCode': _controllers['ifscCode']!.text,
        'swiftCode': _controllers['swiftCode']!.text,
        'enableEmailQuery': _enableEmailQuery,
        'enableSmsQuery': _enableSmsQuery,
        // Add all other fields here...
      };

      // In a real app, you would send this to an API
      print(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Master saved successfully')),
      );

      if (saveAndNew) {
        _formKey.currentState!.reset();
        _controllers.forEach((key, controller) {
          if (key != 'opBal' && key != 'prevYearBal' && key != 'distance') {
            controller.clear();
          }
        });
        setState(() {
          _selectedGroup = null;
          _selectedCountry = null;
          _selectedState = null;
          _opBalType = 'Dr';
          _prevYearBalType = 'Dr';
          _enableEmailQuery = false;
          _enableSmsQuery = false;
        });
      } else {
        Navigator.of(context).pop(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account Master'),
        backgroundColor: Colors.grey.shade100,
        actions: [
          TextButton(onPressed: () => _onSave(saveAndNew: true), child: const Text('Save & New')),
          TextButton(onPressed: () => _onSave(), child: const Text('Save')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Quit')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                // Desktop-like layout with 3 columns
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildGeneralInfoSection()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildOtherInfoSection()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildExtraInfoSection()),
                  ],
                );
              } else {
                // Mobile layout with a single column
                return Column(
                  children: [
                    _buildGeneralInfoSection(),
                    const SizedBox(height: 16),
                    _buildOtherInfoSection(),
                    const SizedBox(height: 16),
                    _buildExtraInfoSection(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGETS FOR EACH SECTION ---

  Widget _buildGeneralInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('General Info', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          _buildTextField('name', 'Name *', isRequired: true),
          _buildTextField('alias', 'Alias'),
          _buildTextField('printName', 'Print Name'),
          _buildDropdown('group', 'Group *', _accountGroups, (val) => setState(() => _selectedGroup = val), _selectedGroup),
          _buildBalanceField('opBal', 'Op. Bal.', _opBalType, (val) => setState(() => _opBalType = val)),
          _buildBalanceField('prevYearBal', 'Prev. Year Bal.', _prevYearBalType, (val) => setState(() => _prevYearBalType = val)),
          _buildTextField('address1', 'Address 1'),
          _buildTextField('address2', 'Address 2'),
          _buildTextField('address3', 'Address 3'),
          _buildTextField('address4', 'Address 4'),
          _buildDropdown('country', 'Country', _countries, (val) => setState(() => _selectedCountry = val), _selectedCountry),
          _buildDropdown('state', 'State', _states, (val) => setState(() => _selectedState = val), _selectedState),
          _buildTextField('gstin', 'GSTIN / UIN', button: TextButton(onPressed: () {}, child: const Text('Validate Online'))),
          _buildTextField('aadhaarNo', 'Aadhaar No.'),
          _buildTextField('itPan', 'IT PAN'),
          _buildTextField('email', 'E-Mail'),
          _buildTextField('mobileNo', 'Mobile No.'),
          _buildTextField('telNo', 'Tel. No.'),
          _buildTextField('contactPerson', 'Contact Person'),
          _buildTextField('station', 'Station'),
          _buildTextField('pinCode', 'PIN Code'),
          _buildTextField('distance', 'Distance (KM)', keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildOtherInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Other Info', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          _buildTextField('cstNo', 'CST No.'),
          _buildTextField('lstNo', 'LST No.'),
          _buildTextField('lbtNo', 'LBT No.'),
          const SizedBox(height: 24),
          _buildTextField('bankName', 'Bank Name'),
          _buildTextField('bankAcNo', 'Bank A/C No.'),
          _buildTextField('ifscCode', 'IFSC Code'),
          const SizedBox(height: 24),
          _buildSwitch('enableEmailQuery', 'Enable Email Query', _enableEmailQuery, (val) => setState(() => _enableEmailQuery = val)),
        ],
      ),
    );
  }

  Widget _buildExtraInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Extra Info', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          _buildTextField('swiftCode', 'Swift Code'),
          const SizedBox(height: 24),
          _buildSwitch('enableSmsQuery', 'Enable SMS Query', _enableSmsQuery, (val) => setState(() => _enableSmsQuery = val)),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTextField(String key, String label, {bool isRequired = false, TextInputType? keyboardType, Widget? button}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controllers[key],
              decoration: InputDecoration(labelText: label),
              validator: isRequired ? (value) => (value == null || value.isEmpty) ? 'This field is required' : null : null,
              keyboardType: keyboardType,
            ),
          ),
          if (button != null) button,
        ],
      ),
    );
  }

  Widget _buildDropdown(String key, String label, List<String> items, Function(String?) onChanged, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => (value == null) ? 'Please select a value' : null,
      ),
    );
  }

  Widget _buildBalanceField(String key, String label, String balanceType, Function(String) onTypeChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controllers[key],
              decoration: InputDecoration(labelText: label, prefixText: '₹ '),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(width: 8),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'Dr', label: Text('Dr')), ButtonSegment(value: 'Cr', label: Text('Cr'))],
            selected: {balanceType},
            onSelectionChanged: (newSelection) => onTypeChanged(newSelection.first),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String key, String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
