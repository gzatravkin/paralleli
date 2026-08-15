# Звук: лицензии и авторы

Всё аудио в `audio/candidates/` — free-to-use. Ниже разбивка по строгости требований.
Файл нужен для страницы игры на джеме: секцию «Требуют указания» скопировать туда целиком.

**Kenney** (kenney.nl) — CC0, атрибуция не требуется. Из его паков взято большинство SFX:
impact-sounds, interface-sounds, digital-audio, sci-fi-sounds, rpg-audio, music-jingles, ui-audio.

## Не требуют указания (CC0) — можно ничего не писать

- **aquinn** — CC0 — https://opengameart.org/content/space-winds
- **bart** — CC0 — https://opengameart.org/content/steam-release-sounds
- **cleytonkauffman** — CC0 — https://opengameart.org/content/exploration-theme
- **cynicmusic** — CC0 — https://opengameart.org/content/aquaria
- **cynicmusic** — CC0 — https://opengameart.org/content/icy-realm-seven-and-eight
- **cynicmusic** — CC0 — https://opengameart.org/content/mysterious-ambience-song21
- **haeldb** — CC0 — https://opengameart.org/content/creepy-forest-f
- **jaggedstone** — CC0 — https://opengameart.org/content/loopable-dungeon-ambience
- **joth** — CC0 — https://opengameart.org/content/black-diamond
- **joth** — CC0 — https://opengameart.org/content/contemplation-0
- **joth** — CC0 — https://opengameart.org/content/near-and-far
- **loyalty-freak-music** — CC0 — https://opengameart.org/content/balance-0
- **qubodup** — CC0 — https://opengameart.org/content/20-rustles-dry-leaves
- **qubodup** — CC0 — https://opengameart.org/content/4-dry-snow-steps
- **qubodup** — CC0 — https://opengameart.org/content/atmospheric-puzzles
- **qubodup** — CC0 — https://opengameart.org/content/dripping-water-loop
- **rubberduck** — CC0 — https://opengameart.org/content/40-cc0-water-splash-slime-sfx
- **spring-spring** — CC0 — https://opengameart.org/content/fire-level
- **subspaceaudio** — CC0 — https://opengameart.org/content/horror-atmosphere
- **synth-thetic** — CC0 — https://opengameart.org/content/beyond-the-frozen-veil
- **yd** — CC0 — https://opengameart.org/content/dungeon-ambience

## Требуют указания (CC-BY) — обязательны в титрах

- **alexandr-zhelanov** — CC-BY 4.0 — https://opengameart.org/content/iron-wasteland
- **alexandr-zhelanov** — CC-BY 4.0 — https://opengameart.org/content/nice-place-in-pa-wastland
- **hencefox** — CC-BY 3.0 — https://opengameart.org/content/appalachian-sunrise
- **jadewizard** — CC-BY 4.0 — https://opengameart.org/content/fire-maze
- **jc-sounds** — CC-BY 4.0 — https://opengameart.org/content/jc-sounds-nature-ambient-pack-vol-1
- **mega-pixel-music-lab** — CC-BY 3.0 — https://opengameart.org/content/tower-of-lava
- **moondanny** — CC-BY 3.0 — https://opengameart.org/content/melancholy-piano-theme
- **peastman** — CC-BY 3.0 — https://opengameart.org/content/the-ice-cavern
- **snabisch** — CC-BY 3.0 — https://opengameart.org/content/among-machines
- **syncopika** — CC-BY 3.0 — https://opengameart.org/content/forest
- **tad** — CC-BY 3.0 — https://opengameart.org/content/abandoned-metropolis
- **tad** — CC-BY 4.0 — https://opengameart.org/content/cold-lake
- **tausdei** — CC-BY 3.0 — https://opengameart.org/content/chill-jungle-ambient
- **terrazon** — CC-BY 3.0 — https://opengameart.org/content/0-k

## Вирусная лицензия (CC-BY-SA / GPL) — для джема ок, для коммерции заменить

- **jdagenet** — CC-BY-SA 3.0 — https://opengameart.org/content/core
- **p0ss** — CC-BY-SA 3.0 — https://opengameart.org/content/spell-sounds-starter-pack
- **remaxim** — CC-BY-SA 3.0 — https://opengameart.org/content/nature-theme-sketch

## Что это значит на практике

- **CC0** — берём и не думаем. Можно менять, продавать, не указывать автора.
- **CC-BY** — использовать можно как угодно, но имя автора обязано быть в титрах игры.
- **CC-BY-SA / GPL** — кроме имени автора требует, чтобы производные шли под той же лицензией.
  Для джем-билда безопасно. Если игра пойдёт в продажу — эти три звука
  (переход «Варп», «Телепорт», «Пружина», «Заморозка» из Spell Sounds Starter Pack)
  надо будет заменить на CC0-аналоги.

## Исходники

- Полные (необрезанные) файлы: `audio/_src/`
- Кандидаты для прослушивания: `audio/candidates/`
- Пересобрать кандидатов: `bash audio/build-candidates.sh`
