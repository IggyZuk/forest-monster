package fm.game.backgrounds {
	import fm.engine.managers.BackgroundManager;
	import fm.states.GameState;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class SceneryFactory {
		
		public static const FOREST:int = 0;
		public static const SWAMP:int = 1;
		public static const SNOW:int = 2;
		public static const LAVA:int = 3;
		
		public var currentScenery:int;
		
		protected var game:GameState;
		protected var scenery:Scenery;
		
		public function SceneryFactory(game:GameState) { this.game = game; }
		
		public function Update(passedTime:Number):void { if(IsScenery()) scenery.Update(passedTime); }
		
		public function ChangeScenery(type:int):void {
			currentScenery = type;
			
			RemoveScenery();
			scenery = CreateScenery(type);
			
			if(IsScenery()) scenery.AddBackgrounds();
		}
		
		public function RemoveScenery():void {
			if(IsScenery()){
				scenery.Cleanup();
				scenery = null;
			}
		}
		
		private function IsScenery():Boolean { return Boolean(scenery); }
		
		protected function CreateScenery(type:int):Scenery {
			if (type == FOREST) return new ForestScenery(game, this);
			else if (type == SWAMP) return new SwampScenery(game, this);
			else if (type == SNOW) return new ForestScenery(game, this);
			else if (type == LAVA) return new ForestScenery(game, this);
			return null;
		}
		
	}

}