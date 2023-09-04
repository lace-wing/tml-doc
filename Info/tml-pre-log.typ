#set text(
      font:(
	"Noto Sans SC",
      )
    )

#let c-green = green.darken(30%)
#let c-yellow = yellow.darken(30%)
#let c-red = red.darken(30%)
#let c-blue = blue.darken(30%)
#let c-text(content, color) = {
  text(strong(content), fill: color)
}

#align(center)[
  #text(weight: "bold", size: 20pt)[
    tModLoader 更新日志
  ]
]

#h(5%)

= 重命名钩子 `(Mod|Global)Projectile.Kill` 为 `OnKill`
by *jopojelly* 已合并 \
*Pull Request*：#link("https://github.com/tModLoader/tModLoader/pull/3770") \
*更新至 Preview*：`2023/09/01 08:00` \
*更新至 Stable*：`2023/10/01 08:00` \
*运行时破坏性*：#c-text("无", c-green) \
*代码破坏性*：#c-text("可由 tModPorter 完成", c-blue)

== 简要总结
- `(Mod|Global)Projectile.Kill` 重命名为了 `OnKill`，与类似钩子保持相同的命名规律。

== 迁移提示
- 运行 tModPorter 或手动重命名。
