import 'package:flutter/material.dart';
import '../utils/svg_icons.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('LocationSelector tapped');
        // TODO: buka modal buat pilih lokasi atau halaman baru
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            SvgIcon.location(),
            const SizedBox(width: 8),
            const Text(
              'Deliver to',
              style: TextStyle(
                color: Color(0xFF404040),
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '3517 W. Gray St. Utica, Pennsylvania',
                style: const TextStyle(
                  color: Color(0xFF404040),
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SvgIcon.down(),
          ],
        ),
      ),
    );
  }
}
