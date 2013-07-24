package  {
	import flash.utils.ByteArray;
	import flash.display.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*; 
	
	public class GlobalMethod {
    	public static function ArrayRemove(list:Array, element: String):Array {
    		for(var i:int = list.length - 1; i >= 0; i--) {		
				if(list[i].toString() == element)
					list.splice(i,1);
        	}
			return list;
    	}
		
		//trim all string in an Array
		public static function ArrayTrim(list:Array): void {
    		for(var i:int = list.length - 1; i >= 0; i--) {		
				list[i] = trim(list[i]);
        	}
    	}
		
		//Combine all string in an Array using SEPARATOR
		public static function StringArrayConcact(list:Array, sep: String): String {
			var returnStr: String = "";
    		for(var i:int = 0; i < list.length; i++) {
				returnStr = returnStr + list[i] + ( i >= list.length -1 ? "" : sep );
        	}
			
			return returnStr;
    	}
		
		//取掉字符串的前后空格
    	public static function trim(returnString: String): String
		{
        	for (; returnString.charCodeAt(0) == 0x20; returnString=returnString.substr(1)) {
        	}
        	for (; returnString.charCodeAt(returnString.length-1) == 0x20; returnString=returnString.substr(0, returnString.length-1)) {
        	}
        	return returnString;
		}
		
		public static function Clone(source:Object):* 
		{ 
    		var myBA:ByteArray = new ByteArray(); 
    		myBA.writeObject(source); 
    		myBA.position = 0; 
    		return(myBA.readObject()); 
		}
		
		// get file extension (lowercase)
		public static function GetFileExtention( fileName: String):String
		{
		    var extensionIndex:Number = fileName.lastIndexOf( '.' );
        	var extension:String = fileName.substr( extensionIndex + 1, fileName.length );
			return extension.toLowerCase();
		}
		
		public static function IsVideoFile(fileName:String): Boolean
		{
			var ext: String = GetFileExtention(fileName);
			
			if(ext == "mp4")
				return true;
			if(ext == "avi")
				return true;
			if(ext == "mpeg")
				return true;
			if(ext == "mpg")
				return true;
			if(ext == "flv")
				return true;
			return false;
		}
		
		public static function IsPictureFile(fileName:String):Boolean
		{
			var ext: String = GetFileExtention(fileName);
			
			if(ext == "jpg")
				return true;
			if(ext == "png")
				return true;
			if(ext == "jpeg")
				return true;
			if(ext == "bmp")
				return true;
			return false;
		}
		
		public static function LoadMovieClipImage( clip: MovieClip, imageURL:String, onLoaded: Function):Loader
		{
			var picLoader : Loader = new Loader();
			clip.addChild(picLoader);
    		picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded); // event listener which is fired when loading is complete
    		picLoader.load(new URLRequest(imageURL));
			return picLoader;
		}
	}
}	
