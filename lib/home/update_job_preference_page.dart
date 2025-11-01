import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intern_go/home/bottom_nav_bar.dart';

class JobPreferenceUpdatePage extends StatefulWidget {
  const JobPreferenceUpdatePage({Key? key}) : super(key: key);

  @override
  State<JobPreferenceUpdatePage> createState() => _JobPreferenceUpdatePageState();
}

class _JobPreferenceUpdatePageState extends State<JobPreferenceUpdatePage>
    with TickerProviderStateMixin {
  final _applicationsController = TextEditingController();
  String? salaryPriority;
  String? locationPriority;
  String? frequency;
  String? duration;
  String? skillMatchPriority;
  String? companyType;

  late AnimationController _iconController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _iconController.dispose();
    _confettiController.dispose();
    _applicationsController.dispose();
    super.dispose();
  }

  Future<void> _saveJobPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "jobPreferences": {
        "autoApplyBatch": int.tryParse(_applicationsController.text.trim()) ?? 10,
        "salaryPriority": salaryPriority,
        "locationPriority": locationPriority,
        "frequency": frequency,
        "duration": duration,
        "skillMatchPriority": skillMatchPriority,
        "companyType": companyType,
        "updatedAt": FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));

    _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🎯 Job preferences updated successfully!")),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavBar()),
      );
    }
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
            backgroundColor: Colors.blueAccent.withOpacity(0.8),
            elevation: 10,
            title: Row(
              children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_iconController),
                  child: const Icon(LucideIcons.settings, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Auto Apply Preferences",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),
        ),
      ),
    );
  }

  Widget buildCard({required Widget child, required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              )),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget buildDropdown(
      String label, List<String> options, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.tune, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      value: value,
      items: options
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 15)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background for premium look
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe3f2fd), Color(0xFFf0f6ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildModernAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildCard(
                  title: "Auto Apply Settings",
                  child: TextFormField(
                    controller: _applicationsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.autorenew, color: Colors.blueAccent),
                      labelText: "Number of Auto Applications (per batch)",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                buildCard(
                  title: "Job Priorities",
                  child: Column(
                    children: [
                      buildDropdown("Salary Priority",
                          ["Highest First", "Medium Range", "Doesn't Matter"],
                          salaryPriority, (v) => setState(() => salaryPriority = v)),
                      const SizedBox(height: 10),
                      buildDropdown("Location Preference",
                          ["Nearest", "Remote", "Any Location"],
                          locationPriority, (v) => setState(() => locationPriority = v)),
                    ],
                  ),
                ),
                buildCard(
                  title: "Schedule & Matching",
                  child: Column(
                    children: [
                      buildDropdown("Application Frequency",
                          ["Daily", "Weekly", "Manual Trigger"],
                          frequency, (v) => setState(() => frequency = v)),
                      const SizedBox(height: 10),
                      buildDropdown("Internship Duration",
                          ["1-3 Months", "3-6 Months", "Flexible", "Apply for jobs only"],
                          duration, (v) => setState(() => duration = v)),
                      const SizedBox(height: 10),
                      buildDropdown("Skill Match Priority",
                          ["Strict Match", "Partial Match", "Open to All"],
                          skillMatchPriority, (v) => setState(() => skillMatchPriority = v)),
                    ],
                  ),
                ),
                buildCard(
                  title: "Company Preferences",
                  child: buildDropdown("Preferred Company Type",
                      ["Startup", "MNC", "Remote-Only", "No Preference"],
                      companyType, (v) => setState(() => companyType = v)),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    elevation: 6,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _saveJobPreferences,
                  label: const Text(
                    "Save Preferences",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40),
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
            numberOfParticles: 20,
            maxBlastForce: 10,
            minBlastForce: 4,
          ),
        ),
      ],
    );
  }
}
