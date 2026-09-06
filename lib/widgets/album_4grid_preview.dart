import 'dart:math';

import 'package:aves/model/entry/entry.dart';
import 'package:aves/widgets/common/thumbnail/image.dart';
import 'package:flutter/material.dart';

class Album4GridPreviewSimple extends StatelessWidget {
  final List<AvesEntry> entries; // up to 4, can be less
  final double extent; // total square extent for the whole widget
  final double gap;
  final bool showPlayIconForVideo;
  final VoidCallback? onTap;
  final Object? heroTag;
  final ValueNotifier<bool>? cancellableNotifier;

  const Album4GridPreviewSimple({
    super.key,
    required this.entries,
    required this.extent,
    this.gap = 1.0,
    this.showPlayIconForVideo = true,
    this.onTap,
    this.heroTag,
    this.cancellableNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final double tileExtent = (extent - gap) / 2.0;

    Widget tileForIndex(int i) {
      if (i < entries.length) {
        final entry = entries[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(max(2.0, extent / 12)),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ThumbnailImage(
                entry: entry,
                extent: tileExtent,
                devicePixelRatio: devicePixelRatio,
                isMosaic: false,
                progressive: true,
                heroTag: heroTag != null ? '${heroTag}_$i' : null,
                cancellableNotifier: cancellableNotifier,
                fit: BoxFit.cover,
                showLoadingBackground: true,
              ),
              if (showPlayIconForVideo && entry.isVideo)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white70,
                    size: max(12.0, tileExtent / 6),
                  ),
                ),
            ],
          ),
        );
      } else {
        // placeholder for missing tiles (keeps layout stable)
        return Container(
          width: tileExtent,
          height: tileExtent,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(max(2.0, extent / 12)),
          ),
        );
      }
    }

    // Build 2x2 fixed layout (non-scrollable)
    final grid = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: tileExtent, height: tileExtent, child: tileForIndex(0)),
            SizedBox(width: gap),
            SizedBox(width: tileExtent, height: tileExtent, child: tileForIndex(1)),
          ],
        ),
        SizedBox(height: gap),
        Row(
          children: [
            SizedBox(width: tileExtent, height: tileExtent, child: tileForIndex(2)),
            SizedBox(width: gap),
            SizedBox(width: tileExtent, height: tileExtent, child: tileForIndex(3)),
          ],
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: extent,
        height: extent,
        child: grid,
      ),
    );
  }
}
