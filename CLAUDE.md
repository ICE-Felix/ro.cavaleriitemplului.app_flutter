# Cavalerii Templului - Flutter App

## Project Overview
Mobile app for Masonic Lodge Nr. 126 "Cavalerii Templului". Flutter app with Supabase backend.

## Architecture
- Clean Architecture: Presentation / Application / Domain / Data
- State management: flutter_bloc
- Navigation: go_router
- HTTP: Supabase Flutter SDK (direct table queries with RLS)

## Supabase Backend
- **Project ref**: zmjwvmabmdagkhsxgjhx
- **Auth**: Supabase Auth (email/password)
- **Data access**: Direct table queries via Supabase SDK (NOT edge functions)
- **Security**: Row Level Security (RLS) - authenticated users can read, only service_role can write

### Database Tables

#### `news_categories`
| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK, auto-generated |
| name | text | Category name (MLNR, Interne, General) |
| created_at | timestamptz | Auto |
| updated_at | timestamptz | Auto |
| deleted_at | timestamptz | Soft delete |

#### `news`
| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK, auto-generated |
| title | text | Article title |
| body | text | Article content |
| summary | text | Short summary |
| image_url | text | Featured image URL |
| keywords | text | Comma-separated tags |
| category_id | uuid | FK to news_categories |
| news_category_title | text | Denormalized category name |
| partner_company_name | text | Author/source |
| read_count | integer | View counter |
| published_at | timestamptz | Publish date |
| created_at | timestamptz | Auto |
| updated_at | timestamptz | Auto |

### RLS Policies
- `news`: authenticated users can SELECT
- `news_categories`: authenticated users can SELECT (where deleted_at IS NULL)
- No INSERT/UPDATE/DELETE for app users (admin only via service_role)

## Key Files
- `lib/core/network/supabase_client.dart` - Supabase client wrapper (auth + DB)
- `lib/features/news/data/datasources/news_remote_data_source.dart` - News data source (direct Supabase queries)
- `lib/features/news/data/models/` - News, Category, Pagination models
- `lib/core/service_locator.dart` - Dependency injection setup
- `.env` - Supabase URL, anon key, service role key, WooCommerce config

## Conventions
- Data sources use Supabase SDK directly (no HTTP calls, no edge functions)
- All queries require authenticated user
- Pagination: offset-based with page/limit params
- Models have fromJson/toJson for Supabase compatibility
