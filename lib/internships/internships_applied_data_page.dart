import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class InternshipsAppliedDataPage extends StatefulWidget {
  const InternshipsAppliedDataPage({Key? key}) : super(key: key);

  @override
  State<InternshipsAppliedDataPage> createState() => _InternshipsAppliedDataPageState();
}

class _InternshipsAppliedDataPageState extends State<InternshipsAppliedDataPage> {
  List<dynamic> jobs = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();
  String currentSkill = "";

  @override
  void initState() {
    super.initState();
    fetchJobs(); // fetch all jobs initially
  }

  Future<void> fetchJobs({String skill = ""}) async {
    setState(() => loading = true);

    try {
      final url = skill.isEmpty
          ? Uri.parse("https://remotive.com/api/remote-jobs")
          : Uri.parse("https://remotive.com/api/remote-jobs?search=$skill");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          jobs = data['jobs'] ?? [];
          loading = false;
        });
      } else {
        setState(() => loading = false);
        print("Failed to fetch jobs: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => loading = false);
      print("Error fetching jobs: $e");
    }
  }
  PreferredSizeWidget buildModernAppBar(BuildContext context) {
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF00BCD4), // cyan
                        Color(0xFF2196F3), // blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Intern Go AI",
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
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

  Widget _buildJobCard(dynamic job) {
    final title = job['title'] ?? 'No Title';
    final company = job['company_name'] ?? 'Unknown Company';
    final location = job['candidate_required_location'] ?? 'Remote';
    final tags = (job['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final url = job['url'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company),
            Text("📍 $location"),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: tags.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.blue.shade50,
              )).toList(),
            ),
          ],
        ),
        trailing: url.isNotEmpty ? const Icon(Icons.open_in_new) : null,
        onTap: () {
          if (url.isNotEmpty) launchUrl(Uri.parse(url));
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: buildModernAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search jobs by skill...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    fetchJobs();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                currentSkill = value.trim();
                fetchJobs(skill: currentSkill);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetchJobs(skill: currentSkill),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : jobs.isEmpty
                      ? const Center(child: Text("🚫 No jobs found"))
                      : ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (context, index) => _buildJobCard(jobs[index]),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
