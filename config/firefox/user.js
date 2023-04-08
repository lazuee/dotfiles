
/*** Devtools ***/

// disable devtools news
user_pref("devtools.whatsnew.enabled", false);
user_pref("devtools.whatsnew.feature-enabled", false);

// disable cache when devtools open
user_pref("devtools.cache.disabled", true);

// enable user agent style inspection in rule-view
user_pref("devtools.inspector.showUserAgentStyles", true);

// many spaces to use when a Tab character is displayed
user_pref("devtools.editor.tabsize", 4);

user_pref("view_source.wrap_long_lines", true);
user_pref("devtools.debugger.ui.editor-wrapping", true);

/*** Extensions ***/

// enable extensions by default in private mode
user_pref("extensions.allowPrivateBrowsingByDefault", true);

// disable system extensions
user_pref("extensions.screenshots.disabled", true);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.pocket.enabled", false);
user_pref("extensions.pocket.api"," ");
user_pref("extensions.pocket.oAuthConsumerKey", " ");
user_pref("extensions.pocket.site", " ");

// disable recommended extensions
user_pref("browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr", false);
user_pref("extensions.htmlaboutaddons.discover.enabled", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// allow installing the unsigned search extensions.
user_pref("xpinstall.signatures.required", false);
user_pref("extensions.autoDisableScopes", 0);

/*** History ***/

// custom history settings
user_pref("privacy.history.custom", true);

// increase the amount of history that is retained
user_pref("places.history.expiration.max_pages", 10000000);

/*** Media ***/

// enable DRM (Netflix, Spotify, etc)
user_pref("media.eme.enabled", true);

// enable autoplay for media (YouTube, Spotify, etc)
user_pref("media.autoplay.blocking_policy", 0);

// enable WebGL (iCloud, etc)
user_pref("webgl.disabled", false);

// disable MathML
user_pref("mathml.disabled", true);

/*** Permissions ***/

// set default permissions
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.xr", 2);

// Disable websites overriding Firefox's keyboard shortcuts
user_pref("permissions.default.shortcuts", 2);

/*** Privacy ***/

// WebRTC
user_pref("media.peerconnection.enabled", true);

// Don't reveal your internal IP when WebRTC is enabled
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.default_address_only", true);

// Set OCSP fetch failures (non-stapled) to hard-fail
user_pref("security.OCSP.require", false);

// Control when to send a cross-origin referer
user_pref("network.http.referer.XOriginPolicy", 0);

// Control the amount of cross-origin information to send
user_pref("network.http.referer.XOriginTrimmingPolicy", 0);

// Don't require safe negotiation
user_pref("security.ssl.require_safe_negotiation", false);

// Disable RFP
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
user_pref("privacy.spoof_english", 2);

// Send DoNotTrack
user_pref("privacy.donottrackheader.enabled", true);

// Reject all Third-Party cookies
user_pref("network.cookie.cookieBehavior", 1);

// Disable Referer header
user_pref("network.http.sendRefererHeader", 0);

// Configure Tracking Protection
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.socialtracking.block_cookies.enabled", true);

// Enable First-Party Isolation
user_pref("privacy.firstparty.isolate", true);

/*** PRELOADING ***/

user_pref("network.dns.disablePrefetch", false); // Modified to false
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", true); // Modified to true
user_pref("network.http.speculative-parallel-limit", 6);
user_pref("network.preload", true);
user_pref("network.predictor.enabled", true);
user_pref("network.predictor.enable-hover-on-ssl", true);
user_pref("network.predictor.enable-prefetch", true); // Modified to true
user_pref("browser.newtab.preload", true);

/*** Search ***/

// Enable location bar using search
user_pref("keyword.enabled", true);

// Enable copying unicode symbols
user_pref("browser.urlbar.decodeURLsOnCopy", true);

// Enable live search suggestions
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

// Enable calculator/unitConversion suggestions
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);

// Disable engines/topsites suggestions
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.topsites", false);

// Highlight all hits on search
user_pref("findbar.highlightAll", true);

/*** Sessions ***/

// Resume previous session
user_pref("browser.startup.page", 3);

// Disable Firefox to clear items on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

// Keep cookies and site data on close
user_pref("network.cookie.lifetimePolicy", 0);

user_pref("browser.sessionstore.restore_tabs_lazily", true);
user_pref("browser.sessionstore.restore_on_demand", false);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", false);

/*** UI/UX ***/

// Make the theme work properly
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("layout.css.moz-document.content.enabled", true);
user_pref("browser.proton.places-tooltip.enabled", true);
user_pref("browser.uidensity", 2);

// Enable "Dark Mode"
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("devtools.theme", "dark");
user_pref("reader.color_scheme", "dark");

// Disable warnings
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.warnOnQuit", false);
user_pref("browser.warnOnQuitShortcut", false);
user_pref("browser.sessionstore.warnOnQuit", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);

// Disable autocopy
user_pref("clipboard.autocopy", false);

// Disable Link to FireFox Marketplace, currently loaded with non-free "apps"
user_pref("browser.apps.URL", "");

// Disable Firefox Hello
user_pref("loop.enabled", false);

// In <about:user_preferences>, hide "More from Mozilla"
// (renamed to "More from GNU" by the global renaming)
user_pref("browser.user_preferences.moreFromMozilla", false);

// Enable spellcheck in all text boxes
user_pref("layout.spellcheckDefault", 2);

