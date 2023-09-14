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

= Extra Jump API
by absoluteAquarian 已合并 \
*Pull Request*：#link("https://github.com/tModLoader/tModLoader/pull/3552") \
*tModLoader 版本*：2023.07.1.24 \
*更新至 Preview*：已完成 \
*更新至 Stable*：2023/10/01 08:00 \
*运行时破坏性*：#reminder[微（用IL实现二段跳的模组可能会炸）] \
*代码破坏性*：#info[无]

== 简要总结
- 新增类型 `ExtraJump` 给模组自定义跳跃。
- `Player` 新增了字段和方法给模组控制跳跃（包括原版的）的开关与刷新。
- `ModPlayer` 新增了调整原版和模组跳跃的钩子。
- 更多信息参见 Example Mod 和 PR。
