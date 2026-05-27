import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimmedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimmedText,
        selection: TextSelection(
          baseOffset: trimmedText.length,
          extentOffset: trimmedText.length,
        ),
      );
    }

    return newValue;
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.isPassword = false,
    this.isCalendar = false,
    this.isAdult = false,
    this.isEmail = false,
    this.isPhoneNumber = false,
    this.isName = false,
    this.clearAllIcon = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.enabled = true,
    this.isDropdown = false,
    this.dropdownType,
    this.dropdownItems,
    this.onDropdownSelected,
    this.onCountrySelected,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isPassword;
  final bool isCalendar;
  final bool isAdult;
  final bool isEmail;
  final bool isPhoneNumber;
  final bool isName;
  final bool clearAllIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final bool enabled;
  final bool isDropdown;
  final String? dropdownType;
  final List<String>? dropdownItems;
  final void Function(dynamic)? onDropdownSelected;
  final ValueChanged<Country>? onCountrySelected;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  static const double _targetHeight = 56.0;
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  final ValueNotifier<Country?> _selectedCountryNotifier =
      ValueNotifier<Country?>(null);
  final ValueNotifier<String?> _selectedDropdownValueNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String> _textValueNotifier = ValueNotifier<String>('');
  final ValueNotifier<Color> _borderColorNotifier = ValueNotifier<Color>(
    Colors.grey.shade400,
  );
  final ValueNotifier<bool> _isFocusedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _obscureNotifier = ValueNotifier<bool>(false);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize password obscure state
    _obscureNotifier.value = widget.isPassword ? true : widget.obscureText;

    // Default to US +1 for country dropdowns when nothing is set
    if (widget.isDropdown == true && widget.dropdownType == 'country') {
      if (widget.controller.text.trim().isEmpty) {
        widget.controller.text = '+1';
        // Set the default US country
        final usCountry = Country(
          phoneCode: '1',
          countryCode: 'US',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'United States',
          example: '2015550123',
          displayName: 'United States (US) [+1]',
          displayNameNoCountryCode: 'United States (US)',
          e164Key: '',
        );

        _selectedCountryNotifier.value = usCountry;
        widget.controller.text = '+1';
        _textValueNotifier.value = '+1';
      } else {
        _textValueNotifier.value = widget.controller.text;
      }
    } else {
      _textValueNotifier.value = widget.controller.text;
    }

    // Focus tracking
    _focusNode.addListener(() {
      _isFocusedNotifier.value = _focusNode.hasFocus;
    });

    // Listen to controller changes
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _selectedCountryNotifier.dispose();
    _selectedDropdownValueNotifier.dispose();
    _textValueNotifier.dispose();
    _borderColorNotifier.dispose();
    _isFocusedNotifier.dispose();
    _obscureNotifier.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    _textValueNotifier.value = widget.controller.text;
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: const CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.black),
        bottomSheetHeight: 500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        searchTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSelect: (Country country) {
        _selectedCountryNotifier.value = country;
        _textValueNotifier.value = '+${country.phoneCode}';
        widget.controller.text = '+${country.phoneCode}';

        if (widget.onCountrySelected != null) {
          widget.onCountrySelected?.call(country);
        }
        if (widget.onDropdownSelected != null) {
          widget.onDropdownSelected?.call(country);
        }
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime adultCutoff = DateTime(now.year - 18, now.month, now.day);
    final DateTime initial = widget.isAdult ? adultCutoff : now;

    final DateTime firstDate = widget.isAdult
        ? DateTime(now.year - 120, 1, 1)
        : DateTime(1900, 1, 1);
    final DateTime lastDate = widget.isAdult
        ? adultCutoff
        : DateTime(now.year + 120, 12, 31);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate)
          ? firstDate
          : initial.isAfter(lastDate)
          ? lastDate
          : initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: widget.isAdult ? 'Select date of birth' : 'Select date',
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );

    if (picked != null) {
      final String formatted =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().padLeft(4, '0')}';
      widget.controller.text = formatted;
      _textValueNotifier.value = formatted;
      if (widget.onChanged != null) {
        widget.onChanged?.call(formatted);
      }
    }
  }

  void _showCustomDropdown() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Option',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.dropdownItems?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = widget.dropdownItems![index];
                  return ValueListenableBuilder<String?>(
                    valueListenable: _selectedDropdownValueNotifier,
                    builder: (context, selectedValue, child) => ListTile(
                      title: Text(item),
                      trailing: selectedValue == item
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        _selectedDropdownValueNotifier.value = item;
                        _textValueNotifier.value = item;
                        widget.controller.text = item;

                        if (widget.onDropdownSelected != null) {
                          widget.onDropdownSelected?.call(item);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContent() {
    if (widget.dropdownType == 'country') {
      return ValueListenableBuilder<Country?>(
        valueListenable: _selectedCountryNotifier,
        builder: (context, selectedCountry, child) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCountry != null
                  ? '+${selectedCountry.phoneCode}'
                  : widget.hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selectedCountry != null
                    ? Colors.black
                    : Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      );
    } else {
      return ValueListenableBuilder<String?>(
        valueListenable: _selectedDropdownValueNotifier,
        builder: (context, selectedValue, child) => Row(
          children: [
            Expanded(
              child: Text(
                selectedValue ?? widget.hintText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selectedValue != null
                      ? Colors.black
                      : Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      );
    }
  }

  void _handleDropdownTap() {
    if (widget.dropdownType == 'country') {
      _showCountryPicker();
    } else {
      _showCustomDropdown();
    }
  }

  TextInputType _effectiveKeyboardType() {
    if (widget.isEmail) return TextInputType.emailAddress;
    if (widget.isPhoneNumber) return TextInputType.number;
    if (widget.isName) return TextInputType.name;
    return widget.keyboardType ?? TextInputType.text;
  }

  List<TextInputFormatter> _buildFormatters() {
    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      NoLeadingSpaceFormatter(),
    ];

    if (widget.isPhoneNumber) {
      formatters.addAll([
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ]);
    }

    if (widget.isName) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')));
    }

    if (widget.isEmail) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@._+\-]')),
      );
    }

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    return formatters;
  }

  Widget? _buildSuffixIcon(bool isObscure, bool isFocused) {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () => _obscureNotifier.value = !isObscure,
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
      );
    }
    if (widget.isCalendar) {
      return IconButton(
        onPressed: _pickDate,
        icon: const Icon(Icons.calendar_today),
      );
    }
    if (widget.clearAllIcon) {
      if (!isFocused) return null;
      return IconButton(
        onPressed: () {
          widget.controller.clear();
          _textValueNotifier.value = '';
          if (widget.onChanged != null) widget.onChanged?.call('');
        },
        icon: const Icon(Icons.close),
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDropdown) {
      return GestureDetector(
        onTap: _handleDropdownTap,
        child: ValueListenableBuilder<Color>(
          valueListenable: _borderColorNotifier,
          builder: (context, borderColor, child) => Container(
            constraints: const BoxConstraints(minHeight: _targetHeight),
            padding: _contentPadding,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildDropdownContent(),
          ),
        ),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNotifier,
      builder: (context, isObscure, child) => ValueListenableBuilder<bool>(
        valueListenable: _isFocusedNotifier,
        builder: (context, isFocused, _) => TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          readOnly: widget.isCalendar,
          onTap: widget.isCalendar ? _pickDate : null,
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          obscureText: widget.isPassword ? isObscure : widget.obscureText,
          keyboardType: _effectiveKeyboardType(),
          textInputAction: widget.textInputAction,
          inputFormatters: _buildFormatters(),
          onChanged: (value) {
            _textValueNotifier.value = value;
            if (widget.onChanged != null) {
              widget.onChanged?.call(value);
            }
          },
          onSubmitted: widget.onSubmitted,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          decoration: InputDecoration(
            isDense: false,
            contentPadding: _contentPadding,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(isObscure, isFocused),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.grey.shade400,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*import 'dart:ui';

import 'package:country_pickers/country.dart' as cp;
import 'package:country_pickers/country_pickers.dart' as cp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String? prefixText;
  final String? errorText;
  final String? error;
  final bool obscureText;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final TextInputAction keyboardAction;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validators;
  final List<TextInputFormatter>? inputFormatters;
  final InputCounterWidgetBuilder? buildCounter;
  final int? maxLength;
  final Widget? prefixIcon;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final Widget? suffixIcon;
  final String? initValue;
  final FormFieldSetter<String>? onSaved;
  final bool paddingLeft;
  final EdgeInsets? contentPadding;
  final int maxLines;
  final int minLines;
  final double height;
  final bool filled;
  final Widget? suffix;
  final Widget? prefix;
  final Function(String?)? onChanged;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool? isDense;
  final bool showTextTitle;
  final bool? isShort;

  // Country picker
  final bool isCountryPicker;
  final Function(cp.Country)? onCountrySelected;
  final Function(cp.Country)? onDropdownSelected;
  final cp.Country? initialCountry;

  // Custom dropdown
  final bool isCustomDropdown;
  final List<String>? dropdownItems;
  final Function(String)? onCustomDropdownSelected;

  // Glass effect
  final bool needGlassEffect;
  final Color? bgColor;
  final double blur;
  final Color? borderColor;
  final bool? needGradientBorder;

  const AppTextField({
    required this.label,
    required this.hint,
    this.error,
    this.obscureText = false,
    this.textStyle,
    this.decoration,
    this.keyboardAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validators,
    this.inputFormatters,
    this.maxLength,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.onTap,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.suffixIcon,
    this.initValue,
    this.paddingLeft = false,
    this.contentPadding,
    this.prefixIcon,
    this.onSaved,
    this.prefixText,
    this.minLines = 1,
    this.maxLines = 1,
    this.height = 1,
    this.filled = false,
    this.suffix,
    this.prefix,
    this.onChanged,
    this.errorText,
    this.buildCounter,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isDense,
    this.showTextTitle = true,
    this.isShort = false,
    this.isCountryPicker = false,
    this.onCountrySelected,
    this.onDropdownSelected,
    this.initialCountry,
    this.isCustomDropdown = false,
    this.dropdownItems,
    this.onCustomDropdownSelected,
    // Glass defaults
    this.needGlassEffect = false,
    this.bgColor,
    this.blur = 4.0,
    this.borderColor,
    super.key,
    this.needGradientBorder = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final ValueNotifier<cp.Country?> _selectedCountryNotifier;
  late final ValueNotifier<String?> _selectedDropdownValueNotifier;
  late final ValueNotifier<String> _textValueNotifier;
  late final ValueNotifier<bool> _isFocusedNotifier;

  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;

  String get selectedCountryCode =>
      '+${_selectedCountryNotifier.value?.phoneCode ?? '1'}';

  @override
  void initState() {
    super.initState();
    final cp.Country defaultCountry =
        widget.initialCountry ??
        cp.CountryPickerUtils.getCountryByIsoCode('US');

    _selectedCountryNotifier = ValueNotifier<cp.Country?>(defaultCountry);
    _selectedDropdownValueNotifier = ValueNotifier<String?>(null);
    _textValueNotifier = ValueNotifier<String>('');
    _isFocusedNotifier = ValueNotifier<bool>(false);

    _internalController = widget.controller ?? TextEditingController();
    _internalFocusNode = widget.focusNode ?? FocusNode();

    if (widget.initValue != null && widget.controller == null) {
      _internalController.text = widget.initValue!;
    }
    _textValueNotifier.value = _internalController.text;

    _internalController.addListener(_onControllerChanged);
    _internalFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _selectedCountryNotifier.dispose();
    _selectedDropdownValueNotifier.dispose();
    _textValueNotifier.dispose();
    _isFocusedNotifier.dispose();
    _internalController.removeListener(_onControllerChanged);
    _internalFocusNode.removeListener(_onFocusChanged);

    if (widget.controller == null) _internalController.dispose();
    if (widget.focusNode == null) _internalFocusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    _textValueNotifier.value = _internalController.text;
  }

  void _onFocusChanged() {
    _isFocusedNotifier.value = _internalFocusNode.hasFocus;
  }

  // --- country picker + dropdown builders remain unchanged ---

  void submit(BuildContext context) {
    switch (widget.keyboardAction) {
      case TextInputAction.done:
        FocusScope.of(context).unfocus();
        break;
      case TextInputAction.next:
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else {
          FocusScope.of(context).nextFocus();
        }
        break;
      default:
        FocusScope.of(context).nextFocus();
        break;
    }
  }

  Widget _buildTextField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isFocusedNotifier,
      builder: (context, isFocused, child) {
        return TextFormField(
          controller: _internalController,
          focusNode: _internalFocusNode,
          obscureText: widget.obscureText,
          validator: widget.validators ?? (String? value) => null,
          textInputAction: widget.keyboardAction,
          textCapitalization: widget.textCapitalization,
          onChanged: (value) {
            _textValueNotifier.value = value;
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: (_) => submit(context),
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          onSaved: widget.onSaved,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          style:
              widget.textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
                errorText: widget.errorText ?? widget.error,
                counterText: "",
                border: InputBorder.none,
                contentPadding:
                    widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = _buildTextField();

    if (!widget.needGlassEffect) {
      return field; // normal
    }

    // Wrap with glass container
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
        child: Container(
          decoration: BoxDecoration(
            color: widget.bgColor ?? Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: widget.needGradientBorder == true
                ? GradientBoxBorder(
                    width: 1,
                    gradient: LinearGradient(
                      colors: [
                        widget.borderColor ?? Colors.white,
                        Colors.transparent,
                        widget.borderColor ?? Colors.white,
                      ],
                    ),
                  )
                : Border.all(color: widget.borderColor ?? Colors.transparent),
          ),
          child: field,
        ),
      ),
    );
  }
}*/
