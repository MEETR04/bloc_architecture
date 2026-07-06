import 'package:bloc_architecture/values/app_colors.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownTextField extends StatefulWidget {
  const AppDropdownTextField({
    super.key,
    required this.controller,
    required this.items,
    required this.pickedValueNotifier,
    required this.hint,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.borderColor,
  });

  final TextEditingController controller;

  /// The list of string options shown in the Cupertino picker.
  final List<String> items;

  /// Drives the selected value. Update this notifier externally to
  /// programmatically change the selection.
  final ValueNotifier<String> pickedValueNotifier;

  final String hint;
  final FormFieldValidator<String>? validator;

  /// Called whenever the user picks a new value.
  final ValueChanged<String>? onChanged;

  final FocusNode? focusNode;
  final bool enabled;
  final Color? borderColor;

  @override
  State<AppDropdownTextField> createState() => _AppDropdownTextFieldState();
}

class _AppDropdownTextFieldState extends State<AppDropdownTextField> {
  // Store the listener reference so we can remove it on dispose — avoids
  // the memory leak present in the original Okalenda implementation.
  late final VoidCallback _notifierListener;

  @override
  void initState() {
    super.initState();
    _notifierListener = _onPickedValueChanged;
    widget.pickedValueNotifier.addListener(_notifierListener);

    // Sync controller with initial notifier value if already set.
    if (widget.pickedValueNotifier.value.isNotEmpty) {
      widget.controller.text = widget.pickedValueNotifier.value;
    }
  }

  @override
  void dispose() {
    widget.pickedValueNotifier.removeListener(_notifierListener);
    super.dispose();
  }

  void _onPickedValueChanged() {
    final value = widget.pickedValueNotifier.value;
    widget.controller.text = value;
    widget.onChanged?.call(value);
  }

  void _showPicker() {
    if (!widget.enabled) return;
    widget.focusNode?.unfocus();

    final items = widget.items;
    if (items.isEmpty) return;

    // Determine the initial scroll index based on the current value.
    final currentValue = widget.pickedValueNotifier.value;
    int initialIndex = items.indexOf(currentValue);
    if (initialIndex < 0) initialIndex = 0;

    final selectedIndex = ValueNotifier<int>(initialIndex);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(widget.hint, style: AppTextStyle.labelLarge),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        widget.pickedValueNotifier.value =
                            items[selectedIndex.value];
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: AppTextStyle.labelLarge.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  itemExtent: 40.h,
                  onSelectedItemChanged: (index) =>
                      selectedIndex.value = index,
                  children: items
                      .map(
                        (item) => Center(
                          child: Text(item, style: AppTextStyle.bodyLarge),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackBorderColor = widget.borderColor ?? Colors.grey.shade400;

    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      readOnly: true,
      enabled: widget.enabled,
      onTap: _showPicker,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTextStyle.bodyLarge,
      decoration: InputDecoration(
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: widget.hint,
        suffixIcon: Icon(
          CupertinoIcons.chevron_down,
          size: 16.r,
          color: AppColors.grey400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: fallbackBorderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: fallbackBorderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: fallbackBorderColor,
          ),
        ),
      ),
    );
  }
}
