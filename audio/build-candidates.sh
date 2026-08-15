#!/bin/bash
# Собирает папку candidates/ из скачанных исходников (_src).
# Всё, что тут делается — обратимо: исходники не трогаются.
set -u
cd "$(dirname "$0")"
SRC="_src"
K="$SRC/kenney_"
OGA="$SRC/oga"
OUT="candidates"
rm -rf "$OUT"; mkdir -p "$OUT/sfx" "$OUT/music"

Q="-c:a libmp3lame -b:a 160k -ar 44100 -ac 2"
n=0
# cp1 <src> <name> — просто перегнать в mp3 с нормализацией пика
cp1(){ ffmpeg -v error -y -i "$1" -af "afade=t=in:st=0:d=0.005,volume=2.0,alimiter=level_in=1:level_out=0.9" $Q "$OUT/sfx/$2.mp3" 2>/dev/null && { echo "  sfx $2"; n=$((n+1)); }; }
# cpf <src> <name> <filter> — с доп. фильтром
cpf(){ ffmpeg -v error -y -i "$1" -af "$3,alimiter=level_in=1:level_out=0.9" $Q "$OUT/sfx/$2.mp3" 2>/dev/null && { echo "  sfx $2"; n=$((n+1)); }; }

echo "== 1. ПЕРЕХОД В ПАРАЛЛЕЛЬНЫЙ МИР (composites)"
# A "МАШИНА": энергия набирает -> низкий удар -> хвост поля
ffmpeg -v error -y -i "${K}sci-fi-sounds/Audio/forceField_000.ogg" \
  -i "${K}sci-fi-sounds/Audio/lowFrequency_explosion_000.ogg" \
  -i "${K}sci-fi-sounds/Audio/doorOpen_000.ogg" \
  -filter_complex "[0]volume=1.1,afade=t=out:st=0.85:d=0.15[a];\
[1]adelay=750|750,volume=1.0[b];\
[2]adelay=800|800,volume=0.7,highpass=f=300[c];\
[a][b][c]amix=inputs=3:duration=longest:normalize=0,\
alimiter=level_in=1:level_out=0.92,afade=t=out:st=2.3:d=0.5" \
  -c:a libmp3lame -b:a 160k "$OUT/sfx/shift__machine.mp3" && echo "  sfx shift__machine"

# B "КРИСТАЛЛ": восходящий трезвучный зап -> тяжёлый колокол с эхом
ffmpeg -v error -y -i "${K}digital-audio/Audio/zapThreeToneUp.ogg" \
  -i "${K}impact-sounds/Audio/impactBell_heavy_000.ogg" \
  -filter_complex "[0]volume=0.85[a];\
[1]adelay=950|950,volume=1.0,aecho=0.7:0.6:180|420:0.35|0.2[b];\
[a][b]amix=inputs=2:duration=longest:normalize=0,\
alimiter=level_in=1:level_out=0.92" \
  -c:a libmp3lame -b:a 160k "$OUT/sfx/shift__crystal.mp3" && echo "  sfx shift__crystal"

# C "ВЫДОХ": реверс-риз (обратный хвост) -> мягкий удар -> шум-хвост
ffmpeg -v error -y -i "${K}impact-sounds/Audio/impactPlate_heavy_000.ogg" \
  -i "${K}sci-fi-sounds/Audio/forceField_003.ogg" \
  -i "${K}sci-fi-sounds/Audio/computerNoise_001.ogg" \
  -filter_complex "[0]areverse,volume=0.8,afade=t=in:st=0:d=0.4[a];\
[1]adelay=550|550,volume=1.0[b];\
[2]adelay=650|650,volume=0.35,lowpass=f=4000[c];\
[a][b][c]amix=inputs=3:duration=longest:normalize=0,\
alimiter=level_in=1:level_out=0.92" \
  -c:a libmp3lame -b:a 160k "$OUT/sfx/shift__breath.mp3" && echo "  sfx shift__breath"

# D сток без сборки
cp1 "${K}sci-fi-sounds/Audio/forceField_004.ogg"   shift__stock-field
cp1 "$OGA/z_spell-sounds-starter-pack/warp.ogg"    shift__stock-warp
cp1 "$OGA/z_spell-sounds-starter-pack/teleport.ogg" shift__stock-teleport

