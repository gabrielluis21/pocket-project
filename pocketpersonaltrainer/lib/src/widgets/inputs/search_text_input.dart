import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/utils/debounce.dart';

class SearchTextInput extends StatefulWidget {
  final String? initialValue;
  final String? label;
  final double? maxheight;
  final String? hintText;
  final SearchController searchController;
  final int debounceMilisecons;
  final Future<List<Widget>> Function(String)? onChanged;
  final bool searchOnTap;
  final Widget? trailing;
  const SearchTextInput({
    required this.searchController,
    super.key,
    this.initialValue,
    this.label,
    this.maxheight,
    this.hintText,
    this.debounceMilisecons = 0,
    this.onChanged,
    this.searchOnTap = true,
    this.trailing,
  });

  @override
  State<SearchTextInput> createState() => _SearchTextInputState();
}

class _SearchTextInputState extends State<SearchTextInput> {
  late final debounce = Debounce(miliseconds: widget.debounceMilisecons);
  List<Widget> children = [];
  String fildContent = '';
  bool _init = false;

  @override
  void initState() {
    if (widget.initialValue != null) {
      fildContent = widget.initialValue!;
    }
    widget.searchController.addListener(() {
      if (!widget.searchController.isOpen) {
        widget.searchController.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(widget.label!, style: context.textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
        SearchAnchor(
          viewHintText: widget.hintText,
          headerHintStyle: context.textTheme.labelLarge!.copyWith(
            color: Get.isDarkMode ? AppColorTheme().customDarkColorScheme.primary : AppColorTheme().customLightColorScheme.primary,
          ),
          viewSurfaceTintColor: GetPlatform.isMobile ? Colors.grey[100] : Colors.grey[100],
          viewBackgroundColor: GetPlatform.isMobile ? Colors.grey[100] : Colors.grey[100],
          viewConstraints: GetPlatform.isMobile ? null : const BoxConstraints(maxHeight: 300),
          isFullScreen: GetPlatform.isMobile ? true : false,
          viewShape: GetPlatform.isMobile
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                ),
          dividerColor: Colors.grey[100]!.withOpacity(0.2),
          searchController: widget.searchController,
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              hintText: widget.hintText,
              hintStyle: WidgetStatePropertyAll<TextStyle>(
                context.textTheme.labelLarge!.copyWith(
                  color: Get.isDarkMode ? AppColorTheme().customDarkColorScheme.primary : AppColorTheme().customLightColorScheme.primary,
                ),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  side: BorderSide(
                    width: Get.isDarkMode ? 0 : 1,
                    color: Get.isDarkMode ? AppColorTheme().customDarkColorScheme.primary : AppColorTheme().customLightColorScheme.primary,
                  ),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              surfaceTintColor: WidgetStatePropertyAll(Colors.white),
              elevation: const WidgetStatePropertyAll(0),
              controller: controller,
              // constraints: const BoxConstraints(
              //   maxHeight: 45,
              //   minHeight: 45,
              // ),
              padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () async {
                if (widget.searchOnTap && _init == false) {
                  children = await widget.onChanged?.call("a") ?? [];
                }
                fildContent = controller.value.text;
                controller.openView();
                widget.searchController.selection = TextSelection.fromPosition(TextPosition(offset: widget.searchController.value.text.length, affinity: TextAffinity.upstream));
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: Icon(
                Icons.search,
                color: Get.isDarkMode ? AppColorTheme().customDarkColorScheme.primary : AppColorTheme().customLightColorScheme.primary,
              ),
              trailing: [widget.trailing ?? const SizedBox.shrink()],
            );
          },
          suggestionsBuilder: (BuildContext conte, SearchController controller) async {
            final String value = controller.value.text;
            if (value.isEmpty && children.isNotEmpty && _init) {
              if (widget.searchOnTap) return children;
              return children = [];
            }
            if (fildContent != value && _init == true) {
              await debounce.startTimer(
                  value: controller.value.text,
                  onComplete: () async {
                    children = await widget.onChanged?.call(value) ?? [];
                    fildContent = value;
                  },
                  lenght: 3);
            }
            _init = true;

            return children;
          },
        ),
      ],
    );
  }
}
