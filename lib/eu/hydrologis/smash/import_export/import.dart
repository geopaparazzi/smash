part of smash_import_export;

abstract class AImportPlugin {
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
  Widget getImportPage();

  /// Get the optional settings page to present to the user.
  Widget? getSettingsPage();
}

class ImportWidget extends StatefulWidget {
  final ProjectDb projectDb;
  ImportWidget({Key? key, required this.projectDb}) : super(key: key);

  @override
  _ImportWidgetState createState() => _ImportWidgetState();
}

class _ImportWidgetState extends State<ImportWidget> {
  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = importPlugins.map((ip) {
      ip.setContext(context);
      ip.setProjectDatabase(widget.projectDb);

      Widget? settingsButton;
      if (ip.getSettingsPage() != null) {
        settingsButton = IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ip.getSettingsPage()!));
          },
          icon: Icon(
            MdiIcons.cog,
          ),
        );
      }

      return ListTile(
        leading: ip.getIcon(),
        title: Text(ip.getTitle()),
        subtitle: Text(ip.getDescription()),
        trailing: settingsButton,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ip.getImportPage()));
        },
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(SL.of(context).importWidget_import), //"Import"
      ),
      body: ListView(children: tiles),
    );
  }
}
