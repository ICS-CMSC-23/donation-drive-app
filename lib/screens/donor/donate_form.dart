import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/organization_model.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/donor_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DonationFormPage extends StatefulWidget {
  final Organization organization;

  const DonationFormPage({Key? key, required this.organization})
      : super(key: key);

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> selectedCategories = [];
  String? selectedOption;
  TextEditingController weightController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<TextEditingController> addressesController = [TextEditingController()];
  TextEditingController contactNoController = TextEditingController();
  PlatformFile? pickedFile;
  File? capturedImage;
  String? uploadedFileUrl;

  final categories = ['Food', 'Clothes', 'Cash', 'Necessities', 'Others'];
  final options = ['Pickup', 'Drop-off'];

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<void> captureImage() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        setState(() {
          capturedImage = File(pickedImage.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera and storage permissions are required')),
      );
    }
  }

  Future<String?> uploadFile() async {
    if (pickedFile == null && capturedImage == null) return null;

    final path =
        'donations/${pickedFile?.name ?? capturedImage!.path.split('/').last}';
    final ref = FirebaseStorage.instance.ref().child(path);

    if (kIsWeb) {
      final uploadTask = ref.putData(pickedFile!.bytes!);
      final snapshot = await uploadTask.whenComplete(() => {});
      final fileUrl = await snapshot.ref.getDownloadURL();
      return fileUrl;
    } else {
      final file =
          pickedFile != null ? File(pickedFile!.path!) : capturedImage!;
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final fileUrl = await snapshot.ref.getDownloadURL();
      return fileUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryField = Column(
      children: categories.map((String category) {
        return CheckboxListTile(
          title: Text(category),
          value: selectedCategories.contains(category),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedCategories.add(category);
              } else {
                selectedCategories.remove(category);
              }
            });
          },
        );
      }).toList(),
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
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            setState(() {
              final DateTime combinedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              dateController.text =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
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
          Row(
            children: [
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
            ],
          ),
      ],
    );

    final filePickerButton = ElevatedButton(
      onPressed: selectFile,
      child: const Text('Select File'),
    );

    final cameraButton = ElevatedButton(
      onPressed: captureImage,
      child: const Text('Capture Image'),
    );

    final fileNameText = Text(pickedFile?.name ??
        capturedImage?.path.split('/').last ??
        'No file selected');

    final submitButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 38, 32, 69)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(
                color: Color.fromARGB(255, 38, 32, 69), width: 2.0),
          ),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (pickedFile != null || capturedImage != null) {
            uploadedFileUrl = await uploadFile();
          }
          await _submitForm();
        }
      },
      child: const Text('Submit', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Donation Form - ${widget.organization.organizationName}",
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
                  filePickerButton,
                  cameraButton,
                  fileNameText,
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

  Future<void> _submitForm() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final donorProvider =
        Provider.of<DonorListProvider>(context, listen: false);

    if (authProvider.userObj == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be signed in to donate')),
      );
      return;
    }

    final donor =
        await donorProvider.getDonorByEmail(authProvider.userObj!.email!);

    if (donor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donor information not found')),
      );
      return;
    }

    final donation = Donation(
      organizationId: widget.organization.userId,
      categories: selectedCategories,
      isPickup: selectedOption == 'Pickup',
      weight: double.parse(weightController.text),
      dateTime: DateTime.parse(dateController.text),
      addresses:
          addressesController.map((controller) => controller.text).toList(),
      contactNo: contactNoController.text,
      status: 0,
      donorId: donor.userId!,
      photoUrl: uploadedFileUrl,
    );

    Provider.of<DonationListProvider>(context, listen: false)
        .addDonation(donation);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Donation submitted successfully')),
    );

    Navigator.pop(context); // Navigate back after submission
  }
}
