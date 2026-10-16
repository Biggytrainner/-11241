# คลังอุปกรณ์ทางกายภาพบำบัด — ฐานข้อมูลกลาง

โปรเจกต์เว็บแอปสำหรับบันทึกยืม-คืนอุปกรณ์และแชร์ข้อมูลผ่าน Supabase พร้อม deploy เป็นเว็บ static บน Netlify โดย **ไม่มีหน้าล็อกอิน**

## โครงสร้าง
- `index.html` — เว็บแอป
- `config.js` — URL และ public anon/publishable key ของ Supabase
- `schema.sql` — ตารางฐานข้อมูลและ Row Level Security
- `netlify.toml` — ตั้งค่า publish directory

## 1) สร้างฐานข้อมูลกลางบน Supabase
1. สร้างโปรเจกต์ที่ https://supabase.com/
2. เปิด SQL Editor แล้วรันเนื้อหาใน `schema.sql`
3. ไปที่ Project Settings → API แล้วคัดลอก Project URL และ anon/publishable key
4. ใส่สองค่านั้นใน `config.js` แทน `YOUR_PROJECT_ID` และ `YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY`

**ข้อควรระวังสำคัญ:** เนื่องจากเอาหน้าล็อกอินออก policy ใน `schema.sql` จึงอนุญาตให้ผู้ที่เข้าถึงเว็บสามารถอ่านและแก้ไขฐานข้อมูลกลางได้ ผู้ใช้ไม่ต้องเข้าสู่ระบบ และไม่ควรใช้กับข้อมูลผู้ป่วย ชื่อ/HN หรือข้อมูลส่วนบุคคล/ข้อมูลอ่อนไหว หากต้องการจำกัดเฉพาะเจ้าหน้าที่ ควรใช้ระบบล็อกอินและกำหนดสิทธิ์ผู้ใช้

## 2) ทดสอบในเครื่อง
เปิด `index.html` ผ่าน local web server (เช่น VS Code Live Server) ไม่แนะนำให้เปิดแบบ `file://` โดยตรง

หากยังไม่ได้ตั้งค่า `config.js` แอปจะทำงานด้วยข้อมูลใน browser เครื่องนั้น และจะไม่ซิงก์ไปยังฐานข้อมูลกลาง

## 3) ฝากโค้ดบน GitHub
1. สร้าง repository ใหม่แบบ Private หากมีข้อมูลภายในหน่วยงาน
2. อัปโหลด `index.html`, `config.js`, `schema.sql`, `netlify.toml`, `README.md`
3. อย่า commit ข้อมูลจริงหรือไฟล์ export ที่มีชื่อ/HN ผู้ป่วย
4. ห้ามใช้ Supabase `service_role` key ในเว็บหรือ GitHub; ใช้เฉพาะ anon/publishable key

## 4) Deploy บน Netlify
1. เข้า https://app.netlify.com/ แล้วเลือก Add new site → Import an existing project
2. เชื่อม GitHub แล้วเลือก repository
3. Build command เว้นว่างไว้
4. Publish directory ใส่ `.` แล้ว Deploy
5. เมื่อ push การแก้ไขไป GitHub, Netlify จะ deploy ใหม่ให้อัตโนมัติ

## ข้อควรทราบก่อนใช้งานจริง
- ตาราง `app_state` เก็บข้อมูลทั้งหมดเป็น JSONB ก้อนเดียวเพื่อให้เข้ากับโค้ดเดิมได้เร็ว การบันทึกพร้อมกันหลายคนอาจเขียนทับการเปลี่ยนแปลงของกันและกันได้
- ก่อนใช้จริง ควรพัฒนาเป็นตาราง equipment/borrow_records และ RPC transaction พร้อมระบบยืนยันตัวตน, สิทธิ์, audit log, backup และการตรวจสอบ PDPA
