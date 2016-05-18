package fm.engine.managers {
	import fm.game.particles.*;
	import fm.states.State;
	import fm.utils.Vec2;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ParticleManager implements IManager {
		
		private var _state:State;
		private var _clip:Sprite;
		
		private var _particleList:Vector.<Particle> = new Vector.<Particle>;
		
		public function ParticleManager(_state:State, _clip:Sprite) {
			this._state = _state;
			this._clip = _clip;
		}
		
		public function Cleanup():void {
			for each(var p:Particle in _particleList) {
				p.Cleanup();
				p.removeFromParent(true);
			}
			_particleList.length = 0;
		}
		
		public function Update(passedTime:Number):void {
			for (var i:int = 0; i < _particleList.length; i++) {
				var p:Particle = _particleList[i];
				if(p.isActive) p.Update(passedTime);
				else {
					p.Cleanup();
					p.removeFromParent(true);
					_particleList.splice(i, 1);
					i--;
				}
			}
		}
		
		public function AddParticle(ParticleClass:Class, texture:Texture, px:Number, py:Number):void {
			var particle:Particle = new ParticleClass(_state, texture);
			particle.x = px;
			particle.y = py;
			_clip.addChild(particle);
			_particleList.push(particle);
		}
		
	}

}