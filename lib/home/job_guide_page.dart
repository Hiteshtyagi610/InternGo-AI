import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

class JobGuidePage extends StatelessWidget {
  const JobGuidePage({super.key});

  final List<Map<String, dynamic>> guideItems = const [
    {
      'icon': LucideIcons.fileText,
      'title': 'Resume Writing',
      'subtitle': 'Craft standout resumes',
      'color1': Color(0xFF6EE7B7),
      'color2': Color(0xFF3B82F6),
    },
    {
      'icon': LucideIcons.mail,
      'title': 'Cover Letters',
      'subtitle': 'Write impressive intros',
      'color1': Color(0xFFFFD6E8),
      'color2': Color(0xFFFB7185),
    },
    {
      'icon': LucideIcons.briefcase,
      'title': 'Job Search',
      'subtitle': 'Explore your dream job',
      'color1': Color(0xFFFFF3C7),
      'color2': Color(0xFFFACC15),
    },
    {
      'icon': LucideIcons.userCheck,
      'title': 'Interview Tips',
      'subtitle': 'Crack your next interview',
      'color1': Color(0xFFD8B4FE),
      'color2': Color(0xFF9333EA),
    },
    {
      'icon': LucideIcons.bookOpen,
      'title': 'Internship Prep',
      'subtitle': 'Prepare like a pro',
      'color1': Color(0xFFBBF7D0),
      'color2': Color(0xFF10B981),
    },
    {
      'icon': LucideIcons.network,
      'title': 'Networking',
      'subtitle': 'Build real connections',
      'color1': Color(0xFFBAE6FD),
      'color2': Color(0xFF0EA5E9),
    },
  ];
PreferredSizeWidget buildModernAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Resume Generator",
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: buildModernAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: guideItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = guideItems[index];
            return GestureDetector(
              onTap: () {
                // Future navigation or interaction
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [item['color1'], item['color2']],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: item['color2'].withOpacity(0.25),
                      offset: const Offset(0, 8),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        item['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
