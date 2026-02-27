# Shop Migration to Supabase - Design

## Summary

Migrate shop from WooCommerce to Supabase. Simplify checkout to "comanda la bunicu" - an email sent via Resend.io edge function. Add order history in user profile.

## Database Schema

### shop_categories

| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK, gen_random_uuid() |
| name | text | NOT NULL |
| slug | text | NOT NULL, unique |
| description | text | nullable |
| image_url | text | nullable |
| parent_id | uuid | FK self-ref, nullable (null = root) |
| sort_order | int | default 0 |
| is_active | boolean | default true |
| created_at | timestamptz | default now() |

### shop_products

| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK |
| name | text | NOT NULL |
| slug | text | NOT NULL, unique |
| description | text | nullable |
| price | numeric(10,2) | NOT NULL, in RON |
| sale_price | numeric(10,2) | nullable |
| images | jsonb | array of URLs |
| category_id | uuid | FK to shop_categories |
| is_active | boolean | default true |
| sort_order | int | default 0 |
| created_at | timestamptz | default now() |

### shop_orders

| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK |
| user_id | uuid | FK to auth.users, NOT NULL |
| status | text | default 'pending' |
| note | text | nullable |
| total | numeric(10,2) | NOT NULL |
| user_name | text | denormalized |
| user_email | text | denormalized |
| created_at | timestamptz | default now() |
| updated_at | timestamptz | default now() |

### shop_order_items

| Column | Type | Notes |
|--------|------|-------|
| id | uuid | PK |
| order_id | uuid | FK to shop_orders |
| product_id | uuid | FK to shop_products |
| product_name | text | denormalized |
| product_price | numeric(10,2) | price at time of order |
| quantity | int | NOT NULL |

### shop_config

| Column | Type | Notes |
|--------|------|-------|
| key | text | PK |
| value | text | email address |

Keys: `order_email_to`, `order_email_cc1`, `order_email_cc2`

### RLS Policies

- `shop_categories`, `shop_products`: authenticated SELECT (where is_active = true)
- `shop_config`: authenticated SELECT
- `shop_orders`: authenticated INSERT (user_id = auth.uid()), authenticated SELECT (user_id = auth.uid())
- `shop_order_items`: authenticated INSERT, authenticated SELECT (via join on own orders)

## Edge Function: send-order-email

- Input: `{ order_id: uuid }`
- Fetches order + items + config with service_role
- Sends HTML email via Resend.io (to: bunicu, cc: 2 addresses)
- Returns success/error

## App Flow

```
Categories → Products → Detail → Add to cart
Cart → "Trimite comanda" → optional note → confirm
  → INSERT shop_orders + shop_order_items
  → CALL send-order-email edge function
  → Success page
Profile → Order History → Order Detail
```

## What Gets Removed

- WooCommerceApiClient and all WooCommerce dependencies
- CartStockDatasource (no stock management)
- Checkout forms (billing/shipping), PaymentWebView
- OrderDataSourceSupabase (old /woo_orders proxy)
- Mock data files

## What Stays

- Cart in SharedPreferences + CartCubit (simplified, no stock check)
- Page structure: categories → products → detail
- CartPage UI (with simplified checkout button)

## Config

- Resend API key: stored as Supabase edge function secret
- Email recipients: stored in shop_config table (manageable from Supabase Studio)
- Products/categories: managed from Supabase Studio
