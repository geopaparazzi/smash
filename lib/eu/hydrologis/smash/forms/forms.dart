/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'dart:convert';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:smashlibs/smashlibs.dart';

const String COLON = ":";
const String UNDERSCORE = "_";

/// Type for a {@link TextView}.
const String TYPE_LABEL = "label";

/// Type for a {@link TextView} with line below.
const String TYPE_LABELWITHLINE = "labelwithline";

/// Type for a {@link EditText} containing generic text.
const String TYPE_STRING = "string";

/// Type for a dynamic (multiple) {@link EditText} containing generic text.
const String TYPE_DYNAMICSTRING = "dynamicstring";

/// Type for a {@link EditText} area containing generic text.
const String TYPE_STRINGAREA = "stringarea";

/// Type for a {@link EditText} containing double numbers.
const String TYPE_DOUBLE = "double";

/// Type for a {@link EditText} containing integer numbers.
const String TYPE_INTEGER = "integer";

/// Type for a {@link Button} containing date.
const String TYPE_DATE = "date";

/// Type for a {@link Button} containing time.
const String TYPE_TIME = "time";

/// Type for a {@link CheckBox}.
const String TYPE_BOOLEAN = "boolean";

/// Type for a {@link Spinner}.
const String TYPE_STRINGCOMBO = "stringcombo";

/// Type for an autocomplete combo.
const String TYPE_AUTOCOMPLETESTRINGCOMBO = "autocompletestringcombo";

/// Type for autocomplete connected combos.
const String TYPE_AUTOCOMPLETECONNECTEDSTRINGCOMBO =
    "autocompleteconnectedstringcombo";

/// Type for two connected {@link Spinner}.
const String TYPE_CONNECTEDSTRINGCOMBO = "connectedstringcombo";

/// Type for one to many connected {@link Spinner}.
const String TYPE_ONETOMANYSTRINGCOMBO = "onetomanystringcombo";

/// Type for a multi combo.
const String TYPE_STRINGMULTIPLECHOICE = "multistringcombo";

/// Type for a the NFC UID reader.
const String TYPE_NFCUID = "nfcuid";

/// Type for a hidden widget, which just needs to be kept as it is but not displayed.
const String TYPE_HIDDEN = "hidden";

/// Type for latitude, which can be substituted by the engine if necessary.
const String TYPE_LATITUDE = "LATITUDE";

/// Type for longitude, which can be substituted by the engine if necessary.
const String TYPE_LONGITUDE = "LONGITUDE";

/// Type for a hidden item, the value of which needs to get the name of the element.
/// <p/>
/// <p>This is needed in case of abstraction of forms.</p>
const String TYPE_PRIMARYKEY = "primary_key";

/// Type for pictures element.
const String TYPE_PICTURES = "pictures";

/// Type for image from library element.
const String TYPE_IMAGELIB = "imagelib";

/// Type for pictures element.
const String TYPE_SKETCH = "sketch";

/// Type for map element.
const String TYPE_MAP = "map";

/// Type for barcode element.
/// <p>
/// <b>Not in use yet.</b>
const String TYPE_BARCODE = "barcode";

/// A constraint that defines the item as mandatory.
const String CONSTRAINT_MANDATORY = "mandatory";

/// A constraint that defines a range for the value.
const String CONSTRAINT_RANGE = "range";

const String ATTR_SECTIONNAME = "sectionname";
const String ATTR_SECTIONDESCRIPTION = "sectiondescription";
const String ATTR_SECTIONICON = "sectionicon";

const String ATTR_FORMS = "forms";
const String ATTR_FORMNAME = "formname";
const String TAG_LONGNAME = "longname";
const String TAG_SHORTNAME = "shortname";
const String TAG_FORMS = "forms";
const String TAG_FORMITEMS = "formitems";
const String TAG_KEY = "key";
const String TAG_LABEL = "label";
const String TAG_VALUE = "value";
const String TAG_ICON = "icon";
const String TAG_IS_RENDER_LABEL = "islabel";
const String TAG_VALUES = "values";
const String TAG_ITEMS = "items";
const String TAG_ITEMNAME = "itemname";
const String TAG_ITEM = "item";
const String TAG_TYPE = "type";
const String TAG_READONLY = "readonly";
const String TAG_SIZE = "size";
const String TAG_URL = "url";

