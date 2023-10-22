# 伤害性减益

泰拉瑞亚的**伤害性减益**指那些会造成生命流失的debuff<br>
它们将NPC或玩家的受伤计数器`lifeRegenTime`设为0, 将正的生命回复速率`lifeRegen`设为0再减去一个值以达到生命流失的效果<br>
在生命回复计数器`lifeRegenCount`正常变化的情况下(每帧+1/-1), 每秒生命回复是生命回复速率`lifeRegen`的一半, 如`lifeRegen = -12`时, 每秒流失6点生命<br>
关于这一段的更详细的介绍, 见[泰拉瑞亚中文Wiki][TrWikiZhLifeRegen]

下面是原版中所有的伤害性减益及其详细信息, 你也可以参阅这个[更简略的列表][TrWikiZhBuffID]

| ID | 英文名 | 中文名 | 内部名 | `lifeRegen` | 生效范围 | 备注 |
| - | - | - | - | - | - | - |
| 24 | On Fire! | 着火了！ | `OnFire` | -8 | 玩家, NPC |  |
| 323 | Hellfire | 狱炎 | `OnFire3` | -8/-30 | 玩家/NPC | 1.4.4许多原本施加着火了!东西改为施加狱炎 |
| 44 | Frostburn | 霜火<br>霜冻 | `Frostburn` | -16 | 玩家, NPC |  |
| 324 | Frostbite | 霜噬<br>冻伤 | `Frostburn2` | -16/-50 | 玩家/NPC |  |
| 39 | Cursed Inferno | 诅咒焰<br>诅咒狱火 | `CursedInferno` | -24/-48 | 玩家/NPC |  |
| 153 | Shadowflame | 暗影焰 | `ShadowFlame` | -30 | NPC | 是的, 不影响玩家 |
| 189 | Daybroken | 破晓 | `Daybreak` | -200 | NPC | 不影响涂油 |
| 67 | Burning | 燃烧 | `Burning` | -60 | 玩家 | 不影响涂油<br>Wiki有误, 是-60而非-100 |
| 20 | Poisoned | 中毒 | `Poisoned` | -4/-12 | 玩家/NPC | 1.4.4提升了对NPC的效果 |
| 70 | Acid Venom | 酸性毒液 | `Venom` | -30/-60 | 玩家/NPC |  |
| 169 | Penetrated | 穿透 | `BoneJavelin` | -6 | NPC | 根据NPC身上的骨钉数量提升生命流失倍率 |
| 337 | (Tentacle Spike) | (触手钉) | `TentacleSpike` | -6 | NPC | 根据NPC身上的触手钉数量提升生命流失倍率 |
| 344 | Blood Butchered | 血腥屠宰 | `BloodButcherer` | -8 | NPC | 根据NPC身上的血腥钉数量提升生命流失倍率 |
| 144 | Electrified | 带电 | `Electrified` | -8 | 玩家 | 玩家按住左/右方向键时, 改为-32 |
| 186 | Dryad's Bane | 树妖祸害 | `DryadsWardDebuff` | -8 | NPC | 随游戏进度与难度提升生命流失速率 |
| 68 | Suffocation | 窒息 | `Suffocation` | -40 | 玩家 |  |
| 30 | Bleeding | 流血 | `Bleeding` | (无效果) | 玩家 | `lifeRegenTime = 0f`, 不受蜂蜜, 心灯等影响 |
| 38 | The Tongue | 狂卷之舌 | `TheTongue` | -100 | 玩家 |  |
| 183 | Celled | (细胞感染) | `StardustMinionBleed` | -40 | NPC | 根据NPC身上的小星尘细胞数量提升生命流失倍率<br>中文Wiki有误, 可以与其它减益伤害叠加 |
| 334 | Starving | 极饿 | `Starving` | 生命上限/50 | 玩家 |  |
| 151 | Life Drain | 生命吸取<br>夺命杖 | `SoulDrain` | -50 | NPC | 是的, 虽然它是个增益, 但对于NPC它是伤害性的 |
| 204 | Oiled | 涂油 | `Oiled` | -50 | NPC | 只在NPC有着火了!/狱炎/霜火/霜噬/诅咒焰/暗影焰时生效<br>若同时有多个上述减益, 仍-50而不叠加 |


[TrWikiZhLifeRegen]: https://terraria.wiki.gg/zh/wiki/%E7%94%9F%E5%91%BD%E5%86%8D%E7%94%9F
[TrWikiZhBuffID]: https://terraria.wiki.gg/zh/wiki/%E5%A2%9E%E7%9B%8A_ID