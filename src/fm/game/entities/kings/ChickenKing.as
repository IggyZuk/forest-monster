package fm.game.entities.kings {
	import flash.geom.Point;
	import fm.engine.GameEngine;
	import fm.game.particles.Debris;
	import fm.utils.Line;
	import starling.display.Sprite;
	import fm.game.Art;
	import fm.states.GameState;
	import fm.game.entities.enemies.StateEnemy;
	
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ChickenKing extends StateEnemy {
		
		private var health:int = 3;
		private var hurtTimer:int;
		
		private var attackTimer:int;
		private var addWaveTimer:int;
		
		private var attackPos:Point;
		private var positions:Vector.<Vector.<int>>;
		
		private const FLY:int = 0;
		private const ATTACK:int = 1;
		
		private var flyMovie:MovieClip;
		private var attackMovie:MovieClip;
		
		private var chickenList:Vector.<Chicken> = new Vector.<Chicken>;
		private var lineList:Vector.<Line> = new Vector.<Line>;
		
		public function ChickenKing(game:GameState) {
			super(game, 1);
			
			attackPos = new Point(300,300);
			//positionsX = new Vector.<int>(400,);
			
			limitless = true;
			
			SetUnitType(AIR_UNIT);
			
			ConstructVisuals();
			ChangeState(FLY);
			
			SetGroundPosition(0, -75);
			SetCenter(25, 50);
			y -= Math.random() * 75 + 100;
			
			SetRadius(120);
			
			//Add chickens!!!
			for (var i:int = 0; i < 8; i++) {
				AddChicken(
					(Math.random() - Math.random()) * 250,
					-Math.random() * 100 - 50
				);
			}
			ConnectWithLines();
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			
			for each(var c:Chicken in chickenList) {
				c.Cleanup();
				c.removeFromParent(true);
			}
			chickenList.length = 0;
			
			for each(var l:Line in lineList) l.removeFromParent(true);
			lineList.length = 0;
		}
		
		override protected function Move(passedTime:Number):void {
			
			//Hurt timer
			if (hurtTimer >= 0) {
				
				hurtTimer--;
				if (hurtTimer <= 60) body.filter = null;
			}
			
			lifeTimer ++;
			
			velocity.y += Math.sin(lifeTimer * 0.4)*2;
			//body.y += velocity.y;
			
			if (x < 350) velocity.x += 0.075 * passedTime;
			else  velocity.x -= 0.075 * passedTime;
			
			x += velocity.x;
			body.y += velocity.y;
			
			//x += velocity.x + (initSpeed - game.monster.GetMoveSpeed()) * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
			
			for each(var chicken:Chicken in chickenList) {
				chicken.Update(passedTime);
			}
			RenderConnections();
		}
		
		override public function Remove():void { Hurt(); }
		private function Hurt():void {
			if (hurtTimer == 0) return;
			
			health--;
			hurtTimer = 100;
			
			velocity.x += 40;
			AddWave(1);
			
			//Color upper part white
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.invert();
			body.filter = filter;
			
			//Kill king
			if (health <= 0) {
				
				for each(var c:Chicken in chickenList)  c.Kill();
				
				game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("king_chicken_attack_05"), x, y);
				super.Remove();
			}
		}
		
		private function AddWave(type:int):void {
			ChangeState(ATTACK);
			movieState.addEventListener(Event.COMPLETE, function():void {
				ChangeState(FLY);
				AddWave(1);
			});
			for (var i:int = 0; i < Math.random()*3+2; i++) {
				var chicken:Chicken = Chicken(game.entityManager.AddEntity(Chicken));
				chicken.SetPosition(GameEngine.WIDTH + chicken.width + (i * 25), (i * 25) + 100);
			}
		}
		
		private function ConnectWithLines():void {
			for (var i:int = 0; i < chickenList.length; i++) {
				var l:Line = new Line();
				l.color = 0x331100;
				l.thickness = 4;
				game.backLayer.addChild(l);
				lineList.push(l);
			}
		}
		
		private function RenderConnections():void {
			for (var i:int = 0; i < chickenList.length; i++) {
				var chicken:Chicken = chickenList[i];
				lineList[i].moveTo(chicken.GetCenter().x + chicken.x, chicken.GetCenter().y + chicken.y);
				lineList[i].lineTo(GetCenter().x + x, GetCenter().y + y);
			}
		}
		
		override protected function ConstructVisuals():void {
			var fly_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("king_chicken_fly");
			flyMovie = new MovieClip(fly_frames, 25);
			
			var attack_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("king_chicken_attack");
			attackMovie = new MovieClip(attack_frames, 25);
			
			AddState(FLY, flyMovie);
			AddState(ATTACK, attackMovie);
			
		}
		
		private function AddChicken(px:int, py:int):void {
			var chicken:Chicken = Chicken(game.entityManager.AddEntity(Chicken));
			chicken.SetKingBehavior(this, px, py);
			chickenList.push(chicken);
		}
		
		override public function CanAddCoin():Boolean { return false; }
		
	}

}