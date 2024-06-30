{ unstable, lib, pkgs, inputs, config, ... }:
{
  programs.firefox.enable = true;
  
  # TODO: Switch to policies
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions =  with inputs.firefox-addons.packages.${pkgs.system}; [
      ublock-origin
      darkreader
      sponsorblock
    ];

    settings = {
      # https://ffprofile.com/#form6
      # https://wiki.mozilla.org/Privacy/Privacy_Task_Force/firefox_about_config_privacy_tweeks
      # https://www.privacytools.io/

      # Other
      "general.useragent.override" = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36";
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","addon_darkreader_org-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","addon_darkreader_org-browser-action","sponsorblocker_ajay_app-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":20,"newElementCount":3}'';
      "media.eme.enabled" = true;
      "browser.tabs.warnOnClose" = true;
      "beacon.enabled" = false;
      "browser.disableResetPrompt" = true;
      "browser.fixup.alternate.enabled" = false;
      "browser.send_pings" = false;
      "network.IDN_show_punycode" = true;
      "extensions.autoDisableScopes" = 0;

      # Cookies and history
      "browser.sessionstore.privacy_level" = 0;
      "privacy.sanitize.sanitizeOnShutdown" = false;

      # Enable DoH
      "network.trr.mode" = 3; # Strict DoH
      "network.trr.uri" = "https://dns.quad9.net/dns-query";

      # Disable Pocket
      "extensions.pocket.enabled" = false;
      "extensions.pocket.api" = "";
      "extensions.pocket.bffApi" = "";
      "extensions.pocket.showHome" = false;
      "browser.urlbar.suggest.pocket" = false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

      /** INDEX
       * the file is organized in categories, and each one has a number of sections:
       * 
       * PRIVACY [ISOLATION, SANITIZING, CACHE AND STORAGE, HISTORY AND SESSION RESTORE, QUERY STRIPPING]
       * NETWORKING [HTTPS, REFERERS, WEBRTC, PROXY, DNS, PREFETCHING AND SPECULATIVE CONNECTIONS]
       * FINGERPRINTING [RFP, WEBGL]
       * SECURITY [SITE ISOLATION, CERTIFICATES, TLS/SSL, PERMISSIONS, SAFE BROWSING, OTHERS]
       * REGION [LOCATION, LANGUAGE]
       * BEHAVIOR [DRM, SEARCH AND URLBAR, DOWNLOADS, AUTOPLAY, POP-UPS AND WINDOWS, MOUSE]
       * EXTENSIONS [USER INSTALLED, SYSTEM, EXTENSION FIREWALL]
       * BUILT-IN FEATURES [UPDATER, SYNC, LOCKWISE, CONTAINERS, DEVTOOLS, SHOPPING, OTHERS]
       * UI [BRANDING, HANDLERS, FIRST LAUNCH, NEW TAB PAGE, ABOUT, RECOMMENDED]
       * TELEMETRY
       * WINDOWS [UPDATES, OTHERS]
       */

      /** [CATEGORY] PRIVACY */
      /** [SECTION] ISOLATION
       * default to strict mode, which includes:
       * 1. dFPI for both normal and private windows
       * 2. strict blocking lists for trackers
       * 3. shims to avoid breakage caused by blocking lists
       * 4. stricter policies for xorigin referrers
       * 5. dFPI specific cookie cleaning mechanism
       * 6. query stripping
       * 
       * the desired category must be set with pref() otherwise it won't stick.
       * the UI that allows to change mode manually is hidden.
       */
      "browser.contentblocking.category" = "strict";
      
      # enable APS
      "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
      "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;

      /** [SECTION] SANITIZING 
      * all the cleaning prefs true by default except for siteSetting and offlineApps,
      * which is what we want. users should set manual exceptions in the UI if there
      * are cookies they want to keep.
      */
      "privacy.clearOnShutdown.offlineApps" = true;
      # DISABLED: "privacy.sanitize.sanitizeOnShutdown" = true;
      "privacy.sanitize.timeSpan" = 0;

      /** [SECTION] CACHE AND STORAGE */
      "browser.cache.disk.enable" = false; # disable disk cache
      
      /** prevent media cache from being written to disk in pb, but increase max cache size to avoid playback issues */
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "media.memory_cache_max_size" = 65536;
      "browser.shell.shortcutFavicons" = false; # disable favicons in profile folder
      "browser.helperApps.deleteTempFileOnExit" = true; # delete temporary files opened with external apps

      /** [SECTION] HISTORY AND SESSION RESTORE
      * since we hide the UI for modes other than custom we want to reset it for
      * everyone. same thing for always on PB mode.
      */
      "privacy.history.custom" = true;
      "browser.privatebrowsing.autostart" = false;
      "browser.formfill.enable" = false; # disable form history
      # DISABLED: "browser.sessionstore.privacy_level" = 2; # prevent websites from storing session data like cookies and forms

      /** [SECTION] QUERY STRIPPING
      * currently we set the same query stripping list that brave uses:
      * https://github.com/brave/brave-core/blob/f337a47cf84211807035581a9f609853752a32fb/browser/net/brave_site_hacks_network_delegate_helper.cc#L29
      */
      "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";

      /** [SECTION] LOGGING
      * these prefs are off by default in the official Mozilla builds,
      * so it only makes sense that we also disable them.
      * See https://gitlab.com/librewolf-community/settings/-/issues/240
      */
      "browser.dom.window.dump.enabled" = false;
      "devtools.console.stdout.chrome" = false;

      /** [CATEGORY] NETWORKING */
      /** [SECTION] HTTPS */
      "dom.security.https_only_mode" = true; # only allow https in all windows, including private browsing
      "network.auth.subresource-http-auth-allow" = 1; # block HTTP authentication credential dialogs

      /** [SECTION] REFERERS
      * to enhance privacy but keep a certain level of usability we trim cross-origin
      * referers to only send scheme, host and port, instead of completely avoid sending them.
      * as a general rule, the behavior of referes which are not cross-origin should not
      * be changed.
      */
      "network.http.referer.XOriginTrimmingPolicy" = 2;

      /** [SECTION] WEBRTC
      * there is no point in disabling webrtc as mDNS protects the private IP on linux, osx and win10+.
      * the private IP address is only used in trusted environments, eg. allowed camera and mic access.
      */
      "media.peerconnection.ice.default_address_only" = true; # use a single interface for ICE candidates, the vpn one when a vpn is used

      /** [SECTION] PROXY */
      "network.gio.supported-protocols" = ""; # disable gio as it could bypass proxy
      "network.file.disable_unc_paths" = true; # hidden, disable using uniform naming convention to prevent proxy bypass
      "network.proxy.socks_remote_dns" = true; # forces dns query through the proxy when using one
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true; # force webrtc inside proxy when one is used

      /** [SECTION] DNS */
      "network.dns.disablePrefetch" = true; # disable dns prefetching
      "network.dns.skipTRR-when-parental-control-enabled" = false;  # Arkenfox user.js v117
      "doh-rollout.provider-list" = ''[{"UIName":"Mozilla Cloudflare","uri":"https://mozilla.cloudflare-dns.com/dns-query"},{"UIName":"Quad9","uri":"https://dns.quad9.net/dns-query"},{"UIName":"Quad9+ECS","uri":"https://dns11.quad9.net/dns-query"}]'';

      /** [SECTION] PREFETCHING AND SPECULATIVE CONNECTIONS
      * disable prefecthing for different things such as links, bookmarks and predictions.
      */
      "network.predictor.enabled" = false;
      "network.prefetch-next" = false;
      "network.http.speculative-parallel-limit" = 0;
      "browser.places.speculativeConnect.enabled" = false;
      # disable speculative connections and domain guessing from the urlbar
      "browser.urlbar.speculativeConnect.enabled" = false;

      /** [CATEGORY] FINGERPRINTING */
      /** [SECTION] RFP
      * librewolf should stick to RFP for fingerprinting. we should not set prefs that interfere with it
      * and disabling API for no good reason will be counter productive, so it should also be avoided.  
      */
      "privacy.resistFingerprinting" = false;

      # rfp related settings
      "privacy.resistFingerprinting.block_mozAddonManager" = true; # prevents rfp from breaking AMO
      "browser.display.use_system_colors" = false; # default, except Win
      
      /**
      * increase the size of new RFP windows for better usability, while still using a rounded value.
      * if the screen resolution is lower it will stretch to the biggest possible rounded value.
      * also, expose hidden letterboxing pref but do not enable it for now.
      */
      "privacy.window.maxInnerWidth" = 1600;
      "privacy.window.maxInnerHeight" = 900;
      "privacy.resistFingerprinting.letterboxing" = false;

      # this ensures there is no rounding error when computing the window size, see #1569.
      "browser.toolbars.bookmarks.visibility" = "always";

      /** [SECTION] WEBGL */
      "webgl.disabled" = true;

      /** [CATEGORY] SECURITY */
      /** [SECTION] CERTIFICATES */
      "security.cert_pinning.enforcement_leveld" = 2; # enable strict public key pinning, might cause issues with AVs
      
      /**
       * enable safe negotiation and show warning when it is not supported. might cause breakage
       * if the the server does not support RFC 5746, in tha case SSL_ERROR_UNSAFE_NEGOTIATION
       * will be shown.
       */
      "security.ssl.require_safe_negotiationd" = true;
      "security.ssl.treat_unsafe_negotiation_as_brokend" = true;
      
      /**
       * our strategy with revocation is to perform all possible checks with CRL, but when a cert
       * cannot be checked with it we use OCSP stapled with hard-fail, to still keep privacy and
       * increase security.
       * crlite is in mode 3 by default, which allows us to detect false positive with OCSP.
       * in v103, when crlite is fully mature, it will switch to mode 2 and no longer double-check.
       */
      "security.remote_settings.crlite_filters.enabledd" = true;
      "security.OCSP.required" = true; # set to hard-fail, might cause SEC_ERROR_OCSP_SERVER_ERROR

      /** [SECTION] TLS/SSL */
      "security.tls.enable_0rtt_datad" = false; # disable 0 RTT to improve tls 1.3 security
      "security.tls.version.enable-deprecatedd" = false; # make TLS downgrades session only by enforcing it with pref(), default
      "browser.xul.error_pages.expert_bad_certd" = true; # show relevant and advanced issues on warnings and error screens

      /** [SECTION] PERMISSIONS */
      "permissions.delegation.enabledd" = false; # force permission request to show real origin
      "permissions.manager.defaultsUrld" = ""; # revoke special permissions for some mozilla domains

      /** [SECTION] SAFE BROWSING
       * disable safe browsing, including the fetch of updates. reverting the 7 prefs below
       * allows to perform local checks and to fetch updated lists from google.
       */
      "browser.safebrowsing.malware.enabledd" = false;
      "browser.safebrowsing.phishing.enabledd" = false;
      "browser.safebrowsing.blockedURIs.enabledd" = false;
      "browser.safebrowsing.provider.google4.gethashURLd" = "";
      "browser.safebrowsing.provider.google4.updateURLd" = "";
      "browser.safebrowsing.provider.google.gethashURLd" = "";
      "browser.safebrowsing.provider.google.updateURLd" = "";
      
      /**
       * disable safe browsing checks on downloads, both local and remote. the resetting prefs
       * control remote checks, while the first one is for local checks only.
       */
      "browser.safebrowsing.downloads.enabledd" = false;
      "browser.safebrowsing.downloads.remote.enabledd" = false;
      "browser.safebrowsing.downloads.remote.block_potentially_unwantedd" = false;
      "browser.safebrowsing.downloads.remote.block_uncommond" = false;
      
      # empty for defense in depth
      "browser.safebrowsing.downloads.remote.urld" = "";
      "browser.safebrowsing.provider.google4.dataSharingURLd" = "";

      /** [SECTION] OTHERS */
      "network.IDN_show_punycoded" = true; # use punycode in idn to prevent spoofing
      "pdfjs.enableScriptingd" = false; # disable js scripting in the built-in pdf reader

      /** [CATEGORY] REGION */
      /** [SECTION] LOCATION
       * replace google with mozilla as the default geolocation provide and prevent use of OS location services
       */
      "geo.provider.network.urldd" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      "geo.provider.ms-windows-locationdd" = false; # [WINDOWS]
      "geo.provider.use_corelocationdd" = false; # [MAC]
      "geo.provider.use_gpsddd" = false; # [LINUX]
      "geo.provider.use_geocluedd" = false; # [LINUX]

      /** [SECTION] LANGUAGE
       * show language as en-US for all users, regardless of their OS language and browser language.
       * both prefs must use pref() and not defaultPref to work.
       */
      "javascript.use_us_english_localedd" = true;
      "intl.accept_languagesdd" = "en-US, en";

      # disable region specific updates from mozilla
      "browser.region.network.urldd" = "";
      "browser.region.update.enableddd" = false;

      /** [CATEGORY] BEHAVIOR */
      /** [SECTION] DRM */
      # DISABLED: "media.eme.enabled" = false; # master switch for drm content
      # DISABLED: "media.gmp-manager.url" = "data:text/plain,"; # prevent checks for plugin updates when drm is disabled
      
      # disable the widevine and the openh264 plugins
      "media.gmp-provider.enabled" = false;
      "media.gmp-gmpopenh264.enabled" = false;

      /** [SECTION] SEARCH AND URLBAR
       * disable search suggestion and do not update opensearch engines.
       */
      "browser.urlbar.suggest.searches" = false;
      "browser.search.suggest.enabled" = false;
      "browser.search.update" = false;
      "browser.search.separatePrivateDefault" = true; # [FF70+] # Arkenfox user.js v119
      "browser.search.separatePrivateDefault.ui.enabled" = true; # [FF71+]  # Arkenfox user.js v119
      "browser.search.serpEventTelemetry.enabled" = false;
      "browser.urlbar.suggest.mdn" = true;
      "browser.urlbar.addons.featureGate" = false;
      "browser.urlbar.mdn.featureGate" = false;
      "browser.urlbar.pocket.featureGate" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.urlbar.weather.featureGate" = false;

      # these are from Arkenfox, I decided to put them here.
      "browser.download.start_downloads_in_tmp_dir" = true; # Arkenfox user.js v118


      /**
       * the pref disables the whole feature and hide it from the ui
       * (as noted in https://bugzilla.mozilla.org/show_bug.cgi?id=1755057).
       * this also includes the best match feature, as it is part of firefox suggest.
       */
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.suggest.weather" = false; # disable weather suggestions in urlbar once they are no longer behind feature gate

      # Allows the user to add a custom search engine in the settings.
      "browser.urlbar.update2.engineAliasRefresh" = true;

      /** [SECTION] DOWNLOADS
       * user interaction should always be required for downloads, as a way to enhance security by asking
       * the user to specific a certain save location. 
       */
      "browser.download.useDownloadDir" = false;
      "browser.download.autohideButton" = false; # do not hide download button automatically
      "browser.download.manager.addToRecentDocs" = false; # do not add downloads to recents
      "browser.download.alwaysOpenPanel" = false; # do not expand toolbar menu for every download, we already have enough interaction

      /** [SECTION] AUTOPLAY
       * block autoplay unless element is right-clicked. this means background videos, videos in a different tab,
       * or media opened while other media is played will not start automatically.
       * thumbnails will not autoplay unless hovered. exceptions can be set from the UI.
       */
      "media.autoplay.default" = 5;

      /** [SECTION] POP-UPS AND WINDOWS
       * prevent scripts from resizing existing windows and opening new ones, by forcing them into
       * new tabs that can't be resized as well.
       */
      "dom.disable_window_move_resize" = true;
      "browser.link.open_newwindow" = 3;
      "browser.link.open_newwindow.restriction" = 0;

      /** [SECTION] MOUSE */
      "browser.tabs.searchclipboardfor.middleclick" = false; # prevent mouse middle click on new tab button to trigger searches or page loads

      /** Librewolf settings */
      /** [CATEGORY] BUILT-IN FEATURES */
      /** [SECTION] UPDATER
        * since we do not bake auto-updates in the browser it doesn't make sense at the moment.
        */
      "app.update.auto" = false;

      /** [SECTION] SYNC
       * this functionality is disabled by default but it can be activated in one click.
       * this pref fully controls the feature, including its ui.
       */
      "identity.fxaccounts.enabled" = false;

      /** [SECTION] LOCKWISE
       * disable the default password manager built into the browser, including its autofill
       * capabilities and formless login capture.
       */
      "signon.rememberSignons" = false;
      "signon.autofillForms" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "signon.formlessCapture.enabled" = false;

      /** [SECTION] CONTAINERS
       * enable containers and show the settings to control them in the stock ui
       */
      "privacy.userContext.enabled" = true;
      "privacy.userContext.ui.enabled" = true;

      /** [SECTION] DEVTOOLS
       * disable remote debugging.
       */
      "devtools.debugger.remote-enabled" = false; # default, but subject to branding so keep it
      "devtools.selfxss.count" = 0; # required for devtools console to work

      /** [SECTION] SHOPPING
       * disable the fakespot shopping sidebar
       */
      "browser.shopping.experience2023.enabled" = false;
      "browser.shopping.experience2023.optedIn" = 2;
      "browser.shopping.experience2023.active" = false;

      /** [SECTION] OTHERS */
      "webchannel.allowObject.urlWhitelist" = ""; # remove web channel whitelist
      "services.settings.server" = "https://%.invalid"; # set the remote settings URL (REMOTE_SETTINGS_SERVER_URL in the code)


      /** [CATEGORY] UI */
      /** [SECTION] FIRST LAUNCH
       * disable what's new and ui tour on first start and updates. the browser
       * should also not stress user about being the default one.
       */
      "browser.startup.homepage_override.mstone" = "ignore";
      "startup.homepage_override_url" = "about:blank";
      "startup.homepage_welcome_url" = "about:blank";
      "startup.homepage_welcome_url.additional" = "";
      "browser.messaging-system.whatsNewPanel.enabled" = false;
      "browser.uitour.enabled" = false;
      "browser.uitour.url" = "";
      "browser.shell.checkDefaultBrowser" = false;

      /** [SECTION] NEW TAB PAGE
       * we want NTP to display nothing but the search bar without anything distracting.
       * the three prefs below are just for minimalism and they should be easy to revert for users.
       */
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      
      # hide stories and sponsored content from Firefox Home
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      
      # disable telemetry in Firefox Home
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      
      # hide stories UI in about:preferences#home, empty highlights list
      "browser.newtabpage.activity-stream.feeds.section.topstories.options" = "{\"hidden\":true}";
      "browser.newtabpage.activity-stream.default.sites" = "";

      /** [SECTION] ABOUT
       * remove annoying ui elements from the about pages, including about:protections
       */
      "browser.contentblocking.report.lockwise.enabled" = false;
      "browser.contentblocking.report.hide_vpn_banner" = true;
      "browser.contentblocking.report.vpn.enabled" = false;
      "browser.contentblocking.report.show_mobile_app" = false;
      "browser.vpn_promo.enabled" = false;
      "browser.promo.focus.enabled" = false;
      
      # ...about:addons recommendations sections and more
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "lightweightThemes.getMoreURL" = ""; # disable button to get more themes
      
      # ...about:preferences#home
      "browser.topsites.useRemoteSetting" = false; # hide sponsored shortcuts button
      
      # ...and about:config
      "browser.aboutConfig.showWarning" = false;
      
      # hide about:preferences#moreFromMozilla
      "browser.preferences.moreFromMozilla" = false;

      /** [SECTION] RECOMMENDED
       * disable all "recommend as you browse" activity.
       */
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;

      /** [CATEGORY] TELEMETRY
       * telemetry is already disabled elsewhere and most of the stuff in here is just for redundancy.
       */
      "toolkit.telemetry.unified" = false; # master switch
      "toolkit.telemetry.enabled" = false;  # master switch
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.cachedClientID" = "";
      "toolkit.telemetry.previousBuildID" = "";
      "toolkit.telemetry.server_owner" = "";
      "toolkit.coverage.opt-out" = true; # hidden
      "toolkit.telemetry.coverage.opt-out" = true; # hidden
      "toolkit.coverage.enabled" = false;
      "toolkit.coverage.endpoint.base" = "";
      "toolkit.crashreporter.infoURL" = "";
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "security.protectionspopup.recordEventTelemetry" = false;
      "browser.ping-centre.telemetry" = false;
      
      # opt-out of normandy and studies
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "app.shield.optoutstudies.enabled" = false;
      
      # disable personalized extension recommendations
      "browser.discovery.enabled" = false;
      
      # disable crash report
      "browser.tabs.crashReporting.sendReport" = false;
      "breakpad.reportURL" = "";
      
      # disable connectivity checks
      "network.connectivity-service.enabled" = false;

      # disable captive portal
      "network.captive-portal-service.enabled" = false;
      "captivedetect.canonicalURL" = "";
    };
  };
}
