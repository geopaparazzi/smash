(folderstructure)=
# Application folder structure

By default SMASH interacts with the filesystem using a folder named **smash** in the device's main storage (typically the internal storage on Android).

Inside the **smash** folder, the following subfolders hold information by category:

- `config`: internal app configuration; for example the debug database, which can be sent to the developers when reporting bugs
- `export`: documents produced by exports are saved here
- `forms`: any form definition file placed here is loaded as a form note type in SMASH
- `maps`: maps live here, including those downloaded or synchronized from a server
- `projects`: new projects are created here.
