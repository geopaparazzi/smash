import 'package:flutter/material.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class SmashAvailableTag extends StatelessWidget {
  final String label;
  final VoidCallback onSelected;

  const SmashAvailableTag({
    Key? key,
    required this.label,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: SmashUI.smallText(
        label,
        color: SmashColors.mainBackground,
      ),
      backgroundColor: Colors.lightGreen,
      onPressed: onSelected,
    );
  }
}

class SmashSelectedReadonlyTag extends StatelessWidget {
  final String label;
  final VoidCallback onSelected;

  const SmashSelectedReadonlyTag({
    Key? key,
    required this.label,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: SmashUI.smallText(
        label,
        color: SmashColors.mainBackground,
      ),
      backgroundColor: SmashColors.mainDecorations,
      onPressed: onSelected,
    );
  }
}

class SmashSelectedTags extends StatelessWidget {
  final List<String> tags;
  final ValueChanged<int> onRemoveAt;

  final WrapAlignment alignment;

  final Color? chipColor;
  final Color? textColor;
  final Color? removeBgColor;
  final Color? removeIconColor;

  final BorderRadius borderRadius;

  const SmashSelectedTags({
    Key? key,
    required this.tags,
    required this.onRemoveAt,
    this.alignment = WrapAlignment.start,
    this.chipColor,
    this.textColor,
    this.removeBgColor,
    this.removeIconColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resolvedChipColor = chipColor ?? SmashColors.mainDecorations;
    final resolvedTextColor = textColor ?? SmashColors.mainBackground;
    final resolvedRemoveBg = removeBgColor ?? SmashColors.mainBackground;
    final resolvedRemoveIcon = removeIconColor ?? SmashColors.mainDecorations;

    return Tags(
      alignment: alignment,
      itemCount: tags.length,
      itemBuilder: (int index) {
        final item = tags[index];
        return ItemTags(
          padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
          key: Key('sel_$index'),
          index: index,
          title: item,
          active: true,
          pressEnabled: true,
          activeColor: resolvedChipColor,
          color: resolvedChipColor,
          textActiveColor: resolvedTextColor,
          borderRadius: borderRadius,
          removeButton: ItemTagsRemoveButton(
            // padding: EdgeInsets.only(left: 4),
            backgroundColor: resolvedRemoveBg,
            color: resolvedRemoveIcon,
            onRemoved: () {
              onRemoveAt(index);
              return true;
            },
          ),
        );
      },
    );
  }
}

class SmashSelectedReadonlyTags extends StatelessWidget {
  final List<String> tags;

  /// Layout
  final WrapAlignment alignment;
  final bool wrapSpacingTight;

  /// Style
  final double? fontSize;
  final BorderRadius borderRadius;

  /// Colors
  final Color? chipColor;
  final Color? textColor;

  const SmashSelectedReadonlyTags({
    Key? key,
    required this.tags,
    this.alignment = WrapAlignment.start,
    this.wrapSpacingTight = false,
    this.fontSize,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.chipColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resolvedChipColor = chipColor ?? SmashColors.mainDecorations;
    final resolvedTextColor = textColor ?? SmashColors.mainBackground;
    final resolvedFontSize = fontSize ?? SmashUI.SMALL_SIZE;

    final spacing = wrapSpacingTight ? 4.0 : 8.0;

    return Tags(
      alignment: alignment,
      spacing: spacing,
      runSpacing: spacing,
      itemCount: tags.length,
      itemBuilder: (int index) {
        final t = tags[index];
        return ItemTags(
          key: Key('tag_$index'),
          index: index,
          title: t,
          active: true,
          pressEnabled: false, // read-only
          textStyle: TextStyle(fontSize: resolvedFontSize),
          activeColor: resolvedChipColor,
          color: resolvedChipColor,
          textActiveColor: resolvedTextColor,
          borderRadius: borderRadius,
        );
      },
    );
  }
}

/// Reusable tags editor:
/// - Shows selected tags (removable)
/// - Shows available tags (tap to add)
/// - Allows typing a new tag and adding it to selected and (optionally) all tags
///
/// Parent owns the truth (tags + allTags); this widget just edits and calls callbacks.
class SmashTagEditor extends StatefulWidget {
  final List<String> tags; // selected tags for the item
  List<String>? allTags; // global list of tags
  final ValueChanged<List<String>> onTagsChanged;
  final ValueChanged<List<String>>? onAllTagsChanged;

  /// Called when a new tag is created from input and wasn't in allTags yet.
  /// If you want auto-persist, handle it in parent (e.g. write to prefs/db).
  final ValueChanged<String>? onNewGlobalTagCreated;

