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

= 堆石器支持
by *GeorgeFeldy* 已合并 \
*Pull Request*：#link("https://github.com/tModLoader/tModLoader/pull/3568") \
*更新至 Preview*：已完成 \
*更新至 Stable*：2023/10/01 08:00 \
*运行时破坏性*：#info[无] \
*代码破坏性*：#info[无]

== 简要总结
- 模组现在可以给#link("https://terraria.wiki.gg/wiki/Rubblemaker")[堆石器]添加物块。
