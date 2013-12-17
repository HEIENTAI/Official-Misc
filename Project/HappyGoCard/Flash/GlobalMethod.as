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
		
		// imageURL : 這個參數要注意 case-sensetive 的問題
		public static function LoadMovieClipImage( clip: MovieClip, imageURL:String, onLoaded: Function):Loader
		{
			try
			{
				trace("LoadMovieClipImage : " + imageURL);
				if(imageURL == "") // avoid  Error #2044: 未处理的 IOErrorEvent:。 text=Error #2035 
				{
					trace( " GlobalMethod.LoadMovieClipImage : imageURL is empty ");
					return null;
				}
				var picLoader : Loader = new Loader();
				clip.addChild(picLoader);
    			picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded); // event listener which is fired when loading is complete
				picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LoadMovieClipImage_Error);
    			picLoader.load(new URLRequest(imageURL));
			
				trace(" GlobalMethod.LoadMovieClipImage : " + imageURL);
			} 
			catch (error:Error) 
			{ 
				trace( " LoadMovieClipImage : " + error.message);
			}	
			return picLoader;
		}
		
		function ioErrorHandler(e:IOErrorEvent):void 
		{
    		 
    		 
		}

		public static function LoadMovieClipImage_Error(evt:IOErrorEvent)
		{
			var pattern:RegExp = /(?<=URL:\s).+/g;
			
			var fileName = evt.text.match(pattern);
			trace( " LoadMovieClipImage 错误，档案读取失败 " + fileName); 
		}
		
		//避免 error #2025 , 先檢查是否為 parent 再進行移除 child displayobject
		//remove child 需要檢查 parent, 因為 remve swf 後, 還沒GC , child可能不會是 null, 
		public static function CheckAndRemoveChild(mc: DisplayObjectContainer, child: DisplayObject):Boolean
		{
			if(mc == null)
				return false;
			if(child == null)
				return false;
			if(child.parent != mc)
			{
				if(child.parent != null) //still try to remove this object
					child.parent.removeChild(child);
				return false;
			}
			mc.removeChild(child);
			return true;
		}
		
		public static function DebugMsg(msg:String)
		{
			var now = new Date();
			trace( now + " --  Debug: " +msg );
		}
	}
}	
