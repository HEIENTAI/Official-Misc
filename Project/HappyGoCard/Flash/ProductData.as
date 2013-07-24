package  {
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.events.*; 
	import flash.external.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class ProductData {
		public function ProductData() {
			// constructor code
		}

		//商品資料
		public var ID: int; //商品編號
		public var Name:String; //商品名稱
		public var PurchasePoint:int;//需求點數
		public var ImagePath: String;//圖片路徑
		public var PicLoader: Loader; //讀取器
		public var TopClip: MovieClip; // 產品最外層影片片段
		public var InnerClip: MovieClip; // 產品內層影片片段
		public var ImageClip: MovieClip; // 產品  放圖片用的 影片片段 , dynamic create
		public var IncPointClip: MovieClip; //送點文字框
		public var DecPointClip: MovieClip; //扣點文字框
		public var PointField: TextField; //點數輸入框
		public var Description: String; //商品細節 - 描述 (商品細節用, 預設為空)
		public var RemainSeconds: int; //商品細節 - 操作時間 (商品細節用, 預設為空)
	}
}
