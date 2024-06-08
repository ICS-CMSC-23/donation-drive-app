// ignore: file_names
import 'package:flutter/material.dart';

class DonationFormPage extends StatefulWidget {
  final String organizationName;

  const DonationFormPage({Key? key, required this.organizationName}) : super(key: key);

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();
  String? selectedCategory;
  String? selectedOption;
  TextEditingController weightController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<TextEditingController> addressesController = [TextEditingController()];
  TextEditingController contactNoController = TextEditingController();

  final categories = ['Food', 'Clothes', 'Cash', 'Necessities', 'Others'];
  final options = ['Pickup', 'Drop-off'];

  @override
  Widget build(BuildContext context) {
    final categoryField = DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );

    final optionField = DropdownButtonFormField<String>(
      value: selectedOption,
      decoration: const InputDecoration(
        labelText: 'Pickup/Drop-off',
        border: OutlineInputBorder(),
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedOption = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
    );

    final weightField = TextFormField(
      controller: weightController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Weight (kg)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the weight';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );

    final dateField = TextFormField(
      controller: dateController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Date and Time',
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            // ignore: use_build_context_synchronously
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            setState(() {
              dateController.text =
                  '${pickedDate.toLocal()} ${pickedTime.format(context)}';
            });
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select date and time';
        }
        return null;
      },
    );

    final contactNoField = TextFormField(
      controller: contactNoController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Contact No',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Contact number is required';
        }
        return null;
      },
    );

    final addAddressButton = ElevatedButton(
      onPressed: () {
        setState(() {
          addressesController.add(TextEditingController());
        });
      },
      child: const Text("Add Address"),
    );

    final addressFields = Column(
      children: [
        for (var i = 0; i < addressesController.length; i++)
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: addressesController[i],
                decoration: InputDecoration(
                  labelText: 'Address ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  addressesController.removeAt(i);
                });
              },
            ),
          ]),
      ],
    );

    final submitButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll<Color>(
            Color.fromARGB(255, 38, 32, 69)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(
                color: Color.fromARGB(255, 38, 32, 69), width: 2.0),
          ),
        ),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Process the donation form submission
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully')),
          );
        }
      },
      child: const Text('Submit', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Donation Form - ${widget.organizationName}",
          style: const TextStyle(fontSize: 25),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  categoryField,
                  const SizedBox(height: 10),
                  optionField,
                  const SizedBox(height: 10),
                  weightField,
                  const SizedBox(height: 10),
                  dateField,
                  const SizedBox(height: 10),
                  addressFields,
                  addAddressButton,
                  const SizedBox(height: 10),
                  contactNoField,
                  const SizedBox(height: 20),
                  submitButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
