import 'package:flutter/material.dart';
import 'package:osce/results.dart';

class CostumRadioCorrect<T> extends StatefulWidget {
  const CostumRadioCorrect({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChanged,
    required this.selectedColor,
    required this.icon,
  });

  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;
  final Color selectedColor;
  final IconData icon;

  @override
  State<CostumRadioCorrect> createState() => _CostumRadioCorrectState();
}

class _CostumRadioCorrectState extends State<CostumRadioCorrect> {
  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.value == widget.groupValue;
    return Row(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.fastOutSlowIn,
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: isSelected ? widget.selectedColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Color.fromARGB(255, 184, 184, 184)),
        ),
        child: InkWell(
          onTap: () => widget.onChanged(widget.value),
          child: Icon(
            widget.icon,
            color:
                isSelected ? Colors.white : Color.fromARGB(255, 184, 184, 184),
            size: 30.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(widget.label))
    ]);
  }
}
