package fm.game {
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Art {
		
		/* Single Bitmaps */
		[Embed(source = "../../res/textures/menu.jpg")]													private static const MenuTitleBitmap:Class;
		
		[Embed(source = "../../res/textures/map.jpg")]														private static const MapBackgroundBitmap:Class;
		
		[Embed(source = "../../res/textures/map_ray.png")]													private static const MapRaysBitmap:Class;
		
		[Embed(source = "../../res/textures/shop.png")]													private static const ShopBackgroundBitmap:Class;
		
		[Embed(source = "../../res/textures/gym.jpg")]														private static const GymBackgroundBitmap:Class;
		
		/* Atlases Bitmap/XM */
		[Embed(source = "../../res/textures/BackgroundAtlas.xml", mimeType="application/octet-stream")]	private static const BackgroundXML:Class;
		[Embed(source = "../../res/textures/BackgroundAtlas.png")]											private static const BackgroundBitmap:Class;
		
		[Embed(source = "../../res/textures/MonsterAtlas.xml", mimeType="application/octet-stream")]		private static const MonsterXML:Class;
		[Embed(source = "../../res/textures/MonsterAtlas.png")]											private static const MonsterBitmap:Class;
		
		[Embed(source = "../../res/textures/EntityAtlas.xml", mimeType="application/octet-stream")]		private static const EntityXML:Class;
		[Embed(source = "../../res/textures/EntityAtlas.png")]												private static const EntityBitmap:Class;
		
		[Embed(source = "../../res/textures/ObstacleAtlas.xml", mimeType="application/octet-stream")]		private static const ObstacleXML:Class;
		[Embed(source = "../../res/textures/ObstacleAtlas.png")]											private static const ObstacleBitmap:Class;
		
		[Embed(source = "../../res/textures/GuiAtlas.xml", mimeType="application/octet-stream")]			private static const GuiXML:Class;
		[Embed(source = "../../res/textures/GuiAtlas.png")]												private static const GuiBitmap:Class;
		
		[Embed(source = "../../res/textures/GameOverAtlas.xml", mimeType="application/octet-stream")] 		private static const GameOverXML:Class;
		[Embed(source = "../../res/textures/GameOverAtlas.png")] 											private static const GameOverBitmap:Class;
		
		[Embed(source = "../../res/textures/CutsceneAtlas.xml", mimeType = "application/octet-stream")]	private static const CutsceneXml:Class;
		[Embed(source = "../../res/textures/CutsceneAtlas.png")]											private static const CutsceneBitmap:Class;
		
		/* Fonts */
		[Embed(source = "../../res/fonts/GoldenFont.fnt", mimeType="application/octet-stream")]			private static const GoldenFontXML:Class;
		[Embed(source = "../../res/fonts/GoldenFont.png")]													private static const GoldenFontBitmap:Class;
		
		[Embed(source = "../../res/fonts/SpeedFont.fnt", mimeType="application/octet-stream")] 			private static const SpeedFontXML:Class;
		[Embed(source = "../../res/fonts/SpeedFont.png")]													private static const SpeedFontBitmap:Class;
		
		[Embed(source = "../../res/fonts/DistanceFont.fnt", mimeType="application/octet-stream")]			private static const DistanceFontXML:Class;
		[Embed(source = "../../res/fonts/DistanceFont.png")]												private static const DistanceFontBitmap:Class;
		
		[Embed(source = "../../res/fonts/DescriptionFont.fnt", mimeType="application/octet-stream")]		private static const DescriptionFontXML:Class;
		[Embed(source = "../../res/fonts/DescriptionFont.png")]											private static const DescriptionFontBitmap:Class;
		
		/* Other Config XML files */
		public static var Config:XML;
		public static var GymXML:XML;
		public static var ShopXML:XML;
		
		//Textures
		public static var MenuTitleTexture:Texture = MakeTexture(MenuTitleBitmap);
		public static var MapBackground:Texture = MakeTexture(MapBackgroundBitmap);
		public static var MapRays:Texture = MakeTexture(MapRaysBitmap);
		public static var ShopBackground:Texture = MakeTexture(ShopBackgroundBitmap);
		public static var GymBackground:Texture = MakeTexture(GymBackgroundBitmap);
		public static var BackgroundAtlas:TextureAtlas = MakeTextureAtlas(BackgroundBitmap, BackgroundXML);
		public static var MonsterAtlas:TextureAtlas = MakeTextureAtlas(MonsterBitmap, MonsterXML);
		public static var EntityAtlas:TextureAtlas = MakeTextureAtlas(EntityBitmap, EntityXML);
		public static var ObstacleAtlas:TextureAtlas = MakeTextureAtlas(ObstacleBitmap, ObstacleXML);
		public static var GuiAtlas:TextureAtlas = MakeTextureAtlas(GuiBitmap, GuiXML);
		public static var GameOverAtlas:TextureAtlas = MakeTextureAtlas(GameOverBitmap, GameOverXML);
		public static var CutsceneAtlas:TextureAtlas = MakeTextureAtlas(CutsceneBitmap, CutsceneXml);
		
		//Fonts
		public static var GoldenFont:BitmapFont = MakeBitmapFont(GoldenFontBitmap, GoldenFontXML);
		public static var SpeedFont:BitmapFont = MakeBitmapFont(SpeedFontBitmap, SpeedFontXML);
		public static var DistanceFont:BitmapFont = MakeBitmapFont(DistanceFontBitmap, DistanceFontXML);
		public static var DescriptionFont:BitmapFont = MakeBitmapFont(DescriptionFontBitmap, DescriptionFontXML);
		
		private static function MakeTextureAtlas(_Texture:Class, _Xml:Class):TextureAtlas {
			var bitmap:Bitmap = new _Texture(); // creates the embedded bitmap (spritesheet file)
			var texture:Texture = Texture.fromBitmap(bitmap); // creates a texture out of it
			var xml:XML = XML(new _Xml()); // creates the XML file detailing the frames in the spritesheet
			return new TextureAtlas(texture, xml); // creates a texture atlas (binds the spritesheet and XML description)
		}
		
		private static function MakeTexture(_Texture:Class):Texture {
			var bitmap:Bitmap = new _Texture();
			return Texture.fromBitmap(bitmap);
		}
		
		private static function MakeBitmapFont(_Texture:Class, _Xml:Class):BitmapFont {
			var font:BitmapFont = new BitmapFont(MakeTexture(_Texture), XML(new _Xml()));
			TextField.registerBitmapFont(font);
			return font;
		}
	}

}