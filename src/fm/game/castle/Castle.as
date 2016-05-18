package fm.game.castle {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.entities.kings.King;
	import fm.game.backgrounds.Background;
	import fm.game.castle.CastleWall;
	import fm.game.castle.CastleExit;
	
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Castle {
		
		private var game:GameState;
		
		public var isActive:Boolean = true;
		
		private var castleList:Vector.<Background> = new Vector.<Background>;
		
		private var isCastleAdded:Boolean;
		private var isSetRemove:Boolean;
		
		private var managerCleared:Boolean;
		
		public function Castle(game:GameState) {
			this.game = game;
		}
		
		public function Cleanup():void {
			for each(var b:Background in castleList) {
				b.Cleanup();
				b.removeFromParent(true);
			}
			castleList.length = 0;
		}
		
		public function Update(passedTime:Number):void {
			
			//Update backgrounds
			for (var j:int = 0; j < castleList.length; j++) {
				var c:Background = castleList[j];
				if(c.isActive) c.Update(passedTime);
				else {
					c.Cleanup();
					c.removeFromParent(true);
					castleList.splice(j, 1);
					j--;
				}
			}
			
			//Remove all backgrounds when monster enters castle
			if (isCastleAdded && !managerCleared) {
				if (castleList.length > 0 && castleList[0].x <= 0) {
					game.backgroundManager.RemoveScene();
					managerCleared = true;
					game.entityManager.AddEntity(King);
				}
			}
			
			//Remove castle when there are no more backgrounds
			if (isSetRemove && castleList.length <= 0) isActive = false;
		}
		
		//Add Nessesary backgrounds for castle
		public function AddBackgrounds(px:Number):void {
			game.backgroundManager.castleLayer.addChild(AddBackground(Art.BackgroundAtlas.getTexture("castle_bg"), px, 0, 2));
			game.backgroundManager.castleLayer.addChild(AddBackground(Art.BackgroundAtlas.getTexture("castle_bg"), px + GameEngine.WIDTH, 0, 2));
		}
		
		//Add Background
		public function AddBackground(texture:Texture, px:int, py:int, distance:Number):Background {
			var b:Background = new Background(game, texture, distance, false);
			b.x = px;
			b.y = py;
			castleList.push(b);
			if(GameEngine.instance.debug) b.alpha = 0.5;
			return b;
		}
		
		//Add Castle Entrance => Bubble -> CastleWall -> AddCastle
		public function AddEntrance():void {
			game.obstacleManager.AddBubble(CastleWall, "warning_wall", 300);
			isCastleAdded = true;
		}
		
		//Add Castle Exit => Bubble -> SetCastleForRemove
		public function AddExit():void { 
			game.obstacleManager.AddBubble(CastleExit, "warning_wall", 300); 
			isSetRemove = false;
		}
		
		public function SetCastleForRemove():void {
			for each(var c:Background in castleList) c.SetRemove();
			isSetRemove = true;
		}
		
		public function GetCastleList():Vector.<Background> { return castleList; }
		
	}

}