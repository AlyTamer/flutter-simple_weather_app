import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecast({
    super.key,
    required this.time,
    required this.temp,
    required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadiusGeometry.circular(16.0)),
        child:  Column(
          children: [
            Text(time,
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            const SizedBox(height:8),
            Icon(icon,size: 32,),
            const SizedBox(height:8),
            Text(temp),
          ],
        ),
      ),
    );
  }
}