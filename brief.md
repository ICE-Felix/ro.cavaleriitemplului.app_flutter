Brief complet – Aplicație mobilă (Flutter)

# Cavaleria Templului - Mobile App

Aplicație oficială pentru digitalizarea activităților Lojei "Cavaleria Templului" Nr. 126, parte a Marii Loji Naționale din România (I.G.M.B.B.U.).

## Identitate vizuală
- Paletă cromatică: roșu bordo (#8B0000) și auriu (#C9A227), reflectând culorile stemei lojei
- Logo: stema oficială cu coloana templului, crucea roșie și motto-ul "Spiritum Sanctum Revirifecimus"
- Design: elegant, ceremonial, cu elemente tradiționale masonice
- Tipografie: Cinzel/Merriweather pentru titluri (ceremonial), Inter/Source Sans 3 pentru text body

## 1) Obiectiv & public țintă

Obiectiv: digitalizarea activităților interne: informare, bibliotecă, prezențe la ținute, magazin online, notificări.

Utilizatori: membri lojei (roluri: membru, ofițer/secretar, admin tehnic).

KPIs: % onboarded în 30 zile, rata de vizualizare anunțuri, % prezențe marcate, comenzi plasate via app, crash-free sessions > 99.5%.

2) Platforme & tehnologie

Flutter (iOS 15+, Android 8+).

Backend primar: Supabase (Auth, Postgres, Storage, RLS).

Magazin: Laravel shop la shop.cavaleriitemplului.ro (REST/GraphQL).

Notificări: Firebase Cloud Messaging.

Fișiere/Bibliotecă: Supabase Storage (sau proxy la Google Drive).

Analytics & crash: Firebase Analytics + Crashlytics.

Feature toggles: remote config (Supabase table sau Firebase RC).

3) Arhitectură app

Pattern: Presentation (Widget) / Application (Bloc) / Domain (UseCases) / Data (Repos, DTOs).

State mgmt: flutter_bloc + freezed pentru modele imutabile.

Networking: dio + interceptors (auth token, retry).

Caching/offline: isar (sau hive) pentru liste & detalii; connectivity_plus.

Routing: go_router (deep-link ready).

DI: get_it.

Config per mediu: .env (dev/stage/prod) cu flutter_dotenv.

Structură directoare
lib/
  app/            # bootstrap, theme, router
  core/           # utils, errors, env, constants, tokens
  features/
    auth/
      data/ domain/ presentation/
    dashboard/
    members/
    notices/
    library/
    presence/
    shop/
    settings/
  shared/
    widgets/     # UI reutilizabile
    services/    # fcm, file_opener, share
    repo/        # base classes

4) Navigație (IA)

Onboarding/Login → Dashboard (Acasă)

Tabs (BottomNav): Acasă | Membri | Noutăți | Bibliotecă | Setări

Ecrane cheie:

Acasă: carduri „Scurt istoric”, „Revistă”, „Program ținute”, „Noutăți”.

Membri: listă + profil membru.

Noutăți/Comunicate: listă MLNR / Interne, detaliu, atașamente.

Bibliotecă: categorii, căutare, vizualizare/descărcare PDF/ePub.

Prezență: (rol secretar) liste ținute, marcare prezență, export.

Shop: listă produse, detaliu, coș, checkout (webview securizat + bridge).

Setări: profil, notificări, legal, logout.

5) Features (MVP → MLP)

MVP

Autentificare Supabase (email+parolă, reset parolei; opțional biometric).

Dashboard cu ultimele anunțuri/evenimente.

Noutăți/Comunicate: listare, filtrare, detaliu, deschidere atașamente.

Membri: listare + profil.

Bibliotecă: browsare/căutare, vizualizare PDF (viewer in-app).

Shop integrat (webview cu SSO token), istoric comenzi read-only.

Notificări push (noutăți, noi documente, evenimente).

Legal (T&C, Privacy), GDPR consimțământ.

MLP

Prezență la ținute (rol secretar): marcare, statistici, export CSV/PDF.

Offline cache pentru noutăți și bibliotecă.

Sondaje interne simple.

Dark mode.

6) Modele de date (Domain)
classDiagram
  class Member { uuid id; text full_name; text grade; text role; text email; text phone; text avatar_url; bool active }
  class Notice { uuid id; text title; text body; bool internal; date date; text attachment_url }
  class Event { uuid id; text title; timestamptz start; text location; text notes }
  class Document { uuid id; text title; text category; text file_url; bool internal }
  class PresenceRecord { uuid id; uuid event_id; uuid member_id; enum status(Present,Absent,Excused); timestamptz marked_at; uuid marked_by }
  class Product { uuid id; text name; text sku; numeric price; text image_url; }
  class Order { uuid id; uuid user_id; text number; numeric total; text status; timestamptz created_at }
Member "1" -- "*" PresenceRecord
Event  "1" -- "*" PresenceRecord


Implementare în Postgres/Supabase cu RLS pe roluri (read public vs internal, write doar secretar/admin).

7) API-uri (schemă)

Supabase Auth: email/password; refresh token; profile table members.

Supabase REST (PostgREST):

GET /notices?select=*&order=date.desc&internal=eq.false (+ RLS pentru interne).

