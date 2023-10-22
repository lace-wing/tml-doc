# 模组内置本地化

本文将讲解如何为模组内置本地化支持<br>

## 使用HJSON

### 文件结构

`Localization`文件夹中的`.hjson`文件用于存放内置的本地化文本
`.hjson`文件的结构是: 
```
Mods: 
{
  MyMod: 
  {
    MyKey1: 
    {
      MyKey2: "MyText"
    }
  }
}
```
其中, `Mods`是固定的, `MyMod`是对应模组的类名, `MyKey`是剩下的键, 依情况而定, `MyText`是要显示的内容

### 使用自动加载的键

tML为模组准备了一些自动加载的键, 包括: 
- `ItemName`, 物品名称
- `ItemDescription`, 物品描述
- `BuffName`, Buff名称
- `BuffDescription`, Buff描述
- `ProjectileName`, 射弹名称
- `NPCName`, NPC名称
- `TownNPCMood`, 城镇NPC的各个心情
  - 具体结构为: `NPCClassName.MoodName`
  - 各个心情分别为: 
    - `Content`, 满足
    - `NoHome`, 无家可归
    - `LoveSpace`, 足够的私人空间
    - `FarFromHome`, 离家过远
    - `DislikeCrowded`, 过于拥挤
    - `HateCrowded`, 太拥挤啦
    - `LikeBiome`, 喜欢生物群系
    - `LoveBiome`, 热爱生物群系
    - `DislikeBiome`, 讨厌生物群系
    - `HateBiome`, 憎恨生物群系
    - `LikeNPC`, 喜欢某人
    - `LoveNPC`, 爱慕某人
    - `DislikeNPC`, 讨厌某人
    - `HateNPC`, 憎恨某人
- `InfoDisplayName`, 信息名称 (就是手机在屏幕右部的那些信息)
- `DamageClassName`, 伤害类型名称
- `Prefix`, 物品前缀名称
- `BiomeName`, 生物群系名称
- `GameTips`, 游戏提示 (加载页面下部的小提示)
- `MapObject`, 鼠标停留在地图物块上显示的名称 (需配合`CreateMapEntryName()`使用)

要使用这些键, 只需要在`.hjson`文件中写好对应的条目, 但是`SetStaticDefaults()`中的方法会覆盖这些值

注意: 在tML的[issue#3074](https://github.com/tModLoader/tModLoader/issues/3074)完成后, `.hjson`文件结构与自动加载的键将会发生改变

### 使用自定义的键

除了上述自动加载的键, 你还可以使用自定义的键<br>
从`.hjson`中加载文本的方法有 (`using Terraria.Localization`): 
- `Language.GetTextValue(string key, object[] args)`
- `Language.GetTextValueWith(string key, params object[] args)`
最常用的方法是`GetTextValue`, `key`为HJSON条目的键, 如`Mods.MyMod.CustomKey1.CustomKey2`, `args`为需要传入的变量, 后面会讲到

### HJSON值特殊写法

如果要使用特殊写法, 值需要以`""`或` ``` ``` `包裹

#### 转义

有时, 我们需要显示`*`, `""`, `\`等文本, 但它们已经有特殊的含义, 不会被直接显示<br>
此时我们需要用`\`转义符号, 将其置于需要转义的符号之前<br>
例: `MyKey: ""Hammer time!""`会报错, 但`MyKey: "\"Hammer time!\""`会显示`"Hammer time!"`

#### 换行

通常, 我们使用`\n`来换行, 但在HJSON中, 你可以: 
````
MyKey: 
  ```
  Line1
  Line2
  ```
````
而无需使用`\n`

请注意, 以` ``` ``` `包裹的值无需再转义

#### 显示颜色

你可以使用`[c/color:text]`来调整文本的颜色<br>
其中, `color`是颜色的html颜色代码, `text`是要显示的文本

#### 显示变量

有时, 我们需要根据实际情况显示一个变量当前的值, 而不是显示固定的文本<br>
这时, 可以使用`Language.GetTextValue(string key, object[] args)`, 将需要的变量以`args`传入<br>
而在HJSON的值中使用`{index}`来插入对应的变量<br>
这在应对中英文不同语法和习惯的情况时也很有用<br>
下面是一个使用例: 
````
// 对应文件中从HJSON文件加载文本的方法
Language.GetTextValue("MyKey", Player.name, DamageDealt)
````
````
# en-US.hjson里的写法
MyKey: "Player {0} has dealt {1} damage!"
````
````
# zh-Hans.hjson里的写法
MyKey: "{0}已经造成了{1}点伤害!"
````
你也可以使用`Language.GetTextValueWith(string key, params object[] args)`, 此时HJSON里所写的是传入变量的变量名: 
````
// 对应文件中从HJSON文件加载文本的方法
string name = npc.GivenName
Language.GetTextValueWith("MyKey", name, DamageDealt)
````
````
# zh-Hans.hjson里的写法
MyKey: "{name}已经造成了{DamageDealt}点伤害!"
````

#### 显示物品图标

你可以使用`[i:ItemID]`或`[i:ItemClassName]`来显示物品<br>
其中, `ItemID`是物品的`type`, `ItemClassName`是物品的类名

你还可以使用`[i/pPrefixID:ItemID]`来显示带前缀的物品<br>
其中, `PrefixID`是前缀的`type`

你还可以使用`[i/sStack:ItemID]`来显示一定堆叠数量的物品<br>
其中, `Stack`是堆叠数

#### 显示键位

你可以使用`<KeybindName>`来显示键位<br>
其中, `KeybindName`是键位的名称<br>
例: `MyKey: "<right>以使用特殊攻击"`

#### 引用HJSON条目

你可以使用`{$Key}`来引用HJSON条目<br>
例: 
````
Common: 
{
  Sleep: "sleep"
}
Action: 
{
  WhatIsThis: 
  {
    Bed: "{$Common.Sleep}!"
  }
}
````

---施工中---