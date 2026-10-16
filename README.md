# คลังอุปกรณ์ทางกายภาพบำบัด — ฐานข้อมูลกลาง

โปรเจกต์นี้ปรับจากไฟล์ HTML ที่ให้มา เพื่อให้เจ้าหน้าที่หลายคนใช้ข้อมูลชุดเดียวกันผ่าน Supabase และ deploy เป็นเว็บ static บน Netlify โดยเก็บโครงหน้าตาและการทำงานเดิมไว้

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
5. ไปที่ Authentication → Users แล้วสร้างบัญชีอีเมล/รหัสผ่านให้เจ้าหน้าที่ที่ได้รับอนุญาต
6. ปิดการสมัครสมาชิกสาธารณะ (Signups) ใน Authentication settings เพื่อไม่ให้บุคคลทั่วไปสมัครเอง

## 2) ทดสอบในเครื่อง
เปิด `index.html` ผ่าน local web server (เช่น VS Code Live Server) ไม่แนะนำให้เปิดแบบ `file://` โดยตรง เพราะเบราว์เซอร์อาจบล็อกบางคำขอ

## 3) ฝากโค้ดบน GitHub
1. สร้าง repository ใหม่แบบ Private หากมีข้อมูลภายในโรงพยาบาล
2. อัปโหลดไฟล์ `index.html`, `config.js`, `schema.sql`, `netlify.toml`, `README.md`
3. อย่า commit ข้อมูลจริงหรือไฟล์ export ที่มีชื่อ/HN ผู้ป่วย

> `config.js` มี public anon/publishable key ซึ่งถูกออกแบบให้ใช้ใน browser ได้ แต่ต้องเปิด RLS และ policy อย่างถูกต้องเสมอ ห้ามใช้ `service_role` key ในเว็บหรือ GitHub

## 4) Deploy บน Netlify
1. เข้า https://app.netlify.com/ แล้วเลือก Add new site → Import an existing project
2. เชื่อม GitHub แล้วเลือก repository
3. Build command เว้นว่างไว้
4. Publish directory ใส่ `.` แล้ว Deploy
5. เมื่อ push การแก้ไขไป GitHub, Netlify จะ deploy ใหม่ให้อัตโนมัติ

## ข้อควรทราบก่อนใช้งานจริง
- ระบบเดิมเก็บข้อมูลยืม-คืนไว้ใน browser; เวอร์ชันนี้จะโหลด/บันทึก snapshot ไปยัง Supabase หลังเจ้าหน้าที่ล็อกอิน
- ตาราง `app_state` เก็บข้อมูลแอปไว้ใน JSONB ก้อนเดียวเพื่อให้เข้ากับโค้ดเดิมได้เร็ว เหมาะกับต้นแบบหรือหน่วยงานขนาดเล็ก แต่การบันทึกพร้อมกันหลายคนอาจเขียนทับการเปลี่ยนแปลงของกันและกันได้
- ก่อนใช้กับข้อมูลผู้ป่วยจริง ควรให้ผู้ดูแลระบบ/IT โรงพยาบาลตรวจสอบ PDPA, การกำหนดสิทธิ์, audit log, backup และการทดสอบการใช้งานหลายคน การใช้ snapshot JSONB ยังไม่ใช่ฐานข้อมูลเชิงสัมพันธ์เต็มรูปแบบ
- การปรับสต๊อกในหน้าเว็บเดิมยังไม่ใช่ transaction ระดับฐานข้อมูล; ควรพัฒนาเป็นตาราง equipment/borrow_records และ RPC transaction ก่อนใช้งานจริงหลายผู้ใช้
