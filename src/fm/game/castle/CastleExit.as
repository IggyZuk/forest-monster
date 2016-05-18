package fm.game.castle {
	import fm.states.GameState;
	import fm.game.backgrounds.Background;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class CastleExit extends CastleWall {
		
		public function CastleExit(game:GameState) {
			super(game);
			
			isAddingBackgrounds = false; //Dont add any backgrounds after this wall
			
			//Find distant wall and attach this wall to the end of it
			var distantBackground:Background = GetDistantBackground();
			SetStartX(distantBackground.x + distantBackground.width + (width >> 2));
			
			//Set castle for remove and add new scenery
			game.backgroundManager.GetCastle().SetCastleForRemove();
			game.backgroundManager.ChangeScene(game.backgroundManager.GetCurrentScenery() + 1);
		}
		
		//Returns the distant tile of the castle background tiles
		private function GetDistantBackground():Background {
			var distantBackground:Background;
			var distantX:int = int.MIN_VALUE;
			
			var castleList:Vector.<Background> = game.backgroundManager.GetCastle().GetCastleList();
			for (var i:int = 0 ; i < castleList.length; i++) {
				var b:Background = castleList[i];
				if (b.x >= distantX) {
					distantX = b.x;
					distantBackground = b;
				}
			}
			return distantBackground;
		}
		
	}

}