/// Separator for multiple items in the form results.
const String SEP = "#";

/// An interface for constraints.
///
/// @author Andrea Antonello (www.hydrologis.com)
abstract class IConstraint {
  /// Applies the current filter to the supplied value.
  ///
  /// @param value the value to check.
  void applyConstraint(Object value);

  /// Getter for the constraint's result.
  ///
  /// @return <code>true</code> if the constraint applies.
  bool isValid();

  /// Getter for the description of the constraint.
  ///
  /// @return the description of the constraint.
  String getDescription();
}

/// A set of constraints.
///
/// @author Andrea Antonello (www.hydrologis.com)
class Constraints {
  List<IConstraint> constraints = [];

  /// Add a constraint.
  ///
  /// @param constraint the constraint to add.
  void addConstraint(IConstraint constraint) {
    if (!constraints.contains(constraint)) {
      constraints.add(constraint);
    }
  }

  /// Remove a constraint.
  ///
  /// @param constraint the constraint to remove.
  void removeConstraint(IConstraint constraint) {
    if (constraints.contains(constraint)) {
      constraints.remove(constraint);
    }
  }

  /// Checks if all the {@link IConstraint}s in the current set are valid.
  ///
  /// @param object the object to check.
  /// @return <code>true</code> if all the constraints are valid.
  bool isValid(Object object) {
    if (object == null) {
      return false;
    }
    bool isValid = true;
    for (int i = 0; i < constraints.length; i++) {
      IConstraint constraint = constraints[i];
      constraint.applyConstraint(object);
      isValid = isValid && constraint.isValid();
      if (!isValid) {
        return false;
      }
    }
    return true;
  }

  // Get human readable description of the constraint.
  String getDescription() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < constraints.length; i++) {
      IConstraint constraint = constraints[i];
      sb.write(",");
      sb.write(constraint.getDescription());
    }

    if (sb.isEmpty) {
      return "";
    }
    String description = sb.toString().substring(1);
    description = "( " + description + " )";
    return description;
  }
}

/// A constraint to check for the content not being empty.
///
/// @author Andrea Antonello (www.hydrologis.com)
class MandatoryConstraint implements IConstraint {
  bool _isValid = false;

  String _description = "mandatory"; //$NON-NLS-1$

  void applyConstraint(Object value) {
    if (value == null) {
      _isValid = false;
    } else {
      String string = value.toString();
      if (string.isNotEmpty) {
        _isValid = true;
      } else {
        _isValid = false;
      }
    }
  }

  bool isValid() {
    return _isValid;
  }

  String getDescription() {
    return _description;
  }
}

/// A numeric range constraint.
///
/// @author Andrea Antonello (www.hydrologis.com)
class RangeConstraint implements IConstraint {
  bool _isValid = false;

  double lowValue;
  bool includeLow;
  double highValue;
  bool includeHigh;

  /// @param low low value.
  /// @param includeLow if <code>true</code>, include low.
  /// @param high high value.
  /// @param includeHigh if <code>true</code>, include high.
  RangeConstraint(num low, bool includeLow, num high, bool includeHigh) {
    this.includeLow = includeLow;
    this.includeHigh = includeHigh;
    highValue = high.toDouble();
    lowValue = low.toDouble();
  }

  void applyConstraint(dynamic value) {
    if (value is String) {
      if (value.isEmpty) {
        // empty can be still ok, we just check for ranges if we have a value
        _isValid = true;
        return;
      } else {
        try {
          value = double.parse(value);
        } catch (e) {
          _isValid = false;
        }
      }
    }
    if (value is num) {
      double doubleValue = value.toDouble();
      if ( //
          ((includeLow && doubleValue >= lowValue) ||
                  (!includeLow && doubleValue > lowValue)) && //
              ((includeHigh && doubleValue <= highValue) ||
                  (!includeHigh && doubleValue < highValue)) //
          ) {
        _isValid = true;
      } else {
        _isValid = false;
      }
    } else {
      _isValid = false;
    }
  }

  bool isValid() {
    return _isValid;
  }

