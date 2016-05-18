package fm.game.backgrounds {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.engine.managers.BackgroundManager;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Scenery {
		
		private var game:GameState;
		private var factory:SceneryFactory;
		
		private var _backLayer:Vector.<Background> = new Vector.<Background>;
		private var _middleLayer:Vector.<Background> = new Vector.<Background>;
		private var _frontLayer:Vector.<Background> = new Vector.<Background>;
		
		public function Scenery(game:GameState, factory:SceneryFactory) { 
			this.game = game;
			this.factory = factory;
		}
		
		final public function Cleanup():void {
			for each(var backBG:Background in backLayer) {
				backBG.Cleanup();
				backBG.removeFromParent(true);
			}
			for each(var middleBG:Background in middleLayer) {
				middleBG.Cleanup();
				middleBG.removeFromParent(true);
			}
			for each(var frontBG:Background in frontLayer) {
				frontBG.Cleanup();
				frontBG.removeFromParent(true);
			}
			backLayer.length = 0;
			middleLayer.length = 0;
			frontLayer.length = 0;
		}
		
		final public function AddBackgrounds():void {
			for each(var backBG:Background in backLayer) game.backgroundManager.backLayer.addChild(backBG);
			for each(var middleBG:Background in middleLayer) game.backgroundManager.middleLayer.addChild(middleBG);
			for each(var frontBG:Background in frontLayer) game.backgroundManager.frontLayer.addChild(frontBG);
		}
		
		final public function Update(passedTime:Number):void {
			UpdateList(backLayer, passedTime);
			UpdateList(middleLayer, passedTime);
			UpdateList(frontLayer, passedTime);
		}
		
		private function UpdateList(list:Vector.<Background>, passedTime:Number):void {
			for (var i:int = 0; i < list.length; i++) {
				var b:Background = list[i];
				if(b.isActive) b.Update(passedTime);
				else {
					b.Cleanup();
					b.removeFromParent(true);
					list.splice(i, 1);
					i--;
				}
			}
		}
		
		final protected function AddBackground(texture:Texture, px:int, py:int, distance:Number):Background {
			var b:Background = new Background(game, texture, distance, false);
			b.x = px;
			b.y = py;
			return b;
		}
		
		final protected function AddBackitem(texture:Texture, px:int, py:int, distance:Number):Background {
			var b:Background = new Background(game, texture, distance, true);
			b.x = px + ((factory.currentScenery != SceneryFactory.FOREST && distance == 1) ? GameEngine.WIDTH + game.monster.speed * 75 : 0);
			b.y = py;
			b.pivotY = b.height;
			return b;
		}
		
		public function get backLayer():Vector.<Background> { return _backLayer; }
		public function get middleLayer():Vector.<Background> { return _middleLayer; }
		public function get frontLayer():Vector.<Background> { return _frontLayer; }
	}

}