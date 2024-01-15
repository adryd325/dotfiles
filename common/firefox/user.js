/* SOME PREFS TAKEN FROM https://gitlab.com/librewolf-community/settings/-/blob/master/librewolf.cfg */

// Color-Management
// user_pref("gfx.color_management.mode", 1);
// user_pref("gfx.color_management.enablev4", true);
// user_pref("gfx.color_management.rendering_intent", -1);
// user_pref("gfx.color_management.display_profile", "__REPLACE_ME__ICC_PROFILE_PATH__");

// idk
user_pref("browser.topsites.useRemoteSetting", false); // hide sponsored shortcuts button
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
lockPref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false); // HIDDEN
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("extensions.pocket.enabled", false);


user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);
user_pref("content.notify.interval", 100000);

/** EXPERIMENTAL ***/
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("layout.css.has-selector.enabled", true);
user_pref("dom.security.sanitizer.enabled", true);

/** GFX ***/
//user_pref("gfx.canvas.accelerated", true); // enable if using a dedicated GPU on WINDOWS
user_pref("gfx.canvas.accelerated.cache-items", 4096);
user_pref("gfx.canvas.accelerated.cache-size", 512);
user_pref("gfx.content.skia-font-cache-size", 20);

/** BROWSER CACHE ***/
user_pref("browser.cache.disk.enable", false);

/** MEDIA CACHE ***/
user_pref("media.memory_cache_max_size", 65536);
user_pref("media.cache_readahead_limit", 7200);
user_pref("media.cache_resume_threshold", 3600);

/** IMAGE CACHE ***/
user_pref("image.mem.decode_bytes_at_a_time", 32768);

/** NETWORK ***/
user_pref("network.buffer.cache.size", 262144);
user_pref("network.buffer.cache.count", 128);
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheEntries", 1000);
user_pref("network.dnsCacheExpiration", 86400);
user_pref("network.dns.max_high_priority_threads", 8);
user_pref("network.ssl_tokens_cache_capacity", 10240);

/** SPECULATIVE CONNECTIONS ***/
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.dns.disablePrefetch", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);


/** [SECTION] NEW TAB PAGE
 * we want NTP to display nothing but the search bar without anything distracting.
 * the three prefs below are just for minimalism and they should be easy to revert for users.
 */
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
// hide stories and sponsored content from Firefox Home
lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
lockPref("browser.newtabpage.activity-stream.showSponsored", false);
lockPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
// disable telemetry in Firefox Home
lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
lockPref("browser.newtabpage.activity-stream.telemetry", false);
// hide stories UI in about:preferences#home, empty highlights list
lockPref("browser.newtabpage.activity-stream.feeds.section.topstories.options", "{\"hidden\":true}");
lockPref("browser.newtabpage.activity-stream.default.sites", "");


// Theming
user_pref("browser.devedition.theme.enabled", true);
user_pref("devtools.theme", "dark");
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");
user_pref("browser.devedition.theme.showCustomizeButton", true);
user_pref("browser.tabs.drawInTitlebar", true);
user_pref("browser.uidensity", 0);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("gnomeTheme.systemIcons", false);
user_pref("gnomeTheme.hideSingleTab", true);

// Enable SVG context-propertes (GNOME Theme)
user_pref("svg.context-properties.content.enabled", true);

// Don't try fix typo'd URLs
user_pref("browser.fixup.alternate.enabled", false);

// Disable search suggestions
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.searches", false);

// No autofill or password manager
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("signon.formlessCapture.enabled", false);

// no ff acc
user_pref("identity.fxaccounts.enabled", false);

// Tracking Protection
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.resistFingerprinting", true)

// Disable SSL Stapling
user_pref("security.OCSP.enabled", 0);

// Fix emoji font
user_pref("font.name-list.emoji", "Noto Color Emoji");

// Use VAAPI for video decode (Once ready)
user_pref("media.ffmpeg.vaapi.enabled", true);
