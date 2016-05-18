package fm.events {
	import starling.events.Event;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class UpgradeEvent extends Event {
		
		public static const BOUGHT:String = "upgrade_bought";
		
		public var message:String = "";
		
		public function UpgradeEvent(type:String, bubbles:Boolean = false, data:Object = null) {
			super(type, bubbles, data);
		}
		
	}

}