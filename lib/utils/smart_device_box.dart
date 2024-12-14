import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartDeviceBox extends StatelessWidget {
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  final void Function(bool)? onChanged;

  SmartDeviceBox({
    super.key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: powerOn ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // icon
            Image.asset(
              iconPath,
              height: 65,
              color: powerOn ? Colors.white : Colors.black,
            ),
            SizedBox(height: 20),
            // smart device name
            Text(
              smartDeviceName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: powerOn ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Divider
            Divider(
              color: powerOn
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              thickness: 1,
              indent: 25,
              endIndent: 25,
            ),
            SizedBox(height: 10),
            // On/Off text and switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    powerOn ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: powerOn ? Colors.white : Colors.black,
                    ),
                  ),
                  CupertinoSwitch(
                    value: powerOn,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
