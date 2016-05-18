package fm.states {
	import fm.engine.GameEngine;
	import fm.engine.managers.*;
	import fm.game.backgrounds.SceneryFactory;
	import fm.game.Sounds;
	import fm.game.Tracker;
	import fm.gui.hud.GameHud;
	import fm.game.entities.Monster;
	import fm.states.State;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class GameState extends State {
		
		public var backgroundManager:BackgroundManager;
		public var entityManager:EntityManager;
		public var obstacleManager:ObstacleManager;
		public var projectileManager:ProjectileManager;
		public var particleManager:ParticleManager;
		
		private var lastTouchStamp:Number;
		
		public var hud:GameHud;
		public var monster:Monster;
		
		//Layers
		public var hudLayer:Sprite;
		public var frontLayer:Sprite;
		public var extraLayer:Sprite;
		public var middleLayer:Sprite;
		public var backLayer:Sprite;
		
		public var gameContent:Sprite;
		
		override public function Init():void {
			
			Tracker.instance.ResetCounters();
			
			InitLayers();
			
			backgroundManager = new BackgroundManager(this);
			entityManager = new EntityManager(this);
			obstacleManager = new ObstacleManager(this);
			projectileManager = new ProjectileManager(this);
			particleManager = new ParticleManager(this, extraLayer);
			
			AddMonster();
			backgroundManager.ChangeScene(SceneryFactory.FOREST);
			
			hudLayer.addChild(hud = new GameHud(this));
			
			stage.addEventListener(TouchEvent.TOUCH, OnTouch);
			
			//GameEngine.instance.audioManager.AddMusic(Sounds.GameMusic).loop(Sounds.MUSIC);
		}
		
		override public function Cleanup():void {
			monster.Cleanup();
			
			particleManager.Cleanup();
			projectileManager.Cleanup();
			obstacleManager.Cleanup();
			entityManager.Cleanup();
			backgroundManager.Cleanup();
			
			DestroyLayers();
			
			stage.removeEventListener(TouchEvent.TOUCH, OnTouch);
		}
		
		//Game loop
		override public function Update(passedTime:Number):void {
			
			monster.Update(passedTime);
			
			hud.Update(passedTime);
			backgroundManager.Update(passedTime);
			entityManager.Update(passedTime);
			obstacleManager.Update(passedTime);
			projectileManager.Update(passedTime);
			particleManager.Update(passedTime);
		}
		
		//Layer methods
		private function InitLayers():void {
			addChild(gameContent = new Sprite);
			gameContent.addChild(backLayer = new Sprite);
			gameContent.addChild(middleLayer = new Sprite);
			gameContent.addChild(extraLayer = new Sprite);
			gameContent.addChild(frontLayer = new Sprite);
			addChild(hudLayer = new Sprite);
		}
		private function DestroyLayers():void {
			hudLayer.removeFromParent(true);
			frontLayer.removeFromParent(true);
			extraLayer.removeFromParent(true);
			middleLayer.removeFromParent(true);
			backLayer.removeFromParent(true);
			gameContent.removeFromParent(true);
		}
		
		private function OnTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch && lastTouchStamp != touch.timestamp) {
				monster.Attack(touch.globalX, touch.globalY);
				lastTouchStamp = touch.timestamp;
			}
		}
		
		//Create new Monster
		private function AddMonster():void {
			monster = new Monster(this);
			middleLayer.addChild(monster);
		}

	}

}