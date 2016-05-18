package fm.engine.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import fm.engine.managers.AudioManager;
	
	/**
	 * 'Class modified from Flash Punk source'
	 * Sound effect object used to play embedded sounds.
	 */
	
	public class Sfx {
		
		private var manager:AudioManager;
		private var complete:Function;
		
		private var _vol:Number = 1;
		private var _pan:Number = 0;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform = new SoundTransform;
		
		private var _position:Number = 0;
		private var _looping:Boolean;
		
		public function Sfx(source:*, manager:AudioManager, complete:Function = null) {
			
			if (source is Class) {
				if (!_sound) _sound = new source;
			}
			else if (source is Sound) _sound = source;
			else throw new Error("Sfx source needs to be of type Class or Sound");
			
			this.manager = manager;
			this.complete = complete;
		}
		
		public function play(vol:Number = 1, pan:Number = 0):void {
			if (_channel) stop();
			_pan = clamp(pan, -1, 1);
			_vol = vol < 0 ? 0 : vol;
			_transform.pan = _pan;
			_transform.volume = _vol;
			_channel = _sound.play(0, 0, _transform);
			if (_channel) _channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
			_looping = false;
			_position = 0;
		}
		
		public function loop(vol:Number = 1, pan:Number = 0):void {
			play(vol, pan);
			_looping = true;
		}
		
		public function stop():Boolean {
			if (!_channel) return false;
			_position = _channel.position;
			_channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
			_channel.stop();
			_channel = null;
			if(!_looping) manager.RemoveSound(this);
			return true;
		}
		
		public function resume():void {
			_channel = _sound.play(_position, 0, _transform);
			if (_channel) _channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
			_position = 0;
		}
		
		private function onComplete(e:Event = null):void {
			if (_looping) loop(_vol, _pan);
			else stop();
			_position = 0;
			if (complete != null) complete();
		}
		
		public function get volume():Number { return _vol; }
		public function set volume(value:Number):void {
			if (!_channel) return;
			if (value < 0) value = 0;
			_vol = value;
			_transform.volume = _vol;
			_channel.soundTransform = _transform;
		}
		
		public function get pan():Number { return _pan; }
		public function set pan(value:Number):void {
			if (!_channel) return;
			value = clamp(value, -1, 1);
			_pan = value;
			_transform.pan = _pan;
			_channel.soundTransform = _transform;
		}
		
		public function get sound():Sound { return _sound }
		
		private function clamp(value:Number, min:Number, max:Number):Number {
			if (max > min) {
				if (value < min) return min;
				else if (value > max) return max;
				else return value;
			} else {
				if (value < max) return max;
				else if (value > min) return min;
				else return value;
			}
		}
	}
}