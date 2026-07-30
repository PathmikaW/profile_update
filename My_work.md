# My Work — Full Breakdown (SharePoint + Project Documents mining)

Sources reviewed: `PathmikaSharepoint/Pathmika/*` and `Project Documents.zip` (~31,400 entries, only document/proposal/architecture files mined — raw CDR data, videos, logs, and credential files were skipped throughout). Cross-checked against the existing `Projects.md` (which covers hands-on mobile/code contributions with git evidence) to avoid repeating what's already written up there — entries below either extend a Projects.md project with new detail, or are **entirely new** work not yet reflected anywhere in the CV.

Legend: **[Project Work]** = hands-on delivery/engineering, **[Pre-Sales]** = proposal/RFP/EE/scoping response with no delivery evidence, **[R&D/Prototype]** = internal exploration/PoC, **[Internal Process/Leadership]** = mentorship, training, standards, org-building.

## Quick index

| # | Project | Client / Context | Type | Timeframe |
|---|---|---|---|---|
| 1 | FirewallBI — architecture/sprint detail | Panamax + Togo/CAR/Cellcom/Ncell | Project Work | 2024–2025 |
| 2 | A2P Grey-Route / Rule-Bypass Detection Engine | Orange/Moov Côte d'Ivoire | Project Work | 2025 |
| 3 | AI/ML SMS Firewall Suite (product/roadmap) | Panamax, Ncell, Togocom | Pre-Sales | 2023–2026 |
| 4 | Flash Call Detection / Voice Firewall | JIO (India), Panamax | Project Work + Pre-Sales | ~2023–2027 |
| 5 | CVM-BI Platform | Multi-region telecom group | Pre-Sales | 2025 |
| 6 | Chatbot (Haystack RAG) | Internal | R&D/Prototype | undated |
| 7 | ELK Capacity Planning & Licensing | Internal (feeds FirewallBI/CVM) | R&D/Prototype | undated |
| 8 | RH-OCR (ID document OCR) | Internal | R&D/Prototype | undated |
| 9 | Banglalink CSG SMSC Reporting Engineering | Banglalink (Bangladesh) | Project Work | Dec 2025 |
| 10 | Robi Bangla SMS Opt-In/Opt-Out | Robi (Bangladesh) | Pre-Sales | Nov 2022–Jul 2023 |
| 11 | RoamerSteering ELK Platform | Multi-operator roaming | Project Work | Feb–Mar 2023 |
| 12 | SOR — Steering of Roaming | Altan Redes (Mexico) | Pre-Sales + Project Work | Apr 2024+ |
| 13 | NWDAF-AF-SOR Integration | Mobileum (vendor) | R&D/Prototype | Jun 2023 |
| 14 | Erlang Reject-Code Effectiveness Engine | Internal roaming | R&D/Prototype | ~2023 |
| 15 | Ncell Campaign Insights / Predictive CLV | Ncell (Nepal) | Pre-Sales + R&D demo | RFP Apr 2025 |
| 16 | GOV Disaster Management AI/ML | Government client | Pre-Sales | undated |
| 17 | Apache Airflow Resource-Sizing Model | Internal tooling | R&D/Prototype | undated |
| 18 | Grameenphone CDR Search Platform | Grameenphone (Bangladesh) | Pre-Sales | undated |
| 19 | Roaming Product Suite | Ethio Telecom (Ethiopia) | Pre-Sales | undated |
| 20 | Hutch HOPP — source code + SOW/EE | Hutch (Sri Lanka) | Project Work | 2023–2024 |
| 21 | RetailHub | Dialog | Project Work (thin evidence) | undated |
| 22 | WinBack | Dialog | Project Work (thin evidence) | ~2023 |
| 23 | Dialog DF (Digital Finance / loans app) | Dialog | Project Work (thin evidence) | undated |
| 24 | CMDP — deployment & UX backlog | Dialog | Project Work (supplement) | ~2022 |
| 25 | Vodafone Selfcare — QA/test evidence | Vodafone Fiji | Project Work (supplement) | Oct 2022 |
| 26 | ISO 27001 Readiness / Git Branching Standard | Internal (Omobio-wide) | Internal Process/Leadership | undated |
| 27 | Git Training Program | Internal (Omobio-wide) | Internal Process/Leadership | undated |
| 28 | Internal AI Challenge 2025 (hackathon) | Internal (Omobio-wide) | Internal Process/Leadership | Nov 2025 |
| 29 | AI Feature Proposals (Chatbot/Health Tip/OCR Nutrition/Voice Bot) | Client-facing AI EE docs | Pre-Sales | undated |
| 31 | AIML Learnings / Omobio AI SDLC Guardian proposal | Internal | Internal Process/Leadership + R&D | undated |
| 32 | BSNL Selfcare AIML | BSNL (India) | Pre-Sales | undated |
| 33 | Bankai Digital Wallet AI (eKYC/Credit Scoring) | Bankai / MobiFin | Pre-Sales | undated |
| 34 | E-channeling Agentic Call Center | eChannelling | Pre-Sales | undated |

---

## 1. FirewallBI — deeper architecture & sprint evidence [Project Work]
*(Extends the FirewallBI entry already in Projects.md — new detail only.)*

