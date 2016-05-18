package fm.states {
	import flash.geom.Point;
	import fm.engine.GameEngine;
	import fm.engine.managers.AudioManager;
	import fm.engine.managers.ParticleManager;
	import fm.engine.sound.Sfx;
	import fm.game.Art;
	import fm.game.Sounds;
	import fm.gui.hud.MenuHud;
	import fm.gui.map.MapBird;
	import fm.gui.map.MapButton;
	import fm.game.particles.Smoke;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.MovieClip;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MapState extends State {
		
		private var hud:MenuHud;
		
		private var gameTimer:int;
		
		private var particleManager:ParticleManager;
		
		private var backgroundImage:Image;
		private var rayImage:Image;
		
		private var playButton:MapButton;
		private var shopButton:MapButton;
		private var gymButton:MapButton;
		
		private var effectLayer:Sprite;
		
		public var wind:Number;
		
		private var birdList:Vector.<MapBird> = new Vector.<MapBird>;
		
		override public function Init():void {
			
			wind = (Math.random() - Math.random()) * 2.25;
			effectLayer = new Sprite();
			
			particleManager = new ParticleManager(this, effectLayer);
			
			//Add background
			addChild(backgroundImage = new Image(Art.MapBackground));
			addChild(effectLayer);
			
			addChild(hud = new MenuHud(true, true));
			
			//Add MenuButtons
			addChild(playButton = new MapButton("map_play_button", GameState, 440, 295, 160, 35));
			addChild(shopButton = new MapButton("map_shop_button", ShopState, 170, 75, 35, 15));
			addChild(gymButton = new MapButton("map_gym_button", GymState, 30, 320, 30, 15));
			
			addChild(rayImage = new Image(Art.MapRays));
			rayImage.touchable = false;
			
			//Add birds
			for (var i:int = 0; i < 10; i++) AddBird();
			
			//Check if music is already playing, if not add, if yes reset volume and pan.
			var music:Sfx = GameEngine.instance.audioManager.music;
			if (!GameEngine.instance.audioManager.IsMusicPlaying(Sounds.MapMusic)) {
				GameEngine.instance.audioManager.AddMusic(Sounds.MapMusic).loop(Sounds.MUSIC);
			} else {
				music.volume = Sounds.MUSIC;
				music.pan = 0;
			}
		}
		
		override public function Cleanup():void {
			hud.Cleanup();
			hud.removeFromParent(true);
			
			backgroundImage.removeFromParent(true);
			playButton.Cleanup();
			playButton.removeFromParent(true);
			shopButton.Cleanup();
			shopButton.removeFromParent(true);
			gymButton.Cleanup();
			gymButton.removeFromParent(true);
			
			particleManager.Cleanup(); //Cleanup particles
			
			//Remove birds
			for each(var b:MapBird in birdList) {
				b.Cleanup();
				b.removeFromParent(true);
			}
			birdList.length = 0;
		}
		
		override public function Update(passedTime:Number):void {
			
			hud.Update(passedTime);
			
			particleManager.Update(passedTime);
			for each(var b:MapBird in birdList) b.Update(passedTime);
			
			//Add smoke
			gameTimer++;
			if (gameTimer % 8 == 0) {
				particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("pipesmoke_1"), 380, 190);
				particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("pipesmoke_2"), 380, 190);
			}
			
			var currentAlpha:Number = Math.sin(Starling.juggler.elapsedTime * 0.1);
			var strength:Number = currentAlpha > 0 ? 0 : 0.5;
			rayImage.alpha = Math.abs(currentAlpha) - strength;
		}
		
		private function AddBird():void {
			var bird:MapBird = new MapBird(this);
			birdList.push(bird);
			effectLayer.addChild(bird);
		}
		
	}

}