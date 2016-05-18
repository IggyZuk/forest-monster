package fm.states {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.Sounds;
	import fm.game.Tracker;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class GameOverState extends State {
		
		private var isTweeningComplete:Boolean;
		
		private var normalCoinCount:Number = 0;
		private var goldenCoinCount:Number = 0;
		
		//Display
		private var background:Quad;
		private var deathImage:Image;
		
		private var normalCoinImage:Image;
		private var goldenCoinImage:Image;
		private var normalCoinText:TextField;
		private var goldenCoinText:TextField;
		private var coinSprite:Sprite;
		
		private var life:int;
		private var skipText:TextField;
		
		override public function Init():void {
			
			//Black Background
			background = new Quad(GameEngine.WIDTH, GameEngine.HEIGHT, 0x000000);
			addChild(background);
			
			//Cause of death image
			deathImage = new Image(GetTexture(Tracker.instance.deathReason));
				deathImage.pivotX = deathImage.width >> 1;
				deathImage.pivotY = deathImage.height >> 1;
				deathImage.x = GameEngine.WIDTH >> 1;
				deathImage.y = GameEngine.HEIGHT >> 1;
			addChild(deathImage);
			
			//Sprite that contains Coins and Coin texts
			coinSprite = new Sprite();
				coinSprite.x = GameEngine.WIDTH >> 1;
				coinSprite.y = (GameEngine.HEIGHT >> 1) + 150;
			addChild(coinSprite);
			
			//Add touch / keyboard skip
			stage.addEventListener(KeyboardEvent.KEY_DOWN, SkipToMap);
			stage.addEventListener(TouchEvent.TOUCH, SkipTouch);
			
			//Start tweening process
			TweenMotion(2, 1.4, 0.4);
			
			GameEngine.instance.audioManager.AddMusic(Sounds.GameOverMusic).play(Sounds.MUSIC);
		}
		
		override public function Cleanup():void {
			background.removeFromParent(true);
			deathImage.removeFromParent(true);
			if(normalCoinImage) normalCoinImage.removeFromParent(true);
			if(goldenCoinImage) goldenCoinImage.removeFromParent(true);
			coinSprite.removeFromParent(true);
			Starling.juggler.removeTweens(this);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, SkipToMap);
			stage.removeEventListener(TouchEvent.TOUCH, SkipTouch);
		}
		
		override public function Update(passedTime:Number):void {
			if (isTweeningComplete) {
				life++;
				
				//Add coins
				if (normalCoinCount < Tracker.instance.coinNormalCount) {
					normalCoinCount += ((Tracker.instance.coinNormalCount - normalCoinCount) * 0.075);
					normalCoinText.text = String(int(normalCoinCount)+1);
				}
				if (goldenCoinCount < Tracker.instance.coinGoldCount) {
					goldenCoinCount += ((Tracker.instance.coinGoldCount - goldenCoinCount) * 0.075);
					goldenCoinText.text = String(int(goldenCoinCount)+1);
				}
				
				//Update Skip
				if (skipText) {
					skipText.scaleX = skipText.scaleY = Math.abs(Math.sin(life * 0.075) * 0.5) + 1;
					skipText.alpha = Math.abs(Math.sin(life * 0.075) * 0.75) + 0.25;
				} else if(life >= 100) AddSkip();
			}
		}
		
		//Skip touch / keyboard
		private function SkipTouch(e:TouchEvent):void { if (e.getTouch(stage, TouchPhase.BEGAN)) SkipToMap(); }
		private function SkipToMap():void { GameEngine.instance.stateManager.ChangeState(new MapState); }
		
		private function TweenMotion(t1:Number, t2:Number, t3:Number):void {
			
			const COIN_TRANSITION:String = Transitions.EASE_IN_OUT;
			const CHAR_WIDTH:int = 22;
			
			//Add a tween of scaling down
			var tween:Tween = new Tween(deathImage, t1, Transitions.EASE_IN_OUT);
			deathImage.scaleX = deathImage.scaleY = 2;
			deathImage.alpha = 0;
			tween.scaleTo(1);
			tween.fadeTo(1);
			tween.onComplete = function():void {
				tween.reset(deathImage, t2, Transitions.EASE_IN_OUT);
				tween.moveTo(deathImage.x, deathImage.y - 50);
				//tween.scaleTo(0.85);
				Starling.juggler.add(tween);
				
				//Add Normal coins with a tween
				coinSprite.addChild(normalCoinImage = AddCoin("coin_normal"));
				
				//Coin tween
				var coin_tween:Tween = new Tween(normalCoinImage, t3, COIN_TRANSITION);
				normalCoinImage.scaleX = normalCoinImage.scaleY = 8;
				normalCoinImage.alpha = 0;
				coin_tween.moveTo(normalCoinImage.x, normalCoinImage.y);
				coin_tween.scaleTo(1);
				coin_tween.fadeTo(1);
				coin_tween.onComplete = function():void {
					
					//Add Golden coin with a tween
					coinSprite.addChild(goldenCoinImage = AddCoin("coin_gold"));
					goldenCoinImage.alpha = 0;
					
					coin_tween.reset(goldenCoinImage, t3, COIN_TRANSITION);
					goldenCoinImage.scaleX = goldenCoinImage.scaleY = 8;
					coin_tween.moveTo(goldenCoinImage.x, goldenCoinImage.y + 50);
					coin_tween.scaleTo(1);
					coin_tween.fadeTo(1);
					coin_tween.onComplete = function():void {
						coin_tween.reset(coinSprite, t3, COIN_TRANSITION);
						coin_tween.moveTo(coinSprite.x - (String(Tracker.instance.coinNormalCount).length-1)*CHAR_WIDTH, coinSprite.y);
						Starling.juggler.add(coin_tween);
						
						//Add coin texts
						coinSprite.addChild(normalCoinText = AddText(Art.DistanceFont, 30, 0));
						coinSprite.addChild(goldenCoinText = AddText(Art.GoldenFont, 30, 50));
						
						isTweeningComplete = true;
					}
					Starling.juggler.add(coin_tween);
				}
				Starling.juggler.add(coin_tween);
			}
			Starling.juggler.add(tween);
		}
		
		private function AddCoin(textureName:String):Image {
			var c:Image = new Image(Art.GuiAtlas.getTexture(textureName));
			c.pivotX = c.width >> 1;
			c.pivotY = c.height >> 1;
			return c;
		}
		
		private function AddText(font:BitmapFont, px:Number, py:Number):TextField {
			var t:TextField = new TextField(150, 50, "0", font.name, font.size, 0xFFFFFF);
			t.hAlign = HAlign.LEFT;
			t.vAlign = VAlign.TOP;
			t.height = t.textBounds.height+10;
			t.pivotY = t.height >> 1;
			t.x = px;
			t.y = py + 5;
			return t;
		}
		
		private function AddSkip():void {
			if (skipText) return;
			
			skipText = new TextField(200, 36, "press any key!", Art.DescriptionFont.name, 32, 0xFFFFFF);
			skipText.pivotX = skipText.width >> 1;
			skipText.pivotY = skipText.height >> 1;
			skipText.x = GameEngine.WIDTH >> 1;
			skipText.y = 575;
			skipText.alpha = 0;
			addChild(skipText);
		}
		
		private function GetTexture(deathCause:int):Texture {
			switch (deathCause) {
				case Tracker.DEATH_SPEED: return Art.GameOverAtlas.getTexture("gameover_speed_1");
				case Tracker.DEATH_HEALTH: return Art.GameOverAtlas.getTexture("gameover_hp_1");
				case Tracker.DEATH_WALL: return Art.GameOverAtlas.getTexture("gameover_hp_2");
				default: return Art.GameOverAtlas.getTexture("gameover_hp_1");
			}
		}
	}

}