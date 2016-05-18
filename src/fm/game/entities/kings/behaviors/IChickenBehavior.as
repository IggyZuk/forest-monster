package fm.game.entities.kings.behaviors {
	/**
	 * Strategy pattern, used to decouple ChickenKing behaviour from normal chicken that shoots eggs.
	 * @author Ignatus Zuk
	 */
	public interface IChickenBehavior {
		
		function Move(passedTime:Number):void;
		function Remove():void;
		
	}

}