import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class Download_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _yY = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Download Mobile App version",
              style: GoogleFonts.aBeeZee(fontSize: _yY * 0.05),
            ),
            Link(
              target: LinkTarget.self,
              uri: Uri.parse(""),
              builder: (context, followlink) => ElevatedButton(
                onPressed: followlink,
                child: Text("Download"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
