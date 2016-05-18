package fm.states {
	import flash.geom.Point;
	import fm.engine.GameEngine;
	import fm.engine.sound.Sfx;
	import fm.events.UpgradeEvent;
	import fm.game.Art;
	import fm.game.Buyable;
	import fm.game.Sounds;
	import fm.gui.buttons.GoToMapButton;
	import fm.gui.hud.MenuHud;
	import fm.gui.hud.NewSign;
	import fm.gui.shop.Scroll;
	import fm.gui.shop.ShopButton;
	import fm.gui.shop.ShopFairy;
	import fm.utils.Angles;
	
	import starling.display.Quad;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import flash.display.Bitmap;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ShopState extends State {
		
		private var hud:MenuHud;
		
		private var backgroundImage:Image;
		private var buttonLayer:Sprite;
		
		private var scroll:Scroll;
		private var scrollTint:Quad;
		
		private var arrow:MovieClip;
		private var ladle:MovieClip;
		
		private var buttonList:Vector.<ShopButton> = new Vector.<ShopButton>;
		private var newList:Vector.<NewSign> = new Vector.<NewSign>;
		
		public var blueFairy:ShopFairy;
		public var greenFairy:ShopFairy;
		
		private var mapButton:GoToMapButton;
		
		private var switchTimer:int;
		private var lastPointStamp:Point;
		
		public var potPosition:Point;
		public var offSetPosition:Point;
		
		override public function Init():void {
			
			//Positions
			potPosition = new Point(385, 100);
			offSetPosition = new Point(Art.ShopXML.@x, Art.ShopXML.@y);
			
			//Add background image
			backgroundImage = new Image(Art.ShopBackground);
				backgroundImage.pivotX = backgroundImage.width >> 1;
				backgroundImage.pivotY = backgroundImage.height >> 1;
				backgroundImage.x = stage.stageWidth >> 1;
				backgroundImage.y = stage.stageHeight >> 1;
			addChild(backgroundImage);
			
			//Add buttons
			addChild(buttonLayer = new Sprite);
			buttonLayer.addChild(mapButton = new GoToMapButton(50, GameEngine.HEIGHT - 50));
			
			var buyableList:Vector.<Buyable> = GameEngine.instance.upgradeManager.shopBuyableList;
			for each(var b:Buyable in buyableList) AddButton(b);
			
			//Add fairy arrow
			arrow = AddHoldItem("fairy_arrow");
			ladle = AddHoldItem("fairy_laddle");
			
			//Add fairies
			blueFairy = AddFairy("fairy_blue", Math.random()*800, Math.random()*600, true);
			greenFairy = AddFairy("fairy_green", Math.random()*800, Math.random()*600, false);
			
			HoldArrow(blueFairy);
			HoldLadle(greenFairy);
			
			addChild(hud = new MenuHud(true, false));
			
			GameEngine.instance.stage.addEventListener(UpgradeEvent.BOUGHT, BuyableBought);
			
			//If map music is playing, add some transformation on it.
			if (GameEngine.instance.audioManager.IsMusicPlaying(Sounds.MapMusic)) {
				var music:Sfx = GameEngine.instance.audioManager.music;
				music.volume = Sounds.MUSIC/5;
				music.pan = -0.75;
			}
		}
		
		override public function Cleanup():void {
			
			GameEngine.instance.stage.removeEventListener(UpgradeEvent.BOUGHT, BuyableBought);
			
			removeChild(backgroundImage);
			
			//Remove buttons
			for each(var b:ShopButton in buttonList) {
				b.Cleanup();
				b.removeFromParent(true);
			}
			buttonList.length = 0;
			
			//Remove fairies
			blueFairy.Cleanup();
			blueFairy.removeFromParent(true);
			greenFairy.Cleanup();
			greenFairy.removeFromParent(true);
			
			mapButton.Cleanup();
			
			//Remove scroll
			if(scroll){
				scroll.Cleanup();
				scroll.removeFromParent(true);
			}
			if (scrollTint) {
				scrollTint.removeEventListener(TouchEvent.TOUCH, CloseScroll);
				scrollTint.removeFromParent(true);
			}
			
			//Remove new signs
			for each(var n:NewSign in newList) {
				n.Cleanup();
				n.removeFromParent(true);
			}
			newList.length = 0;
		}
		
		override public function Update(passedTime:Number):void {
			hud.Update(passedTime);
			
			if (switchTimer >= 200) {
				if (Angles.GetDistance(blueFairy, greenFairy) < 80) {
					if (blueFairy.IsHoldingArrow()) {
						HoldArrow(greenFairy);
						HoldLadle(blueFairy);
					} else {
						HoldArrow(blueFairy);
						HoldLadle(greenFairy);
					}
					if(lastPointStamp) ChangeArrowPos(lastPointStamp.x, lastPointStamp.y);
					switchTimer = 0;
				}
			} else switchTimer++;
			
			blueFairy.Update(passedTime);
			greenFairy.Update(passedTime);
			
			mapButton.Update();
			for each(var n:NewSign in newList) n.Update();
		}
		
		private function AddButton(buyable:Buyable):void {
			var b:ShopButton = new ShopButton(this, buyable);
			buttonLayer.addChild(b);
			buttonList.push(b);
		}
		
		private function AddFairy(texture:String, px:int, py:Number, isBlue:Boolean):ShopFairy {
			var f:ShopFairy = new ShopFairy(this, texture, isBlue);
			f.x = px;
			f.y = py;
			addChild(f);
			return f;
		}
		
		private function AddHoldItem(textureName:String):MovieClip {
			var i:MovieClip = new MovieClip(Art.EntityAtlas.getTextures(textureName));
			i.pivotX = i.width >> 1;
			//i.pivotY = i.height >> 1;
			addChild(i);
			return i;
		}
		
		//Set holding items
		public function HoldArrow(fairy:ShopFairy):void { fairy.HoldItem(arrow, true); }
		public function HoldLadle(fairy:ShopFairy):void { fairy.HoldItem(ladle, false); }
		
		//Who ever is holding the arrow, move to the given position
		public function ChangeArrowPos(px:int, py:int):void {
			lastPointStamp = new Point(px, py);
			if (blueFairy.IsHoldingArrow()) blueFairy.ChangePosition(px, py);
			else greenFairy.ChangePosition(px, py);
		}
		
		public function OpenScroll(buyable:Buyable):void {
			if (scroll) return;
			
			//Add scroll tint
			addChild(scrollTint = new Quad(GameEngine.WIDTH, GameEngine.HEIGHT, 0x000000));
			scrollTint.alpha = 0.5;
			scrollTint.addEventListener(TouchEvent.TOUCH, TouchCloseScroll);
			
			//Add scroll
			scroll = new Scroll(buyable, true);
			addChild(scroll);
		}
		
		private function TouchCloseScroll(e:TouchEvent):void {
			var touch:Touch = e.getTouch(scrollTint, TouchPhase.BEGAN);
			if (touch && scroll) CloseScroll();
		}
		
		public function CloseScroll():void {
			if (!scroll.isRemoving) {
				//Remove scroll
				scroll.CloseingTween().onComplete = function():void {
					scroll.Cleanup();
					scroll.removeFromParent(true);
					scroll = null;
				}
				
				//Remove scroll tint
				scrollTint.removeEventListener(TouchEvent.TOUCH, CloseScroll);
				scrollTint.removeFromParent(true);
				scrollTint = null;
			}
		}
		
		private function BuyableBought(upEvent:UpgradeEvent):void {
			if(upEvent) trace(upEvent.message); //Trace message in the event
			CloseScroll();
		}
		
		public function AddNewSign(buyable:Buyable, x:int, y:int):void {
			if (buyable.isNew) {
				var newSign:NewSign = new NewSign(buyable, x, y);
				newList.push(newSign);
				addChild(newSign);
			}
		}
	}

}