# Kristal

Flutter ilə yazılmış 8x8 blok tapmacası oyunu. Tam offline, hesab tələb etmir, reklam yoxdur.

## Nədir?

Kristal — klassik 1010 / Block Blast tipli tapmacadır. 8x8 lövhəyə 3 təsadüfi fiqur yerləşdirirsən, dolu sətir və sütunlar silinir, xal toplayırsan. Fiqurlar fırlanmır.

Əsas fərq: **ağıllı fiqur generatoru** və **dinamik çətinlik**. Oyun səni izləyir — yaxşı oynayanda sərtləşir, çətinlikdə qalanda kömək edir. Amma həmişə yox.

## Xüsusiyyətlər

- 8x8 lövhə, 3 fiqur, sürüşdürmə ilə yerləşdirmə
- Ağıllı generator: xal artdıqca böyük və yöndəmsiz fiqurlar artır
- Dinamik çətinlik əyrisi (performans əsaslı)
- Combo sistemi, full-clear bonusu
- Xilasedici məntiq: lövhə dolanda bəzən asan fiqur gəlir
- CustomPainter ilə şüşə effektli bloklar (şəkil faylı yoxdur)
- 60 FPS, aşağı büdcəli Android cihazlarda axıcı
- Yalnız portret
- Tam offline (shared_preferences ilə saxlama)

## Planlaşdırılan Rejimlər

- Klassik
- Gündəlik çağırış (tarixdən seed → eyni lövhə hər kəs üçün)
- Macəra rejimi (hədəfli səviyyələr, buzlu bloklar)
- Mövzular: Kristal, Meşə, Gecə
- Xüsusi bloklar: bomba, buz, bağlı

## Texniki Stack

- Flutter (stable)
- Riverpod (state management)
- shared_preferences (yaddaş)
- CustomPainter (bütün qrafika)
- GitHub Actions (APK / AAB build)

Xarici şəkil və səs faylı yoxdur. Reklam yoxdur. İnternet tələb olunmur.

## Qovluq Strukturu
