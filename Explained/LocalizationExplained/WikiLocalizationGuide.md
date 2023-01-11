# 什么是本地化?
本地化使得与作者使用不同语言的玩家也能畅玩模组. 每一条用户可能在游玩时看见的文本都被储存在一种叫做本地化文件的文本文件里. 举个例子, ExampleMod有个物品叫做 "纸飞机", 但在英语中叫 "Paper Airplane". 通过本地化, 无论是汉语还是英语的使用者都可以看懂, 而不需要先去学一门语言. 

这些本地化文件很容易制作, 使得不懂编程的人也能翻译模组. 然后作者便可以将这些翻译加入模组中, 允许更多人游玩. (译注: 而无需加载翻译补丁)

此指南将涵盖模组作者需要知道的本地化专题教程. 如果你想要翻译一个已有的模组, 或者是翻译tML本身, 请参阅[贡献本地化](https://github.com/tModLoader/tModLoader/wiki/Contributing-Localization).

# 从1.4.3迁移到1.4.4
从tMLv2023.01开始, 所有的本地化都在`.hjson`文件中完成. 不再支持在代码中声明翻译 (译注: 然而可以硬写文本). 这项改动将大幅精简改良本地化管理并使翻译模组更简单. 如果你对逻辑层面的改动更感兴趣的话, 参阅[重大本地化改动建议](https://github.com/tModLoader/tModLoader/issues/3074). 

**如果你没在使用Git或其它形式的版本控制的话, 建议在迁移之前备份好你的模组.**

## 在1.4.3生成本地化文件
首先, 我们需要一个较 "老" 的tML来导出本地化文件. 用Steam将tML的测试版调至`无`. ([切换tML版本的教程](https://github.com/tModLoader/tModLoader/wiki/Basic-tModLoader-Usage-FAQ#switch-to-stable-tmodloader-or-to-preview-tmodloader))

切换至正确的版本后, 启动游戏, 启用模组, 然后进入`开发模组`菜单. 在模组列表里找到你的模组. 你会看到一个绿色箭头按钮, 鼠标停留于其上时显示 "Export 1.4.4+ localization files", 点它.  
![image](https://user-images.githubusercontent.com/4522492/210681409-a659670d-5908-4e5d-bd45-74c0545f4666.png)  
现在去到`ModSources`文件夹, 然后是你模组里的`Localization`文件夹. 你将会看到新生成的`.hjson.new`文件:  
![image](https://user-images.githubusercontent.com/4522492/210681629-8aad2234-bd56-40c8-b03f-7e36b98d4486.png)  
在文本编辑器里打开上述文件, 确认一下它们都是好的. 原有`.hjson`里的条目和新生成的条目都应该在新文件里. 如果一切正常, 下一步. 

## 切换至1.4.4并生成模组
用Steam将tML的测试版调至`1.4-preview`. ([切换tML版本的教程](https://github.com/tModLoader/tModLoader/wiki/Basic-tModLoader-Usage-FAQ#switch-to-stable-tmodloader-or-to-preview-tmodloader))

启动tML后, 你会发现你的模组 (大概你启用的其它模组也会) 加载失败, 这是正常现象. 进入`开发模组`菜单并点击 "Run tModPorter" 按钮. 这会将过时的本地化方法连同其它过时内容一起移除 (译注: 但这并不能解决所有问题, 该手动改的还是逃不过的).  
![image](https://user-images.githubusercontent.com/4522492/210683375-43816104-2812-4db2-bac6-813ebb47a089.png)  
在此之后, 你应该用`hjson.new`文件替换现有的`.hjson`文件. 删除`.hjson`文件并将`.hjson.new`重命名为`.hjson`文件 (如果你不能修改文件扩展名, 你需要先[启用 "文件扩展名"](https://gfycat.com/TheseSameGrasshopper))

现在, 你可能需要打开VS, 修复剩下的问题. 修好以后, 你就可以重新生成你的模组. 确保一切正常后, 你就可以在模组源码里搜索`// Tooltip.SetDefault("这是一个模组物品.");`和`// DisplayName.SetDefault("示例剑");`之类的东西, 删掉. 它们不再有用了. (你可以在项目中的所有文件搜索`.SetDefault(`以轻松找到这些该删的代码)

# 本地化如何运作
从物品名字到主菜单文字, 每一条文本都使用本地化. 游戏里的每一条文本实际上是一对数据: 一个 "键" 和一个 "值" ("键值对"). 举个例子, 当玩家创建一个小世界时, 游戏用键`UI.WorldSizeSmall`来寻找当前语言的对应翻译, 若为汉语则显示 "小", 若为英语, 游戏依然会寻找键`UI.WorldSizeSmall`, 但此时它的值就不一样了, 是 "Small". 由于泰拉瑞亚的作者用英语写代码, 大部分原版的本地化键很接近它们在英语下的值. 

在tML中, 模组使用`.hjson`文件来整齐地存放本地化的键与值. 每一种语言有它自己的`.hjson`文件. 如果你熟悉JSON, 那么[HJSON](https://hjson.github.io)用起来也不会陌生. 

下面是一个简单的示例: 

文件名: **tModLoader/ModSources/ExampleMod/zh-Hans.hjson**
```
Mods: {
	ExampleMod: {
		Items: {
			ExampleItem: {
				DisplayName: 示例物品
				Tooltip: 这是一个模组物品.
			}
		}
	}
}
```

在上面这个例子中, 我们可以找到两个概念: (本地化) 键和 (本地化) 值. 键从`:`号左侧每一级的文本组合而来. `:`号右侧则是值. 这个例子传达了两个键和它们对应的值: `Mods.ExampleMod.Items.ExampleItem.Displayname`对应`示例物品`, `Mods.ExampleMod.Items.ExampleItem.Tooltip`对应`这是一个模组物品.`. 如果这些语法看起来很复杂 (译注: 别担心, 后面有常用且更复杂且的), 别担心, tML会自动更新这些文件的. 

当模组被加载时, tML会寻找当前语言下的所有本地化文件并将它们储存在内存中. 需要向玩家显示文本时, 就用一个键去储存的数据里查询并检索出正确的文本. 翻译以`LocalizedText`对象的形式存储于内存中. 模组作者可以用方法`Language.GetText`以键获取`LocalizedText`对象. `LocalizedText`的`Value`属性可获取其中的本地化值. 另外, 方法`Language.GetTextValue`直接由键返回值: 

```cs
string hivePackDialogue = Language.GetTextValue("Mods.ExampleMod.Dialogue.ExampleTravelingMerchant.HiveBackpackDialogue"); // 直接返回要显示的文本, string
或
string hivePackDialogue = Language.GetText("Mods.ExampleMod.Dialogue.ExampleTravelingMerchant.HiveBackpackDialogue").Value; // 返回LocalizedText, 使用其Value属性获取string
或
LocalizedText hivePackDialogueLocalizedText = Language.GetText("Mods.ExampleMod.Dialogue.ExampleTravelingMerchant.HiveBackpackDialogue"); // 返回LocalizedText
string hivePackDialogue = hivePackDialogueLocalizedText.Value; // 将其Value赋值给新声明的string
```

## 本地化键
tML会自动为大多数内容分配键. 这些键的模板是`Mods.{模组名}.{类别}.{内容名}.{数据名}`, `模组名`是是模组的内部名称 (类名), `类别`依内容的类型而定, `内容名`是内容的内部名 (一般是类名), `数据名`指明了该类中的键. 

例如`ModItem`有叫`Items`的`类别`. 它也有两条数据, 分别是`DisplayName`和`Tooltip`. 如果一个叫`ExampleMod`的模组加入了一个类名为`ExampleItem`的`ModItem`, 上述两个键会生成在`.hjson`文件里: `Mods.ExampleMod.Items.ExampleItem.DisplayName`和`Mods.ExampleMod.Items.ExampleItem.Tooltip`. 

译注: 关于自动分配的键, 可以参考本仓库的[内置本地化指南](https://github.com/lyc-Lacewing/tMLAllInOne/blob/master/Explained/LocalizationExplained/InternalLocalization.md)

### 自定义键
如果你有许多描述相同的物品, 你可以令它们的描述指向同一个键. 要这么做, 重写描述属性并返回你要的`LocalizedText`: 
```cs
public override LocalizedText Tooltip => Language.GetText("Mods.ExampleMod.Common.SomeSharedTooltip"); // 将该类的Tooltip属性重写为你需要的LocalizedText
```
如果你有其它的物品继承此类, 你只需要在此基类中重写描述. 当然, 如果有需要, 你还可以在子类中继续重写. 

## 文本换元
如果你的本地化文件里有重复出现的文本, 或你想要使用游戏里已有的文本, 你可以使用换元来保持文件整洁. 在值中使用`{$Key}`来换元. 当游戏加载时, 这一段将会被替换为其`Key`所指的文本. 

比如说, 游戏里已经有 "右键以打开" 的翻译, 储存在键`CommonItemTooltip.RightClickToOpen`中. 模组可以使用换元复用它的值. HJSON条目`Tooltip: "{$CommonItemTooltip.RightClickToOpen}"`将被展示为用户语言的 "右键以打开" 翻译. 其它已有翻译, 诸如物品名称和常用描述也都可以这样使用. 

模组内的翻译也可以换元. 比如[示例模组本地化文件](https://github.com/tModLoader/tModLoader/blob/1.4/ExampleMod/Localization/en-US.hjson)中的例子, `DisplayName: "{$Mods.ExampleMod.Common.PaperAirplane}"`就复用了键`Mods.ExampleMod.Common.PaperAirplane`对应的翻译. 

## 格式化字符串
模组作者可以使用[字符串格式化](https://learn.microsoft.com/en-us/dotnet/api/system.string.format?view=net-7.0#insert-a-string)在翻译中给要填的文本留出空位. 这是个C#的普通特性. 你可以用方法`string.Format`或`Language.GetTextValue`来格式化字符串. 

## 聊天标签
本地化值中可以加入颜色和物品图标等 (译注: 参见本仓库的[内置本地化指南](https://github.com/lyc-Lacewing/tMLAllInOne/blob/master/Explained/LocalizationExplained/InternalLocalization.md)) 聊天标签. 参考[示例模组的本地化文件](https://github.com/tModLoader/tModLoader/blob/1.4/ExampleMod/Localization/en-US.hjson)中的`ExampleTooltipsItem`. 

# 自动更新本地化
tML会在有新内容或本地化键加入时自动更新`.hjson`文件. 英语的文件`en-US.hjson`将会被用作其它语言的模板, 注释和排版将会被自动继承. 

## 加入新内容
当模组作者向模组中添加内容时, 就拿一个`ModItem`来说, 一开始并没有被本地化. 模组作者应该生成并重载模组. 一旦重载完成, `.hjson`文件将会自动更新. 英语的文件`en-US.hjson`会包含所有新内容的默认本地化条目. 非英语的文件也会包含一样的条目, 但是都被注释掉了. 为了进行本地化, 需要修改`.hjson`文件, 填入翻译, 保存 (译注: 记得以`UTF-8`编码保存), 重新生成并加载. 

## HJSON语法
`.hjson`文件包含HJSON数据. 与JSON相似, 但是可读性更高. 详细语法参见[Hjson官网](https://hjson.github.io/), 但你也可以看看下面的示例初步了解一下. 

## 注释
`.hjson`文件可以包含多种注释. tML用两种Hjson注释表达不同的含义. 

以`#`开头的注释可被用做提示. 它们需要被置于对应的键的上一行. 否则就有可能在本地化文件自动更新后消失或错位. 

例: 
```
...
			ExampleCanStackItem: {
				DisplayName: Example CanStack Item: 礼物袋
				# 引用一个指向游戏语言对应的 "右键以打开" 文本的键
				Tooltip: "{$CommonItemTooltip.RightClickToOpen}"
			}
...
```

英语文件中的此类注释会被自动复制进其它语言的文件, 可以用于向译者说明情况. 

以`/* */`包裹或以`//`开头的注释被tML用于指示非英语文件中未翻译的键. 译者可以将标出的值翻译并移除注释. 模组作者**不应该**将它们作为常规注释, 因为它们可能在自动更新时丢失. 

## 前缀
模组作者可以使用一种特殊文件名格式让文件中所有的本地化条目共享同一个前缀. 此特性最常见的用途是省去`Mod.模组名`条目. 这样该文件就少了几层缩进也更容易编辑了. 绝大部分模组不会用到它们本模组前缀以外的值. 

比如说, 一个名为`Localization/en-US_Mods.ExampleMod.hjson`的文件会继承`Mods.ExampleMod`, 意味着此文件里的所有条目可以省去`Mods`和`ExampleMod`, 直接从下一级开始. 

前缀的格式遵循以下规则: 首先以文件夹, 再是以下划线分隔. 语言确定以后, 剩下的部分将被作为前缀. 下面的这些例子都是用于汉语且以`Mods.ExampleMod`作为前缀的文件名. 

```
Localization/zh-Hans_Mods.ExampleMod.hjson
Localization/zh-Hans/Mods.ExampleMod.hjson
zh-Hans_Mods.ExampleMod.hjson
zh-Hans/Mods.ExampleMod.hjson
Localization/CoolBoss_zh-Hans_Mods.ExampleMod.hjson
```

## 多个同语言文件
模组作者可以用多个`.hjson`文件来管理翻译 (尤其是当本地化条目非常多时). 假设有一个内含`en-US_Mods.ExampleMod.Items.hjson`和`en-US_Mods.ExampleMod.hjson`的模组, 文件`en-US_Mods.ExampleMod.Items.hjson`可以存放所有物品的本地化条目, 其它文件放剩下的本地化条目. 新增内容的本地化条目会被自动添加进*含有与其最相似条目的*`.hjson`文件. 

如果你要分开本地化文件, 仅需编辑英语的文件再重新生成并加载模组. 其它语言的文件将会自动调整为相同的布局. 

# 手动添加键
新内容的本地化条目会自动添加进`.hjson`文件里, 但也可以添加自定义的键. 

## 自定义键
要添加自定义的键, 遵循HJSON语法即可直接向本地化文件中添加. 比如, ExampleMod有一个叫做 "Common" 的类别, 因为没有被tML的类型所使用, 其中的条目都是被手动添加的. 

## 自定义字段
模组作者可以向他们的类中添加`LocalizedText`属性. 下面的例子向一个`ModItem`类中加入了属性: 

```cs
public LocalizedText 随便什么信息 => this.GetOrRegisterLocalization(nameof(随便什么信息), () => "");
```

在代码的其它地方, 该属性可被用于向用户显示本地化的文本: 

```cs
Main.NewText(Language.GetTextValue(this.GetLocalizationKey("随便什么信息")));
```

# 添加新语言
默认情况下, tML仅会为模组生成tML认为模组支持的语言的本地化文件要添加新语言. 要添加新的语言, 仅需新建一个文本文档, 重命名为与现有本地化文件相同的格式. 文件名或其路径中需要包含对应的语言代码: 英语 ("en-US"), 德语 ("de-DE"), 意大利语 ("it-IT"), 法语 ("fr-FR"), 西班牙语 ("es-ES"), 俄语 ("ru-RU"), 汉语 ("zh-Hans"), 葡萄牙语 ("pt-BR"), 或波兰语 ("pl-PL"). 创建好文件并确保其有正确的文件扩展名`.hjson`之后, 重新生成模组. 这样该文件就会更新出可供翻译的条目, 其它文件也会依据英语的`.hjson`文件的结构一并生成. 

# `ModType`与`ILocalizedModType`
有实现自定义`ModType`的模组可以实现`ILocalizedModType`来轻松地推行本地化. 仅需在类继承后面加上`, ILocalizedModType`并添加`public string LocalizationCategory => "自定义类别名称";`以实现属性`LocalizationCategory`. 对于你自定义的`ModType`中的每一个`Localizedtext`, 你可以使用`public virtual LocalizedText 随便什么名字 => this.GetOrAddLocalization(nameof(随便什么名字), 默认显示的随便什么名字);`以允许它们像已有`ModType`里的`Localizedtext`属性一样成为`.hjson`文件中分好类的属性. 