echo "== 2. ОСЕВЫЕ ОТТЕНКИ одного и того же перехода (доказательство: 1 ассет -> 27 миров)"
B="$OUT/sfx/shift__machine.mp3"
AX="-c:a libmp3lame -b:a 160k"
# ТЕМПЕРАТУРА
ffmpeg -v error -y -i "$B" -af "asetrate=44100*1.18,aresample=44100,highpass=f=350,treble=g=5,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__temp-frost.mp3"
ffmpeg -v error -y -i "$B" -af "asetrate=44100*0.85,aresample=44100,lowpass=f=3200,bass=g=6,acrusher=level_in=1:level_out=1:bits=10:mode=log,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__temp-heat.mp3"
# ЭПОХА
ffmpeg -v error -y -i "$B" -af "lowpass=f=1400,vibrato=f=3.2:d=0.25,volume=1.4,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__era-past.mp3"
ffmpeg -v error -y -i "$B" -af "aecho=0.8:0.85:70|180|420:0.5|0.35|0.2,treble=g=4,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__era-future.mp3"
# РАСТИТЕЛЬНОСТЬ
ffmpeg -v error -y -i "$B" -af "lowpass=f=2600,highpass=f=180,volume=1.2,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__plants-decay.mp3"
ffmpeg -v error -y -i "$B" -af "chorus=0.6:0.9:55:0.4:0.25:2,bass=g=3,alimiter=level_out=0.9" $AX "$OUT/sfx/axis__plants-lush.mp3"
echo "  6 осевых вариантов"

echo "== 3. ХОДЬБА (по 6 шагов в темпе ходьбы — иначе не оценить)"
walk(){ # walk <name> <f0> <f1> <f2> <f3> <f4> <f5>
  local nm=$1; shift
  ffmpeg -v error -y -i "$1" -i "$2" -i "$3" -i "$4" -i "$5" -i "$6" \
   -filter_complex "[0]adelay=0|0[a];[1]adelay=340|340[b];[2]adelay=680|680[c];\
[3]adelay=1020|1020[d];[4]adelay=1360|1360[e];[5]adelay=1700|1700[f];\
[a][b][c][d][e][f]amix=inputs=6:duration=longest:normalize=0,volume=2.2,alimiter=level_out=0.9" \
   -c:a libmp3lame -b:a 160k "$OUT/sfx/$nm.mp3" && echo "  sfx $nm"
}
IM="${K}impact-sounds/Audio"
walk step__stone   $IM/footstep_concrete_00{0,1,2,3,4}.ogg $IM/footstep_concrete_001.ogg
walk step__ice     $IM/footstep_snow_00{0,1,2,3,4}.ogg     $IM/footstep_snow_002.ogg
walk step__grass   $IM/footstep_grass_00{0,1,2,3,4}.ogg    $IM/footstep_grass_003.ogg
walk step__wood    $IM/footstep_wood_00{0,1,2,3,4}.ogg     $IM/footstep_wood_001.ogg
RP="${K}rpg-audio/Audio"
walk step__leather $RP/footstep0{0,1,2,3,4}.ogg $RP/footstep05.ogg
cp1 "$OGA/4-dry-snow-steps.mp3"   step__snow-oga
cp1 "$OGA/20-rustles-dry-leaves.mp3" step__leaves-oga

echo "== 4. ПРЫЖОК / ПРИЗЕМЛЕНИЕ"
D="${K}digital-audio/Audio"; IF="${K}interface-sounds/Audio"; UI="${K}ui-audio/Audio"
cp1 "$D/phaserUp1.ogg"        jump__phaser
cp1 "$D/pepSound3.ogg"        jump__pep
cp1 "$IF/pluck_001.ogg"       jump__pluck
cpf "$RP/cloth2.ogg"          jump__cloth "volume=6.0"
cp1 "$IF/maximize_006.ogg"    jump__maximize
cpf "$IM/impactSoft_medium_000.ogg" land__soft "volume=2.5"
cpf "$IM/impactPlate_light_002.ogg" land__plate "volume=2.5"
cpf "$IM/footstep_concrete_003.ogg" land__boot "asetrate=44100*0.8,aresample=44100,volume=3.0"

