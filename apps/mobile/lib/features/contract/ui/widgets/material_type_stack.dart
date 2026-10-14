import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class MaterialTypeStack extends StatelessWidget {
  const MaterialTypeStack({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final kinds = [
      ('pdf', colors.purpleSoft, colors.purple),
      ('document', colors.orangeSoft, colors.orange),
      ('audio', colors.pinkSoft, colors.pink),
      ('link', colors.skySoft, colors.sky),
    ];
    return SizedBox(
      width: ContractTokens.materialTypesWidth,
      height: ContractTokens.materialTypesHeight,
      child: Stack(
        children: [
          for (var index = 0; index < kinds.length; index++)
            Positioned(
              left: index * ContractTokens.materialTypeOffset,
              top: ContractTokens.materialTypeInset,
              child: _tile(context, kinds[index]),
            ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, (String, Color, Color) kind) => Container(
    width: ContractTokens.materialTypeSize,
    height: ContractTokens.materialTypeSize,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: kind.$2,
      border: Border.all(
        color: AppColors.of(context).surface,
        width: WidgetTokens.activeWidth,
      ),
      borderRadius: BorderRadius.circular(ContractTokens.materialTypeRadius),
    ),
    child: SvgPicture.asset(
      'assets/icons/material_type_${kind.$1}.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(kind.$3, BlendMode.srcIn),
    ),
  );
}
