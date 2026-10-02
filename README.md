# Kristal

[![Build](https://github.com/arefhna/kristal/actions/workflows/build.yml/badge.svg)](https://github.com/arefhna/kristal/actions/workflows/build.yml)

Flutter ilə yazılmış 8x8 blok tapmacası oyunu. Tam offline, hesab tələb etmir, reklam yoxdur.

## Nədir?

Kristal — klassik 1010 / Block Blast tipli tapmacadır. 8x8 lövhəyə 3 təsadüfi fiqur yerləşdirirsən, dolu sətir və sütunlar silinir, xal toplayırsan. Fiqurlar fırlanmır.

Əsas fərq: **ağıllı fiqur generatoru** və **dinamik çətinlik**. Oyun oyunçunu izləyir — yaxşı oynayanda sərtləşir, çətinlikdə qalanda kömək edir. Amma həmişə yox.

## Rejimlər

- **Klassik** — 8x8 lövhə, 3 fiqur, sonsuz oyun
- **Gündəlik çağırış** — hər gün eyni seed, eyni lövhə (hər kəs üçün)
- **Macəra** — 3 dünya × 10 səviyyə = 30 hədəfli səviyyə, buzlu bloklar, ulduzlar

## Xüsusiyyətlər

- 8x8 lövhə, 3 fiqur, sürüşdürmə ilə yerləşdirmə
- Ağıllı generator: xal artdıqca böyük və yöndəmsiz fiqurlar artır
- Dinamik çətinlik əyrisi (performans əsaslı)
- Combo sistemi (5.0x-a qədər), full-clear bonusu
- Xilasedici məntiq: lövhə dolanda bəzən asan fiqur gəlir
- CustomPainter ilə şüşə effektli bloklar (şəkil faylı yoxdur)
- Animasiyalar: blok parıltısı, sətir dalğası, hissəciklər, ekran titrəməsi
- 23 nailiyyət, 5 mövzu (Kristal, Meşə, Gecə, Günəş, Okean)
- Gündəlik seriya (streak) sayğacı
- 60 FPS, aşağı büdcəli Android cihazlarda axıcı
- Yalnız portret, tam offline

## Texniki Stack

- Flutter (stable)
- Riverpod (state management)
- shared_preferences (yaddaş)
- CustomPainter (bütün qrafika)
- GitHub Actions (APK / AAB build)

Xarici şəkil və səs faylı yoxdur. Reklam yoxdur. İnternet tələb olunmur.

## Qovluq Strukturu
