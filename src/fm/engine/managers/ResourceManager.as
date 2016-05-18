package fm.engine.managers {
	import fm.engine.GameEngine;
	import fm.events.ResourceEvent;
	import fm.game.Art;
	import fm.game.entities.Monster;
	import fm.game.entities.enemies.*;
	import fm.game.entities.kings.*;
	import fm.game.particles.*;
	import fm.game.projectiles.*;
	import fm.game.obstacles.*;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
    import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ResourceManager {
		
		private var engine:GameEngine;
		
		private var totalResources:int;
		private var resoucesLoaded:int;
		
		private var resourceTimer:Number;
		
		public function ResourceManager(engine:GameEngine):void {
			this.engine = engine;
			LoadResources();
		}
		
		//When a resource is loaded, check if all resources are loaded, if yes send out an event to the engine
		private function ResourceLoaded():void {
			resoucesLoaded++;
			if (resoucesLoaded >= totalResources) {
				trace("- Resources Loaded in", ((getTimer() - resourceTimer)/1000), " seconds -");
				engine.dispatchEvent(new ResourceEvent(ResourceEvent.LOADED));
			}
		}
		
		public function LoadResources():void {
			trace("# Load Resources #");
			
			resourceTimer = getTimer();
			
			totalResources = resoucesLoaded = 0;
			
			//Load & Parse All Data
			ProcessData("config", ParseConfigData);
			ProcessData("monster", ParseMonsterData);
			ProcessData("entities", ParseEntityData);
			ProcessData("particles", ParseParticleData);
			ProcessData("projectiles", ParseProjectileData);
			ProcessData("shop", ParseShopData);
			ProcessData("gym", ParseGymData);
		}
		
		private function ProcessData(sourceName:String, ParseFunction:Function):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, ParseFunction);
			loader.load(new URLRequest("script/"+sourceName+".xml"));
			totalResources++;
		}
		
		private function ParseConfigData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Art.Config = xml;
			
			ResourceLoaded();
		}
		
		private function ParseMonsterData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Monster.s_startHealth = xml.monster[0].@start_health;
			Monster.s_startSpeed = xml.monster[0].@start_speed;
			Monster.s_maxSpeed = xml.monster[0].@max_speed;
			Monster.s_addSpeed = xml.monster[0].@add_speed;
			Monster.s_maxStamina = xml.monster[0].@max_stamina;
			Monster.s_addStamina = xml.monster[0].@add_stamina;
			Monster.s_range = xml.monster[0].@range;
			
			Monster.s_xPos = xml.monster[0].@x_pos;
			Monster.s_yPos = xml.monster[0].@y_pos;
			Monster.s_xMotion = xml.monster[0].@x_motion;
			Monster.s_yMotion = xml.monster[0].@y_motion;
			Monster.s_bodyRotation = xml.monster[0].@body_rotation;
			Monster.s_faceMotion = xml.monster[0].@face_motion;
			
			ResourceLoaded();
		}
		
		private function ParseEntityData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Enemy.s_gravity = xml.@gravity;
			Enemy.s_jump = xml.@jump;
			
			Peasant.s_speed = xml.entity[0].@speed;
			FlyingKnight.s_speed = xml.entity[1].@speed;
			HorseKnight.s_speed = xml.entity[2].@speed;
			HorseArcher.s_speed = xml.entity[3].@speed;
			FishFairy.s_speed = xml.entity[4].@speed;
			King.s_speed = xml.entity[5].@speed;
			Chicken.s_speed = xml.entity[6].@speed;
			
			ResourceLoaded();
		}
		
		private function ParseParticleData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Smoke.s_life = xml.particle[0].@life;
			Smoke.s_lifeRandom = xml.particle[0].@life_random;
			Smoke.s_angleStart = xml.particle[0].@angle;
			Smoke.s_angleAdd = xml.particle[0].@angle_add;
			Smoke.s_scaleStart = xml.particle[0].@scale;
			Smoke.s_scaleAdd = xml.particle[0].@scale_add;
			
			Feather.s_gravity = xml.particle[1].@gravity;
			Feather.s_velocityX = xml.particle[1].@velocity_x;
			Feather.s_angleSpeed = xml.particle[1].@angle_speed;
			Feather.s_slowFactor = xml.particle[1].@slow_factor;
			
			Debris.s_movement = xml.particle[2].@movement;
			Debris.s_movementRandom = xml.particle[2].@movement_random;
			Debris.s_gravity = xml.particle[2].@gravity;
			Debris.s_velocityX = xml.particle[2].@velocity_x;
			Debris.s_velocityY = xml.particle[2].@velocity_y;
			Debris.s_angleAdd = xml.particle[2].@angle_add;
			
			HeavyDebris.s_movement = xml.particle[3].@movement;
			HeavyDebris.s_movementRandom = xml.particle[3].@movement_random;
			HeavyDebris.s_gravity = xml.particle[3].@gravity;
			HeavyDebris.s_velocityX = xml.particle[3].@velocity_x;
			HeavyDebris.s_velocityY = xml.particle[3].@velocity_y;
			HeavyDebris.s_angleAdd = xml.particle[3].@angle_add;
			
			SmokeDebris.s_smokeAddSpeed = xml.particle[4].@smoke_add_speed;
			SmokeDebris.s_smokeAddRandom = xml.particle[4].@smoke_add_random;
			
			WhiteLife.s_gravity = xml.particle[5].@gravity;
			WhiteLife.s_velocityX = xml.particle[5].@velocity_x;
			WhiteLife.s_velocityY = xml.particle[5].@velocity_y;
			
			ResourceLoaded();
		}
		
		private function ParseProjectileData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Arrow.s_gravity = xml.projectile[0].@gravity;
			Arrow.s_startAngle = xml.projectile[0].@start_angle;
			Arrow.s_startSpeed = xml.projectile[0].@start_speed;
			Arrow.s_slowFactor = xml.projectile[0].@slow_factor;
			
			ResourceLoaded();
		}
		
		private function ParseShopData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Art.ShopXML = xml;
			
			ResourceLoaded();
		}
		
		private function ParseGymData(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			Art.GymXML = xml;
			
			ResourceLoaded();
		}
	}

}