  String getDescription() {
    StringBuffer sb = new StringBuffer();
    if (includeLow) {
      sb.write("[");
    } else {
      sb.write("(");
    }
    sb.write(lowValue);
    sb.write(",");
    sb.write(highValue);
    if (includeHigh) {
      sb.write("]");
    } else {
      sb.write(")");
    }
    return sb.toString();
  }
}

/// Utilities methods for form stuff.
///
/// @author Andrea Antonello (www.hydrologis.com)
/// @since 2.6
class FormUtilities {
  /// Checks if the type is a special one.
  ///
  /// @param type the type string from the form.
  /// @return <code>true</code> if the type is special.
  static bool isTypeSpecial(String type) {
    if (type == TYPE_PRIMARYKEY) {
      return true;
    } else if (type == TYPE_HIDDEN) {
      return true;
    }
    return false;
  }

  /// Check an {@link JSONObject object} for constraints and collect them.
  ///
  /// @param jsonObject  the object to check.
  /// @param constraints the {@link Constraints} object to use or <code>null</code>.
  /// @return the original {@link Constraints} object or a new created.
  /// @throws Exception if something goes wrong.
  static Constraints handleConstraints(
      Map<String, dynamic> jsonObject, Constraints constraints) {
    if (constraints == null) constraints = new Constraints();

    if (jsonObject.containsKey(CONSTRAINT_MANDATORY)) {
      String mandatory = jsonObject[CONSTRAINT_MANDATORY].trim();
      if (mandatory.trim() == "yes") {
        constraints.addConstraint(MandatoryConstraint());
      }
    }
    if (jsonObject.containsKey(CONSTRAINT_RANGE)) {
      String range = jsonObject[CONSTRAINT_RANGE].trim();
      List<String> rangeSplit = range.split(",");
      if (rangeSplit.length == 2) {
        bool lowIncluded = rangeSplit[0].startsWith("[");
        String lowStr = rangeSplit[0].substring(1);
        double low = double.parse(lowStr);
        bool highIncluded = rangeSplit[1].endsWith("]");
        String highStr = rangeSplit[1].substring(0, rangeSplit[1].length - 1);
        double high = double.parse(highStr);
        constraints.addConstraint(
            RangeConstraint(low, lowIncluded, high, highIncluded));
      }
    }
    return constraints;
  }

  /// Updates a form items array with the given kay/value pair.
  ///
  /// @param formItemsArray the array to update.
  /// @param key            the key of the item to update.
  /// @param value          the new value to use.
  /// @ if something goes wrong.
  static void update(
      List<Map<String, dynamic>> formItemsArray, String key, String value) {
    int length = formItemsArray.length;

    for (int i = 0; i < length; i++) {
      Map<String, dynamic> itemObject = formItemsArray[i];
      if (itemObject.containsKey(TAG_KEY)) {
        String objKey = itemObject[TAG_KEY].trim();
        if (objKey == key) {
          itemObject[TAG_VALUE] = value;
        }
      }
    }
  }

  /// Update those fields that do not generate widgets.
  ///
  /// @param formItemsArray the items array.
  /// @param latitude       the lat value.
  /// @param longitude      the long value.
  /// @param pkValue        an optional value to set the PRIMARYKEY to.
  /// @ if something goes wrong.
  static void updateExtras(List<Map<String, dynamic>> formItemsArray,
      double latitude, double longitude, String pkValue) {
    int length = formItemsArray.length;

// TODO check back if it would be good to check also on labels
    for (int i = 0; i < length; i++) {
      Map<String, dynamic> itemObject = formItemsArray[i];
      if (itemObject.containsKey(TAG_KEY)) {
        String objKey = itemObject[TAG_KEY].trim();
        if (objKey.contains(TYPE_LATITUDE)) {
          itemObject[TAG_VALUE] = latitude;
        } else if (objKey.contains(TYPE_LONGITUDE)) {
          itemObject[TAG_VALUE] = longitude;
        }
        if (pkValue != null && itemObject.containsKey(TAG_TYPE)) {
          if (itemObject[TAG_TYPE].trim().equals(TYPE_PRIMARYKEY)) {
            itemObject[TAG_VALUE] = pkValue;
          }
        }
      }
    }
  }