- **Architecture options actually evaluated before build** (Sprint1 docs): hybrid AWS RDS + on-prem ELK w/ NGINX LB vs. fully-AWS (RDS + OpenSearch + EKS) vs. on-prem K8s ELK (24-node sizing: 3 master/15 data/4 ingest/2 ML, 5-broker Kafka, 50k–100k writes/sec target). Confirms **8 on-prem client sites**, each with a MariaDB "FW DB" holding 20 report summary tables, aggregated centrally over VPN.
- **Orchestration decision trail**: Apache Airflow piloted first (DAG count 4→3, XCom reduction) → evaluated against Prefect (feature-by-feature comparison) → ultimately shipped on Logstash native JDBC cron (matches the existing accuracy-note in Projects.md — this is the evidence trail behind that decision).
- **Superset vs. Kibana** evaluated for cost (avoid Kibana Enterprise license) — kept Kibana, instead **custom-patched compiled Kibana JS bundles inside running Docker containers** (`core.entry.js`, `login_page.js`, `security.chunk.*.js`, `template.js`, `newsfeed.plugin.js`, `spaces.chunk.2.js`) to strip Elastic branding/rebrand login, then committed a new image `kibana-8.17.1:v1` to a private Harbor registry — binary/bundle-level frontend patching without source access.
- **CI/CD**: GitLab Runner on Windows (PowerShell executor, `fwbi-runner`/`fwbi` tag), 2-stage pipeline (debug+deploy) SCP/SSH deploying to `/data/firewallBI`.
- **Pipeline/RBAC mechanics**: `<report_name>-<client_id>` index-naming convention, per-client Logstash pipeline folders (~20 configs/client via `pipelines.yml`), per-client ES RBAC roles vs. admin `*` role.
- **Scale growth evidence**: as of ~April 2025, **205 Logstash pipelines → ~100 ES indexes** (grew to 300+/6+ operators by later delivery) — a parallelized Python reconciliation framework (PostgreSQL vs. ES row/hash diffing, Slack/email alerts) was designed to validate this at scale.
- **Backup/DR**: two parallel strategies — bash Docker-volume tar.gz backup/restore (2-gen retention) + native Elasticsearch snapshot/restore workflow.
- **Test automation design**: planned pytest/Great-Expectations DAG validation, Selenium/Playwright Kibana RBAC UI tests, SQLAlchemy cross-DB reconciliation.
- **Real client references with scale**: Ncell (Nepal) — 1,500 TPS, 16.3M subscribers, live since 2017; Togocom (Togo) — 500 TPS, 3.5M subscribers, live since 2023, via the Panamax partner channel.
- **2025–2026 roadmap** (board-approved): Flash Call Detection completion (465 md), AI/ML Spam Detection Suite (400 md) — justified by a **Moov Togo PO making flash-call detection contractually mandatory**; 2026 backlog: AI/ML Firewall Suite integration (700 md), BI/DVS analytics (500 md), AI/ML-integrated CLV/CVM (450 md).
- **CVM-BI proposal explicitly proposed reusing this Airflow+ELK infrastructure** — direct evidence of platform reuse across product lines.

Evidence: `PathmikaSharepoint/Pathmika/Firewall-BI/Sprint1–6/*.docx` (28 files).

---

## 2. A2P Grey-Route / Rule-Bypass Detection Engine (Orange/Moov Côte d'Ivoire) [Project Work]
*(New — extends the "SMS Firewall AI/ML Suite" line in Projects.md with concrete architecture.)*

- **Pipeline**: CDR decryption (Caesar shift-3 + base64) → 5-min CSV generation → SentenceTransformer embeddings (`all-MiniLM-L6-v2`, 384-dim, CPU) → cosine-similarity vs. a 365-day rolling `unallowed_p2p_content` table → block decision.
- **Active mode**: blocks at ≥75% similarity, writes monthly-partitioned `sender_msisdn_blacklist_YYYYMM`, pushes blocks to the live Firewall GUI API.
- **Passive/GenAI mode**: local **Ollama `llama3:8b`** (Q4, ~4.7GB VRAM) generates new unallowed-content variants; **NLLB-200-distilled-600M** handles 20-language translation of non-English CDR content.
- **Measured performance**: ~378 msg/sec, ~2.6s to block 1,000 messages, ~2.67GB disk/1M records.
- **Production hardware-sizing model authored**: TPS-based formulas, scaling table 2 TPS (8 vCPU/8GB) → 1,200 TPS (112 vCPU/384GB/1×A100, "rearchitecture mandatory" flag); identified `gen_ai_inputs` as the #1 unbounded storage-growth table and designed a tiered retention policy cutting steady-state DB size ~90%; flagged missing container CPU/memory limits as a production-readiness gap.
- **Forensic investigation**: parallelized awk/shell pipelines over **20M CDR records** (21 CSV parts, ~5.4GB) to isolate OTP-like bypass content and rank suspect MSISDNs by unique-recipient fan-out (SIMBox/grey-route detection) — real production sender IDs (WAVE, CANAL+, ECOBANK, Orange Money) recovered and validated.

Evidence: `Project Documents/AIML/A2P/*`, `Project Documents/rule bypass detection/hw_guide.{docx,md}`, `Project Documents/AIML/smsfw/sms-fw-aiml-feature-IOS-2068-orangeic-moovic-issue/*` (actual Python source present).

---

## 2a. SMS Firewall AI/ML Suite — Current/Expanded Architecture [Project Work, per direct input — supersedes Section 2 above]

*(Section 2 above captures an earlier snapshot of just the OTP-bypass/grey-route module. The suite has since grown into a modular platform with several detection modules behind a single codebase and admin CMS. Recorded here per direct input, not yet cross-checked against a new evidence pull — re-verify against `Project Documents/AIML/smsfw/*` when that folder is next refreshed.)*

