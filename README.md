# 🤖 InternGo AI

InternGo AI is a full-stack **Flutter application** powered by **Firebase** and **Artificial Intelligence**, built to simplify how students and job seekers discover internships.
Instead of scrolling endlessly through listings, users can simply **upload their resume**, and the AI automatically analyzes it to extract skills, experience, and education — delivering **personalized internship recommendations** instantly.

The goal of InternGo AI is to **bridge the gap between students and companies**, offering an intelligent, accessible, and efficient way to connect talent with opportunities.

---

🔐 **Key Features**
🧠 **AI Resume Parsing** – Upload your resume (PDF), and the AI extracts important data such as skills, experience, and education.
🎯 **Smart Internship Matching** – Get internship suggestions tailored to your background and goals.
👤 **Personalized Dashboard** – View, edit, and manage your profile, parsed data, and saved internships.
☁️ **Firebase Integration** – Authentication, Firestore database, and cloud storage ensure real-time and secure data management.
📍 **Modern Flutter UI** – Clean, minimal, and fully responsive interface for smooth user experience.
🚀 **Cross-Platform Support** – Runs seamlessly on both Android and iOS.

---

🚧 **Tech Stack**

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase Auth, Firestore, Firebase Storage
* **AI Layer:** Python (Firebase Cloud Functions), PyMuPDF, SpaCy for NLP-based parsing
* **State Management:** Provider
* **Tools & Services:** GitHub, VS Code, Firebase CLI

---

🔧 **How to Run**

1️⃣ Clone the repository

```bash
git clone https://github.com/Hiteshtyagi610/InternGo-AI.git
```

2️⃣ Navigate to the project folder

```bash
cd InternGo-AI
```

3️⃣ Install dependencies

```bash
flutter pub get
```

4️⃣ Connect Firebase

* Add `google-services.json` in `android/app/`
* Add `GoogleService-Info.plist` in `ios/Runner/`

5️⃣ Run the app

```bash
flutter run
```

6️⃣ (Optional) Deploy the Python Cloud Function

```bash
cd functions
firebase deploy --only functions
```

---

💡 **How the AI Works**

1. User uploads a **PDF resume**
2. Cloud Function extracts text using **PyMuPDF**
3. **SpaCy NLP Model** processes the text and identifies key details (skills, name, experience)
4. Parsed data is stored in **Firestore**
5. The app fetches updated user data and shows **AI-powered internship suggestions**

---

📱 **Future Enhancements**

* 🤖 Chatbot for career & internship queries
* 💬 Push notifications for new internship matches
* 💼 Employer dashboard for posting and managing listings
* 🔍 Smart search filters (location, role, stipend)
* 🌐 Resume builder and profile insights

---

🙋‍♂️ **Developer**

**Hitesh Tyagi**
Flutter Developer • AI Integration • Firebase Cloud

GitHub: [Hiteshtyagi610](https://github.com/Hiteshtyagi610)
LinkedIn: [Hitesh Tyagi](https://www.linkedin.com/in/hitesh-tyagi-1838a4282/)

---

⭐ **If you like this project, please give it a star!**
Your support motivates continued development and new features ✨

