package fm.game.entities.enemies {
	import fm.states.GameState;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class StateEnemy extends Enemy {
		
		private var _animationState:int;
		private var movieVector:Vector.<MovieClip>;
		
		public function StateEnemy(game:GameState, speed:Number) {
			super(game, speed);
			
			movieVector = new Vector.<MovieClip>();
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			movieVector[animationState].removeFromParent(true);
			Starling.juggler.remove(movieVector[animationState]);
		}
		
		final protected function AddState(state:int, movie:MovieClip):void {
			movieVector[state] = movie;
		}
		
		final protected function ChangeState(state:int):void {
			movieVector[animationState].removeFromParent(true);
			Starling.juggler.remove(movieVector[animationState]);
			_animationState = state;
			body.addChild(movieVector[animationState]);
			Starling.juggler.add(movieVector[animationState]);										
		}
		
		protected function get animationState():int { return _animationState; }
		protected function get movieState():MovieClip { return movieVector[_animationState]; }
		
	}

}