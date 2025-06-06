import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditleadScreen extends StatefulWidget {
  final String? leadId;
  const EditleadScreen({super.key, required this.leadId});

  @override
  State<EditleadScreen> createState() => _EditleadScreenState();
}

class _EditleadScreenState extends State<EditleadScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _remarkController;
  late TextEditingController _visitTimeController;
  
  String _selectedBranch = 'Main Branch';
  String _selectedSource = 'Website';
  String _selectedQueryType = 'Product Inquiry';
  bool _phoneVerified = false;

  // final List<String> _branches = ['Main Branch', 'North Branch', 'South Branch', 'East Branch'];
  // final List<String> _sources = ['Website', 'Social Media', 'Referral', 'Advertisement', 'Walk-in'];
  // final List<String> _queryTypes = ['Product Inquiry', 'Service Request', 'Complaint', 'Feedback'];

  @override
  void initState() {
    super.initState();
    // Initialize with dummy data - replace with actual data from your controller
    _nameController = TextEditingController(text: 'John Doe');
    _phoneController = TextEditingController(text: '+1 234 567 890');
    _emailController = TextEditingController(text: 'john.doe@example.com');
    _addressController = TextEditingController(text: '123 Main St, New York, NY');
    _remarkController = TextEditingController(text: 'Interested in premium package');
    _visitTimeController = TextEditingController(text: DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()));
    _phoneVerified = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarkController.dispose();
    _visitTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectVisitTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime fullDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _visitTimeController.text = DateFormat('dd MMM yyyy, hh:mm a').format(fullDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Edit Lead',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lead updated successfully')),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 16),
              _buildContactInfoSection(),
              const SizedBox(height: 16),
              _buildAdditionalInfoSection(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.person, size: 40, color: Colors.blue),
        ),
        const SizedBox(height: 12),
        Text(
          'Editing Lead #${widget.leadId}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.length < 10) {
                  return 'Enter valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.verified, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  'Phone Verified',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                Switch(
                  value: _phoneVerified,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _phoneVerified = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty && !value.contains('@')) {
                  return 'Enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _buildDateTimePicker(),
            const SizedBox(height: 12),
            // _buildDropdown(
            //   value: _selectedBranch,
            //   items: _branches,
            //   label: 'Branch',
            //   icon: Icons.apartment,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedBranch = value!;
            //     });
            //   },
            // ),
            const SizedBox(height: 12),
            // _buildDropdown(
            //   value: _selectedSource,
            //   items: _sources,
            //   label: 'Source',
            //   icon: Icons.source,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedSource = value!;
            //     });
            //   },
            // ),
            // const SizedBox(height: 12),
            // _buildDropdown(
            //   value: _selectedQueryType,
            //   items: _queryTypes,
            //   label: 'Query Type',
            //   icon: Icons.question_answer,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedQueryType = value!;
            //     });
            //   },
            // ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _remarkController,
              label: 'Remarks',
              icon: Icons.comment,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required void Function(String?)? onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () => _selectVisitTime(context),
      child: IgnorePointer(
        child: TextFormField(
          controller: _visitTimeController,
          decoration: InputDecoration(
            labelText: 'Visit Time',
            prefixIcon: Icon(Icons.access_time, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(Icons.calendar_today, size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select visit time';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Save logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lead updated successfully')),
          );
          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CRMColors.crmMainCOlor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'SAVE CHANGES',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}