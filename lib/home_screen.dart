import 'package:flutter/material.dart';
import 'package:url_shortener/http_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController urlController = TextEditingController();
  String url = '';
  String message = 'Please enter any url';
  bool isLoading = false;
  bool copyButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: const Text('Url Shortener'),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Center(
                child: Text('url'),
              ),
              TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (urlController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                            copyButton = false;
                          });
                          final shortenedUrl =
                              await Services().shortUrl(urlController.text);
                          setState(() {
                            url = shortenedUrl;
                            isLoading = false;
                            copyButton = true;
                          });
                        } else {
                          setState(() {
                            url = message;
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text('Shorten the url'),
                    ),
              GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(url);
                    if (url != message && await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Text(url)),
              copyButton
                  ? IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: url));
                      },
                      icon: const Icon(Icons.copy),
                    )
                  : const SizedBox()
            ],
          ),
        )));
  }
}
