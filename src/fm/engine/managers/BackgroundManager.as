package fm.engine.managers {
	import fm.engine.GameEngine;
	import fm.game.backgrounds.SceneryFactory;
	import fm.game.castle.Castle;
	import fm.states.GameState;
	import fm.game.backgrounds.Background;
	import fm.game.Art;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class BackgroundManager implements IManager {
		
		private var game:GameState;
		
		private var sceneryFactory:SceneryFactory;
		
		private var castle:Castle;
		private var _isAddingCastle:Boolean = false;
		
		public var backLayer:Sprite;
		public var middleLayer:Sprite;
		public var castleLayer:Sprite;
		public var frontLayer:Sprite;
		
		private var shakeTimer:int;
		
		public function BackgroundManager(game:GameState) {
			this.game = game;
			
			InitLayers();
			sceneryFactory = new SceneryFactory(game);
		}
		
		public function Cleanup():void {
			if (castle) {
				castle.Cleanup();
				castle = null;
			}
			RemoveScene();
			DestroyLayers();
		}
		
		public function Update(passedTime:Number):void {
			
			sceneryFactory.Update(passedTime);
			
			//Update Castle
			if (castle) {
				if (castle.isActive) castle.Update(passedTime);
				else {
					castle.Cleanup();
					castle = null;
				}
			}
			
			Shake();
		}
		
		//Layer methods
		private function InitLayers():void {
			game.backLayer.addChild(backLayer = new Sprite);
			game.backLayer.addChild(middleLayer = new Sprite);
			game.backLayer.addChild(castleLayer = new Sprite);
			game.frontLayer.addChild(frontLayer = new Sprite);
		}
		
		private function DestroyLayers():void {
			backLayer.removeFromParent(true);
			middleLayer.removeFromParent(true);
			castleLayer.removeFromParent(true);
			frontLayer.removeFromParent(true);
		}
		
		//Castle Methods
		public function EnterCastle():void {
			if (castle) return;
			castle = new Castle(game);
			castle.AddEntrance();
			_isAddingCastle = true;
			trace("+Enter Castle+");
			//GameEngine.instance.ToggleSlowMotion();
		}
		public function ExitCastle():void {
			if (!castle) return;
			castle.AddExit();
			trace("-Exit Castle-");
			_isAddingCastle = false;
		}
		
		public function ChangeScene(scenery:int):void { sceneryFactory.ChangeScenery(scenery); }
		public function RemoveScene():void { sceneryFactory.RemoveScenery(); }
		public function GetCurrentScenery():int { return sceneryFactory.currentScenery; }
		public function GetCastle():Castle { return castle; }
		public function IsAddingCaslte():Boolean { return _isAddingCastle; }
		
		//Screen Shake
		public function AddShake(time:int = 10 ):void { shakeTimer = time; }
		private function Shake():void {
			if (shakeTimer >= 0) {
				shakeTimer--;
				
				game.gameContent.x = 0;
				game.gameContent.y = 0;
				game.gameContent.x = (Math.random() - Math.random()) * 10;
				game.gameContent.y = (Math.random() - Math.random()) * 10;
				
				if (shakeTimer <= 0) {
					game.gameContent.x = 0;
					game.gameContent.y = 0;
				}
			}
		}
		
	}

}