  /// Transforms a form content to its plain text representation.
  /// <p/>
  /// <p>Media are inserted as the file name.</p>
  ///
  /// @param section    the json form.
  /// @param withTitles if <code>true</code>, all the section titles are added.
  /// @return the plain text representation of the form.
  /// @throws Exception if something goes wrong.
  static String formToPlainText(String section, bool withTitles) {
    StringBuffer sB = StringBuffer();
    Map<String, dynamic> sectionObject = jsonDecode(section);
    if (withTitles) {
      if (sectionObject.containsKey(ATTR_SECTIONNAME)) {
        String sectionName = sectionObject[ATTR_SECTIONNAME];
        sB.writeln(sectionName);
        for (int i = 0; i < sectionName.length; i++) {
          sB.write("=");
        }
        sB.writeln();
      }
    }

    List<String> formsNames = TagsManager.getFormNames4Section(sectionObject);
    for (int j = 0; j < formsNames.length; j++) {
      String formName = formsNames[j];
      if (withTitles) {
        sB.writeln(formName);
        for (int i = 0; i < formName.length; i++) {
          sB.write("-");
          sB.write("-");
        }
        sB.writeln();
      }
      Map<String, dynamic> form4Name =
          TagsManager.getForm4Name(formName, sectionObject);
      List<Map<String, dynamic>> formItems =
          TagsManager.getFormItems(form4Name);
      for (int i = 0; i < formItems.length; i++) {
        Map<String, dynamic> formItem = formItems[i];
        if (!formItem.containsKey(TAG_KEY) ||
            !formItem.containsKey(TAG_VALUE) ||
            !formItem.containsKey(TAG_TYPE)) {
          continue;
        }

        String type = formItem[TAG_TYPE];
        String key = formItem[TAG_KEY];
        String value = formItem[TAG_VALUE];
        String label = key;
        if (formItem.containsKey(TAG_LABEL)) {
          label = formItem[TAG_LABEL];
        }

        if (type == TYPE_PICTURES ||
            type == TYPE_IMAGELIB ||
            type == TYPE_MAP ||
            type == TYPE_SKETCH) {
          if (value.trim().isEmpty) {
            continue;
          }
          List<String> imageSplit = value.split(";");
          for (int i = 0; i < imageSplit.length; i++) {
            String image = imageSplit[i];
            String imgName = FileUtilities.nameFromFile(image, true);
            sB.writeln("$label: $imgName");
          }
        } else {
          sB.writeln("$label: $value");
        }
      }
    }
    return sB.toString();
  }

  /// Get the images paths out of a form string.
  ///
  /// @param formString the form.
  /// @return the list of images paths.
  /// @throws Exception if something goes wrong.
  static List<String> getImageIds(String formString) {
    List<String> imageIds = [];
    if (formString != null && formString.isNotEmpty) {
      Map<String, dynamic> sectionObject = jsonDecode(formString);
      List<String> formsNames = TagsManager.getFormNames4Section(sectionObject);
      for (int j = 0; j < formsNames.length; j++) {
        String formName = formsNames[j];
        Map<String, dynamic> form4Name =
            TagsManager.getForm4Name(formName, sectionObject);
        var formItems = TagsManager.getFormItems(form4Name);
        for (int i = 0; i < formItems.length; i++) {
          Map<String, dynamic> formItem = formItems[i];
          if (!formItem.containsKey(TAG_KEY)) {
            continue;
          }

          String type = formItem[TAG_TYPE];
          String value = "";
          if (formItem.containsKey(TAG_VALUE)) value = formItem[TAG_VALUE];

          if (type == TYPE_PICTURES || type == TYPE_IMAGELIB) {
            if (value.trim().isEmpty) {
              continue;
            }
            List<String> imageSplit = value.split(";");
            imageIds.addAll(imageSplit);
          } else if (type == TYPE_MAP) {
            if (value.trim().isEmpty) {
              continue;
            }
            String image = value.trim();
            imageIds.add(image);
          } else if (type == TYPE_SKETCH) {
            if (value.trim().isEmpty) {
              continue;
            }
            List<String> imageSplit = value.split(";");
            imageIds.addAll(imageSplit);
          }
        }
      }
    }
    return imageIds;
  }

