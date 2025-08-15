// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_cubit.dart';
import 'package:breaking_project/business_logic/CancelOrderCubit/cancel_order_states.dart';
import 'package:flutter/material.dart';

import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CancelOrderScreen extends StatefulWidget {
  String? id;
  CancelOrderScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  TextEditingController _customReasonController = TextEditingController();
  bool _showCustomReasonField = false;

  final List<String> _cancellationReasons = [
    'Just trying the app',
    'Changed my mind',
    'No technician assigned',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  void _selectReason(String reason) {
    setState(() {
      _selectedReason = reason;
      if (reason == 'Custom reason') {
        _showCustomReasonField = true;
      } else {
        _showCustomReasonField = false;
      }
    });
    print('Selected reason: $reason');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CancelOrderCubit, CancelOrderStates>(
        listener: (context, state) {
          if (state is CancelOrderLoading) {
            Get.defaultDialog(
              title: "...جاري التحميل ",
              titleStyle: TextStyle(fontFamily: "Cairo"),
              content: const Column(
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 10),
                  Text(
                    "الرجاء الانتظار.",
                    style: TextStyle(fontFamily: "Cairo"),
                  ),
                ],
              ),
              barrierDismissible: false,
            );
          } else if (state is CancelOrderSuccess) {
            Get.back();
            Get.defaultDialog(
              title: '',
              titlePadding:
                  EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
              content: Column(
                children: [
                  Container(
                      width: 32,
                      height: 32,
                      child: SvgPicture.asset("assets/images/svg/checkc.svg")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Your cancellation order was submitted",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(71, 71, 71, 1)),
                  ),
                ],
              ),
              middleText: "Enter Correct Informations",
              backgroundColor: Colors.white,
              middleTextStyle: TextStyle(color: Colors.black),
              confirm: Padding(
                padding: const EdgeInsets.only(left: 63, right: 63, bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomElevatedButton(
                      text: 'ok',
                      onpressed: () {
                        Get.toNamed("mainscreen");
                      }),
                ),
              ),
              barrierDismissible: false,
            );
          } else {
            if (Get.isDialogOpen!) {
              Get.back();
            }
          }

          if (state is CancelOrderError) {
            Get.snackbar("Error", state.message,
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Cancellation Reason',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                ..._cancellationReasons
                    .map((reason) => _buildReasonButton(reason)),
                _buildReasonButton('Custom reason'),
                if (_showCustomReasonField)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField(
                      controller: _customReasonController,
                      decoration: InputDecoration(
                        hintText: 'Enter your custom reason here...',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (text) {
                        // print('Custom reason input: $text');
                        _selectedReason = _customReasonController.text;
                        print('selected reason $_selectedReason');
                      },
                    ),
                  ),
                //Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                      onpressed: _selectedReason != null
                          ? () {
                              String finalReason = _selectedReason!;
                              if (_selectedReason == 'Custom reason') {
                                finalReason =
                                    _customReasonController.text.trim().isEmpty
                                        ? 'Custom reason (no text provided)'
                                        : _customReasonController.text.trim();
                              }
                              print(
                                  'Final reason for cancellation: $finalReason');
                              context.read<CancelOrderCubit>().cancelorder(
                                  id: widget.id!, reason: _selectedReason!);
                            }
                          : null,
                      text: 'confirm cancellation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonButton(String reason) {
    bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () => _selectReason(reason),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 1.0)
              : Border.all(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            reason,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