- **Platform**: Architected and led end-to-end development of a modular SMS Firewall AI/ML Suite exposing REST APIs (FastAPI), enabling dynamic deployment of containerized detection modules — OTP-bypass, encoded-Unicode-pattern detection, phishing-URL detection, grey-route identification, and campaign detection — all integrated into a single codebase and controlled via a unified admin CMS (Next.js), processing high-volume SMS data streams.
- **OTP-bypass / grey-route module**: as documented in Section 2 (Caesar-cipher/base64 decryption, SentenceTransformer `all-MiniLM-L6-v2` embeddings, cosine-similarity vs. rolling reference table, ~378 msg/sec). **Correction**: the semantic-embeddings approach isn't unique to this module — the encoded-Unicode-pattern detection module also layers in semantic embeddings; earlier drafts had scoped this to the OTP-bypass/grey-route module alone.
- **Phishing-URL detection module**: ensemble ML classifier (XGBoost + CatBoost) with SHAP explainability and Optuna hyperparameter tuning. **Correction**: Section 2 (and downstream CV/cover-letter drafts) had mis-attributed this XGBoost/CatBoost ensemble to the grey-route/OTP-bypass module — it belongs to the phishing-URL module.
- **GenAI subsystem**: local LLM (Google Gemma via Ollama, orchestrated with LangChain-Ollama) for content review and translation, backed by multilingual BAAI/bge-m3 embeddings (SentenceTransformers) for semantic similarity search.
- **Multilingual NLP pipeline**: FastText for 176-language identification with LLM-based translation — supersedes the earlier NLLB-200/20-language approach noted in Section 2.
- **Data layer**: MariaDB via SQLAlchemy ORM, containerized with Docker.
- Encoded-Unicode-pattern and campaign-detection modules are named per direct input; module-level implementation detail not yet documented here — fold in once evidence is pulled.

---

## 3. AI/ML SMS Firewall Suite (product/roadmap decks) [Pre-Sales]

