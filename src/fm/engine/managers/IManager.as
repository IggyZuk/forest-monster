package fm.engine.managers {
	import fm.states.State;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public interface IManager {
		
		function IManager(state:State);
		
		function Cleanup():void;
		function Update(passedTime:Number):void;
		
	}

}