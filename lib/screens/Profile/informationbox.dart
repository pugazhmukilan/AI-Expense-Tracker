
import 'package:ai_expense/utils/editbutton.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:flutter/material.dart';

class InformationBox extends StatelessWidget {
  const InformationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Name : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    LocalStorage.getString("name").toString(),
                    style: const TextStyle(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: EditButton(
                func: () {
                  // TODO: Edit profile functionality
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}