  final String title;
  final String currentTagsLabel;
  final String availableTagsLabel;
  final String emptySelectedText;
  final String emptyAvailableText;
  final String inputHint;

  /// If true: typing a brand new tag adds it to allTags too.
  final bool addNewTagToAllTags;

  /// If true: available tags list is filtered by the input text.
  final bool filterAvailableByInput;

  SmashTagEditor({
    Key? key,
    required this.tags,
    required this.onTagsChanged,
    this.allTags,
    this.onAllTagsChanged,
    this.onNewGlobalTagCreated,
    this.title = "Tags",
    this.currentTagsLabel = "Current tags",
    this.availableTagsLabel = "Available tags",
    this.emptySelectedText = "No tags yet.",
    this.emptyAvailableText = "No available tags.",
    this.inputHint = "or type a new tag and press +",
    this.addNewTagToAllTags = true,
    this.filterAvailableByInput = true,
  }) : super(key: key);

  @override
  State<SmashTagEditor> createState() => _SmashTagEditorState();
}

class _SmashTagEditorState extends State<SmashTagEditor> {
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _tagFocusNode = FocusNode();

  List<String>? _allTags;

  @override
  void initState() {
    super.initState();
    if (widget.allTags == null) {
      _allTags = GpPreferences()
          .getStringListSync(SmashPreferencesKeys.KEY_GPS_LOG_TAGS, [])!;
    } else {
      _allTags = widget.allTags;
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  List<String> get _availableTags {
    final sel = widget.tags.toSet();

    final base = _allTags!.where((t) => !sel.contains(t)).toList();

    if (!widget.filterAvailableByInput) {
      base.sort();
      return base;
    }

    final f = _tagController.text.trim().toLowerCase();
    if (f.isEmpty) {
      base.sort();
      return base;
    }

    final filtered = base.where((t) => t.toLowerCase().contains(f)).toList()
      ..sort();
    return filtered;
  }

  void _emitTags(List<String> next) {
    widget.onTagsChanged(next);
  }

  void _emitAllTags(List<String> next) {
    widget.onAllTagsChanged?.call(next);
    _allTags = next;
    // if alltags was taken from prefs, save it back
    if (widget.allTags == null)
      GpPreferences().setStringListSync(
        SmashPreferencesKeys.KEY_GPS_LOG_TAGS,
        _allTags!,
      );
  }

  void _removeSelectedTag(String tag) {
    final next = List<String>.from(widget.tags)..remove(tag);
    _emitTags(next);
  }

  void _addSelectedTag(String tag) {
    if (tag.trim().isEmpty) return;

    final next = List<String>.from(widget.tags);
    if (!next.contains(tag)) {
      next.add(tag);
      _emitTags(next);
    }

    _tagController.clear();
    setState(() {}); // refresh availability/filter
  }

  void _addTagFromInput() {
    final raw = _tagController.text.trim();
    if (raw.isEmpty) return;

    // 1) add to selected
    final nextTags = List<String>.from(widget.tags);
    if (!nextTags.contains(raw)) {
      nextTags.add(raw);
      _emitTags(nextTags);
    }

    // 2) optionally add to global list
    if (widget.addNewTagToAllTags) {
      final nextAll = List<String>.from(_allTags!);
      if (!nextAll.contains(raw)) {
        nextAll.add(raw);
        _emitAllTags(nextAll);
        widget.onNewGlobalTagCreated?.call(raw);
      }
    }

    _tagController.clear();
    _tagFocusNode.requestFocus();
    setState(() {}); // refresh availability/filter
  }

  @override
  Widget build(BuildContext context) {
    final available = _availableTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),

        // current tags
        Text(widget.currentTagsLabel,
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),

        if (widget.tags.isEmpty)
          Text(widget.emptySelectedText,
              style: Theme.of(context).textTheme.bodySmall)
        else
          SmashSelectedTags(
            tags: widget.tags,
            onRemoveAt: (index) => _removeSelectedTag(widget.tags[index]),
          ),

        const SizedBox(height: 16),

        // available tags
        Text(widget.availableTagsLabel,
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),

        if (available.isEmpty)
          Text(widget.emptyAvailableText,
              style: Theme.of(context).textTheme.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in available)
                SmashAvailableTag(
                  label: t,
                  onSelected: () => _addSelectedTag(t),
                ),
            ],
          ),

        const SizedBox(height: 10),

        // input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                focusNode: _tagFocusNode,
                decoration: InputDecoration(hintText: widget.inputHint),
                onSubmitted: (_) => _addTagFromInput(),
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}), // refresh filtering live
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTagFromInput,
            ),
          ],
        ),
      ],
    );
  }
}
