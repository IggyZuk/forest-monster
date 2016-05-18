package fm.game.entities {
	import fm.engine.GameEngine;
	import fm.game.particles.Smoke;
	import fm.game.Sounds;
	import fm.game.Tracker;
	import fm.game.Upgrades;
	import fm.states.GameOverState;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.utils.Line;
	import fm.utils.Vec2;
	import starling.filters.ColorMatrixFilter;
	
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.*;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Monster extends Entity {
		
		public var isDead:Boolean;
		
		private var health_max:int;
		private var _health:int;
		private var _speed:Number;
		private var _stamina:Number;
		
		private var lifeTimer:int;
		private var upperVelocity:Vec2;
		private var hurtTimer:int;
		private var hurtTimerAdd:int = 100;
		
		//Dynamic properties
		public static var s_startHealth:Number;
		public static var s_startSpeed:Number;
		public static var s_maxSpeed:Number;
		public static var s_addSpeed:Number;
		public static var s_maxStamina:Number;
		public static var s_addStamina:Number;
		public static var s_range:Number;
		
		public static var s_xPos:Number;
		public static var s_yPos:Number;
		public static var s_xMotion:Number;
		public static var s_yMotion:Number;
		public static var s_bodyRotation:Number;
		public static var s_faceMotion:Number;
		
		public static const NORMAL:int = 0;
		public static const LEFT_GROUND:int = 1;
		public static const LEFT_AIR:int = 2;
		public static const RIGHT_GROUND:int = 3;
		public static const RIGHT_AIR:int = 4;
		
		private const HURT:int = 5;
		private const FACE_WTF:int = 7;
		
		//Monster Parts
		private var bottomBody:Image;
		private var upperBody:Sprite;
		private var body:MovieClip;
		private var face:MovieClip;
		private var leftPaw:Paw;
		private var rightPaw:Paw;
		
		private var staticFace:int;
		private var pawCount:int;
		private var facePos:Point;
		
		private var bodyLine:Line;
		
		public function Monster(game:GameState) {
			super(game);
			
			//Set static properties
			_health = s_startHealth;
			_speed = s_startSpeed;
			_stamina = s_maxStamina;
			
			//Upgrades
			if (GameEngine.instance.upgradeManager.IsUpgraded(Upgrades.HP_UPGRADE_1)) _health += 4;
			if (GameEngine.instance.upgradeManager.IsUpgraded(Upgrades.HP_UPGRADE_2)) _health += 8;
			if (GameEngine.instance.upgradeManager.IsUpgraded(Upgrades.HP_UPGRADE_3)) _health += 12;
			
			health_max = _health;
			
			ConstructVisuals();
			
			upperVelocity = new Vec2();
			x = s_xPos;
			y = s_yPos;
			groundY = y - 15;
			
			GameEngine.instance.audioManager.AddSound(Sounds.Meow).play(Sounds.EFFECT);
		}
		
		override public function Cleanup():void {
			bottomBody.removeFromParent(true);
			upperBody.removeFromParent(true);
			body.removeFromParent(true);
			face.removeFromParent(true);
			leftPaw.Cleanup();
			leftPaw.removeFromParent(true);
			rightPaw.Cleanup();
			rightPaw.removeFromParent(true);
		}
		
		override public function Update(passedTime:Number):void {
			
			lifeTimer++;
			
			//Hurt timer
			if (hurtTimer >= 0) {
				
				if (hurtTimer <= hurtTimerAdd * 0.95) {
					upperBody.filter = null;
					if (hurtTimer <= hurtTimerAdd >> 1) ChangeFaceState(HURT, 1);
				}
				
				if (hurtTimer <= 0) ChangeBodyState(NORMAL);
				
				upperVelocity.x -= hurtTimer * 0.05;
				if (_speed >= 10 && hurtTimer % 6 == 0) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x + 80, y - 15);
				if (_speed >= 10 && hurtTimer % 8 == 0) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke_2"), x + 100, y - 15);
				hurtTimer -= passedTime;
			}
			
			//Update hud properties
			Tracker.instance.speedCount = _speed * 2.5;
			Tracker.instance.distanceCount += _speed * 0.025;
			
			if (isDead) DeadMovement();
			else AliveMovement(passedTime);
		}
		
		private function AliveMovement(passedTime:Number):void {
			
			//Add Speed and Stamina
			if (_speed < s_maxSpeed) _speed += s_addSpeed * passedTime;
			if (_stamina >= s_maxStamina) _stamina = s_maxStamina;
			else _stamina += s_addStamina * passedTime;
			
			//UpperBody rotation velocity
			upperVelocity.x += Math.sin(lifeTimer * s_bodyRotation);
			if (upperVelocity.x < -15) upperVelocity.x = -15;
			
			//Add natural motion to parts of monster
			bottomBody.x += Math.cos(lifeTimer * 0.1) * s_xMotion;
			bottomBody.y += Math.sin(lifeTimer * 0.1) * s_yMotion;
			upperBody.x += Math.cos(lifeTimer * 0.1) * s_xMotion * 0.8;
			upperBody.rotation = deg2rad(upperVelocity.x);
			face.y += Math.sin(lifeTimer * 0.1) * s_faceMotion;
			
			upperVelocity.x *= 0.9;
			
			//x = Math.cos(_lifeTimer*0.05)*300;
			
			//Draw line
			if (bodyLine) {
				bodyLine.removeFromParent(true);
				bodyLine = null;
			}
			
			if(GameEngine.instance.debug){
				bodyLine = new Line(GetBodyX(), 0, 0xFF0000);
				bodyLine.lineTo(GetBodyX(), 600);
				game.frontLayer.addChild(bodyLine);
			}
		}
		
		private function DeadMovement():void {
			if (_speed > 0) {
				_speed -= 0.2;
				if (_speed >= 10 && _speed % 6 == 0) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x + 80, y - 15);
				if (_speed >= 10 && _speed % 8 == 0) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke_2"), x + 100, y - 15);
			} else _speed = 0;
			
			if (upperBody.rotation <= Math.PI/2) upperVelocity.x += 8;
			upperBody.rotation = deg2rad(upperVelocity.x);
			
			upperVelocity.x *= 0.9;
		}
		
		public function Attack(px:int, py:int):void {
			if (isDead) return;
			if (_stamina <= 25) return; //  || hurtTimer > 0
			
			//Make sure it is in range
			var dx:Number = (x+100) - px;
			var dy:Number = (y-180) - py;
			var dis:Number = Math.sqrt(dx * dx + dy * dy);
			
			if (dis >= s_range) {
				px += dx / dis * (dis - s_range);
				py += dy / dis * (dis - s_range);
			}
			
			//Attack with different paws
			var paw:Paw;
			if (pawCount == 0) {
				paw = leftPaw;
				pawCount = 1;
			} else if (pawCount == 1) {
				paw = rightPaw;
				pawCount = 0;
			}
			
			//Ground / Air, Check if can attack, then reduce stamina
			if (py >= 320) {
				if (paw.Attack(px, py, true)) AttackSuccess();
			} else if (py < 320) {
				if (paw.Attack(px, py, false)) AttackSuccess();
			}
		}
		
		private function AttackSuccess():void {
			_stamina -= 25;
		}
		
		public function ChangeBodyState(state:int):void {
			if (state == NORMAL) {
				//Not attacking
				body.currentFrame = 0;
				ChangeFaceState(NORMAL);
			} else if (state == LEFT_GROUND || state == LEFT_AIR) {
				//Attacking from left
				body.currentFrame = 0;
				ChangeFaceState(state == LEFT_GROUND ? LEFT_GROUND : LEFT_AIR);
			} else if (state == RIGHT_GROUND || state == RIGHT_AIR) {
				//Attacking from right
				body.currentFrame = 1;
				ChangeFaceState(state == RIGHT_GROUND ? RIGHT_GROUND : RIGHT_AIR);
			} else if (state == HURT) {
				body.currentFrame = 0;
				ChangeFaceState(HURT);
			}
		}
		
		public function ChangeStaticFace(state:int):void { staticFace = state; }
		
		public function ChangeFaceState(state:int, offSet:int = 0):void {
			//Reset Face Position
			AdjustFace();
			
			if (state == NORMAL) {
				face.currentFrame = staticFace;
			} else if (state == LEFT_AIR) {
				face.currentFrame = 1 + offSet;
			} else if (state == RIGHT_AIR) {
				face.currentFrame = 2 + offSet;
				AdjustFace(48, 10);
			} else if (state == LEFT_GROUND) {
				face.currentFrame = 3 + offSet;
			} else if (state == RIGHT_GROUND) {
				face.currentFrame = 4 + offSet;
				AdjustFace(48, 10);
			} else if (state == HURT) {
				face.currentFrame = 5 + offSet;
				AdjustFace(0, 0);
			}
		}
		
		private function AdjustFace(px:Number = 0, py:Number = 0):void {
			face.x = facePos.x+px;
			face.y = facePos.y+py;
		}
		
		public function Hurt(damage:int = 1):void {
			
			const SLOW_DOWN_CONSTANT:int = 1.5;
			
			_health -= damage;
			if (health <= 0) _health = 0;
			game.hud.SetHearts(health);
			
			hurtTimer = hurtTimerAdd;
			upperVelocity.x -= 5;
			_speed -= damage * SLOW_DOWN_CONSTANT;
			if (speed <= 0) _speed = 0;
			
			//Color upper part white
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.invert();
			upperBody.filter = filter;
			
			ChangeBodyState(HURT);
			
			IsGameOver();
		}
		
		private function IsGameOver():void {
			if (health <= 0) Tracker.instance.deathReason = Tracker.DEATH_HEALTH;
			if (speed <= 0) Tracker.instance.deathReason = Tracker.DEATH_SPEED;
			if(Tracker.instance.deathReason != Tracker.DEATH_NONE) {
				isDead = true;
				GameEngine.instance.stateManager.ChangeState(new GameOverState);
			}
		}
		
		public function AddHealth(hp:int = 1):void {
			_health += hp;
			if (_health >= health_max) _health = health_max;
			game.hud.SetHearts(_health);
		}
		
		private function ConstructVisuals():void {
			
			//Add Bottom Body
			bottomBody = new Image(Art.MonsterAtlas.getTexture("body_bottom"));
				bottomBody.pivotX = bottomBody.width >> 1;
				bottomBody.pivotY = bottomBody.height;
				bottomBody.x = -130;
				bottomBody.y = 0;
			addChild(bottomBody);
			
			//Add Upper Body
			upperBody = new Sprite();
			
				//Add Body as Movieclip
				var body_frames:Vector.<Texture> = new Vector.<Texture>; 
				body_frames.push(Art.MonsterAtlas.getTexture("body_normal"));
				body_frames.push(Art.MonsterAtlas.getTexture("body_attack"));
				
				body = new MovieClip(body_frames);
					body.pivotX = body.width >> 1;
					body.pivotY = body.height >> 1;
					body.x = 100;
					body.y = 0;
					body.currentFrame = 0;
				upperBody.addChild(body);
				
				//Set Upper Body
				upperBody.pivotX = upperBody.width >> 1;
				upperBody.pivotY = 150;
				upperBody.x = 110;
				upperBody.y = -35;
			
			addChild(upperBody);
			
			//Add Face
			var face_frames:Vector.<Texture> = new Vector.<Texture>; 
			face_frames.push(Art.MonsterAtlas.getTexture("face_normal"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_attack_air_left"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_attack_air_right"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_attack_ground_left"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_attack_ground_right"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_hurt_1"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_hurt_2"));
			face_frames.push(Art.MonsterAtlas.getTexture("face_wtf"));
			
			if (Math.random() < 0.5) ChangeStaticFace(NORMAL);
			else ChangeStaticFace(FACE_WTF);
			
			facePos = new Point(140,-55);
			
			face = new MovieClip(face_frames);
				face.pivotX = face.width >> 1;
				face.pivotY = face.height >> 1;
				face.x = facePos.x;
				face.y = facePos.y;
				face.currentFrame = 0;
			upperBody.addChild(face);
			
			//Add Paws
			addChildAt(leftPaw = new Paw(game, 160,-140, false), 0);
			addChild(rightPaw = new Paw(game, 120, -80, true));
		}
		
		public function GetMoveSpeed():Number { return _speed * 0.5; }
		public function GetSpeedTick():Number { return _speed * 0.01; }
		public function GetBodyX():Number { return (x + upperBody.x + upperBody.rotation*360); }
		public function GetPaw(isRight:Boolean):Paw {
			if (isRight) return rightPaw;
			else return leftPaw;
		}
		
		public function get health():Number { return _health; }
		public function get speed():Number { return _speed; }
		public function get stamina():Number { return _stamina; }
	}

}