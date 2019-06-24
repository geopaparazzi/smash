/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/services.dart';
import 'package:mapsforge_flutter/core.dart';
import 'package:mapsforge_flutter/datastore.dart';
import 'package:mapsforge_flutter/maps.dart';

class MapModelHelper {
  static Future<MapModel> prepareMapModel() async {

    MultiMapDataStore multiMapDataStore = MultiMapDataStore(DataPolicy.DEDUPLICATE);

//    {
//      print("opening mapfile");
//      ReadBuffer readBuffer = ReadBuffer(_localPath + "/" + Constants.worldmap);
//      MapFile mapFile = MapFile(readBuffer, null, null);
//      await mapFile.init();
//      //await mapFile.debug();
//      multiMapDataStore.addMapDataStore(mapFile, true, true);
//    }
    {
      print("opening mapfile");
      String  _localPath = "/storage/emulated/0/mymaps/italy.map";
      ReadBuffer readBuffer = ReadBuffer(_localPath);
      MapFile mapFile = MapFile(readBuffer, null, null);
      await mapFile.init();
      //await mapFile.debug();
      multiMapDataStore.addMapDataStore(mapFile, false, false);
    }

    GraphicFactory graphicFactory = FlutterGraphicFactory();
    final DisplayModel displayModel = DisplayModel();
    SymbolCache symbolCache = SymbolCache(graphicFactory, displayModel);

    RenderThemeBuilder renderThemeBuilder = RenderThemeBuilder(graphicFactory, displayModel, symbolCache);
    String content = await rootBundle.loadString("assets/defaultrender.xml");
    await renderThemeBuilder.parseXml(content);
    RenderTheme renderTheme = renderThemeBuilder.build();
    MapDataStoreRenderer dataStoreRenderer = MapDataStoreRenderer(multiMapDataStore, renderTheme, graphicFactory, true);

    DummyRenderer dummyRenderer = DummyRenderer();

    FileBitmapCache bitmapCache = FileBitmapCache(dataStoreRenderer.getRenderKey());
//    bitmapCache.purge();

    MapModel mapModel = MapModel(
      displayModel: displayModel,
      graphicsFactory: graphicFactory,
      renderer: dataStoreRenderer,
      symbolCache: symbolCache,
      bitmapCache: bitmapCache,
    );

    MarkerDataStore markerDataStore = MarkerDataStore();
    markerDataStore.markers.add(BasicMarker(
      src: "jar:symbols/windsock.svg",
      symbolCache: symbolCache,
      width: 20,
      height: 20,
      caption: "TestMarker",
      latitude: 48.089355,
      longitude: 16.311509,
    ));
    mapModel.markerDataStores.add(markerDataStore);

    return mapModel;
  }
}
