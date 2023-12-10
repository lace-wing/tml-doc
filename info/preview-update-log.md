# `ChangeDir` 现在正确地更新 `itemRotation`（修复了射弹的剑有一刻错误转向的问题）
by **jopojelly** 已合并  
**Pull Request:** <https://github.com/tModLoader/tModLoader/commit/05f30a6ad8a0987142131e456132274a8b4a22c4>  
**更新至 Preview**: 2023/11/01 08:00  
**更新至 Stable**: 2023/12/01 09:00  
**运行时破坏性**: 🟡 - **不太可能**  
**代码破坏性**: 🟢 - **无**  

## 简要总结
- 为了修复剑的一个视效错误，方法 `Player.ChangeDir` 现在会影响手臂转向，物品转向和物品位置。

## 迁移提示
- 无需改动
- 如果您手动修改了 `Player.direction`，推荐改用方法 `Player.ChangeDir`，因为它能帮忙修正边缘情况下的视效。