  ///**
// * Make the given string json safe.
// *
// * @param text the srting to check.
// * @return the modified string.
// */
//static String makeTextJsonSafe
//(
//
//String text
//) {
//text = text.replaceAll("\"", "'");
//return text;
//}

}

/// Singleton that takes care of tags.
/// <p/>
/// <p>The tags are looked for in the following places:</p>
/// <ul>
/// <li>a file named <b>tags.json</b> inside the application folder (Which
/// is retrieved via {@link ResourcesManager#getApplicationSupporterDir()} </li>
/// <li>or, if the above is missing, a file named <b>tags/tags.json</b> in
/// the asset folder of the project. In that case the file is copied over
/// to the file in the first point.</li>
/// </ul>
/// <p>
/// <p>
/// The tags file is subdivided as follows:
/// <p>
/// [{
/// "sectionname": "scheda_sisma",
/// "sectiondescription": "this produces a button names scheda_sisma",
/// "forms": [
/// {
/// "formname": "Name of the section, used in the fragments list",
/// "formitems": [
/// ....
/// ....
/// ]
/// },{
/// "formname": "This name produces a second fragment",
/// "formitems": [
/// ....
/// ....
/// ]
/// }
/// ]
/// },{
/// "sectionname": "section 2",
/// "sectiondescription": "this produces a second button",
/// "forms": [
/// {
/// "formname": "this produces one fragment in the list",
/// "formitems": [
/// ....
/// ....
/// ]
/// },{
/// <p>
/// }
/// ]
/// }]
///
/// @author Andrea Antonello (www.hydrologis.com)
class TagsManager {
  /// The tags file name end pattern. All files that end with this are ligible as tags.
  static const String TAGSFILENAME_ENDPATTERN = "tags.json";

  List<String> _tagsFileArray;
  List<String> _tagsFileArrayStrings;

  static final TagsManager _instance = TagsManager._internal();

  factory TagsManager() => _instance;

  TagsManager._internal() {}

  /// Creates a new sectionsmap from the tags file
  LinkedHashMap<String, Map<String, dynamic>> getSectionsMap() {
    LinkedHashMap<String, Map<String, dynamic>> _sectionsMap = LinkedHashMap();
    for (int j = 0; j < _tagsFileArrayStrings.length; j++) {
      String tagsFileString = _tagsFileArrayStrings[j];
      List<dynamic> sectionsArrayObj = jsonDecode(tagsFileString);
      int tagsNum = sectionsArrayObj.length;
      for (int i = 0; i < tagsNum; i++) {
        Map<String, dynamic> jsonObject = sectionsArrayObj[i];
        if (jsonObject.containsKey(ATTR_SECTIONNAME)) {
          String sectionName = jsonObject[ATTR_SECTIONNAME];
          _sectionsMap[sectionName] = jsonObject;
        }
      }
    }
    return _sectionsMap;
  }

  /// Performs the first data reading. Necessary for everything else.
  ///
  /// @param context the context to use.
  /// @throws Exception
  Future<void> readFileTags([String tagsFilePath]) async {
    if (_tagsFileArray == null) {
      _tagsFileArray = [];
      _tagsFileArrayStrings = [];
    }

    if (tagsFilePath != null) {
      _tagsFileArray.add(tagsFilePath);
    } else {
      Directory formsFolder = await Workspace.getFormsFolder();
      List<String> fileNames = FileUtilities.getFilesInPathByExt(
          formsFolder.path, TAGSFILENAME_ENDPATTERN);
      _tagsFileArray = fileNames
          .map((fn) => FileUtilities.joinPaths(formsFolder.path, fn))
          .toList();
      if (_tagsFileArray == null || _tagsFileArray.isEmpty) {
        String tagsFile =
            FileUtilities.joinPaths(formsFolder.path, "tags.json");
        if (!File(tagsFile).existsSync()) {
          var tagsString = await rootBundle.loadString("assets/tags.json");
          FileUtilities.writeStringToFile(tagsFile, tagsString);
        }
        _tagsFileArray = [tagsFile];
      }
    }

    for (int j = 0; j < _tagsFileArray.length; j++) {
      String tagsFile = _tagsFileArray[j];
      if (!File(tagsFile).existsSync()) continue;
      String tagsFileString = FileUtilities.readFile(tagsFile);
      _tagsFileArrayStrings.add(tagsFileString);
    }
  }

