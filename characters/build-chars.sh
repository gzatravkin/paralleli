#!/bin/bash
# Раскладывает кадры персонажей из _src в candidates/<id>/<анимация>_<n>.png
# Плавание там, где его нет в паке, синтезируется из позы БЕГА наклоном на -55°.
set -u
cd "$(dirname "$0")"
S="_src"; OUT="candidates"
rm -rf "$OUT"; mkdir -p "$OUT"

# f <id> <анимация> <файл>... — копирует кадры под нужным именем
f(){ local id=$1 an=$2; shift 2; local i=0
  mkdir -p "$OUT/$id"
  for src in "$@"; do
    [ -f "$src" ] || { echo "  !! нет $src"; continue; }
    magick "$src" -trim +repage "$OUT/$id/${an}_${i}.png" 2>/dev/null
    i=$((i+1))
  done
}
# swimfrom <id> <кадр>... — синтез плавания: поза бега, наклонённая на -55°.
# Позу ЛАЗАНЬЯ поворачивать нельзя: она нарисована со спины и читается как падение лицом вниз.
swimfrom(){ local id=$1; shift; local i=0
  for src in "$@"; do
    [ -f "$src" ] || continue
    magick "$src" -trim +repage -background none -rotate -55 \
      "$OUT/$id/swim_${i}.png" 2>/dev/null
    i=$((i+1))
  done
}

PC="$S/k_platformer-characters/PNG"
TC="$S/k_toon-characters"
PAD="$S/k_platformer-art-deluxe/Base pack/Player"
OGA="$S/oga"

echo "== Kenney Platformer Characters (полный набор, есть плавание)"
for c in Adventurer:adventurer Soldier:soldier Player:player Female:female; do
  d="${c%%:*}"; n="${c##*:}"; id="pc-$n"; P="$PC/$d/Poses"
  f "$id" idle  "$P/${n}_idle.png" "$P/${n}_stand.png"
  f "$id" walk  "$P/${n}_walk1.png" "$P/${n}_idle.png" "$P/${n}_walk2.png" "$P/${n}_idle.png"
  f "$id" jump  "$P/${n}_jump.png" "$P/${n}_fall.png"
  f "$id" climb "$P/${n}_climb1.png" "$P/${n}_climb2.png"
  f "$id" swim  "$P/${n}_swim1.png" "$P/${n}_swim2.png"
  echo "  $id"
done

echo "== Kenney Toon Characters (8 кадров ходьбы, плавание синтезировано)"
for c in "Male adventurer:maleAdventurer:tc-male-adv" "Male person:malePerson:tc-male-person" \
         "Female person:femalePerson:tc-female-person" "Female adventurer:femaleAdventurer:tc-female-adv"; do
  d=$(echo "$c"|cut -d: -f1); n=$(echo "$c"|cut -d: -f2); id=$(echo "$c"|cut -d: -f3)
  P="$TC/$d/PNG/Poses"
  f "$id" idle  "$P/character_${n}_idle.png"
  f "$id" walk  "$P/character_${n}_walk0.png" "$P/character_${n}_walk1.png" \
                "$P/character_${n}_walk2.png" "$P/character_${n}_walk3.png" \
                "$P/character_${n}_walk4.png" "$P/character_${n}_walk5.png" \
                "$P/character_${n}_walk6.png" "$P/character_${n}_walk7.png"
  f "$id" run   "$P/character_${n}_run0.png" "$P/character_${n}_run1.png" "$P/character_${n}_run2.png"
  f "$id" jump  "$P/character_${n}_jump.png" "$P/character_${n}_fall.png"
  f "$id" climb "$P/character_${n}_climb0.png" "$P/character_${n}_climb1.png"
  swimfrom "$id" "$P/character_${n}_run0.png" "$P/character_${n}_run1.png" "$P/character_${n}_run2.png"
  echo "  $id"
done

echo "== Kenney Platformer Art Deluxe (11 кадров ходьбы, нет лазанья/плавания)"
for p in p1 p2 p3; do
  id="pad-$p"; W="$PAD/${p}_walk/PNG"
  f "$id" idle "$PAD/${p}_stand.png"
  f "$id" walk "$W/${p}_walk01.png" "$W/${p}_walk02.png" "$W/${p}_walk03.png" "$W/${p}_walk04.png" \
               "$W/${p}_walk05.png" "$W/${p}_walk06.png" "$W/${p}_walk07.png" "$W/${p}_walk08.png" \
               "$W/${p}_walk09.png" "$W/${p}_walk10.png" "$W/${p}_walk11.png"
  f "$id" jump "$PAD/${p}_jump.png"
  echo "  $id"
done

echo "== Kenney Simplified Platformer (минимализм, есть лазанье)"
SP="$S/k_simplified-platformer-pack/PNG/Characters"
f "sp-char" idle  "$SP/platformChar_idle.png"
f "sp-char" walk  "$SP/platformChar_walk1.png" "$SP/platformChar_idle.png" "$SP/platformChar_walk2.png" "$SP/platformChar_idle.png"
f "sp-char" jump  "$SP/platformChar_jump.png"
f "sp-char" climb "$SP/platformChar_climb1.png" "$SP/platformChar_climb2.png"
swimfrom "sp-char" "$SP/platformChar_walk1.png" "$SP/platformChar_walk2.png"
echo "  sp-char"

echo "== OGA: Big Eyes Boy (мультяшный контур, только бег+прыжок)"
B="$OGA/z_bigeyesboy/PNG Images Sequences"
mkdir -p "$OUT/oga-bigeyesboy"
i=0; for n in 000 002 004 006 008 010; do s="$B/run/running_$n.png"
  [ -f "$s" ] && { magick "$s" -trim +repage -resize x200 "$OUT/oga-bigeyesboy/walk_$i.png" 2>/dev/null; i=$((i+1)); }; done
i=0; for n in 000 004 008; do s="$B/jump/jump_$n.png"
  [ -f "$s" ] && { magick "$s" -trim +repage -resize x200 "$OUT/oga-bigeyesboy/jump_$i.png" 2>/dev/null; i=$((i+1)); }; done
magick "$B/run/running_000.png" -trim +repage -resize x200 "$OUT/oga-bigeyesboy/idle_0.png" 2>/dev/null
echo "  oga-bigeyesboy"

echo "== OGA: Caveman (пиксель, готовые GIF: бег/прыжок/лазанье/траверс)"
mkdir -p "$OUT/oga-caveman"
cp "$OGA/cavemanrun1ani.gif"     "$OUT/oga-caveman/walk.gif"    2>/dev/null
cp "$OGA/cavemanjump1ani.gif"    "$OUT/oga-caveman/jump.gif"    2>/dev/null
cp "$OGA/cavemanclimb1.gif"      "$OUT/oga-caveman/climb.gif"   2>/dev/null
cp "$OGA/cavemanshimmey1ani.gif" "$OUT/oga-caveman/shimmy.gif"  2>/dev/null
echo "  oga-caveman"

echo "== OGA: Forest Boy (пиксель 24x24, лист спрайтов)"
mkdir -p "$OUT/oga-forestboy"
cp "$OGA/forestboy.png" "$OUT/oga-forestboy/sheet.png" 2>/dev/null
cp "$OGA/classichero.png" "$OUT/oga-forestboy/../classic-hero-sheet.png" 2>/dev/null
echo "  oga-forestboy"

echo
echo "ГОТОВО: $(ls -d $OUT/*/ | wc -l) персонажей, $(find $OUT -type f | wc -l) файлов, $(du -sh $OUT|cut -f1)"
