package fm.states {
	import fm.engine.GameEngine;
	import fm.engine.sound.Sfx;
	import fm.game.Art;
	import fm.game.Buyable;
	import fm.game.Sounds;
	import fm.gui.buttons.GoToMapButton;
	import fm.gui.gym.TechTree;
	import fm.gui.hud.MenuHud;
	import fm.gui.hud.NewSign;
	import fm.gui.shop.Scroll;
	import fm.events.UpgradeEvent;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class GymState extends State {
		
		private var hud:MenuHud;
		
		private var newList:Vector.<NewSign> = new Vector.<NewSign>;
		
		private var backgroundImage:Image;
		private var techTree:TechTree;
		private var newLayer:Sprite;
		private var mapButton:GoToMapButton;
		
		private var scroll:Scroll;
		private var scrollTint:Quad;
		
		override public function Init():void {
			addChild(backgroundImage = new Image(Art.GymBackground));
			
			hud = new MenuHud(true, false);
			mapButton = new GoToMapButton(50, GameEngine.HEIGHT - 50);
			newLayer = new Sprite();
			techTree = new TechTree(this);
			
			addChild(techTree);
			addChild(newLayer);
			addChild(mapButton);
			addChild(hud);
			
			GameEngine.instance.stage.addEventListener(UpgradeEvent.BOUGHT, BuyableBought);
			
			//If map music is playing, add some transformation on it.
			if (GameEngine.instance.audioManager.IsMusicPlaying(Sounds.MapMusic)) {
				var music:Sfx = GameEngine.instance.audioManager.music;
				music.volume = Sounds.MUSIC/4;
				music.pan = 0.75;
			}
		}
		
		override public function Cleanup():void {
			
			GameEngine.instance.stage.removeEventListener(UpgradeEvent.BOUGHT, BuyableBought);
			
			hud.Cleanup();
			hud.removeFromParent(true);
			
			backgroundImage.removeFromParent(true);
			
			techTree.Cleanup();
			techTree.removeFromParent(true);
			mapButton.Cleanup();
			mapButton.removeFromParent(true);
			
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
			newLayer.removeFromParent(true);
		}
		
		override public function Update(passedTime:Number):void {
			hud.Update(passedTime);
			techTree.Update();
			mapButton.Update();
			for each(var n:NewSign in newList) n.Update();
		}
		
		public function OpenScroll(buyable:Buyable):void {
			if (scroll) return;
			
			//Add scroll tint
			addChild(scrollTint = new Quad(GameEngine.WIDTH, GameEngine.HEIGHT, 0x000000));
			scrollTint.alpha = 0.5;
			scrollTint.addEventListener(TouchEvent.TOUCH, TouchCloseScroll);
			
			//Add scroll
			scroll = new Scroll(buyable, false);
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
			techTree.CheckAllIsBuyable();
			CloseScroll();
		}
		
		public function AddNewSign(buyable:Buyable, px:int, py:int):void {
			if (buyable.isNew) {
				var newSign:NewSign = new NewSign(buyable, px, py);
				newList.push(newSign);
				newLayer.addChild(newSign);
			}
		}
	}

}