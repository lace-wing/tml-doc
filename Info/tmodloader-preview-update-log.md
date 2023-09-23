## 用 TileID.Sets 控制物块能否放在非实心块旁
by **Rijam** 已合并
**Pull Request**：<https://github.com/tModLoader/tModLoader/pull/3684>  
**更新至 Preview**：`2023/10/01`  
**更新至 Stable**：`2023/11/01`  
**运行时破坏性**：🟢 - **无**  
**代码破坏性**：🟢 - **无**

### 简要总结
- 新数组 `TileID.Sets.CanPlaceNextToNonSolidTile[]` 控制玩家能否将物块放置在非实心块旁，就像原版的蜘蛛网、钱币、活火块、烟和泡泡那样。