echo "== 5. ЯДРО ДЕВАЙСА НАЙДЕНО (крупная награда)"
MJ="${K}music-jingles/Audio"
cp1 "$MJ/Steel jingles/jingles_STEEL10.ogg"      core__steel
cp1 "$MJ/Hit jingles/jingles_HIT08.ogg"          core__hit
cp1 "$MJ/8-Bit jingles/jingles_NES09.ogg"          core__nes
cp1 "$MJ/Sax jingles/jingles_SAX11.ogg"    core__sax
ffmpeg -v error -y -i "$D/powerUp5.ogg" -i "$MJ/Steel jingles/jingles_STEEL04.ogg" \
 -filter_complex "[0]volume=1.0[a];[1]adelay=260|260,volume=1.0[b];[a][b]amix=inputs=2:duration=longest:normalize=0,alimiter=level_out=0.92" \
 -c:a libmp3lame -b:a 160k "$OUT/sfx/core__powerup-steel.mp3" && echo "  sfx core__powerup-steel"

echo "== 6. ИГРУШКА / СЛЕД РЕБЁНКА (мелкая награда, тёплая)"
cp1 "$MJ/Pizzicato jingles/jingles_PIZZI04.ogg"  toy__pizzicato
cp1 "$MJ/Pizzicato jingles/jingles_PIZZI12.ogg"  toy__pizzicato2
cp1 "$IF/confirmation_002.ogg"                   toy__confirm
cp1 "$IF/glass_003.ogg"                          toy__glass
cp1 "$D/pepSound2.ogg"                           toy__pep
cpf "$IM/impactBell_heavy_002.ogg"               toy__bell "asetrate=44100*1.35,aresample=44100,volume=1.6"

echo "== 7. ОТКАЗ / ЗАПЕРТО"
cp1 "$IF/error_004.ogg"    denial__error
cp1 "$IF/bong_001.ogg"     denial__bong
cp1 "$IF/question_002.ogg" denial__question
cpf "$IM/impactWood_heavy_001.ogg" denial__thud "volume=2.5"

echo "== 8. ДВЕРЬ: КРУТИМ ОСЬ (±1) и ВХОД"
cp1 "$UI/switch18.ogg"        dial__switch
cp1 "$IF/toggle_002.ogg"      dial__toggle
cp1 "$RP/metalClick.ogg"      dial__metal
cp1 "$IF/tick_002.ogg"        dial__tick
cp1 "${K}sci-fi-sounds/Audio/doorOpen_001.ogg" door__scifi
cp1 "$RP/doorOpen_1.ogg"                       door__rpg
cp1 "$IF/open_002.ogg"                         door__interface

echo "== 9. РАСТЕНИЯ: ПРУЖИНА, ЛАЗАНЬЕ · ГЕЙЗЕР · ВОДА"
cp1 "$OGA/z_spell-sounds-starter-pack/spring.ogg" bounce__spring
cp1 "$D/pepSound5.ogg"                            bounce__pep
cpf "$IM/impactSoft_heavy_002.ogg"                bounce__soft "asetrate=44100*1.25,aresample=44100,volume=2.5"
cpf "$RP/cloth4.ogg"                              climb__cloth "volume=6.0"
cpf "$OGA/z_steam-release-sounds/steam hisses - Marker #1.wav" geyser__steam "volume=2.0"
cp1 "${K}sci-fi-sounds/Audio/thrusterFire_001.ogg" geyser__thruster
W="$OGA/z_40-cc0-water-splash-slime-sfx"
cp1 "$W/splash_03.ogg"    water__splash
cp1 "$W/splash_11.ogg"    water__splash2
cp1 "$W/loop_water_01.ogg" water__swim-loop
cpf "$OGA/z_spell-sounds-starter-pack/freeze.ogg" ice__freeze "volume=1.5"

