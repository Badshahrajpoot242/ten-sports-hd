// lib/services/data_service.dart
import '../models/category_model.dart';

/// DataService - Admin-controlled data source.
/// Currently uses local data. To connect Firebase:
/// 1. Uncomment firebase_core, cloud_firestore in pubspec.yaml
/// 2. Replace _loadLocalData() with _loadFirebaseData()
/// 3. All UI code remains unchanged.
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<CategoryModel>? _cachedCategories;

  Future<List<CategoryModel>> getCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _cachedCategories = _loadLocalData();
    return _cachedCategories!;
  }

  void clearCache() => _cachedCategories = null;

  // ══════════════════════════════════════════════════════════
  // LOCAL DATA — Replace with Firebase fetch when ready
  // ══════════════════════════════════════════════════════════
  List<CategoryModel> _loadLocalData() {
    return [
      // 1. CRICKET
      CategoryModel(
        id: 'cricket',
        title: 'CRICKET',
        subtitle: 'Live Matches & Highlights',
        iconEmoji: '🏏',
        isLive: true,
        sortOrder: 1,
        subCategories: [
          SubCategoryModel(
            id: 'cricket_live',
            title: 'Live Matches',
            subtitle: 'Watch live cricket now',
            iconEmoji: '🔴',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'cricket_pak_vs_ind',
                title: 'PAK vs IND',
                subtitle: 'T20 World Cup 2024',
                iconEmoji: '🏆',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'v1',
                    title: 'PTV Sports HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                  VideoLinkModel(
                    id: 'v2',
                    title: 'GEO Super HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'cricket_sa_vs_eng',
                title: 'SA vs ENG',
                subtitle: 'Test Series - Day 2',
                iconEmoji: '🏏',
                videoLinks: [
                  VideoLinkModel(
                    id: 'v3',
                    title: 'SuperSport HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'cricket_highlights',
            title: 'Highlights',
            subtitle: 'Best moments',
            iconEmoji: '🎬',
            videoLinks: [
              VideoLinkModel(
                id: 'v_yt1',
                title: 'ICC Highlights',
                url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                type: VideoType.youtube,
                quality: 'HD',
              ),
            ],
          ),
          SubCategoryModel(
            id: 'cricket_psl',
            title: 'PSL 2024',
            subtitle: 'Pakistan Super League',
            iconEmoji: '🟢',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'psl_lahore',
                title: 'Lahore Qalandars',
                subtitle: '',
                videoLinks: [
                  VideoLinkModel(
                    id: 'v_psl1',
                    title: 'PSL Live Stream',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'psl_karachi',
                title: 'Karachi Kings',
                subtitle: '',
                videoLinks: [
                  VideoLinkModel(
                    id: 'v_psl2',
                    title: 'PSL Live Stream 2',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // 2. FOOTBALL
      CategoryModel(
        id: 'football',
        title: 'FOOTBALL',
        subtitle: 'UEFA, EPL & More',
        iconEmoji: '⚽',
        isLive: true,
        sortOrder: 2,
        subCategories: [
          SubCategoryModel(
            id: 'football_ucl',
            title: 'UEFA Champions League',
            subtitle: 'Elite European Football',
            iconEmoji: '⭐',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'ucl_semifinal',
                title: 'Semi Final',
                subtitle: 'Real Madrid vs Bayern',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vf1',
                    title: 'BeIN Sports HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'football_epl',
            title: 'English Premier League',
            subtitle: 'Top Flight English Football',
            iconEmoji: '🦁',
            subCategories: [
              SubCategoryModel(
                id: 'epl_match1',
                title: 'Manchester City vs Arsenal',
                subtitle: 'Matchday 34',
                videoLinks: [
                  VideoLinkModel(
                    id: 'vf2',
                    title: 'Sky Sports HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'football_laliga',
            title: 'La Liga',
            subtitle: 'Spanish Football',
            iconEmoji: '🇪🇸',
            videoLinks: [
              VideoLinkModel(
                id: 'vf3',
                title: 'Movistar HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 3. HOCKEY
      CategoryModel(
        id: 'hockey',
        title: 'HOCKEY',
        subtitle: 'International & Club Hockey',
        iconEmoji: '🏑',
        sortOrder: 3,
        subCategories: [
          SubCategoryModel(
            id: 'hockey_world_cup',
            title: 'Hockey World Cup',
            subtitle: 'International Championship',
            iconEmoji: '🏆',
            isLive: true,
            videoLinks: [
              VideoLinkModel(
                id: 'vh1',
                title: 'PTV Sports HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
          SubCategoryModel(
            id: 'hockey_olympics',
            title: 'Olympics Hockey',
            subtitle: 'Paris 2024',
            iconEmoji: '🥇',
            videoLinks: [
              VideoLinkModel(
                id: 'vh2',
                title: 'Olympic Channel HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'FHD',
              ),
            ],
          ),
        ],
      ),

      // 4. TENNIS
      CategoryModel(
        id: 'tennis',
        title: 'TENNIS',
        subtitle: 'Grand Slams & ATP/WTA',
        iconEmoji: '🎾',
        sortOrder: 4,
        subCategories: [
          SubCategoryModel(
            id: 'tennis_wimbledon',
            title: 'Wimbledon 2024',
            subtitle: 'Grand Slam - Grass Court',
            iconEmoji: '🏆',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'wimb_mens',
                title: "Men's Final",
                subtitle: 'Djokovic vs Alcaraz',
                videoLinks: [
                  VideoLinkModel(
                    id: 'vt1',
                    title: 'BBC Sport HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'wimb_womens',
                title: "Women's Final",
                subtitle: 'Swiatek vs Rybakina',
                videoLinks: [
                  VideoLinkModel(
                    id: 'vt2',
                    title: 'BBC Sport HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'tennis_atp',
            title: 'ATP Tour',
            subtitle: 'Men\'s Professional Circuit',
            iconEmoji: '🎯',
            videoLinks: [
              VideoLinkModel(
                id: 'vt3',
                title: 'Tennis Channel',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 5. BOXING / MMA
      CategoryModel(
        id: 'boxing',
        title: 'BOXING & MMA',
        subtitle: 'Combat Sports',
        iconEmoji: '🥊',
        sortOrder: 5,
        subCategories: [
          SubCategoryModel(
            id: 'boxing_live',
            title: 'Live Fights',
            subtitle: 'Championship Bouts',
            iconEmoji: '🔴',
            isLive: true,
            videoLinks: [
              VideoLinkModel(
                id: 'vb1',
                title: 'DAZN HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'FHD',
              ),
            ],
          ),
          SubCategoryModel(
            id: 'ufc',
            title: 'UFC',
            subtitle: 'Ultimate Fighting Championship',
            iconEmoji: '🥋',
            videoLinks: [
              VideoLinkModel(
                id: 'vu1',
                title: 'UFC Fight Pass',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 6. FORMULA 1
      CategoryModel(
        id: 'formula1',
        title: 'FORMULA 1',
        subtitle: 'F1 Racing & Motorsport',
        iconEmoji: '🏎️',
        sortOrder: 6,
        subCategories: [
          SubCategoryModel(
            id: 'f1_race',
            title: 'Race Day',
            subtitle: 'Live Grand Prix',
            iconEmoji: '🏁',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'f1_main',
                title: 'Main Race',
                subtitle: 'Monaco GP 2024',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vf1_1',
                    title: 'Sky F1 HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'f1_quali',
                title: 'Qualifying',
                subtitle: 'Q1, Q2, Q3 Sessions',
                videoLinks: [
                  VideoLinkModel(
                    id: 'vf1_2',
                    title: 'F1 TV Pro',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'f1_highlights',
            title: 'Race Highlights',
            subtitle: 'Best moments from races',
            iconEmoji: '🎬',
            videoLinks: [
              VideoLinkModel(
                id: 'vf1_h1',
                title: 'F1 Official Highlights',
                url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                type: VideoType.youtube,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 7. BASKETBALL
      CategoryModel(
        id: 'basketball',
        title: 'BASKETBALL',
        subtitle: 'NBA & International',
        iconEmoji: '🏀',
        sortOrder: 7,
        subCategories: [
          SubCategoryModel(
            id: 'nba_live',
            title: 'NBA Live',
            subtitle: 'National Basketball Association',
            iconEmoji: '🔴',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'nba_finals',
                title: 'NBA Finals',
                subtitle: 'Lakers vs Celtics',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vbb1',
                    title: 'ESPN HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'euroleague',
            title: 'EuroLeague',
            subtitle: 'European Basketball',
            iconEmoji: '🇪🇺',
            videoLinks: [
              VideoLinkModel(
                id: 'vbb2',
                title: 'Euroleague TV',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 8. SNOOKER
      CategoryModel(
        id: 'snooker',
        title: 'SNOOKER',
        subtitle: 'World Snooker Championship',
        iconEmoji: '🎱',
        sortOrder: 8,
        subCategories: [
          SubCategoryModel(
            id: 'snooker_world',
            title: 'World Championship',
            subtitle: 'Crucible Theatre Sheffield',
            iconEmoji: '🏆',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'snooker_final',
                title: 'World Final',
                subtitle: 'Ronnie O\'Sullivan vs Judd Trump',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vs1',
                    title: 'Eurosport HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                  VideoLinkModel(
                    id: 'vs2',
                    title: 'BBC Two HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'snooker_masters',
            title: 'Masters Snooker',
            subtitle: 'Alexandra Palace',
            iconEmoji: '🎯',
            videoLinks: [
              VideoLinkModel(
                id: 'vs3',
                title: 'Eurosport 2 HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 9. WOMEN'S CRICKET
      CategoryModel(
        id: 'womens_cricket',
        title: "WOMEN'S CRICKET",
        subtitle: 'ICC Women\'s Events',
        iconEmoji: '🏏',
        sortOrder: 9,
        subCategories: [
          SubCategoryModel(
            id: 'womens_t20_wc',
            title: 'ICC Women\'s T20 WC',
            subtitle: 'International Championship',
            iconEmoji: '🏆',
            isLive: true,
            subCategories: [
              SubCategoryModel(
                id: 'w_pak_aus',
                title: 'PAK Women vs AUS Women',
                subtitle: 'Super 8 Stage',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vwc1',
                    title: 'PTV Sports HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'womens_odi',
            title: 'Women\'s ODI Series',
            subtitle: 'One Day Internationals',
            iconEmoji: '🌍',
            videoLinks: [
              VideoLinkModel(
                id: 'vwc2',
                title: 'Willow TV HD',
                url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                type: VideoType.hls,
                quality: 'HD',
              ),
            ],
          ),
        ],
      ),

      // 10. LIVE TV
      CategoryModel(
        id: 'live_tv',
        title: 'LIVE SPORTS TV',
        subtitle: 'Sports Channels 24/7',
        iconEmoji: '📺',
        isLive: true,
        sortOrder: 10,
        subCategories: [
          SubCategoryModel(
            id: 'pk_channels',
            title: 'Pakistan Channels',
            subtitle: 'Local Sports Channels',
            iconEmoji: '🇵🇰',
            subCategories: [
              SubCategoryModel(
                id: 'ptv_sports',
                title: 'PTV Sports HD',
                subtitle: 'Official Pakistan Sports Channel',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vtv1',
                    title: 'PTV Sports HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'geo_super',
                title: 'GEO Super HD',
                subtitle: '24/7 Sports Coverage',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vtv2',
                    title: 'GEO Super Live',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'ten_sports',
                title: 'TEN Sports HD',
                subtitle: 'International Sports',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vtv3',
                    title: 'TEN Sports Live',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'HD',
                  ),
                ],
              ),
            ],
          ),
          SubCategoryModel(
            id: 'intl_channels',
            title: 'International Channels',
            subtitle: 'Global Sports Networks',
            iconEmoji: '🌍',
            subCategories: [
              SubCategoryModel(
                id: 'sky_sports',
                title: 'Sky Sports HD',
                subtitle: 'UK Premium Sports',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vtv4',
                    title: 'Sky Sports Main Event',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
              SubCategoryModel(
                id: 'bein_sports',
                title: 'beIN Sports HD',
                subtitle: 'Middle East Sports Giant',
                isLive: true,
                videoLinks: [
                  VideoLinkModel(
                    id: 'vtv5',
                    title: 'beIN Sports 1 HD',
                    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
                    type: VideoType.hls,
                    quality: 'FHD',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