// Disable middle-click auto-scrolling
user_pref("general.autoScroll", false);

// Avoid loading urls by mistake
user_pref("middlemouse.contentLoadURL", false);

// Disable "Firefox View" tab
user_pref("browser.tabs.firefox-view", false);

// Clear default top sites
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.useRemoteSetting", false);

// Download settings
user_pref("browser.download.autohideButton", false);
user_pref("browser.download.panel.shown", true);
user_pref("browser.download.useDownloadDir", true);
user_pref("browser.download.forbid_open_with", true);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.hide_plugins_without_extensions", false);
user_pref("browser.download.open_pdf_attachments_inline", true);

// Reader settings
user_pref("reader.font_type", "serif");
user_pref("reader.content_width", 7);
user_pref("pdfjs.disabled", false);
user_pref("browser.helperApps.showOpenOptionForPdfJS", true);

// New tab settings
user_pref("browser.newtabpage.activity-stream.showTopSites",false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories",false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets",false);
user_pref("browser.newtabpage.activity-stream.disableSnippets", true);
user_user_pref("browser.newtabpage.activity-stream.tippyTop.service.endpoint", "");

// Tabs settings
user_pref("browser.tabs.loadDivertedInBackground", true);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.insertAfterCurrent", true);
user_pref("browser.tabs.unloadOnLowMemory", false);
user_pref("browser.ctrlTab.recentlyUsedOrder", false);

// Don't download ads for the newtab page
user_pref("browser.newtabpage.directory.source", "");
user_pref("browser.newtabpage.directory.ping", "");
user_pref("browser.newtabpage.introShown", true);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Default newtab page
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtab.preload", true);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.activity-stream.topSitesRows", 3);

// Disable home snippets
user_pref("browser.aboutHomeSnippets.updateUrl", "data:text/html");

// Showed "Firefox Experiments" on settings
user_pref("browser.preferences.experimental", true);

// Disable welcome page
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");

// Disable page promos
user_pref("browser.vpn_promo.enabled", false);
user_pref("browser.promo.focus.enabled", false);
user_pref("browser.promo.pin.enabled", false);

// Disable VPN/mobile promos
user_pref("browser.contentblocking.report.hide_vpn_banner", true);
user_pref("browser.contentblocking.report.mobile-ios.url", "");
user_pref("browser.contentblocking.report.mobile-android.url", "");
user_pref("browser.contentblocking.report.show_mobile_app", false);
user_pref("browser.contentblocking.report.vpn.enabled", false);
user_pref("browser.contentblocking.report.vpn.url", "");
user_pref("browser.contentblocking.report.vpn-promo.url", "");
user_pref("browser.contentblocking.report.vpn-android.url", "");
user_pref("browser.contentblocking.report.vpn-ios.url", "");
user_pref("browser.privatebrowsing.promoEnabled", false);

// Disable battery status.
user_pref("dom.battery.enabled", false);

// Disable beacons
user_pref("beacon.enabled", false);

/*** Personal ***/

// Performance settings, may introduce instability on some hardware
user_pref("gfx.webrender.all", true);
user_pref("gfx.direct2d.disabled", true);
user_pref("webgl.force-enabled", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("layers.offmainthreadcomposition.enabled", true);
user_pref("layers.offmainthreadcomposition.async-animations", true)
user_pref("html5.offmainthread", true)

// Speeding it up
user_pref("network.http.pipelining", true);
user_pref("network.http.proxy.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 10);
user_pref("nglayout.initialpaint.delay", 0);

// Disable SSDP
user_pref("browser.casting.enabled", false);

// Disable directory service
user_pref("social.directories", "");

// Don't report TLS errors to Mozilla
user_pref("security.ssl.errorReporting.enabled", false);

// Set preferred language for displaying pages
user_pref("intl.accept_languages", "en-US, en");

// Set search region
user_pref("browser.search.region", "EN");

// Enforce fallback text encoding to match Cyrillic
user_pref("intl.charset.fallback.override", "windows-1251");

// Bookmarks settings
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Disable use of WiFi region/location information
user_pref("browser.region.network.scan", false);
user_pref("browser.region.network.url", "");

// Eliminate the blank white window during startup
user_pref("browser.startup.blankWindow", false);
user_pref("browser.startup.preXulSkeletonUI", false);

// Prevent bugs that would otherwise be caused by the custom scrollbars in the user-agent sheet
user_pref("layout.css.cached-scrollbar-styles.enabled", false);

// Allow the color-mix() CSS function
user_pref("layout.css.color-mix.enabled", true);

// Get rid of menu bar and alt key annoyances
user_pref("ui.key.menuAccessKey", 0);
user_pref("ui.key.menuAccessKeyFocuses", false);

// MS Edge smooth scrolling personality (using msdPhysics) [customized by dst27]
// reddit.com/r/firefox/comments/bvfqtp/_/eppxp4p?context=3
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 250);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 1300);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 1100);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 50);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", 1.5);
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 15000);
user_pref("apz.overscroll.enabled", true);
user_pref("mousewheel.min_line_scroll_amount", 20);
user_pref("toolkit.scrollbox.horizontalScrollDistance", 4);
user_pref("toolkit.scrollbox.verticalScrollDistance", 5);

// Others
user_pref("layout.css.moz-outline-radius.enabled", true);
user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);
user_pref("content.notify.interval", 100000);
user_pref("browser.compactmode.show", true);