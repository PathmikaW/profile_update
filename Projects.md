Circardian

Native Alarm System (iOS & Android)
    • Architected and built a fully custom, cross-platform native alarm engine for a React Native app from the ground up — ~2,700 lines of native Java (Android) and Swift/Objective-C (iOS) across 26 files, bridged to a unified JavaScript API, replacing reliance on third-party alarm libraries.
    • Engineered Android alarm reliability using AlarmManager.setExactAndAllowWhileIdle, foreground Services, WakeLock management, and BroadcastReceivers to guarantee exact-time delivery despite Doze mode, App Standby, and OEM battery-optimization restrictions.
    • Designed a reboot-persistence system (BootReceiver + JSON-backed SharedPreferences) to automatically re-arm all active alarms after device restart, eliminating alarm loss across power cycles.
    • Built the iOS alarm subsystem on UNUserNotificationCenter/UNCalendarNotificationTrigger with custom AVAudioPlayer-based gradual volume-ramp playback and UIBackgroundModes (audio, fetch, remote-notification, processing) to maximize reliability within Apple's background-execution limits.
    • Developed a platform-agnostic JS orchestration layer normalizing divergent Android/iOS native alarm APIs into a single async interface, including day-of-week convention mapping and de-duplication/reschedule logic.
    • Implemented supporting native Android modules for overlay permissions, battery-optimization exemption, and system ringtone selection, enabling a full-screen, lock-adjacent alarm-ring experience.
    • Built a "circadian rhythm" scheduling engine that converts sunrise/sunset/civil-dawn/dusk astronomical data into dynamically computed wake, sleep, meal, exercise, and light-exposure alarms and push notifications (using Notifee).
    • Solved overlapping-alarm conflicts and background/killed-app alarm detection via AppState-driven polling and bidirectional native-to-JS event bridging (DeviceEventEmitter, NSNotificationCenter).
Subscription & Monetization (iOS/Android IAP)
    • Integrated RevenueCat to implement end-to-end in-app subscription purchasing and entitlement management across iOS StoreKit and Google Play Billing.
    • Designed a client-side regional pricing engine mapping ISO country codes to four currency/price tiers for iOS offerings, enabling geographic price parity without native store-level tier configuration.
    • Built promotional discount and win-back retention flows (percentage-based promo codes, 50%-off retention offers, complimentary trial extensions) driven by dynamically resolved RevenueCat product identifiers.
    • Architected a custom REST API integration layer to track trial windows, subscription tier, and cancellation feedback independently of store-reported entitlement state, reconciling both sources of truth client-side.
    • Implemented App Store/Play Store-compliant cancellation UX, deep-linking users to native subscription-management screens and capturing structured cancellation feedback for retention analysis.
    • Built a tiered feature-gating system controlling access to premium content across the app based on live subscription status (trial/basic/full).
ATS keyword line (optional, for skills section)
React Native, iOS, Android, Swift, Objective-C, Java, native modules, native bridging, AlarmManager, UNUserNotificationCenter, foreground services, BroadcastReceiver, background execution, RevenueCat, StoreKit, Google Play Billing, in-app purchases, Notifee, push notifications, REST API integration
A couple of notes on accuracy: I didn't include a bullet about the hardcoded RevenueCat API keys in App.js — that's a security smell, not a resume-worthy achievement, so I'd skip mentioning it (or better, fix it before it comes up in a technical interview). Also, no server-side receipt validation or webhook handling exists in this codebase, so I avoided claiming that.

---

Hutch Selfcare

Core Architecture & Application State
    • Built and maintained Hutch Selfcare, a React Native 0.76 (React 18, React Navigation 7) telecom self-care app spanning dashboard, multi-connection management, loyalty/offers, VAS, login/OTP, and parental-control (CFI) feature modules, authoring the core services layer (HTTP client, storage service, global state store).
    • Designed a centralized React Context + useReducer application state store managing session, multi-line/connection switching, loyalty tier, parental-control (CFI), and mandatory/optional force-update state without a third-party state management library.
    • Maintained third-party native module patches via patch-package (e.g., react-native-ssl-pinning) to apply upstream fixes in-repo without forking.

