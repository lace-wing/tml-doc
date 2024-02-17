# 无敌帧

## 目录

- [前言](#前言)
- [概述](#概述)
- [玩家的无敌帧](#玩家无敌帧)
- [NPC的无敌帧](#npc无敌帧)

## 前言

在游玩时,我们不难发现:

> 玩家在受伤后很短一段时间内**闪烁**, 此时即使被敌怪或敌方射弹碰到**也不会被击中**

> 玩家闪避后或克盾冲撞到敌人后会有一小段**无敌时间**

> 敌怪受到**特定的攻击**后, 也会有一定的**无敌时间**

由此可见, 无敌帧是一种防止玩家或NPC**过于频繁地受击**, 也能作为一种增幅或削弱的机制<br>
为什么要这么做呢?<br>

泰拉瑞亚是一个60帧的游戏, 意味着其**每秒更新60次**<br>
试想一下, 即使一只绿史莱姆造成的伤害只有6, 如果它能每秒打你60次, 那秒伤(dps)将会达到360<br>
首领单位(boss)更不必说, 创你一下你直接没了<br>
而玩家的攻击也变得相对强大, 这里不再赘述<br>
感兴趣的话可以去创意工坊搜 "No Immunity Frames" 模组试试

然而, 你可能会问, 为什么:

> 即使玩家刚刚被尖刺或岩浆所伤, 也能被敌怪击中

> 即使玩家在闪烁, 伤害性减益(damaging debuff)依然会造成生命流失

> 即使玩家刚刚被小怪击中, **月球领主**或**光之女皇**的攻击依然能命中玩家

还有:

> 既然有的攻击会使敌怪获得无敌帧, 我该怎样最大化输出

>玩家和敌怪的"**骗伤**"是什么

#### 本文将为你详细讲解: 泰拉瑞亚中的无敌帧机制

## 概述:

- 无敌帧是玩家或敌怪在受到攻击或触发某些奖励后(如: 克盾冲撞和黑腰带闪避)获得的无敌时间<br>
  (游戏里的时间并非连续, 而是一帧一帧地流动的)

- 处于无敌帧**并非真正的无敌**, 只是一般**无法受击**

- 玩家与敌怪、不同伤害来源所造成的无敌帧是**不同**的

根据第二条, 我们可以解释debuff在无敌帧期间仍能造成生命流失:<br>
Debuff并不通过**攻击**来造成伤害, 而是通过将目标的生命回复`lifeRegen`归零再减去一个值来达到生命流失的效果

## 玩家无敌帧

### 小节目录

- [触发方式](#玩家无敌帧触发方式)
- [代码解析](#玩家无敌帧代码解析)
- [结论与技巧](#玩家无敌帧结论与技巧)

### 玩家无敌帧触发方式:

- 受到攻击伤害

- 受到其它伤害, 如: 尖刺和岩浆

- 触发奖励, 如: 克苏鲁之脑的闪避和独角兽冲撞后的无敌

泰拉瑞亚中, 1帧 = 1/60秒<br>
大多数的无敌帧时长是40, 即2/3秒<br>
特殊无敌帧的时长可以在泰拉瑞亚或对应模组的Wiki查看

### 玩家无敌帧代码解析

#### 更新无敌帧

```cs
	public void UpdateImmunity() 
	{
		if (immune) // 要是无敌,就
		{
			immuneTime--; // 减少无敌时长
			if (immuneTime <= 0) // 无敌时长 <= 0 就不无敌了
			{
				immune = false; // 不无敌
				immuneNoBlink = false; // 重置这个bool, 不然下次也不闪
			}

			if (immuneNoBlink) // 如果不闪烁
			{
				immuneAlpha = 0; // 透明度 = 0
			}
			else 
			{
				immuneAlpha += immuneAlphaDirection * 50; // 变化透明度
				if (immuneAlpha <= 50)
					immuneAlphaDirection = 1; // 透明度加还是减, 1 是加 -1 是减
				else if (immuneAlpha >= 205)
					immuneAlphaDirection = -1;
			}
		}
		else 
		{
			immuneAlpha = 0; // 完全不透明, 正常显示
		}

		for (int i = 0; i < hurtCooldowns.Length; i++) 
		{
			if (hurtCooldowns[i] > 0)
				hurtCooldowns[i]--; // 同时也减少对应 hurtCooldowns 的值
		}
	}
```
	
#### 设置全局无敌帧

```cs
	public void SetImmuneTimeForAllTypes(int time) // 这里传入要设置的无敌时间
	{
		immune = true; // 得无敌才有用
		immuneTime = time; // 无敌时间设为time
		for (int i = 0; i < hurtCooldowns.Length; i++) 
		{
			hurtCooldowns[i] = time; // 把所有的hurtCooldowns设为time
		}
	}
```
	
##### 神圣庇护(暗影躲避), 混乱之脑和黑腰带

```cs
	SetImmuneTimeForAllTypes(longInvince ? 120 : 80);
```

所以它们连岩浆和尖刺的伤害都能闪避

#### 玩家无敌帧类型

`hurtCooldowns`是一个int[5]: -1 普通伤害 0 其它伤害(物块等) 1 Boss单位 2 塔防兽人(除了击退外跟-1一样)

```cs
	public static class ImmunityCooldownID
	{
		// 默认的, 没啥特别的,就是 Player.immuneTime
		public const int General = -1;
		
		// 物块的接触伤害, 像尖刺和饥荒世界中的仙人掌
		public const int TileContactDamage = 0;
		
		// 像月总和光女一样的Boss(以及它们的仆从和射弹)
		// 防止玩家用其它低额伤害来骗伤
		public const int Bosses = 1;
		
		// 塔防兽人的攻击, 除了特殊的击退效果以外和 -1 一样
		public const int DD2OgreKnockback = 2;
		
		// 尝试用普通捕虫网捕捉岩浆生物(得用防熔岩虫网或金虫网)
		public const int WrongBugNet = 3;

		// 岩浆伤害
		public const int Lava = 4;
	}
```
	
`Hurt`方法中判断`cooldownCounter`的部分

```cs
	bool flag = !immune;
	bool flag2 = false; // 用于判断是否用特殊击退公式
	switch (cooldownCounter) {
		case 0: // 物块的接触伤害, 在HurtTile里给伤害
		case 1: // Boss单位
		case 3: // 抓岩浆生物
		case 4: // 岩浆伤害
			flag = (hurtCooldowns[cooldownCounter] <= 0); // 只有受击冷却<=0了才受伤
			break;
		case 2: // 塔防兽人攻击
			flag2 = true; // 使用特殊的击退公式
			cooldownCounter = -1; // 其它还是用 -1 的
			break;
	}
```
	
#### 给伤害和无敌帧

```cs
	Color color = Crit ? CombatText.DamagedFriendlyCrit : CombatText.DamagedFriendly; // 普通跟暴击有不同的颜色
	CombatText.NewText(new Rectangle((int)position.X, (int)position.Y, width, height), color, (int)num2, Crit); // 头上跳数字
	statLife -= (int)num2; // 扣血
	switch (cooldownCounter) // 判断要给予的无敌帧类型
	{
		case -1: // 普通无敌帧
			{
				immune = true; // 得无敌才有用
				int num14 = 0; // 意义不明
				// 玩家打玩家(PvP)的话就只给8; 只有1点伤害就给20, 大于1点伤害就给40, 十字项链就翻倍
				num14 = (immuneTime = (pvp ? 8 : ((num2 != 1.0) ? (longInvince ? 80 : 40) : (longInvince ? 40 : 20))));
				break;
			}
		case 0: // 物块伤害
			if (num2 == 1.0) // 如果是1伤害
				hurtCooldowns[cooldownCounter] = (longInvince ? 40 : 20); // 只给20
			else
				hurtCooldowns[cooldownCounter] = (longInvince ? 80 : 40); // 给40
			break;
		case 1:
		case 3:
		case 4: // 岩浆伤害
			if (num2 == 1.0)
				hurtCooldowns[cooldownCounter] = (longInvince ? 40 : 20);
			else
				hurtCooldowns[cooldownCounter] = (longInvince ? 80 : 40);
			break;
	}
```

#### 塔防兽人的攻击

```cs
	if (flag2 && hitDirection != 0) // 如果是塔防兽人的攻击且要击退
	{
		if (!mount.Active || !mount.Cart) // 不在坐骑上也不在矿车上
		{
			float num23 = 10.5f; // 水平方向击飞的乘数
			float y2 = -7.5f; // 竖直方向的击飞
			if (noKnockback) // 如果"免疫击退"则受到更小的击退
			{
				num23 = 2.5f;
				y2 = -1.5f;
			}

			StopVanityActions();
			velocity.X = num23 * (float)hitDirection;
			velocity.Y = y2;
			fallStart = (int)(position.Y / 16f);
		}
	}
```
	
#### 如果`!immune`(不无敌)才继续进行受伤的步骤

```cs
	if (flag) // bool flag = !immune, immune为false那flag就为true
	{
		if (whoAmI == Main.myPlayer && blackBelt && Main.rand.Next(10) == 0) 
		{
			NinjaDodge();
			return 0.0;
		}
		
		if (whoAmI == Main.myPlayer && brainOfConfusionItem != null && !brainOfConfusionItem.IsAir && Main.rand.Next(6) == 0 && FindBuffIndex(321) == -1) 
		{
			BrainOfConfusionDodge();
			return 0.0;
		}
		
		if (whoAmI == Main.myPlayer && shadowDodge) 
		{
			ShadowDodge();
			return 0.0;
		}
		
		bool customDamage = false;
		bool playSound = true;
		bool genGore = true;
		if (!PlayerLoader.PreHurt(this, pvp, quiet, ref Damage, ref hitDirection, ref Crit, ref customDamage, ref playSound, ref genGore, ref damageSource, ref cooldownCounter))
			return 0.0;
		
		if (whoAmI == Main.myPlayer && panic)
			AddBuff(63, 480);
		...
	}
```

#### 物块的接触伤害

```cs
	else if (vector3.Y != 0f) // 这个 vector3 是 HurtTile 返回的一个 Vector2
	{
		int damage3 = Main.DamageVar(vector3.Y, 0f - luck);
		Hurt(PlayerDeathReason.ByOther(3), damage3, 0, pvp: false, quiet: false, Crit: false, 0);
		if (vector3.Y == 60f || vector3.Y == 80f) // 原版不是这么搞的, tML才是 These values have to match TileID.Sets.TouchDamageOther, which is unused in vanilla and was not up to date with 1.4 --direwolf420
			AddBuff(30, Main.rand.Next(240, 600));
	}
```

### 玩家无敌帧结论与技巧

从[玩家无敌帧的类型](#玩家无敌帧类型)中可知, 不同的伤害来源会给予玩家不同类型的无敌帧, 不同类型的无敌帧之间互不影响. 这就解释了[前言](#前言)中提到的三个问题<br>
所以, 你不能频繁小怪的伤害来躲过月球领主的伤害, 但是可以通过频繁受到月球领主"较低"的伤害来避免较高的伤害, 比如保持在其眼窝中就不会受到其激光的伤害<br>
原版中除月球领主和光之女皇外的boss并没有使用boss专用的无敌帧, 所以在其他情况下小怪骗伤仍然是可行的

对模组作者来说, 如果你不想让你的boss被小怪骗伤, 记得使用boss无敌帧
	

## NPC无敌帧

> 此处的"NPC"不是指城镇NPC, 而是指所有NPC

### 小节目录

- [触发方式](#npc无敌帧触发方式)
- [无敌帧类型](#npc无敌帧类型)
- [对于射弹的无敌帧](#npc对于射弹的无敌帧)

#### NPC无敌帧触发方式:

- 受到大多数穿透性的攻击
- 受到某些特殊攻击

### NPC无敌帧类型

NPC的无敌帧与玩家的不同, 只有一种<br>
由数组`NPC.immune`表示<br>
元素0~254代表各个玩家的客户端<br>
因此, NPC对于不同玩家的无敌帧是相互独立的<br>
联机时**不会**因为其他玩家造成的无敌帧而打不出伤害

但是, **射弹**(可以理解为你射出去的那些东西, 包括箭矢和剑气)对于NPC有独特的判定方式:

### NPC对于射弹的无敌帧

> 此部分参考了[灾厄维基对于无敌帧的解释][CalamityWikiImmunityFrames]

#### usesLocalNPCImmunity

如果射弹设置`usesLocalNPCImmunity = true`，它对NPC的免疫帧机制将会从根本上改变。<br>
当这个射弹命中一个NPC时（应该是命中后，即跳伤害数字后），它不会立刻设置这个NPC的`immune`，而是在射弹中设置一个计时器。<br>
它能防止这个NPC在一定时间内被特定射弹击中多次。一旦计时结束，这个射弹就能再次对那个NPC造成伤害。

上述计时器的时间长度由变量`localNPCHitCooldown`决定<br>
由于泰拉瑞亚每秒跑60帧，如果`localNPCHitCooldown`被赋为60，它将限制这种射弹，使其每秒最多对同一个NPC造成一次伤害。<br>
但是，这个计时器仅对这个射弹有用。任何其他射弹——甚至是最终棱镜激光那种能穿透的射弹——仍然可以在计时没有结束时击中NPC，这给人一种射弹无视了无敌帧的假象。

`localNPCHitCooldown`在原版中有两个特殊值：-2和-1。这样它们就可以看作设置了一个负数秒数的计时器。或者如原文档所述它们根本就没有设置这个计时器。<br>
那么这个计时永远减不到0，这个NPC也就永远不可能被这个射弹击中第二次。<br>
但是-2和-1的区别在于: 当`usesLocalNPCImmunity`是-1时，这个射弹会将在击中NPC时（这次是命中前，即跳伤害数字之前）将它的`immune`设为0，保证这个射弹一定能够对NPC造成伤害，而不管这个NPC是否正处于无敌帧之中。
然后原文档给出了一个有关`localNPCHitCooldown`的文字形式的总结，这里我以表格形式整理如下：

| `localNPCHitCooldown`的值 | 射弹的行为 |
| - | - |
| -2 | 如果NPC处于`immune`时，该射弹无法对NPC造成伤害，其余与`localNPCHitCooldown = -1`时情况相同 |
| -1 | 击中NPC前将`NPC.immune`设为0，保证该射弹一定能击中目标NPC，但只能击中NPC一次 |
| 0 | 如果NPC处于`immune`时，该射弹无法对NPC造成伤害，一旦成功击中，这个射弹将每帧对NPC造成一次伤害 |
| 1 | 行为几乎与`localNPCHitCooldown`为0时相同，但不同点在于它会将`NPC.immune`设为1，使得在同一帧内这个NPC不能被其他射弹所伤害（和值为-1时优先级未知）|
| >=2 | 每若干帧内，这个射弹只能击中同一个NPC一次 |

#### usesIDStaticNPCImmunity

如果射弹设置`usesIDStaticNPCImmunity = true`，并且给`idStaticNPCHitCooldown`赋值，那么它对NPC的免疫帧机制也会从根本上改变。<br>
像极了`usesLocalNPCImmunity`，当射弹击中NPC时会设置计时器，但是，这个新的计时器会影响同一个玩家的所有同种射弹。<br>
并且, 使用`usesIDStaticNPCImmunity`的射弹都会像`localNPCHitCooldown = -1`那样在击中NPC前将`NPC.immune`设为0，从而保证该射弹一定能击中目标NPC。

#### NPC.immune

设置`NPC.immune`的射弹攻击到NPC之后仅会改变NPC的无敌帧数。<br>
一般的穿透射弹会把`NPC.immune`设置为10(即1/6秒)，我们可以修改它为一个更小的值从而达到缩减部分无敌帧的目的。



[CalamityWikiImmunityFrames]: https://calamitymod.fandom.com/wiki/Immunity_frames
