import 'package:auscurator/widgets/shimmer_custom.dart';
import 'package:auscurator/widgets/size_unit.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/theme_guided.dart';
import 'package:flutter/material.dart';

class ShimmerList1 extends StatelessWidget {
  const ShimmerList1({super.key, this.height});
  final double? height;
  @override
  Widget build(BuildContext context) {
    return ShimmerCustom(
      child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
              SizeUnit.lg, SizeUnit.lg, SizeUnit.lg, SizeUnit.lg * 6),
          itemBuilder: (_, i) => LayoutBuilder(builder: (context, constraints) {
                return Container(
                    decoration: ThemeGuide.cardDecoration(), height: 100);
              }),
          separatorBuilder: (_, i) => const HeightFull(),
          itemCount: 10),
    );
  }
}