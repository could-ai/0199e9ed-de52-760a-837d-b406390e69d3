import 'package:flutter/material.dart';

void main() {
  runApp(const VexaApp());
}

class VexaApp extends StatelessWidget {
  const VexaApp({super.key});

  @Override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEXA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        hintColor: Colors.purpleAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        ).copyWith(
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const VexaHomePage(),
    );
  }
}

class VexaHomePage extends StatefulWidget {
  const VexaHomePage({super.key});

  @override
  State<VexaHomePage> createState() => _VexaHomePageState();
}

class _VexaHomePageState extends State<VexaHomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addVexaMessage("Olá! Sou a VEXA. Diga o que quer, e a VEXA cria.");
  }

  void _addVexaMessage(String text, {List<Widget>? actions}) {
    setState(() {
      _messages.insert(0, {"sender": "vexa", "text": text, "actions": actions});
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.insert(0, {"sender": "user", "text": text});
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _addUserMessage(text);
    _textController.clear();

    // Simulate VEXA's response
    Future.delayed(const Duration(milliseconds: 500), () {
      _addVexaMessage(
        "Entendido. Você quer ver o protótipo ou a versão final?",
        actions: [
          ElevatedButton(
            onPressed: () => _handleChoice("prototype"),
            child: const Text("🧱 Modo Protótipo"),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _handleChoice("final"),
            child: const Text("⚙️ Modo Versão Final"),
          ),
        ],
      );
    });
  }

  void _handleChoice(String choice) {
    // Remove the choice buttons after selection
    setState(() {
      _messages.firstWhere((msg) => msg["actions"] != null)["actions"] = null;
    });

    if (choice == "prototype") {
      _addVexaMessage(
        "Gerando seu app em modo protótipo... pronto!",
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.download),
            label: const Text("Baixar Protótipo"),
            onPressed: () {},
          ),
          TextButton.icon(
            icon: const Icon(Icons.code),
            label: const Text("Criar Versão Final"),
            onPressed: () => _handleChoice("final"),
          ),
        ],
      );
    } else {
      _addVexaMessage(
        "Gerando a versão final completa do seu app...",
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.file_zip),
            label: const Text("Baixar Versão Final"),
            onPressed: () {},
          ),
          TextButton.icon(
            icon: const Icon(Icons.link),
            label: const Text("Gerar Link Público"),
            onPressed: () {},
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VEXA", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "“Diga o que quer, e a VEXA cria.”",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.purpleAccent,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isVexa = message["sender"] == "vexa";
                return Align(
                  alignment: isVexa ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isVexa ? Colors.grey[900] : Colors.purple,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["text"],
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (message["actions"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: message["actions"],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: "Descreva seu app ou site...",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.purpleAccent),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}