  ///**
// * @return the section names.
// */
//public Set<String> getSectionNames() {
//  return sectionsMap.keySet();
//}
//
  ///**
// * get a section obj by name.
// *
// * @param name thename.
// * @return the section object.
// */
//public JSONObject getSectionByName(String name) {
//  return sectionsMap.get(name);
//}
//
//public String getSectionDescriptionByName(String sectionName) {
//  return sectionsDescriptionMap.get(sectionName);
//}
//
  /// get form name from a section obj.
  ///
  /// @param section the section.
  /// @return the name.
  /// @ if something goes wrong.
  static List<String> getFormNames4Section(Map<String, dynamic> section) {
    List<String> names = [];
    List<dynamic> jsonArray = section[ATTR_FORMS];
    if (jsonArray != null && jsonArray.isNotEmpty) {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<String, dynamic> jsonObject = jsonArray[i];
        if (jsonObject.containsKey(ATTR_FORMNAME)) {
          String formName = jsonObject[ATTR_FORMNAME];
          names.add(formName);
        }
      }
    }
    return names;
  }

  /// get icon from a section obj.
  ///
  static String getIcon4Section(Map<String, dynamic> section) {
    if (section.containsKey(ATTR_SECTIONICON)) {
      return section[ATTR_SECTIONICON];
    } else {
      return "fileAlt";
    }
  }

  /// Get the form for a name.
  ///
  /// @param formName the name.
  /// @param section  the section object containing the form.
  /// @return the form object.
  /// @ if something goes wrong.
  static Map<String, dynamic> getForm4Name(
      String formName, Map<String, dynamic> section) {
    List<dynamic> jsonArray = section[ATTR_FORMS];
    if (jsonArray != null && jsonArray.length > 0) {
      for (int i = 0; i < jsonArray.length; i++) {
        Map<String, dynamic> jsonObject = jsonArray[i];
        if (jsonObject.containsKey(ATTR_FORMNAME)) {
          String tmpFormName = jsonObject[ATTR_FORMNAME];
          if (tmpFormName == formName) {
            return jsonObject;
          }
        }
      }
    }
    return null;
  }

  ///**
// * Convert a string to a {@link TagObject}.
// *
// * @param jsonString the string.
// * @return the object.
// * @ if something goes wrong.
// */
//public static TagObject stringToTagObject(String jsonString)  {
//JSONObject jsonObject = new JSONObject(jsonString);
//String shortname = jsonObject.getString(TAG_SHORTNAME);
//String longname = jsonObject.getString(TAG_LONGNAME);
//
//TagObject tag = new TagObject();
//tag.shortName = shortname;
//tag.longName = longname;
//if (jsonObject.has(TAG_FORMS)) {
//tag.hasForm = true;
//}
//tag.jsonString = jsonString;
//return tag;
//}
//

  /// Utility method to get the formitems of a form object.
  /// <p>
  /// <p>Note that the entering json object has to be one
  /// object of the main array, not THE main array itself,
  /// i.e. a choice was already done.
  ///
  /// @param formObj the single object.
  /// @return the array of items of the contained form or <code>null</code> if
  /// no form is contained.
  /// @ if something goes wrong.
  static List<dynamic> getFormItems(Map<String, dynamic> formObj) {
    if (formObj.containsKey(TAG_FORMITEMS)) {
      List<dynamic> formItemsArray = formObj[TAG_FORMITEMS];
      int emptyIndex = -1;
      while ((emptyIndex = hasEmpty(formItemsArray)) >= 0) {
        formItemsArray.remove(emptyIndex);
      }
      return formItemsArray;
    }
    return [];
  }

  static int hasEmpty(List<dynamic> formItemsArray) {
    for (int i = 0; i < formItemsArray.length; i++) {
      Map<String, dynamic> formItem = formItemsArray[i];
      if (formItem.isEmpty) {
        return i;
      }
    }
    return -1;
  }

  static String getLabelFromFormItem(Map<String, dynamic> formItem) {
    String label = formItem[TAG_LABEL] ?? formItem[TAG_KEY];
    return label;
  }

  static String getTypeFromFormItem(Map<String, dynamic> formItem) {
    return formItem[TAG_TYPE];
  }

  /// Utility method to get the combo items of a formitem object.
  ///
  /// @param formItem the json form <b>item</b>.
  /// @return the array of items.
  /// @ if something goes wrong.
  static List<dynamic> getComboItems(Map<String, dynamic> formItem) {
    if (formItem.containsKey(TAG_VALUES)) {
      var valuesObj = formItem[TAG_VALUES];
      if (valuesObj.containsKey(TAG_ITEMS)) {
        return valuesObj[TAG_ITEMS];
      }
    }
    return null;
  }

  /// @param comboItems combo items object.
  /// @return the string names.
  /// @ if something goes wrong.
  static List<String> comboItems2StringArray(List<dynamic> comboItems) {
    int length = comboItems.length;
    List<String> itemsArray = [];
    for (int i = 0; i < length; i++) {
      var itemObj = comboItems[i];
      if (itemObj.containsKey(TAG_ITEM)) {
        itemsArray.add(itemObj[TAG_ITEM].trim());
      } else {
        itemsArray.add(" - ");
      }
    }
    return itemsArray;
  }

  ///**
