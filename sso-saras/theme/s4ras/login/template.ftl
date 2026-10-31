<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html lang="${lang}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="dark light">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>${msg("loginTitle",(realm.displayName!'myS4RAS Portal'))}</title>
    <link rel="icon" type="image/svg+xml" href="${url.resourcesPath}/img/favicon.svg" />
    <link rel="alternate icon" type="image/x-icon" href="${url.resourcesPath}/img/favicon.ico" />

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>

    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body>
<div class="s4ras-shell">
    <div class="s4ras-dual-card">
        <!-- Visual Panel (Left side on >= 960px, hidden on < 960px) -->
        <aside class="s4ras-panel-visual" aria-hidden="true">
            <div class="s4ras-vis-top">
                <a href="https://s4ras.site" class="s4ras-vis-brand" tabindex="-1">
                    <svg class="s4ras-vis-logo" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <rect x="4" y="4" width="92" height="92" rx="22" fill="none" stroke="currentColor" stroke-width="5"/>
                        <g stroke="currentColor" stroke-width="3.2" stroke-linecap="round" opacity="0.55">
                            <line x1="40.5" y1="35" x2="58.5" y2="35"/>
                            <line x1="35" y1="40.5" x2="35" y2="58.5"/>
                            <line x1="65" y1="40.5" x2="65" y2="58.5"/>
                            <line x1="40.5" y1="65" x2="58.5" y2="65"/>
                        </g>
                        <circle cx="35" cy="35" r="9.5" fill="currentColor"/>
                        <circle cx="65" cy="35" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                        <circle cx="35" cy="65" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                        <circle cx="65" cy="65" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                    </svg>
                    <div class="s4ras-vis-brand-text">
                        <span class="s4ras-vis-title">myS4RAS</span>
                        <span class="s4ras-vis-badge">${msg("s4rasBadgeSso")!"SSO Gateway"}</span>
                    </div>
                </a>

                <a href="https://s4ras.site" class="s4ras-vis-pill" title="S4RAS Ecosystem" tabindex="-1">
                    ${msg("s4rasBackToWebsite")!"Kembali ke s4ras.site"} &rarr;
                </a>
            </div>

            <!-- Hub-and-Spoke Ecosystem Diagram (SVG) -->
            <div class="s4ras-vis-body">
                <svg class="s4ras-hub-svg" viewBox="0 0 320 220" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="S4RAS Ecosystem Hub">
                    <defs>
                        <linearGradient id="hubGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#ef4444" />
                            <stop offset="100%" stop-color="#b91c1c" />
                        </linearGradient>
                        <radialGradient id="hubGlow" cx="50%" cy="50%" r="50%">
                            <stop offset="0%" stop-color="#ef4444" stop-opacity="0.35"/>
                            <stop offset="100%" stop-color="#ef4444" stop-opacity="0"/>
                        </radialGradient>
                    </defs>

                    <!-- Spoke Connector Lines -->
                    <g class="s4ras-spoke-lines" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 4" opacity="0.3">
                        <line x1="160" y1="105" x2="65" y2="48" />
                        <line x1="160" y1="105" x2="255" y2="48" />
                        <line x1="160" y1="105" x2="65" y2="162" />
                        <line x1="160" y1="105" x2="255" y2="162" />
                    </g>

                    <!-- Spoke Animated Flow Particles (Pure SVG Animation) -->
                    <circle r="2.5" fill="#ef4444">
                        <animate attributeName="cx" values="160;65" dur="3s" repeatCount="indefinite" />
                        <animate attributeName="cy" values="105;48" dur="3s" repeatCount="indefinite" />
                        <animate attributeName="opacity" values="0;0.9;0" dur="3s" repeatCount="indefinite" />
                    </circle>
                    <circle r="2.5" fill="#ef4444">
                        <animate attributeName="cx" values="160;255" dur="3.4s" repeatCount="indefinite" />
                        <animate attributeName="cy" values="105;48" dur="3.4s" repeatCount="indefinite" />
                        <animate attributeName="opacity" values="0;0.9;0" dur="3.4s" repeatCount="indefinite" />
                    </circle>
                    <circle r="2.5" fill="#ef4444">
                        <animate attributeName="cx" values="160;65" dur="3.2s" repeatCount="indefinite" />
                        <animate attributeName="cy" values="105;162" dur="3.2s" repeatCount="indefinite" />
                        <animate attributeName="opacity" values="0;0.9;0" dur="3.2s" repeatCount="indefinite" />
                    </circle>
                    <circle r="2.5" fill="#ef4444">
                        <animate attributeName="cx" values="160;255" dur="3.6s" repeatCount="indefinite" />
                        <animate attributeName="cy" values="105;162" dur="3.6s" repeatCount="indefinite" />
                        <animate attributeName="opacity" values="0;0.9;0" dur="3.6s" repeatCount="indefinite" />
                    </circle>

                    <!-- Satellite Node 1: LMS Moodle (Top-Left) -->
                    <g class="s4ras-sat-node" transform="translate(65, 48)">
                        <circle r="22" class="s4ras-sat-bg" />
                        <!-- Graduation Cap Icon -->
                        <path d="M-10 -2 L0 -7 L10 -2 L0 3 Z M-7 0 V5 C-7 7.5 -2 9 0 9 C2 9 7 7.5 7 5 V0 M10 -1 V6" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
                        <text y="32" text-anchor="middle" class="s4ras-sat-label">${msg("s4rasHubLms")!"LMS Moodle"}</text>
                    </g>

                    <!-- Satellite Node 2: Cloud SAN (Top-Right) -->
                    <g class="s4ras-sat-node" transform="translate(255, 48)">
                        <circle r="22" class="s4ras-sat-bg" />
                        <!-- Cloud Icon -->
                        <path d="M-6 4 H6 C8.5 4 10 2.2 10 0 C10 -2 -1 -3 -3 -5 C-5 -6 -9 -4 -9 -1 C-10 -1 -11 0.5 -11 2 C-11 3.5 -8.5 4 -6 4 Z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
                        <text y="32" text-anchor="middle" class="s4ras-sat-label">${msg("s4rasHubSan")!"Cloud SAN"}</text>
                    </g>

                    <!-- Satellite Node 3: Telefoni VoIP (Bottom-Left) -->
                    <g class="s4ras-sat-node" transform="translate(65, 162)">
                        <circle r="22" class="s4ras-sat-bg" />
                        <!-- Phone Receiver Icon -->
                        <path d="M-6 -7 C-8 -5 -8 3 -3 8 C2 13 10 13 12 11 L9 8 L7 9 C5 8 2 5 1 3 L2 1 Z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
                        <text y="32" text-anchor="middle" class="s4ras-sat-label">${msg("s4rasHubVoip")!"Telefoni PBX"}</text>
                    </g>

                    <!-- Satellite Node 4: IPTV Edukasi (Bottom-Right) -->
                    <g class="s4ras-sat-node" transform="translate(255, 162)">
                        <circle r="22" class="s4ras-sat-bg" />
                        <!-- TV / Play Icon -->
                        <rect x="-9" y="-6" width="18" height="13" rx="2" fill="none" stroke="currentColor" stroke-width="1.6" />
                        <polygon points="-2,-1 3,1.5 -2,4" fill="currentColor" />
                        <path d="M-4 -9 L-1 -6 M4 -9 L1 -6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
                        <text y="32" text-anchor="middle" class="s4ras-sat-label">${msg("s4rasHubIptv")!"IPTV Edukasi"}</text>
                    </g>

                    <!-- Central Hub: S4RAS SSO Gateway -->
                    <g class="s4ras-hub-center" transform="translate(160, 105)">
                        <circle r="46" fill="url(#hubGlow)" class="s4ras-pulse-glow" />
                        <circle r="34" class="s4ras-hub-ring" />
                        <circle r="24" fill="url(#hubGradient)" class="s4ras-hub-core" />
                        <!-- Shield & Key Icon -->
                        <path d="M0 -9 L7 -5 V0 C7 5 0 9 0 9 C0 9 -7 5 -7 0 V-5 Z" fill="#ffffff" />
                        <path d="M0 -3 V1 M-1.5 2 H1.5" stroke="#dc2626" stroke-width="1.4" stroke-linecap="round" />
                        <text y="44" text-anchor="middle" class="s4ras-hub-label">${msg("s4rasHubSso")!"myS4RAS SSO"}</text>
                    </g>
                </svg>
            </div>

            <div class="s4ras-vis-bottom">
                <h2 class="s4ras-vis-tagline">${msg("s4rasVisualTagline")!"Satu Identitas untuk Semua Layanan"}</h2>
                <p class="s4ras-vis-desc">${msg("s4rasVisualDesc")!"Gerbang terpadu untuk pembelajaran daring, penyimpanan awan, telefoni VoIP, dan IPTV mandiri daerah 3T."}</p>
                <div class="s4ras-vis-indicators" aria-hidden="true">
                    <span class="s4ras-vis-dot active"></span>
                    <span class="s4ras-vis-dot"></span>
                    <span class="s4ras-vis-dot"></span>
                </div>
            </div>
        </aside>

        <!-- Form Panel (Right side on >= 960px, full-width on < 960px) -->
        <main class="s4ras-panel-form">
            <!-- Mobile Brand Header (only displayed on < 960px) -->
            <div class="s4ras-mobile-brand">
                <a href="https://s4ras.site" class="s4ras-mobile-brand-link" title="S4RAS Ecosystem">
                    <svg class="s4ras-brand-logo-svg" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <rect x="4" y="4" width="92" height="92" rx="22" fill="none" stroke="currentColor" stroke-width="5"/>
                        <g stroke="currentColor" stroke-width="3.2" stroke-linecap="round" opacity="0.55">
                            <line x1="40.5" y1="35" x2="58.5" y2="35"/>
                            <line x1="35" y1="40.5" x2="35" y2="58.5"/>
                            <line x1="65" y1="40.5" x2="65" y2="58.5"/>
                            <line x1="40.5" y1="65" x2="58.5" y2="65"/>
                        </g>
                        <circle cx="35" cy="35" r="9.5" fill="currentColor"/>
                        <circle cx="65" cy="35" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                        <circle cx="35" cy="65" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                        <circle cx="65" cy="65" r="7" fill="none" stroke="currentColor" stroke-width="3"/>
                    </svg>
                    <div class="s4ras-mobile-title-wrap">
                        <span class="s4ras-mobile-portal">myS4RAS</span>
                        <span class="s4ras-mobile-service">Portal</span>
                    </div>
                </a>
                <p class="s4ras-mobile-subtitle">${msg("loginSubTitle")!"Satu akun untuk semua layanan S4RAS"}</p>
            </div>

            <div class="s4ras-form-header">
                <h1 class="s4ras-card-title"><#nested "header"></h1>
                <p class="s4ras-card-subtitle">${msg("loginSubTitle")!"Satu akun untuk semua layanan S4RAS"}</p>
            </div>

            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="s4ras-alert s4ras-alert-${message.type}">
                    <svg class="s4ras-alert-icon" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                    </svg>
                    <span>${kcSanitize(message.summary)?no_esc}</span>
                </div>
            </#if>

            <#nested "form">

            <!-- Mobile Return to Home link (only shown on < 960px) -->
            <div class="s4ras-return-home-mobile">
                <a href="https://s4ras.site">&larr; ${msg("s4rasReturnHome")!"Kembali ke Beranda"}</a>
            </div>
        </main>
    </div>
</div>
</body>
</html>
</#macro>
