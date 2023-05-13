# Replace String 使用指南

---

## 请注意
这篇教程对应的泰拉瑞亚版本为1.4.3.6  
未来版本的 Replace String 使用方法将有较大变化  
本教程仅适用于对应泰拉瑞亚1.4.3.6的 Replace String

---

## 目录

- [Replace String 简介](#什么是-replace-string)
- [汉化包简介](#什么是汉化包)
- [使用汉化包](#使用汉化包)
- [制作汉化包](#制作汉化包)

## 什么是 Replace String
Replace String（RS）直译为“替换字符串”，是一个泰拉瑞亚模组。
它可用于制作和应用泰拉瑞亚模组的汉化包。

许多模组**自身不支持中文**。其中的物品，NPC等的名称或描述大都是英文。
对于不懂英文的人来说，想要畅玩就需要**翻译**了。
除了**内置翻译**和**翻译补丁**，**汉化包及其加载器**也是一种翻译的方法。

**RS正是汉化包的生成器与加载器**。

如果你熟悉1.3时期的Localizer（汉化者），那么RS对你应该不陌生。

除了汉化，它也能应用其它语言的翻译。

## 什么是汉化包
汉化包是存有汉化内容及其配置的文件。
它能告诉汉化包的加载器：
- 对应的模组
- 翻译对应的原文
- 翻译文本
- 汉化包的版本及其它相关信息

RS使用的汉化包为 `.loc` 文件。
请注意，扩展名为 `.loc` 的文件**不一定**能被RS加载，仅仅改变文件的扩展名也**不能**制作汉化包。

如果你看不到文件扩展名，请在文件浏览器的“查看”标签页中勾选“文件扩展名”。

## 使用汉化包

### 前置条件

- 正版泰拉瑞亚

    使用1.4的tModLoader需要你拥有正版的泰拉瑞亚。通常，你需要[购买泰拉瑞亚](https://github.com/lyc-Lacewing/tMLAllInOne/blob/master/IssuesAndSolutions/tML/GetTerraria.md)。

- tModLoader

    tModLoader是一款泰拉瑞亚的模组加载器。如果你已经拥有正版泰拉瑞亚，那么你可以[免费获取它](https://github.com/lyc-Lacewing/tMLAllInOne/blob/master/IssuesAndSolutions/tML/WhatIsTML.md)。

- Replace String

    如果你在使用Steam，可以在tModLoader的创意工坊中搜索“ReplaceString”或[点此链接](https://steamcommunity.com/sharedfiles/filedetails/?id=2852444211)，订阅并等待下载完成。你可能需要重启游戏来让该模组生效。

- 汉化包文件

    你获得的[汉化包](#什么是汉化包)可能是压缩包。在这种情况下，需要先解压。

### 安装方法

1. 启用RS。启用后，RS才可识别并加载汉化包。

    ![EnableRS](/Explained/ExplainedAssets/rs_usepack_1.png)

2. 将汉化包，`.loc` 文件放进 `...\steamapps\common\tModLoader\ReplaceString\Packages`。

    要打开上述文件夹，你可以在Steam库中右键tModLoader，选择“管理”，再“浏览本地文件”。随后进入其中的 `ReplaceString\Packages` 文件夹。  
    你还可以在**RS的配置（小齿轮图标）**中点击“Open Folder”按钮，进入 `...\steamapps\common\tModLoader\ReplaceString`，再打开其中的 `Packages` 文件夹。
    ![RSConfig](/Explained/ExplainedAssets/rs_usepack_2-1.png)
    ![RSOpenFolder](/Explained/ExplainedAssets/rs_usepack_2-2.png)
    ![PackageFolder](/Explained/ExplainedAssets/rs_usepack_2-3.png)
    ![PlacedLocPacks](/Explained/ExplainedAssets/rs_usepack_2-4.png)

3. 返回游戏。进入**RS配置**，在“Select Mod”栏选择**汉化包对应的模组**。被选中的模组会出现在“Autoload Mods”栏中。**保存设置**！

    ![RSSelectMod](/Explained/ExplainedAssets/rs_usepack_3-1.png)
    ![RSAutoloadMods](/Explained/ExplainedAssets/rs_usepack_3-2.png)

4. 点击被选中的模组右侧小三角图标展开选择页面，选择对应的汉化包。

    ![SelectLocPack](/Explained/ExplainedAssets/rs_usepack_4.png)

5. 退出配置界面。重启游戏，正常游玩。

    ![AppliedLocPack](/Explained/ExplainedAssets/rs_usepack_5.png)

## 制作汉化包

施工中……

<!---
1. 订阅下载并启用Replace String mod 
2. 将从任意地方得来的.loc后缀的汉化文件（qq群，steam等）放置到~\steamapps\common\tModLoader\ReplaceString\Packages文件夹中（~代表你的steam位置）
或点开Rs的配置，并点击上方的Open folder来直接跳转到 E:\steam\steamapps\common\tModLoader\ReplaceString  并进入Packages文件夹放置汉化包。 
3. 放置好汉化包后，返回游戏的Rs配置窗口，在下方Select Mod栏选择汉化包所对应的mod
选择完毕后，该mod会上到上面的Autoload Mods栏，点击下方保存设置 
4. 点击选择mod右方小三角打开选择页面，点选汉化包 
5. 汉化包选中后退出界面，重启游戏，进入游戏，汉化成功 
![img1](/Explained/ExplainedAssets/rs_usepack_1.png)
--->