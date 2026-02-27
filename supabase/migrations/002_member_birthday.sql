-- Add birthday column to members table
ALTER TABLE members ADD COLUMN IF NOT EXISTS birthday date;

-- Function to get members whose birthday is today (matching month and day)
CREATE OR REPLACE FUNCTION get_today_birthdays()
RETURNS SETOF members
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT *
  FROM members
  WHERE birthday IS NOT NULL
    AND EXTRACT(MONTH FROM birthday) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(DAY FROM birthday) = EXTRACT(DAY FROM CURRENT_DATE)
  ORDER BY name;
$$;

-- Function to create birthday notifications for today's birthdays
-- Uses 'global' target_type (notifications constraint allows only 'global' or 'user')
-- Stores birthday metadata in the 'data' jsonb column
CREATE OR REPLACE FUNCTION create_birthday_notifications()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  member RECORD;
BEGIN
  FOR member IN
    SELECT id, name FROM members
    WHERE birthday IS NOT NULL
      AND EXTRACT(MONTH FROM birthday) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(DAY FROM birthday) = EXTRACT(DAY FROM CURRENT_DATE)
  LOOP
    -- Only insert if not already created today for this member
    IF NOT EXISTS (
      SELECT 1 FROM notifications
      WHERE target_type = 'global'
        AND data->>'birthday_member_id' = member.id::text
        AND created_at::date = CURRENT_DATE
    ) THEN
      INSERT INTO notifications (title, body, target_type, data, created_at)
      VALUES (
        'La Multi Ani! 🎂',
        'Astazi este ziua de nastere a fratelui ' || member.name || '! Ureaza-i La Multi Ani!',
        'global',
        jsonb_build_object('birthday_member_id', member.id::text, 'member_name', member.name, 'type', 'birthday'),
        NOW()
      );
    END IF;
  END LOOP;
END;
$$;

-- Schedule daily cron job at 06:00 UTC to create birthday notifications
-- Requires pg_cron extension to be enabled in Supabase Dashboard
-- SELECT cron.schedule(
--   'daily-birthday-notifications',
--   '0 6 * * *',
--   $$ SELECT create_birthday_notifications(); $$
-- );
