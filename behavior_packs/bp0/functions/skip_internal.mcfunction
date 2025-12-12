# Internal skip cutscene logic - jumps to actual end points

# Show help if no specific cutscene is detected
execute if score .act global matches ..0 run tellraw @s {"rawtext":[{"text":"§6현재 진행 중인 컷신이 없습니다."}]}

# Detect current cutscene and skip to actual end
execute unless score .act global matches ..0 run tellraw @a {"rawtext":[{"text":"§e"},{"selector":"@s"},{"text":"§a님이 컷신을 완전히 스킵했습니다."}]}

## Act 0 - Lobby Cutscenes (모든 로비 인트로 한번에 스킵)
execute if score .act global matches 1 if score .seq global matches 1..2419 run scoreboard players set .seq global 2420
execute if score .act global matches 1 if score .seq global matches 1..2419 run tellraw @a {"rawtext":[{"text":"§6모든 로비 인트로를 스킵했습니다. 게임 선택으로 이동합니다."}]}

execute if score .act global matches 2 if score .seq global matches 1..349 run scoreboard players set .seq global 350  
execute if score .act global matches 2 if score .seq global matches 1..349 run tellraw @a {"rawtext":[{"text":"§6모든 로비 인트로를 스킵했습니다. 게임 선택으로 이동합니다."}]}

execute if score .act2 global matches 3 if score .seq global matches 1..999 run scoreboard players set .seq global 1000
execute if score .act2 global matches 3 if score .seq global matches 1..999 run tellraw @a {"rawtext":[{"text":"§6모든 로비 인트로를 스킵했습니다. 게임 선택으로 이동합니다."}]}

## Act 1 - Orb Ambush Cutscene (카운트다운 직전으로)
execute if score .act global matches 101 if score .seq global matches 1..659 run scoreboard players set .seq global 650
execute if score .act global matches 101 if score .seq global matches 1..659 run tellraw @a {"rawtext":[{"text":"§6Orb Ambush 컷신을 스킵했습니다. 카운트다운이 시작됩니다."}]}

## Act 2 - Craft Off Cutscenes (카운트다운 직전으로)
execute if score .act global matches 200 if score .seq global matches 1..1099 run scoreboard players set .seq global 1030
execute if score .act global matches 200 if score .seq global matches 1..1099 run tellraw @a {"rawtext":[{"text":"§6Craft Off 인트로를 스킵했습니다. 카운트다운이 시작됩니다."}]}

execute if score .act global matches 201 if score .seq global matches 1..1099 run scoreboard players set .seq global 1030
execute if score .act global matches 201 if score .seq global matches 1..1099 run tellraw @a {"rawtext":[{"text":"§6Craft Off 라운드 1을 스킵했습니다. 카운트다운이 시작됩니다."}]}

execute if score .act global matches 202 if score .seq global matches 1..2099 run scoreboard players set .seq global 1700
execute if score .act global matches 202 if score .seq global matches 1..2099 run tellraw @a {"rawtext":[{"text":"§6Craft Off 라운드 2를 스킵했습니다. 카운트다운이 시작됩니다."}]}

## Act 3 - Grid Wars Cutscene (카운트다운 직전으로)
execute if score .act global matches 301 if score .seq global matches 1..1099 run scoreboard players set .seq global 1090
execute if score .act global matches 301 if score .seq global matches 1..1099 run tellraw @a {"rawtext":[{"text":"§6Grid Wars 컷신을 스킵했습니다. 카운트다운이 시작됩니다."}]}
execute if score .act global matches 301 if score .seq global matches 1090 run function utility/games/grid/garden_blocks_reset

## Act 4 - Nock it Off Cutscene (카운트다운 직전으로)
execute if score .act global matches 401 if score .seq global matches 1..539 run scoreboard players set .seq global 539
execute if score .act global matches 401 if score .seq global matches 1..539 run tellraw @a {"rawtext":[{"text":"§6Nock it Off 컷신을 스킵했습니다. 카운트다운이 시작됩니다."}]}
execute if score .act global matches 401 if score .seq global matches 539 run function utility/games/nock/respawn_targets
execute if score .act global matches 401 if score .seq global matches 539 run function utility/games/nock/player_loadout
execute if score .act global matches 401 if score .seq global matches 539 run function utility/games/nock/upper_rail_active
execute if score .act global matches 401 if score .seq global matches 539 run inputpermission set @a[tag=!admin] movement disabled
execute if score .act global matches 401 if score .seq global matches 539 run inputpermission set @a[tag=!admin] camera disabled

## Act 5 - Elytra Rumble Cutscene (카운트다운 직전으로 - 임시)
execute if score .act global matches 501 if score .seq global matches 1..1099 run scoreboard players set .seq global 1090
execute if score .act global matches 501 if score .seq global matches 1..1099 run tellraw @a {"rawtext":[{"text":"§6Elytra Rumble 컷신을 스킵했습니다. 카운트다운이 시작됩니다."}]}

## Act 6 - Finale Showdown Cutscene (카운트다운 직전으로 - 임시)
execute if score .act global matches 601 if score .seq global matches 1..949 run scoreboard players set .seq global 950
execute if score .act global matches 601 if score .seq global matches 1..949 run tellraw @a {"rawtext":[{"text":"§6Finale Showdown 컷신을 스킵했습니다. 카운트다운이 시작됩니다."}]}

# Force immediate cutscene cleanup - 권한 문제 해결
execute unless score .act global matches ..0 unless score .act global matches 501 run camera @a set minecraft:first_person
execute unless score .act global matches ..0 if score .act global matches 501 run camera @a set minecraft:third_person
execute unless score .act global matches ..0 run camera @a clear
execute unless score .act global matches ..0 run hud @a reset
# 중요: movement는 admin만, camera는 모든 플레이어에게 (블록 파괴 방지하면서 카메라는 허용)
execute unless score .act global matches ..0 unless score .act global matches 401 run inputpermission set @a[tag=admin] movement enabled
execute unless score .act global matches ..0 run inputpermission set @a camera enabled