Security & Anti-Fraud Hardening
    • Enforced certificate/public-key pinning (react-native-ssl-pinning) with dual SHA-256 pinned certificates on every network request, unifying heterogeneous native/JS network errors into a single error contract.
    • Implemented a per-network-call device-integrity gate (jail-monkey) detecting root/jailbreak status, USB-debugging/developer mode, emulator environments, and instrumentation-hook tampering (Frida/Xposed-style), blocking API calls with user-facing messaging on failure — hardening a banking-adjacent telecom app against fraud and tampering.

Push Notifications & Native Integrations
    • Architected a dual push-notification pipeline that dynamically selects between Firebase Cloud Messaging and Huawei HMS Push Kit at runtime based on device Google/Huawei Mobile Services availability, unifying cold-start and foreground deep-link handling into a single dispatch path — solving Android push delivery across Sri Lanka's fragmented GMS/HMS device landscape.
    • Implemented a custom iOS Notification Service Extension (Swift, UNNotificationServiceExtension) to enable rich media/image push notifications, requiring a dedicated app-extension build target.

UI/UX Engineering
    • Built a custom 3D parallax promotional carousel using react-native-reanimated (interpolated rotateZ/translateY/scale transforms) to drive marketing offer popups sourced from a third-party engagement platform, with in-carousel activation CTAs.
    • Integrated QR/barcode scanning directly on react-native-vision-camera's code-scanner APIs (not a third-party QR wrapper), with URL auto-detection, and built a multi-channel in-app support launcher (WhatsApp, live chat, general support).
    • Supported i18next-based localization across English, Sinhala, and Tamil.

ATS keyword line (optional, for skills section)
React Native, React Navigation, SSL/certificate pinning, jail-monkey, Firebase Cloud Messaging, Huawei HMS Push Kit, iOS Notification Service Extension, Swift, react-native-reanimated, react-native-vision-camera, react-native-keychain, patch-package, i18next, React Context/useReducer

---

Vodafone Selfcare

React Native Version Upgrade & Release Engineering
    • Led the React Native version upgrade of Vodafone Fiji's production self-care app (net.omobio.vodafonesc) from RN 0.59.3 to 0.70.5, scaffolding New Architecture plumbing (TurboModuleManagerDelegate, MainComponentsRegistry, CMakeLists, JSI OnLoad bootstrap) alongside the existing Java bridge.
    • Rewired MainActivity/MainApplication and re-integrated third-party native Android dependencies (analytics SDK AAR, Gradle wrapper/property updates, keystore signing config) across the upgrade, and resolved a JCenter-shutdown build breakage in the Android Gradle configuration.
    • Hardened the app for production release by auditing and removing dev-only console logging across ~15 feature modules ahead of a release build, and produced multiple versioned release APK builds.
    • Diagnosed and fixed conditional-rendering display bugs in the postpaid broadband balance-info UI where empty/falsy API responses surfaced incorrect user-facing error text.
    • Performed field QA testing on production builds, reproducing and logging install/crash defects (multi-connection add flow, permission-grant flow) and data-display bugs (zero-balance display for specific test accounts).
    • Worked within a large, multi-year (2017–2024) production codebase built on Redux + Redux-Saga, React Navigation, and Firebase Analytics/Crashlytics, supporting features spanning mobile-wallet payments, ringback-tune subscriptions, and location-based services.

ATS keyword line (optional, for skills section)
React Native, New Architecture, TurboModules, Gradle, Android build engineering, Redux, Redux-Saga, Firebase Crashlytics, release engineering, keystore signing

Note on scope/accuracy: this codebase's commit history shows my direct contributions concentrated on the RN 0.59.3→0.70.5 version upgrade, New Architecture scaffolding, build/release engineering, and a handful of targeted bug fixes (Oct–Nov 2022) within a large, long-running team codebase — rather than originating the app's core features, which predate my involvement. I've kept the bullets scoped to that verified work rather than the broader "led design and development" framing.

---

SMS Firewall AI/ML Suite & FirewallBI

