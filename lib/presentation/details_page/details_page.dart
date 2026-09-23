import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmu_course/domain/models/card.dart';

class DetailsPage extends StatelessWidget {
  final CardEmployeeData data;
  
  const DetailsPage(this.data, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Image.asset(data.imageUrl ?? ''),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 4.2),
            child: Text(
              data.text,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Text(
            data.descriptionText,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}