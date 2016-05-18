package fm.engine {
	import fm.engine.managers.AudioManager;
	import fm.engine.managers.StateManager;
	import fm.engine.managers.ResourceManager;
	import fm.engine.managers.UpgradeManager;
	import fm.events.ResourceEvent;
	import fm.states.*;
	import fm.game.Art;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import fr.kouma.starling.utils.Stats;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class GameEngine extends Sprite implements IAnimatable {
		
		public static const WIDTH:int = 800;
		public static const HEIGHT:int = 600;
		
		public static var title:String;
		
		private static var _instance:GameEngine;
		
		public var gameContent:Sprite;
		public var resourceManager:ResourceManager;
		public var stateManager:StateManager;
		public var audioManager:AudioManager;
		public var upgradeManager:UpgradeManager;
		
		public var debug:Boolean = false;
		public var turbo:Boolean = false;
		public var isPaused:Boolean = false;
		public var motion:Number = 1;
		
		public function GameEngine() {
			if (!_instance) _instance = this;
			
			Starling.current.stop();
			
			//Load Script Resources
			resourceManager = new ResourceManager(this);
			addEventListener(ResourceEvent.LOADED, Init);
		}
		
		//Resources loaded => Initialize
		private function Init(e:Event):void {
			trace("# Engine Initialized #");
			removeEventListener(ResourceEvent.LOADED, Init);
			
			title = Art.Config.game.@name; //Set game title
			
			addChild(gameContent = new Sprite); //Add game content sprite
			var stats:Stats = new Stats();
			stats.alpha = 0.75;
			addChild(stats); //Add stats
			
			InitManagers();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			Starling.current.start();
		}
		
		private function InitManagers():void {
			stateManager = new StateManager(this, new MenuState); // Init State Manager
			upgradeManager = new UpgradeManager();
			audioManager = new AudioManager(); // Init Sound Manager
		}
		
		//Remove Engine
		public function Cleanup():void {}
		
		public function advanceTime(passedTime:Number):void {
			for (var i:int = 0; i < (turbo ? 4 : 1); i++) {
				stateManager.Update(passedTime * 60);
			}
		}
		
		public function KeyDown(e:KeyboardEvent):void {
			
			//Change States
			if(e.keyCode == Keyboard.NUMBER_1) stateManager.ChangeState(new MenuState);
			else if (e.keyCode == Keyboard.NUMBER_2 || e.keyCode == Keyboard.SPACE) stateManager.ChangeState(new GameState);
			else if (e.keyCode == Keyboard.NUMBER_3) stateManager.ChangeState(new MapState);
			else if (e.keyCode == Keyboard.NUMBER_4) stateManager.ChangeState(new ShopState);
			else if (e.keyCode == Keyboard.NUMBER_5) stateManager.ChangeState(new GymState);
			else if (e.keyCode == Keyboard.NUMBER_6) stateManager.ChangeState(new GameOverState);
			
			//Debug controls
			if (e.keyCode == Keyboard.P) isPaused = !isPaused;
			if (e.keyCode == Keyboard.C) debug = !debug;
			if (e.keyCode == Keyboard.X) turbo = !turbo;
			if (e.keyCode == Keyboard.Z) resourceManager.LoadResources();
			if (e.keyCode == Keyboard.V) ToggleSlowMotion();
		}
		
		public function ToggleSlowMotion():void {
			if (motion == 1) motion = 0.1;
			else if (motion == 0.1) motion = 1;
		}
		
		public static function get instance():GameEngine { return _instance; }
		public static function get stage():Stage { return instance.stage; }
	}
	
	
}