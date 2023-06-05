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
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.everOpened", true);
user_pref("devtools.selfxss.count", 5);
user_pref("devtools.theme.show-auto-theme-info", false);
user_pref("devtools.debugger.ui.editor-wrapping", true);
user_pref("devtools.netmonitor.persistlog", true);
user_pref("devtools.netmonitor.msg.visibleColumns", "[\"data\",\"time\"]");
user_pref("devtools.performance.recording.entries", 134217728);
user_pref("devtools.performance.recording.features", "[\"screenshots\",\"js\",\"cpu\"]");
user_pref("devtools.performance.recording.threads", "[\"GeckoMain\",\"Compositor\",\"Renderer\",\"DOM Worker\"]");
user_pref("devtools.toolbox.footer.height", 469);
user_pref("devtools.toolbox.selectedTool", "storage");
user_pref("devtools.toolbox.splitconsoleEnabled", true);
user_pref("devtools.toolsidebar-height.inspector", 350);
user_pref("devtools.toolsidebar-width.inspector", 700);
user_pref("devtools.toolsidebar-width.inspector.splitsidebar", 350);
user_pref("devtools.browserconsole.contentMessages", true);
user_pref("devtools.browserconsole.filter.css", true);
user_pref("devtools.browserconsole.filter.net", true);
user_pref("devtools.browserconsole.filter.netxhr", true);
user_pref("devtools.webconsole.filter.info", false);
user_pref("devtools.webconsole.filter.css", true);
user_pref("devtools.webconsole.filter.net", true);
user_pref("devtools.webconsole.filter.netxhr", true);
user_pref("devtools.webconsole.input.editor", true);
user_pref("devtools.webconsole.input.editorOnboarding", false);
user_pref("devtools.webconsole.persistlog", true);
user_pref("devtools.webconsole.timestampMessages", true);

/*** Extensions ***/

// Enable extensions by default in private mode
user_pref("extensions.allowPrivateBrowsingByDefault", true);

// Disable system extensions
user_pref("extensions.screenshots.disabled", true);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.pocket.enabled", false);
user_pref("extensions.pocket.oAuthConsumerKey", "blank");
user_pref("extensions.pocket.api", "blank");
user_pref("extensions.pocket.site", "blank");

// Enables some extra Extension System Logging (can reduce performance)
user_pref("extensions.logging.enabled", false);

// Disables strict compatibility, making addons compatible-by-default.
pref("extensions.strictCompatibility", false);

// Allow installing the unsigned search extensions.
user_pref("xpinstall.signatures.required", false);
user_pref("xpinstall.whitelist.required", false);
user_pref("extensions.autoDisableScopes", 0);

user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", true);
user_pref("extensions.webcompat.perform_ua_overrides", true);
user_pref("extensions.webcompat.perform_injections", true);
user_pref("extensions.webcompat.enable_shims", true);
user_pref("extensions.ui.locale.hidden", true);

// Suppress "{Extension} is Controlling New Tab!" on startup
user_pref("browser.newtab.extensionControlled", true);

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

// Don't require safe negotiation
user_pref("security.ssl.require_safe_negotiation", false);

// Disable RFP
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
user_pref("privacy.spoof_english", 2);

// Disable studies and experiments
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.first_run", false);
user_pref("messaging-system.rsexperimentloader.enabled", false);

// Send DoNotTrack
user_pref("privacy.donottrackheader.enabled", true);

// Don't send referer header cross-domain (0=always send, 1=base domain match, 2=full domain match)
user_pref("network.http.referer.XOriginPolicy", 1);

// Display true origin of permission prompts (don't allow sites to delegate to iframe/other)
user_pref("permissions.delegation.enabled", false);

// Configure Tracking Protection
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.socialtracking.block_cookies.enabled", true);

// Enable First-Party Isolation
user_pref("privacy.firstparty.isolate", true);

// Disable sending the URL of the website where a plugin crashed
user_pref("dom.ipc.plugins.reportCrashURL", false);

