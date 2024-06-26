import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MyScanner extends StatelessWidget {
  const MyScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerSimple(),
                  ),
                );
              },
              child: const Text('MobileScanner Simple'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerListView(),
                  ),
                );
              },
              child: const Text('MobileScanner with ListView'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerWithController(),
                  ),
                );
              },
              child: const Text('MobileScanner with Controller'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerWithScanWindow(),
                  ),
                );
              },
              child: const Text('MobileScanner with ScanWindow'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerReturningImage(),
                  ),
                );
              },
              child: const Text(
                'MobileScanner with Controller (returning image)',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerWithZoom(),
                  ),
                );
              },
              child: const Text('MobileScanner with zoom slider'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerPageView(),
                  ),
                );
              },
              child: const Text('MobileScanner pageView'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BarcodeScannerWithOverlay(),
                  ),
                );
              },
              child: const Text('MobileScanner with Overlay'),
            ),
          ],
        ),
      ),
    );
  }
}

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({super.key});

  @override
  State<BarcodeScannerWithController> createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,
    torchEnabled: true,
    useNewCameraSelector: true,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With controller')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  StartStopMobileScannerButton(controller: controller),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                  SwitchCameraButton(controller: controller),
                  AnalyzeImageFromGalleryButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}
//
//
//

class BarcodeScannerWithScanWindow extends StatefulWidget {
  const BarcodeScannerWithScanWindow({super.key});

  @override
  State<BarcodeScannerWithScanWindow> createState() =>
      _BarcodeScannerWithScanWindowState();
}

class _BarcodeScannerWithScanWindowState
    extends State<BarcodeScannerWithScanWindow> {
  final MobileScannerController controller = MobileScannerController();

  Widget _buildBarcodeOverlay() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized || !value.isRunning || value.error != null) {
          return const SizedBox();
        }

        return StreamBuilder<BarcodeCapture>(
          stream: controller.barcodes,
          builder: (context, snapshot) {
            final BarcodeCapture? barcodeCapture = snapshot.data;

            // No barcode.
            if (barcodeCapture == null || barcodeCapture.barcodes.isEmpty) {
              return const SizedBox();
            }

            final scannedBarcode = barcodeCapture.barcodes.first;

            // No barcode corners, or size, or no camera preview size.
            if (scannedBarcode.corners.isEmpty ||
                value.size.isEmpty ||
                barcodeCapture.size.isEmpty) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: BarcodeOverlay(
                barcodeCorners: scannedBarcode.corners,
                barcodeSize: barcodeCapture.size,
                boxFit: BoxFit.contain,
                cameraPreviewSize: value.size,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('With Scan window')),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.contain,
            scanWindow: scanWindow,
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
          _buildBarcodeOverlay(),
          _buildScanWindow(scanWindow),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: ScannedBarcodeLabel(barcodes: controller.barcodes),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcodeCorners,
    required this.barcodeSize,
    required this.boxFit,
    required this.cameraPreviewSize,
  });

  final List<Offset> barcodeCorners;
  final Size barcodeSize;
  final BoxFit boxFit;
  final Size cameraPreviewSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcodeCorners.isEmpty ||
        barcodeSize.isEmpty ||
        cameraPreviewSize.isEmpty) {
      return;
    }

    final adjustedSize = applyBoxFit(boxFit, cameraPreviewSize, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final double ratioWidth;
    final double ratioHeight;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      ratioWidth = barcodeSize.width / adjustedSize.destination.width;
      ratioHeight = barcodeSize.height / adjustedSize.destination.height;
    } else {
      ratioWidth = cameraPreviewSize.width / adjustedSize.destination.width;
      ratioHeight = cameraPreviewSize.height / adjustedSize.destination.height;
    }

    final List<Offset> adjustedOffset = [
      for (final offset in barcodeCorners)
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
    ];

    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
//
//
//

class BarcodeScannerReturningImage extends StatefulWidget {
  const BarcodeScannerReturningImage({super.key});

  @override
  State<BarcodeScannerReturningImage> createState() =>
      _BarcodeScannerReturningImageState();
}

