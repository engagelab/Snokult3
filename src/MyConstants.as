package components
{
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	public class MyConstants
	{
		public static const DROPBOX_WORK_DIR:String = File.userDirectory.nativePath + File.separator + "Dropbox"+ File.separator + "Snøkult" + File.separator + "Work" + File.separator;
		public static const DROPBOX_MATERIALS_DIR:String = File.userDirectory.nativePath + File.separator + "Dropbox"+ File.separator + "Snøkult" + File.separator + "Materials" + File.separator;
		public static const DROPBOX_SCHOOL_DIR:String = File.userDirectory.nativePath + File.separator + "Dropbox"+ File.separator + "Snøkult" + File.separator + "School" + File.separator;

		public static const FLICKR_API_KEY:String = "5c5b8db96a0654a78a3627a5794b8b55";
		public static const FLICKR_SECRET:String = "51251f746a113420";
		
		public static const TOP:int = 180;
		public static const LEFT:int = 90;
		public static const BOTTOM:int = 0;
		public static const RIGHT:int = 270;
		
		public static const SOLID_COLOUR:uint = 0xFF00E0;
		public static const GLOW_COLOUR:uint = 0xFFFF00;
		public static const BACKGROUND_COLOUR:uint = 0x000000;
		public static const BORDER_COLOUR:uint = 0xAAAAAA;
		public static const HIGHLIGHT_COLOUR:uint = 0x32E800;
		
		public static const TOOLBAR_PADDING:int = 12;
		public static const ROUND_CORNER_SIZE:int = 30;
		public static const DEFAULT_PADDING:int = 0;
		
		public static const ICON_WIDTH:int = 40;
		public static const LARGE_ICON_WIDTH:int = 64;
		
		public static const DEFAULT_IMAGE_WIDTH:int = 250;
		public static const DEFAULT_IMAGE_HEIGHT:int = 250;
		
		public static const TOOLBOX_SIZE:int = 64;
		public static const CONTROLBOX_SIZE:int = 64;
		public static const TOOLBOX_BACKGROUND_COLOUR:int = 0x232323;
		public static const TOOLBOX_BACKGROUND_LINE:int = 0x555555;
		public static const COLOUR_PICKER_BACKGROUND:int = 0x333333;
		
		public static const CANVAS_BACKGROUND:uint = 0x222222;
		public static const CANVAS_MENU_RADIUS:int = 72;
		public static const CANVAS_MENU_LINE:int = 0x555555;
		
		public static const GLOBALCONTROL_WIDTH:int = 200;
		public static const GLOBALCONTROL_HEIGHT:int = 60;
		
		public static const GLOBALMENU_CAMERA_WIDTH:int = 1000;
		public static const GLOBALMENU_CAMERA_HEIGHT:int = 900;
		public static const GLOBALMENU_MAIN_WIDTH:int = 1000;
		public static const GLOBALMENU_MAIN_HEIGHT:int = 900;
		public static const GLOBALMENU_TITLE_HEIGHT:int = 180;
		
		public static const CANVASMENU_MAIN_WIDTH:int = 1000;
		public static const CANVASMENU_MAIN_HEIGHT:int = 900;
		
		public static const GROUPMENU_MAIN_WIDTH:int = 1000;
		public static const GROUPMENU_MAIN_HEIGHT:int = 900;
		
		public static const DRAWER_WIDTH:int = 550;
		public static const DRAWER_HEIGHT:int = 1080;
		public static const DRAWER_CONTROLS_HEIGHT:int = 100;
		public static const DRAWER_CONTROLS_PADDING:int = 10;	
		
		public static const DRAGGER_WIDTH:int = 60;
		public static const DRAGGER_HEIGHT:int = 160;
		
		public static const DEFAULT_TEXTOBJECT_HEIGHT:int = 64;
		public static const DEFAULT_TEXTOBJECT_WIDTH:int = 300;
		
		public static const TILE_SIZE:int = 140;
		public static const TILE_BACKGROUND:int = 0x444444;
		public static const TILES_PER_FRAME:uint = 15;
		public static const TILES_PER_PAGE:uint = 15;
		public static const MAX_FILES:uint = 200;
		public static const ICON_CANVAS_SIZE:int = 128;
		public static const ICON_TEXT_WIDTH:int = 180;
		public static const ICON_TEXT_HEIGHT:int = 40;
		public static const ICON_THUMB_WIDTH:int = 340;
		public static const ICON_THUMB_HEIGHT:int = 200;
		public static const TILE_H_PADDING:int = 20;
		public static const TILE_V_PADDING:int = 20;
		
		public static const COLOUR_PICKER_COLOURS:Array = [0xFF0000,0xEA00FF,0x2000FF,0x00E0FF,0x00FF00,0xFFFB00,0xFFAE00,0x000000,0xFFFFFF];
		
		public static const ANIMATION_TOOLBOX_DELAY:Number = 1;
		public static const ANIMATION_TOOLBOX_SHORT_DELAY:Number = 0.6;
		
		public static const HOTSPOT_SOURCE_RADIUS:int = 18;		
		public static const HOTSPOT_DESTINATION_RADIUS:int = 8;
		
		public function MyConstants()
		{
		/*	if(Capabilities.os.search("Windows") > -1) {
				DROPBOX_WORK_DIR:String = File.userDirectory.nativePath + "\\Dropbox\\Snøkult\\Work\\";
				DROPBOX_MATERIALS_DIR:String = File.userDirectory.nativePath + "\\Dropbox\\Snøkult\\Materials\\";
			}
			else if(Capabilities.os.search("Mac") > -1){
				DROPBOX_WORK_DIR:String = File.userDirectory.nativePath + "\\Dropbox\\Snøkult\\Work\\";
				DROPBOX_MATERIALS_DIR:String = File.userDirectory.nativePath + "\\Dropbox\\Snøkult\\Materials\\";
			}
		*/	
		}

	}
}