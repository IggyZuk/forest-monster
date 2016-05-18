package fm.gui.hud {
	import flash.geom.Rectangle;
	import fm.engine.GameEngine;
	import fm.game.Upgrades;
	import fm.states.GameState;
	import fm.game.Tracker;
	import fm.gui.buttons.MuteButton;
	import fm.gui.buttons.PauseButton;
	import fm.game.entities.Monster;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class GameHud extends Hud {
		
		private var game:GameState;
		
		private var normalCoinText:TextField;
		private var goldenCoinText:TextField;
		private var speedText:TextField;
		private var distanceText:TextField;
		
		private var normalCoin:Image;
		private var goldenCoin:Image;
		private var km:Image;
		
		private var lastHeart:int;
		private var heartCount:int;
		private var heartList:Vector.<MovieClip> = new Vector.<MovieClip>;
		
		private var staminaBar:StaminaBar;
		
		public function GameHud(game:GameState) {
			this.game = game;
			
			AddBlackBar(0);
			AddBlackBar(547);
			
			//Add Images
			addChild(normalCoin = AddImage("coin_normal", 20, 510));
			addChild(goldenCoin = AddImage("coin_gold", 20, 545));
			addChild(km = AddImage("kmhm", 730, 530));
			
			//Add mini buttons
			addChild(new PauseButton(GameEngine.WIDTH - 20, 20));
			addChild(new MuteButton(GameEngine.WIDTH - 45, 20));
			
			//Add TextFields
			addChild(normalCoinText = AddText(new Rectangle(80,525,150,50), null, Art.DistanceFont, 0xFFFFFF, HAlign.LEFT));
			addChild(goldenCoinText = AddText(new Rectangle(77.5,555,150,50), null, Art.GoldenFont, 0xFFFFFF, HAlign.LEFT));
			addChild(speedText = AddText(new Rectangle(575,520,150,50), null, Art.SpeedFont, 0xFFFFFF, HAlign.RIGHT));
			addChild(distanceText = AddText(new Rectangle(575,560,150,50), null, Art.DistanceFont, 0xFFFFFF, HAlign.RIGHT));
			
			//Add StaminaBar
			staminaBar = new StaminaBar(game, 400, 20, Monster.s_maxStamina * 0.01);
			addChild(staminaBar);
			
			//Add Hearts
			heartCount = game.monster.health >> 2;
			for (var i:int = 0; i < heartCount; i++) AddHeart(i, 55, 55);
			lastHeart = heartList.length - 1;
			
			if (GameEngine.instance.upgradeManager.IsUpgraded(Upgrades.HEART_FAIRY)) {
				trace("UPGRADED!!!!!!!!!!!!!!!!!!!");
				addChild(new Image(Art.GuiAtlas.getTexture("heart_fairy")));
			}
		}
		
		override public function Cleanup():void {
			
			//Remove Stamina
			staminaBar.Cleanup();
			staminaBar.removeFromParent(true);
			
			//Remove Icons
			normalCoin.removeFromParent(true);
			goldenCoin.removeFromParent(true);
			km.removeFromParent(true);
			
			//Remove TextFields
			normalCoinText.removeFromParent(true);
			goldenCoinText.removeFromParent(true);
			speedText.removeFromParent(true);
			distanceText.removeFromParent(true);
			
			//Remove hearts
			for each(var h:MovieClip in heartList) h.removeFromParent(true);
			heartList.length = 0;
		}
		
		override public function Update(passedTime:Number):void {
			staminaBar.Update();
			if (normalCoinText.text != String(Tracker.instance.coinNormalCount)) SetText(normalCoinText, Tracker.instance.coinNormalCount);
			if (goldenCoinText.text != String(Tracker.instance.coinGoldCount)) SetText(goldenCoinText, Tracker.instance.coinGoldCount);
			if (speedText.text != String(Tracker.instance.speedCount)) SetText(speedText, Tracker.instance.speedCount);
			if (distanceText.text != String(Tracker.instance.distanceCount)) SetText(distanceText, Tracker.instance.distanceCount);
		}
		
		private function AddHeart(px:Number, py:Number, w:Number):void {
			var heart_frames:Vector.<Texture> = Art.GuiAtlas.getTextures("hp_heart");
			var heart:MovieClip = new MovieClip(heart_frames);
			heart.pivotX = heart.width >> 1;
			heart.pivotY = heart.height >> 1;
			addChild(heart);
			heartList.push(heart);
			
			heart.x = (w + heart.width >> 1) * px - (heartCount * w >> 1) + ((GameEngine.WIDTH + heart.width) >> 1);
			heart.y = py;
		}
		
		public function SetHearts(health:int):void {
			if (health < 0) return;
			
			var currentHeart:int = lastHeart;
			var currentHealth:int = ((currentHeart + 1) * 4) - heartList[currentHeart].currentFrame;
			
			//Take away hearts
			while (currentHealth > health) {
				currentHealth--;
				
				if (heartList[currentHeart].currentFrame == 4) {
					currentHeart--;
					if (currentHeart < 0) return;
					heartList[currentHeart].currentFrame = 0;
				}
				heartList[currentHeart].currentFrame++;
			}
			
			//Add hearts
			while (currentHealth < health) {
				currentHealth++;
				
				if (heartList[currentHeart].currentFrame == 0) {
					currentHeart++;
					if (currentHeart > heartList.length-1) return;
					heartList[currentHeart].currentFrame = 4;
				}
				heartList[currentHeart].currentFrame--;
			}
			
			lastHeart = currentHeart;
			
			//Bubble tween
			var animation:Tween = new Tween(heartList[currentHeart], 0.5, Transitions.EASE_OUT_ELASTIC);
			animation.scaleTo(1.5);
			animation.onComplete = function ():void {
				var animation:Tween = new Tween(heartList[currentHeart], 0.25, Transitions.EASE_IN);
				animation.scaleTo(1);
				Starling.juggler.add(animation);
			};
			Starling.juggler.add(animation);
		}
		
		private function AddBlackBar(py:int):void {
			var q:Quad = new Quad(800, 53, 0x000000);
			q.y = py;
			addChildAt(q, 0);
		}
		
	}

}