import 'package:flutter/material.dart';
import 'app_typeahead.dart';

class AppMultiDropdown<T> extends StatefulWidget {
  final String labelText;
  final Future<List<T>> Function(String) updateFilterValue;
  final void Function(String) onSelected;
  final String Function(T) displayText;
  final String Function(T) getId;
  final void Function(T)? onClear;
  final Widget Function(BuildContext)? emptyBuilder;
  final List<T> selectedValues;

  const AppMultiDropdown({
    Key? key,
    required this.labelText,
    required this.updateFilterValue,
    required this.onSelected,
    required this.displayText,
    required this.getId,
    required this.selectedValues,
    this.onClear,
    this.emptyBuilder,
  }) : super(key: key);

  @override
  State<AppMultiDropdown<T>> createState() => _AppMultiDropdownState<T>();
}

class _AppMultiDropdownState<T> extends State<AppMultiDropdown<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bordered container for chips
        GestureDetector(
          onTap: () => setState(() => _isFocused = true),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.selectedValues.map((item) {
                return InputChip(
                  label: Text(widget.displayText(item), style: const TextStyle(fontSize: 12)),
                  onDeleted: () {
                    widget.onClear?.call(item);
                    setState(() {}); // update UI
                  },
                );
              }).toList(),
            ),
          ),
        ),

        // Search field (only if focused)
        if (_isFocused) ...[
          const SizedBox(height: 8),
          FocusScope(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                setState(() => _isFocused = false);
              }
            },
            child: AppTypeahead<T>(
              label: '',
              controller: null,
              debounceDuration: const Duration(milliseconds: 500),
              updateFilterValue: widget.updateFilterValue,
              displayText: widget.displayText,
              getId: widget.getId,
              onClear: (_) {
                // optional: clear filter
              },
              emptyBuilder: widget.emptyBuilder ?? (_) => const SizedBox.shrink(),
              onSelected: (val) {
                widget.onSelected(val);
                setState(() => _isFocused = true); // keep focus after selection
              },
            ),
          ),
        ],
      ],
    );
  }
}
