import 'package:flutter/material.dart';

/// A custom vertical bar waveform visualization for voice recording.
class VoiceWaveform extends StatefulWidget {
  final double amplitude;
  final Color color;

  /// Width of each waveform bar.
  final double barWidth;

  /// Maximum height of a waveform bar.
  final double maxHeight;

  /// Minimum height of a waveform bar.
  final double minHeight;

  /// Radius of the bar corners.
  final double borderRadius;

  /// Space between bars.
  final double barGap;

  /// Maximum number of bars.
  final int barCount;

  /// Animation duration for bar height changes.
  final Duration animationDuration;

  const VoiceWaveform({
    super.key,
    required this.amplitude,
    this.color = Colors.blue,
    this.barWidth = 4.0,
    this.maxHeight = 28.0,
    this.minHeight = 1.0,
    this.borderRadius = 4.0,
    this.barGap = 3.0,
    this.barCount = 30,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform> {
  late List<double> _amplitudes;

  @override
  void initState() {
    super.initState();

    // IMPORTANT:
    // growable: true because we remove the oldest amplitude
    // and add a new one on every update.
    // _amplitudes = List<double>.filled(
    //   widget.barCount,
    //   0.0,
    //   growable: true,
    // );
    _amplitudes = List<double>.generate(
      widget.barCount,
      (index) => 0.0,
      growable: true,
    );
  }

  @override
  void didUpdateWidget(covariant VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle barCount changes safely.
    if (oldWidget.barCount != widget.barCount) {
      if (widget.barCount > _amplitudes.length) {
        _amplitudes.addAll(
          List<double>.filled(
            widget.barCount - _amplitudes.length,
            0.0,
          ),
        );
      } else if (widget.barCount < _amplitudes.length) {
        _amplitudes = _amplitudes.sublist(
          _amplitudes.length - widget.barCount,
        );
      }
    }

    if (oldWidget.amplitude != widget.amplitude) {
      _updateAmplitudes();
    }
  }

  void _updateAmplitudes() {
    if (!mounted || _amplitudes.isEmpty) {
      return;
    }

    setState(() {
      _amplitudes.removeAt(0);
      _amplitudes.add(
        widget.amplitude.clamp(0.0, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Nothing useful can be rendered without horizontal space.
        if (availableWidth <= 0) {
          return const SizedBox.shrink();
        }

        // One bar + one gap.
        final itemWidth = widget.barWidth + widget.barGap;

        // Leave a tiny safety margin for fractional-pixel rounding.
        final safeWidth = (availableWidth - 1.0).clamp(
          0.0,
          double.infinity,
        );

        final visibleBarCount = (safeWidth / itemWidth)
            .floor()
            .clamp(1, widget.barCount);

        final startIndex =
            (_amplitudes.length - visibleBarCount).clamp(
          0,
          _amplitudes.length,
        );

        final visibleAmplitudes =
            _amplitudes.sublist(startIndex);

        return SizedBox(
          width: double.infinity,
          height: widget.maxHeight,
          child: ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                visibleAmplitudes.length,
                (index) {
                  final amplitude = visibleAmplitudes[index];

                  final currentHeight =
                      widget.minHeight +
                          (widget.maxHeight -
                                  widget.minHeight) *
                              amplitude;

                  return SizedBox(
                    width: widget.barWidth,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index ==
                                visibleAmplitudes.length - 1
                            ? 0
                            : widget.barGap,
                      ),
                      child: AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: Curves.easeOutCubic,
                        width: widget.barWidth,
                        height: currentHeight,
                        decoration: BoxDecoration(
                          // color: widget.color,
                          color: Colors.purpleAccent,
                          borderRadius:
                              BorderRadius.circular(
                            widget.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
