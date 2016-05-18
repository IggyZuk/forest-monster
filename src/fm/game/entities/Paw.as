package fm.game.entities {
	import fm.engine.GameEngine;
	import fm.engine.sound.Sfx;
	import fm.game.Sounds;
	import fm.states.GameState;
	import fm.game.particles.Smoke;
	import fm.game.Art;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Paw extends Sprite {
		
		private var game:GameState;
		
		public static const NONE:int = 0;
		public static const WALK:int = 1;
		public static const ATTACK_GROUND:int = 2;
		public static const ATTACK_AIR:int = 3;
		
		private var state:int;
		private var body:MovieClip;
		
		private var isRight:Boolean;
		private var animationState:int;
		
		private var originPos:Point;
		private var aimTarget:Point;
		
		private var animation:Tween;
		
		public function Paw(game:GameState, px:int, py:int, isRight:Boolean) {
			
			this.game = game;
			this.originPos = new Point(px, py);
			this.isRight = isRight;
			this.animationState = int(isRight);
			
			addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			var frames:Vector.<Texture> = new Vector.<Texture>;
				
			if (isRight) {
				
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_right_1")); // 0
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_right_2")); // 1
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_right_3")); // 2
				
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_ground_right_1")); // 3
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_ground_right_2")); // 4
				
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_right_1")); // 5
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_right_2")); // 6
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_right_3")); // 7
				
			} else {
				
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_left_1")); // 0
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_left_2")); // 1
				frames.push(Art.MonsterAtlas.getTexture("paw_walk_left_3")); // 2
				
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_ground_left_1")); // 3
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_ground_left_2")); // 4
				
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_left_1")); // 5
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_left_2")); // 6
				frames.push(Art.MonsterAtlas.getTexture("paw_attack_air_left_3")); // 7
			}
			
			body = new MovieClip(frames);
			scaleX = scaleY = isRight ? 1.1 : 1;
			addChild(body);
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			
			//Start Walking
			ChangeState(WALK, animationState);
		}
		
		public function Cleanup():void {
			Starling.juggler.removeTweens(this);
			body.removeFromParent(true);
		}
		
		//Tween animation
		private function AnimateTo(px:int, py:int, angle:Number, time:Number, transition:String, move:Boolean = true):void {
			
			Starling.juggler.removeTweens(this);
			if (animation) animation.reset(this, time, transition); // Reset
			else           animation = new Tween(this, time, transition);
			
			if (move) {
				animation.moveTo(px * 0.75 + originPos.x, py * 0.75 + originPos.y);
				animation.animate("rotation", deg2rad(angle));
			}
			animation.onComplete = AdvanceAnimation;
			Starling.juggler.add(animation);
		}
		
		//When tween is finished continue
		private function AdvanceAnimation():void {
			
			animationState++;
			
			if (state == WALK) Walking();
			else if (state == ATTACK_GROUND) AttackingGround();
			else if (state == ATTACK_AIR) AttackingAir();
		}
		
		//Change animation state
		public function ChangeState(state:int, animState:int = 0):void {
			if (this.state == state) return;
			
			this.state = state;
			animationState = animState;
			
			if (state == NONE) trace("None");
			else if (state == WALK) Walking();
			else if (state == ATTACK_GROUND) AttackingGround();
			else if (state == ATTACK_AIR) AttackingAir();
		}
		
		private function Walking():void {
			
			//Reset
			if (animationState >= 3) animationState = 0;
			
			//Sequenced Walking
			if (animationState == 0) {
				body.currentFrame = 0;
				AnimateTo(40, -30, -40, (1 / game.monster.speed) * 2.5, Transitions.EASE_OUT);
			} else if (animationState == 1) {
				body.currentFrame = 1;
				AnimateTo(70, 40, 0, (1 / game.monster.speed) * 1, Transitions.EASE_IN);
			} else if (animationState == 2) {
				body.currentFrame = 2;
				AnimateTo( -60, 40, 0, (1 / game.monster.speed) * 4, Transitions.LINEAR);
				GameEngine.instance.audioManager.AddSound(isRight ? Sounds.Step_1 : Sounds.Step_2).play(Sounds.EFFECT);
			}
		}
		
		public function Attack(px:int, py:int, isGround:Boolean):Boolean {
			if (state != WALK) return false;
			
			aimTarget = new Point(px, py);
			x = originPos.x;
			y = originPos.y;
			ChangeState(isGround ? ATTACK_GROUND : ATTACK_AIR);
			
			return true;
		}
		
		private function AttackingGround():void {
			
			//Stop Attack
			if (animationState == 3) {
				ChangeState(WALK);
				if(game.monster.GetPaw(!isRight).state == WALK) game.monster.ChangeBodyState(Monster.NORMAL);
				return;
			}
			
			//Find real aim target
			var newAim:Point = new Point((aimTarget.x - x) - parent.x, (aimTarget.y - y) - parent.y);
			
			//Sequenced Ground Attack
			if (animationState == 0) {
				body.currentFrame = 0;
				AnimateTo(50, -150, -60, 0.15, Transitions.EASE_OUT);
				game.monster.ChangeBodyState(isRight ? Monster.RIGHT_GROUND : Monster.LEFT_GROUND);
			} if (animationState == 1) {
				body.currentFrame = 3;
				AnimateTo(newAim.x, 50, 0, 0.1, Transitions.EASE_IN);
				
			} else if (animationState == 2) {
				body.currentFrame = 4;
				AnimateTo(0, 0, 0, 0.2, Transitions.LINEAR, false);
				
				//Hit Ground!
				game.backgroundManager.AddShake();
				for (var j:int = 0; j < 2; j++) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), aimTarget.x+50, 450);
				game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke_2"), aimTarget.x+150, 420);
				
				game.entityManager.CheckCollision(GetStartLine(-50), GetEndLine(aimTarget.x, 330), true);
				game.entityManager.CheckCollision(GetStartLine( -50), GetEndLine(aimTarget.x, 430), true);
				
				GameEngine.instance.audioManager.AddSound(Sounds.Smash).play(Sounds.EFFECT);
			}
		}
		
		
		private function AttackingAir():void {
			
			//Stop Attack
			if (animationState == 3) {
				ChangeState(WALK);
				if(game.monster.GetPaw(!isRight).state == WALK) game.monster.ChangeBodyState(Monster.NORMAL);
				return;
			}
			
			//Find real aim target
			var newAim:Point = new Point((aimTarget.x - x) - parent.x, (aimTarget.y - y) - parent.y);
			var angleAim:Number = GetAngle(aimTarget) -180;
			
			//Sequenced Air Attack
			if (animationState == 0) {
				body.currentFrame = 5;
				AnimateTo(newAim.x, newAim.y, angleAim, 0.15, Transitions.EASE_IN_OUT_BACK);
			} else if (animationState == 1) {
				body.currentFrame = 6;
				AnimateTo(0, 0, 0, 0.15, Transitions.LINEAR, false);
				
				//Hit Air!
				game.monster.ChangeBodyState(isRight ? Monster.RIGHT_AIR : Monster.LEFT_AIR);
				
				game.entityManager.CheckCollision(GetStartLine( -160), GetEndLine(aimTarget.x, aimTarget.y), false);
				
			} else if (animationState == 2) {
				body.currentFrame = 7;
				AnimateTo(0, 0, 0, 0.1, Transitions.LINEAR, false);
			}
		}
		
		private function GetAngle(p:Point):Number {
			var dx:Number = this.x - (p.x - game.monster.x);
			var dy:Number = this.y - (p.y - game.monster.y);
			return Math.atan2(dy, dx) / (Math.PI / 180);
		}
		
		private function GetStartLine(py:Number):Point {
			var p:Point = new Point();
			p.x = game.monster.x + 100;
			p.y = game.monster.y + py;
			return p;
		}
		
		private function GetEndLine(aimX:Number, aimY:Number):Point {
			var p:Point = new Point();
			p.x = aimX;
			p.y = aimY;
			return p;
		}
	}

}