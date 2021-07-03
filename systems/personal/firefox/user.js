/* SOME PREFS TAKEN FROM https://gitlab.com/librewolf-community/settings/-/blob/master/librewolf.cfg */

// Color-Management
user_pref("gfx.color_management.mode", 1);
user_pref("gfx.color_management.enablev4", true);

// Theming
user_pref("browser.devedition.theme.enabled", true);
user_pref("devtools.theme", "dark");
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");
user_pref("browser.devedition.theme.showCustomizeButton", true);
user_pref("browser.tabs.drawInTitlebar", true);
user_pref("browser.uidensity", 0);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("gnomeTheme.systemIcons", true);
user_pref("gnomeTheme.hideSingleTab", true);

// Disable Firefox's new "Proton" theme (until firefox-gnome-theme works)
user_pref("browser.proton.contextmenus.enabled", true);
user_pref("browser.proton.doorhangers.enabled", true);
user_pref("browser.proton.enabled", true);
user_pref("browser.proton.modals.enabled", true);

// Enable SVG context-propertes (GNOME Theme)
user_pref("svg.context-properties.content.enabled", true);

// Disable Pocket
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.site", "");
user_pref("extensions.pocket.oAuthConsumerKey", "");
user_pref("extensions.pocket.api", "");

// Disable Firefox Account
user_pref("identity.fxaccounts.remote.root", "");
user_pref("identity.fxaccounts.enabled", false);
user_pref("identity.fxaccounts.auth.uri", "");
user_pref("identity.fxaccounts.remote.oauth.uri", "");
user_pref("identity.fxaccounts.remote.profile.uri", "");
user_pref("identity.fxaccounts.service.monitorLoginUrl", "");

// No Location Services pls
user_pref("geo.enabled", false);
user_pref("geo.wifi.uri", "");
user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
user_pref("geo.provider.use_corelocation", false); // [MAC]
user_pref("geo.provider.use_gpsd", false); // [LINUX]
user_pref("geo.provider.network.url", "");
user_pref("geo.provider.network.logging.enabled", false);
user_pref("geo.provider-country.network.scan", false);
user_pref("geo.provider-country.network.url", "");
user_pref("browser.search.region", "US");
user_pref("browser.search.geoip.url", "");
user_pref("browser.search.geoSpecificDefaults.url", "");

// Don't try fix typo'd URLs
user_pref("browser.fixup.alternate.enabled", false);

// Nicer new tab page
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned", "duckduckgo");
user_pref("browser.newtabpage.pinned", "[{\"url\":\"https://duckduckgo.com\",\"label\":\"@duckduckgo\",\"searchTopSite\":true}]");

// No spell check
user_pref("layout.spellcheckDefault", 0);

// Disable search suggestions
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.topsites", false);

// No autofill or password manager
user_pref("signon.autofillForms", false);
user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("signon.rememberSignons", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Tracking Protection
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("browser.contentblocking.category", "strict");

// Telemetry and annoyances
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.discovery.enabled", false);

// Disable SSL Stapling
user_pref("security.OCSP.enabled", 0);

// Disable Safe Browsing
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.provider.google4.lastupdatetime", "0");
user_pref("browser.safebrowsing.provider.google4.nextupdatetime", "9999999999999");
