package fm.states {
	import fm.engine.GameEngine;
	import fm.engine.sound.Sfx;
	import fm.game.Art;
	import fm.game.Sounds;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class IntroSceneState extends State {
		
		private var imageList:Vector.<String> = new Vector.<String>;
		private var currentImage:Image;
		
		private var currentFlip:int;
		private var flipTimer:int;
		
		private var background:Quad;
		
		private var ambientSfx:Sfx;
		
		override public function Init():void {
			
			//Black Background
			background = new Quad(GameEngine.WIDTH, GameEngine.HEIGHT, 0x000000);
			addChild(background);
			
			imageList.push("cutscene_begin_1");
			imageList.push("cutscene_begin_2");
			imageList.push("cutscene_begin_3");
			imageList.push("cutscene_begin_4");
			
			//Add skipables
			stage.addEventListener(KeyboardEvent.KEY_DOWN, SkipToGame);
			stage.addEventListener(TouchEvent.TOUCH, SkipTouch);
			
			//Add ambient sound
			ambientSfx = GameEngine.instance.audioManager.AddSound(Sounds.ShopEnviroment);
			ambientSfx.loop(Sounds.AMBIENT);
		}
		
		override public function Cleanup():void {
			background.removeFromParent(true);
			if(currentImage) currentImage.removeFromParent(true);
			Starling.juggler.removeTweens(this);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, SkipToGame);
			stage.removeEventListener(TouchEvent.TOUCH, SkipTouch);
			
			GameEngine.instance.audioManager.GetSound(ambientSfx).stop();
		}
		
		private function Flip():void {
			
			if (currentFlip >= imageList.length) {
				GameEngine.instance.stateManager.ChangeState(new GameState);
				return;
			}
			
			if (currentFlip > 0) {
				var removeAnimation:Tween = new Tween(currentImage, 1, Transitions.EASE_OUT);
				removeAnimation.moveTo(-(currentImage.width >> 1), GameEngine.HEIGHT >> 1);
				removeAnimation.onComplete = function():void {
					removeAnimation.target.removeFromParent(true);
				}
				Starling.juggler.add(removeAnimation);
			}
			
			currentImage = AddImage(imageList[currentFlip]);
			
			var animation:Tween = new Tween(currentImage, 1, Transitions.EASE_OUT);
			animation.moveTo(GameEngine.WIDTH >> 1, GameEngine.HEIGHT >> 1);
			Starling.juggler.add(animation);
			
			GameEngine.instance.audioManager.AddSound(Sounds.PageFlip).play(Sounds.GUI);
			
			currentFlip++;
			flipTimer = 225;
		}
		
		private function AddImage(textureName:String):Image {
			var image:Image = new Image(Art.CutsceneAtlas.getTexture(textureName));
			image.pivotX = image.width >> 1;
			image.pivotY = image.height >> 1;
			image.x = GameEngine.WIDTH + (image.width >> 1);
			image.y = GameEngine.HEIGHT >> 1;
			addChild(image);
			return image;
		}
		
		override public function Update(passedTime:Number):void { 
			if (flipTimer <= 0) Flip();
			else flipTimer --;
		}
		
		private function SkipTouch(e:TouchEvent):void { if (e.getTouch(stage, TouchPhase.BEGAN)) Flip(); }
		private function SkipToGame():void { Flip(); }
		
	}

}