/*** SECURITY ***/

// Don't allow being MITM'd by Microsoft's Family Safety system
user_pref("security.family_safety.mode", 0);

// Disable DNS over HTTPS (use the system-configured resolver instead)
// 0=default, 1=reserved, 2=DoH first, 3=DoH only, 4=reserved, 5=off
user_pref("network.trr.mode", 5);

// Send DNS requests through SOCKS when SOCKS proxying is in use
user_pref("network.proxy.socks_remote_dns", true);

// Make rel=noopener implicit in certain cases
// (don't allow links to change the page they were opened from)
user_pref("dom.targetBlankNoOpener.enabled", true);

// Automatically redirect to HTTPS versions of websites
user_pref("dom.security.https_only_mode", true);

// Prevent sites from messing with window chrome, size, and position
user_pref("dom.disable_window_open_feature.close", true);
user_pref("dom.disable_window_open_feature.location", true);
user_pref("dom.disable_window_open_feature.menubar", true);
user_pref("dom.disable_window_open_feature.minimizable", true);
user_pref("dom.disable_window_open_feature.personalbar", true);
user_pref("dom.disable_window_open_feature.resizable", true);
user_pref("dom.disable_window_open_feature.status", true);
user_pref("dom.disable_window_open_feature.titlebar", true);
user_pref("dom.disable_window_open_feature.toolbar", true);
user_pref("dom.disable_window_move_resize", true);

// Disable the vibration API
user_pref("dom.vibrator.enabled", false);

// Disable the battery API
user_pref("dom.battery.enabled", false);

// Disable sending beacons and pings
user_pref("beacon.enabled", false);
user_pref("browser.send_pings", false);
user_pref("browser.send_pings.require_same_host", true);  // Require pings to at least be the same domain if enabled

/*** PRELOADING ***/

user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.prefetch-next", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("network.http.speculative-parallel-limit", 6);
user_pref("network.preload", true);
user_pref("network.predictor.enabled", true);
user_pref("network.predictor.enable-hover-on-ssl", true);
user_pref("network.predictor.enable-prefetch", true); // Modified to true
user_pref("browser.newtab.preload", true);

/*** Search ***/

// Enable location bar using search
user_pref("keyword.enabled", true);

// Decode copied URLs, containing UTF8 symbols
user_pref("browser.urlbar.decodeURLsOnCopy", true);

// Enable live search suggestions
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

// Enable calculator/unitConversion suggestions
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);

// Display the URL exactly as it was entered (don't trim slashes, remove http, etc)
user_pref("browser.urlbar.trimURLs", false);

// Show 30 URL bar suggestions (default is 10)
user_pref("browser.urlbar.maxRichResults", 30);

// Reclassify and restyle search results in the history as search suggestions
user_pref("browser.urlbar.restyleSearches", true);

// Show search suggestions after history, bookmarks, etc
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

// Show search suggestions in Private Windows
user_pref("browser.search.suggest.enabled.private", true);

// Don't suggest open tabs when typing in the URL bar
// (replaced with the TabSearch addon)
user_pref("browser.urlbar.suggest.openpage", false);

// Don't suggest popular websites just because they're popular
user_pref("browser.urlbar.usepreloadedtopurls.enabled", false);

// Disable engines/topsites suggestions
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.topsites", false);

// Disable location bar domain guessing (ie. trying x.com if x doesn't resolve)
user_pref("browser.fixup.alternate.enabled", false);
user_pref("browser.fixup.hide_user_pass", true); // Don't send user:pass to guessed domains if guessing is enabled

// Don't start loading pages before the user hits enter or clicks a link
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("network.http.speculative-parallel-limit", 0);

// Highlight all hits on search
user_pref("findbar.highlightAll", true);

// Disable sponsored searches in the URL bar
user_pref("browser.urlbar.sponsoredTopSites", false);

/*** History ***/

// custom history settings
user_pref("privacy.history.custom", true);