- Client-facing pptx decks (Omobio-branded + co-branded Panamax version) pitching A2P grey-route detection, semantic content filtering, and real-time campaign detection as an add-on to the rule-based firewall.
- Cross-language filtering via Google Translate API; 2023–2025 phased roadmap (Spam Model → R&D Demo → API integration, repeated yearly).
- Board-approval requests formalize 2025–2026 investment (see Project 1's roadmap bullet).

Evidence: `Project Documents/AIML/Firewall Presentations/*.pptx`.

---

## 4. Flash Call Detection / Voice Firewall [Project Work + Pre-Sales]
*(Substantially extends the "Voice Firewall" bullet in Projects.md — this is now backed by evidence of a real, deployed product, not just a design contribution.)*

**Reframing note:** Projects.md currently frames this as "design contribution only." The JIO technical presentation describes deployed geo-redundant infrastructure and real detection metrics — this looks like at least a v1 was **built and shipped**, not purely architected. Worth revisiting that framing once this is folded into the CV.

- **Signaling architecture**: CAMEL/CAP (A-CSI, GMSC→FCD via InitialDP, 0-duration release detection, ATI validation), inline IVR (SIP 183/DTMF) for block/charge/pass decisions; alternative SIP-native ingestion mode.
- **Passive mode**: MSC/IN CDR batch ingestion + outbound-dial (OBD) verification before whitelist/blacklist.
- **Stack**: Erlang signaling layer, PHP/Python/ExtJS/Kafka app layer, MySQL+Redis, ExtJS GUI + Nagios NMS.
- **AI/ML layer**: Random Forest risk scoring, Social Graph Scoring (community detection/centrality for SIM-box rings), periodic campaign-identification clustering (broadcast vs P2P).
- **Geo-redundant, GPU-provisioned deployment**: dual-site active/standby, 100 calls/sec sizing = 2× FDC/SIGTRAN nodes + 2× AI/ML nodes each with an **NVIDIA A100 80GB**.
- **Real production results cited** (Middle East case study): ~5,159 flash-call cases detected, ~7,574 unique numbers identified, ~98% detection accuracy.
- **Full EE** (final agreed): Phase 1 (offline CDR/ML) 250 md, Phase 2 (real-time SIP/SS7) 215 md, total **465 man-days / ~6 months / 4 devs**, task-level breakdown down to individual components (CDR ETL, feature engineering, ML dev, rule engine, dashboard, SIP probes, Kafka/Flink ingestion, VPE/firewall integration).
- **Proposed stack for the AI/ML phase**: Python 3.12/Erlang, Spark/Airflow ETL, LightGBM+GNN(PyTorch Geometric)+Optuna+SMOTE, Kafka/Flink, River (online ML), FastAPI/gRPC, Postgres/Redis, Kamailio, Consul, Docker/K8s/GitHub Actions.
- **Competitive/market research compiled**: Mobileum, BICS FraudGuard, LANCK, TNS Call Guardian, iconectiv, Syniverse; Juniper Research market sizing (~128B flash calls/yr, ~$39B revenue at risk, $450M market by 2027).
- **Separate monetization product** also documented: event-based charging/IVR redirection for "free" flash-call traffic (not just fraud detection).
- **Precursor system found**: a purely rule-based Airtel passive CDR fraud engine (OBD-verification state machine, IMEI blacklist) — likely predates Pathmika's involvement, noted as prior art only.

Evidence: `PathmikaSharepoint/Pathmika/Flash Call/*` (product doc, JIO technical presentation, 3 EE versions, kickoff/board-approval decks); `Project Documents/Flashcall/{Fraud Use Cases, Passive, Drawio, Client Shared}/*`.

---

## 5. CVM-BI Platform [Pre-Sales]

- Proposed multi-region CVM+BI platform (Next Best Offer + Churn ML, 130 dashboards) for a telecom group across UK/US/Europe/Australia BSS regions.
- **Scale**: 4 regional deployments × Billing/OCS/Voucher/Dealers integration, **10M subscribers total**, 5-year TCO with L2+L3 AMC support model.
- **Explicitly proposed reusing the existing FirewallBI Airflow+ELK stack** (regional DAGs, Kibana extended with Lens/Vega/TSVB/Canvas to simulate the 130 dashboards).
- New-build: NBO (collaborative filtering/XGBoost) + Churn (Logistic Regression/RF) via MLflow; Postgres/Mongo notification-history DB + FastAPI layer (90-day retention); FNF list post-processing; "agentic BI" via Kibana scripted alerts/anomaly detection.
- Requirements-clarification analysis was self-authored by Pathmika (`CVM-REQ clarification-self.docx`).

Evidence: `PathmikaSharepoint/Pathmika/CVM/*`.

---

## 6. Chatbot (Haystack RAG) [R&D/Prototype]

- Internal engineer-support chatbot: Qdrant vector DB + Haystack (`EmbeddingRetriever` w/ `all-MiniLM-L6-v2`, `ExtractiveQAPipeline` w/ `deepset/roberta-base-squad2`) → Flask backend → React frontend, falling back to GPT-4 if no internal match.
- **Deliberate tool evaluation**: rejected Rasa (no built-in RAG); compared Haystack vs. LangChain specifically, chose Haystack for retrieval-focused (non-agentic) use case.
- Qdrant was actually stood up locally (screenshot evidence), not purely theoretical.
- Phased plan: MVP (2-3mo) → OCR/vector-search/auth (3-6mo) → analytics/fine-tuning/multilingual (6-12mo).

Evidence: `PathmikaSharepoint/Pathmika/ChatBot/*`.

---

## 7. ELK Capacity Planning & Licensing Research [R&D/Prototype]

- Original CPU/RAM sizing formulas derived from benchmarking (not just vendor docs): `C_min = 7 + 0.009×TPS`, `C_rec = 9 + 0.011×TPS` cores; `RAM_rec = max(2.0×Cores, 12 + 0.03×TPS)` GB.
- Full server-spec doc for 7,500 logs/sec CDR ingestion: 8.7TB disk (90-day retention), 32-core/128GB RAM recommendation with per-component (ES/Logstash/Filebeat/Kibana) heap breakdowns.
- Licensing cost comparison: Elastic self-hosted Platinum (~$7,200/node/yr) vs. Enterprise vs. Elastic Cloud managed, ~$7,700–$10,800/yr estimate for a 1,500 TPS single-node deployment.

Evidence: `PathmikaSharepoint/Pathmika/ELK/*`.

---

## 8. RH-OCR (ID Document OCR) [R&D/Prototype — thin]

- Small NIC/Driving-License OCR verification API prototype tested via Postman collection (base64 front/back image submission with `trace_id`/`id_type`).
- No architecture/scope docs found — too thin for strong CV bullets on its own; flagging existence only.

Evidence: `Project Documents/AIML/RH-OCR/*`.

---

## 9. Banglalink CSG SMSC Reporting Engineering [Project Work] — **entirely new, recent, high-value**

Real hands-on engineering embedded with a client team (Banglalink, Bangladesh), **Dec 10–24, 2025**, validating/building SQL report logic for a CSG-vendor SMSC billing platform. This is recent, technically dense delivery work with no current CV presence.

- **System**: CSG SMSC → plain-text Statistic CDR logs (4 servers × 2 sites) → Python `cdr_processor` CLI parses into MariaDB `tbl_cdr_event_5min` (15-column composite key) → MySQL Events (5-min cron) roll up into ~18 KPI report tables feeding the GUI.
- **Validation methodology**: reverse-engineered CDR field mapping, wrote AWK cross-check scripts achieving 99.94–99.98% accuracy on MO Error Statistic report validation. Root-caused multiple bugs:
  - 5-minute time-bucket filter only matching the exact minute (missing ~79% of records at boundaries).
  - A MySQL event silently skipping 4 of 12 five-minute buckets/hour.
  - `count` field being a weighted multi-dimension aggregate, not 1:1 with raw CDR lines (found via a 6,004-vs-11,947 discrepancy) — established success-rate % as the only valid cross-check metric.
  - Customized Success Rate bug root-caused to an incomplete error-code allow-list (~85,000 event-9 records silently dropped).
- **Performance fix**: diagnosed a 240x query slowdown on a "V2" schema variant caused by 7 missing indexes; added them (without FK constraints, to avoid write-lock contention) — 12x speedup (4+min → ~20s); patched `schema_loader.py` so future tables ship indexed by default.
- **New feature**: added a `dcs` (Data Coding Scheme) column end-to-end via GitHub PR; fixed a Unique Number Counting bug (`src_esme_ref` vs `src_scope_ref`).
- **Built the Delay Statistic Report from scratch**: new `tbl_cdr_event_delay_5min` table, new MySQL event scheduler, new standalone Python delay processor deployed across all 4 servers of Site 1.
- **Catalogued ~45+ CSG report types** (Report Types 22–65) end-to-end, mapping SQL/logic for each into a shared tracking spreadsheet.
- **AWK-based field-extraction** for Bulk Masking Wise SMS report cross-validation.

Evidence: `Project Documents/BanglalinkDocs/*` (CDR guide, final_tables_sql, Report_Type_44 investigation docs); `PathmikaSharepoint/Pathmika/Banglalink/Day 02–Day 11/*.docx`.

---

## 10. Robi Bangla SMS Opt-In/Opt-Out [Pre-Sales]
*(Corrects/extends the CV's current "Bangla SMS" framing, which is based only on a thin repo-scaffolding commit. Real documents show Pathmika's actual role was SRS technical review, matching the git-commit dates exactly.)*

- Nov 2022–Jul 2023 RFQ→Proposal→SRS→BOQ cycle for a USSD-driven Bangla/English SMS language-preference platform, mandated by Bangladesh's BTRC regulator.
- **Pathmika reviewed SRS v1.1 on 28-Jul-2023** — same week as the "2 days of solo commits" already noted in Projects.md, confirming his July 2023 involvement was SRS review, not (only) repo setup.
- **Architecture**: Erlang core, Apache+PHP GUI backend, React frontend, MariaDB 10.6 cluster, Redis, RHEL 8.6, active/standby N+1 redundancy — same architecture family as MDA/CMDP.
- **Scope**: 5 user types, GUI CRUD + bulk CSV upload, daily D-1 dump sync, real-time push/pull REST APIs (<100ms QoS, throttle+queue), reporting (daily/weekly/monthly, 6-month retention).
- **Capacity**: 200 TPS hardware / 100 TPS software, N+1 redundancy, 6-8 week delivery SLA.
- Reviewed a 947-row RFQ compliance matrix and Robi's Information Security Checklist (ISO 27001 hosting, DMZ segregation, PAM onboarding, encrypted DB, GDPR-style consent/retention).

**Recommendation:** Update the CV's "Bangla SMS" framing to reflect SRS technical review + solution scoping, not just "bootstrapped a repo."

Evidence: `Project Documents/Opt-In-Opt-Out/provided/*`, `.../updated/System Requirements Specification...docx`.

---

## 11. RoamerSteering ELK Platform [Project Work]
*(Extends existing ELK/FirewallBI entries with new, distinct engineering evidence — Feb–Mar 2023, predates the FirewallBI sprints.)*

- Built ES queries/aggregations against `ntr-index-*` (roaming registration events: GSM UL, GPRS UL, Diameter ULR), `_reindex` pipelines into purpose-built indices, and an **Elasticsearch Transform with a scripted_metric pivot** to de-duplicate/join roaming transaction fragments — a workaround for ES's lack of native joins.
- Dashboards computing steering success/reject rates by country/network/technology, cell-level rejection analysis.
- **Kibana 7.17 white-labeling**: `docker cp` in/out of running containers to replace `core.entry.js`/`logo.js`/`styles.js`/`template.js`/login chunk/favicons, including gzip/brotli recompression so Kibana serves the patched bundles.

Evidence: `Project Documents/RoamerSteering/Notes/*.txt`.

---

## 12. SOR — Steering of Roaming (Altan Redes, Mexico) [Pre-Sales + Project Work]

- Technical Proposal v1.0 (30-Apr-2024) for SS7+Diameter roaming steering (LTE/VoLTE/5G-NSA, OTA, usage/percentage-based steering, IMSI-range profiles, blacklist mgmt, real-time CDR search).
- VoLTE/5G-NSA steering logic: checks device capability + network capability + APN subscription via Diameter ULR/ULA inspection.
- N+1 redundant deployment, sized for 2,000 Update-Location req/sec.
- **Kibana white-labeling extended to v8.17.1/v9.0.0** for this platform — same technique as RoamerSteering, updated for Elastic's internal path restructuring across versions.

Evidence: `Project Documents/SOR/*`.

---

## 13. NWDAF-AF-SOR Integration (Mobileum) [R&D/Prototype]

- Architecture study integrating 3GPP-standard NWDAF (Mobileum product: DCCF/MFAF/ADRF/AnLF/MTLF) with Omobio's own AF-OmobioNG-SORA node and Steering Core Engine, via `Nnwdaf`/`Nnef`/`Nadrf`/`Nmfaf` interfaces.
- **Named use case**: predicting whether an SS7/Diameter reject code will be "effective" (roamer actually moves networks).
- Build-vs-integrate evaluation of Mobileum's stack (TimescaleDB, MLflow, React/D3.js/Grafana portal) vs. Omobio's own.
- 4 iterated joint presentation decks with detailed NF Load Analytics / UE Mobility Analytics sequence diagrams.

Evidence: `Project Documents/Data Science-Mobilium/*`.

---

## 14. Erlang Reject-Code Effectiveness Engine [R&D/Prototype]
*(A specific, previously-undocumented algorithm inside the "dvs" Erlang app already referenced in Projects.md's ELK section.)*

- Algorithm: for an IMSI's reject code RC1 on network NW1, checks whether the next Location Update within a **15-min/900s window** lands on the same network (ineffective) or a different one (effective) — tracks a running effectiveness rate per reject code.
- Implementation: **Redis as a sliding-window store** (key `"rce:" ++ IMSI`, 900s TTL) comparing successive stored network/reject-code pairs.
- Directly underpins the "roaming fraud/market-share anomaly-detection" bullet already in Projects.md's FirewallBI section — this is the specific logic behind it.

Evidence: `Project Documents/Erlang/{Scripts.txt, rc update.txt}`.

---

## 15. Ncell Campaign Insights / Predictive CLV Platform (Nepal) [Pre-Sales + R&D demo]

- 16-module ML/platform architecture responding to an RFP (`CLM__RFP_Tech_25-04-2025`): Predictive CLV, Churn Risk, Offer Recommendation, Uplift Modeling, Real-Time Usage Counters (Kafka), Dynamic/Evaluation Campaign Engines, Next-Best-Action + Social Network Analysis, Nepali-calendar localization, Dormant-User Re-engagement, App-Usage Clustering (K-Means+PCA), Behavioral Persona Detection, CLV Growth Simulator — **~1,300+ man-days** total across modules plus integration/QA/deployment overhead.
- Platform: Postgres/BigQuery/ClickHouse warehouse, Python/XGBoost/LightGBM AIML engine (Dockerized Flask/FastAPI + MLflow/DVC), separate "AdReach" campaign-execution engine (SMSC/USSD/Push/IVR delivery, ROI dashboards).
- Hardware: dedicated GPU training nodes (2× A100, HA), 3× load-balanced CPU inference nodes, InfluxDB/Druid time-series cluster.
- **Working prototype built**: synthetic 1,000-user churn dataset, scikit-learn Random Forest (80-90% accuracy), Flask `/predict` API, React+Tailwind GUI with at-risk-user table and churn-probability chart.

Evidence: `PathmikaSharepoint/Pathmika/Ncell - Campaign Insights/*`.

---

## 16. GOV Disaster Management AI/ML Alert System [Pre-Sales]

- 8-stage architecture aggregating 3 government departments + 7 third-party sources: Airflow ingestion (120 TPS peak) → Hadoop HDFS → Spark ETL → PostgreSQL → TensorFlow/MLflow AI models (daily retrain) → Drools+Django rule engine/portal → FastAPI `/alerts` → ELK monitoring.
- Full effort estimate: Business Analysis 210 md, Development 2,260 md (broken down per pipeline stage) plus a dedicated QA phase (up to 500 TPS stress testing, security/pen testing).
- Formal client clarification/assumptions document authored covering TPS targets, retraining cadence, alert-threshold ownership.

Evidence: `PathmikaSharepoint/Pathmika/GOV-Disaster mgt AIML/*`.

---

## 17. Apache Airflow Resource-Sizing Model [R&D/Prototype — internal tooling]

- Generalized closed-form sizing equations for self-hosted Airflow (CeleryExecutor+Postgres+Redis): `Scheduler RAM = 2 + 0.02·D·(60/PI)` etc., parametrized by DAG count/tasks/concurrency/RAM-per-task.
- Second model sizing an Airflow-orchestrated Oracle/Snowflake → ClickHouse/Postgres ETL pipeline, directly reusable methodology for the Grameenphone "38GB peak scan" analysis.

Evidence: `PathmikaSharepoint/Pathmika/Airflow/*`.

---

## 18. Grameenphone CDR Search Platform [Pre-Sales] — technically substantial

- Architecture proposal at extreme scale: **150 billion records (~67.5TB)**, 60+ source VMs, peak single-query scan ≈38GB.
- **Rejected ELK explicitly** for this workload (30-50% storage overhead vs. ClickHouse's ~7-10TB via columnar compression, Scroll-API too slow for bulk export, Kibana memory limits, ingestion backpressure at scale) — recommended **Kafka → ClickHouse** (`ReplicatedMergeTree`, 8-12 shards×2 replicas) + thin Go/Node API (search/download only, streamed export) + hot/cold split (ClickHouse 3-12mo, Parquet+Trino/Spark beyond).
- Full K8s ETL + ClickHouse hardware BOQ: HPA-scaled ETL pods (32→40), single ClickHouse server spec'd at 64 cores/768GB RAM/80Gbps aggregate networking, 150TB all-flash SAN.
- Effort estimate: 5-6 month delivery, team ramping 2-3 → 11-12 engineers at peak, 175-md backend component breakdown.

Evidence: `PathmikaSharepoint/Pathmika/PRES TASKS/Grameenphone reporting/*`.

---

## 19. Roaming Product Suite — Ethio Telecom [Pre-Sales]

- Early opportunity scoping: AI-based customer service, e-SIM detection, cost-optimization for revenue leakage, Voice&Data Fraud Management, anti-steering, silent-roamer detection.
- Dashboard reference pattern (SQI for Attach/Data/Voice&SMS, MAP/Diameter success rates) analogous to the RoamerSteering ELK dashboards — likely reuse of that design in a new pursuit.

Evidence: `PathmikaSharepoint/Pathmika/PRES TASKS/PRES-2223- Roaming Product Suite - Documentation/*`.

---

## 20. Hutch HOPP — MAJOR UPDATE: real source code found [Project Work]
**This significantly upgrades the current Projects.md HOPP entry, which states "no source code was available."** A nested `hutch-hopp-web-master.zip` contains the actual Next.js codebase, with explicit `@author Pathmika Weerarathna` headers on multiple core files — recommend revising the Projects.md HOPP section once this is incorporated.

- **Stack**: Next.js 14.2.13 (App Router, `[locale]` routing), React 18, TypeScript, Tailwind+shadcn/ui (Radix primitives), `next-intl`, `react-hook-form`+`zod`, axios, `js-cookie`.
- **Personally authored** (per file headers, dated Jun–Nov 2024): `src/middleware.ts` (locale/auth guard), `src/lib/Axios.ts` (custom wrapper: `jsonGet/jsonPost/formPost/formMultiPartPost/downloadFile`, `CancelToken` timeouts, unified `ApiError`), `src/services/axiosService.ts` (backend calls to shared `scapp/...` namespace — same backend as Hutch mobile Selfcare), `src/services/storageService.ts` (5MB quota-guarded storage wrapper).
- **`GlobalStateContext.tsx`**: React Context+useReducer global state with selective localStorage persistence — architecturally consistent with the mobile Hutch Selfcare app already in Projects.md.
- **Custom image CAPTCHA component** (backend-driven, not `react-google-recaptcha` despite it being in package.json).
- **Payment integrations**: FriMi (Nations Trust Bank — OAuth2 client_credentials, 4 request types incl. async-poll and reversal, 18-row error mapping), Visa/Amex/Mastercard/Alipay/Genie/Sampath Vishwa.
- **Tooling discipline**: Husky+lint-staged+Commitlint (Conventional Commits enforced via git hook), `removeConsole` production build flag.
- **Hybrid Git Flow branching model documented in the repo's own README** — same model formalized separately in the ISO 27001 readiness work (see #26) and taught in Git Training (#27) — confirms company-wide standard, applied here.
- **EE history** (6 versioned spreadsheets): V0.1 initial 966.75 total days → V1.5 client-negotiated final **543.3 days** (dev 262.8 + PM 66 + QA 129 + BA 55.5 + UAT 10 + deployment 10) tracked against Jira epic `HWHHP5`; separate 103.5-day OS/PHP-upgrade infra estimate; 61.25-day "new modifications" estimate.
- **SOW** (v1.2/v1.13): dual guest/logged-in flows, prepaid/postpaid dashboards, tokenization, bulk payment, scratch-card top-up, slab-based promotional rules, CMS-driven content publishing.
- **Release**: v0.1.0 dated Oct 2024, deployed to `reloadpay.hutch.lk` QA, git tag `QA-V-0.1.0`.

Evidence: `Project Documents/Hutch-HOPP/*` incl. `hutch-hopp-web-master.zip`.

---

## 21. RetailHub (Dialog) [Project Work — thin evidence]

- No SOW/EE/code found in this archive — only a Drive-links pointer file (external, not embedded) and an empty screenshots folder marker.
- Adjacent WinBack folder shows sibling "O2A" (online-to-agent) retail platform containers with CI vulnerability scanning (see #22) — same product family.
- **Action needed**: source additional evidence elsewhere if stronger RetailHub bullets are wanted; current material only supports a light mention.

Evidence: `Project Documents/DialogProjects/RetailHUB/*`.

---

## 22. WinBack (Dialog) [Project Work — thin evidence]

- Dialog device-sale/win-back campaign web app (`o2a-web-win-back`), Docker/Alpine, Dialog internal registry, CI-integrated Prisma Cloud/Twistlock vulnerability scanning (May 2023) flagging libxml2/freetype/openssl/ncurses/curl CVEs.

Evidence: `Project Documents/DialogProjects/WinBack/*.csv`.

---

## 23. Dialog DF (Digital Finance / loans app) [Project Work — thin evidence]

- React Native loan/finance app ("DF loans") — build/debug support evidence only: RN Gesture Handler downgrade for STG compatibility, cleartext traffic config, Hermes disabling, Prod↔STG constant switching, and a hand-patch to RN's internal `MessageQueue.js` to fix a Chrome-debugging "Invariant Violation" on synchronous native calls.

Evidence: `Project Documents/DialogProjects/DF/*`.

---

## 24. CMDP — deployment & UX backlog [Project Work — supplements existing Projects.md entry]

- Deployment runbook (QA+Prod): React build, manual web-directory swap/backup, `umask`/`chmod` fixes, a Content-Disposition header parsing fix in `Http.js`.
- UX/workflow backlog for the police/court CDR-disclosure portal: mobile-OTP self-registration for visiting officers, e-receipt/email delivery, 3-language support, status-tracking color-coding, scanner/camera attachment support.

Evidence: `Project Documents/cmdp/{CMDP.pdf, CMDP.txt, Dialog information portal.docx, Fwd Information System Issue List/*}`.

---

## 25. Vodafone Selfcare — QA/test evidence [Project Work — supplements existing Projects.md entry]

- Field QA test report: crash reproduction (adding 2nd connection, install permission-grant, balance-check on 2nd number), zero-balance display bug for a specific test MSISDN.
- Log-tail-based OTP retrieval technique used for testing since SMS OTP wasn't available in the test environment.

Evidence: `Project Documents/Vodafone/{APP Test Result 27.10.22.docx, Vodafone Fiji.xlsx}`.

---

## 26. ISO 27001 Readiness / Git Branching Standardization [Internal Process/Leadership]

- Authored SDLC-hardening guidance mapped to ISO/IEC 27001:2022 Annex A.14 controls + OWASP Top 10 compliance mapping, proposing new SDLC document sections (Secure Development Policy, Security Testing/Code Review, Change Control, Vulnerability/Patch Management, Third-Party Dev Security).
- Third-Party Library Usage Compliance Checklist (license/vulnerability/maintenance sign-off, dual Security+Tech-Lead approval).
- **Hybrid Git Flow branching model diagrams** — the same diagrams found live in HOPP's README (#20) and taught in Git Training (#27), confirming this was formalized company-wide, not a one-project convention.

Evidence: `Project Documents/ISO/*`, `Project Documents/Dev GuideLines/*`.

---

## 27. Git Training Program [Internal Process/Leadership]

- **6 versioned training decks** ("Git Practices Session — Internal Discussions," V.1–V.6, last tailored for the Firewall-GUI team).
- Curriculum: workflow pain points → repo-creation governance (GitLab group/naming conventions) → Hybrid Git Flow → commit practices → PR/code review → merge/rebase → hooks/CI/CD/tagging → docs/onboarding.
- Same branching model as HOPP (#20) and ISO readiness (#26) — this training is the origin/formalization point for that company-wide standard.

Evidence: `PathmikaSharepoint/Pathmika/GIT/Git/*`.

---

## 28. Internal AI Challenge 2025 (hackathon organizer) [Internal Process/Leadership]

- Designed a 5-criterion, 100-point weighted scoring rubric (Impact 30pts/×6, Feasibility 25pts/×5, Cost-Efficiency/ROI 20pts/×4, Scalability 15pts/×3, Evidence/PoC 10pts/×2) with tiebreaker rules.
- **Evaluated 14 employee proposals** end-to-end with written justifications (scores 65-89/100).
- Produced a phased rollout plan and awarded top-3 winners + 12 additional license grants, projecting $110K-$220K/yr combined value against $7K-$20K investment (550-1,100% ROI estimate).

Evidence: `PathmikaSharepoint/Pathmika/AI Challenge/*`.

---

## 29. AI Feature Proposals — Chatbot / Health Tip Generator / OCR Nutrition Tracker / Voice Chatbot [Pre-Sales]

- **Multilingual Chatbot**: 690-day internal EE / 800-day client-facing EE (13-phase breakdown), plus a buy-vs-build analysis vs. Dialogflow CX/MS Bot Framework/Rasa Enterprise/Kore.ai/Yellow.ai.
- **Personalized Health Tip Generation System**: 810-day estimate — recommendation engine (weather/health-API fusion) + OCR prescription-reading module, with App Store/Play Store/Huawei AppGallery health-data compliance analysis.
- **OCR Nutrition Tracker**: 352-day estimate — OCR (Tesseract/EasyOCR/Google Vision) + fuzzy-match against USDA/NutritionIX/MyFitnessPal, scoped add-ons (barcode +40d, CNN food recognition +70d).
- **Voice Chatbot + Virtual Human Interface**: 720-day voice bot (ASR/TTS/SIP/IVR, PCI-DSS/GDPR) + 480-day 3D avatar/lip-sync layer = 1,200-day combined program.

Evidence: `PathmikaSharepoint/Pathmika/AIA- EE and Effort Justification/*`.

---

## 31. AIML Learnings / "Omobio AI SDLC Guardian" proposal [Internal Process/Leadership + R&D]

- **Org-wide AI-tooling adoption proposal**: named stack + pricing (GitHub Copilot Enterprise $39/user/mo, SonarQube AI CodeFix $150/mo, Testim+Applitools $499/mo, Atlassian Intelligence $15-25/user/mo, Vanta for ISO-compliance automation $8,000/yr), 3-phase rollout (Quick Wins → Full Deployment → Optimization), citing industry benchmarks (Microsoft 55% faster coding, Orange France 85% less debugging time).
- Personal AI/ML learning roadmap (math → classical ML → deep learning → NLP → MLOps) and a comparative STT/TTS library survey (Whisper/Vosk/DeepSpeech/Kaldi vs. cloud STT/TTS) that fed the Voice Chatbot proposal (#29).

Evidence: `PathmikaSharepoint/Pathmika/AIML- Learnings/*`.

---

## 32. BSNL Selfcare AIML (India) [Pre-Sales]

- 4-module fraud/anomaly-detection EE for BSNL's self-care platform: bot/fraud detection (Isolation Forest+DBSCAN, 150 md), referral/cashback abuse (LSTM+rules, 220 md), usage/transaction outlier detection (Z-score/PCA+ARIMA, 200 md), geo-anomaly re-verification (Haversine clustering+Logistic Regression, 200 md) — **~770 man-days total**.

Evidence: `PathmikaSharepoint/Pathmika/BSNL Selfcare/AIML modules EE.docx`.

---

## 33. Bankai Digital Wallet AI (eKYC & Credit Scoring) [Pre-Sales]

- 4-module feasibility+EE (iterated 347→387→495 md across 3 versions): OCR/KYC extraction (Vision Transformer/Donut/Tesseract, 55-65 md), Facial Recognition (ArcFace/FaceNet, 96-130 md), Liveness Detection (passive+active, 76-130 md), Credit Scoring (XGBoost/RF baseline + GNN/Transformer advanced, SHAP explainability, 120-175 md).
- Full microservices architecture (Python FastAPI+Node.js, PyTorch/TF, Postgres/MongoDB, ONNX/TensorRT, Docker/K8s) with per-module on-prem hardware sizing (GPU nodes for facial/liveness, CPU-only for credit scoring).
- Separate MobiFin pitch deck arguing for hybrid rule+ML credit scoring to replace a purely rule-based system.

Evidence: `PathmikaSharepoint/Pathmika/PRES TASKS/Discussion Assistance on AIML Use Cases-Dinesh/*`.

---

## 34. E-channeling Agentic Call Center RFP [Pre-Sales]

- RFP-drafting engagement for an AI-assisted agentic contact center automating appointment booking (Doctor Channelling, NTMI, MFA appointments, refunds, general inquiries) — Stage 1 scoped to NTMI Channelling.
- Requirements: NLU multi-turn conversational AI with human escalation, CRM+backend+IVR integration, 2-3 min avg call target, revenue-sharing commercial model (no CapEx).

Evidence: `PathmikaSharepoint/Pathmika/PRES TASKS/E-channeling/*`.

---

## Notes on exclusions (applies across all sections above)

- **Personal/HR documents excluded entirely**: `Project Documents/Omobio_Documents/*` (contracts, NDA, IDs, tax docs, personal CV/blog) and `Project Documents/NetSarang/*` (personal SSH/FTP client config) — not project work, not reviewed for content.
- **Raw data excluded**: CDR `.csv` dumps, `.mp4/.mkv/.m4a` recordings, raw `.log` files, and large nested data zips were noted as present but not extracted/analyzed.
- **Credentials excluded**: multiple documents contained plaintext passwords, SSH keys, VPN/DB credentials, and internal IPs (Vodafone, CMDP, Airtel, ELK setup guides, Robi VPN notes) — none reproduced here; flagging that this material exists in the source folders and must stay out of any CV/portfolio-facing document.
- **Thin/low-evidence items flagged for follow-up**: RetailHub (#21), RH-OCR (#8), Bankai Due Diligence reports (folder present but empty), Ncell-campaignInsights standalone `.drawio` (architecture sketch only, no narrative doc).

## Key recommendation for next CV pass

The **Hutch HOPP** finding (#20) is the most significant update — real source code with author headers was found, meaning the current Projects.md entry (which assumes no code exists) should be rewritten with concrete implementation bullets rather than scope-only language. The **Bangla SMS** finding (#10) similarly corrects the CV's framing from "repo scaffolding" to "SRS technical review + solution scoping." The **Banglalink** (#9) and **Flash Call/Voice Firewall** (#4) findings represent substantial, recent, technically-rich work with no current CV presence at all and should be prioritized for new CV bullets.