Platform Architecture & Delivery
    • Architected and led development of FirewallBI, a multi-tenant telecom SMS-firewall business-intelligence platform deployed across 8 on-prem operator sites (including named live references at 1,500 TPS/16.3M subscribers and 500 TPS/3.5M subscribers), evolving it from an early ELK-based analytics prototype into a productionized, containerized platform (Docker Compose, GitLab CI/CD on a self-configured Windows PowerShell runner).
    • Evaluated multiple candidate architectures before implementation (hybrid AWS RDS + on-prem ELK, fully-AWS RDS+OpenSearch+EKS, and on-prem Kubernetes ELK sized for 50k-100k writes/sec) and multiple orchestration tools (Apache Airflow piloted first, then evaluated against Prefect) before settling on Logstash's native JDBC cron scheduling for the shipped platform.
    • Evaluated Apache Superset as a cost alternative to licensed Kibana Enterprise; ultimately custom-patched Kibana's compiled JS bundles directly inside running Docker containers to strip Elastic branding and rebuild a private-registry Kibana image, avoiding both the Enterprise license and a BI-tool migration.
    • In the platform's earlier R&D phase, built a custom Erlang/OTP application with a hand-written ASN.1 codec decoding the GSMA TAP3 roaming-CDR protocol, plus Elasticsearch-aggregation-driven roaming fraud/market-share anomaly-detection scripts (Python) as a precursor to the productized alerting layer.

ELK Cluster & Security Engineering
    • Stood up a 3-node Elasticsearch 8.17 cluster with mutual TLS between all nodes and components, authoring the OpenSSL CA and per-node certificate-generation toolchain from scratch, and documented custom Kibana RBAC roles restricting Discover/ML access for non-admin users.
    • Authored a Docker-volume backup/restore toolchain and disaster-recovery runbook for the Elasticsearch data tier.

Analytics Pipelines & Reporting
    • Built 300+ Logstash JDBC pipeline configurations across 6+ operator deployments (grown from ~205 pipelines/100 indices at an earlier measured point), each executing hand-written PostgreSQL rollup queries (UNION-based minute/hourly/daily aggregation) with incremental tracking-column extraction, plus consolidated cross-operator pipelines for executive-level reporting.
    • Designed custom Kibana visualizations beyond the built-in library using hand-authored Vega/Vega-Lite specs, and translated a 35+ rule SMS-firewall rule taxonomy (anti-flood, anti-fake, content filtering, DND, quota enforcement) into human-readable BI reporting.
    • Designed a parallelized Python reconciliation framework (PostgreSQL-vs-Elasticsearch row/hash diffing with incremental per-pipeline timestamp tracking) to validate data integrity across the platform's 200+ pipelines, with Slack/email alerting on discrepancies.

