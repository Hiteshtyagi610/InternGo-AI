import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intern_go/home/bottom_nav_bar.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:confetti/confetti.dart';

class DataUpdatePage extends StatefulWidget {
  const DataUpdatePage({Key? key}) : super(key: key);

  @override
  State<DataUpdatePage> createState() => _DataUpdatePageState();
}

class _DataUpdatePageState extends State<DataUpdatePage> with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _resumeLinkController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _locationController = TextEditingController();
  final _domainController = TextEditingController();

  final List<String> _skillsList = [
    "Flutter", "Firebase", "Django", "Node.js", "React", "Machine Learning",
    "iOS", "Android", "Backend", "Frontend", "UI/UX", "Data Science","Python","React",
   "Digital Marketing","SEO","Content Writing","UI/UX Design","Graphic Design","Java",
  "Kotlin","Data Analysis","Project Management","Social Media Management","Law",
  ];
  List<String> _selectedSkills = [];

  late AnimationController _iconController;
  late ConfettiController _confettiController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _iconController.dispose();
    _confettiController.dispose();
    _usernameController.dispose();
    _resumeLinkController.dispose();
    _linkedInController.dispose();
    _locationController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final email = user.email;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': _usernameController.text.trim(),
      'resumeLink': _resumeLinkController.text.trim(),
      'linkedIn': _linkedInController.text.trim(),
      'skills': _selectedSkills,
      'locationPreferences':
          _locationController.text.split(',').map((s) => s.trim()).toList(),
      'jobDomains':
          _domainController.text.split(',').map((s) => s.trim()).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  PreferredSizeWidget buildModernAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.blue.withOpacity(0.7),
            elevation: 10,
            title: Row(
              children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_iconController),
                  child: const Icon(LucideIcons.brainCircuit, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Intern Go AI",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget neumorphicField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  bool validateStep(int step) {
    switch (step) {
      case 0:
        return _usernameController.text.isNotEmpty &&
            _linkedInController.text.isNotEmpty;
      case 1:
        return _resumeLinkController.text.isNotEmpty &&
            _selectedSkills.isNotEmpty;
      case 2:
        return _locationController.text.isNotEmpty &&
            _domainController.text.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildModernAppBar(),
          backgroundColor: const Color(0xFFEFF4FB),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep--);
              },
              onStepContinue: () async {
                if (validateStep(_currentStep)) {
                  if (_currentStep < 2) {
                    setState(() => _currentStep++);
                  } else {
                    _confettiController.play();
                    await _saveUserData();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated successfully!")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const BottomNavBar()),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please complete all required fields")),
                  );
                }
              },
              controlsBuilder: (context, details) => Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? 'Finish' : 'Next'),
                  ),
                  if (_currentStep > 0)
                    TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back')),
                ],
              ),
              steps: [
                Step(
                  title: const Text("Basic Info"),
                  content: Column(
                    children: [
                      neumorphicField(
                          icon: LucideIcons.user,
                          label: "Username",
                          controller: _usernameController),
                      neumorphicField(
                          icon: LucideIcons.linkedin,
                          label: "LinkedIn",
                          controller: _linkedInController),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text("Career"),
                  content: Column(
                    children: [
                      neumorphicField(
                          icon: LucideIcons.fileText,
                          label: "Resume Link",
                          controller: _resumeLinkController),
                      const SizedBox(height: 10),
                      MultiSelectDialogField(
                        items: _skillsList
                            .map((skill) => MultiSelectItem(skill, skill))
                            .toList(),
                        title: const Text("Skills"),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        buttonIcon: const Icon(Icons.code),
                        buttonText: const Text("Choose Skills"),
                        onConfirm: (results) =>
                            _selectedSkills = results.cast<String>(),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text("Preferences"),
                  content: Column(
                    children: [
                      neumorphicField(
                          icon: LucideIcons.mapPin,
                          label: "Preferred Locations",
                          controller: _locationController),
                      neumorphicField(
                          icon: LucideIcons.briefcase,
                          label: "Job Domains",
                          controller: _domainController),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 15,
            minBlastForce: 5,
          ),
        ),
      ],
    );
  }
}
