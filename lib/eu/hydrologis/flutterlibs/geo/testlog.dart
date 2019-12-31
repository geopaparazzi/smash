/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'dart:math';

import 'package:dart_jts/dart_jts.dart';
import 'package:smash/eu/hydrologis/flutterlibs/geo/maps/map_plugins.dart';

const DO_TEST_LOG = false;

class Testlog {
  static int _index = 0;

  static Coordinate getNext() {
    if (_index > TESTLOG.length - 1) {
      _index = 0;
    }
    Coordinate c1 = TESTLOG[_index];
    Coordinate c2 = TESTLOG[_index + 1];
    var azimuth = _azimuth(c1, c2);
    _index++;
    return Coordinate.fromXYZ(c1.x, c1.y, azimuth);
  }

  /// Calculates the azimuth in degrees given two {@link Coordinate} composing a line.
  ///
  /// Note that the coords order is important and will differ of 180.
  ///
  /// @param c1 first coordinate (used as origin).
  /// @param c2 second coordinate.
  /// @return the azimuth angle.
  static double _azimuth(Coordinate c1, Coordinate c2) {
    // vertical
    if (c1.x == c2.x) {
      if (c1.y == c2.y) {
        // same point
        return double.nan;
      } else if (c1.y < c2.y) {
        return 0.0;
      } else if (c1.y > c2.y) {
        return 180.0;
      }
    }
    // horiz
    if (c1.y == c2.y) {
      if (c1.x < c2.x) {
        return 90.0;
      } else if (c1.x > c2.x) {
        return 270.0;
      }
    }
    // -> /
    if (c1.x < c2.x && c1.y < c2.y) {
      double tanA = (c2.x - c1.x) / (c2.y - c1.y);
      double atanD = atan(tanA);
      return toDegrees(atanD);
    }
    // -> \
    if (c1.x < c2.x && c1.y > c2.y) {
      double tanA = (c1.y - c2.y) / (c2.x - c1.x);
      double atanD = atan(tanA);
      return toDegrees(atanD) + 90.0;
    }
    // <- /
    if (c1.x > c2.x && c1.y > c2.y) {
      double tanA = (c1.x - c2.x) / (c1.y - c2.y);
      double atanD = atan(tanA);
      return toDegrees(atanD) + 180;
    }
    // <- \
    if (c1.x > c2.x && c1.y < c2.y) {
      double tanA = (c2.y - c1.y) / (c1.x - c2.x);
      double atanD = atan(tanA);
      return toDegrees(atanD) + 270;
    }

    return double.nan;
  }
}