class _BarcodeScannerReturningImageState
    extends State<BarcodeScannerReturningImage> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
    returnImage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Returning image')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<BarcodeCapture>(
                stream: controller.barcodes,
                builder: (context, snapshot) {
                  final barcode = snapshot.data;

                  if (barcode == null) {
                    return const Center(
                      child: Text(
                        'Your scanned barcode will appear here!',
                      ),
                    );
                  }

                  final barcodeImage = barcode.image;

                  if (barcodeImage == null) {
                    return const Center(
                      child: Text('No image for this barcode.'),
                    );
                  }

                  return Image.memory(
                    barcodeImage,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text('Could not decode image bytes. $error'),
                      );
                    },
                    frameBuilder: (
                      BuildContext context,
                      Widget child,
                      int? frame,
                      bool? wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded == true || frame != null) {
                        return Transform.rotate(
                          angle: 90 * 3.14 / 180,
                          child: child,
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: ColoredBox(
                color: Colors.grey,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      errorBuilder: (context, error, child) {
                        return ScannerErrorWidget(error: error);
                      },
                      fit: BoxFit.contain,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 100,
                        color: Colors.black.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ToggleFlashlightButton(controller: controller),
                            StartStopMobileScannerButton(
                              controller: controller,
                            ),
                            Expanded(
                              child: Center(
                                child: ScannedBarcodeLabel(
                                  barcodes: controller.barcodes,
                                ),
                              ),
                            ),
                            SwitchCameraButton(controller: controller),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
//
//
//

class BarcodeScannerWithZoom extends StatefulWidget {
  const BarcodeScannerWithZoom({super.key});

  @override
  State<BarcodeScannerWithZoom> createState() => _BarcodeScannerWithZoomState();
}

class _BarcodeScannerWithZoomState extends State<BarcodeScannerWithZoom> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
  );

  double _zoomFactor = 0.0;

  Widget _buildZoomScaleSlider() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final TextStyle labelStyle = Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                '0%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
              Expanded(
                child: Slider(
                  value: _zoomFactor,
                  onChanged: (value) {
                    setState(() {
                      _zoomFactor = value;
                      controller.setZoomScale(value);
                    });
                  },
                ),
              ),
              Text(
                '100%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With zoom slider')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: [
                  if (!kIsWeb) _buildZoomScaleSlider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleFlashlightButton(controller: controller),
                      StartStopMobileScannerButton(controller: controller),
                      Expanded(
                        child: Center(
                          child: ScannedBarcodeLabel(
                            barcodes: controller.barcodes,
                          ),
                        ),
                      ),
                      SwitchCameraButton(controller: controller),
                      AnalyzeImageFromGalleryButton(controller: controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
//
//
//

class BarcodeScannerPageView extends StatefulWidget {
  const BarcodeScannerPageView({super.key});

  @override
  State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView> {
  final MobileScannerController controller = MobileScannerController();

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With PageView')),
      backgroundColor: Colors.black,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) async {
          // Stop the camera view for the current page,
          // and then restart the camera for the new page.
          await controller.stop();

          // When switching pages, add a delay to the next start call.
          // Otherwise the camera will start before the next page is displayed.
          await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

          if (!mounted) {
            return;
          }

          unawaited(controller.start());
        },
        children: [
          _BarcodeScannerPage(controller: controller),
          const SizedBox(),
          _BarcodeScannerPage(controller: controller),
          _BarcodeScannerPage(controller: controller),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    pageController.dispose();
    super.dispose();
    await controller.dispose();
  }
}

class _BarcodeScannerPage extends StatelessWidget {
  const _BarcodeScannerPage({required this.controller});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          fit: BoxFit.contain,
          errorBuilder: (context, error, child) {
            return ScannerErrorWidget(error: error);
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 100,
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: ScannedBarcodeLabel(barcodes: controller.barcodes),
            ),
          ),
        ),
      ],
    );
  }
}
//
//
//

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  const AnalyzeImageFromGalleryButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();

        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image == null) {
          return;
        }

        final BarcodeCapture? barcodes = await controller.analyzeImage(
          image.path,
        );

        if (!context.mounted) {
          return;
        }

        final SnackBar snackbar = barcodes != null
            ? const SnackBar(
                content: Text('Barcode found!'),
                backgroundColor: Colors.green,
              )
            : const SnackBar(
                content: Text('No barcode found!'),
                backgroundColor: Colors.red,
              );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
    );
  }
}

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return IconButton(
            color: Colors.white,
            icon: const Icon(Icons.play_arrow),
            iconSize: 32.0,
            onPressed: () async {
              await controller.start();
            },
          );
        }

        return IconButton(
          color: Colors.white,
          icon: const Icon(Icons.stop),
          iconSize: 32.0,
          onPressed: () async {
            await controller.stop();
          },
        );
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          iconSize: 32.0,
          icon: icon,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const Icon(
              Icons.no_flash,
              color: Colors.grey,
            );
        }
      },
    );
  }
}
//
// import 'package:flutter/material.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarcodeScannerListView extends StatefulWidget {
  const BarcodeScannerListView({super.key});

  @override
  State<BarcodeScannerListView> createState() => _BarcodeScannerListViewState();
}

class _BarcodeScannerListViewState extends State<BarcodeScannerListView> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
  );

  Widget _buildBarcodesListView() {
    return StreamBuilder<BarcodeCapture>(
      stream: controller.barcodes,
      builder: (context, snapshot) {
        final barcodes = snapshot.data?.barcodes;

        if (barcodes == null || barcodes.isEmpty) {
          return const Center(
            child: Text(
              'Scan Something!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          itemCount: barcodes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                barcodes[index].rawValue ?? 'No raw value',
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With ListView')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    child: _buildBarcodesListView(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleFlashlightButton(controller: controller),
                      StartStopMobileScannerButton(controller: controller),
                      const Spacer(),
                      SwitchCameraButton(controller: controller),
                      AnalyzeImageFromGalleryButton(controller: controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}

class BarcodeScannerWithOverlay extends StatefulWidget {
  @override
  _BarcodeScannerWithOverlayState createState() =>
      _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<BarcodeScannerWithOverlay> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scanner with Overlay Example app'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: MobileScanner(
              fit: BoxFit.contain,
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              overlayBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow), //falta
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
