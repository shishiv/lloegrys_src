**Interações _bin/ — Uses Elements (IDs 40210–40216)**

- Escopo: varredura completa no diretório `_bin/`.
- Filtros: `40210`, `40211`, `40213`, `40214`, `40215`, `40216` e as chaves "Uses <Element> - <ID>".

**Uses Fire - 40210**
- _bin/data/actions/scripts/spellbooks/scorching_ray.lua:10 — `elestr = 40210`
- _bin/data/actions/scripts/spellbooks/flame_wave.lua:10 — `elestr = 40210`
- _bin/data/actions/scripts/spellbooks/firebolt.lua:10 — `elestr = 40210`
- _bin/data/actions/scripts/spellbooks/fireball.lua:10 — `elestr = 40210`
- _bin/data/actions/scripts/spellbooks/blizzard.lua:11 — `negstr = 40210`
- _bin/data/actions/scripts/spellbooks/water_gush.lua:11 — `negstr = 40210`
- _bin/data/actions/scripts/spellbooks/stream_of_mana.lua:11 — `negstr = 40210`
- _bin/data/actions/scripts/spellbooks/freezing_palm.lua:11 — `negstr = 40210`
- _bin/data/Storage List.lua:342 — `Uses Fire - 40210`

**Uses Water - 40211**
- _bin/data/actions/scripts/spellbooks/water_gush.lua:10 — `elestr = 40211`
- _bin/data/actions/scripts/spellbooks/stream_of_mana.lua:10 — `elestr = 40211`
- _bin/data/actions/scripts/spellbooks/freezing_palm.lua:10 — `elestr = 40211`
- _bin/data/actions/scripts/spellbooks/scorching_ray.lua:11 — `negstr = 40211`
- _bin/data/actions/scripts/spellbooks/flame_wave.lua:11 — `negstr = 40211`
- _bin/data/actions/scripts/spellbooks/firebolt.lua:11 — `negstr = 40211`
- _bin/data/actions/scripts/spellbooks/fireball.lua:11 — `negstr = 40211`
- _bin/data/Storage List.lua:343 — `Uses Water - 40211`

**Uses Earth - 40213**
- _bin/data/actions/scripts/spellbooks/wrath_of_nature.lua:10 — `elestr = 40213`
- _bin/data/actions/scripts/spellbooks/tremor.lua:10 — `elestr = 40213`
- _bin/data/actions/scripts/spellbooks/regrowth.lua:10 — `elestr = 40213`
- _bin/data/actions/scripts/spellbooks/acid_blast.lua:10 — `elestr = 40213`
- _bin/data/actions/scripts/spellbooks/erupting_thunder.lua:11 — `negstr = 40213`
- _bin/data/actions/scripts/spellbooks/static_shock.lua:11 — `negstr = 40213`
- _bin/data/actions/scripts/spellbooks/wind_gale.lua:11 — `negstr = 40213`
- _bin/data/actions/scripts/spellbooks/twister.lua:11 — `negstr = 40213`
- _bin/data/Storage List.lua:344 — `Uses Earth - 40213`

**Uses Wind - 40214**
- _bin/data/actions/scripts/spellbooks/wind_gale.lua:10 — `elestr = 40214`
- _bin/data/actions/scripts/spellbooks/twister.lua:10 — `elestr = 40214`
- _bin/data/actions/scripts/spellbooks/static_shock.lua:10 — `elestr = 40214`
- _bin/data/actions/scripts/spellbooks/erupting_thunder.lua:10 — `elestr = 40214`
- _bin/data/actions/scripts/spellbooks/wrath_of_nature.lua:11 — `negstr = 40214`
- _bin/data/actions/scripts/spellbooks/tremor.lua:11 — `negstr = 40214`
- _bin/data/actions/scripts/spellbooks/acid_blast.lua:11 — `negstr = 40214`
- _bin/data/Storage List.lua:345 — `Uses Wind - 40214`

**Uses Holy - 40215**
- _bin/data/actions/scripts/spellbooks/smite.lua:10 — `elestr = 40215`
- _bin/data/actions/scripts/spellbooks/repel_evil.lua:10 — `elestr = 40215`
- _bin/data/actions/scripts/spellbooks/heal.lua:10 — `elestr = 40215`
- _bin/data/actions/scripts/spellbooks/greater_healing.lua:10 — `elestr = 40215`
- _bin/data/actions/scripts/spellbooks/sudden_death.lua:11 — `negstr = 40215`
- _bin/data/actions/scripts/spellbooks/necrotic_impulse.lua:11 — `negstr = 40215`
- _bin/data/actions/scripts/tools/testing.lua:9 — `--player:setStorageValue(40215, 1)`
- _bin/data/Storage List.lua:346 — `Uses Holy - 40215`

**Uses Death - 40216**
- _bin/data/actions/scripts/spellbooks/sudden_death.lua:10 — `elestr = 40216`
- _bin/data/actions/scripts/spellbooks/necrotic_impulse.lua:10 — `elestr = 40216`
- _bin/data/actions/scripts/spellbooks/body_to_mind.lua:10 — `elestr = 40216`
- _bin/data/actions/scripts/spellbooks/smite.lua:11 — `negstr = 40216`
- _bin/data/actions/scripts/spellbooks/repel_evil.lua:11 — `negstr = 40216`
- _bin/data/actions/scripts/spellbooks/heal.lua:11 — `negstr = 40216`
- _bin/data/actions/scripts/spellbooks/greater_healing.lua:11 — `negstr = 40216`
- _bin/data/actions/scripts/tools/testing.lua:8 — `--player:setStorageValue(40216, -1)`
- _bin/data/Storage List.lua:347 — `Uses Death - 40216`

**Observações**
- Entradas em `testing.lua` estão comentadas (uso de exemplo/teste).
- As referências `elestr` e `negstr` indicam, respectivamente, storage principal e storage oposto/negativo usado pelos scripts dos spellbooks.
