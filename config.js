// ใส่ค่าจาก Supabase > Project Settings > API
// anon/publishable key ใช้ฝั่ง browser ได้เมื่อเปิด RLS และตั้ง policy ตาม schema.sql
window.SUPABASE_CONFIG = {
  url: "https://YOUR_PROJECT_ID.supabase.co",
  anonKey: "YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY"
};
