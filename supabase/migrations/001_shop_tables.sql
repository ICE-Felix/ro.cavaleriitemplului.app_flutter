-- Shop categories
CREATE TABLE shop_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  image_url text,
  parent_id uuid REFERENCES shop_categories(id),
  sort_order integer DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Shop products
CREATE TABLE shop_products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  price numeric(10,2) NOT NULL,
  sale_price numeric(10,2),
  images jsonb DEFAULT '[]'::jsonb,
  category_id uuid REFERENCES shop_categories(id),
  is_active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Shop orders
CREATE TABLE shop_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) NOT NULL,
  status text DEFAULT 'pending',
  note text,
  total numeric(10,2) NOT NULL,
  user_name text NOT NULL,
  user_email text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Shop order items
CREATE TABLE shop_order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES shop_orders(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES shop_products(id) NOT NULL,
  product_name text NOT NULL,
  product_price numeric(10,2) NOT NULL,
  quantity integer NOT NULL
);

-- Shop config (email addresses etc)
CREATE TABLE shop_config (
  key text PRIMARY KEY,
  value text NOT NULL
);

-- RLS policies
ALTER TABLE shop_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read active categories"
  ON shop_categories FOR SELECT TO authenticated
  USING (is_active = true);

CREATE POLICY "Authenticated users can read active products"
  ON shop_products FOR SELECT TO authenticated
  USING (is_active = true);

CREATE POLICY "Users can insert own orders"
  ON shop_orders FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can read own orders"
  ON shop_orders FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert order items"
  ON shop_order_items FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM shop_orders
      WHERE shop_orders.id = order_id
      AND shop_orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can read own order items"
  ON shop_order_items FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM shop_orders
      WHERE shop_orders.id = order_id
      AND shop_orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Authenticated users can read config"
  ON shop_config FOR SELECT TO authenticated
  USING (true);

-- Insert default config
INSERT INTO shop_config (key, value) VALUES
  ('order_email_to', 'bunicu@example.com'),
  ('order_email_cc1', 'cc1@example.com'),
  ('order_email_cc2', 'cc2@example.com');
