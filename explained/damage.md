# Damage Explained

## Tile Damage

结构体 `HurtTile` 表示可伤害玩家的物块；注意它不是个物块，只包含对应物块的位置和 ID。

```cs
// Terraria.Collision
public struct HurtTile
{
    public int type;
    public int x;
    public int y;
}
```

方法 `CanTileHurt` 会检查物块 `type` 是否在几个伤害性物块的 `TileID.Sets` 数组里。

<details>
    <summary>Terraria.Collision.CanTileHurt</summary>

```cs
public static bool CanTileHurt(ushort type, int i, int j, Player player)
{
	if (type == 230 && !Main.getGoodWorld)
	{
		return false;
	}
	if (type == 80 && !Main.dontStarveWorld)
	{
		return false;
	}
	if (TileID.Sets.TouchDamageBleeding[type] || TileID.Sets.Suffocate[type] || TileID.Sets.TouchDamageImmediate[type] > 0)
	{
		return true;
	}
	if (TileID.Sets.TouchDamageHot[type] && (player == null || !player.fireWalk))
	{
		return true;
	}
	return false;
}
```

</details>

方法 `HurtTiles` 检查玩家接触的物块；注意其只返回一个 `HurtTile`，意味着玩家同时只会被一种物块伤害。

<details>
    <summary>Terraria.Collision.HurtTiles</summary>

```cs
public static HurtTile HurtTiles(Vector2 Position, int Width, int Height, Player player)
{
	int num = (int)(Position.X / 16f) - 1;
	int num2 = (int)((Position.X + (float)Width) / 16f) + 2;
	int num3 = (int)(Position.Y / 16f) - 1;
	int num4 = (int)((Position.Y + (float)Height) / 16f) + 2;
	if (num < 0)
	{
		num = 0;
	}
	if (num2 > Main.maxTilesX)
	{
		num2 = Main.maxTilesX;
	}
	if (num3 < 0)
	{
		num3 = 0;
	}
	if (num4 > Main.maxTilesY)
	{
		num4 = Main.maxTilesY;
	}
	Vector2 vector = default(Vector2);
	HurtTile result;
	for (int i = num; i < num2; i++)
	{
		for (int j = num3; j < num4; j++)
		{
			Tile tile = Main.tile[i, j];
			if (tile == null || tile.inActive() || !tile.active())
			{
				continue;
			}
			vector.X = i * 16;
			vector.Y = j * 16;
			int num5 = 16;
			if (tile.halfBrick())
			{
				vector.Y += 8f;
				num5 -= 8;
			}
			int num6 = 0;
			if (TileID.Sets.Suffocate[tile.type])
			{
				num6 = 2;
			}
			if (Position.X + (float)Width - (float)num6 < vector.X || Position.X + (float)num6 > vector.X + 16f || Position.Y + (float)Height - (float)num6 < vector.Y - 0.5f || Position.Y + (float)num6 > vector.Y + (float)num5 + 0.5f || !CanTileHurt(tile.type, i, j, player))
			{
				continue;
			}
			if (tile.slope() > 0)
			{
				if (num6 > 0)
				{
					continue;
				}
				int num7 = 0;
				if (tile.rightSlope() && Position.X > vector.X)
				{
					num7++;
				}
				if (tile.leftSlope() && Position.X + (float)Width < vector.X + 16f)
				{
					num7++;
				}
				if (tile.bottomSlope() && Position.Y > vector.Y)
				{
					num7++;
				}
				if (tile.topSlope() && Position.Y + (float)Height < vector.Y + (float)num5)
				{
					num7++;
				}
				if (num7 == 2)
				{
					continue;
				}
			}
			result = default(HurtTile);
			result.type = tile.type;
			result.x = i;
			result.y = j;
			return result;
		}
	}
	result = default(HurtTile);
	result.type = -1;
	return result;
}
```

</details>

<details>
    <summary>Terraria.Player.GetHurtTile</summary>

```cs
private Collision.HurtTile GetHurtTile()
{
    Collision.HurtTile result = Collision.HurtTiles(position, width, (!mount.Active || !mount.Cart) ? height : (height - 16), this);
    if (result.type >= 0)
    {
        return result;
    }
    Enumerator<Point> enumerator = TouchedTiles.GetEnumerator();
    try
    {
        while (enumerator.MoveNext())
        {
            Point touchedTile = enumerator.get_Current();
            Tile tile = Main.tile[touchedTile.X, touchedTile.Y];
            if (tile != null && tile.active() && tile.nactive() && !TileID.Sets.Suffocate[tile.type] && Collision.CanTileHurt(tile.type, touchedTile.X, touchedTile.Y, this))
            {
                Collision.HurtTile result2 = default(Collision.HurtTile);
                result2.type = tile.type;
                result2.x = touchedTile.X;
                result2.y = touchedTile.Y;
                return result2;
            }
        }
        return result;
    }
    finally
    {
        ((System.IDisposable)enumerator).Dispose();
    }
}
```

</details>

<details>
    <summary>Terraria.Player.ApplyTouchDamage</summary>

```cs
private void ApplyTouchDamage(int tileId, int x, int y)
	{
		if (TileID.Sets.TouchDamageHot[tileId])
		{
			AddBuff(67, 20);
		}
		if (TileID.Sets.Suffocate[tileId])
		{
			if (suffocateDelay < 5)
			{
				suffocateDelay++;
			}
			else
			{
				AddBuff(68, 1);
			}
		}
		else
		{
			suffocateDelay = 0;
		}
		if (TileID.Sets.TouchDamageBleeding[tileId])
		{
			AddBuff(30, Main.rand.Next(240, 600));
		}
		int num = TileID.Sets.TouchDamageImmediate[tileId];
		if (num > 0)
		{
			num = Main.DamageVar(num, 0f - luck);
			Hurt(PlayerDeathReason.ByOther(3), num, 0, pvp: false, quiet: false, Crit: false, 0);
		}
		if (TileID.Sets.TouchDamageDestroyTile[tileId])
		{
			WorldGen.KillTile(x, y);
			if (Main.netMode == 1 && !Main.tile[x, y].active())
			{
				NetMessage.SendData(17, -1, -1, null, 4, x, y);
			}
		}
	}
```

</details>

<details>
    <summary>Logics in Terraria.Player.Update</summary>

```cs
// ...
if (!shimmering)
{
    Collision.HurtTile hurtTile = GetHurtTile();
    if (hurtTile.type >= 0)
    {
        ApplyTouchDamage(hurtTile.type, hurtTile.x, hurtTile.y);
    }
}
// ...
```

</details>
