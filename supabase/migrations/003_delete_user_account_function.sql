-- Function that allows authenticated users to delete their own account
-- Runs with SECURITY DEFINER to have elevated privileges needed to delete from auth.users
CREATE OR REPLACE FUNCTION public.delete_user_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  -- Delete the user from auth.users (this cascades to all related data)
  DELETE FROM auth.users WHERE id = auth.uid();
END;
$$;

-- Only authenticated users can call this function
REVOKE ALL ON FUNCTION public.delete_user_account() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.delete_user_account() TO authenticated;
