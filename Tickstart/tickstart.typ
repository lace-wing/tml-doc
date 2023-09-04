#let asset = "./Assets/"
#let c-red = red.darken(30%)
#let c-blue = blue.darken(30%)
#let c-green = green.darken(30%)
#let c-yellow = yellow.darken(30%)

#show link: set text(style: "italic", fill: blue.darken(30%))
#show cite: set text(fill: olive.darken(30%))
#show ref: set text(fill: teal.darken(30%))
#show bibliography: set heading(numbering: "1.")

#set text(
  font: (
    "Noto Sans SC"
  ),
  size: 12pt
)
#set par(
  first-line-indent: 0pt,
)
#set heading(numbering: "1.")
#show heading: it => {
  it
  v(1%)
}

#set document(title: "tModLoader 1.4.4 From Scratch", author: "Lacewing")

#v(25%)

#align(center, text(
    weight: "bold",
    size: 24pt,
  )[
    从零开始的 1.4.4 tModLoader
  ]
)

#align(center)[
  by Lacewing
]

#v(2%)

#align(center)[
  #block(width: 60%, height: 18.5%, fill: red.lighten(67%), inset: 16pt)[
    本文默认你了解：
    - 基础计算机操作
    - _泰拉瑞亚_/_Terraria_（游戏）
    - _Steam_（游戏平台）

    本文仅涉及在电脑端使用 Steam 平台的情况 \
    不会介绍其他场景，也不会介绍盗版
  ]
]

#v(2%)

#pagebreak()

#outline(depth: 2, title: "目录")

#pagebreak()

= tModLoader 简介

== 什么是 tModLoader
<what-tml>

tModLoader，是游戏泰拉瑞亚（Terraria）的模组加载器，其名称来源于 \[T\]erraria \[Mod\] \[Loader\]。
若无说明，本文中提到的 tModLoader 指对应泰拉瑞亚版本 #text(fill: c-green)[1.4.4] 的 tModLoader。

== 什么是模组

模组，译自游戏领域中的“mod”，即“\[mod\]ification”，而非一般语境下的“module”。
模组是对原版游戏的改动，可以增加、修改或删除内容。

== 为什么要 tModLoader
<why-tml>

原版的泰拉瑞亚没有加载模组的功能，而 tModLoader 提供了模块化加载模组的方法。
要想游玩模组，就需要使用 tModLoader 加载。

虽然有其他的模组加载器和其他使用模组的方法，但综合表现均不如 tModLoader，故本文不做介绍。

== 怎样获取 tModLoader

在 Steam 上购买泰拉瑞亚后，tModLoader 可以作为其模组加载器下载并安装。

详细步骤将在下一节中介绍。

#pagebreak()

= 获取 tModLoader

== 前置要求

- 电脑，无需高配
- 64位操作系统
- 正版泰拉瑞亚
- 网络连接

对于国内玩家，若出现无法连接 Steam 之类的情况，请考虑使用加速器或其他手段。

== 安装 Steam

Steam 是一个游戏平台。
基础部分中，泰拉瑞亚和 tModLoader 都将从此平台获取。

=== 从官网获取

+ 访问 Steam 的官方网站 #link("https://store.steampowered.com/about/")
+ 点击按钮 “安装 STEAM”，之后网站应尝试下载 Steam 的安装程序
+ 运行刚刚下载的安装包并根据提示操作

#text(fill: c-yellow)[注意：有许多诈骗软件/网站将自己伪装成 Steam，请从官方渠道获取 Steam]

=== 从包管理器获取

- Windows：`winget install -e --id Valve.Steam`
- macOS：`brew install --cask steam`（需要 `homebrew`）
- Linux：使用对应的包管理器获取

之后根据提示操作。

== 安装泰拉瑞亚

若未在 Steam 购买泰拉瑞亚，在 Steam 商店中搜索“Terraria”，找到名称一致的游戏并购买。
#text(fill: c-yellow)[购买游戏需花钱，请根据自身经济情况量力而行。]

如果你认为价格太高，也可以添加至愿望单，在打折时购买。

安装好泰拉瑞亚后，启动游戏让它完成一些设置，以便之后运行 tModLoader。

== 安装 tModLoader

在 Steam 商店中搜索“tModLoader”，找到名称一致的模组（头图右上角有“MOD”标识）并加入库中。
安装好 tModLoader 后，就可以尝试启动了。
