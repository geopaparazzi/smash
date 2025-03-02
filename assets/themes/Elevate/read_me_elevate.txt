5.1

Elevate themes read me:
***********************

1. Installation & usage:
   English
   German
   
2. Changelog

3. Licenses


-------------------------------------------------------------------------
INSTALLATION & USAGE
-------------------------------------------------------------------------

ENGLISH:
********

OruxMaps:
---------

Quick install (recommended):
- Open http://www.openandromaps.org/en/legend/elevate-mountain-hike-theme in a browser on your android device
- Press on "OruxMaps" in the column "Install in Android" below "Downloads" in the "Elevate 4" table

Choose map style (essential):
- Make sure in OruxMaps settings that "User interface", "Miscellaneous UI", "No Navigation Drawer" is not checked
- Open navigation drawer by swiping from the left border, tap on "Mapsforge theme", tap on the the theme you like to use (Elevate or Elements)
- Use the cog wheel next to "Mapsforge theme" in the navigation drawer to choose the map style (hiking, cycling, city, mountainbike) and (de-)select overlays
- There are other ways like the old style action bar or on screen buttons, use the OruxMaps manual on how to use this

Manual install (advanced):
- Please make sure you downloaded "Elevate.zip"
- If it's an update of existing Elevate map themes: remove all old files and folders
- Unzip Elevate.zip with an Android file explorer to "../oruxmaps/mapstyles/" on your SD-Card or internal memory (depending on your device)
- You can choose your own path for theme files in OruxMaps via "...", "Global settings", "Maps", "Mapsforge settings" and "Mapsforge themes"
- Choose map style as above


Locus:
------

Quick install (recommended):
- Open http://www.openandromaps.org/en/legend/elevate-mountain-hike-theme in a browser on your android device
- Press on "Locus" in the column "Install in Android" below "Downloads" in the "Elevate 4" table

Choose map style (essential):
- For choosing the map theme in Locus use the blue button on the bottom left side of the map for "Map content" and press "Map themes" (if not available open settings, "Maps", "Panels & Buttons", "Left Actions Panel", check "Map content") 
- Touch the name of the map theme (if necessary hit "Show more" below "Internal themes")
- For choosing map styles (hiking, cycling, city, mountainbike) and overlays, a menu pops up when choosing the map theme. To change again later, just use "Map themes" again.
- There are other ways to do this, use the Locus manual for reference

Manual install (advanced):
- Please make sure you downloaded "Elevate.zip"
- If it's an update of existing Elevate map theme files: remove all old files and folders
- Unzip Elevate.zip with an Android file explorer into a subfolder of "../Locus/mapsVector/_themes/" on your SD-Card or internal memory (depending on your device)
- Choose map style as above


-------------------------------------------------------------------------

DEUTSCH:
********

OruxMaps:
---------

Schnellinstallation (empfohlen):
- Öffne http://www.openandromaps.org/kartenlegende/elevation-hike-theme in einem Browser auf dem Android Gerät
- Drücke auf "OruxMaps" in der Spalte "Installieren unter Android" unterhalb von "Downloads" in der "Elevate 4" Tabelle

Kartenstil wählen (wichtig):
- Stelle sicher, das in den OruxMaps Einstellungen unter "Benutzeroberfläche", "Verschiedenes" kein Haken bei "App-Navigation ausblenden" gesetzt ist
- Öffne die App-Navagation durch das Wischen vom linken Rand, berühre "Mapsforge-Thema" und berühre den gewünschten Theme (Elevate oder Elements)
- Benutze das Zahnrad neben "Mapsforge theme" in der App Navigation um den Kartenstil auszuwählen und Overlays an- oder abzuschalten
- Es gibt andere Wege hierzu wie die alte Menüleiste oder die Buttons auf dem Bildschirm, wie das geht bitte im OruxMaps Handbuch nachlesen

Manuelle Installation (fortgeschritten):
- Bitte darauf achten, dass die heruntergeladene Datei "Elevate.zip" heißen sollte
- Wenn es ein Update von bisherigen Elevate Kartenthemen ist: lösche alle alten Dateien und Ordner
- Entpacke Elevate.zip mit einem Android Datei Explorer nach "../oruxmaps/mapstyles/" auf der SD-Karte oder im internen Speicher (kommt auf das Gerät an)
- Man kann selbst in OruxMaps auch den Pfad zu den Kartenthemen festlegen, via "Menü", "Globale Einstellungen", "Karten", "Mapsforge-Einstellungen" und "Mapsforge-Themen"
- Kartenstil wählen siehe oben

Locus:
------

Schnellinstallation (empfohlen):
- Öffne http://www.openandromaps.org/kartenlegende/elevation-hike-theme in einem Browser auf dem Android Gerät
- Drücke auf "Locus" in der Spalte "Installieren unter Android" unterhalb von "Downloads" in der "Elevate 4" Tabelle

Kartenstil wählen (wichtig):
- Um den Kartenstil auszuwählen benutze in Locus den blauen Button für "Karteninhalt" unten links bei der Karte und drücke auf "Thema der Karte" (wenn nicht vorhanden öffne die Einstellungen, "Karten", "Bedienleisten & Knöpfe", "Aktivitätenliste", Haken bei "Karteninhalt" setzen)
- Wähle dann den Namen des Kartenthemas (wenn nötig, berühre "mehr..." am Ende von "Interne Themen")
- Um Kartenstile und Overlays zu ändern erscheint ein weiteres Menü wenn das Kartenthema ausgewählt wird. Um diese später zu ändern, einfach wieder "Thema der Karte" benutzen. 
- Es gibt andere Wege hierzu, wie das geht bitte im Locus Handbuch nachlesen

