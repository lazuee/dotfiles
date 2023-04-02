
/**** API ****/

// disable Web Notifications
user_pref("dom.webnotifications.enabled", false);
user_pref("dom.webnotifications.serviceworker.enabled", false);

// disable Push API
user_pref("dom.push.enabled", false);
user_pref("dom.push.userAgentID", "");

// disable getUserMedia, screen sharing, audio capture, video capture
user_pref("media.navigator.enabled", false);
user_pref("media.navigator.video.enabled", false);
user_pref("media.getusermedia.screensharing.enabled", false);
user_pref("media.getusermedia.audiocapture.enabled", false);

// disable speech recognition, synthesis
user_pref("media.webspeech.synth.enabled", false);

// disable Gamepad API to prevent USB device enumeration
user_pref("dom.gamepad.enabled", false);

// disable Sensor API
user_pref("device.sensors.enabled", false);

// disable touch events
user_pref("dom.w3c_touch_events.enabled", 0);

// disable event for device such as a camera, mic, or speaker is connected or removed
user_pref("media.ondevicechange.enabled", false);

/**** Devtools ****/

// disable devtools news
user_pref("devtools.whatsnew.enabled", false);
user_pref("devtools.whatsnew.feature-enabled", false);

// disable cache when devtools open
user_pref("devtools.cache.disabled", true);

// enable user agent style inspection in rule-view
user_pref("devtools.inspector.showUserAgentStyles", true);

// many spaces to use when a Tab character is displayed
user_pref("devtools.editor.tabsize", 4);

/**** Extensions ****/

// enable extensions by default in private mode
user_pref("extensions.allowPrivateBrowsingByDefault", true);

// disable system extensions
user_pref("browser.pocket.enabled", false);
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);

// Disable recommended extensions
user_pref("browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr", false);
user_pref("extensions.htmlaboutaddons.discover.enabled", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

/**** History ****/

// custom history settings
user_pref("privacy.history.custom", true);

// increase the amount of history that is retained
user_pref("places.history.expiration.max_pages", 10000000);

/**** Media ****/

// enable DRM (Netflix, Spotify, etc)
user_pref("media.eme.enabled", true);

// enable autoplay for media (YouTube, Spotify, etc)
user_pref("media.autoplay.blocking_policy", 0);

// enable WebGL (iCloud, etc)
user_pref("webgl.disabled", false);

// disable MathML
user_pref("mathml.disabled", true);

/**** Permissions ****/

// set default permissions
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.xr", 2);

// disable websites overriding Firefox's keyboard shortcuts
user_pref("permissions.default.shortcuts", 2);

/**** Privacy ****/

// WebRTC
user_pref("media.peerconnection.enabled", true);
// Don't reveal your internal IP when WebRTC is enabled
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.default_address_only", true);

// set OCSP fetch failures (non-stapled) to hard-fail
user_pref("security.OCSP.require", false);

// control when to send a cross-origin referer
user_pref("network.http.referer.XOriginPolicy", 0);

// control the amount of cross-origin information to send
user_pref("network.http.referer.XOriginTrimmingPolicy", 0);

// dont require safe negotiation
user_pref("security.ssl.require_safe_negotiation", false);

// disable RFP
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

/**** Search ****/

// enable location bar using search
user_pref("keyword.enabled", true);

// enable copying unicode symbols
user_pref("browser.urlbar.decodeURLsOnCopy", true);

// enable live search suggestions
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

// highlight all hits on search
user_pref("findbar.highlightAll", true);

/**** Sessions ****/

// resume previous session
user_pref("browser.startup.page", 3);

// disable Firefox to clear items on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

// keep cookies and site data on close
user_pref("network.cookie.lifetimePolicy", 0);

/**** UI/UX ****/

// disable warnings
user_pref("browser.warnOnQuitShortcut", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);

// disable autocopy
user_pref("clipboard.autocopy", false);

//Disable Link to FireFox Marketplace, currently loaded with non-free "apps"
user_pref("browser.apps.URL", "");

//Disable Firefox Hello
user_pref("loop.enabled", false);

// In <about:user_preferences>, hide "More from Mozilla"
// (renamed to "More from GNU" by the global renaming)
user_pref("browser.user_preferences.moreFromMozilla", false);

// enable spellcheck in all text boxes
user_pref("layout.spellcheckDefault", 2);

// disable middle-click auto-scrolling
user_pref("general.autoScroll", false);

//Disable middle click content load
//Avoid loading urls by mistake
user_pref("middlemouse.contentLoadURL", false);

// tabs settings
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.insertAfterCurrent", true);

// disable "Firefox View" tab
user_pref("browser.tabs.firefox-view", false);

// clear default top sites
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.useRemoteSetting", false);

// download settings
user_pref("browser.download.useDownloadDir", true);
user_pref("browser.download.forbid_open_with", true);

// New tab settings
user_pref("browser.newtabpage.activity-stream.showTopSites",false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories",false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets",false);
user_pref("browser.newtabpage.activity-stream.disableSnippets", true);
user_user_pref("browser.newtabpage.activity-stream.tippyTop.service.endpoint", "");

// Don't download ads for the newtab page
user_pref("browser.newtabpage.directory.source", "");
user_pref("browser.newtabpage.directory.ping", "");
user_pref("browser.newtabpage.introShown", true);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// default newtab page
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtab.preload", true);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.activity-stream.topSitesRows", 3);

// Disable home snippets
user_pref("browser.aboutHomeSnippets.updateUrl", "data:text/html");

// showed "Firefox Experiments" on settings
user_pref("browser.preferences.experimental", true);

// disable welcome page
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");

// disable page promos
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

/**** Personal ****/

// Disable hardware acceleration
//user_pref("layers.acceleration.disabled", false);
user_pref("gfx.direct2d.disabled", true);

//Speeding it up
user_pref("network.http.pipelining", true);
user_pref("network.http.proxy.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 10);
user_pref("nglayout.initialpaint.delay", 0);

// Disable SSDP
user_pref("browser.casting.enabled", false);

//Disable directory service
user_pref("social.directories", "");

// Don't report TLS errors to Mozilla
user_pref("security.ssl.errorReporting.enabled", false);

// set preferred language for displaying pages
user_pref("intl.accept_languages", "en-US, en");

// set search region
user_pref("browser.search.region", "EN");

// enforce fallback text encoding to match Cyrillic
user_pref("intl.charset.fallback.override", "windows-1251");

// enable "Dark Mode"
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("devtools.theme", "dark");
user_pref("reader.color_scheme", "dark");

// allow userChrome.css/userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// disable warning on about:config
user_pref("browser.aboutConfig.showWarning", false);

// reader settings
user_pref("reader.font_type", "serif");
user_pref("reader.content_width", 7);

// bookmarks settings
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Disable use of WiFi region/location information
user_pref("browser.region.network.scan", false);
user_pref("browser.region.network.url", "");