A2P Grey-Route & Rule-Bypass Detection Engine
    • Built a production fraud-detection module (live SMS Firewall deployment, Orange/Moov Côte d'Ivoire) combining Caesar-cipher/base64 CDR decryption, SentenceTransformer embeddings (all-MiniLM-L6-v2) and cosine-similarity matching against a 365-day rolling unallowed-content reference table to auto-block OTP-bypass and grey-route A2P traffic, sustaining ~378 messages/sec.
    • Extended the engine with a local-LLM passive/GenAI mode (Ollama-hosted Llama 3 8B) generating new unallowed-content variants and an NLLB-200 translation model handling 20-language CDR content classification.
    • Authored a TPS-based production hardware-sizing model (2 TPS to 1,200+ TPS scaling tables, GPU-tier flagging) and a tiered data-retention redesign that cut steady-state database growth by an estimated ~90%.

Flash Call Detection / Voice Firewall
    • Delivered a flash-call fraud-detection and monetization system (presented in production detail to Reliance JIO, India) built on CAMEL/CAP signaling (A-CSI, GMSC-triggered InitialDP, ATI validation) with an inline IVR block/charge/pass decision path and an alternative SIP-native ingestion mode, backed by an Erlang signaling layer and a geo-redundant, GPU-provisioned (NVIDIA A100) dual-site deployment.
    • Layered Random Forest risk scoring, social-graph-based SIM-box-ring detection (community detection/centrality analysis), and periodic broadcast-vs-P2P campaign clustering on top of the rule-based signaling layer.
    • Separately scoped a next-phase system and ML architecture for extending this into a broader Voice Firewall fraud-detection suite (IRSF, Wangiri, CLI-spoofing, SIM-swap prevention) — an ETL-based pipeline (Apache Airflow, Apache Spark, FastAPI inference service) integrating with SS7/CAMEL signaling and existing rule-based fraud systems.

ATS keyword line (optional, for skills section)
Elasticsearch, Kibana, Logstash, ELK Stack, Docker, GitLab CI/CD, PostgreSQL, mutual TLS, RBAC, Vega, Erlang/OTP, ASN.1, SentenceTransformers, Ollama, NLLB, Apache Airflow, Apache Spark, FastAPI, SS7, CAMEL, Random Forest

Note on accuracy: the deployed FirewallBI platform's actual scheduling mechanism is Logstash's native JDBC cron scheduling, not Apache Airflow — Airflow only appears in the next-phase Voice Firewall architecture design (last bullet above), not in the productized SMS-firewall BI codebase. This section was also revised from an earlier "design contribution only" framing for Flash Call/Voice Firewall — a client-facing technical presentation to JIO describes deployed geo-redundant infrastructure and real detection metrics (~98% accuracy in a cited case study), indicating at least an initial version was built and shipped, not purely architected.

---

MDA (Dialog Mobile Device Management Platform)

    • Contributed to Dialog Axiata's Mobile Device Management (MDM) platform, a carrier-grade admin system combining a PHP Yii2 backend, a React (Material-UI, Redux-Saga) admin console, and an Erlang/OTP telecom-signaling core.
    • Worked within the platform's Equipment Identity Register (EIR) subsystem for IMEI blacklist/whitelist device blocking (stolen/counterfeit device prevention), spanning backend controllers and the React device-management UI.
    • Supported the PHP-to-Erlang RPC bridge (HTTP/JSON marshaling of module/function calls) connecting the admin platform to real-time SS7/Diameter signaling components implementing 3GPP interfaces (S6a, S6c, S13, Sh) for MME-to-EIR identity checks.
    • Contributed to device-configuration and SMS-campaign scheduling features (throttled campaign delivery via SMPP) and a custom GSM-7BIT/UTF-16 SMS segment counter for accurate billing.

ATS keyword line (optional, for skills section)
PHP, Yii2, React, Redux-Saga, Erlang/OTP, SS7, Diameter, IMEI, EIR, SMPP, MariaDB, Redis, ClickHouse

Note on accuracy: this folder has no git history, so I can't attribute specific commits to myself here — these bullets describe the platform architecture I worked within rather than claiming sole authorship of every component (particularly the Erlang/OTP signaling core, which is specialized telecom infrastructure likely owned by a dedicated team).

---

Dtel

    • Built the foundational architecture for Dtel, a React Native app for Dialog's fixed-line/home-telecom brand, establishing the app's security and infrastructure layer ahead of feature development.
    • Implemented SSL/certificate pinning against the operator's production certificate chain and a custom per-request API integrity-signing scheme (randomized request IDs, checksum generation) with a remote kill-switch that force-closes the app if backend integrity checks fail — an anti-tampering/anti-repackaging defense.
    • Configured encrypted, selective Redux persistence (redux-persist-transform-encrypt) to disk-persist only non-sensitive locale/config state, keeping session data out of unencrypted storage.
    • Set up a two-tier internationalization strategy for 6 languages (including Sinhala and Tamil), loading a minimal locale bundle at first paint and swapping in full translations post-login.
    • Wired a full Firebase observability and growth stack (Crashlytics, Performance Monitoring, Remote Config, Dynamic Links, In-App Messaging, Cloud Messaging) into the Redux store layer, and instrumented every API call with device/session telemetry (IMSI, IMEI, device model, app version) for backend fraud/analytics correlation.

ATS keyword line (optional, for skills section)
React Native, SSL/certificate pinning, Redux, Redux-Saga, redux-persist, Firebase Crashlytics, Remote Config, i18n, encrypted storage

Note on accuracy: no git history is present in this folder, so exact personal authorship can't be confirmed — this snapshot captures an early architecture/scaffolding phase (feature screens were still placeholders), so bullets focus on the security and infrastructure work actually present in the code rather than claiming finished feature delivery.

---

Payroll Slip Generation System

    • Built an end-to-end payroll slip generation and distribution desktop tool (Python, Tkinter) automating company-wide salary slip creation and email delivery, replacing a manual HR process.
    • Implemented per-employee PDF encryption (PyPDF2) with passwords algorithmically derived from each employee's NIC and date of birth, dynamically communicated to recipients in the distribution email.
    • Built a cross-file data-verification engine reconciling 5 payroll fields (EPF number, name, email, NIC, date of birth) against an HR master spreadsheet before allowing generation, including detection of ambiguous dd/mm vs. mm/dd date-entry errors and Excel serial-date/scientific-notation normalization.
    • Developed an auto-remediation module that timestamps a backup of the source workbook, locates mismatched records by EPF number, and rewrites corrected cells in place — including file-lock detection to avoid corrupting a workbook open elsewhere.
    • Built set-difference-based reconciliation to surface employees missing from the HR master, with an interactive Tkinter form to onboard them mid-run.
    • Implemented per-employee failure isolation (PDF generation vs. email delivery tracked independently), routing outputs into dated success/failure folders with a run summary, plus dual timestamped audit logs.
    • Packaged the tool as a standalone Windows executable (PyInstaller) for non-technical HR use.

ATS keyword line (optional, for skills section)
Python, Tkinter, pandas, openpyxl, ReportLab, PyPDF2, smtplib, PyInstaller, data validation, automation

---

HOPP (Hutch Web Selfcare Portal)

Core Architecture & Application Layer
    • Built HOPP, Hutch's Next.js 14 (App Router) web self-care portal, authoring core infrastructure files including the locale/auth middleware, a custom Axios wrapper class, and the API service and storage service layers (confirmed via authorship headers on the source, dated Jun–Nov 2024).
    • Designed a custom Axios wrapper (jsonGet/jsonPost/formPost/formMultiPartPost/downloadFile) with CancelToken-based request timeouts and a unified ApiError contract, and a locale-and-auth-aware middleware guarding authenticated routes (e.g., /profile) via cookie-based session checks across en/si/ta locales.
    • Implemented a React Context + useReducer global state store (auth, guest session, language, connections, payment/bill-retrieval data) with selective localStorage persistence per action type, and a quota-guarded (5MB) storage-service wrapper.
    • Built a custom backend-driven image CAPTCHA component (refresh/rotate animation) instead of relying on the third-party reCAPTCHA package present in the dependency tree.

Payment Gateway Integration
    • Integrated the FriMi payment gateway (Nations Trust Bank) end-to-end: OAuth2 client-credentials token flow, four request types (hold-and-wait, async-with-poll, status-inquiry, reversal), and an 18-scenario error-message mapping layer, alongside Visa/Mastercard/Amex/Alipay/Genie/Sampath Vishwa payment methods.

Engineering Practices
    • Enforced Conventional Commits via Husky + lint-staged + Commitlint git hooks, and configured a production build flag to automatically strip console logging.
    • Delivered under a company-wide Hybrid Git Flow branching model (master/develop/feature/QA/release/hotfix, Jira-ticket-named feature branches), released v0.1.0 to the QA environment (reloadpay.hutch.lk) under Jira epic HWHHP5.
    • Negotiated and tracked effort estimates across multiple SOW/EE revisions (final agreed scope ~543 development-equivalent days) covering login/OTP, prepaid/postpaid dashboards, tokenized bulk payment, scratch-card top-up, and CMS-driven promotional content.

ATS keyword line (optional, for skills section)
Next.js, React, TypeScript, Tailwind CSS, shadcn/ui, Radix UI, next-intl, Axios, React Context, useReducer, OAuth2, payment gateway integration, Husky, Commitlint, Git Flow

Note on accuracy: this supersedes an earlier pass where the HOPP folder available at the time contained only requirement/scope documents with no code. A later-discovered nested archive contained the actual Next.js source with your author headers on several core files, so these bullets are now code-verified rather than scope-only.

---

Bangla SMS (Robi Opt-In/Opt-Out Solution)

    • Contributed technical review and solution scoping to Robi's (Bangladesh, Axiata Group) BTRC-mandated Bangla/English SMS language-preference (Opt-In/Opt-Out) platform, reviewing the System Requirements Specification (v1.1) against the proposed architecture — Erlang core, PHP/React GUI, MariaDB 10.6 cluster, Redis, active/standby N+1 redundancy.
    • Reviewed platform scope covering 5 user-role types, bulk MSISDN/language-preference management (GUI + CSV upload), a daily D-1 dump sync to downstream systems, and real-time push/pull REST APIs (sub-100ms QoS, throttle/queue-protected) for USSD and CRM integration, sized for 200 TPS hardware / 100 TPS software capacity.
    • Bootstrapped the initial project repository, evaluating and importing an existing internal Yii2/React platform codebase (sharing the same PHP Yii2 + React architecture pattern used on the MDA platform) as a starting scaffold.

ATS keyword line (optional, for skills section)
Erlang, PHP, Yii2, React, MariaDB, Redis, REST API design, requirements review, telecom platform architecture

Note on accuracy: earlier framing of this project (based only on the initiated repo's git history — 2 days of solo commits, July 2023) undersold the actual involvement — presales/requirements documents show the SRS review happened in that same week, so the repo work was one part of a broader requirements-review engagement, not the whole of it. Still no evidence of subsequent feature-level implementation in this codebase, so bullets stay scoped to review/scoping rather than claiming a fully delivered application.

---

CMDP (Dialog CDR Disclosure Platform)

    • Contributed targeted bug fixes to CMDP, Dialog Axiata's Call Detail Record (CDR) disclosure-request platform used to manage law-enforcement/court data requests — a PHP Yii2 backend with a React (Material-UI) frontend and a Java utility module for legal PDF form generation.
    • Fixed a CDR search date-picker defect and a CDR search-type toggle bug in the request-management UI, and updated build configuration for a testbed environment.
    • Performed QA/production deployment support (React build + manual web-directory swap-and-backup across QA and Production environments) and fixed a Content-Disposition header-parsing defect affecting file-attachment downloads.

Platform context (architecture I worked within, not verified as personally authored)
    • The platform implements a full work-order/approval workflow engine (role-based approvers, request lifecycle states), OTP-based authentication with LDAP-backed login, granular per-action RBAC, encrypted CDR data at rest, and Java-based legal PDF form generation for court disclosure requests.

ATS keyword line (optional, for skills section)
PHP, Yii2, React, Material-UI, Java, LDAP, OTP authentication, RBAC, PDF generation, workflow engine

Note on accuracy: git history shows only 3 commits under my name here, all minor bug fixes/build config — bullets above are scoped to that, with the platform's broader architecture described separately as context rather than claimed as personal authorship. This project isn't in the current CV; since you mentioned adding it later, I'd suggest scoping the CV wording to "contributed to" rather than "led/architected" to stay accurate.

---

Banglalink SMSC Reporting Engineering

Report Validation & Data Engineering
    • Reverse-engineered and documented the CDR-to-report field mapping for a CSG-vendor SMSC billing/reporting platform, writing AWK-based cross-validation scripts that achieved 99.94-99.98% accuracy against raw CDR logs on a live MO Error Statistic report.
    • Root-caused and fixed multiple report-accuracy defects: a 5-minute time-bucket filter matching only the exact minute (silently dropping ~79% of boundary-spanning records), a MySQL scheduled event skipping 4 of every 12 five-minute buckets per hour, and a Customized Success Rate bug traced to an incomplete error-code allow-list (recovering ~85,000 previously-dropped records).
    • Diagnosed a 240x query-performance regression on a new schema variant, caused by 7 missing indexes; added them without foreign-key constraints (to avoid write-lock contention under high insert volume), cutting query time from 4+ minutes to ~20 seconds, and updated the schema-loader tooling so future tables ship pre-indexed.

Feature Development
    • Designed and built a new Delay Statistic reporting pipeline end-to-end — new database schema, a new MySQL scheduled-event aggregator, and a standalone Python delay processor deployed across a 4-server production cluster.
    • Added a new Data Coding Scheme (DCS) field across the CDR-processing schema and pipeline via a merged pull request, and fixed a Unique Number Counting defect caused by an incorrect column reference.
    • Catalogued SQL/logic mappings for 45+ distinct client-facing report types as part of a report-modernization initiative.

ATS keyword line (optional, for skills section)
SQL, MariaDB, MySQL, CDR processing, AWK, data validation, query performance tuning, database indexing, Python, ETL, telecom billing/reporting systems

---

RetailHub

    • Supported RetailHub, Dialog's retail/device-sales web platform, as part of a containerized "O2A" (online-to-agent) platform family alongside sibling device-sale and win-back services (Docker/Alpine images, CI-integrated container vulnerability scanning on Dialog's internal registry).

Note on accuracy: available material for this project is limited to environment/CI artifacts rather than source code or scope documents, so this entry is intentionally brief — worth expanding if a fuller RetailHub archive becomes available.