// * Extract the combo values map.
// *
// * @param formItem the json object.
// * @return the map of combo items.
// * @ if something goes wrong.
// */
//public static LinkedHashMap<String, List<String>> extractComboValuesMap(JSONObject formItem)  {
//LinkedHashMap<String, List<String>> valuesMap = new LinkedHashMap<>();
//if (formItem.has(TAG_VALUES)) {
//JSONObject valuesObj = formItem.getJSONObject(TAG_VALUES);
//
//JSONArray names = valuesObj.names();
//int length = names.length;
//for (int i = 0; i < length; i++) {
//String name = names.getString(i);
//
//List<String> valuesList = new ArrayList<String>();
//JSONArray itemsArray = valuesObj.getJSONArray(name);
//int length2 = itemsArray.length;
//for (int j = 0; j < length2; j++) {
//JSONObject itemObj = itemsArray.getJSONObject(j);
//if (itemObj.has(TAG_ITEM)) {
//valuesList.add(itemObj.getString(TAG_ITEM).trim());
//} else {
//valuesList.add(" - ");
//}
//}
//valuesMap.put(name, valuesList);
//}
//}
//return valuesMap;
//
//}
//
  ///**
// * Extract the combo values map.
// *
// * @param formItem the json object.
// * @return the map of combo items.
// * @ if something goes wrong.
// */
//public static LinkedHashMap<String, List<NamedList<String>>> extractOneToManyComboValuesMap(JSONObject formItem)  {
//LinkedHashMap<String, List<NamedList<String>>> valuesMap = new LinkedHashMap<>();
//if (formItem.has(TAG_VALUES)) {
//JSONObject valuesObj = formItem.getJSONObject(TAG_VALUES);
//
//JSONArray names = valuesObj.names();
//int length = names.length;
//for (int i = 0; i < length; i++) {
//String name = names.getString(i);
//
//List<NamedList<String>> valuesList = new ArrayList<>();
//JSONArray itemsArray = valuesObj.getJSONArray(name);
//int length2 = itemsArray.length;
//for (int j = 0; j < length2; j++) {
//JSONObject itemObj = itemsArray.getJSONObject(j);
//
//String itemName = itemObj.getString(TAG_ITEMNAME);
//JSONArray itemsSubArray = itemObj.getJSONArray(TAG_ITEMS);
//NamedList<String> namedList = new NamedList<>();
//namedList.name = itemName;
//int length3 = itemsSubArray.length;
//for (int k = 0; k < length3; k++) {
//JSONObject subIemObj = itemsSubArray.getJSONObject(k);
//if (subIemObj.has(TAG_ITEM)) {
//namedList.items.add(subIemObj.getString(TAG_ITEM).trim());
//} else {
//namedList.items.add(" - ");
//}
//}
//valuesList.add(namedList);
//}
//valuesMap.put(name, valuesList);
//}
//}
//return valuesMap;
//}

}

/// The tag object.
class TagObject {
  String shortName;
  String longName;
  bool hasForm;
  String jsonString;
}
