import 'package:breaking_project/business_logic/CopounsCubit/copouns_cubit.dart';
import 'package:breaking_project/business_logic/CopounsCubit/copouns_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CopounsCubit>(context).getAllCopouns();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // واجهة عربية
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            "كوبوناتي",
            style: GoogleFonts.cairo(),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CopounsCubit, CopounsStates>(
          builder: (context, state) {
            if (state is CopounsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CopounsSuccess) {
              final copuns = state.copuns;
              return ListView.builder(
                itemCount: copuns.length,
                itemBuilder: (context, index) {
                  final coupon = copuns[index];
                  return ListTile(
                    title: Text("كود: ${coupon.coupon}"),
                    subtitle: Text("القيمة: ${coupon.value}"),
                  );
                },
              );
            } else if (state is CopounsEmpty) {
              return const Center(
                child: Text("لا يوجد كوبونات متاحة"),
              );
            } else if (state is CopounsError) {
              return Center(
                child: Text("خطأ: ${state.message}"),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
