package fm.states {
	import starling.extensions.ClippedSprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class State extends ClippedSprite {
		
		public function Init():void {}
		public function Cleanup():void {}
		
		public function Pause():void {}
		public function Resume():void {}
		
		public function Update(passedTime:Number):void {}
		public function Draw():void { }
	}

}