// increase the amount of history that is retained
user_pref("places.history.expiration.max_pages", 10000000);

/*** Sessions ***/

// Resume previous session
user_pref("browser.startup.page", 3);
user_pref("browser.startup.homepage", "about:blank");

// Write session restore data every 30 seconds (default is 15)
user_pref("browser.sessionstore.interval", 30000);

// Set number of saved closed tabs on 20
user_pref("browser.sessionstore.max_tabs_undo", 20);

// Disable Firefox to clear items on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", false);

// Keep cookies and site data on close
user_pref("network.cookie.lifetimePolicy", 0);

user_pref("browser.sessionstore.restore_tabs_lazily", true);
user_pref("browser.sessionstore.restore_on_demand", false);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", false);

/*** Media ***/

// enable DRM (Netflix, Spotify, etc)
user_pref("media.eme.enabled", true);

// enable autoplay for media (YouTube, Spotify, etc)
user_pref("media.autoplay.blocking_policy", 0);

// enable WebGL (iCloud, etc)
user_pref("webgl.disabled", false);

// disable MathML
user_pref("mathml.disabled", true);

/*** UI/UX ***/

// Make the theme work properly
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("layout.css.moz-document.content.enabled", true);
user_pref("layout.css.moz-outline-radius.enabled", true);
user_pref("browser.proton.places-tooltip.enabled", true);

// Required for icons with data URLs
user_pref("svg.context-properties.content.enabled", true);

// Eliminate the blank white window during startup
user_pref("browser.startup.blankWindow", false);
user_pref("browser.startup.preXulSkeletonUI", false);

// Enable compact mode
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 2);

// Enable "Dark Mode"
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("devtools.theme", "dark");
user_pref("reader.color_scheme", "dark");

// Faster animations
user_pref("layout.frame_rate.precise", true);

// Disable warnings
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.warnOnQuit", false);
user_pref("browser.warnOnQuitShortcut", false);
user_pref("browser.sessionstore.warnOnQuit", false);
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);

// Disable default browser warning
user_pref("browser.shell.didSkipDefaultBrowserCheckOnFirstRun", true);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.shell.defaultBrowserCheckCount", 1);

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

// Disable recommendations
user_pref("extensions.getAddons.showPane", false); // Hides the "Recommended" tab in about:addons
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("extensions.htmlaboutaddons.discover.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Disable middle-click auto-scrolling
user_pref("general.autoScroll", false);

// Smooth scrolling: https://wiki.archlinux.org/title/Firefox/Tweaks
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.lines.durationMinMS", 125);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.other.durationMaxMS", 125);
user_pref("general.smoothScroll.other.durationMinMS", 125);
user_pref("general.smoothScroll.pages.durationMaxMS", 125);
user_pref("general.smoothScroll.pages.durationMinMS", 125);
user_pref("mousewheel.min_line_scroll_amount", 30);
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", true);
user_pref("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);
user_pref("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);
user_pref("toolkit.scrollbox.horizontalScrollDistance", 6);
user_pref("toolkit.scrollbox.verticalScrollDistance", 2);

// Tabs settings
user_pref("browser.tabs.loadDivertedInBackground", true);
user_pref("browser.tabs.insertAfterCurrent", true);
user_pref("browser.ctrlTab.recentlyUsedOrder", false);

// Open new tabs on the right
user_pref("browser.tabs.insertRelatedAfterCurrent", false);

// Open bookmarks in a background tab
user_pref("browser.tabs.loadBookmarksInBackground", true);

// Unload tabs when Firefox detects the system is running on low memory
user_pref("browser.tabs.unloadOnLowMemory", true);

// Double-сlick to close tabs feature
user_pref("browser.tabs.closeTabByDblclick", true);

// The last tab does not close the browser
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Bookmarks settings
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Disable Firefox Hello
user_pref("loop.enabled", false);

// In <about:user_preferences>, hide "More from Mozilla"
// (renamed to "More from GNU" by the global renaming)
user_pref("browser.user_preferences.moreFromMozilla", false);

// Don't show the picture-in-picture toggle
// (still available on right-click or shift + right-click)
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

// When loading media, always try to load the entire file immediately
// Increase the cache size to reduce the likelihood of a huge file evicting everything else
user_pref("media.cache_readahead_limit", 86400); // amount of future media to preload (1 day in seconds)
user_pref("media.cache_resume_threshold", 86400); // resume loading when less seconds than this of future media is loaded
user_pref("media.cache_size", 1024000); // Increase on-disk media cache size to 1GB (default is 500MB)

// Disable "Firefox View" tab
user_pref("browser.tabs.firefox-view", false);

// Clear default top sites
user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.useRemoteSetting", false);

// Turn off Snippets (Updates from Mozilla and Firefox)
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);

// Unpin Top Sites search shortcuts
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);

