// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  void _startNFCScanSession() async {
    print('Scanning started...');

    await NfcManager.instance.startSession(
      // These polling options will help us read our YubiKey.
      // The YubiKey will use read at iso14443
      pollingOptions: {
        NfcPollingOption.iso14443,
      },
      onDiscovered: (NfcTag tag) async {
        // When a tag is detected, we will add functionality here
        // to decode the tag and stop the NFC scanning.
        print('Tag Detected!');

        Ndef? ndef = Ndef.from(tag);

        if (ndef == null) {
          print('Tag not compatible with NDEF');
          return;
        }

        print('Tag Data: ${tag.data}');

        // Stop NFC Scan Session now that we have read our tag
        // and accessed the data.
        _stopNFCScanSession();
      },
    );
  }

  void _stopNFCScanSession() async {
    await NfcManager.instance.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Testing NFC Scanning...',
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startNFCScanSession,
                child: const Text(
                  'Start Scanning',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
