package fm.engine.managers {
	import flash.media.SoundChannel;
	import fm.engine.sound.Sfx;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class AudioManager {
		
		private var _mute:Boolean = false;
		private var soundList:Vector.<Sfx> = new Vector.<Sfx>;
		
		private var _music:Sfx;
		
		public function AddSound(source:*, complete:Function = null):Sfx {
			if (_mute) return null;
			var s:Sfx = new Sfx(source, this, complete);
			soundList.push(s);
			return s;
		}
		
		public function RemoveSound(sound:Sfx):void {
			for (var i:int = 0; i < soundList.length; i++) {
				var s:Sfx = soundList[i];
				if (s == sound) {
					trace("Sound Removed -", s);
					soundList.splice(i, 1);
					s = null;
					return;
				}
			}
		}
		
		public function AddMusic(source:Class):Sfx {
			if (_mute) return null;
			if (_music) {
				_music.stop();
				_music = null;
			}
			_music = new Sfx(source, this);
			return _music;
		}
		
		public function RemoveAll():void {
			for each(var s:Sfx in soundList) {
				s.stop();
				s = null;
			}
			soundList.length = 0;
		}
		
		public function IsMusicPlaying(source:Class):Boolean {
			if (music) {
				if(music.sound is source) return true;
			}
			return false;
		}
		
		public function IsPlaying(sound:Sfx):Boolean {
			for each(var s:Sfx in soundList) {
				if (s == sound) return true;
			}
			return false;
		}
		
		public function GetSound(sound:Sfx):Sfx {
			for each(var s:Sfx in soundList) {
				if (s ==  sound) return s;
			}
			return null;
		}
		
		public function get music():Sfx { return _music; }
		
		public function set mute(m:Boolean):void {
			if (m) {
				RemoveAll();
				_music.stop();
				_music = null;
			}
			mute = m;
		}
		public function get mute():Boolean { return _mute; }
		
	}

}