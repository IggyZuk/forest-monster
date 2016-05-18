package fm.game {
	
	/**
	 * Stores class names for all sound effects
	 * Sounds can later be used with the AudioManager
	 * GameEngine.instance.audioManager.AddSound(Sounds.Example).play(Sounds.EFFECT);
	 * @author Ignatus Zuk
	 */
	
	public class Sounds {
		
		/* Volumes */
		public static const EFFECT:Number = 0.15;
		public static const AMBIENT:Number = 0.4;
		public static const VOICE:Number = 0.75;
		public static const MUSIC:Number = 0.45;
		public static const GUI:Number = 0.80;
		
		/* Music */
		[Embed(source = "../../res/audio/music/map_music.mp3")] 			public static const MapMusic:Class;
		[Embed(source = "../../res/audio/music/game_music.mp3")] 			public static const GameMusic:Class;
		[Embed(source = "../../res/audio/music/game_over_music.mp3")] 		public static const GameOverMusic:Class;
		
		/* Ambient */
		[Embed(source = "../../res/audio/ambient/map_wilderness.mp3")] 	public static const MapWilderness:Class;
		[Embed(source = "../../res/audio/ambient/shop_enviroment.mp3")] 	public static const ShopEnviroment:Class;
		
		/* Monster */
		[Embed(source = "../../res/audio/monster/smash.mp3")] 				public static const Smash:Class;
		[Embed(source = "../../res/audio/monster/step_1.mp3")] 			public static const Step_1:Class;
		[Embed(source = "../../res/audio/monster/step_2.mp3")] 			public static const Step_2:Class;
		[Embed(source = "../../res/audio/monster/meow.mp3")] 				public static const Meow:Class;
		
		/* Gui */
		[Embed(source = "../../res/audio/gui/page_flip.mp3")] 				public static const PageFlip:Class;
	}

}