var TESTLOG = [
  Coordinate(23.54325, 35.2708415),
  Coordinate(23.543236772800153, 35.27081867370877),
  Coordinate(23.5437484, 35.2705222),
  Coordinate(23.5442428, 35.2702136),
  Coordinate(23.5443063, 35.2700176),
  Coordinate(23.5449586, 35.269548),
  Coordinate(23.5460436, 35.2692442),
  Coordinate(23.5465642, 35.2688499),
  Coordinate(23.5474957, 35.2684612),
  Coordinate(23.5477654, 35.2685601),
  Coordinate(23.5480571, 35.2684129),
  Coordinate(23.5480914, 35.2683148),
  Coordinate(23.5482888, 35.268532),
  Coordinate(23.5486665, 35.268399),
  Coordinate(23.5490612, 35.2682868),
  Coordinate(23.5494045, 35.2681816),
  Coordinate(23.5498165, 35.2684269),
  Coordinate(23.5501771, 35.268637),
  Coordinate(23.5505547, 35.2684901),
  Coordinate(23.5508723, 35.2686512),
  Coordinate(23.5511984, 35.2686583),
  Coordinate(23.5517908, 35.2683079),
  Coordinate(23.5524347, 35.268238),
  Coordinate(23.5528035, 35.2682798),
  Coordinate(23.5531553, 35.2681676),
  Coordinate(23.5534472, 35.2682027),
  Coordinate(23.553867, 35.2680544),
  Coordinate(23.5541006, 35.2680857),
  Coordinate(23.5543742, 35.2679994),
  Coordinate(23.554606, 35.2678312),
  Coordinate(23.5548462, 35.2679784),
  Coordinate(23.5552068, 35.2679924),
  Coordinate(23.5557733, 35.2682798),
  Coordinate(23.5560994, 35.2683779),
  Coordinate(23.5565371, 35.268532),
  Coordinate(23.5567432, 35.2685741),
  Coordinate(23.5571295, 35.2686933),
  Coordinate(23.5577045, 35.2686791),
  Coordinate(23.5578589, 35.268588),
  Coordinate(23.5580993, 35.268588),
  Coordinate(23.5583311, 35.268518),
  Coordinate(23.5588547, 35.2685672),
  Coordinate(23.5592667, 35.2687562),
  Coordinate(23.5598074, 35.2688263),
  Coordinate(23.5600046, 35.2688052),
  Coordinate(23.5604854, 35.2689594),
  Coordinate(23.5606141, 35.2688684),
  Coordinate(23.5610863, 35.2688965),
  Coordinate(23.561378, 35.2689876),
  Coordinate(23.5619532, 35.2689594),
  Coordinate(23.5628543, 35.2688544),
  Coordinate(23.5634638, 35.2686162),
  Coordinate(23.5634295, 35.2685109),
  Coordinate(23.5635152, 35.2683288),
  Coordinate(23.563661, 35.2682447),
  Coordinate(23.5639358, 35.2682798),
  Coordinate(23.5645108, 35.2682027),
  Coordinate(23.5649056, 35.2679294),
  Coordinate(23.5654378, 35.2678594),
  Coordinate(23.5659614, 35.267558),
  Coordinate(23.5661072, 35.267558),
  Coordinate(23.5667683, 35.2673687),
  Coordinate(23.5674891, 35.2675299),
  Coordinate(23.5677123, 35.2672987),
  Coordinate(23.567884, 35.2672287),
  Coordinate(23.56815, 35.2670394),
  Coordinate(23.5686995, 35.2668291),
  Coordinate(23.5689224, 35.2667802),
  Coordinate(23.56918, 35.2669344),
  Coordinate(23.569446, 35.2669344),
  Coordinate(23.569652, 35.2672916),
  Coordinate(23.5694717, 35.2676981),
  Coordinate(23.5694891, 35.2677823),
  Coordinate(23.569343, 35.2678312),
  Coordinate(23.5692916, 35.2680415),
  Coordinate(23.5693687, 35.2680484),
  Coordinate(23.5698323, 35.2679994),
  Coordinate(23.5702615, 35.2675159),
  Coordinate(23.570536, 35.2671234),
  Coordinate(23.5710596, 35.2667731),
  Coordinate(23.571489, 35.2666399),
  Coordinate(23.5719094, 35.2664298),
  Coordinate(23.5723128, 35.2661984),
  Coordinate(23.5724846, 35.2661984),
  Coordinate(23.5731283, 35.265855),
  Coordinate(23.57342, 35.2656799),
  Coordinate(23.5736776, 35.2655396),
  Coordinate(23.5738149, 35.2650771),
  Coordinate(23.5742697, 35.2648389),
  Coordinate(23.5746475, 35.2647268),
  Coordinate(23.5751195, 35.2642643),
  Coordinate(23.5754886, 35.2638158),
  Coordinate(23.5757203, 35.2637876),
  Coordinate(23.576218, 35.2634583),
  Coordinate(23.5766988, 35.263143),
  Coordinate(23.5772138, 35.2628977),
  Coordinate(23.5773511, 35.2629187),
  Coordinate(23.5774455, 35.2627784),
  Coordinate(23.5773168, 35.2626805),
  Coordinate(23.5773597, 35.2625473),
  Coordinate(23.5775143, 35.2624421),
  Coordinate(23.57754, 35.2623791),
  Coordinate(23.5778233, 35.2622459),
  Coordinate(23.5782781, 35.2620567),
  Coordinate(23.5785871, 35.2616713),
  Coordinate(23.5788617, 35.26158),
  Coordinate(23.5790936, 35.261482),
  Coordinate(23.5794626, 35.2610406),
  Coordinate(23.5797973, 35.2605148),
  Coordinate(23.5801834, 35.2600102),
  Coordinate(23.5804068, 35.2595335),
  Coordinate(23.580707, 35.2590641),
  Coordinate(23.5808616, 35.2587907),
  Coordinate(23.5809561, 35.2586225),
  Coordinate(23.58081, 35.2584824),
  Coordinate(23.5808272, 35.2584053),
  Coordinate(23.5809561, 35.2583422),
  Coordinate(23.5810075, 35.258244),
  Coordinate(23.5810591, 35.2577815),
  Coordinate(23.5812306, 35.2577325),
  Coordinate(23.5812477, 35.2575573),
  Coordinate(23.5811621, 35.2574662),
  Coordinate(23.5813079, 35.257333),
  Coordinate(23.5812306, 35.2571927),
  Coordinate(23.5813593, 35.2571156),
  Coordinate(23.581325, 35.2569124),
  Coordinate(23.5814452, 35.2567302),
  Coordinate(23.5814023, 35.256555),
  Coordinate(23.5810332, 35.2564007),
  Coordinate(23.5811621, 35.2560362),
  Coordinate(23.5811105, 35.2555668),
  Coordinate(23.5811621, 35.2552724),
  Coordinate(23.5811621, 35.255027),
  Coordinate(23.5811362, 35.2547748),
  Coordinate(23.581282, 35.2545014),
  Coordinate(23.5812306, 35.2543612),
  Coordinate(23.5813165, 35.2541019),
  Coordinate(23.5813593, 35.2537515),
  Coordinate(23.5815053, 35.2535623),
  Coordinate(23.5815053, 35.253401),
  Coordinate(23.5814785, 35.253088),
  Coordinate(23.5812202, 35.2528407),
  Coordinate(23.5810157, 35.252549),
  Coordinate(23.5810317, 35.2517508),
  Coordinate(23.5812183, 35.2513949),
  Coordinate(23.5815311, 35.2512982),
  Coordinate(23.5818572, 35.2512561),
  Coordinate(23.5822176, 35.251095),
  Coordinate(23.5823808, 35.2509128),
  Coordinate(23.5824752, 35.2505975),
  Coordinate(23.5825782, 35.2505412),
  Coordinate(23.5823206, 35.2502538),
  Coordinate(23.5820461, 35.2501698),
  Coordinate(23.5816454, 35.249901),
  Coordinate(23.5814588, 35.2496367),
  Coordinate(23.5814886, 35.2494369),
  Coordinate(23.5811706, 35.2492797),
  Coordinate(23.5803038, 35.2491534),
  Coordinate(23.5801432, 35.249094),
  Coordinate(23.5800892, 35.2485832),
  Coordinate(23.5799638, 35.2481422),
  Coordinate(23.5797193, 35.2479784),
  Coordinate(23.5794918, 35.24767),
  Coordinate(23.5798396, 35.2472892),
  Coordinate(23.5801495, 35.2469383),
  Coordinate(23.5803727, 35.2465339),
  Coordinate(23.5801549, 35.2464764),
  Coordinate(23.5798068, 35.2463564),
  Coordinate(23.5792465, 35.2460454),
  Coordinate(23.5791595, 35.2458945),
  Coordinate(23.5791323, 35.2456768),
  Coordinate(23.5791649, 35.245468),
  Coordinate(23.5791323, 35.2452502),
  Coordinate(23.5790671, 35.2450593),
  Coordinate(23.5789638, 35.2449038),
  Coordinate(23.5788496, 35.2447393),
  Coordinate(23.5786264, 35.2444906),
  Coordinate(23.5784471, 35.2443573),
  Coordinate(23.5784109, 35.2442213),
  Coordinate(23.578511, 35.2441255),
  Coordinate(23.5787341, 35.2439324),
  Coordinate(23.5789822, 35.2437798),
  Coordinate(23.5792167, 35.2435898),
  Coordinate(23.5794052, 35.2433669),
  Coordinate(23.5794745, 35.2431657),
  Coordinate(23.5797746, 35.2429145),
  Coordinate(23.5798321, 35.242817),
  Coordinate(23.5799899, 35.2425345),
  Coordinate(23.5800637, 35.2424998),
  Coordinate(23.5801832, 35.2425088),
  Coordinate(23.5804349, 35.2425987),
  Coordinate(23.5806673, 35.2426609),
  Coordinate(23.580851, 35.2426719),
  Coordinate(23.5809326, 35.2426975),
  Coordinate(23.5810591, 35.2427697),
  Coordinate(23.5813692, 35.2430242),
  Coordinate(23.5814793, 35.2430817),
  Coordinate(23.581645, 35.2431119),
  Coordinate(23.5825166, 35.2431633),
  Coordinate(23.5827243, 35.2431067),
  Coordinate(23.5830241, 35.2429748),
  Coordinate(23.5832473, 35.2429685),
  Coordinate(23.5835626, 35.2428491),
  Coordinate(23.5837858, 35.2427045),
  Coordinate(23.5839165, 35.2425477),
  Coordinate(23.5841166, 35.2422586),
  Coordinate(23.5842662, 35.2421364),
  Coordinate(23.5846007, 35.2418455),
  Coordinate(23.5848182, 35.2416344),
  Coordinate(23.585164, 35.2413163),
  Coordinate(23.5853072, 35.241163),
  Coordinate(23.5855195, 35.2409695),
  Coordinate(23.5856527, 35.2408365),
  Coordinate(23.5856924, 35.2407396),
  Coordinate(23.5855689, 35.2405461),
  Coordinate(23.585559, 35.2404653),
  Coordinate(23.5855935, 35.2403364),
  Coordinate(23.5856823, 35.2401184),
  Coordinate(23.5857417, 35.2398644),
  Coordinate(23.5858157, 35.2396064),
  Coordinate(23.5859194, 35.239324),
  Coordinate(23.5860873, 35.2389731),
  Coordinate(23.586196, 35.2388641),
  Coordinate(23.5864775, 35.2387391),
  Coordinate(23.5869521, 35.2384296),
  Coordinate(23.5871209, 35.2382094),
  Coordinate(23.5871015, 35.2379919),
  Coordinate(23.5871114, 35.2377883),
  Coordinate(23.5872497, 35.2376167),
  Coordinate(23.5872641, 35.2374785),
  Coordinate(23.5871786, 35.2373194),
  Coordinate(23.5871343, 35.2371823),
  Coordinate(23.5871143, 35.2369605),
  Coordinate(23.587149, 35.2367226),
  Coordinate(23.5871244, 35.2365612),
  Coordinate(23.5871046, 35.2363071),
  Coordinate(23.5872836, 35.2362896),
  Coordinate(23.5876918, 35.236194),
  Coordinate(23.5881269, 35.2361497),
  Coordinate(23.5884396, 35.2361497),
  Coordinate(23.5889483, 35.2361253),
  Coordinate(23.5893616, 35.2360674),
  Coordinate(23.5896825, 35.2359986),
  Coordinate(23.5899627, 35.2359118),
  Coordinate(23.5902508, 35.2359387),
  Coordinate(23.5904984, 35.2360452),
  Coordinate(23.5906973, 35.2362285),
  Coordinate(23.5908016, 35.2363373),
  Coordinate(23.5910603, 35.2363013),
  Coordinate(23.5912041, 35.2362693),
  Coordinate(23.5915046, 35.2362061),
  Coordinate(23.591805, 35.236108),
  Coordinate(23.5920624, 35.2360798),
  Coordinate(23.5921489, 35.2360076),
  Coordinate(23.5921997, 35.2360379),
  Coordinate(23.5923826, 35.2359567),
  Coordinate(23.5925005, 35.2358967),
  Coordinate(23.5926633, 35.2360169),
  Coordinate(23.5930668, 35.236108),
  Coordinate(23.5931784, 35.2361219),
  Coordinate(23.5932212, 35.2361782),
  Coordinate(23.5935302, 35.2362972),
  Coordinate(23.5941911, 35.2364025),
  Coordinate(23.5945686, 35.2365006),
  Coordinate(23.5948862, 35.2365988),
  Coordinate(23.5950123, 35.2367942),
  Coordinate(23.5952675, 35.2368372),
  Coordinate(23.5956423, 35.2368502),
  Coordinate(23.5959755, 35.2368471),
  Coordinate(23.5961932, 35.2368929),
  Coordinate(23.596543, 35.2370047),
  Coordinate(23.5967621, 35.2371119),
  Coordinate(23.5969336, 35.2371496),
  Coordinate(23.5971462, 35.2370952),
  Coordinate(23.597854, 35.2368031),
  Coordinate(23.5982615, 35.2367465),
  Coordinate(23.5986055, 35.2366321),
  Coordinate(23.5995346, 35.2361558),
  Coordinate(23.5997192, 35.2361497),
  Coordinate(23.6000424, 35.2361812),
  Coordinate(23.6002577, 35.2361057),
  Coordinate(23.6005578, 35.2360648),
  Coordinate(23.6009694, 35.2361182),
  Coordinate(23.6012149, 35.2361007),
  Coordinate(23.6014062, 35.236062),
  Coordinate(23.6017925, 35.2359927),
  Coordinate(23.6021325, 35.2359659),
  Coordinate(23.6027717, 35.236488),
  Coordinate(23.6031023, 35.2372801),
  Coordinate(23.6036129, 35.2376271),
  Coordinate(23.6043367, 35.2370102),
  Coordinate(23.6082207, 35.2348188),
  Coordinate(23.6102884, 35.2336614),
  Coordinate(23.6115725, 35.2352441),
  Coordinate(23.6131362, 35.2350371),
  Coordinate(23.6143913, 35.2356453),
  Coordinate(23.6146351, 35.2356829),
  Coordinate(23.6148739, 35.2356594),
  Coordinate(23.6155379, 35.2354808),
  Coordinate(23.6157, 35.2353655),
  Coordinate(23.6161833, 35.2343692),
  Coordinate(23.6161431, 35.2340218),
  Coordinate(23.6162385, 35.2336193),
  Coordinate(23.616377, 35.233425),
  Coordinate(23.6165981, 35.2333142),
  Coordinate(23.6174976, 35.233273),
  Coordinate(23.6181412, 35.2334677),
  Coordinate(23.6185798, 35.2335696),
  Coordinate(23.6220816, 35.2341867),
  Coordinate(23.6222898, 35.2342193),
  Coordinate(23.6248813, 35.2346255),
  Coordinate(23.624932, 35.2345765),
  Coordinate(23.6250879, 35.2345642),
  Coordinate(23.6254787, 35.2346804),
  Coordinate(23.6259743, 35.2347723),
  Coordinate(23.6262848, 35.2347402),
  Coordinate(23.6264292, 35.2346724),
  Coordinate(23.6265354, 35.2345961),
  Coordinate(23.6266752, 35.2344962),
  Coordinate(23.6270383, 35.2342276),
  Coordinate(23.6275591, 35.2339769),
  Coordinate(23.6276224, 35.2339354),
  Coordinate(23.6276908, 35.233794),
  Coordinate(23.6277053, 35.2335943),
  Coordinate(23.6277405, 35.2333442),
  Coordinate(23.6279458, 35.233209),
  Coordinate(23.6282624, 35.233076),
  Coordinate(23.6286981, 35.2329744),
  Coordinate(23.6290171, 35.2329348),
  Coordinate(23.6292749, 35.2329348),
  Coordinate(23.6297894, 35.2330396),
  Coordinate(23.630247, 35.2333602),
  Coordinate(23.6305153, 35.2335539),
  Coordinate(23.6301467, 35.2338326),
  Coordinate(23.6300358, 35.2339462),
  Coordinate(23.6299948, 35.234047),
  Coordinate(23.6301753, 35.2346851),
  Coordinate(23.6302798, 35.2348309),
  Coordinate(23.630147567097623, 35.2348388353423),
  Coordinate(23.6301535, 35.2349377),
];
