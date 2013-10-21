// Authored by Richard Nesnass, Future Interactions, Scotland 2011
//
package components
{

	import collections.ArrayList;
	
	import com.greensock.TweenLite;
	
	import components.*;
	import components.fileTile.TileUnit;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/*
	** Base object used to lay out all other screen objects
	*/
	public class Table extends Sprite
	{
		private var canvas:Canvas;
		private var _canvasBackground:Sprite;
		private var _hotspotWidget:Sprite;
		private var _hotspotList:ArrayList = new ArrayList();
		
		private var drawer1:Drawer;
		private var drawer2:Drawer;
		private var drawer3:Drawer;
		private var drawer4:Drawer;
		
		private var canvasMenu1:NewCanvasMenu;
		private var canvasMenu2:NewCanvasMenu;
		
		private var gControl1:GlobalControl;
		private var gControl2:GlobalControl;
		private var _globalMenu:GlobalMenu;
		private var pb:ProgressBar;
		
		private var _tableModal:Sprite;
		
		private var _currentGroup:String = "Sted";
		private var _currentCanvas:int = 1;
		
		private var tableTemplate:Sprite;
		
		private var _width:int;
		private var _height:int;
		
		private var screensaverRunning:Boolean = false;
		private var presenting:Boolean = false;
		
		private var _presentationList:ArrayList = new ArrayList();
		private var _presentationHotspotList:ArrayList = new ArrayList();
		
		private var previousContentsY:int;
		private var previousContentsX:int;
		
		
		private var presenterWidget:Sprite;
		private var draggingOverlay:Sprite;
		private var currentCanvasPresented:int;
		private var oldPresenterx:int =0;
		
		private var firstRun:Boolean = true;
		
		public function Table(twidth:int, theight:int)
		{
			width = _width = twidth;
			height = _height = theight;
			super();
			
			_canvasBackground = new Sprite();
			_canvasBackground.graphics.beginFill(MyConstants.CANVAS_BACKGROUND,1);
			_canvasBackground.graphics.drawRect(0,0,_width,_height);
			var canvasBackgroundLoader:Loader = new Loader();
			canvasBackgroundLoader.load(new URLRequest("/assets/carbondark.png"));
			_canvasBackground.addChild(canvasBackgroundLoader);
			addChild(_canvasBackground);
			
			addEventListener(HotspotEvent.HOTSPOT_ADDED, setupHotspot);
		}
		public function addDrawers():void {
			drawer1 = new Drawer(this, MyConstants.LEFT);
			drawer2 = new Drawer(this, MyConstants.RIGHT);
			drawer1.currentList = Utilities.loadArchive();
			drawer2.currentList = Utilities.loadArchive();
			addChild(drawer1);
			addChild(drawer2);
		}
		
		public function addCanvas():void {
			
			// For location calcualtions, Canvas should remain same size as Table
			canvas = new Canvas(_width,_height);
			canvas.width = this.width;
			canvas.height = this.height;
			addChild(canvas);
			canvas.canvasLock(true);
			
			_hotspotWidget = new Sprite();
			_hotspotWidget.height = canvas.height;
			_hotspotWidget.width = canvas.width;
			addChild(_hotspotWidget);
			
			canvas.hotspotWidget = _hotspotWidget;
			canvas.hotspotList = _hotspotList;
			

		}
		public function addOverlays():void {
			presenterWidget = new Sprite();
			draggingOverlay = new Sprite();
			presenterWidget.visible = false;
			draggingOverlay.visible = true;
			addChild(presenterWidget);
			addChild(draggingOverlay);
		}
		
		public function addGlobals():void {
			// tableModal prevents operations over the table when the global meny is open
			_tableModal = new Widget();
			_tableModal.allowRotation = false;
			_tableModal.allowScale = false;
			_tableModal.allowTranslation = false;
			_tableModal.visible = false;
			_tableModal.width = this.width;
			_tableModal.height = this.height;
			addChild(_tableModal);
			
			gControl1 = new GlobalControl(this, MyConstants.TOP);
			gControl2 = new GlobalControl(this, MyConstants.BOTTOM);
			addChild(gControl1);
			addChild(gControl2);
			
			_globalMenu = new GlobalMenu(this);
			_globalMenu.visible = false;
			_globalMenu.alpha = 0;
			_globalMenu.addEventListener(GlobalEvent.GLOBAL_SHOW, manageGlobalEvents);
			_globalMenu.addEventListener(GlobalEvent.GLOBAL_HIDE, manageGlobalEvents);
			addChild(_globalMenu);
			
			canvasMenu1 = new NewCanvasMenu(MyConstants.CANVAS_MENU_RADIUS, this);
			canvasMenu2 = new NewCanvasMenu(MyConstants.CANVAS_MENU_RADIUS, this);
			canvasMenu1.setScreenSide(MyConstants.TOP);
			canvasMenu2.setScreenSide(MyConstants.BOTTOM);
			
			//		addChild(canvasMenu1);
			//		addChild(canvasMenu2);
			
			
			// Actionscript can't multithread by default, so getting a progress bar to work this way is difficult..
			pb = new ProgressBar();
			pb.x = _width/2 - pb.width/2;
			pb.y = height/2 - pb.height/2;
			pb.visible = false;
		//	addChild(pb);
		}

		
		public function set tableWidth(width:int):void {
			this._width = width;
			this.width = width;
		}
		public function set tableHeight(height:int):void {
			this._height = height;
			this.height = height;
		}
		
		private function setGraphics(event:Event):void {
			;
		}
		public function setTemplate(w:int, h:int, name:String):void {
			if(tableTemplate == null) {
				tableTemplate = new Sprite();
				addChild(tableTemplate);
			}
			tableTemplate.name = name;
			tableTemplate.graphics.clear();		
			tableTemplate.graphics.lineStyle(1,MyConstants.TOOLBOX_BACKGROUND_LINE, 0.5);
			tableTemplate.graphics.drawRoundRect(0,0,w,h,MyConstants.ROUND_CORNER_SIZE,MyConstants.ROUND_CORNER_SIZE);
			
			tableTemplate.width = w;
			tableTemplate.height = h;
			
			tableTemplate.x = this._width/2-w/2;
			tableTemplate.y = this._height/2-h/2;

		}
		public function get template():Sprite {
			return tableTemplate;
		}
//-----------------  Get Set --------------------
		public function get canvasObject():Canvas {
			return this.canvas;
		}
		public function get canvasBackground():Sprite {
			return this._canvasBackground;
		}
		public function get hotspotObject():Sprite {
			return this._hotspotWidget;
		}
		public function get globalMenu():GlobalMenu {
			return this._globalMenu;
		}
		public function get measuredWidth():int {
			return this._width;
		}
		public function get measuredHeight():int {
			return this._height;
		}
		public function get currentGroup():String {
			return this._currentGroup;
		}
		public function get currentCanvas():int {
			return this._currentCanvas;
		}
		public function get hotspotList():ArrayList {
			return _hotspotList;
		}
		public function set hotspotList(hsl:ArrayList):void {
			_hotspotList = hsl;
		}
		public function get dragOverlay():Sprite {
			return draggingOverlay;
		}
		public function set dragOverlay(w:Sprite):void {
			draggingOverlay = w;
		}
//-----------------  Event Listeners -------------
		
		public function manageGlobalEvents(event:GlobalEvent):void {
			event.stopImmediatePropagation();
			switch(event.eventOperation) {
				case EventOps.showGlobalMenu:
					if(event.type == GlobalEvent.GLOBAL_SHOW)
						showGlobalMenu(event.eventOrientation);
					else
						hideGlobalMenu();
					break;
				case EventOps.addCameraImagesToEnvironment:
					addCameraImages("Miljø");
					break;
				case EventOps.addCameraImagesToInspiration:
					addCameraImages("Inspirasjon");
					break;
				case EventOps.addCameraImagesToModels:
					addCameraImages("Modeller");
					break;
				case EventOps.addCameraImagesToPlace:
					addCameraImages("Sted");
					break;
				case EventOps.addCameraImagesToUse:
					addCameraImages("Bruk");
					break;
				case EventOps.imageDroppedOnCanvas:
					if(event.type == GlobalEvent.GLOBAL_SKETCH_DROP)
						dropSketchOnCanvas(event);
					else
						dropImageOnCanvas(event);
					break;
				case EventOps.imageMissedCanvas:
					drawer1.removeMovingImages();
					drawer2.removeMovingImages();
					break;
				case EventOps.canvasSave:
					saveCanvas();
					break;
				case EventOps.canvasPrint:
					printCanvas();
					break;
				case EventOps.canvasNew:
				//	newCanvas();
					break;
				case EventOps.addGroup:
					canvas.unloadImages();
					startupTable();
					break;
			}
		}
		public function tableModalLock(set:Boolean):void {
			if(set) {
				canvas.enabled = false;
				drawer1.enabled = false;
				drawer2.enabled = false;
				_tableModal.graphics.beginFill(0x000000,0.5);
				_tableModal.graphics.drawRect(0,0,width, height);
				_tableModal.graphics.endFill();
				_tableModal.visible = true;
			}
			else {
				canvas.enabled = true;
				drawer1.enabled = true;
				drawer2.enabled = true;
				_tableModal.graphics.clear();
				_tableModal.visible = false;
			}
		}
		
		public function showGlobalMenu(orientation:int):void {
			tableModalLock(true);
			drawer1.closeDrawer();
			drawer2.closeDrawer();
			_globalMenu.currentMode = "main";
			_globalMenu.setupWindow();
			gControl1.setControl();
			gControl2.setControl();
			switch(orientation) {
				case 180:
					_globalMenu.changeRotation(180);
					break;
				case 0:
					_globalMenu.changeRotation(0);
					break;
			}
			_globalMenu.visible = true;
			TweenLite.to(_globalMenu,MyConstants.ANIMATION_TOOLBOX_DELAY,{alpha:1});
			
			if(screensaverRunning) {
				screensaverRunning = false;
				drawer1.visible = true;
				drawer2.visible = true;
				draggingOverlay.visible = true;
				Utilities.loadCanvasDataFromDateGroupCanvas(this, _currentGroup, _currentCanvas);
			}
			
			else if(presenting) {
				presenterWidget.visible = false;
				
// ******** Needs to be set up for PAN or Drag touch events
		//		draggingOverlay.removeEventListener(MultiTouchEvent.DOWN, contentsDown);
		//		draggingOverlay.removeEventListener(MultiTouchEvent.MOVE, contentsMove);
		//		draggingOverlay.removeEventListener(MultiTouchEvent.UP, contentsUp);
				draggingOverlay.graphics.clear();
				
				for each (var cv:Canvas in _presentationList) {
					presenterWidget.removeChild(cv);
				}
				for each (var hsw:TouchSprite in _presentationHotspotList) {
					presenterWidget.removeChild(hsw);
				}
				_presentationList.clear();
				_presentationHotspotList.clear();
				presenting = false;
				canvas.visible = true;
				_hotspotWidget.visible = true;
				drawer1.visible = true;
				drawer2.visible = true;
			}
			else {
				canvas.reorderCanvasList();
				if(firstRun)
					firstRun = false;
				else
					Utilities.saveCanvasData(this, _currentGroup, currentCanvas);
			}
		}
		public function setupHotspot(event:HotspotEvent):void {
			var hitObject:Boolean = false;
			for each (var oe:ObjectEditor in canvas.canvasImages) {
				if(oe.containsCoords(event.hotspotInstance.destinationLocationOnStage.getX(),event.hotspotInstance.destinationLocationOnStage.getY()) && oe != event.hotspotInstance.sourceObjectEditor) {
					hitObject = true;
					oe.addIncomingHotspotFromEvent(event.hotspotInstance);
				}
			}
			if(!hitObject) {
				var oe2:ObjectEditor = event.hotspotInstance.sourceObjectEditor;
				oe2.removeParticularHotspot(event.hotspotInstance);
			}
		}
		
		public function hideGlobalMenu():void {
			TweenLite.to(globalMenu,MyConstants.ANIMATION_TOOLBOX_DELAY,{alpha:0, onComplete: function():void { _globalMenu.visible = false; }});
			gControl1.resetControl();
			gControl2.resetControl();
			tableModalLock(false);
		}
		public function addCameraImages(drawer:String):void {
			Utilities.copyUSBToDropbox(_globalMenu.filesToCopy, drawer, this);
		}
		public function printCanvas():void {
			_canvasBackground.visible = false;
			Utilities.printCanvas(this);
			_canvasBackground.visible = true;
		}
		public function reloadDrawers(group:String, drawer:String, rearrange:Boolean=false):void {
			var funcName:String = "show"+drawer+"Drawer";
			funcName = funcName.replace("ø","o");
			drawer1[funcName](null);
			drawer2[funcName](null);
			if(rearrange) {
				drawer1.contents.contentsGrid.completeValidation();
				drawer2.contents.contentsGrid.completeValidation();
			}
		}
		public function dropImageOnCanvas(event:GlobalEvent):void {
			canvas.addImage(event.eventFile, event.eventOrientation, event.eventStageX, event.eventStageY);
			drawer1.removeMovingImages();
			drawer2.removeMovingImages();
		}
		public function dropSketchOnCanvas(event:GlobalEvent):void {
			canvas.addSketchFromFile(event.eventFile, event.eventOrientation, event.eventStageX, event.eventStageY);
			drawer1.removeMovingImages();
			drawer2.removeMovingImages();
		}
		public function saveCanvas():void {
			Utilities.screenCapture(this, _currentGroup);
		}

		public function showProgressBar():void {
			pb.autoRun();
			pb.visible = true;
		}
		public function hideProgressBar():void {
			pb.stop();
			pb.visible = false;
		}
		public function get progress():ProgressBar {
			return pb;
		}
		public function changeCanvas(objectlist:ArrayList, canvasNumber:int, screensaver:Boolean=false):void {
			canvas.changeCanvas(objectlist, screensaver);

			if(screensaver) {
				screensaverRunning = true;
				drawer1.visible = false;
				drawer2.visible = false;
				draggingOverlay.visible = false;
				hideGlobalMenu();
			}
			else if(_globalMenu.currentMode == "browsecanvas") {
				_currentCanvas = canvasNumber;
				hideGlobalMenu();
			}
			else {
				_currentCanvas = canvasNumber;
				_globalMenu.currentMode = "main";
				_globalMenu.setupWindow();
			}
			
		}
		// This function must be run after the canvas is loaded, as it relies on the index values of the canvas objects to match hotspots
		public function changeHotspotList(hsList:ArrayList):void {
			for each(var hs:Hotspot in _hotspotList) {
				if(_hotspotWidget.contains(hs))
					_hotspotWidget.removeChild(hs);
			}
			_hotspotList = hsList;
			canvas.hotspotList = hsList;
			for each(var hs2:Hotspot in hsList) {
				ObjectEditor(canvas.canvasImages.at(hs2.destinationObjectIndex)).addIncomingHotspot(hs2);
				ObjectEditor(canvas.canvasImages.at(hs2.sourceObjectIndex)).addOutgoingHotspot(hs2);
				_hotspotWidget.addChild(hs2);
			}
		}
		public function changeGroup(groupString:String):void {
			_currentGroup = groupString;
			drawer1.showArkivDrawer(null);
			drawer2.showArkivDrawer(null);
		}
		public function startupTable():void {
	/*		var lastGroup:int = Utilities.getTodaysLastGroup();
			
			if(lastGroup > 0)
				_currentGroup = lastGroup+1;
			else
				_currentGroup = 1;
	*/
			_currentGroup = "Sted"
			var file:File= new File(MyConstants.DROPBOX_SCHOOL_DIR + Utilities.schoolName + File.separator + "Work" + File.separator + _currentGroup + File.separator+"Ark_"+_currentCanvas+File.separator+"canvas.jpg");
			Utilities.loadCanvasDataFromThumb(this, file);
			setupCanvasesForGroup();
		}
		public function setupCanvasesForGroup():void {
	/*		var date:Date = new Date();
			var lastGroup:int = Utilities.getTodaysLastGroup();
			var lastCanvas:int = Utilities.getTodaysLastCanvas(lastGroup);
			
			Utilities.createGroupCanvases(this, _currentGroup);
	*/
			showGlobalMenu(0);
			gControl1.setControl();
			gControl2.setControl();
		}
		
		public function addPresentation(objectList:ArrayList, canvasNumber:int, hsList:ArrayList):void {
			var newCanvas:Canvas = new Canvas(_width,_height);
		//	newCanvas.width = this.width;
		//	newCanvas.height = this.height;
			newCanvas.canvasLock(true);
			newCanvas.changeCanvas(objectList,false);
			
			var newHotspotWidget:Sprite = new Sprite();
			newHotspotWidget.height = _height;
			newHotspotWidget.width = _width;
			
			newCanvas.hotspotList = hsList;
			newCanvas.hotspotWidget = newHotspotWidget;
			
			for each(var hs:Hotspot in hsList) {
				ObjectEditor(newCanvas.canvasImages.at(hs.destinationObjectIndex)).addIncomingHotspot(hs);
				ObjectEditor(newCanvas.canvasImages.at(hs.sourceObjectIndex)).addOutgoingHotspot(hs);
				newHotspotWidget.addChild(hs);
			}
			
			_presentationList.add(newCanvas);
			_presentationHotspotList.add(newHotspotWidget);
		}
		
		public function present():void {
			presenting = true;
			// Load canvas list for the current group
			var showList:ArrayList = Utilities.loadGroupCanvasDataFileList(_currentGroup);
			
			// Load object list for each canvas in presentation mode
			for each(var tile:TileUnit in showList) {
				Utilities.loadCanvasDataFromThumb(this,tile.file,false,true);
			}
			presenterWidget.x = 0;
	//		presenterWidget.height = _presentationList[0].height;
	//		presenterWidget.width = _presentationList[0].width*_presentationList.length;
			
			// Place presentations onto presenter widget
			var xCoord:int = 0;
			for each (var cv:Canvas in _presentationList) {
				cv.x = xCoord;
				presenterWidget.addChild(cv);
				xCoord+=1920;
			}
			xCoord = 0;
			for each (var hsw:TouchSprite in _presentationHotspotList) {
				hsw.x = xCoord;
				presenterWidget.addChild(hsw);
				xCoord+=1920;
			}
			presenterWidget.width = xCoord;
			
			draggingOverlay.graphics.beginFill(0x000000,0.01);
			draggingOverlay.graphics.drawRect(0,0,_width,_height);
			
// *************   Change to PAN or DRAG touch events
			if(_presentationList.length > 1) {
	//			draggingOverlay.addEventListener(MultiTouchEvent.DOWN, contentsDown);
	//			draggingOverlay.addEventListener(MultiTouchEvent.MOVE, contentsMove);
	//			draggingOverlay.addEventListener(MultiTouchEvent.UP, contentsUp);
			}
			
			canvas.visible = false;
			_hotspotWidget.visible = false;
			drawer1.visible = false;
			drawer2.visible = false;
			
			presenterWidget.visible = true;
			
			currentCanvasPresented = 0;
			hideGlobalMenu();
		}
/*		private function contentsDown(event:MultiTouchEvent):void {
			event.stopImmediatePropagation();
			draggingOverlay.removeEventListener(MultiTouchEvent.DOWN, contentsDown);
			previousContentsX = event.stageX;
			previousContentsY = event.stageY;
			
		}
		// Deals with contents dragging, accounting for rotation of the drawer
		private function contentsMove(event:MultiTouchEvent):void {
			event.stopImmediatePropagation();
			var vgy:int = (event.stageY - previousContentsY);
			var vgx:int = (event.stageX - previousContentsX);
			presenterWidget.x += vgx;
			previousContentsY = event.stageY;
			previousContentsX = event.stageX;
		}
		private function reEnablePresentationDown():void {
			oldPresenterx = presenterWidget.x;
			draggingOverlay.addEventListener(MultiTouchEvent.DOWN, contentsDown);
		}
		private function contentsUp(event:MultiTouchEvent):void {
			event.stopImmediatePropagation();
			if(oldPresenterx  <= presenterWidget.x) {
				if(currentCanvasPresented > 0) {
					TweenLite.to(presenterWidget,1, {x:-(currentCanvasPresented-1)*presenterWidget.width/4, onComplete:reEnablePresentationDown});
					currentCanvasPresented--;
				}
				else
					TweenLite.to(presenterWidget,1, {x:oldPresenterx, onComplete:reEnablePresentationDown});
			}
			else if(oldPresenterx > presenterWidget.x) {
				if(currentCanvasPresented < _presentationList.length-1) {
					TweenLite.to(presenterWidget,1, {x:-(currentCanvasPresented+1)*presenterWidget.width/4, onComplete:reEnablePresentationDown});
					currentCanvasPresented++;
				}
				else
					TweenLite.to(presenterWidget,1, {x:oldPresenterx, onComplete:reEnablePresentationDown});
			}
		}
*/
	}
}