package
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TapGesture;
	import org.gestouch.gestures.TransformGesture;
	
	/**
	 * Snokult3 - the next iteration of Snokult recoded to remove cornerstone dependencies 
	 * @author richardnesnass
	 * 
	 */	
	public class Snokult3 extends Sprite
	{
		private var _square:TouchSprite;
		

		public function Snokult3()
		{
			addEventListener(Event.ADDED_TO_STAGE, waitForStageReady);

			_square = new TouchSprite();
			_square.graphics.beginFill(0xFFFF00);
			_square.graphics.drawRect(0,0,200,200);
			_square.graphics.endFill();
			addChild(_square);
			
		}
		
		public function waitForStageReady(event:Event):void
		{
			stage.addEventListener(Event.ACTIVATE, enterFullScreen);
		}
		public function enterFullScreen(event:Event):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
	}
}