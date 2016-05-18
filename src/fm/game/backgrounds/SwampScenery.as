package fm.game.backgrounds {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class SwampScenery extends Scenery {
		
		public function SwampScenery(game:GameState, factory:SceneryFactory) {
			super(game, factory);
			
			//Back layers
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_bg_8"), 0, 0, 9));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_bg_8"), GameEngine.WIDTH, 0, 9));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_tree_6"), 0, 80, 8));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_tree_6"), GameEngine.WIDTH, 80, 8));
			
			//Middle layers
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_fog_4"), 0, 0, 5));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_fog_4"), GameEngine.WIDTH, 0, 5));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_road_7"), 0, 395, 2));
			backLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_road_7"), GameEngine.WIDTH, 395, 2));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_fog_3"), 0, 260, 3));
			middleLayer.push(AddBackground(Art.BackgroundAtlas.getTexture("swamp_fog_3"), GameEngine.WIDTH, 260, 3));
			
			//Add - Backitems
			var i:int;
			for (i = 0; i < Math.random() * 4 + 4; i++) backLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("swamp_tree_5_" + ((i%3)+1)), (i * 200) + Math.random()*200, 320, 6));
			for (i = 0; i < Math.random() * 4 + 4; i++) backLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("swamp_plant_2_" + ((i%5)+1)), (i * 100) + Math.random()*200, 340, 4));
			for (i = 0; i < Math.random() * 6 + 6; i++) frontLayer.push(AddBackitem(Art.BackgroundAtlas.getTexture("swamp_bush_1_" + ((i%5)+1)), (i * 100) + Math.random()*200, 560, 1));
		}
	}
}