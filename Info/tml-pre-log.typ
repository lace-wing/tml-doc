#set text(
  font:(
    "Noto Sans SC",
  )
)

#let c-green = green.darken(30%)
#let c-orange = orange.darken(30%)
#let c-red = red.darken(30%)
#let c-blue = blue.darken(30%)

#let info(body) = {
  text(fill: c-green)[#body]
}
#let reminder(body) = {
  text(fill: c-orange)[#body]
}
#let warning(body) = {
  text(fill: c-red)[*#body*]
}

#show link: set text(fill: c-blue, style: "italic")

#align(center)[
  #text(weight: "bold", size: 20pt)[
    tModLoader 更新日志
  ]
]

#h(5%)

== 为爆炸物添加数组 ProjectileID.Sets.PlayerHurtDamageIgnoresDifficultyScaling
by ChickenBones 已合并 \
*Pull Request*：#link("https://github.com/tModLoader/tModLoader/pull/3796") \
*更新至 Preview*：已完成 \
*更新至 Stable*：2023/10/01 08:00 \
*运行时破坏性*：#info[*无*] \
*代码破坏性*：#info[*无*]

== Short Summary
- 原版 `friendly` 的爆炸物现将 `ProjectileID.Sets.PlayerHurtDamageIgnoresDifficultyScaling[Type]` 设为 `true`。
- 此更新修复了炸弹之类爆炸物在专家或大师模式下造成巨额伤害的问题。
- 模组需要在玩家产生的炸弹、手雷和火箭等的 `SetStaticDefaults` 做出相同的改动，_如果_ 它们有“友方伤害”的话。
