import 'dart:convert';

import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';

import '../../../config/app_format.dart';
import '../../controller/history/c_add_history.dart';

class AddHistoryPage extends StatelessWidget {
  AddHistoryPage({Key? key}) : super(key: key);
  final cAddHistory = Get.put(CAddHistory());
  final cUser = Get.put(CUser());
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();

  addHistory() async {
    bool success = await SourceHistory.add(
        cUser.data.idUser!,
        cAddHistory.date,
        cAddHistory.type,
        jsonEncode(cAddHistory.items),
        cAddHistory.total.toString(),
    );

    if(success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Tambah Baru'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Obx(
                () {
                  return Text(cAddHistory.date);
                }
              ),
              DView.width(16),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? result = await showDatePicker(
                   context: context,
                   initialDate: DateTime.now(),
                   firstDate: DateTime(2024,01,01),
                    lastDate: DateTime(DateTime.now().year+1),
                  );
                  if(result != null) {
                    cAddHistory.setDate(DateFormat('yyyy-MM-dd').format(result));
                  }
                },
                icon: const Icon(Icons.event),
                label: const Text('Pilih'),
              )
            ],
          ),
          DView.height(),
          const Text(
            "Tipe",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(4),
          Obx(
            () {
              return DropdownButtonFormField(
                value: cAddHistory.type,
                items: ['Pemasukan', 'Pengeluaran'].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  cAddHistory.setType(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true
                ),
              );
            }
          ),
          DView.height(),
          DInput(
            controller: controllerName,
            hint: 'Jualan',
            title: 'Sumber/Objek Pengeluaran',
          ),
          DView.height(),
          DInput(
            controller: controllerPrice,
            hint: '30000',
            title: 'Harga',
            inputType: TextInputType.number,
          ),
          DView.height(),
          ElevatedButton(
            onPressed: () {
              cAddHistory.addItem({
                'name': controllerName.text,
                'price': controllerPrice.text,
              });
              controllerName.clear();
              controllerPrice.clear();
            },
            child: const Text('Tambah ke items'),
          ),
          DView.height(),
          Center(
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.bgColor,
                borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),
          DView.height(),
          const Text(
            "Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: GetBuilder<CAddHistory>(
              builder: (_) {
                return Wrap(
                  runSpacing: 0,
                  spacing: 8,
                  children: List.generate(_.items.length, (index) {
                    return Chip(
                      label: Text(_.items[index]['name']),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () => _.deleteItem(index),
                    );
                  })
                );
              }
            ),
          ),
          DView.height(),
          Row(
            children: [
              const Text(
                "Total:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DView.width(8),
              Obx(
                () {
                  return Text(
                    AppFormat.currency(cAddHistory.total.toString()),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                  );
                }
              ),
            ],
          ),
          DView.height(30),
          Material(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => addHistory(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'SUBMIT',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