echo "== 10. ФИНАЛ / РЕБЁНОК НАЙДЕН · UI"
cp1 "$MJ/Steel jingles/jingles_STEEL16.ogg"      final__steel
cp1 "$MJ/Sax jingles/jingles_SAX16.ogg"    final__sax
cp1 "$MJ/Pizzicato jingles/jingles_PIZZI16.ogg"  final__pizzicato
cp1 "$UI/click3.ogg"          ui__click
cp1 "$IF/maximize_002.ogg"    ui__map-open
cp1 "$IF/minimize_002.ogg"    ui__map-close

echo
echo "== МУЗЫКА: превью 45с (полные файлы лежат в _src/oga)"
# mus <src> <name> <start>
mus(){ [ -f "$1" ] || { echo "  !! нет $1"; return; }
  ffmpeg -v error -y -ss "${3:-15}" -t 45 -i "$1" \
   -af "afade=t=in:st=0:d=1.5,afade=t=out:st=43:d=2,loudnorm=I=-18:TP=-1.5:LRA=11" \
   -c:a libmp3lame -b:a 128k -ar 44100 -ac 2 "$OUT/music/$2.mp3" 2>/dev/null \
   && echo "  mus $2" || echo "  !! сбой $2"; }

mus "$OGA/atmospheric-puzzles.ogg"            bed__atmospheric-puzzles 10
mus "$OGA/contemplation-0.mp3"                bed__contemplation 10
mus "$OGA/near-and-far.mp3"                   bed__near-and-far 5
mus "$OGA/balance-0.mp3"                      bed__balance 20
mus "$OGA/exploration-theme.ogg"              bed__exploration 15
mus "$OGA/mysterious-ambience-song21.mp3"     bed__mysterious 5
mus "$OGA/dungeon-ambience.ogg"               bed__dungeon 5

mus "$OGA/beyond-the-frozen-veil.ogg"         cold__frozen-veil 20
mus "$OGA/black-diamond.mp3"                  cold__black-diamond 20
mus "$OGA/the-ice-cavern.ogg"                 cold__ice-cavern 10
mus "$OGA/0-k.mp3"                            cold__0k 20
mus "$OGA/cold-lake.mp3"                      cold__cold-lake 20
mus "$OGA/icy-realm-seven-and-eight.mp3"      cold__icy-realm 20

mus "$OGA/fire-level.mp3"                     heat__fire-level 10
mus "$OGA/fire-maze.mp3"                      heat__fire-maze 5
mus "$OGA/tower-of-lava.mp3"                  heat__tower-of-lava 30
mus "$OGA/iron-wasteland.ogg"                 heat__iron-wasteland 20
mus "$OGA/among-machines.mp3"                 heat__among-machines 20
mus "$OGA/core.mp3"                           heat__core 20

mus "$OGA/horror-atmosphere.ogg"              decay__post-apoc 20
mus "$OGA/space-winds.mp3"                    decay__space-winds 5
mus "$OGA/nice-place-in-pa-wastland.ogg"      decay__pa-wasteland 20
mus "$OGA/dripping-water-loop.mp3"            decay__dripping 2
mus "$OGA/loopable-dungeon-ambience.ogg"      decay__dungeon-amb 5

mus "$OGA/jc-sounds-nature-ambient-pack-vol-1.mp3" lush__jc-nature 5
mus "$OGA/chill-jungle-ambient.flac"          lush__chill-jungle 20
mus "$OGA/forest.mp3"                         lush__forest 15
mus "$OGA/creepy-forest-f.ogg"                lush__creepy-forest 20
mus "$OGA/appalachian-sunrise.mp3"            lush__appalachian 20

mus "$OGA/melancholy-piano-theme.mp3"         story__melancholy-piano 5
mus "$OGA/abandoned-metropolis.mp3"           story__abandoned-metropolis 20
mus "$OGA/medieval-fantasy-ambient-music-nimuehs-gift.mp3" story__nimuehs-gift 20
mus "$OGA/nature-theme-sketch.wav"            story__nature-sketch 5
mus "$OGA/aquaria.mp3"                        story__aquaria 10

echo
echo "ГОТОВО: $(ls "$OUT/sfx" | wc -l) sfx, $(ls "$OUT/music" | wc -l) music, $(du -sh "$OUT" | cut -f1)"
