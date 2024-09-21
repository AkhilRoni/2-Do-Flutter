import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tudo/config/theme_provider.dart";

class OptionBox extends StatelessWidget {
  final String optionName;
  final String iconPath;
  final Widget screenPath;
  final Function toggleFrame;

  const OptionBox(
      {super.key,
      required this.optionName,
      required this.iconPath,
      required this.screenPath,
      required this.toggleFrame});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          if (optionName == "Theme") {
            toggleFrame();
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            // Trigger animation here when mode is toggled
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => screenPath));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                iconPath,
                height: 65,
                color: Theme.of(context).iconTheme.color,
              ),
              Text(
                optionName,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
