## 无敌帧?

在游玩时,我们不难发现:

> 玩家在受伤后很短一段时间内**闪烁**, 此时即使被敌怪或敌方射弹碰到**也不会被击中**

> 玩家闪避后或克盾冲撞到敌人后会有一小段**无敌时间**

> 敌怪受到**特定的攻击**后, 也会有一定的**无敌时间**

由此可见, 无敌帧是一种防止玩家或NPC**过于频繁地受击**, 也能作为一种增幅或削弱的机制<br>
为什么要这么做呢?<br>

泰拉瑞亚是一个60帧的游戏, 意味着其**每秒更新60次**<br>
试想一下, 即使一只绿史莱姆的攻击只有6, 如果它能每秒打你60次, 那秒伤(dps)将会达到360<br>
首领单位(boss)更不必说, 创你一下直接没了<br>
而玩家的攻击也变得相对强大, 这里不再赘述<br>
感兴趣的话可以去创意工坊搜 "No Immunity Frames" 模组试试

然而, 你可能会问, 为什么:

> 即使玩家刚刚被尖刺或岩浆所伤, 也能被敌怪击中

> 即使玩家在闪烁, 伤害性减益(debuff)依然会造成生命流失

> 即使玩家刚刚被小怪击中, **月球领主**或**光之女皇**的攻击依然能命中玩家

还有:

> 既然有的攻击会使敌怪获得无敌帧, 我该怎样最大化输出

>玩家和敌怪的**"骗伤"**是什么

#### 本系列视频将为你详细讲解: 泰拉瑞亚中的无敌帧机制

# 概述:

- 无敌帧是玩家或敌怪在受到攻击或触发某些奖励后(如: 克盾冲撞和黑腰带闪避)获得的无敌时间<br>
  (游戏里的时间并非连续, 而是一帧一帧地流动的)

- 处于无敌帧**并非真正的无敌**, 只是一般**无法受击**

- 玩家与敌怪、不同伤害来源所造成的无敌帧是**不同**的

根据第二条, 我们可以解释debuff在无敌帧期间仍能造成生命流失:<br>
Debuff并**不攻击**, 而是通过将目标的生命回复`lifeRegen`归零再减去一个值来达到生命流失的效果

# 玩家无敌帧

触发方式:

- 受到攻击伤害

- 受到其它伤害, 如: 尖刺和岩浆

- 触发奖励, 如: 克苏鲁之脑的闪避和独角兽冲撞后的无敌

泰拉瑞亚中, 1帧 = 1/60秒<br>
大多数的无敌帧时长是40, 即2/3秒<br>
特殊无敌帧的时长可以在泰拉瑞亚或对应模组的Wiki查看

## 更新无敌帧

	public void UpdateImmunity() 
	{
		if (immune) //要是无敌,就
		{
			immuneTime--; //减少无敌时长
			if (immuneTime <= 0) //无敌时长 <= 0 就不无敌了
			{
				immune = false; //不无敌
				immuneNoBlink = false; //重置这个bool, 不然下次也不闪
			}

			if (immuneNoBlink) //如果不闪烁
			{
				immuneAlpha = 0; //透明度 = 0
			}
			else 
			{
				immuneAlpha += immuneAlphaDirection * 50; //变化透明度
				if (immuneAlpha <= 50)
					immuneAlphaDirection = 1; //透明度加还是减, 1 是加 -1 是减
				else if (immuneAlpha >= 205)
					immuneAlphaDirection = -1;
			}
		}
		else 
		{
			immuneAlpha = 0; //完全不透明, 正常显示
		}

		for (int i = 0; i < hurtCooldowns.Length; i++) 
		{
			if (hurtCooldowns[i] > 0)
				hurtCooldowns[i]--; //同时也减少对应 hurtCooldowns 的值
		}
	}
	
## 设置全局无敌帧

	public void SetImmuneTimeForAllTypes(int time) //这里传入要设置的无敌时间
	{
		immune = true; //得无敌才有用
		immuneTime = time; //无敌时间设为time
		for (int i = 0; i < hurtCooldowns.Length; i++) 
		{
			hurtCooldowns[i] = time; //把所有的hurtCooldowns设为tuime
		}
	}
	