GET /documents?select=*&category=eq.{cat}; GET /storage/v1/object/public/library/{file}

GET /events?select=*

GET /members?select=id,full_name,grade,role,avatar_url

(MLP) POST /presence_records body { event_id, member_id, status }

Shop (Laravel):

GET /products, GET /products/{id}

POST /cart, POST /checkout (via webview + token SSO query param, ex: ?sb_access_token=...)

FCM: topic-based (all, mlnr, interna), sau per-user token mapping în Supabase.

8) Securitate & conformitate

RLS strict pe tabelele cu marcaj internal.

Token Supabase injectat în dio via interceptor; refresh automat.

WebView shop: origin allowlist, SSO token scurt (JWT signed), dezactivare mixed content.

Criptare la repaus pentru cache (Isar cu encryptionKey).

GDPR: consimțământ analytics, drept de ștergere cont (flux suport).

9) Theming & Design tokens

Paletă (propusă; poate fi înlocuită 1:1 cu tokenii Webflow):

Primary #8B0000 | Primary* #A31212

Secondary #C9A227 | Secondary* #A88717

Background #F7F5EF | Surface #FFFFFF | SurfaceAlt #F1EFE8

Text #1B1B1B (primar) | #4A4A4A (secundar) | Divider #E2DED3

Error #B00020 | Info #1E88E5 | Success #2E7D32 | Warning #C77800

Tipografie

Headings: Cinzel / Merriweather

Body/UI: Inter / Source Sans 3

Implementare: google_fonts.

Componente UI

Carduri cu colțuri 16–20, umbre discrete, listă densă pe „Membri”, carduri media pe „Noutăți”.

10) Localizare & accesibilitate

Limbi: ro (default), en (pregătit).

flutter_localizations + intl.

A11y: contrast AA+, dynamic type, label-uri pentru screen readers.

11) Performanță (bugete)

TTFB API < 500ms (medie), ecran încărcat < 1.5s pe 4G.

Imagery: WebP/AVIF, thumbs & lazy-load.

Liste: PagedListView/infinite_scroll_pagination.

12) Logging, Analytics, Observabilitate

Crashlytics cu breadcrumbs (screen names, API fail).

Analytics evenimente: notice_open, doc_open, presence_mark, shop_checkout_start, shop_purchase.

13) Testare

Unit: use cases, repositories, mappers.

Widget/Golden: ecrane-cheie (dashboard, listări, detalii).

Integration: auth flow, cache + offline, webview shop.

UAT checklist: navigație, a11y, RLS, push, export prezențe.

E2E: integration_test (login → preluare noutăți → deschidere document → logout).

14) CI/CD

GitHub Actions / Codemagic:

Lint + tests pe PR, build dev (internal).

Semnare iOS via Fastlane Match; Android keystore criptat.

Artefacte: .ipa (TestFlight), .aab (Internal testing).

Schemes/Flavors: dev / stg / prod cu bundle id distinct.

Auto-increment build number, note de release generate.

15) Plan de livrare

Săpt. 1–2: Setup proiect, Auth, Routing, Theme, Dashboard read-only.

Săpt. 3–4: Noutăți + Membri + Bibliotecă (vizualizare PDF) + FCM.

Săpt. 5: Shop webview + SSO; QA runda 1.

Săpt. 6: Hardening, analytics, crash, UAT; pregătire demo.

MLP (post-demo): Prezență la ținute + export, offline complet.

16) Criterii de acceptanță (MVP)

Login funcțional, sesiune persistentă, logout sigur.

Dashboard populat, deschidere detalii noutăți și documente.

Membri listare + profil fără PII excesiv (conform RLS).

Shop accesibil și checkout funcțional (prin webview securizat).

Notificări push recepționate pe iOS/Android (foreground/background/terminated).

Crash-free > 99.5%, ecrane sub 1.5s la încărcare pe conexiune mobilă.

17) Dependențe recomandate (pubspec)
flutter_bloc, go_router, dio, json_annotation, freezed, freezed_annotation,
get_it, flutter_dotenv, isar, isar_flutter_libs, connectivity_plus,
package_info_plus, url_launcher, file_picker, open_filex, share_plus,
firebase_core, firebase_messaging, firebase_analytics, firebase_crashlytics,
supabase_flutter, cached_network_image, google_fonts, infinite_scroll_pagination

18) Puncte de risc & mitigare

RLS greșit → expunere date: audit rules + teste automate de permisiuni.

SSO webview shop: token scurt + origin allowlist + expirare.

Offline & fișiere mari: limit dimensiune, preîncărcare thumbs, retry policy.

App store review (conținut intern): login obligatoriu, fără funcții nefuncționale.

Checklist livrabile

 Proiect Flutter cu flavors, router, theme, DI.

 Integrare Supabase (auth + CRUD) + RLS verificate.

 Ecrane: Acasă, Membri, Noutăți, Bibliotecă, Setări (+ Shop webview).

 FCM configurat + topicuri.

 Analytics & Crashlytics.

 Teste unit/widget/integration min 60% coverage features cheie.

 Build iOS TestFlight + Android Internal testing.

 Documentație release & rollback.