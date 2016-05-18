package fm.events {
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ResourceEvent extends Event {
		
		public static const LOADED:String = "resources_loaded";
		 
		public function ResourceEvent(type:String, bubbles:Boolean = false, data:Object = null) {
			super(type, bubbles, data);
		}
		
	}

}