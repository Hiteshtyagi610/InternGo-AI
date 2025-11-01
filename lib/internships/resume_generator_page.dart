import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

final String geminiApiKey = 'xxxxx'; // Replace with your Gemini API Key

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class ResumeChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  void addMessage(Message msg) {
    _messages.add(msg);
    notifyListeners();
  }
}

Future<String> fetchResumeAIResponse(String prompt) async {
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$geminiApiKey',
  );
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'contents': [
      {
        'parts': [
          {'text': prompt}
        ]
      }
    ]
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    try {
      return decoded['candidates'][0]['content']['parts'][0]['text'].toString();
    } catch (e) {
      return "⚠️ Failed to parse AI response.";
    }
  } else {
    return "❌ API Error:\n${response.body}";
  }
}

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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ResumeChatProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResumeChatScreen(),
      ),
    ),
  );
}

class ResumeChatScreen extends StatefulWidget {
  @override
  State<ResumeChatScreen> createState() => _ResumeChatScreenState();
}

class _ResumeChatScreenState extends State<ResumeChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  void _sendMessage(BuildContext context, String text) async {
    if (text.trim().isEmpty || _loading) return;
    final provider = Provider.of<ResumeChatProvider>(context, listen: false);

    provider.addMessage(Message(text: text, isUser: true));
    _controller.clear();
    setState(() => _loading = true);

    String reply = await fetchResumeAIResponse(text);

    setState(() => _loading = false);
    provider.addMessage(Message(text: reply, isUser: false));
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<ResumeChatProvider>(context).messages;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: buildModernAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.06,
                child: Center(
                  child: Icon(
                    Icons.description_rounded,
                    size: 280,
                    color: Colors.blue.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Row(
                        mainAxisAlignment: msg.isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!msg.isUser)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Tooltip(
                                message: "ResumeBot",
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.blue.withOpacity(0.6),
                                  child: Icon(Icons.smart_toy,
                                      color: Colors.white),
                                  radius: 18,
                                ),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: msg.isUser
                                    ? Colors.blue.withOpacity(0.6)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft:
                                      Radius.circular(msg.isUser ? 16 : 4),
                                  bottomRight:
                                      Radius.circular(msg.isUser ? 4 : 16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          if (msg.isUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Tooltip(
                                message: "You",
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.blue.withOpacity(0.6),
                                  child: Icon(Icons.person, color: Colors.white),
                                  radius: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_loading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "ResumeBot is typing...",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.08),
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Type your resume query...",
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) =>
                              _sendMessage(context, text),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: _loading
                          ? null
                          : () => _sendMessage(context, _controller.text),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              _loading ? Colors.grey : Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