### 神圣庇护(暗影躲避), 混乱之脑和黑腰带

	SetImmuneTimeForAllTypes(longInvince ? 120 : 80);

所以它们连岩浆和尖刺都能闪

## 玩家无敌帧类型

`hurtCooldowns`是一个int[5]: -1 普通伤害 0 其它伤害(物块等) 1 Boss单位 2 塔防兽人(除了击退外跟-1一样)

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
	
`Hurt`方法中判断`cooldownCounter`的部分

	bool flag = !immune;
	bool flag2 = false; //用于判断是否用特殊击退公式
	switch (cooldownCounter) {
		case 0: //物块的接触伤害, 在HurtTile里给伤害
		case 1: //Boss单位
		case 3: //抓岩浆生物
		case 4: //岩浆伤害
			flag = (hurtCooldowns[cooldownCounter] <= 0); //只有受击冷却<=0了才受伤
			break;
		case 2: //塔防兽人攻击
			flag2 = true; //使用特殊的击退公式
			cooldownCounter = -1; //其它还是用 -1 的
			break;
	}
	
给伤害和无敌帧

	Color color = Crit ? CombatText.DamagedFriendlyCrit : CombatText.DamagedFriendly; //普通跟暴击有不同的颜色
	CombatText.NewText(new Rectangle((int)position.X, (int)position.Y, width, height), color, (int)num2, Crit); //头上跳数字
	statLife -= (int)num2; //扣血
	switch (cooldownCounter) //判断要给予的无敌帧类型
	{
		case -1: //普通无敌帧
			{
				immune = true; //得无敌才有用
				int num14 = 0; //意义不明
				//玩家打玩家(PvP)的话就只给8; 只有1点伤害就给20, 大于1点伤害就给40, 十字项链就翻倍
				num14 = (immuneTime = (pvp ? 8 : ((num2 != 1.0) ? (longInvince ? 80 : 40) : (longInvince ? 40 : 20))));
				break;
			}
		case 0: //物块伤害
			if (num2 == 1.0) //如果是1伤害
				hurtCooldowns[cooldownCounter] = (longInvince ? 40 : 20);//只给20
			else
				hurtCooldowns[cooldownCounter] = (longInvince ? 80 : 40);//给40
			break;
		case 1:
		case 3:
		case 4: //岩浆伤害
			if (num2 == 1.0)
				hurtCooldowns[cooldownCounter] = (longInvince ? 40 : 20);
			else
				hurtCooldowns[cooldownCounter] = (longInvince ? 80 : 40);
			break;
	}

