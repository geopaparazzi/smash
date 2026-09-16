part of smash_import_export;

abstract class AExportPlugin {
  /// set the context.
  void setContext(BuildContext context);

  /// Get the icon of the import plugin for the import page list.
  Icon getIcon();

  /// Get the title of the import plugin for the import page list.
  String getTitle();

  /// Get the description of the import plugin for the import page list.
  String getDescription();

  /// Supplies the [projectDb] for internal use.
  void setProjectDatabase(ProjectDb projectDb);

  /// Get the import page to present to the user.
  Widget getExportPage();

  /// Get the optional settings page to present to the user.
  Widget? getSettingsPage();
}

class ExportWidget extends StatefulWidget {
  final ProjectDb projectDb;
  ExportWidget({Key? key, required this.projectDb}) : super(key: key);

  @override
  _ExportWidgetState createState() => _ExportWidgetState();
}

class _ExportWidgetState extends State<ExportWidget> {
  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = exportPlugins.map((ep) {
      ep.setContext(context);
      ep.setProjectDatabase(widget.projectDb);

      Widget? settingsButton;
      if (ep.getSettingsPage() != null) {
        settingsButton = IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              var settingsPage = ep.getSettingsPage();
              return settingsPage!;
            }));
          },
          icon: Icon(
            MdiIcons.cog,
          ),
        );
      }

      return ListTile(
        leading: ep.getIcon(),
        title: Text(ep.getTitle()),
        subtitle: Text(ep.getDescription()),
        trailing: settingsButton,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ep.getExportPage()));
        },
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).exportWidget_export),
      ),
      body: ListView(children: tiles),
    );
  }
}
