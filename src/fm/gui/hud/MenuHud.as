package fm.gui.hud {
	import flash.geom.Rectangle;
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.Tracker;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MenuHud extends Hud {
		
		private var life:int;
		
		private var hasCoins:Boolean;
		private var hasStats:Boolean;
		
		private var coinContainer:Sprite;
		private var statsContainer:Sprite;
		
		private var normalCoin:Image;
		private var goldenCoin:Image;
		private var normalCoinText:TextField;
		private var goldenCoinText:TextField;
		
		private var chest:Image;
		
		private var statsText:TextField;
		
		public function MenuHud(hasCoins:Boolean, hasStats:Boolean) {
			
			this.hasCoins = hasCoins;
			this.hasStats = hasStats;
			
			if(hasCoins){
				addChild(coinContainer = new Sprite);
				
				chest = new Image(Art.GuiAtlas.getTexture("chest"))
					chest.x = -25;
					chest.y = -10;
				coinContainer.addChild(chest);
				
				coinContainer.addChild(normalCoin = AddImage("coin_normal", 0, 0));
				coinContainer.addChild(goldenCoin = AddImage("coin_gold", 0, 35));
				coinContainer.addChild(normalCoinText = AddText(new Rectangle(60,15,150,50), String(Tracker.instance.coinNormalTotal), Art.DistanceFont, 0xFFFFFF, HAlign.LEFT));
				coinContainer.addChild(goldenCoinText = AddText(new Rectangle(57.5,45,150,50), String(Tracker.instance.coinGoldTotal), Art.GoldenFont, 0xFFFFFF, HAlign.LEFT));
				
				coinContainer.pivotX = coinContainer.width >> 1;
				coinContainer.pivotY = coinContainer.height >> 1;
				coinContainer.x = 700;
				coinContainer.y = 100;
			}
			
			if (hasStats) {
				addChild(statsContainer = new Sprite);
				var statsBg:Quad = new Quad(240, 220, 0x000000);
				statsBg.alpha = 0.75;
				statsContainer.addChild(statsBg);
				
				var statsString:String = 
					"total kills:" + int(Math.random() * 5000) + "\n" +
					"total deaths:" + int(Math.random() * 5000) + "\n" +
					"distance:" + int(Math.random() * 5000) + "ft\n" +
					"most combos:" + int(Math.random() * 5000) + "\n" +
					"ugliness:" + int(Math.random() * 5000) + "\n" +
					"awesome:" + int(Math.random() * 5000) + "\n.";
				
				statsContainer.addChild(statsText = AddText(new Rectangle(10,10,220,275), statsString, Art.DescriptionFont, 0xFFFFFF, HAlign.LEFT));
				
				statsContainer.pivotX = statsContainer.width >> 1;
				statsContainer.pivotY = statsContainer.height >> 1;
				statsContainer.x = 150;
				statsContainer.y = 150;
			}
		}
		
		//Call this after successful purchase!
		public function UpdateText():void {
			SetText(normalCoinText, Tracker.instance.coinNormalTotal);
			SetText(goldenCoinText, Tracker.instance.coinGoldTotal);
		}
		
		override public function Update(passedTime:Number):void {
			life++;
			
			if (hasCoins) {
				coinContainer.x += Math.sin(life* 0.025) * 0.5;
				coinContainer.y += Math.sin(life* 0.05) * 1.25;
				coinContainer.rotation = Math.sin(life* 0.025) * 0.1;
			}
			
			if (hasStats) {
				statsContainer.x += Math.sin(life* 0.015) * 0.05;
				statsContainer.y += Math.sin(life* 0.025) * 0.5;
				statsContainer.rotation = Math.sin(life* 0.015) * 0.025;
			}
			
			UpdateText();
		}
		
		override public function Cleanup():void {
			chest.removeFromParent(true);
			if (hasCoins) {
				normalCoin.removeFromParent(true);
				goldenCoin.removeFromParent(true);
				normalCoinText.removeFromParent(true);
				goldenCoinText.removeFromParent(true);
				coinContainer.removeFromParent(true);
			}
			
			if (hasStats) {
				statsText.removeFromParent(true);
				statsContainer.removeFromParent(true);
			}
		}
		
	}

}