// Hide sponsored top sites in Firefox Home screen
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Show Highlights in 4 rows
user_pref("browser.newtabpage.activity-stream.section.highlights.rows", 4);

// Disable autocopy
user_pref("clipboard.autocopy", false);

// Enable spellcheck in all text boxes
user_pref("layout.spellcheckDefault", 2);

// Avoid loading urls by mistake
user_pref("middlemouse.contentLoadURL", false);

// Disable Link to FireFox Marketplace, currently loaded with non-free "apps"
user_pref("browser.apps.URL", "");

// Turn on "Firefox Experiments" settings page
user_pref("browser.preferences.experimental", true);

// Force links to open in new tabs instead of new windows
user_pref("browser.link.open_newwindow", 3);
user_pref("browser.link.open_newwindow.restriction", 0);

// Get rid of menu bar and alt key annoyances
user_pref("ui.key.menuAccessKey", 0);
user_pref("ui.key.menuAccessKeyFocuses", false);

// PDF
user_pref("pdfjs.disabled", false);
user_pref("pdfjs.enableScripting", false);
user_pref("pdfjs.enabledCache.state", false);
user_pref("browser.helperApps.showOpenOptionForPdfJS", true);

/*** Personal ***/

// Per <https://www.boxaid.com/blog/make-firefox-faster-by-editing-the-config-file/>
user_pref("network.http.pipelining", true);
user_pref("network.http.proxy.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 8);
user_pref("network.http.max-connections", 900);
user_pref("network.http.max-persistent-connections-per-proxy", 96);
user_pref("network.http.max-persistent-connections-per-server", 32);
user_pref("nglayout.initialpaint.delay", 0);
user_pref("network.dns.disableIPv6", false);
user_pref("plugin.expose_full_path", true);

// Disable network connectivity checking
user_pref("network.connectivity-service.enabled", false);
user_pref("network.manage-offline-status", false);

// Turn off Firefox starting automatically after Windows 10 restart
user_pref("toolkit.winRegisterApplicationRestart", false);

// Enable the import of passwords as a CSV file on the about:logins page
user_pref("signon.management.page.fileImport.enabled", true);

// Turn on UI customizations sync
user_pref("services.sync.prefs.sync.browser.uiCustomization.state", true);

// Prevent bugs that would otherwise be caused by the custom scrollbars in the user-agent sheet
user_pref("layout.css.cached-scrollbar-styles.enabled", false);

// Do not select when double-clicking text the space following the text
user_pref("layout.word_select.eat_space_to_next_word", false);

// Allow stylesheets to modify trees in system pages viewed in regular tabs
user_pref("layout.css.xul-tree-pseudos.content.enabled", true);

// Allow the color-mix() CSS function
user_pref("layout.css.color-mix.enabled", true);

// Turn on lazy loading for images
user_pref("dom.dom.image-lazy-loading.enabled", true);

// Turn off protection for downloading files over insecure connections
user_pref("dom.block_download_insecure", false);

// Disable restore on crash
user_pref("browser.sessionstore.resume_from_crash", false);

// Make backspace go to the previous page
user_pref("browser.backspace_action", 0);

// Others
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