塔防兽人的攻击

	if (flag2 && hitDirection != 0) //如果是塔防兽人的攻击且要击退
	{
		if (!mount.Active || !mount.Cart) //不在坐骑上也不在矿车上
		{
			float num23 = 10.5f; //水平方向击飞的乘数
			float y2 = -7.5f; //竖直方向的击飞
			if (noKnockback) //如果"免疫击退"则受到更小的击退
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
	
如果`!immune`(不无敌)才继续进行受伤的步骤

	if (flag) //flag = !immune, immune为false那flag就为true
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

物块的接触伤害

	else if (vector3.Y != 0f) //这个 vector3 是 HurtTile 返回的一个 Vector2
	{
		int damage3 = Main.DamageVar(vector3.Y, 0f - luck);
		Hurt(PlayerDeathReason.ByOther(3), damage3, 0, pvp: false, quiet: false, Crit: false, 0);
		if (vector3.Y == 60f || vector3.Y == 80f) //原版不是这么搞的, tML才是 These values have to match TileID.Sets.TouchDamageOther, which is unused in vanilla and was not up to date with 1.4 --direwolf420
			AddBuff(30, Main.rand.Next(240, 600));
	}
	

# NPC无敌帧

> 此处的"NPC"不是指城镇NPC, 而是指所有NPC

触发方式:

- 受到某些攻击

## NPC无敌帧类型

NPC的无敌帧与玩家的不同, 只有一种<br>
由数组`NPC.immune`表示<br>
元素0~254代表各个玩家的客户端<br>
因此, NPC对于不同玩家的无敌帧是相互独立的<br>
联机时不会因为其他玩家而打不出伤害

但是, 射弹对于NPC有独特的判定方式:

## NPC对于射弹的无敌帧

翻译润色以下句段:


usesLocalNPCImmunity
This section primarily describes vanilla Terraria behavior.
If a projectile sets usesLocalNPCImmunity to true, its interaction with immunity frames fundamentally changes. When the projectile strikes an NPC, instead of setting the NPC's npc.immune, it sets up a timer on the projectile which stops that specific projectile from striking the NPC for a certain number of frames. Once the timer is up, the projectile can strike that NPC again.

The length of the timer is determined by the variable localNPCHitCooldown. Since Terraria runs at 60 tick per second, a value of 60 for localNPCHitCooldown would limit the projectile to striking once per second. However, the timer only applies to the specific projectile which started it. Any other projectiles - even piercing ones - can still hit the NPC while the timer is running, which is what gives the impression that the projectile "ignores iframes".

localNPCHitCooldown also has two special values, -2 and -1. In both of these cases, no internal timer is set. Instead, the NPC that was struck by the projectile becomes permanently immune to that specific projectile forever. This means that the NPC can only be hit by a projectile with negative localNPCHitCooldown once, no matter how long the projectile lasts. When localNPCHitCooldown is set to -1, the projectile sets npc.immune to zero on hit, ensuring that it always hits no matter what. This also lends credence to the phrase "ignores iframes", because the projectile literally ignores the immunity frames of the NPC it is hitting.

Summary of the behavior of localNPCHitCooldown values:

-2: The NPC's immunity frames are unaffected by the projectile. If the NPC has immunity frames, the projectile does not strike. Otherwise, the NPC is struck and does not receive any immunity frames. The projectile will never hit this NPC again.
-1: The projectile explicitly removes the NPC's immunity frames on contact. It always hits. The projectile will never hit this NPC again. An example of localNPCHitCooldown -1 is Luminite Bullets.
0: Behaves effectively the same way as -2, except that the projectile can immediately strike the NPC again on the next frame. The NPC gets no immunity frames if struck, but the projectile won't remove immunity frames if the NPC already has some.
1: Behaves almost the same as 0. The difference is that because the NPC's npc.immune is set to 1, it is immune to all other basic piercing or -2 localNPCHitCooldown projectiles which would strike it this frame.
2+: The projectile can only strike a particular NPC once per this many frames. This cooldown is individual per NPC.
A table of all items with projectiles that use this code, along with the corresponding localNPCHitCooldown values is below:

Additionally, the explosions created by the Chaotic Puffer also set usesLocalNPCImmunity to true, with localNPCHitCooldown set to 1.

usesIDStaticNPCImmunity
This section primarily describes vanilla Terraria behavior.
If a projectile sets usesIDStaticNPCImmunity to true and idStaticNPCHitCooldown to a value, its interaction with immunity frames is fundamentally changed. Much like usesLocalNPCImmunity, a timer is set when the projectile strikes an NPC. However, this type of internal timer blocks out all projectiles of the same type from the same player. This means that after any instance of a usesIDStaticNPCImmunity projectile hits an enemy, the NPC is immune to all projectiles of that type from the player who struck them for a given time. All projectiles which use usesIDStaticNPCImmunity explicitly remove immunity frames from any NPCs they strike, like projectiles which set localNPCHitCooldown to -1.

npc.immune
Projectiles which set npc.immune to a value upon striking an NPC simply change the number of immunity frames the NPC receives. Like a typical piercing projectile, the NPC will not be able to be struck by any piercing projectiles for that many frames. Normal piercing projectiles set npc.immune to 10, so typically projectiles which change this behavior set npc.immune to a lower value such as 4. This behavior is often called "partially ignoring iframes", because it removes or ignores some of the NPC's immunity frames, but not all of them.