Manuelle Installation (fortgeschritten):
- Bitte darauf achten dass die heruntergeladene Datei "Elevate.zip" heißen sollte (oder die L/XL Varianten, für die gilt das unten Stehende entsprechend)
- Wenn es ein Update von bisherigen Elevate Kartenthemen ist: lösche alle alten Dateien und Ordner
- Entpacke Elevate.zip mit einem Android Datei Explorer in einen Unterordner von "../Locus/mapsVector/_themes/" auf der SD-Karte oder im internen Speicher (kommt auf das Gerät an)
- Kartenstil wählen siehe oben


-------------------------------------------------------------------------
CHANGELOG
-------------------------------------------------------------------------

5.1 07/06/22
- added: tracktype=grade1 to emphasized paved ways options,  low zoom emphasized paved cycle ways rendering (cycling), man_made=breakwater, amenity=bicycle_repair_station, amenity=public_bookcase
- changed rendering of: man_made=groyne, waterway=weir, low zoom waymarks colored routes (hiking)
- removed: mtbnetwork=umn (MTB)

5.0 05/12/21
- made for next OAM map generation based on mapsforge maps V5, starting December 2021
- new routes and separate route refs: hknetwork=own, network=ocn, mtbnetwork=omn, ref_hike/rec_cycle/ref_mtb 
- better waymarks support: OSMC waycolors orange/brown/gray, lots of additional, new OSMC foreground/backgrounds, changed rendering of OSMC waycolors
- changed symbols fee=yes symbols for parking and toilets, removed obsolete uwn/ucn networks
- added building=greenhouse 

4.5.2 14/10/21
- optimized drag_lift and chair_lift symbols, changed rendering of path/footway areas, natural=tree_row
- added rendering for closed highway=pedestrian ways, highway=construction as area, cutting=yes, hillshading (for apps that support it), waymarks: white background when background is missing

4.5.1 27/05/21
- added new rendering of MTB Routes (local/unspecified yellow, regional/national/international green), rendering alpine_huts as restaurants when accommodations are turned off, man_made=reservoir_covered, fee=yes for parking and toilets, bicycle charging station
- changed historic=stone/shop=farm for latest maps, updated translations
- removed tourism=information without specific information=*
- optimized contour lines (hiking/mtb for mountain areas, cycling/city for flat areas)

4.5.0 21/04/21
- many changes in POI symbols - new colors, remodeled categories, unified symbols, reworked many symbols, category letters for mapstyle options (R=Route, W=Ways, P=POIs, A=Areas)
- restructured POI categories
- added minor contour lines in cycling for ZL13/14, some access additions, historic=stone, shop=farm, man_made=wastewater_plant, man_made=water_works, amenity=ice_cream, sport=cliff_diving, sport=free_flying, sport=climbing_adventure, sport=roller_skating, sport=skateboard, sport=miniature_golf
- changed aerial ways rendering, removed workaround for missing building tags, removed symbol for water_well/drinking (now same as drinking_water)

4.4.5 06/03/21
- added mtb:scale and mtb:scale:uphill to highway=steps in MTB-mapstyle
- fixed error in cliffs

4.4.4 15/02/21
- added additional rendering for protected areas with limited access (onroad only, discouraged, conditional no etc.), natural=tree_row
- changed rendering rules for protected areas, limited minor contour lines to ZL15 instead of ZL13 (as the new 10m lines are too dense in steep areas), changed rendering for cliffs, removed access=private/restricted pattern from boundary areas 

4.4.3 06/01/21
- changed protected areas including new protect_class values (starting with maps January 2021)
- added blue line for paths with cycling permitted when option render like cycle ways is disabled (like in hiking), special rendering for natural/landuse areas with bridge=yes
- fixed cycleway lanes/tracks (now only shown in cycling)

4.4.2 26/09/20
- added barrier=log, barrier=hedge, highway=elevator, ref for railway=platform_edge/platform, amenity=townhall, protect_class=5/11 with access=no, hiking route refs for routes with waymarks colors, added/changed rendering for (special) buildings, different rendering for minor service roads, option to disable rendering of paths with cycling permitted like cycle ways (Cycling), highway=services
- changed rendering of highway=service, rendering for protected areas (replaced access=no pattern with strict nature reserve)
- fixed error in permitted cycle paths option

4.4.1 07/07/20
- fixed cycle route refs
- changed route ref captions, border color for tracks, highway=service
- added refs for guideposts in waymarks overlay, waymark colors for long distance routes at zoom 9-12

4.4.0 15/04/20
- changed to rendertheme V5 and removed deprecated tags, so now at least mapsforge 0.6.1 is necessary
- optimized all pathtexts for mapsforge 0.12 rendering (esp. route refs and street names, increased tiny font sizes), optimized oneway symbols
- added man_made=petroleum_well, attraction=summer_toboggan, priority to playground, rendering for strict nature reserves (protect_class=1), rendering of protect_class=2/3/4 for maps starting 03/2020
- changed rendering for buildings=ruins/buildings with historic=ruins, removed symbol for ruins when they are just buildings=ruins
- removed some unnecessary slashes in waymarks ressource links, small fix for hike_node/housenumbers, code cleaned of Locus Engine optimizations

