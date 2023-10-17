# 修复回声涂料不隐藏火把火焰的问题
by **jopojelly** 已合并  
**Pull Request**：<https://github.com/tModLoader/tModLoader/commit/89d407f518804819abd363bb939ba990c56f9758>  
**更新至 Preview**：2023/10/01  
**更新至 Stable**：2023/11/01  
**运行时破坏性**：🟢 - **无**  
**代码破坏性**：🟢 - **无**

## 简要总结
- 公开了方法 `TileDrawing.IsVisible(tile)` 并在 ExampleMod 中添加用例。

## 迁移提示
- 模组应检查其物块是否对回声涂料做出正确的反应，必要时使用 `TileDrawing.IsVisible(tile)`
