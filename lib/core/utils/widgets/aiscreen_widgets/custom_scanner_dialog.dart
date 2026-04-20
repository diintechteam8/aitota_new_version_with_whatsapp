import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app-export.dart';

class CustomScannerDialog extends StatelessWidget {
  final Function(String) onDetect;

  const CustomScannerDialog({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: Get.width * 0.9,
        height: Get.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.appThemeColor.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 10,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorConstants.appThemeColor,
                    ColorConstants.appThemeColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.qr_code_scanner,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan Agent QR Code',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Point camera at agent QR code to connect',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.85),
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: ColorConstants.appThemeColor.withOpacity(0.35),
                      width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.appThemeColor.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Stack(
                    children: [
                      MobileScanner(
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            final String? code = barcode.rawValue;
                            if (code != null && code.isNotEmpty) {
                              Navigator.of(context).pop();
                              onDetect(code);
                              return;
                            }
                          }
                        },
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                              left: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                              right: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                              left: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                              right: BorderSide(
                                  color: ColorConstants.appThemeColor,
                                  width: 4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: ColorConstants.appThemeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Position QR code within the frame',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.appThemeColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              ColorConstants.appThemeColor.withOpacity(0.25)),
                    ),
                    child: Text(
                      'Scanning...',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.appThemeColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
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