4.3.3.1 30/09/19
- last version of Elevate LE for V3 maps in Locus
- fix for problem with some peaks not displayed at ZL14 and higher 

4.3.3 26/09/19
- added surface rendering for all tracks in hiking/cycling/mtb (as tracktype isn't always consistent with surface), tourism=artwork, natural=earth_bank, natural=gully, barrier=ditch, closed=yes for man_made=groyne
- optimized landcover rendering for multipolygons with missing inners, changed zoom level for river captions, changed map background option for city - bodies of water will now show, changed footway/path areas (rendering depends now on surface), restricted generator:source to power=generator
- fixed missing casings for some tracks at ZL13, improved spanish translations

4.3.2 08/07/19
- changed hiking nodes caption from name to addr:housenumber for maps with new tag-mapping, zoom-min for admin_level=4
- added option to show sac_scale=T1/hiking on paths without bicycle=* (may no be allowed to use by bike in certain countries)

4.3.1 12/06/19
- added emphasized paved cycleways resp. footpaths (cycling/city), tracktype=grade1 to ZL12 in Elevate, boundary=aboriginal_lands
- changed pipeline caption size
- small fixes

4.3.0 01/05/19
- new switchable overlays: paths + tracks (city), marking of permitted foot/cycle paths (hiking/cycling/mtb) - for countries where usage is forbidden by default or questionable
- added transformation of bridleways to paths/cycleways if using by foot/bike is legal (hiking/cycling/mtb), transformation of paths with bicycle=yes AND mtb:scale=1+ or sac_scale=T2+ to cycleways but with red dashes (cycling), ft_permit and ft_destination to other positive foot-rules
- changed old network=mtb to newer network_mtb=lay_mtb, MTB: leisure=track with mtb:scale is now rendered like MTB trails, emphasized access=no pattern

4.2.6.1 08/12/18
- changed license to allow commercial usage

4.2.6 08/10/18
- cycling/MTB style: changed rendering for footways/paths without mtb_scale/bicycle=yes etc., now similar as in hiking: brown means unpaved path/footway (or path without surface information); grey means paved path/footway (or footway without surface information)
- added watermill, windpump, osmc way color orange, boundary_stone 
- changed symbols for bicycle shop, cinema, rearranged drawing order of some areas

4.2.5 10/08/18
- added aerialway=zip_line, aerialway=station, regional cycling routes for ZL10/11 (maps of end of July 2018 and later), zoom-min for valley/canyon/peninsula, cw_lane_oneway/cw_track_oneway
- optimized rendering of settlement names rendering including improved popcat implementation (maps 06/08/18 and later), access for mtb mapstyle, mountain_range/mountain_area, oneways
- removed old cycleway tags

4.2.4 18/06/18
- added incline direction to MTB uphill scale, refs for ways without cycling/hiking routes (in cycling/hiking route overlays), refs for highway links, waterway=lock_gate, seperate rendering for minor aerialways, PopCat for city/town/village
- optimized cycleway rendering, cycling routes captions, waterway=dam, place rendering
- fixed Italian translation

4.2.3 23/04/18
- added the possibility to switch map background off (for composite maps), zoom min for area captions in Elements
- fixed tram stations, rough paved surfaces on highway=service
- changed zoom-min for playgrounds

4.2.2 13/02/18
- new access rendering: private/no/destination/permit patterns now shown per transport mode the mapstyle implies (foot/general values for hiking, bicycle/vehicle/general values for cycling/MTB, general values only for city), removed separate pattern bicycle=no 
- added seasonal for waterways, surface=winter, symbols for mountain passes with direction, building=construction
- removed house number display from peaks

4.2.1 28/11/17
- added zoom level visibility/priority per dominance for peaks/volcanos, osmc way colors (to waymarks overlay), blue/green/yellow arch waymark foregrounds, tower=windmill, bunker/bunker_disused, adit/adit_disused
- moved patterns for swimming areas/tourist attractions/golf courses/camping & caravan sites to special areas overlay, removed tourism=attraction from protected areas, tennis grounds/running tracks/swimming areas from sports overlay, limited tourism=attraction zoom level for Elements
- fixed ele for small volcano symbols, low zoom railway tunnels

4.2.0 06/10/17
- new optional overlay for extended road surface information of primary/secondary/tertiary/track roads and missing surface in cycling/MTB/hiking map style
- new via ferrata rendering: added non-switchable via_ferrata marking and highway=via_ferrata (for maps starting October 2017 and later)
- added dashed borders for non-paved cycleways (cycling/MTB), leisure=swimming_area, leisure=beach_resort, separate symbol for leisure=water_park, bboxweight for archipelagos and islands (for maps starting October 2017 and later), patterns for camp_site/caravan_site/golf_course (in case symbols for accomodation/sports are switched off), surface for turning circles
- changed administrative borders, all areas with strokes to areas with separate line for VTM compatibility
- removed "no trail_visibility available" marking for paths/footways without sac_scale/mtb_scale, old raw_sac_scale values (which were used in maps earlier than August 2017)

4.1.7 10/07/17
- added man_made=cutline, man_made=cairn, support for sac_scale=T5/T6 (for maps August 2017 and later)
- removed yes-value from via_ferrata_flag, changed name of special buildings overlay to "special buildings + orientation", moved guidepost to this overlay

4.1.6 18/05/17
- added natural=stone/rock for nodes, amenity=hunting_stand (in special buildings overlay)
- changed rendering for living_street, rendering for surface=smooth_paved for maps starting May 2017 (with separate surface=paved tagging)

4.1.5 11/03/17
- added intermittent=yes for waterbodies, access=permit
- smaller borders for normal/italic settlement captions
- Locus: changed to new feature scale-line-dy-by-zoom, removed lots of workarounds

4.1.4 19/12/16
- added cycleway_lane/cycleway_track, overlay option for mtb_scale on roads
- changed path areas, mtb_scale on roads
- fixed man_made=cross, Locus ZL 12 tunnels

4.1.3 29/11/16
- added colored names for waymarks, cycleway lanes/tracks left/right/both in cycling mapstyle, man_made=cross
- changed some waymark symbols, high zoom level country borders, highway refs on mid-level, removed route refs from highways, Locus: spacing for city symbols

4.1.2 10/10/16
- added waymarks for _right foregrounds, embankment=yes, separate rendering for sac_scale=difficult_alpine_hiking
- changed rendering of dyke/embankment, retaining_wall, golf_course, admin-borders, trail_visibility combinations (now: excellent+good, intermediate, bad+horrible+no), crevasse, crater
- fixes for waymarks

4.1.1 25/09/16
- changed rendering of waymark captions, optimized hiking route rendering
- fixed a bug in tunnel definitions

4.1.0.1 14/09/16
- fixed Locus conversion error for Elements
- Locus: added rounded curves for contour lines

4.1.0 14/09/16
- added waymark symbols for maps from late August 2016 and later
- new rendering of hiking routes
- new trail_visibility rendering/combinations, new rendering of tracks without tracktype
- reduced symbol size to match better those of Elevate 3 PNG versions
- added: man_made=dyke/embankment/groyne
- fixed MTBS1 and MTBS3 rendering for tracks, dy for tunnels, Locus: limited village names in Elevate LE to ZL 12+ (this time for real)

4.0.1 31/07/16
- reduced width of roads/buildings for less excessive scaling on very high dpi devices
- increased width of highway=pedestrian
- Locus: fixed rendering of most symbol captions at ZL 17+, limited village names in Elevate LE to ZL 12+
- some name changes in the overlay menu

4.0 10/07/16
- one size only: SVG version which scales with screen density is now default (instead of various sizes, removed those)
- new SVG patterns that scale with screen density, changed pattern zoom behavior
- new MTB mapstyle: new rendering for mtb_scale_uphill, added trail_visibility to paths, removed mtb_scale from highways with bicycle=no
- reworked routes: separate colors for international and national routes (same for hiking and cycling - blue and green), new low zoom rendering for hiking routes on paths, optimized route rendering
- reworked access markings: separate pattern colors for access=private (orange) and access=no (red), more complex filtering of access rules on highways, new access patterns
- Locus: added "dp" to all values for adjusting to screen density, added standard V4 version, renamed Locus edition with "LE"
- added tourism=apartment, zoom-min to some bridges and tunnels, separate rendering for private playgrounds, natural=cape/crater/bay/peninsula/fjord/canyon, place=islet/archipelago/sea/ocean, areas for highway=track/steps, names for highway areas, bicycle=no for areas, low zoom tunnels, areas for archaeological_site, natural=hot_spring, shop=mall
- changed low zoom captions, cycle and hike nodes, captions for protected areas, symbol for tourism=chalet, cliff rendering, motorway_junction caption, high zoom hiking routes on cycleways, moved observation tower to outdoor overlay, removed viewpoint from towers, rendering for sac_scale 5/6, limited capital to certain places, removed sled pistes from cycling mapstyle, optimized emphasized cycleways, removed bridges from tunnels, changed cycleway=track to cycleway=cw_track, removed amenity=drinking_water with drinking_water=no, optimized highway area rendering

3.1.6 16/03/16
- changed leisure=track to leisure=ls_track, larger symbol/earlier ZL for amenity=bus_station
- corrected SVG scale factor for public transport network stations, removed SVG scaling in Locus PNG versions
- removed leisure=ls_track from highways/tourism, moved highway=raceway upwards, moved residential landuse etc. to level 12+

3.1.5 07/03/16
- added caravan_site to low zoom markers, border for admin_level=3, natural=crevasse, low zoom markers for cities/capitals
- changed admin borders, rendering of some place names, rendering of low zoom (inter)national routes, moved low zoom highways to level 11 and lower, reduced caption/symbol distance for small SVG symbols (non-Locus), optimized very low zooms
- corrected spanish translation for overlay menus
- Locus: moved protected area borders to zoom level 16 because of rendering issues

3.1.4.1 10/02/16
- fixed path/footway rendering rules

3.1.3 09/02/16
- limited bicycle=no marking to relevant highways in cycling style
- restructured path rendering rules, fixed some missing trail_visibility information for path/footway without sac_scale in hiking style, fixed color for cycleway with foot=yes without surface information in hiking
- added bicycle access information for path/footway in hiking/city style, added weak priority for ele captions, leisure=picnic_table
- Locus: moved most captions for symbols to zoom level 17 and higher because of missing priorities/different collision management/missing dy on areas in Locus

3.1.2 10/01/16
- added oneway:bicycle=no for cycling style (turquoise arrow added where cycling is allowed in opposite direction of oneway streets), name captions in city style for retail/commercial/industrial/brownfield/garages/construction/greenfield, name caption for residential/farmyard/farm landuses
- changed ZL for high zoom forest/wood/desert captions

3.1.1 10/11/15
- optimized SVG symbols, rerendered PNG symbols
- changed rendering of tracks, rendering of routes at ZL 12+13, color of contour lines, rendering of pipelines
- added shop=travel_agency, new symbol for pub, amenity=bar

3.1.0 08/10/15
- low zoom areas are now much more usable: names for states and mountain ranges/areas are displayed, names of lakes/glaciers/woods/mountain ranges/protected for larger areas are displayed earlier and for smaller areas later (differs for city style)
- it's easier to distinguish between routes and highways as colors are optimized: (inter)national cycling routes are now violet, regional are red (already changed mtb routes and colors of major highways in earlier versions)
- improved Elements: limited symbols and captions somewhat to make low zooms less random and more usable
- added place=state, natural=mountain_range, natural=mountain_area for low zooms, bboxweight for poly_labels, zoom-min for ditch/stream/drain/river/canal/railway/pier/runway/apron/taxiway, different colors for some landscape names, small ford symbol for Elements low zooms
- changed rendering of settlement names, zoom-min for island captions/forest areas, low zoom hiking/cycling routes, captions & rendering of protected areas
- fixed rendering of low zoom motorway tunnels, volcano low zoom captions

3.0.6 19/09/15
- changed rendering for footways/paths without sac_scale for hiking style: brown means unpaved path/footway (or path without surface information); grey means paved path/footway (or footway without surface information)
- Locus: changed tunnels to Elevate 2 style (as dy isn't working properly on ways)
- corrected surface width for some highways
- limited national hiking/cycling routes to ZL8
- changed low to mid zoom rendering of highway refs, rendering of basin borders, (inter)national hiking routes on paths, colors of major highways, rendering of bridleways, zoom-min for bridges, track cores, xsd location
- removed leisure=track from ski pistes
- added glacier border, zoom-min for pistes, low zoom motorway tunnels, memorial types
- viewpoint now in both tourism and outdoor overlays

3.0.5 07/08/15
- added trail_visibility rendering to path/footway without sac_scale, added access=no for various items (rendered like access=private)
- added closed=yes to landcover and water areas (incl. fallback option) to avoid some rendering issues with double tagging on ways and relations
- changed access=no to access=acc_no for maps starting 30/07/15

3.0.4 19/07/15
- made contour lines optional for city style, disabled by default
- some items are now in several overlays (fuel in shops & cars, aerial ways in public transport & outdoor, alpine huts in outdoor & accommodation, toll in car & cycling style)
- changed rendering for path/footway in city style, color for mtb routes so that they distinguish better from roads, rendering for low zoom routes
- added kissing_gate, turnstile

3.0.3 23/06/15
- Locus: added .nomedia for map style chooser symbols
- removed cycleway=track/lane from footway/track/path/motorway
- added border to riverbank/natural=water, cycling: symbol for private/no bike gates starting zoom 15
- reduced area borders slightly
- optimized low zoom highways, low zoom local hiking routes, mid zoom street names

3.0.2 07/06/15
- Locus: uses now mapsforge 0.5 map styles including switchable overlays
- Locus optimizations: simplified some SVG symbols, moved building captions, new theme switcher icons
- added priority/display to street names/route refs

3.0.1 26/05/15
- added Locus version with limited support of new abilities and no switchable overlays
- added outline to SVG symbols for better perceptibility
- changed display of public transport stations, now analogous to public transport network of city style
- optimized low zoom rendering - no highway casings until level 13, changed cores until level 12, added various zoom-mins, changed border/railway rendering
- added bordertext for protected areas on high zooms, names for trunks/motorways, bic_designated/ft_designated, theme icons for Locus theme selector, slight transparency for white caption outlines
- removed underscores from filenames, some mapsforge 0.3 style file paths, basin/water caption from fountain, borders for some landcovers, pois with information=* from tourism=information
- changed rendering order for areas/pedestrian highways, rendering of fountain/basin/reservoir/drain/canal/aerialway, rendering of landscape names, rendering of waterway=dam, rendering of waterway names, rendering of cycleways with no surface information, rendering of runways
- moved ski pistes below paths

3.0.0 29/03/15
- switched to mapsforge rendertheme-v4, only compatible with apps supporting mapsforge 0.5 and higher, optimized for mapsforge 0.5.1
- added svg version, optimized for 320dpi
- added mapsforge styles (hiking, city, cycling), removed variations Elevelo & Elegant
- Elements now has the same styles as Elevate, the only difference is most zoom mins and low zoom markers are removed
- moved all symbols and captions in switchable overlays with english, french, german, italian and spanish labels
- separate style and overlay ids for all styles, layers and theme variation, so settings are remembered for each style/theme in OruxMaps
- replaced all dy for symbols with symbol-id/position
- made settlement names/routes/mtb tags switchable
- added switchable strong hiking/cycling routes for zoom level 14+
- city: added public transport routes overlay
- cycling: added emphasized cycling ways with surface information, changed cycling route colors
- added different zoom mins for different styles for some symbols
- transformed paths/footways to cycleways if bicycle=yes (cycling), transformed cycleways to footways with cycling marker if foot=yes (hiking/city)
- added priorities/display, map-background-outside, highway=emergency_access_point, natural=shingle, place=quarter, place=neighbourhood, place=farm, power=plant, station=subway, capital=2/4, cycleway=track/lane, transparency for sand/aerodrome/university/sea, pattern for bicycle=no on highways, access for highway areas, access=destination for parking
- changed low zoom markers, rendering for cliffs/ridges/aerialways, rendering for route refs, network rendering order, changed rendering for MTB-scale 5+6, separate rendering for railway=disused & abandoned, font size for contour lines text zl 16+, rendering of lock/dock/pier/bridleway/swimming_pool, limited toll to highways, rendering for places, captions for dam/weir/dock/lock, colors for post_box/atm/bank/fuel, simplified tracks for zoom 12/13, symbols for place_of_worship unknown/sports shop/gondola/cable_car/railway funicular, rendering of path/track etc. names, rendering of tunnels
- removed landcover with tunnel=yes, some building keys for POIs, limits for symbols eliminating captions on ways (unnecessary with mf 0.5)
- some clean-up, fine tuning and other changes I forgot

2.4.1 25/01/15
- added separate color for regional cycling routes (violet)
- removed place_of_worship from historic (like wayside_shrine)

2.4.0 04/01/15
- new appearance - changed rendering/colors for: buildings/wall/retaining_wall/dam etc., most highways/motorways/cycleways/motorway junctions/highway refs, tram, platforms, bridges, retail/military/industrial/school etc. landuses, place names, admin borders, peak names, pattern for pedestrian roads/areas, runways/aerodrome/helipad, powerlines, some fine-tuning
- improved routes: added separate color for local hiking routes (yellow), better visibility of route refs, some fine-tuning
- improved low zoom markers, major highway casings, bridges
- added separate rendering for MTB-scale 5+6, water_well, ele for cave_entrance, inhabited landuses color for lower zooms, taxiway bridges
- loosened dy value for OruxMaps so higher dpi themes can be used on lower dpi devices (e.g. 240dpi on 160dpi) and font-size a bit enlarged with OruxMaps setting
- limited paths/footway/steps/MTB-scale to zoom 13+
- removed POI areas with tunnel=yes
- combined all accompanying .txt-files

2.3.0.1 15/12/14
- fixed sea area problems when used with Locus maps

2.3.0 18/11/14
- added themes optimized for OruxMaps 6
- optimized rendering for mapsforge 0.4+
- moved large patterns to lower zoom levels
- changed motorway_junction, peak rendering zoom 13 and lower, track casings
- added map border

2.2.4 29/10/14
- Elegant: removed low zoom markers and limited peaks to zoom 14+ for better overview
- add zoom-min for military areas/waterways/polylabels, captions for ditch/drain, tunnel for railway=abandoned
- changed city and town name sizes at lower zoom levels, rendering retaining_wall, zoom-min for barriers for Elegant and Elevate, rendering of park etc. captions, rendering railway=abandoned
- removed bridge for areas 

2.2.3 17/09/14
- added pattern for glacier, name for weir/lock, leaf_type, railway=abandoned/disused, aerialway=goods, symbol for drag_lift 
- new rendering for wall, retaining_wall, dam, weir, dock, lock
- some changes for Elevelo (removed sled/nordic pistes, MTB scale perceptibility improvement, more contrast in route colors)
- simplified track intervals
- reduced generator:source to the more visible ones
- changed most nodes to any
- removed members-only huts from low zoom marker for alpine huts

2.2.2 05/08/14
- changed file/folder names so that it's easier to guess the use of the theme (added hiking/cycling/city/backcountry)
- added sport=climbing, separate symbol for emergency=phone, circles to hiking/cycling nodes
- made surface coloring more visible

2.2.1 19/06/14
- removed leisure=park from protected areas, wrong rendering of motorway_junction numbers at Zoom 19+
- added ways for towers, oneway=-1, ferry_terminal, defibrillator
- changed trail_visibility value combinations

2.2.0 01/06/14
- optimized rendering at zoom 12 and 13 for place names
- limited poi symbols to zoom 14 and larger and added low zoom markers (zoom 12+13) for important pois
- included MTB-scale in Elevelo (not in Elements because of sac_scale)
- added symbol for farmyard, archaeological_site, wayside_shrine, tundra
- removed green overlay for protected areas at lower zooms
- changed priority for camp_sites/caravan_sites, rendering for landfill, contour lines at lower zooms, rendering of surface

2.1.2 11/05/14
- added zoom-min for huts, name for tourism=information without information details 
- improved motorway_junction, aeroway symbols
- removed surface coloring for major highways

2.1.1 04/05/14
- Elements: removed zoom-min for shelter caption, green overlay for protected areas
- fixed grave_yard caption
- added surface coloring to highways (except path, track, byway, bridleway, motorway)
- adjusted some dy for Java map viewers

2.1.0 19/03/14
- new variation: Elements with cycling & hiking routes and little zoom-mins - for sparsely populated/mapped areas
- added emergency phone, mini_roundabout, desert, vending=bicycle_tube, religion=buddhist/shinto/hindu, border_control, raceway, bus_guideway, helipad area
- improved contour lines, closed piste areas
- changed MTB routes to orange
- some clean-up & restructuring & zoom-min changes

2.0.1 09/03/14
- fixed tertiary_link, ele for summits, ford on nodes
- added buildings to captions, symbol for sports_centre
- some clean-up & zoom-min changes

2.0.0 22/02/14
- new theme sizes: L for xhdpi (300+) and XL for xxhdpi (450+) devices
- new variation: Elevelo with cycling routes instead of hiking routes, therefore no cyling routes in other variants anymore
- completely reworked symbol set: unified & optimized, lots of modifications, different glow
- new symbols for bench, geyser, info terminal, railway crossings, sports shop, train station, via ferrata, waterfall, aerialways, information office
- new larger patterns at zoom 16+
- new cemetary pattern, reworked fell/heath/marsh/rock/scree/scrub pattern
- new rendering for military areas/swimming areas
- added drinking_water for fountains, toll highways, fords
- improved hknetworks on tracks
- removed locus bug workaround (bug is fixed in Locus 2.19)
- switch to one ressource folder with relative paths for Locus themes
- some clean-up and fine-tuning

1.3.1 01/02/14
- improved pattern protected_area z16+, rendering of safety measures ways, wetland pattern, zoom-min for landcover, hike nodes, piste:downhill
- added name for graveyard/cemetery, .nomedia file, slight indicator for sac_scale T5/T6, earlier names for camp_site/caravan_site
- removed cycle networks at zoom 11-14 in Elegant

1.3.0 12/01/14
- new rendering of hiking routes, many thanks to Maki for inspiration!
- new folder name for symbols/patterns, separate download for easier installation on Locus
- added trail_visibility, winter_room for alpine_huts, rendering of various POI ways without building tag, market_place, chalet, barrier=block, shelter_type, separate color for farmland, waterway bridges
- improved rendering of hkr refs, rendering of tunnels, safety_rope and ladder symbol, rendering of safety measures way, rock pattern, oneway symbol, leisure=track, ridge/arete, highway=track
- changed early appearance of alpine_hut names (reason: too often wrong tagged), width of highway=cycleway/service, core color cycleway, color of waterways/bodies of water, pipeline caption color, footway/bridge/barrier color, color for various POI areas
- moved POI name block for better priorities, adjusted some POI zoom-min
- removed transparency from beach/sand, coastline, transparency of bodies of water at zoom till 13, alpine_hut without name
- better "glow" for non-sjjb symbols
- workarounds for Locus "~"-Bug on nodes
- some fine-tuning

1.2.1 25/12/13
- improved rendering of sled pistes, school/college/university areas, historic buildings/areas, biergarten area, tourism=attraction, spring rendering
- removed swimming symbol from swimming_pools with sport=swimming
- reduced font-size for path etc. names
- refined forest pattern, rock pattern

1.2.0 17/12/13
- new subtheme "Elegant" for cities (without hiking routes and less obtrusive paths/footways)
- new rendering for cycle networks, blue borders on highways
- names for nearly every symbol starting zoom 18
- added lots of shops, name for restaurant nodes, name for pipelines, waterways/pipelines in tunnels, symbol for tourism=information without further details, closed=no to networks
- simplified place_of_worship etc. and more clean-up
- improved viewpoints, railway ways, access patterns, rock pattern, swimming_pool/swimming/water_park, public transport stations, highway casings, protected area pattern zoom 14+
- changed rendering for tourist attraction ways/areas/added area pattern, bridges, walls
- reduced zoom-min for barrier, bus_stop/tram_stop/railway halt captions
- installation instructions included
- lots of fine-tuning

1.1.3 01/12/13
- changed tourism information to any, area colors: industrial etc./school etc./retail, lowered level of residential/industrial etc./retail 
- improved attraction, pedestrian area/highway, bus_stop/tram_stop captions, swimming_pool
- turned some nodes into any, added memorial/monument area
- joined nature_reserve/national_park/protected_area for new handling in OAM
- added safety_rope, rungs, ladder

1.1.2 23/11/13
- improved leisure areas, nature_reserve, access patterns, highway=construction, construction bridges, rendering of motorway junctions and motorway refs, tunnels, conflicting refs/names of highways, highway areas
- added motorway junction names, zoom-min at way tourism attraction captions, transparency to buildings zoom-min=17
- removed city circles, tunnel platforms
- simplified shops, highway captions
- less transparency in patterns

1.1.1 17/11/13
- fixed meadow names
- added motorway junctions
- changed highway=construction
- changed orchard/protected area names to poly labels

1.1.0 15/11/13
- massive code clean-up and restructuring, lots of fine-tuning
- reduced and adjusted landuse/area colors
- new wood/forest patterns, incl. coniferous/deciduous
- hiking routes enhanced rendering on tracks/paths, now visible on roads
- improved: turning circles, highway refs, places, places of worship, tourism attraction, tracks, barrier ways, cliffs, landfill/quarry, tourist information, pier, bridges, tunnels, streets, administrative borders, dam, dock, weir, lock, walls, steps, suburb, river/stream/canal/ditch width
- added: isolated_dwelling, grassland, tourism attraction, orchard, vineyard, spring drinking_water no/yes, doctors, geyser, coastline, nordic pistes, gorge, water_point, wayside_cross, polylabels: forest/orchard, waterfall, rapids, symbol parking_private, police, slipway, museum, lighthouse, aeroway gate, golf, shooting, embassy, zoo, ele to places, ele/name to guidepost/viewpoint, ruins/castle area, summit:cross, pipeline, weir symbol, generator, alpine_hut access, ele to lots of amenities/spring/place_of_worship, ele to bodies of water, sac_scale to steps
- changed mountain pass/building text color to be in line with general coloring, changed peak/place color
- changed symbols for bench, picnic_site, bus stop, tram stop
- added serif italic font style for landscape information etc.
- some fixes for Locus

1.0.7 15/10/13
- removed: startoffset, tree limit rule
- less transparency for areas
- alpine_hut icon without zoom restriction again
- less obstrusive nature_reserve pattern
- better visibility for fell pattern

1.0.6 12/10/13
- added zoom restriction to some amenities/aerial ways
- reduced transparency for water, added transparency for reservoirs

1.0.5 12/10/13
- transparency in landuses/patterns
- changed some caption colors
- smaller sled pistes
- new rendering for bridleways
- optimized route refs/names

1.0.4 05/10/13
- code clean-up
- adjusted zoom restriction and sizes for various captions
- optimized swimming/spa etc.
- added historic symbols
- removed area for closed cliffs
- more transparency in wood pattern

1.0.1-1.03 30/09/13 
- zoom restriction for alpine_hut icon
- zoom restriction for elevation information
- bug fix

1.0 30/09/13 
- first public release


-------------------------------------------------------------------------
LICENSES
-------------------------------------------------------------------------

Elevate theme family
********************
including Elevate & Elements

by Tobias Kuehn
Contact: http://www.eartrumpet.net/contact/

Mapsforge theme for OpenAndroMaps
formerly based on OpenAndroMaps HC


License:
********

This map style is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License: https://creativecommons.org/licenses/by-nc-sa/4.0/
For commercial usage it is licensed under a Attribution-NoDerivatives 4.0 International License: https://creativecommons.org/licenses/by-nd/4.0/

This means you can use it in a commercial app etc. for free if you:
- attribute the origin (for example: "uses Elevate map theme by Tobias Kühn, http://www.openandromaps.org/en/legend/elevate-mountain-hike-theme")
- don't change anything or use parts of it, so you can only use it if you include the whole contents of the zip file

For non-commercial usage you are free to reuse everything I made if you stick to those conditions:
- attribute the origin (for example: "symbols/patterns/code based on Elevate theme by Tobias Kühn, http://www.openandromaps.org/en/legend/elevate-mountain-hike-theme")
- don't use it for commercial purposes, that means for example you are not allowed to include (also parts) or directly download with a commercial app; if in doubt contact me
- if you use some of my work it has to be under the same license, but only Creative Commons Attribution-NonCommercial-ShareAlike 4.0; please remove the commercial license, as it is only valid for unmodified Elevate
- have a look at the licenses of the resources I used below, those can differ - please also stick to those

I'm always happy to hear someone can use my work, so it would be nice if you contact me to let me know.

For automatic updates you can check the current version number here: https://www.openandromaps.org/wp-content/users/tobias/version.txt


Symbols and patterns licenses:
******************************

- all patterns, symbols for cliff, geyser, ladder, oneways, peaks, railway_crossings, ridge, rungs, safety_rope, via ferrata, volcano, waterfall, wilderness hut, goods_lift, drag_lift, bridge_movable, turnstile, hot spring, public transport, cities, apartment, beach_resort, water_park, swimming_area, bunkers, windpump, watermill, log, climbing_adventure, water_works, wastewater_plant and modifications/adaptions of other symbols by Tobias Kuehn - CC BY NC SA 4.0 license (commercial usage: CC BY ND 4.0 license)
- most symbols: http://www.sjjb.co.uk/mapicons - CC-0 license
- waymark symbols based on: Locus internal theme, Apache License and LocusUser#1 (Frank Schöneck)
- rapids and chemist symbols are adaptions of original symbols from: http://mapicons.nicolasmollet.com - CC BY SA 3.0 license
- sport shop contains a modification of an original symbol from: http://openclipart.org/detail/173952/shoe-by-spacefem-173952 - Public Domain
- cable_car, chair_lift, gondola, rail_funicular are modifications of original symbols from: http://wiki.openstreetmap.org/wiki/Template:Aerialway/doc - CC BY SA 2.0 license
- bench is a modification of an original symbol from: http://wiki.openstreetmap.org/wiki/File:Amenity_Bench-br.svg - Public Domain
- farmyard, emergency_access_point, stone, boundary_stone: http://osm-icons.org - CC-0 by Markus59
- defibrillator, water_well, free_flying, farm_shop: http://osm-icons.org - CC BY SA 2.0 license by Msemm
- hunting_stand, townhall, ice_cream, charging_station: https://gitlab.com/gmgeo/osmic - CC-0 by Michael Glanznig
- artwork, petroleum well: https://github.com/gravitystorm/openstreetmap-carto - CC-0 by Tomasz Wójcik
- elevator, roller_skating, skateboard, dollar coin: https://www.svgrepo.com/ - CC-0 by SVG Repo
- cliff_diving - CC_0 by Werner Huth