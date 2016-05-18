package fm.game.backgrounds {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.states.GameState;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ForestScenery extends Scenery {
		
		public function ForestScenery(game:GameState, factory:SceneryFactory) {
			super(game, factory);
			
			//Back layers
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("far_background_9"), 0, 25, 9));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("far_background_9"), GameEngine.WIDTH, 25, 9));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_trunk_8"), 0, 80, 8));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_trunk_8"), GameEngine.WIDTH, 80, 8));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_top_7"), 0, 50, 7));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_top_7"), GameEngine.WIDTH, 50, 7));
			
			//Middle layers
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("back_bush_4"), 0, 280, 4));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("back_bush_4"), GameEngine.WIDTH, 280, 4));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_top_3"), 0, 40, 3));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("tree_top_3"), GameEngine.WIDTH, 40, 3));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("road_ground_2"), 0, 380, 2));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("road_ground_2"), GameEngine.WIDTH, 380, 2));
			
			//Add - Backitems
			var i:int;
			for (i = 0; i < Math.random() * 5 + 5; i++) backLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("tree_trunk_6_" + (Math.floor(Math.random() * 3) + 1)), i * Math.random() * 350, 380, 6));
			for (i = 0; i < Math.random() * 5 + 5; i++) backLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("tree_trunk_5_" + (Math.floor(Math.random() * 3) + 1)), i * Math.random() * 350, 380, 5));
			for (i = 0; i < Math.random() * 6 + 6; i++) middleLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("front_bush_2_" + (Math.floor(Math.random() * 4) + 1)), i * Math.random() * 350, 410, 2));
			for (i = 0; i < Math.random() * 8 + 8; i++) frontLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("front_bush_1_" + (Math.floor(Math.random() * 4) + 1)), i * Math.random() * 350, 560, 1));
		}
	}

}