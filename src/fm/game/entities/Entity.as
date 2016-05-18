package fm.game.entities {
	import fm.states.GameState;
	
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Entity extends Sprite {
		
		public var isActive:Boolean = true;
		public var groundY:int;
		
		protected var game:GameState;
		
		public function Entity(game:GameState) {
			this.game = game;
		}
		
		public function Cleanup():void { }
		
		public function Update(passedTime:Number):void { }
		
	}

}