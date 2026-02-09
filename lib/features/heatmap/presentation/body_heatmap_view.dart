import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

import '../../../core/enums/app_enums.dart';
import '../../../domain/services/heatmap_service.dart';

enum BodyOrientation { front, back }

enum _SvgFitBoundsMode { viewBox, content }

class BodyHeatmapView extends StatelessWidget {
  const BodyHeatmapView({
    super.key,
    required this.orientation,
    required this.itemByMuscle,
    required this.onMuscleTap,
    this.useBackSvgForBack = true,
  });

  final BodyOrientation orientation;
  final Map<SpecificMuscle, MuscleHeatmapItem> itemByMuscle;
  final ValueChanged<MuscleHeatmapItem> onMuscleTap;
  final bool useBackSvgForBack;

  @override
  Widget build(BuildContext context) {
    if (orientation == BodyOrientation.front) {
      return _SvgBodyMapView(
        key: const ValueKey('front_svg_body'),
        assetPath: _frontSvgAssetPath,
        idToMuscle: _frontSvgIdToMuscle,
        fitBoundsMode: _SvgFitBoundsMode.viewBox,
        itemByMuscle: itemByMuscle,
        onMuscleTap: onMuscleTap,
      );
    }

    if (orientation == BodyOrientation.back && useBackSvgForBack) {
      return _SvgBodyMapView(
        key: const ValueKey('back_svg_body'),
        assetPath: _backSvgAssetPath,
        idToMuscle: _backSvgIdToMuscle,
        fitBoundsMode: _SvgFitBoundsMode.content,
        itemByMuscle: itemByMuscle,
        onMuscleTap: onMuscleTap,
      );
    }

    final regions = _regionsForOrientation(orientation);

    return LayoutBuilder(
      builder: (context, constraints) {
        const aspectRatio = 0.56;
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        var width = maxWidth;
        var height = width / aspectRatio;

        if (height > maxHeight) {
          height = maxHeight;
          width = height * aspectRatio;
        }

        final size = Size(width, height);

        return Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) {
                final region = _hitTestRegionAt(
                  localPosition: details.localPosition,
                  size: size,
                  regions: regions,
                );

                if (region == null) {
                  return;
                }

                final item = itemByMuscle[region.muscle];
                if (item != null) {
                  onMuscleTap(item);
                }
              },
              child: CustomPaint(
                painter: _BodyMusclePainter(
                  regions: regions,
                  itemByMuscle: itemByMuscle,
                  surfaceColor: Theme.of(context).colorScheme.surfaceContainer,
                  outlineColor: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SvgBodyMapView extends StatefulWidget {
  const _SvgBodyMapView({
    super.key,
    required this.assetPath,
    required this.idToMuscle,
    required this.fitBoundsMode,
    required this.itemByMuscle,
    required this.onMuscleTap,
  });

  final String assetPath;
  final Map<String, SpecificMuscle> idToMuscle;
  final _SvgFitBoundsMode fitBoundsMode;
  final Map<SpecificMuscle, MuscleHeatmapItem> itemByMuscle;
  final ValueChanged<MuscleHeatmapItem> onMuscleTap;

  @override
  State<_SvgBodyMapView> createState() => _SvgBodyMapViewState();
}

class _SvgBodyMapViewState extends State<_SvgBodyMapView> {
  late Future<_SvgGeometry> _geometryFuture;
  String? _selectedPathId;

  @override
  void initState() {
    super.initState();
    _geometryFuture = _createGeometryFuture();
  }

  @override
  void didUpdateWidget(covariant _SvgBodyMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        !identical(oldWidget.idToMuscle, widget.idToMuscle)) {
      _geometryFuture = _createGeometryFuture();
      _selectedPathId = null;
    }
  }

  Future<_SvgGeometry> _createGeometryFuture() {
    return _loadSvgGeometry(
      assetPath: widget.assetPath,
      idToMuscle: widget.idToMuscle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<_SvgGeometry>(
          future: _geometryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Unable to load SVG geometry'));
            }

            final geometry = snapshot.data!;
            final fitBounds = widget.fitBoundsMode == _SvgFitBoundsMode.content
                ? geometry.contentBounds
                : geometry.viewBox;
            final aspectRatio = fitBounds.width > 0 && fitBounds.height > 0
                ? fitBounds.width / fitBounds.height
                : 0.56;

            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;

            var width = maxWidth;
            var height = width / aspectRatio;

            if (height > maxHeight) {
              height = maxHeight;
              width = height * aspectRatio;
            }

            final size = Size(width, height);

            return Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final svgPoint = _toSvgCoordinates(
                      localPosition: details.localPosition,
                      size: size,
                      fitBounds: fitBounds,
                    );
                    if (svgPoint == null) {
                      return;
                    }

                    final hit = _hitTestSvgPath(
                      svgPoint: svgPoint,
                      paths: geometry.paths,
                    );
                    if (hit == null) {
                      return;
                    }

                    setState(() {
                      _selectedPathId = hit.id;
                    });

                    final item = widget.itemByMuscle[hit.muscle];
                    if (item != null) {
                      widget.onMuscleTap(item);
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _SvgHeatmapPainter(
                            geometry: geometry,
                            fitBounds: fitBounds,
                            itemByMuscle: widget.itemByMuscle,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _SvgSelectionPainter(
                            geometry: geometry,
                            fitBounds: fitBounds,
                            selectedPathId: _selectedPathId,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SvgHeatmapPainter extends CustomPainter {
  const _SvgHeatmapPainter({
    required this.geometry,
    required this.fitBounds,
    required this.itemByMuscle,
  });

  final _SvgGeometry geometry;
  final Rect fitBounds;
  final Map<SpecificMuscle, MuscleHeatmapItem> itemByMuscle;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.black.withValues(alpha: 0.2);

    for (final pathData in geometry.paths) {
      final transformed = _transformSvgPathToCanvas(
        svgPath: pathData.path,
        size: size,
        fitBounds: fitBounds,
      );

      final band =
          itemByMuscle[pathData.muscle]?.recencyBand ?? MuscleRecencyBand.never;
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = _bodyBandColor(band);

      canvas.drawPath(transformed, fillPaint);
      canvas.drawPath(transformed, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvgHeatmapPainter oldDelegate) {
    return oldDelegate.geometry.paths.length != geometry.paths.length ||
        oldDelegate.fitBounds != fitBounds ||
        oldDelegate.itemByMuscle != itemByMuscle;
  }
}

class _SvgSelectionPainter extends CustomPainter {
  const _SvgSelectionPainter({
    required this.geometry,
    required this.fitBounds,
    required this.selectedPathId,
  });

  final _SvgGeometry geometry;
  final Rect fitBounds;
  final String? selectedPathId;

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedPathId == null) {
      return;
    }

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withValues(alpha: 0.25);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = Colors.blue.shade700;

    final selectedPaths = geometry.paths.where(
      (path) => path.id == selectedPathId,
    );
    for (final pathData in selectedPaths) {
      final transformed = _transformSvgPathToCanvas(
        svgPath: pathData.path,
        size: size,
        fitBounds: fitBounds,
      );
      canvas.drawPath(transformed, fillPaint);
      canvas.drawPath(transformed, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvgSelectionPainter oldDelegate) {
    return oldDelegate.selectedPathId != selectedPathId ||
        oldDelegate.geometry.paths.length != geometry.paths.length ||
        oldDelegate.fitBounds != fitBounds;
  }
}

class _SvgGeometry {
  const _SvgGeometry({
    required this.viewBox,
    required this.contentBounds,
    required this.paths,
  });

  final Rect viewBox;
  final Rect contentBounds;
  final List<_SvgPathRef> paths;
}

class _SvgPathRef {
  const _SvgPathRef({
    required this.id,
    required this.muscle,
    required this.path,
  });

  final String id;
  final SpecificMuscle muscle;
  final Path path;
}

const String _frontSvgAssetPath = 'assets/heatmap/overlay_front.svg';
const String _backSvgAssetPath = 'assets/heatmap/overlay_back.svg';

const Map<String, SpecificMuscle> _frontSvgIdToMuscle = {
  'traps_l': SpecificMuscle.traps,
  'traps_r': SpecificMuscle.traps,
  'upper_chest_l': SpecificMuscle.upperChest,
  'upper_chest_r': SpecificMuscle.upperChest,
  'mid_chest_l': SpecificMuscle.midChest,
  'mid_chest_r': SpecificMuscle.midChest,
  'lower_chest_l': SpecificMuscle.lowerChest,
  'lower_chest_r': SpecificMuscle.lowerChest,
  'front_delts_l': SpecificMuscle.frontDelts,
  'front_delts_r': SpecificMuscle.frontDelts,
  'side_delts_l': SpecificMuscle.sideDelts,
  'side_delts_r': SpecificMuscle.sideDelts,
  'biceps_l': SpecificMuscle.biceps,
  'biceps_r': SpecificMuscle.biceps,
  'triceps_l': SpecificMuscle.triceps,
  'triceps_r': SpecificMuscle.triceps,
  'forearms_l': SpecificMuscle.forearms,
  'forearms_r': SpecificMuscle.forearms,
  'abs': SpecificMuscle.abs,
  'obliques_l': SpecificMuscle.obliques,
  'obliques_r': SpecificMuscle.obliques,
  'hips_l': SpecificMuscle.hips,
  'hips_r': SpecificMuscle.hips,
  'quads_l': SpecificMuscle.quads,
  'quads_r': SpecificMuscle.quads,
  'adductors_l': SpecificMuscle.adductors,
  'adductors_r': SpecificMuscle.adductors,
  'calves_l': SpecificMuscle.calves,
  'calves_r': SpecificMuscle.calves,
  'ankles_l': SpecificMuscle.ankles,
  'ankles_r': SpecificMuscle.ankles,
  'aerobic': SpecificMuscle.aerobic,
  'anaerobic': SpecificMuscle.anaerobic,
};

const Map<String, SpecificMuscle> _backSvgIdToMuscle = {
  'traps_l': SpecificMuscle.traps,
  'traps_r': SpecificMuscle.traps,
  'rear_delts_l': SpecificMuscle.rearDelts,
  'rear_delts_r': SpecificMuscle.rearDelts,
  'rhomboids_l': SpecificMuscle.rhomboids,
  'rhomboids_r': SpecificMuscle.rhomboids,
  'lats_l': SpecificMuscle.lats,
  'lats_r': SpecificMuscle.lats,
  'thoracic': SpecificMuscle.thoracic,
  'triceps_l': SpecificMuscle.triceps,
  'triceps_r': SpecificMuscle.triceps,
  'forearms_l': SpecificMuscle.forearms,
  'forearms_r': SpecificMuscle.forearms,
  'lower_back_l': SpecificMuscle.lowerBack,
  'lower_back_r': SpecificMuscle.lowerBack,
  'spinal_erectors_l': SpecificMuscle.spinalErectors,
  'spinal_erectors_r': SpecificMuscle.spinalErectors,
  'glute_med_l': SpecificMuscle.gluteMed,
  'glute_med_r': SpecificMuscle.gluteMed,
  'glute_max_l': SpecificMuscle.gluteMax,
  'glute_max_r': SpecificMuscle.gluteMax,
  'glutes_max_l': SpecificMuscle.gluteMax,
  'glutes_max_r': SpecificMuscle.gluteMax,
  'hamstrings_l': SpecificMuscle.hamstrings,
  'hamstrings_r': SpecificMuscle.hamstrings,
  'calves_l': SpecificMuscle.calves,
  'calves_r': SpecificMuscle.calves,
  'ankles_l': SpecificMuscle.ankles,
  'ankles_r': SpecificMuscle.ankles,
};

Future<_SvgGeometry> _loadSvgGeometry({
  required String assetPath,
  required Map<String, SpecificMuscle> idToMuscle,
}) async {
  final svgRaw = await rootBundle.loadString(assetPath);
  final document = XmlDocument.parse(svgRaw);
  final root = document.rootElement;
  final viewBox = _parseViewBox(root.getAttribute('viewBox'));
  final paths = <_SvgPathRef>[];
  Rect? contentBounds;

  for (final node in root.findAllElements('path')) {
    final id = node.getAttribute('id');
    final data = node.getAttribute('d');
    if (id == null || data == null || data.trim().isEmpty) {
      continue;
    }

    final muscle = idToMuscle[id];
    if (muscle == null) {
      continue;
    }

    try {
      final path = parseSvgPathData(data);
      final pathBounds = path.getBounds();
      if (!pathBounds.hasNaN && !pathBounds.isEmpty) {
        final currentBounds = contentBounds;
        contentBounds = currentBounds == null
            ? pathBounds
            : currentBounds.expandToInclude(pathBounds);
      }
      paths.add(_SvgPathRef(id: id, muscle: muscle, path: path));
    } catch (_) {
      // Ignore malformed paths, keeping the rest interactive.
    }
  }

  final currentBounds = contentBounds;
  final effectiveBounds = currentBounds == null || currentBounds.isEmpty
      ? viewBox
      : currentBounds;

  return _SvgGeometry(
    viewBox: viewBox,
    contentBounds: effectiveBounds,
    paths: paths,
  );
}

Rect _parseViewBox(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const Rect.fromLTWH(0, 0, 300, 650);
  }

  final parts = raw
      .split(RegExp(r'[,\s]+'))
      .where((value) => value.isNotEmpty)
      .toList();
  if (parts.length != 4) {
    return const Rect.fromLTWH(0, 0, 300, 650);
  }

  final left = double.tryParse(parts[0]);
  final top = double.tryParse(parts[1]);
  final width = double.tryParse(parts[2]);
  final height = double.tryParse(parts[3]);
  if (left == null || top == null || width == null || height == null) {
    return const Rect.fromLTWH(0, 0, 300, 650);
  }
  return Rect.fromLTWH(left, top, width, height);
}

_SvgPathRef? _hitTestSvgPath({
  required Offset svgPoint,
  required List<_SvgPathRef> paths,
}) {
  for (final pathData in paths.reversed) {
    if (pathData.path.contains(svgPoint)) {
      return pathData;
    }
  }
  return null;
}

class _SvgFitResult {
  const _SvgFitResult({required this.scale, required this.drawRect});

  final double scale;
  final Rect drawRect;
}

_SvgFitResult _fitSvgBounds({required Rect fitBounds, required Size size}) {
  final scale = math.min(
    size.width / fitBounds.width,
    size.height / fitBounds.height,
  );
  final drawnSize = Size(fitBounds.width * scale, fitBounds.height * scale);
  final drawRect = Rect.fromLTWH(
    (size.width - drawnSize.width) / 2,
    (size.height - drawnSize.height) / 2,
    drawnSize.width,
    drawnSize.height,
  );
  return _SvgFitResult(scale: scale, drawRect: drawRect);
}

Offset? _toSvgCoordinates({
  required Offset localPosition,
  required Size size,
  required Rect fitBounds,
}) {
  final fit = _fitSvgBounds(fitBounds: fitBounds, size: size);
  if (!fit.drawRect.contains(localPosition)) {
    return null;
  }

  return Offset(
    fitBounds.left + (localPosition.dx - fit.drawRect.left) / fit.scale,
    fitBounds.top + (localPosition.dy - fit.drawRect.top) / fit.scale,
  );
}

Path _transformSvgPathToCanvas({
  required Path svgPath,
  required Size size,
  required Rect fitBounds,
}) {
  final fit = _fitSvgBounds(fitBounds: fitBounds, size: size);
  final matrix = Matrix4.identity()
    ..translateByDouble(fit.drawRect.left, fit.drawRect.top, 0, 1)
    ..scaleByDouble(fit.scale, fit.scale, 1, 1)
    ..translateByDouble(-fitBounds.left, -fitBounds.top, 0, 1);
  return svgPath.transform(matrix.storage);
}

Color _bodyBandColor(MuscleRecencyBand band) {
  switch (band) {
    case MuscleRecencyBand.recent:
      return const Color(0xFF56B65D);
    case MuscleRecencyBand.medium:
      return const Color(0xFFF3D74D);
    case MuscleRecencyBand.stale:
      return const Color(0xFFE57373);
    case MuscleRecencyBand.never:
      return const Color(0xFFCFE8CF);
  }
}

class _BodyMusclePainter extends CustomPainter {
  _BodyMusclePainter({
    required this.regions,
    required this.itemByMuscle,
    required this.surfaceColor,
    required this.outlineColor,
  });

  final List<_MuscleRegion> regions;
  final Map<SpecificMuscle, MuscleHeatmapItem> itemByMuscle;
  final Color surfaceColor;
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBodyBase(canvas, size);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = outlineColor.withValues(alpha: 0.65);

    for (final region in regions) {
      final path = _pathForRegion(region, size);
      final color = _colorFor(region.muscle);

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  Color _colorFor(SpecificMuscle muscle) {
    final band = itemByMuscle[muscle]?.recencyBand ?? MuscleRecencyBand.never;
    return _bodyBandColor(band);
  }

  void _drawBodyBase(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = surfaceColor.withValues(alpha: 0.45);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = outlineColor.withValues(alpha: 0.4);

    final head = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.08),
      width: size.width * 0.17,
      height: size.height * 0.12,
    );
    canvas.drawOval(head, basePaint);
    canvas.drawOval(head, linePaint);

    final torso = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.38),
        width: size.width * 0.28,
        height: size.height * 0.44,
      ),
      Radius.circular(size.width * 0.07),
    );
    canvas.drawRRect(torso, basePaint);
    canvas.drawRRect(torso, linePaint);

    final leftArm = Path()
      ..moveTo(size.width * 0.34, size.height * 0.20)
      ..lineTo(size.width * 0.20, size.height * 0.40)
      ..lineTo(size.width * 0.24, size.height * 0.72)
      ..lineTo(size.width * 0.34, size.height * 0.48)
      ..close();
    canvas.drawPath(leftArm, basePaint);
    canvas.drawPath(leftArm, linePaint);

    final rightArm = Path()
      ..moveTo(size.width * 0.66, size.height * 0.20)
      ..lineTo(size.width * 0.80, size.height * 0.40)
      ..lineTo(size.width * 0.76, size.height * 0.72)
      ..lineTo(size.width * 0.66, size.height * 0.48)
      ..close();
    canvas.drawPath(rightArm, basePaint);
    canvas.drawPath(rightArm, linePaint);

    final leftLeg = Path()
      ..moveTo(size.width * 0.46, size.height * 0.58)
      ..lineTo(size.width * 0.36, size.height * 0.98)
      ..lineTo(size.width * 0.47, size.height)
      ..lineTo(size.width * 0.54, size.height * 0.60)
      ..close();
    canvas.drawPath(leftLeg, basePaint);
    canvas.drawPath(leftLeg, linePaint);

    final rightLeg = Path()
      ..moveTo(size.width * 0.54, size.height * 0.58)
      ..lineTo(size.width * 0.64, size.height * 0.98)
      ..lineTo(size.width * 0.53, size.height)
      ..lineTo(size.width * 0.46, size.height * 0.60)
      ..close();
    canvas.drawPath(rightLeg, basePaint);
    canvas.drawPath(rightLeg, linePaint);
  }

  @override
  bool shouldRepaint(covariant _BodyMusclePainter oldDelegate) {
    return oldDelegate.regions != regions ||
        oldDelegate.itemByMuscle != itemByMuscle ||
        oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}

class _MuscleRegion {
  const _MuscleRegion({
    required this.id,
    required this.muscle,
    required this.points,
  });

  final String id;
  final SpecificMuscle muscle;
  final List<Offset> points;
}

Path _pathForRegion(_MuscleRegion region, Size size) {
  final first = region.points.first;
  final path = Path()..moveTo(first.dx * size.width, first.dy * size.height);

  for (final point in region.points.skip(1)) {
    path.lineTo(point.dx * size.width, point.dy * size.height);
  }

  return path..close();
}

_MuscleRegion? _hitTestRegionAt({
  required Offset localPosition,
  required Size size,
  required List<_MuscleRegion> regions,
}) {
  for (final region in regions.reversed) {
    final path = _pathForRegion(region, size);
    if (path.contains(localPosition)) {
      return region;
    }
  }
  return null;
}

List<_MuscleRegion> _regionsForOrientation(BodyOrientation orientation) {
  switch (orientation) {
    case BodyOrientation.front:
      return _frontRegions();
    case BodyOrientation.back:
      return _backRegions();
  }
}

List<_MuscleRegion> _frontRegions() {
  return [
    ..._paired('front_traps', SpecificMuscle.traps, const [
      Offset(0.47, 0.13),
      Offset(0.40, 0.18),
      Offset(0.46, 0.21),
      Offset(0.51, 0.16),
    ]),
    ..._paired('front_front_delts', SpecificMuscle.frontDelts, const [
      Offset(0.36, 0.18),
      Offset(0.27, 0.24),
      Offset(0.33, 0.29),
      Offset(0.40, 0.22),
    ]),
    ..._paired('front_side_delts', SpecificMuscle.sideDelts, const [
      Offset(0.28, 0.25),
      Offset(0.22, 0.31),
      Offset(0.26, 0.36),
      Offset(0.32, 0.30),
    ]),
    ..._paired('front_upper_chest', SpecificMuscle.upperChest, const [
      Offset(0.40, 0.20),
      Offset(0.33, 0.24),
      Offset(0.42, 0.27),
      Offset(0.50, 0.23),
    ]),
    ..._paired('front_mid_chest', SpecificMuscle.midChest, const [
      Offset(0.36, 0.27),
      Offset(0.31, 0.34),
      Offset(0.41, 0.38),
      Offset(0.49, 0.32),
      Offset(0.44, 0.25),
    ]),
    ..._paired('front_lower_chest', SpecificMuscle.lowerChest, const [
      Offset(0.38, 0.37),
      Offset(0.34, 0.43),
      Offset(0.44, 0.45),
      Offset(0.49, 0.39),
    ]),
    ..._paired('front_biceps', SpecificMuscle.biceps, const [
      Offset(0.30, 0.31),
      Offset(0.23, 0.40),
      Offset(0.28, 0.49),
      Offset(0.34, 0.40),
    ]),
    ..._paired('front_triceps', SpecificMuscle.triceps, const [
      Offset(0.24, 0.32),
      Offset(0.19, 0.42),
      Offset(0.22, 0.50),
      Offset(0.27, 0.40),
    ]),
    ..._paired('front_forearms', SpecificMuscle.forearms, const [
      Offset(0.26, 0.49),
      Offset(0.19, 0.66),
      Offset(0.25, 0.73),
      Offset(0.31, 0.57),
    ]),
    const _MuscleRegion(
      id: 'front_abs',
      muscle: SpecificMuscle.abs,
      points: [
        Offset(0.43, 0.38),
        Offset(0.57, 0.38),
        Offset(0.59, 0.57),
        Offset(0.41, 0.57),
      ],
    ),
    ..._paired('front_obliques', SpecificMuscle.obliques, const [
      Offset(0.34, 0.40),
      Offset(0.30, 0.55),
      Offset(0.40, 0.58),
      Offset(0.43, 0.40),
    ]),
    ..._paired('front_hips', SpecificMuscle.hips, const [
      Offset(0.41, 0.57),
      Offset(0.35, 0.62),
      Offset(0.41, 0.67),
      Offset(0.47, 0.61),
    ]),
    ..._paired('front_quads', SpecificMuscle.quads, const [
      Offset(0.41, 0.64),
      Offset(0.33, 0.84),
      Offset(0.43, 0.88),
      Offset(0.47, 0.68),
    ]),
    ..._paired('front_adductors', SpecificMuscle.adductors, const [
      Offset(0.47, 0.69),
      Offset(0.43, 0.84),
      Offset(0.48, 0.88),
      Offset(0.50, 0.70),
    ]),
    ..._paired('front_calves', SpecificMuscle.calves, const [
      Offset(0.43, 0.88),
      Offset(0.39, 0.98),
      Offset(0.46, 0.99),
      Offset(0.49, 0.90),
    ]),
    ..._paired('front_ankles', SpecificMuscle.ankles, const [
      Offset(0.43, 0.98),
      Offset(0.40, 1.0),
      Offset(0.47, 1.0),
    ]),
    const _MuscleRegion(
      id: 'front_aerobic',
      muscle: SpecificMuscle.aerobic,
      points: [
        Offset(0.48, 0.27),
        Offset(0.52, 0.27),
        Offset(0.53, 0.31),
        Offset(0.49, 0.33),
        Offset(0.46, 0.30),
      ],
    ),
    const _MuscleRegion(
      id: 'front_anaerobic',
      muscle: SpecificMuscle.anaerobic,
      points: [
        Offset(0.48, 0.33),
        Offset(0.53, 0.33),
        Offset(0.54, 0.37),
        Offset(0.48, 0.38),
        Offset(0.45, 0.35),
      ],
    ),
  ];
}

List<_MuscleRegion> _backRegions() {
  return [
    ..._paired('back_traps', SpecificMuscle.traps, const [
      Offset(0.47, 0.13),
      Offset(0.38, 0.18),
      Offset(0.44, 0.23),
      Offset(0.51, 0.18),
    ]),
    ..._paired('back_rear_delts', SpecificMuscle.rearDelts, const [
      Offset(0.36, 0.19),
      Offset(0.26, 0.25),
      Offset(0.32, 0.31),
      Offset(0.40, 0.23),
    ]),
    ..._paired('back_rhomboids', SpecificMuscle.rhomboids, const [
      Offset(0.43, 0.23),
      Offset(0.37, 0.29),
      Offset(0.44, 0.36),
      Offset(0.50, 0.30),
    ]),
    ..._paired('back_lats', SpecificMuscle.lats, const [
      Offset(0.38, 0.31),
      Offset(0.30, 0.45),
      Offset(0.40, 0.53),
      Offset(0.46, 0.37),
    ]),
    const _MuscleRegion(
      id: 'back_thoracic',
      muscle: SpecificMuscle.thoracic,
      points: [
        Offset(0.47, 0.22),
        Offset(0.53, 0.22),
        Offset(0.55, 0.39),
        Offset(0.45, 0.39),
      ],
    ),
    ..._paired('back_triceps', SpecificMuscle.triceps, const [
      Offset(0.28, 0.31),
      Offset(0.21, 0.43),
      Offset(0.26, 0.52),
      Offset(0.33, 0.40),
    ]),
    ..._paired('back_forearms', SpecificMuscle.forearms, const [
      Offset(0.25, 0.51),
      Offset(0.18, 0.67),
      Offset(0.24, 0.74),
      Offset(0.30, 0.58),
    ]),
    ..._paired('back_lower_back', SpecificMuscle.lowerBack, const [
      Offset(0.44, 0.40),
      Offset(0.39, 0.51),
      Offset(0.45, 0.56),
      Offset(0.50, 0.48),
    ]),
    ..._paired('back_spinal_erectors', SpecificMuscle.spinalErectors, const [
      Offset(0.49, 0.36),
      Offset(0.47, 0.59),
      Offset(0.50, 0.59),
      Offset(0.52, 0.36),
    ]),
    ..._paired('back_glute_med', SpecificMuscle.gluteMed, const [
      Offset(0.42, 0.56),
      Offset(0.35, 0.62),
      Offset(0.41, 0.67),
      Offset(0.46, 0.61),
    ]),
    ..._paired('back_glute_max', SpecificMuscle.gluteMax, const [
      Offset(0.46, 0.61),
      Offset(0.39, 0.70),
      Offset(0.46, 0.74),
      Offset(0.51, 0.66),
    ]),
    ..._paired('back_hamstrings', SpecificMuscle.hamstrings, const [
      Offset(0.45, 0.71),
      Offset(0.36, 0.87),
      Offset(0.44, 0.90),
      Offset(0.50, 0.76),
    ]),
    ..._paired('back_calves', SpecificMuscle.calves, const [
      Offset(0.43, 0.89),
      Offset(0.39, 0.98),
      Offset(0.46, 0.99),
      Offset(0.49, 0.91),
    ]),
    ..._paired('back_ankles', SpecificMuscle.ankles, const [
      Offset(0.43, 0.98),
      Offset(0.40, 1.0),
      Offset(0.47, 1.0),
    ]),
  ];
}

List<_MuscleRegion> _paired(
  String id,
  SpecificMuscle muscle,
  List<Offset> left,
) {
  final right = left.map((point) => Offset(1 - point.dx, point.dy)).toList();

  return [
    _MuscleRegion(id: '${id}_left', muscle: muscle, points: left),
    _MuscleRegion(id: '${id}_right', muscle: muscle, points: right),
  ];
}
