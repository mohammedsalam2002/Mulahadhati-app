# 📝 تطبيق ملاحظاتي - Notes App

تطبيق ملاحظات احترافي مبني بـ Flutter، جاهز للنشر على Google Play Store.

## ✨ المميزات

- ✅ إنشاء وتعديل وحذف الملاحظات
- ✅ تنسيق نص غني (عريض، مائل، قوائم، عناوين)
- ✅ وسوم وتصنيفات
- ✅ بحث فوري
- ✅ ترتيب متعدد الطرق
- ✅ تثبيت الملاحظات المهمة
- ✅ أرشيف وسلة محذوفات
- ✅ وضع ليلي ونهاري
- ✅ دعم العربية والإنجليزية مع RTL
- ✅ تصدير PDF و TXT
- ✅ نسخ احتياطي محلي
- ✅ قفل بـ PIN أو بصمة
- ✅ تخزين محلي 100% (لا سيرفر)

---

## 🚀 خطوات الإعداد والتشغيل

### 1. تثبيت المتطلبات
```bash
# تأكد من تثبيت Flutter SDK 3.10+
flutter --version

# تثبيت الحزم
cd notes_app
flutter pub get
```

### 2. توليد ملفات Hive (إذا عدّلت النموذج)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. تشغيل التطبيق للاختبار
```bash
flutter run
```

### 4. إنشاء الأيقونات
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

> **مهم:** يجب وضع الملفات التالية في `assets/icons/`:
> - `app_icon.png` (1024×1024)
> - `app_icon_foreground.png` (شفاف، الشعار في الوسط)
> - `splash_logo.png` (للشاشة الافتتاحية)

---

## 🔐 إنشاء Keystore للتوقيع

قبل النشر يجب توقيع التطبيق. شغّل الأمر التالي في Terminal:

```bash
keytool -genkey -v -keystore ~/notes-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias notes
```

سيُطلب منك:
- كلمة مرور للـ keystore (احفظها جيداً!)
- معلومات (اسم، مؤسسة، إلخ)
- كلمة مرور للـ key (يمكن نفس الأولى)

### ربط Keystore بالمشروع

1. أنشئ ملف `android/key.properties`:
```properties
storePassword=كلمة_مرور_keystore
keyPassword=كلمة_مرور_key
keyAlias=notes
storeFile=/المسار/الكامل/إلى/notes-release-key.jks
```

2. **مهم:** أضف `key.properties` إلى `.gitignore` ولا ترفعه على GitHub أبداً.

---

## 📦 بناء App Bundle للنشر

```bash
# تنظيف
flutter clean
flutter pub get

# بناء AAB (الموصى به من Google Play)
flutter build appbundle --release

# الناتج في:
# build/app/outputs/bundle/release/app-release.aab
```

لبناء APK (للاختبار فقط):
```bash
flutter build apk --release --split-per-abi
```

---

## ✅ قائمة التحقق قبل النشر على Google Play

### المتطلبات التقنية
- [ ] `applicationId` مُحدَّث في `android/app/build.gradle` (ليس `com.example`)
- [ ] `versionCode` و `versionName` صحيحان في `pubspec.yaml`
- [ ] `targetSdkVersion 34` (أو الأحدث المطلوب)
- [ ] `minSdkVersion 21` على الأقل
- [ ] App Bundle موقّع بـ keystore حقيقي
- [ ] حجم AAB أقل من 150 MB
- [ ] التطبيق تم اختباره على Android 7, 10, 13

### المتطلبات القانونية
- [ ] رفع `privacy_policy.md` على موقع/GitHub Pages وتحديث الرابط في `app_constants.dart`
- [ ] تحديث `developerEmail` و `developerName` في `app_constants.dart`
- [ ] ملء **Data Safety form** في Play Console:
  - Data collection: **No data collected**
  - Data shared: **No data shared**
  - Encryption in transit: لا ينطبق
  - User data deletion: نعم (بإلغاء التثبيت)

### المحتوى المرئي للمتجر
- [ ] أيقونة 512×512 بصيغة PNG
- [ ] صورة Feature Graphic بحجم 1024×500
- [ ] على الأقل 2-8 لقطات شاشة (Phone): 1080×1920 أو ما يماثلها
- [ ] لقطات شاشة Tablet (إذا كان مدعوماً)
- [ ] فيديو ترويجي (اختياري، YouTube)

### النصوص
- [ ] وصف قصير (Short description): حتى 80 حرف
- [ ] وصف كامل (Full description): حتى 4000 حرف
- [ ] What's new: حتى 500 حرف
- [ ] التصنيف: **Productivity**
- [ ] التقييم العمري: **3+** (يتم تحديده عبر استبيان)

### قبل الضغط على Publish
- [ ] اختبار التطبيق على Internal Testing track أولاً
- [ ] إصلاح أي تحذيرات في Pre-launch report
- [ ] التأكد من عدم استخدام صلاحيات غير مُعلَنة
- [ ] سياسة الخصوصية متاحة عبر URL ثابت
- [ ] لا توجد مكتبات بحاجة Privacy Disclosure إضافي

---

## 📂 هيكل المشروع

```
notes_app/
├── lib/
│   ├── main.dart                    # نقطة الدخول
│   ├── core/
│   │   ├── constants/               # الثوابت العامة
│   │   ├── theme/                   # الثيمات
│   │   └── services/                # الخدمات (مصادقة، نسخ احتياطي، تصدير)
│   ├── data/
│   │   ├── models/                  # نماذج البيانات
│   │   └── repositories/            # طبقة الوصول للبيانات
│   └── presentation/
│       ├── screens/                 # شاشات التطبيق
│       ├── widgets/                 # ويدجتس قابلة لإعادة الاستخدام
│       └── providers/               # مزودات الحالة
├── android/
│   └── app/
│       ├── build.gradle             # إعدادات البناء
│       └── src/main/
│           ├── AndroidManifest.xml
│           └── res/                 # الموارد
├── assets/
│   ├── icons/                       # الأيقونات
│   └── fonts/                       # الخطوط
├── docs/
│   └── privacy_policy.md            # سياسة الخصوصية
├── pubspec.yaml
└── README.md
```

---

## 🐛 حل المشاكل الشائعة

### خطأ "Hive adapter not found"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### مشكلة في AndroidX
في `android/gradle.properties` تأكد من:
```
android.useAndroidX=true
android.enableJetifier=true
```

### حجم AAB كبير
- استخدم `--obfuscate --split-debug-info=./debug-info`
- تأكد من `shrinkResources true` و `minifyEnabled true`

### رفض Google Play بسبب Data Safety
- راجع جميع الحزم في `pubspec.yaml`
- بعض الحزم قد تجمع بيانات تلقائياً (مثل Firebase)
- نحن لا نستخدم أي منها في هذا التطبيق ✅

---
