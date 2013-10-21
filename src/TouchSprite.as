package
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TapGesture;
	import org.gestouch.gestures.TransformGesture;

	public class TouchSprite extends Sprite
	{
		private var doubleTapGesture:TapGesture;
		private var twoFingerTapGesture:TapGesture;
		private var transformGesture:TransformGesture;
		
		private var _gesturesEnabled:Boolean = false;
		
		public function TouchSprite()
		{
			super();
			
			// Set up gesture support and enable
			doubleTapGesture = new TapGesture(this);
			doubleTapGesture.numTapsRequired = 2;
			twoFingerTapGesture = new TapGesture(this);
			twoFingerTapGesture.numTouchesRequired = 2;
			transformGesture = new TransformGesture(this);
		
			setGestures(true);
		}
		
		public function setGestures(enable:Boolean):void
		{
			if(enable && !_gesturesEnabled)
			{
				doubleTapGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_RECOGNIZED, onTapGesture);
				twoFingerTapGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_RECOGNIZED, onTapGesture);
				transformGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_BEGAN, onTransformGesture);
				transformGesture.addEventListener(org.gestouch.events.GestureEvent.GESTURE_CHANGED, onTransformGesture);
			}
			else if(!enable && _gesturesEnabled)
			{
				doubleTapGesture.removeEventListener(org.gestouch.events.GestureEvent.GESTURE_RECOGNIZED, onTapGesture);
				twoFingerTapGesture.removeEventListener(org.gestouch.events.GestureEvent.GESTURE_RECOGNIZED, onTapGesture);
				transformGesture.removeEventListener(org.gestouch.events.GestureEvent.GESTURE_BEGAN, onTransformGesture);
				transformGesture.removeEventListener(org.gestouch.events.GestureEvent.GESTURE_CHANGED, onTransformGesture);
			}
		}
		
		private function onTapGesture(event:org.gestouch.events.GestureEvent):void
		{
			var gesture:TapGesture = event.target as TapGesture;
			var scale:Number = this.scaleX;
			
			
			if (gesture == doubleTapGesture)
			{
				scale = this.scaleX * 1.2;
			}
			else if(gesture == twoFingerTapGesture)
			{
				scale = this.scaleX / 1.2;
			}
			
			TweenMax.to(this, 0.3, {
				scaleX: scale,
				scaleY: scale
			});
		}
		
		private function onTransformGesture(event:org.gestouch.events.GestureEvent):void
		{
			const gesture:TransformGesture = event.target as TransformGesture;
			var matrix:Matrix = this.transform.matrix;
			
			// Panning
			matrix.translate(gesture.offsetX, gesture.offsetY);
			this.transform.matrix = matrix;
			
			if (gesture.scale != 1 || gesture.rotation != 0)
			{
				// Scale and rotation.
				var transformPoint:Point = matrix.transformPoint(this.globalToLocal(gesture.location));
				matrix.translate(-transformPoint.x, -transformPoint.y);
				matrix.rotate(gesture.rotation);
				matrix.scale(gesture.scale, gesture.scale);
				matrix.translate(transformPoint.x, transformPoint.y);
				
				this.transform.matrix = matrix;
			}
		}
	}
}