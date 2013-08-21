package  {

	//----------------------------------------------------------
	// 有追加實體名稱的片段
	// Layer: doll - IntroDoll
	// 領取卡片 - ButtonReceiveCard
	// 申請卡片 - ButtonRequestCard
	// 返回 	- ButtonReturn
	// Layer: menu 商品圖示 ICON - ButtonProduct_1
	// Layer: menu 商品圖示 ICON - ButtonProduct_2
	// Layer: menu 商品圖示 ICON - ButtonProduct_3
	// Layer: menu 商品圖示 ICON - ButtonProduct_4
	// Layer: menu 商品圖示 ICON - ButtonProduct_5
	// Layer: menu 商品圖示 ICON - ButtonProduct_6
	// 請在右方感應掃描 - MovieMsgSensor
	// 請點選下方產品 - MovieMsgChoose
	// 兌換成功 - MovieMsgExchangeDone
	// 請輸入你的手機號碼 - MovieMsgMobile
	// 出卡失敗 - MovieMsgCardFailed
	// 剩餘點數 - MovieMsgRemainPoint
	// 等待出卡(N個應該放在同一個MC元素...) - MovieMsgExportingCard
	// 等待出卡(N個應該放在同一個MC元素...) - MovieExportingCard_1 ---> 已將點陣圖轉 mc (不然無法控制喔..NG) 
	// 等待出卡(N個應該放在同一個MC元素...) - MovieExportingCard_2
	// 等待出卡(N個應該放在同一個MC元素...) - MovieExportingCard_Text ---> 已將text轉 mc (不然無法控制喔..NG)
	// Layer : mask - demo 示意圖 - MovieMaskDemo
	// Layer:Layer 2 - 黑色遮罩 - MovieCoverMask 
	//-----------------------------------------------------------
	
	// 用來跟 CSharp WPF 溝通的訊息介面 
	//
	
	import flash.events.*; 
	import flash.external.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.display.Bitmap;
    import flash.display.BitmapData;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
    import flash.media.Video;     
    import flash.net.NetConnection;     
    import flash.net.NetStream; 
	import flashx.textLayout.formats.VerticalAlign;
	
	public class WPFStation {

		public static const IS_DEBUG_VERSION:Boolean = false; //是否為 degbug 版
		public static const IS_NO_CARD_VERSION:Boolean = true; //是否為 no card 機型 版

    	public static const COMMAND_NUM_INVALID:int = 0; 
    	public static const LABEL_STAGE_1:String = "ProductList"; 
    	public static const LABEL_STAGE_2:String = "ShowMsg"; 
    	public static const LABEL_STAGE_3:String = "Waiting"; 
		public static const LABEL_STAGE_PRODUCT_STOPPED:String = "ProductList_Stop";  
		public static const LABEL_MESSAGE_HIDE:String = "Hidding";  
		public static const LABEL_MESSAGE_SHOW:String = "StartShow";
		public static const LABEL_MESSAGE_STOP:String = "Stopped";
		public static const LABEL_MARQUEE_IN = "MarqueeIn";
		public static const LABEL_MARQUEE_STOP = "MarqueeStop";
		public static const LABEL_MARQUEE_OUT = "MarqueeOut";
		public static const LABEL_MARQUEE_END = "MarqueeEnd";
		public static const LABEL_PRODUCT_DETAIL_START = "ProductDetailStart";
		public static const LABEL_PRODUCT_DETAIL_STOP = "ProductDetailStop";
		public static const NAME_TEXT_PURCHASECODE: String = "Input_PurchaseCode";
		public static const FILE_CONFIG_XML = "config.xml";
		public static const MAX_PURCHASE_CODE: int = 10;
		public static const WAITING_SET_ALPHA_INTERVAL = 100;
		public static const WAITING_SET_ALPHA_REPEAT = 35;
		public static const MESSAGE_IMAGE_W: int = 243;
		public static const MESSAGE_IMAGE_H: int = 150;
		public static const PRODUCT_DETAIL_IMAGE_W: int = 300;
		public static const PRODUCT_DETAIL_IMAGE_H: int = 180;
		public static const PRODUCT_DETAIL_IMAGE_X: int = 0;
		public static const PRODUCT_DETAIL_IMAGE_Y: int = 0;
		public static const PRODUCT_IMAGE_W: int = 260;
		public static const PRODUCT_IMAGE_H: int = 210;
		public static const PRODUCT_IMAGE_X: int = -132;
		public static const PRODUCT_IMAGE_Y: int = -94;
		public static const PRODUCT_ENABLE_ALPHA: Number = 1.0;
		public static const PRODUCT_DISABLE_ALPHA: Number = 0.3;
		
		//產品名稱, 字型大小設定相關
		public static const PRODUCT_NAME_DEFAULT_MAX_LENGTH: Number = 8;
		public static const PRODUCT_NAME_DEFAULT_FONT_SIZE: Number = 33; //代表字型大小 33 只能容納 8 字
		public static const PRODUCT_NAME_MINIMIZE_1_MAX_LENGTH: Number = 10;
		public static const PRODUCT_NAME_MINIMIZE_1_FONT_SIZE: Number = 26;
		public static const PRODUCT_NAME_MINIMIZE_2_MAX_LENGTH: Number = 12;
		public static const PRODUCT_NAME_MINIMIZE_2_FONT_SIZE: Number = 22;
		public static const PRODUCT_NAME_MINIMIZE_3_MAX_LENGTH: Number = 26;
		public static const PRODUCT_NAME_MINIMIZE_3_FONT_SIZE: Number = 20;
		public static const MESSAGE_IMAGE_CLIP_X: int = -440.75; //通用訊息圖片, 
		public static const MESSAGE_IMAGE_CLIP_Y: int = 292.85; //通用訊息圖片, 
		public static const MESSAGE_IMAGE_CLIP_ROTATE_Y: int = 372.85;  //通用訊息圖片, 有旋轉的話, Y 要改變
		public static const COMMAND_SEPARATOR = ",";
		public static const MARQUEE_MOVE_SPEED: int = 4;
		public static const MARQUEE_MOVE_SEPARATOR: String = "              ";
		public static const MARQUEE_ENTRANCE_X: Number = 1080;
		public static const SELF_DEF_PAGE_MAIN = "MAIN"; //主畫面, 商品列表, 7501
		public static const SELF_DEF_PAGE_WAITING_AUTH = "WAITING_AUTH"; // 等待用戶輸入授權, 等待輸入購買碼
		public static const SELF_DEF_PAGE_AUTHORIZED_PURCHASE = "AUTHORIZED_PURCHASE"; //已驗證, 準備購買, 購買碼已輸入 or 已刷卡
		public static const SELF_DEF_PAGE_NOTICE = "NOTICE_MESSAGE"; //警告訊息, 單獨顯示    (弱(子)頁面)
		public static const SELF_DEF_PAGE_PURCHASE_PRODUCT_DETAIL = "PURCHASE_PRODUCT_DETAIL"; //購買物品詳細資料
		public static const SELF_DEF_PAGE_EXPORTING_CARD = "EXPORTING_CARD"; //領取卡片頁面
		public static const SELF_DEF_PAGE_EXPORTING_PRODUCT = "EXPORTING_PRODUCT"; //領取商品頁面 2013.08.15 add
		public static const SELF_DEF_PAGE_MOBILE_CODE_INPUT = "MOBILE_CODE_INPUT"; //申請卡片頁面 (輸入手機號碼)
		public static const INSTANCE_NAME_MSG_CLIP = "MovieMsgDefault"; //訊息用影片片段最上層
		public static const INSTANCE_NAME_MSG_CHILD_CLIP = "MovieMsgNotice"; //訊息用影片片段最子層
		public static const INSTANCE_NAME_MSG_TITLE = "MessageTitle"; //頭
		public static const INSTANCE_NAME_MSG_MID = "MessageMid"; //正文
		public static const INSTANCE_NAME_MSG_BOTTOM = "MessageBottom"; //尾巴
		public static const INSTANCE_NAME_MSG_IMAGE = "MessageImage"; //圖片
		public static const INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP = "PurchaseProductDetail_Clip"; 
		public static const INSTANCE_NAME_PURCHASE_PRUDUCT_INNER_CLIP = "InnerClip";
		public static const INSTANCE_NAME_PURCHASE_PRUDUCT_CHILD_CLIP = "Detail"; //
		public static const INSTANCE_NAME_RETURN_BUTTON = "ButtonReturn";
		public static const INSTANCE_NAME_VIDEO_CLIP = "VideoContainerClip";
		public static const INSTANCE_NAME_ADIMAGE_CLIP = "ImageContainerClip";
		public static const INSTANCE_NAME_PRODUCT_MENU_CHLID_CLIP = "ButtonProduct_InnerClip";
		public static const INSTANCE_NAME_MARQUEE_ROOT = "MarqueeClipRoot"; // 20130821 待廢棄
		public static const INSTANCE_NAME_MARQUEE_CHILD = "MarqueeClipChild"; // 20130821 待廢棄
		public static const INSTANCE_NAME_MARQUEE_TEXT = "TextContent"; // 20130821 待廢棄
		
		public static const INSTANCE_NAME_MARQUEE_DYNAMIC_ROOT = "MarqueeDynamicClipRoot";
		public static const INSTANCE_NAME_MARQUEE_DYNAMIC_CHILD = "MarqueeDynamicClipChild";
		public static const INSTANCE_NAME_MARQUEE_DYNAMIC_TEXT = "MarqueeWords";
		
		public static const INSTANCE_NAME_EXPORTING_CARD = "MovieMsgExportingCard"
		public static const INSTANCE_NAME_EXPORTING_CARD_CHILD = "MovieMsgExportingCardChild";
		public static const INSTANCE_NAME_EXPORTING_PRODUCT = "MovieMsgExportingProduct";
		public static const INSTANCE_NAME_EXPORTING_PRODUCT_CHILD = "MovieMsgExportingProductChild";
		public static const INSTANCE_NAME_MOBILE_CODE_INPUT = "MovieMsgMobile" ;
		public static const INSTANCE_NAME_MOBILE_CODE_INPUT_CHILD = "MovieMsgMobileChild" ;
		public static const TOKEN_NAME_POINT_CHECK = "pointcheck";
		public static const MENU_BUTTON_COORDS_X: Array = new Array(981, 841, 701, 561);
		public static const MENU_BUTTON_COORDS_Y: Array = new Array(1152, 1152, 1152, 1152);
		
		//需要觸發事件的 Instance 實體, 請列在下方
		public static const WATCHING_INSTANCES: Array = new Array(
								"ButtonProduct_1",
								"ButtonProduct_2", 
								"ButtonProduct_3", 
								"ButtonProduct_4", 
								"ButtonProduct_5", 
								"ButtonProduct_6",
								"ButtonReceiveCard",
								"ButtonRequestCard",
								"ButtonCheckPoint", // 查詢點數
								"ButtonReturn",
								"IntroDoll",
								"MovieMsgSensor",
								"MovieCoverMask",
								"MovieMsgChoose",
								"MovieMsgExchangeDone",
								"MovieMsgMobile",
								"MovieMsgCardFailed",
								"MovieMsgNotice",
								//---
								"MovieMsgExportingCard",
								"MovieExportingCard_1",
								"MovieExportingCard_2",
								"MovieExportingCard_Text",
								//----
								"FullScreenMask", //這個不送給 server , C 端處理, 中途會被攔截
								//---
								"MovieMaskDemo",
								"HiddenAdminBTN_TL",
								"HiddenAdminBTN_TR",
								"HiddenAdminBTN_BL",
								"HiddenAdminBTN_BR"
								);
								
		public static const MESSAGE_INSTANCES: Array = new Array(
								"MovieMsgSensor",
								"MovieMsgChoose",
								"MovieMsgExchangeDone",
								"MovieMsgMobile",
								"MovieMsgCardFailed",
								"MovieMsgNotice", //舊版通用 MSG  待移除  20130606
								"MovieMsgExportingCard",
								"MovieMsgDefault" //20130606 add
								);
								
		// 進入管理者介面的隱藏按鈕順序
		public static const HIDDEN_ADMIN_SEQUENCE: Array = new Array(
								"HiddenAdminBTN_TL",
								"HiddenAdminBTN_BR",
								"HiddenAdminBTN_TR",
								"HiddenAdminBTN_BL"
								);
		public static const STR_0001 = "您拥有的点数为 \n "
		public static const STR_0002 = " 点";
		public static const STR_0003 = "兑 ";
		public static const STR_0004 = "送 ";
		
		public var _copyWatching: Array = new Array();
		public var _uiRuntimeDatas: Array = new Array();
		
		private var _hidden_admin_index = 0;

		private var _rootMovie: MovieClip;
		private var _rootStage: Stage;
		private var _debugText: TextField;
		private var _purchaseCodeInput: TextField; //消費碼輸入框
		private var _adminEnterCount = 0;
		private var _allProducts: Array = new Array();
		private var _now:Date = new Date();
		private var _selfDefPage: String;//目前頁面
		private var _selfDefPage_Previous: String; //前一個頁面
		private var _userInputtedCode: String = ""; //使用者現在已經輸入的   購買碼
		private var _userInputtedMobile: String = ""; //使用者現在已經輸入的   手機號碼
		private var _mobileInputCode: TextField; //使用者輸入手機號碼的輸入框
		private var _messageTimer: Timer;
		private var _idleSecondsCount : int = 30; //server需要的. 幾秒後認定使用者不在機台前操作
		private var _adMovie: VideoPlay; // 下方廣告動畫
		private var _moviePaths: Array;
		private var _defaultProductTextFormat: TextFormat = null;
		private var _displayObjectList: Array = new Array(); //所有動態建立的 DisplayObject 需要放於此, sh130821 add
		private var _marqueeList: Array;  //20130821 maybe marked
		private var _marqueeList_Index: int = 0; //20130821 maybe marked
		private var _productAlphaMark: Array = new Array();
		private var _productDetailResetFlag: Boolean = false; //商品資料是否被重設過 (=是否準備更新中)
		private var _mobileInputCodeResetFlag: Boolean = false; //手機號碼輸入框的 event 重設 flag
		private var _currentProductDetail: ProductData = new ProductData(); //目前使用者查看的  商品細節
		private var _currentCodeInputToken: String = ""; // 目前使用者輸入 page 的標識號
		private var _currentCodeInputTitle: String = ""; // 目前使用者輸入 code 的標題
		private var _currentCodeMaxChar: int; // 目前使用者輸入 code 的 length
		private var _currentCodeInputSeconds: int; // 目前使用者輸入 code 的標題
		private var _currentMessageToken: String;
		private var _destroying: Boolean = false;
		private var _previousDefaultMessageLoader: Loader = null; //前一次通用訊息的 圖片, 需移除 sh20130815 add
		// auto return
		private var _userLastOperateTime: Date = new Date();
		private var _userExitExportingPageTime: Date = new Date();

		public function WPFStation( rootMovie: DisplayObject, rootStage: Stage) {
			InitUIRuntimeData();
			
			_rootMovie = (rootMovie as MovieClip);
			_rootStage = rootStage;
			
			_defaultProductTextFormat = _rootMovie["ButtonProduct_1"][INSTANCE_NAME_PRODUCT_MENU_CHLID_CLIP]["ProductName"].getTextFormat();
			// constructor code
			ExternalInterface.addCallback("WPFCommand",this.RecieveMessage);
			//_copyWatching = GlobalMethod.Clone( WATCHING_INSTANCES );
			
			for(var i: int=0 ; i < WATCHING_INSTANCES.length ;i++)
			{
				_copyWatching.push(WATCHING_INSTANCES[i]);
			}
			
			if(IS_DEBUG_VERSION == true)
			{
				CreateDebugTextfield(); // debug 用訊息
				_rootStage.addChild(DebugTextfield);
				//_displayObjectList.push(DebugTextfield);
			}
			_rootMovie.addEventListener(Event.ENTER_FRAME, Update);
		
			// debug 專區
			//DoCommand_1500([1500, 399]);
			//DoCommand_1900(null);
			//DoCommand_1100(null);
			
			//7501,页面倒计时长(秒)，商品总数量，商品编号(从1开始)，商品名称，点数，图片路径
//			DoCommand_7501([60, 6, 1,"辣的面",-5, "product_images/HT000001.jpg",
//						   		  2,"方便面",-5, "product_images/HT000002.jpg",
//								  3,"不方便面",-5, "product_images/HT000003.jpg",
//								  4,"藍莓汁",-5, "product_images/HT15966.png",
//								  5,"楊梅汁",-5, "product_images/HT35195.png",
//								  6,"黑莓汁",-5, "product_images/HT44310.png"]);
//								  
//			DoCommand_7501([60, 6, 1,"辣的面",-5, "product_images/HT000001.jpg",
//						   		  2,"方便面",-5, "product_images/HT35195.png",
//								  3,"不方便面",-5, "product_images/HT44310.png",
//								  4,"藍莓汁",-5, "product_images/HT15966.png",
//								  5,"楊梅汁",-5, "product_images/HT000002.jpg",
//								  6,"黑莓汁",-5, "D:/远鼎/IMG_1111.jpg"]);
//
//			RecieveMessage("7501, 60, 6, 1,辣的面,-5, product_images/HT000001.jpg,"+
//						   		  "2,方便面,-5, product_images/HT000002.jpg,"+
//								  "3,不方便面,-5, product_images/HT000003.jpg,"+
//								  "4,藍莓汁,-65, product_images/HT15966.png,"+
//								  "5,楊梅汁,25, product_images/HT35195.png,"+
//								  "6,黑莓汁,-5, product_images/HT44310.png");
								
			//RecieveMessage("7502, 6, 1,0,2,1,3,0,4,1,5,0,6,0");
			
			//RecieveMessage("7101,1,ButtonProduct_1,1");
			
			_selfDefPage_Previous = SELF_DEF_PAGE_MAIN;
			_selfDefPage = ""; //尚未初始化的頁面
			
			
			DebugMsg("LoadXML(FILE_CONFIG_XML , OnConfigXMLLoaded);");
			LoadXML(FILE_CONFIG_XML , OnConfigXMLLoaded);
			
//			if(IS_DEBUG_VERSION)
//			{
//							RecieveMessage("7501, 5, 6, 1,不好吃,-5, product_images/HT000001.jpg,"+
//						   		  "2,不好吃,-5, product_images/HT35195.png,"+
//								  "3,不好吃,-5, product_images/HT000003.jpg,"+
//								  "4,難吃阿,-65, product_images/HT15966.png,"+
//								  "5,難吃阿,25, product_images/HT000002.jpg,"+
//								  "6,難吃阿,-5, product_images/HT44310.png");
//			}
		}
		
		// "RecieveMessage" 此 method name 必須在 csharp 端的 invoke name (in XML)內設定
		public function RecieveMessage(val: String):void
		{
			var args = val.split(COMMAND_SEPARATOR);
			
			_userLastOperateTime = Now;
			GlobalMethod.ArrayTrim(args);
			if(args.length <=0)
			{
				DebugMsg("RecieveMessage no arguments");
				return;
			}
			
			var commandNum : String = args.shift();
			var methodName: String = "DoCommand_" + commandNum;
			
			try 
			{ 
				if(!(methodName in this) || (this[methodName] == null) || (this[methodName] == undefined))
				{
					DebugMsg("RecieveMessage no method : " + methodName);
					return;
				}
				
				this[methodName](args); //call DoCommand_xxx
				DebugMsg("Call method  " + commandNum + " OK");
			} 
			catch (error:Error) 
			{ 
				DebugMsg(error.message);
			}	
		}
		
		public function GetWatchingInstances():Array
		{
			return WATCHING_INSTANCES;
		}
		
		public function get UIDatas():Array
		{
			return _uiRuntimeDatas;
		}
		
		private function InitUIRuntimeData():void
		{
			_uiRuntimeDatas.length = 0;
			var newData: UIRuntimeData;
			for(var i:int=0 ; i < WATCHING_INSTANCES.length; i++)
			{
				newData = new UIRuntimeData();
				newData.Flag = false;
				newData.Name = WATCHING_INSTANCES[i];
				_uiRuntimeDatas.push(newData);
			}
		}
		
		private function ResetUIRuntimeDataFlag():void
		{
			for(var i:int=0 ; i < _uiRuntimeDatas.length; i++)
			{
				_uiRuntimeDatas[i].Flag = false;
			}
		}
		
		public function SendMessage( commandNum : int, ... args):void
		{
			if(_destroying == true)
				return;
				
			_userLastOperateTime = Now;
			
			var combinedCommand : String = GlobalMethod.StringArrayConcact(args, COMMAND_SEPARATOR);
			
			combinedCommand = commandNum + COMMAND_SEPARATOR + combinedCommand;
			DebugMsg("SendMessage: " + combinedCommand);
			//ExternalInterface.call("ASCommand", commandNum, args ); //多個參數版本已棄用 2013.06.04
			ExternalInterface.call("ASCommand", combinedCommand ); //單參數使用 ", " 分隔的版本
		}
		
		// UI 被觸發的消息類型
		public function UITrigger(evt : Event, btnName: String = ""):void
		{
			if(IS_DEBUG_VERSION == false)
			{
				if(this == null)
					return;
			}
			
			var evtName: String = "";
			var commandNumber: int = 0;
			
			_userLastOperateTime = Now; //使用者有操作過, 更新 idle 秒數
			
			if((evt == null) && (btnName != "")) //強制模擬某元件被 trigger 的方式. todo: script trigger
			{
				evtName = btnName ;
				commandNumber = GetCommandNumber(evtName);
			}
			else if(evt.currentTarget is DisplayObject)
			{
				evtName = (evt.currentTarget as DisplayObject).name ;
				commandNumber = GetCommandNumber(evtName);
			}
			else
			{
				evtName = "notdefined";
				commandNumber = WPFStation.COMMAND_NUM_INVALID;
			}
			
			// 判斷是否為例外處理用的 component
			var needSend : Boolean = true;
			var methodName: String = "ReadySendCommand_" + commandNumber;
			var currentPage = _selfDefPage;
			
			//7203:提示信息时的返回和部件
			//命令格式	7203,页面名，部件名，标识号
			if(_selfDefPage == SELF_DEF_PAGE_NOTICE)
			{
				SendMessage(7203, [currentPage, evtName, _currentMessageToken]);
			}
			// 7201 UI 觸發事件一般情況都要送
			//7201:用户点击了部件   7201,页面名，部件名
			else if(evtName != "")
			{
				SendMessage(7201, [currentPage, evtName]);
			}

			try 
			{ 
				
				if(!(methodName in this) || (this[methodName] == null) || (this[methodName] == undefined))
				{
					needSend = true;
					//DebugMsg("Ready Send Message no method : " + methodName);
				}
				else //有 method name 代表送出 command 是有條件的, 檢查之
				{
					needSend = this[methodName]([evtName]); //call DoCommand_xxx
				}
			}
			catch (error:Error) 
			{ 
				DebugMsg(error.message);
			}	
			
			if(needSend == false)
			{
				DebugMsg(commandNumber + " needSend == false: ");
				return;
			}
			
			
			if(IS_DEBUG_VERSION == true)
			{
			//test
			if(evtName == "HiddenAdminBTN_TR")
			{
							RecieveMessage("7501, 20, 6, 1,辣的面,-5, product_images/HT000001.jpg,"+
					   		  "2,方便面,-5, product_images/HT000002.jpg,"+
								  "3,不方便面,-5, product_images/HT000003.jpg,"+
								  "4,藍莓汁,-65, product_images/HT15966.png,"+
								  "5,楊梅汁,25, product_images/HT35195.png,"+
								  "6,黑莓汁,-5, product_images/HT44310.png");

				//RecieveMessage("7100, 6, 抱歉, 券號輸入錯誤 \n 如有疑問，請洽客服, 420-021-8816, product_images/HappyGo.png, 340, msgToken");
				//RecieveMessage("7710, 5, 2053");
			}
			
			if(evtName == "HiddenAdminBTN_BR")
			{
							RecieveMessage("7501, 40, 6, 1,不好吃,-5, product_images/HT000001.jpg,"+
						   		  "2,不好吃,-5, product_images/HT35195.png,"+
								  "3,不好吃難吃阿難吃阿,-5, product_images/HT000003.jpg,"+
								  "4,難吃阿難吃阿難吃阿難吃阿,-65, product_images/HT15966.png,"+
								  "5,難吃阿難吃阿難吃阿難吃阿難吃阿難吃阿,25, product_images/HT000002.jpg,"+
								  "6,難吃阿難吃阿難吃阿難吃阿難吃阿難吃阿難吃阿難吃阿難吃阿,-5, product_images/HT44310.png");
								  
							//RecieveMessage("7502, 6, 1,0,2,0,3,1,4,1,5,0,6,1");
			}
			if(evtName == "HiddenAdminBTN_TL")
			{
				//RecieveMessage("7100, 6, 抱歉, 哈哈, 420-021-8816, , 0, msgToken");
				RecieveMessage("7105");
				//RecieveMessage("7502, 6, 1,0,2,0,3,1,4,1,5,0,6,1");
				//RecieveMessage("7502, 6, 1,0,2,1,3,0,4,1,5,0,6,0");
				//RecieveMessage("7601, 30, 3, 霹靂包,-5,product_images/HT000003.jpg,聽說這裡是詳細敘述~要補滿很多字~看會不會換行~~~~YO~ 結果字還是不夠呢~ HAHA" );
				//RecieveMessage("7901, 8");
			}
			
			if(evtName == "HiddenAdminBTN_BL")
			{
				RecieveMessage("7801, 30, mobile , 手機號碼, 9");
				//RecieveMessage("7601, 30, 3, 霹靂包,-5,product_images/HT000003.jpg," );
				//RecieveMessage("7100, 8, 標題, 中間內文, 結尾, , 0");
//				RecieveMessage("7501, 20, 6, 1,不好吃,-5, product_images/HT000001.jpg,"+
//						   		  "2,不好吃,-5, product_images/HT35195.png,"+
//								  "3,不好吃,-5, product_images/HT000003.jpg,"+
//								  "4,難,-65, product_images/HT44310.png,"+
//								  "5,難阿,25, product_images/HT000002.jpg,"+
//								  "6,吃阿,-5, product_images/HT15966.png");
			}
			
			}
			
			// 其他協定
			//SendMessage(commandNumber, [evtName]);
		}
		
		//窗体倒计时为0时，发信息给C#
		//关于倒计时，当用户有动作或C#有发命令，倒计时重新计算，当时间为0时，才发信息给C#
		private function CheckUserIdle():void
		{
			var millisecondDifference:int = Now.valueOf() - _userLastOperateTime.valueOf();
			var seconds:int = millisecondDifference / 1000;

			if( seconds > _idleSecondsCount ) //閒置過久
			{
				UITrigger(null, INSTANCE_NAME_RETURN_BUTTON);
				_userLastOperateTime = Now;
			}
		}
		
		// 由 UI 命名判斷要傳送給 C# 的命令編號
		// 回傳 0 代表不回傳給 C#
		private function GetCommandNumber( instance: String) : int
		{
			var res:int = WPFStation.COMMAND_NUM_INVALID;
			switch(instance)
			{
				case "ButtonReceiveCard": //領取卡片
					res = 2000;
					break;
				case "ButtonRequestCard": //申請卡片
					res = 2100;
					break;
				case "ButtonProduct_1": //點選商品
				case "ButtonProduct_2":
				case "ButtonProduct_3":
				case "ButtonProduct_4":
				case "ButtonProduct_5":
				case "ButtonProduct_6":
					res = 3000;
					break;
				case "HiddenAdminBTN_TL":
				case "HiddenAdminBTN_BR":
				case "HiddenAdminBTN_TR":
				case "HiddenAdminBTN_BL":
					res = 9999;
					break;
				case "FullScreenMask":
					res = 10001;
					break;
				case "ButtonReturn":
					res = 10002;
					break;
				case "PurchaseSubmit" :
					res = 10003;
				default:
					res = WPFStation.COMMAND_NUM_INVALID;
					break;
			}
			return res;
		}
		
		public function CreateDebugTextfield()
		{
			if(_debugText==null)
				_debugText = new TextField();
			_debugText.x = 10;
			_debugText.y = 10;
			_debugText.width = 450;
			_debugText.height = 35;
			_debugText.alwaysShowSelection = true;
			_debugText.border = true;
			
			var format:TextFormat = new TextFormat(); 
            format.font = "Verdana"; 
            format.color = 0x000000; 
            format.size = 24; 
 
            _debugText.defaultTextFormat = format; 
		}
		
		public function DebugMsg(msg:String)
		{
			if(_debugText != null)
			{
				_debugText.text = "Debug: " +msg;
			}
			trace("Debug: " +msg);
		}
		
		private function HideAllMessageMovie(): void
		{
			try{
				/*(RootStage.getChildByName("MovieMsgSensor") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieCoverMask") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieMsgChoose") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieMsgExchangeDone") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieMsgMobile") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieMsgCardFailed") as MovieClip).visible = false;
				(RootStage.getChildByName("MovieMsgRemainPoint") as MovieClip).visible = false;*/
				var mc : MovieClip;
				for(var i:int=0 ; i < MESSAGE_INSTANCES.length;i++)
				{
					if(MESSAGE_INSTANCES[i].indexOf("MovieMsg") <= -1)
						continue;
					mc = RootStage.getChildByName(MESSAGE_INSTANCES[i])as MovieClip
					if(mc==null)
						continue;
					mc.visible = false;
				}
			}
			catch(e:Error)
			{
				DebugMsg(e.message);
			}
		}
		
		private function HideProductDetail(): void
		{
			HideMovie(INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP);
			RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP].gotoAndStop(LABEL_MESSAGE_HIDE);
		}
		
		//使用預設的提示元件顯示訊息
		private function ShowDefaultMessage(remaindSeconds: int, titleMsg: String, midContents: String, bottom:String, imagePath:String, rotate:int, token: String)
		{
			_currentMessageToken = token;
			HideAllMessageMovie(); //可能要跟其他 MSG 同時顯示 ? 待觀察
			
			if(remaindSeconds == 0) //持續秒數為 0 代表隱藏訊息
			{
				HideDefaultMessage(null);
			}

			var mc: MovieClip = RootStage.getChildByName( INSTANCE_NAME_MSG_CLIP ) as MovieClip;
			
			if(mc == null)
			{
				DebugMsg("DoCommand error.1");
				return;
			}
			mc.visible = true;
			var msgTitle: TextField 	= mc[INSTANCE_NAME_MSG_CHILD_CLIP][INSTANCE_NAME_MSG_TITLE] as TextField;
			var msgMid: TextField 		= mc[INSTANCE_NAME_MSG_CHILD_CLIP][INSTANCE_NAME_MSG_MID] as TextField;
			var msgBot: TextField 		= mc[INSTANCE_NAME_MSG_CHILD_CLIP][INSTANCE_NAME_MSG_BOTTOM] as TextField;
			
			if(msgTitle==null)
			{
				DebugMsg("DoCommand error.2");
				return;
			}
			
			msgTitle.text = titleMsg;
			msgMid.multiline = true;
			msgMid.wordWrap = true;
			msgMid.text = midContents;
			//msg.htmlText =  "<p>" + contents + "<p>" + "<p> <font color=\"blue\" size = \"32\">This is some text!</font>  <img src='HKP'/>"; // 這個暫時不用
			msgMid.autoSize = TextFieldAutoSize.CENTER; 
			//msg.y = mc.height * 0.5 - msg.textHeight * 0.5; //因為有動畫, 可能無用
			msgBot.text = bottom;
			
			mc.gotoAndPlay( LABEL_MESSAGE_SHOW );
			
			_messageTimer = StartCoroutine(UpdateDefaultMessage, HideDefaultMessage, remaindSeconds* 1000, 1);//remaindSeconds
			
			var imageMC: MovieClip = mc[INSTANCE_NAME_MSG_CHILD_CLIP][INSTANCE_NAME_MSG_IMAGE] as MovieClip;
			
			imageMC.rotation = rotate;
			if(rotate > 0)
			{
				imageMC.x = MESSAGE_IMAGE_CLIP_X;
				imageMC.y = MESSAGE_IMAGE_CLIP_ROTATE_Y;
			}
			else
			{
				imageMC.x = MESSAGE_IMAGE_CLIP_X;
				imageMC.y = MESSAGE_IMAGE_CLIP_Y;
			}
			
			if(_previousDefaultMessageLoader != null) // sh20130815 add 修復前一次訊息 PIC 沒移除的 BUG
			{
				imageMC.removeChild(_previousDefaultMessageLoader);
				_previousDefaultMessageLoader = null;
			}
			_previousDefaultMessageLoader = GlobalMethod.LoadMovieClipImage( imageMC, imagePath, OnMessageImageLoaded);
		}
		
		//使用預設的提示元件顯示訊息 OLD
		private function ShowDefaultMessage_old(contents: String, remaindSeconds: int = 1000)
		{
			HideAllMessageMovie(); //可能要跟其他 MSG 同時顯示 ? 待觀察
			//var mc: MovieClip = RootStage.getChildByName("MovieMsgNotice") as MovieClip;
			var mc: MovieClip = RootStage.getChildByName("MovieMsgDefault") as MovieClip;
			
			if(mc == null)
			{
				DebugMsg("DoCommand error.1");
				return;
			}
			mc.visible = true;
			
			var msg: TextField = mc["MovieMsgNotice"]["Message"] as TextField;
			if(msg==null)
			{
				DebugMsg("DoCommand error.2");
				return;
			}
			msg.multiline = true;
			msg.wordWrap = true;
			msg.text = contents;
			//msg.htmlText =  "<p>" + contents + "<p>" + "<p> <font color=\"blue\" size = \"32\">This is some text!</font>  <img src='HKP'/>"; // 這個暫時不用
			msg.autoSize = TextFieldAutoSize.CENTER; 
			//msg.y = mc.height * 0.5 - msg.textHeight * 0.5; //因為有動畫, 可能無用
			
			mc.gotoAndPlay( LABEL_MESSAGE_SHOW );
			
			StartCoroutine(UpdateDefaultMessage, HideDefaultMessage, remaindSeconds* 1000, 1);// N 秒後消失
		}
		
		private function UpdateDefaultMessage(e:Event) // todo : 找機會看能不能簡化吧, 讓 evet 帶參數
		{
		}
		private function HideDefaultMessage(e:Event, autoReturn: Boolean = true) // todo : 找機會看能不能簡化吧, 讓 evet 帶參數
		{
			//var mc: MovieClip = RootStage.getChildByName("MovieMsgNotice") as MovieClip;
			var mc: MovieClip = RootStage.getChildByName(INSTANCE_NAME_MSG_CLIP) as MovieClip;
			
			if(mc == null)
			{
				DebugMsg("HideDefaultMessage error.1");
				return;
			}
			mc.visible = false;
			
			if(_messageTimer != null)
			{
				_messageTimer.stop();
				_messageTimer = null;
			}
			
			//trace("弱頁面是返回上一頁");
			// goto previous page
			if(autoReturn)
			{
				// 送個訊息給 server 通知一下 sh130701 add
				SendMessage(7203, [_selfDefPage, INSTANCE_NAME_RETURN_BUTTON, _currentMessageToken]); 
				
				switch(_selfDefPage_Previous)
				{
					case SELF_DEF_PAGE_MAIN:
					case SELF_DEF_PAGE_NOTICE: //同頁面, 理論上是 ser 送錯, 回 main
						On_Page_WaitingMain();
						Page_WaitingMain();
						break;
					case SELF_DEF_PAGE_WAITING_AUTH:
						On_Page_WaitingUserAuthorize();
						Page_WaitingUserAuthorize();
						break;
					case SELF_DEF_PAGE_AUTHORIZED_PURCHASE:
						On_Page_AuthorizedPurchase();
						Page_AuthorizedPurchase();
						break;
					default:
					//nothing
				}
				
			}
		}
		
		//顯示特定的提示元件
		private function ShowMovieMessage(componentName: String)
		{
			HideAllMessageMovie();
			RootStage[ componentName ].visible = true;
		}
		private function HideMovie(componentName: String)
		{
			try
			{
				if(!(componentName in RootStage) || (RootStage[componentName] == null) || (RootStage[componentName] == undefined)){}
				else
				{
					RootStage[ componentName ].visible = false;
				}
			}
			catch(error:Error)
			{
				DebugMsg(error.message);
			}
		}
		//---------------------------- Property -----------------------------
		public function get DebugTextfield():TextField {
			if(_debugText==null)
				CreateDebugTextfield();
			return _debugText;
		}
		public function get RootStage():MovieClip {
			return _rootMovie;		
		}
		public function get Now():Date
		{
			_now = new Date();
			return _now;
		}
		//---------------------------- Property End-----------------------------
		
		private function DisableFullScreenMask(): void //判斷用戶是否點擊 SCREEN 任意點的 隱藏按鈕
		{
			HideMovie("FullScreenMask");
		}
		
		private function EnableFullScreenMask(): void //判斷用戶是否點擊 SCREEN 任意點的 隱藏按鈕
		{
			RootStage["FullScreenMask"].visible = true;
		}
		
		private function DisableMessageAlpha(): void //判斷用戶是否點擊 SCREEN 任意點的 隱藏按鈕
		{
			HideMovie("FullScreenAlphaMask");
		}
		
		private function EnableMessageAlpha(): void //判斷用戶是否點擊 SCREEN 任意點的 隱藏按鈕
		{
			RootStage["FullScreenAlphaMask"].visible = true;
		}
		
		private function DisableExportingCard(): void
		{
			RootStage[INSTANCE_NAME_EXPORTING_CARD].gotoAndPlay(LABEL_MESSAGE_HIDE);
		}
		
		private function DisableMobileCodeInput(): void
		{
			RootStage[INSTANCE_NAME_MOBILE_CODE_INPUT].gotoAndPlay(LABEL_MESSAGE_HIDE);
		}
		
		// 執行 1次,購買物品詳細頁面
		private function On_Page_PurchaseProductDetail():void
		{
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_PURCHASE_PRODUCT_DETAIL;
			
			RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP].gotoAndPlay(LABEL_MESSAGE_SHOW);
			RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP].visible = true;
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
		}
		
		// 執行 1次, Page Main, 等待使用者感應.主畫面
		public function On_Page_WaitingMain():void
		{
			ResetUIRuntimeDataFlag(); //防止 UI 出錯, 事件重新加入
			
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_MAIN;
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_1)
			{
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_1);
				ReplayProductMenuAnimation();
			}

			HideProductDetail();
			DisableExportingCard();
			DisableMobileCodeInput();
			
			SetAll_ProductVisible(true);
			
			//回到未認證狀態, 商品要看起來都可以買, 照理說應該是 server 會送 7502, 不過預防一下 CL 先做
			//SetAll_ClickableProduct(true);  //過早設定 alpha , marked 2013.0610
			StartWaitingResetAlpha();
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
		}
		
		// 執行 1次, Page UserAuthorize, 等待使用者輸入   購物碼
		private function On_Page_WaitingUserAuthorize():void
		{
			ResetUIRuntimeDataFlag(); //防止 UI 出錯, 事件重新加入
						
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_WAITING_AUTH;
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2)
			{
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
			}
			
			//----
			_purchaseCodeInput = null; 
			// script 的 ref 參照到 stage 上的實體物件, 這個參照在 flash frame 重新進入後, 會是個孤兒, 也就是
			// ref 到一個實體 flash 物件, 在 frame 變動過後, 並不可靠, 100% 遺失, 可見 flash 每次執行 frame 會重新 new 美術拉的實體物件(STABLE INSTANCE);
			
			ShowMovieMessage("MovieMsgSensor");
			StartCoroutine(DetectTextField_PurchaseCode, DetectTextFieldComplete_PurchaseCode, 100, 30);

			HideProductDetail();
			DisableExportingCard();
			DisableMobileCodeInput();
			
			SetAll_ProductVisible(true);
			//SetAll_ClickableProduct(true); //回到未認證狀態, 商品要看起來都可以買, 照理說應該是 server 會送 7502, 不過預防一下 CL 先做, sh130617 marked, 過早設定 alpha
			StartWaitingResetAlpha();
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
		}
		
		// 執行 1次, Page AUTHORIZED_PURCHASE, 已驗證, 準備購買, 購買碼已輸入 or 已刷卡
		private function On_Page_AuthorizedPurchase():void
		{
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_AUTHORIZED_PURCHASE;
			
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_1)
			{
				RootStage.gotoAndPlay(LABEL_STAGE_1);
				ReplayProductMenuAnimation();
			}
			
			HideMovie("MovieMsgSensor"); //已經刷卡了, 隱藏可能有的感應訊息框
			HideMovie("FullScreenAlphaMask");
			DisableFullScreenMask();
			DisableExportingCard();
			DisableMobileCodeInput();
			HideProductDetail();
			SetAll_ProductVisible(true);
			StartWaitingResetAlpha_Single();
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
		}
		
		// 執行 1次, 獨立顯示訊息
		private function On_Page_NoticeMessage():void
		{
			HideProductDetail();
			DisableExportingCard();
			DisableMobileCodeInput();
			
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_NOTICE;
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
		}
		
		// 執行 1次, 領取卡片(等待出卡)
		private function On_Page_ExportingCard():void
		{
			HideProductDetail();
			DisableMobileCodeInput();
			
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_EXPORTING_CARD;
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
			
			var clip: MovieClip = RootStage[INSTANCE_NAME_EXPORTING_CARD] as MovieClip;
			clip.gotoAndPlay(LABEL_MESSAGE_SHOW);
			clip.visible = true;
		}
		
		// 執行 1次, 領取商品 sh20130815 add
		private function On_Page_ExportingProduct():void
		{
			HideProductDetail();
			DisableMobileCodeInput();
			
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_EXPORTING_PRODUCT;
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
			
			var clip: MovieClip = RootStage[INSTANCE_NAME_EXPORTING_CARD] as MovieClip;
			clip.gotoAndPlay(LABEL_MESSAGE_SHOW);
			clip.visible = true;
		}
		
		// 執行 1次, 申請卡片(輸入手機號碼)
		private function On_Page_MobileCodeInput():void
		{
			HideProductDetail();
			DisableExportingCard();
			
			_selfDefPage_Previous = _selfDefPage;
			_selfDefPage = SELF_DEF_PAGE_MOBILE_CODE_INPUT;
			
			_userLastOperateTime = Now; //換頁也預設, 使用者有操作過, 更新 idle 秒數
			
			var clip: MovieClip = RootStage[INSTANCE_NAME_MOBILE_CODE_INPUT] as MovieClip;
			clip.gotoAndPlay(LABEL_MESSAGE_SHOW);
			clip.visible = true;
			
			_mobileInputCodeResetFlag = true;
		}
		
		private function Page_NotInitialize(): void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
		}
		// 執行多次, Page Main, 等待使用者感應.主畫面
		private function Page_WaitingMain()
		{
			//StartCoroutine(Invisible_Button, Invisible_Button_Complete, 80, 30);
			
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = true;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = true;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideDefaultMessage(null, false);
			HideProductDetail();
			EnableFullScreenMask();
			DisableMessageAlpha();
		}
		
		// 執行多次,購買物品詳細頁面
		private function Page_PurchaseProductDetail():void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideDefaultMessage(null, false);
			DisableFullScreenMask();
			DisableMessageAlpha();
		}
		
		// 執行多次, 等待使用者輸入,  購物碼
		private function Page_WaitingUserAuthorize()
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = true;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = true;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideDefaultMessage(null, false);
			HideProductDetail();
			EnableFullScreenMask();
			EnableMessageAlpha();
		}
		
		//執行多次, 已驗證, 準備購買, 購買碼已輸入 or 已刷卡
		private function Page_AuthorizedPurchase():void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = true;
			}
			
			HideDefaultMessage(null, false);
			HideProductDetail();
			DisableFullScreenMask();
			DisableMessageAlpha();
		}
		
		//執行多次, 獨立顯示訊息
		private function Page_NoticeMessage(): void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideProductDetail();
			SetAll_ProductVisible(false);
		}
		
		//執行多次, 领取卡片(等待出卡)
		private function Page_ExportingCard(): void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideProductDetail();
			HideDefaultMessage(null, false);
			SetAll_ProductVisible(false);
			DisableFullScreenMask();
			DisableMessageAlpha();
			
			// check auto return
			if( Now.valueOf() > _userExitExportingPageTime.valueOf() ) //閒置過久
			{
				UITrigger(null, INSTANCE_NAME_RETURN_BUTTON);
				_userExitExportingPageTime.setSeconds(_userExitExportingPageTime.getSeconds, 60); //避免訊息連送, 假設 ser 60 秒內會送回應
			}
		}
		
		//執行多次, 领取卡片(等待出卡)
		private function Page_MobileCodeInput(): void
		{
			//因為補間動畫的關係, BTN visible最好每個 frame 設定一次
			if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
			else
			{
				RootStage["ButtonReceiveCard"].visible = false;
			}

			if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
			else
			{
				RootStage["ButtonRequestCard"].visible = false;
			}
			
			if(!("ButtonCheckPoint" in RootStage) || (RootStage["ButtonCheckPoint"] == null) || (RootStage["ButtonCheckPoint"] == undefined)){}
			else
			{
				RootStage["ButtonCheckPoint"].visible = false;
			}
			
			HideProductDetail();
			SetAll_ProductVisible(false);
			DisableFullScreenMask();
			DisableMessageAlpha();
			HideDefaultMessage(null, false);
			
			if(_mobileInputCodeResetFlag == false)
				return;
			if(RootStage[INSTANCE_NAME_MOBILE_CODE_INPUT].currentLabel != LABEL_MESSAGE_STOP)
				return;
			var mc : MovieClip = RootStage[INSTANCE_NAME_MOBILE_CODE_INPUT][INSTANCE_NAME_MOBILE_CODE_INPUT_CHILD] as MovieClip;
			_mobileInputCode = mc["MobileInputText"] as TextField;
			var mobileTitle: TextField =  mc["MobileInputTitle"] as TextField;
			mobileTitle.text = _currentCodeInputTitle;

			_rootStage.focus = _mobileInputCode;
			_mobileInputCode.addEventListener(KeyboardEvent.KEY_DOWN, MobileCodeInputKeyDown);
			_mobileInputCode.text = "";
			_userInputtedMobile = "";
			//_mobileInputCode.restrict = "a-zA-Z0-9_ \\-" ; //限制輸入字元
			_mobileInputCode.restrict = "0-9" ; //限制輸入字元
			_mobileInputCode.maxChars = _currentCodeMaxChar;
			_mobileInputCodeResetFlag = false;
		}
		
		//DetectTextField, 消費碼
		private function DetectTextField_PurchaseCode(event:TimerEvent): void
		{
			if(_purchaseCodeInput != null)
			{
				//ResetPurchaseInput();
				return;
			}
			var mc: MovieClip = RootStage["MovieMsgSensor"] as MovieClip;
			var tempField: TextField;			

			if(_purchaseCodeInput == null)
			{
				//trace(DetectTextField);
				tempField = DetectTextField( mc, NAME_TEXT_PURCHASECODE);
			}
			
			if(tempField == null)
				return;
				
			_purchaseCodeInput = tempField;
			ResetPurchaseInput();
		}
		
		public function ResetPurchaseInput():void
		{
			trace(_purchaseCodeInput);
			
			_userInputtedCode = ""; // 清空輸入碼
			_purchaseCodeInput.text = "";
			_purchaseCodeInput.restrict = "a-zA-Z0-9_ \\-" ; //限制輸入字元
			_purchaseCodeInput.maxChars = MAX_PURCHASE_CODE;
			_purchaseCodeInput.addEventListener(KeyboardEvent.KEY_DOWN, PurchaseCodeKeyDown);
			_rootStage.focus = _purchaseCodeInput;
			
			//trace("_rootStage.focus = _purchaseCodeInput; " + _purchaseCodeInput   + "    "   + _purchaseCodeInput.text);
		}
		
		//此為 pre - process, flash 輸入到 textfield 前會執行  todo: 與 MobileCodeInputKeyDown 重構合併
		private function PurchaseCodeKeyDown(event:KeyboardEvent)
		{
			if((event.charCode == 8) && (_userInputtedCode.length <=1)) //backspace, 且字會清空
			{
				_userInputtedCode = "";
				trace("_userInputtedCode : " + _userInputtedCode + "   L:" + _userInputtedCode.length);
				return;
			}
			
			if((event.charCode == 8) && (_userInputtedCode.length >1)) //backspace
			{
				_userInputtedCode = _userInputtedCode.substr(0, _userInputtedCode.length - 1);
				
				trace("_userInputtedCode : " + _userInputtedCode + "   L:" + _userInputtedCode.length);
				return;
			}
			
			if(event.charCode == 13) //enter 回車鍵
			{
				SendMessage(7510, [_userInputtedCode]); // 1.	7510:总换码上报   ,  用户输入兑换码按回车后发送此命令
				
				return;
			}
			
			if(event.charCode <= 31 && event.charCode != 0)//其他控制字元, 不處理, tf 用 restrict 擋掉
			{
				trace("event.charCode  " + event.charCode);
				return;
			}
			
			if(_userInputtedCode.length == MAX_PURCHASE_CODE)//超出字元數, 不處理, tf 用 maxChar 擋掉
			{
				trace("超出字元數, 不處理, tf 用 maxChar 擋掉");
				return;
			}
			
			_userInputtedCode = _userInputtedCode + String.fromCharCode(event.charCode);
			trace("_userInputtedCode : " + _userInputtedCode + "   --L:" + _userInputtedCode.length);
			StartCoroutine(OnTick_PasswordMask, OnComplete_PasswordMask, 500, 1);
		}
		
		//此為 pre - process, flash 輸入到 textfield 前會執行 todo: 與 PurchaseCodeKeyDown 重構合併
		private function MobileCodeInputKeyDown(event:KeyboardEvent)
		{
			if((event.charCode == 8) && (_userInputtedMobile.length <=1)) //backspace, 且字會清空
			{
				_userInputtedMobile = "";
				trace("_userInputtedMobile : " + _userInputtedMobile + "   L:" + _userInputtedMobile.length);
				return;
			}
			
			if((event.charCode == 8) && (_userInputtedMobile.length >1)) //backspace
			{
				_userInputtedMobile = _userInputtedMobile.substr(0, _userInputtedMobile.length - 1);
				
				trace("_userInputtedMobile : " + _userInputtedMobile + "   L:" + _userInputtedMobile.length);
				return;
			}
			
			if(event.charCode == 13) //enter 回車鍵
			{
				//SendMessage(7810, [_mobileInputCode.text]); //20130627 discard 7810:总换码上报   ,  用户输入兑换码按回车后发送此命令
				
				//7850: 数据上报
				//用户输入数据按回车后发送此命令
				//命令格式	7850, 标题(如：mobile), 输入数据
				SendMessage(7850, [ _currentCodeInputToken + COMMAND_SEPARATOR + _userInputtedMobile]); //
				
				_userInputtedMobile = "";
				return;
			}
			
			if(event.charCode <= 31 && event.charCode != 0)//其他控制字元, 不處理, tf 用 restrict 擋掉
			{
				trace("event.charCode  " + event.charCode);
				return;
			}
			
			_userInputtedMobile  = _userInputtedMobile + String.fromCharCode(event.charCode);
			trace("_userInputtedMobile : " + _userInputtedMobile + "   --L:" + _userInputtedMobile.length);
			StartCoroutine(OnTick_PasswordMask, OnComplete_MobileMask, 500, 1);

		}
		
		private function OnTick_PasswordMask(event:TimerEvent)
		{
			//nothing
		}
		
		private function OnComplete_PasswordMask(event:TimerEvent)
		{
			var res: String = "";
			var filled: Boolean = false;
			for(var i:int=0 ; i < _purchaseCodeInput.text.length ;i++)
			{
				if((filled == false) && (_purchaseCodeInput.text.charAt(i) != "*")) //進 method 一次只填一個 *
				{
					res = res + "*";
					filled = true;
				}
				else
				{
					res = res + _purchaseCodeInput.text.charAt(i);
				}
			}			
			_purchaseCodeInput.text = res;
			//trace("_userInputtedCode : " + _userInputtedCode);
		}
		
		private function OnComplete_MobileMask(event:TimerEvent)
		{
			var res: String = "";
			var filled: Boolean = false;
			for(var i:int=0 ; i < _mobileInputCode.text.length ;i++)
			{
				if((filled == false) && (_mobileInputCode.text.charAt(i) != "*")) //進 method 一次只填一個 *
				{
					res = res + "*";
					filled = true;
				}
				else
				{
					res = res + _mobileInputCode.text.charAt(i);
				}
			}			
			_mobileInputCode.text = res;
			//trace("_userInputtedCode : " + _userInputtedCode);
		}
		
		private function DetectTextFieldComplete_PurchaseCode(event:TimerEvent): void
		{
			// no thing
		}
		
		//偵測並回傳一個 text field
		private function DetectTextField(parentMC: MovieClip, fieldName: String): TextField
		{
			if(parentMC == null)
			{
				trace("parentMC == null");
				return null;
			}
			if((parentMC[fieldName] == null) || (parentMC[fieldName] == undefined))
			{
				trace("parentMC[fieldName]");
				return null;
			}
			return parentMC[fieldName];
		}
		
		// 重播 product 動畫 
		private function ReplayProductMenuAnimation():void
		{
			for(var i: int=0 ; i < _allProducts.length;i++)
			{
				if(_allProducts[i].TopClip != null)
				{
					_allProducts[i].TopClip.gotoAndPlay(1) ;
				}
			}
		}
		
		public function HandleProducts(products: Array)
		{
			var clip : MovieClip;
			var productText : TextField;
			var imageClip: MovieClip ;
			
			for(var i: int=0 ; i < products.length;i++)
			{
				products[i].TopClip = _rootMovie["ButtonProduct_" + products[i].ID];
				products[i].InnerClip = _rootMovie["ButtonProduct_" + products[i].ID][INSTANCE_NAME_PRODUCT_MENU_CHLID_CLIP] ;
				if(products[i].InnerClip==null)
				{
					DebugMsg("amazing wrong products[i].InnerClip==null");
					continue;
				}

				productText = products[i].InnerClip["ProductName"];
				imageClip = new MovieClip();
				products[i].ImageClip = imageClip;
				products[i].InnerClip.addChild(products[i].ImageClip);
				_displayObjectList.push(products[i].ImageClip)
				products[i].IncPointClip = products[i].InnerClip["IncPointClip"];
				products[i].DecPointClip = products[i].InnerClip["DecPointClip"];
				products[i].PointField = products[i].InnerClip["PointField"];
				
				if( products[i].InnerClip.getChildIndex( products[i].IncPointClip) < products[i].InnerClip.getChildIndex( products[i].ImageClip) )
				{
					products[i].InnerClip.swapChildren(products[i].IncPointClip, products[i].ImageClip);
				}
				//products[i].Clip.setChildIndex(products[i].IncPointClip, 8);
				//products[i].Clip.setChildIndex(products[i].DecPointClip, 9);
				
				if(products[i].PurchasePoint > 0 ) //點數 + - 是不同圖片
				{
					products[i].IncPointClip.visible = true;
					products[i].DecPointClip.visible = false;
				}
				else
				{
					products[i].IncPointClip.visible = false;
					products[i].DecPointClip.visible = true;
				}
				
				products[i].PointField.text =  String( Math.abs(products[i].PurchasePoint) );
				products[i].PicLoader = GlobalMethod.LoadMovieClipImage( products[i].ImageClip, products[i].ImagePath, ProductImageLoaded);
				_displayObjectList.push(products[i].PicLoader);
				
				productText.text = products[i].Name;
				productText.wordWrap = true;
				var len: Number = products[i].Name.length;
				var adjustFormat: TextFormat = _defaultProductTextFormat;
				adjustFormat.align = TextFormatAlign.CENTER;
				
				if(len <= PRODUCT_NAME_DEFAULT_MAX_LENGTH)
				{
					//do nothing, no need adjust
				}
				else if(len <= PRODUCT_NAME_MINIMIZE_1_MAX_LENGTH)
				{
					adjustFormat.size = PRODUCT_NAME_MINIMIZE_1_FONT_SIZE;
					productText.setTextFormat(adjustFormat);
					productText.y = productText.y + 8;
				}
				else if(len <= PRODUCT_NAME_MINIMIZE_2_MAX_LENGTH)
				//else
				{
					adjustFormat.size = PRODUCT_NAME_MINIMIZE_2_FONT_SIZE;
					productText.setTextFormat(adjustFormat);
					productText.y = productText.y + 8;
				}
				else
				{
					adjustFormat.size = PRODUCT_NAME_MINIMIZE_3_FONT_SIZE;
					productText.autoSize = TextFieldAutoSize.CENTER;
					productText.wordWrap = true;
					productText.setTextFormat(adjustFormat);
				}
			}
			
			StartCoroutine(WaitingSetAlpha, EmptyEvent, WAITING_SET_ALPHA_INTERVAL, WAITING_SET_ALPHA_REPEAT) //server 重送代表刷新, 預設都可點擊, sh0606 太早設 alpha 會動畫 stop , 所以用 coroutine 等待
		}
		
		private function HandleProductDetail(remainSecond: int, productNO: int, productName: String, productPoint: int , imagePath: String, description: String):void
		{
			try
			{
				//var mc: MovieClip = RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP];
				var mc: MovieClip = RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP][INSTANCE_NAME_PURCHASE_PRUDUCT_INNER_CLIP];
				var pointText: String = "";
				if(productPoint > 0)
				{
					pointText = STR_0004 + String(Math.abs(productPoint)) + STR_0002; //送 x 點
				}
				else
				{
					pointText = STR_0003 + String(Math.abs(productPoint)) + STR_0002; //兑 x 點
				}
				
				// sh note,  如果 Label 的關鍵影格 與 instance 的關鍵影格 same frame, 可能會造成
				// Label 判斷為此關鍵影格, but instance 尚未實體化的 flash 問題
				(mc["Description"] as TextField).text = description;
				(mc["ProductName"] as TextField).text = productName;
				(mc["PointField"] as TextField).text = pointText;
				
				//特例 todo: 集中管理
				(mc["PurchaseSubmit"] as DisplayObject).addEventListener(MouseEvent.CLICK, (RootStage["Trigger"] as Function));
							
				GlobalMethod.LoadMovieClipImage( mc["MessageImage"], imagePath, OnProductDetailImageLoaded);
			}
			catch(error: Error)
			{
				DebugMsg("HandleProductDetail : " + error.message);
			}
		}
		
		//延遲設定 product 動畫的 alpha 
		private function StartWaitingResetAlpha(): void
		{
			//server 重送代表刷新, 預設都可點擊, sh0606 太早設 alpha 會動畫 stop , 所以用 coroutine 等待
			StartCoroutine(WaitingSetAlpha, EmptyEvent, WAITING_SET_ALPHA_INTERVAL, WAITING_SET_ALPHA_REPEAT) 
		}
		
		private function WaitingSetAlpha(e:Event): void
		{
			if( RootStage.currentLabel == LABEL_STAGE_PRODUCT_STOPPED )
			{
				SetAll_ClickableProduct(true);
				var stopThis: Timer = (e.target as Timer);
				stopThis.stop();
				stopThis = null;
			}
		}
		
		//延遲設定 product 動畫的 alpha 
		private function StartWaitingResetAlpha_Single(): void
		{
			//server 重送代表刷新, 預設都可點擊, sh0606 太早設 alpha 會動畫 stop , 所以用 coroutine 等待
			StartCoroutine(WaitingSetAlpha_Single, EmptyEvent, WAITING_SET_ALPHA_INTERVAL, WAITING_SET_ALPHA_REPEAT) 
		}
		
		private function WaitingSetAlpha_Single(e:Event): void
		{
			if( RootStage.currentLabel == LABEL_STAGE_PRODUCT_STOPPED )
			{
				for(var i:int=0 ; i < _productAlphaMark.length ;i++)
				{
					ClickableProduct(i+1, (_productAlphaMark[i] >= 1 ? false : true));
				}
				
				var stopThis: Timer = (e.target as Timer);
				stopThis.stop();
			}
		}
		
		private function EmptyEvent( e:Event): void{}
		
		//設置商品是否可點擊的效果, 注意!! alpha 不能再 MC 動畫中設置, MC frame 會 stop
		private function ClickableProduct(productNO: int, enable: Boolean):void
		{
			try
			{
				
				if(_allProducts.length < productNO)
				{
					DebugMsg("_allProducts.length < productNO : " + _allProducts.length + "    " + productNO);
					return;
				}
				
				if(RootStage.currentLabel != LABEL_STAGE_PRODUCT_STOPPED)
					return;
				
				if(enable)
				{
					_allProducts[ productNO-1 ].TopClip.alpha = PRODUCT_ENABLE_ALPHA;
				}
				else
				{
					_allProducts[ productNO-1 ].TopClip.alpha = PRODUCT_DISABLE_ALPHA;
				}
			}
			catch (error:Error) 
			{
				DebugMsg(error.message);
			}
		}
		
		//設置所有商品是否可點擊的效果, 注意!! alpha 不能再 MC 動畫中設置, MC frame 會 stop
		private function SetAll_ClickableProduct(enable: Boolean):void
		{
			try
			{			
				_productAlphaMark.length = 0;
				for(var i:int=0 ; i < _allProducts.length;i++)
				{
					_productAlphaMark.push( (enable==false ? 1 : 0) );
					ClickableProduct(i+1, enable);
				}
			}
			catch (error:Error) 
			{
				DebugMsg(error.message);
			}
		}
		
		//設置所有商品是否可見
		private function SetAll_ProductVisible(ifShow: Boolean):void
		{
			try
			{
				for(var i:int=0 ; i < _allProducts.length;i++)
				{
					_allProducts[i].TopClip.visible = ifShow;
					_allProducts[i].InnerClip.visible = ifShow;
				}
			}
			catch (error:Error) 
			{
				DebugMsg(error.message);
			}
		}
		
		private function RemoveProduct():void
		{
			trace("RemoveProduct");
			
			if(_allProducts.length > 0)
			{
				for(var j: int= 0 ; j < _allProducts.length; j++)
				{
					if(_allProducts[j].ImageClip != null)
					{
						_allProducts[j].ImageClip.removeChild(_allProducts[j].PicLoader);
						_allProducts[j].InnerClip.removeChild(_allProducts[j].ImageClip);
					}
				}
				
				DebugMsg("清除");
			}
			else
			{
				DebugMsg("沒清除 " + _allProducts.length);
			}
			_allProducts.length = 0;
		}
		
		private function LoadXML(path: String, onLoaded: Function)
		{
			DebugMsg("LoadXML  path : " + path);
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest(path));
			myLoader.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function OnConfigXMLLoaded(e:Event)
		{
			var myXML:XML;
			myXML = new XML(e.target.data);
			
			_moviePaths = new Array();
			_marqueeList = new Array();
			
			//廣告片路徑
			for(var i: int ; i < myXML.MoviePath.length() ;i++)
			{
				_moviePaths.push(myXML.MoviePath[i]);
			}
			
			//跑馬燈
			var allMarqueeWords: String = "";
			for(var j: int ; j < myXML.Marquee.length() ;j++)
			{
				_marqueeList.push(myXML.Marquee[j]);  //20130821 maybe marked
				allMarqueeWords = allMarqueeWords + myXML.Marquee[j] + MARQUEE_MOVE_SEPARATOR ;
			}
			
			var seconds: int = int(myXML.AdPlayTime);
						
			_adMovie = new VideoPlay(RootStage[INSTANCE_NAME_VIDEO_CLIP], 
									 RootStage[INSTANCE_NAME_ADIMAGE_CLIP], 1080, 650, seconds);
			_rootMovie.addEventListener(Event.ENTER_FRAME, _adMovie.Update);
			_adMovie.PlayVideo(_moviePaths);
			
			//maquee , 20130821 discard
			//var maqueeText: TextField =RootStage[INSTANCE_NAME_MARQUEE_ROOT][INSTANCE_NAME_MARQUEE_CHILD][INSTANCE_NAME_MARQUEE_TEXT];
			//maqueeText.text = _marqueeList[_marqueeList_Index];
			
			var maqueeText: TextField =RootStage[INSTANCE_NAME_MARQUEE_DYNAMIC_ROOT][INSTANCE_NAME_MARQUEE_DYNAMIC_CHILD][INSTANCE_NAME_MARQUEE_DYNAMIC_TEXT];
			maqueeText.autoSize = TextFieldAutoSize.LEFT; //自動拉寬 
			maqueeText.wordWrap = false; // 不換行
			maqueeText.text = allMarqueeWords;
			maqueeText.border = true;
		}

		// async 
		private function ProductImageLoaded(e:Event) 
		{
   			e.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, ProductImageLoaded);
			var image: Bitmap = Bitmap(e.target.loader.content);
			
			//調整圖片參數
			var w_h_ratio: Number = PRODUCT_IMAGE_H / PRODUCT_IMAGE_W;
			var newImageRatio: Number = image.height / image.width ;
			
			if(newImageRatio > w_h_ratio) //比例 相較預設尺吋, 偏高
			{
				image.height = PRODUCT_IMAGE_H;
				image.width = (PRODUCT_IMAGE_H / newImageRatio);
			}
			else //比例 相較預設尺吋, 偏寬
			{
				image.height = PRODUCT_IMAGE_W * newImageRatio;
				image.width = PRODUCT_IMAGE_W;	
			}
			
			//置中作業
			image.x = PRODUCT_IMAGE_X + (PRODUCT_IMAGE_W  - image.width)/2 ;
			image.y = PRODUCT_IMAGE_Y + (PRODUCT_IMAGE_H  - image.height)/2;

			//產品圖片讀取完畢
    		/// this.addChild(e.target.loader.content); // loaded content is stored in e.target.loader.content variable
		}
		
		// async 
		private function OnMessageImageLoaded(e:Event) 
		{
   			e.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, OnMessageImageLoaded);
			var image: Bitmap = Bitmap(e.target.loader.content);

//			//調整圖片參數
			var w_h_ratio: Number = MESSAGE_IMAGE_H / MESSAGE_IMAGE_W;
			var newImageRatio: Number = image.height / image.width ;
			
			if(newImageRatio > w_h_ratio) //比例 相較預設尺吋, 偏高
			{
				image.height = MESSAGE_IMAGE_H;
				image.width = (MESSAGE_IMAGE_H / newImageRatio);
			}
			else //比例 相較預設尺吋, 偏寬
			{
				image.height = MESSAGE_IMAGE_W * newImageRatio;
				image.width = MESSAGE_IMAGE_W;	
			}
			
			//置中作業
			image.x = (MESSAGE_IMAGE_W  - image.width)/2 ;
			image.y = (MESSAGE_IMAGE_H  - image.height)/2;
		}
		
		private function OnProductDetailImageLoaded(e:Event) 
		{
			e.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, OnProductDetailImageLoaded);
			var image: Bitmap = Bitmap(e.target.loader.content);

//			//調整圖片參數
			var w_h_ratio: Number = PRODUCT_DETAIL_IMAGE_H / PRODUCT_DETAIL_IMAGE_W;
			var newImageRatio: Number = image.height / image.width ;
			
			if(newImageRatio > w_h_ratio) //比例 相較預設尺吋, 偏高
			{
				image.height = PRODUCT_DETAIL_IMAGE_H;
				image.width = (PRODUCT_DETAIL_IMAGE_H / newImageRatio);
			}
			else //比例 相較預設尺吋, 偏寬
			{
				image.height = PRODUCT_DETAIL_IMAGE_W * newImageRatio;
				image.width = PRODUCT_DETAIL_IMAGE_W;	
			}
			
			//置中作業
			image.x = PRODUCT_DETAIL_IMAGE_X + (PRODUCT_DETAIL_IMAGE_W  - image.width)/2 ;
			image.y = PRODUCT_DETAIL_IMAGE_Y + (PRODUCT_DETAIL_IMAGE_H  - image.height)/2;
		}

		//---------------------------- Recieve From Csharp : 接收 csharp 參數起點 -----------------------------
		//<0100> 要求螢幕進入「待機頁面」(主畫面)
		public function DoCommand_0100(args:Array):void
		{
			//todo: 播放 Happy Go 動畫
			RootStage.gotoAndStop(1);
		}
		//<1100> 進入激活流程 - 要求螢幕顯示「是否擁有 Happy GO 卡」
		public function DoCommand_1100(args:Array):void
		{
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
				setTimeout(DoCommand_1100, 0, args); //由於 gotoAndPlay 不會馬上執行的 async 問題, 會造成物件存取不到, 因此 setTimeout
				return;
			}
			//ShowDefaultMessage("是否拥有 \n Happy GO卡？");
		}
		
		//<1200> 要求螢幕顯示 「Happy GO 卡申請」、「領取」選項
		public function DoCommand_1200(args:Array):void
		{
			
		}
		//<1300> 要求螢幕顯示 「兌換」、「領取」選項
		public function DoCommand_1300(args:Array):void
		{
			
		}
		//<1400> 要求螢幕顯示 - 提示「請在感應區刷Happy購卡或掃描動態消費碼」
		public function DoCommand_1400(args:Array):void
		{
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
				setTimeout(DoCommand_1400, 0, args); //由於 gotoAndPlay 不會馬上執行的 async 問題, 會造成物件存取不到, 因此 setTimeout
				return;
			}
			//ShowDefaultMessage("请在感应区刷Happy购卡\n或扫描动态消费码");
		}
		//<1500> 要求螢幕顯示 - 提示「您可使用的開心點數：xx。請選擇您要兌換的樣品」 //[1] 剩餘點數
		public function DoCommand_1500(args:Array):void
		{
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
				setTimeout(DoCommand_1500, 0, args); //由於 gotoAndPlay 不會馬上執行的 async 問題, 會造成物件存取不到, 因此 setTimeout
				return;
			}
			if(args.length < 2)
			{
				DebugMsg("DoCommand_1500 error !");
			}
			//ShowDefaultMessage("您可使用的开心点数："+ args[1] + "。请选择您要兑换的样品");
		}
		//<1800> 要求螢幕顯示 「卡片未激活，暫不能使用，請洽客服」
		public function DoCommand_1800(args:Array):void
		{
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
				setTimeout(DoCommand_1800, 0, args); //由於 gotoAndPlay 不會馬上執行的 async 問題, 會造成物件存取不到, 因此 setTimeout
				return;
			}
			//ShowDefaultMessage("卡片未激活，暫不能使用，請洽客服");
		}
		//<1900> 要求螢幕顯示 「動態消費碼已失效，請檢查動態消費碼是否超時或輸入錯誤，如有疑問，請洽客服4000218826」
		public function DoCommand_1900(args:Array):void
		{
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
				setTimeout(DoCommand_1900, 0, args); //由於 gotoAndPlay 不會馬上執行的 async 問題, 會造成物件存取不到, 因此 setTimeout
				return;
			}
			//ShowDefaultMessage("動態消費碼已失效，請檢查動態消費碼是否超時或輸入錯誤，如有疑問，請洽客服4000218826");			
		}
		public function DoCommand_2100(args:Array):void
		{
			
		}
		public function DoCommand_2200(args:Array):void
		{
			
		}
		public function DoCommand_2300(args:Array):void
		{
			
		}
		public function DoCommand_2400(args:Array):void
		{
			
		}
		public function DoCommand_2500(args:Array):void
		{
			
		}
		public function DoCommand_3100(args:Array):void
		{
			
		}
		public function DoCommand_3200(args:Array):void
		{
			
		}
		public function DoCommand_3300(args:Array):void
		{
			
		}
		public function DoCommand_5100(args:Array):void
		{
			
		}
		public function DoCommand_5200(args:Array):void
		{
			
		}
		public function DoCommand_5300(args:Array):void
		{
			
		}
		public function DoCommand_6100(args:Array):void
		{
			
		}
		public function DoCommand_6200(args:Array):void
		{
			
		}
		public function DoCommand_6300(args:Array):void
		{
			
		}
		public function DoCommand_6400(args:Array):void
		{
			
		}
		
		//		1.		7100:显示提示信息
		//命令格式	7100,保持时间(秒),头部字符,正文,尾部字符,图片路径,图片旋转角度（0~360）,标识(英文字符组成)
		//注：1. 旋转为逆时钟，角度为0不旋转，默认330度
		//2.如需要提前结束，再发一次保持时间为0的命令
		//3.时间到或用户返回，回复的数据格式为：7203,页面名，部件名，标识号
		public function DoCommand_7100(args:Array):void
		{
			if(args.length <= 1)
			{
				DebugMsg("DoCommand_7100 error. 1");
			}
			
			var remainSec: int;
			var top,midmsg, bottom: String;
			var imagePath: String;
			var rotate: int;
			var token: String; // 标识号
			
			remainSec = args.shift();
			top = args.shift();
			midmsg = args.shift();
			bottom = args.shift();
			imagePath = args.shift();
			rotate = args.shift();
			token = args.shift();
			
			On_Page_NoticeMessage();
			Page_NoticeMessage();
			
//			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
//				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
//			}

			ShowDefaultMessage(remainSec, top, midmsg, bottom, imagePath, rotate, token);
		}
		
		//7101,要设置的部件数量，部件名称，显示状态（显示0，隐藏1，凸显2）
		public function DoCommand_7101(args:Array):void
		{
			if(args.length <= 1)
			{
				DebugMsg("DoCommand_7101 error. 1");
			}
			
			var componentNum: int;
			var componentName: String;
			var behavior: int;
			
			componentNum = args.shift();
			for(var i:int = 0 ; i<componentNum ; i++)
			{
				componentName = args.shift();
				behavior = args.shift();
				
				if(!(componentName in RootStage) || (RootStage[componentName] == null) || (RootStage[componentName] == undefined))
				{
					DebugMsg( " Not Exist : " + componentName);
					continue;
				}
				switch(behavior)
				{
					case 0:
						(RootStage[componentName] as DisplayObject).visible = true;
						break;
					case 1:
						(RootStage[componentName] as DisplayObject).visible = false;
						trace("visible = true");
						break;
					break;
					case 2:
						(RootStage[componentName] as DisplayObject).visible = true; //todo: 還不知道凸顯怎麼坐
						break;
					default:
						//
				}
			}
		}
		
		//	命令格式	7104
		//注：无参数，发送后结束FLASH
		public function DoCommand_7104(args:Array):void
		{
			_destroying = true;
			_adMovie.StopVideo();
			_adMovie = null;
			RootStage.gotoAndStop(0);
			_selfDefPage == "";
			RootStage.Destroy();
		}
		
		//命令格式	7105
		//注：无参数，发送后复位FLASH，和刚加载FLASH时的效果一样
		public function DoCommand_7105(args:Array):void
		{
			_destroying = true;
			_adMovie.StopVideo();
			_adMovie = null;
			RootStage.gotoAndPlay(0);
			_selfDefPage == "";
			
			//remove all dynamic create MC
			var mc : DisplayObject = null;
			var parentMC : MovieClip = null;
			for(var i : int = 0 ; i < _displayObjectList.length; i++ )
			{
				mc = _displayObjectList[i];
				if(mc == null)
					continue;
				if(mc.parent == null)
					continue;
				parentMC = mc.parent as MovieClip;
				parentMC.removeChild(mc);
			}
			
			RootStage.Destroy();
			RootStage.Start();
		}
		
		//7501,页面倒计时长(秒)，商品总数量，商品编号(从1开始)，商品名称，点数，图片路径
		public function DoCommand_7501(args:Array):void
		{
			var timeCount: int ;
			var total: int;
			var productNO: int;
			
			if(args.length <= 2)
			{
				DebugMsg("DoCommand_7501 error. 1");
			}
			
			_idleSecondsCount = args.shift();
			
			trace(" _idleSecondsCount   " + _idleSecondsCount);
			total =  args.shift();
			
			RemoveProduct();

			for(var i: int=0; i < total ; i++)
			{
				var newData: ProductData = new ProductData();
				newData.ID = args.shift();
				newData.Name = args.shift();
				newData.PurchasePoint = args.shift();
				newData.ImagePath = args.shift();
				
				_allProducts.push(newData);
			}
			
			HandleProducts(_allProducts);
			On_Page_WaitingMain();
			Page_WaitingMain();
			
			_userLastOperateTime = Now; //假設使用者有操作過, 更新 idle 秒數
		}
		
		//		7502:商品是否可以点击 , 半透明顯示來區分( NOTICE: 變相代表用戶已經刷卡了!!)    只顯示 2 個按鈕 (查詢點數 + 返回)
		//		page3 click 後  順利刷卡~ 會收到
		//
		//		命令格式	7502,商品数量，商品编号(从1开始)，是否可以点击(0可点 1不可点)
		public function DoCommand_7502(args:Array):void
		{
			var productNum:int;
			var productNO: int;
			var clickable: int;
			
			productNum= args.shift();
			_productAlphaMark.length=0;
			for(var i:int=0 ; i < productNum ;i++)
			{
				productNO = args.shift();
				clickable = args.shift();
				
				_productAlphaMark.push(clickable);
				
				//ClickableProduct(productNO, (clickable >= 1 ? false : true));
			}
			
			On_Page_AuthorizedPurchase();
			Page_AuthorizedPurchase();
			
			_userLastOperateTime = Now; //假設使用者有操作過, 更新 idle 秒數
		}
		
		//7601,页面倒计时长(秒)，商品编号(从1开始)，商品名称，点数，图片路径，说明文字
		//	7601,30,3,方便面,-5,c:\tu\fbm.png,方便面又称泡面、杯面、快熟面、速食面、即食面
		public function DoCommand_7601(args:Array):void
		{
			On_Page_PurchaseProductDetail();
			Page_PurchaseProductDetail();
			
//			var remainSecond:int = args.shift();
//			var productNO: int = args.shift();
//			var productName: String = args.shift();
//			var productPoint: int = args.shift();
//			var imagePath: String = args.shift();
//			var description: String = args.shift();
			
			_currentProductDetail.RemainSeconds = args.shift();
			_currentProductDetail.ID = args.shift();
			_currentProductDetail.Name = args.shift();
			_currentProductDetail.PurchasePoint = args.shift();
			_currentProductDetail.ImagePath = args.shift();
			_currentProductDetail.Description = args.shift();
			
			_productDetailResetFlag = true;
			//HandleProductDetail(remainSecond, productNO, productName, productPoint, imagePath, description);
			
			_userLastOperateTime = Now; //假設使用者有操作過, 更新 idle 秒數
		}
		
		//7701:商品信息
		//命令格式	7701,页面倒计时长(秒)，剩余点数
		public function DoCommand_7710(args:Array):void
		{
			if(args.length <= 1)
			{
				DebugMsg("DoCommand_7710 error. 1");
			}
			
			var keepSec: int;
			var remainPoint: int;
			
			keepSec = args.shift();
			remainPoint = args.shift();
			
			if(RootStage.currentLabel!=WPFStation.LABEL_STAGE_2){
				RootStage.gotoAndPlay(WPFStation.LABEL_STAGE_2);
			}
			var msg:String = STR_0001 + remainPoint + STR_0002;
			ShowDefaultMessage(keepSec, "", msg, "", "", 0, TOKEN_NAME_POINT_CHECK);
			
			_userLastOperateTime = Now; //假設使用者有操作過, 更新 idle 秒數
		}
		
		//7103:		加载页面  显示出货动画提示
		public function DoCommand_7103(args:Array):void
		{
			var remainSec = args.shift();
			
			if(remainSec == 0)
			{
				UITrigger(null, INSTANCE_NAME_RETURN_BUTTON);
				return;
			}
			
			_userExitExportingPageTime = Now;
			_userExitExportingPageTime.setSeconds(_userExitExportingPageTime.getSeconds() + (int(remainSec)));
			
			On_Page_ExportingCard();
			Page_ExportingCard();
		}
		
		//7901:		加载页面
		public function DoCommand_7901(args:Array):void
		{
			var remainSec = args.shift();
			
			if(remainSec == 0)
			{
				UITrigger(null, INSTANCE_NAME_RETURN_BUTTON);
				return;
			}
			
			_userExitExportingPageTime = Now;
			_userExitExportingPageTime.setSeconds(_userExitExportingPageTime.getSeconds() + (int(remainSec)));
			
			On_Page_ExportingCard();
			Page_ExportingCard();
		}
	
		//7801: 進入申请卡片页面
		//7801		加载页面
		//命令格式	7801,页面倒计时长(秒)，标识号(如：mobile),提示信息，数据长度
		public function DoCommand_7801(args:Array):void
		{
			_currentCodeInputSeconds = args.shift();
			_currentCodeInputToken = args.shift();
			_currentCodeInputTitle = args.shift();
			_currentCodeMaxChar = args.shift();
			
			On_Page_MobileCodeInput();
			Page_MobileCodeInput();
		}
		
		public function DoCommand_8100(args:Array):void
		{
			
		}
		public function DoCommand_8200(args:Array):void
		{
			
		}
		public function DoCommand_9100(args:Array):void
		{
		}
		//---------------------------- Recieve From Csharp End-----------------------------
		
		//---------------------------- Ready Send to Csharp-----------------------------
		// 隱藏模式進入管理介面, 暫時關閉, server 處理 201306.4
		//public function ReadySendCommand_9999(args:Array):Boolean
		public function ReadySendCommand_0000(args:Array):Boolean
		{			
			var evtName: String = args[0];
			if((evtName == HIDDEN_ADMIN_SEQUENCE[_hidden_admin_index]) && (_hidden_admin_index == HIDDEN_ADMIN_SEQUENCE.length-1))
			{
				_hidden_admin_index = 0;
				trace("_hidden_admin_index : " + _hidden_admin_index);
				return true;
			}
			else if(evtName == HIDDEN_ADMIN_SEQUENCE[_hidden_admin_index])
			{
				_hidden_admin_index++;
				trace("_hidden_admin_index : " + _hidden_admin_index);
				return false;
			}
			else
			{
				_hidden_admin_index = 0;
				trace("_hidden_admin_index : " + _hidden_admin_index);
				return false;
			}
		}
		
		//全螢幕遮罩,不送 server
		public function ReadySendCommand_10001(args:Array):Boolean
		{			
			var evtName: String = args[0];
			
			if(_selfDefPage == SELF_DEF_PAGE_WAITING_AUTH)
			{
				if(_userInputtedCode != "") //使用者已經輸入過內容,強制留在頁面了
				{
					trace("使用者已經輸入過內容,強制留在頁面了");
					_rootStage.focus = _purchaseCodeInput; //使用者點到空白處, 幫他重設 focus
					return false; // keep 在同頁面, sev 不需要知道
				}

				On_Page_WaitingMain();
				Page_WaitingMain();
			}
			else if(SELF_DEF_PAGE_MAIN)
			{
				On_Page_WaitingUserAuthorize();
				Page_WaitingUserAuthorize();
			}
			
			return false;
		}
		
		//返回, 依據頁面不同可能要給 server
		public function ReadySendCommand_10002(args:Array):Boolean
		{			
			var evtName: String = args[0];
			var needSend: Boolean = true;
			if(_selfDefPage == SELF_DEF_PAGE_WAITING_AUTH) //等待用戶感應, 刷卡
			{
				needSend = true;
				//20130623 改為不主動返回, 讓 server 決定要回到哪一個頁面
				//On_Page_WaitingMain();
				//Page_WaitingMain();
			}
			else if(_selfDefPage == SELF_DEF_PAGE_NOTICE) //訊息框中 return , server 不用知道, 自己回主頁面就好, 弱頁面是返回上一頁
			{
				if(_messageTimer != null) //將訊息框倒數計時的 timer 關掉
				{
					_messageTimer.stop();
				}
				HideDefaultMessage(null);
			}
			else if(_selfDefPage == SELF_DEF_PAGE_MAIN) // 主頁面中又點 return , 要送, ser 要求, 原因不明
			{
				needSend = true;
				//20130623 改為不主動返回, 讓 server 決定要回到哪一個頁面
				//On_Page_WaitingMain();
				//Page_WaitingMain();
			}
			else if(_selfDefPage == SELF_DEF_PAGE_PURCHASE_PRODUCT_DETAIL) // server 要求發送後不要跳轉到 main
			{
				needSend = true;
			}
			else
			{
				needSend = true;
				//20130623 改為不主動返回, 讓 server 決定要回到哪一個頁面
				//On_Page_WaitingMain();
				//Page_WaitingMain();
			}
			
			return needSend;
		}
		//---------------------------- Ready Send to Csharp End -----------------------------
		
		public function StartCoroutine( onTick:Function, onComplete:Function, interval: int, repTimes: int): Timer
		{
			var intervalTimer:Timer = new Timer(interval,repTimes);
			intervalTimer.addEventListener(TimerEvent.TIMER, onTick);
			intervalTimer.addEventListener(TimerEvent.TIMER_COMPLETE , onComplete);
			intervalTimer.start();
			return intervalTimer;
		}
		
		//隐藏了“申请卡片”和“领取卡片”这两个按钮的软件（图标和功能都隐藏）版本
		public function UpdateNoCard():void
		{
			if(IS_NO_CARD_VERSION == true)
			{
				if(!("ButtonReceiveCard" in RootStage) || (RootStage["ButtonReceiveCard"] == null) || (RootStage["ButtonReceiveCard"] == undefined)){}
				else
				{
					RootStage["ButtonReceiveCard"].visible = false;
				}

				if(!("ButtonRequestCard" in RootStage) || (RootStage["ButtonRequestCard"] == null) || (RootStage["ButtonRequestCard"] == undefined)){}
				else
				{
					RootStage["ButtonRequestCard"].visible = false;
				}
			}
		}
		
		public function UpdateProductDetail():void
		{
			if(_productDetailResetFlag == false)
				return;
				
			var mc: MovieClip = RootStage[INSTANCE_NAME_PURCHASE_PRUDUCT_CLIP];
			
			if(mc.currentLabel != LABEL_MESSAGE_SHOW)//防呆
			{
				mc.gotoAndPlay(LABEL_MESSAGE_SHOW);
				return;
			}

			var mcInner: MovieClip = mc[INSTANCE_NAME_PURCHASE_PRUDUCT_INNER_CLIP];

			if(mcInner.currentLabel != LABEL_PRODUCT_DETAIL_STOP)
				return;
			
			HandleProductDetail(_currentProductDetail.RemainSeconds, _currentProductDetail.ID, 
								_currentProductDetail.Name, _currentProductDetail.PurchasePoint,
								_currentProductDetail.ImagePath, _currentProductDetail.Description);
			
			_productDetailResetFlag = false;
		}
		
		// 跑馬燈相關 Update, 20130821 words 從補間動畫, 改為動態設定 + update 移動
		public function UpdateMarquee():void
		{
			//20130821 marked
			//var maqueeClip: MovieClip = RootStage[INSTANCE_NAME_MARQUEE_ROOT];
			//if(maqueeClip.currentLabel != LABEL_MARQUEE_END)
				//return;
			//var maqueeText: TextField =maqueeClip[INSTANCE_NAME_MARQUEE_CHILD][INSTANCE_NAME_MARQUEE_TEXT];
			//_marqueeList_Index = (_marqueeList_Index + 1) % _marqueeList.length;
			//maqueeText.text =  _marqueeList[_marqueeList_Index];
			
			var maqueeClip: MovieClip = RootStage[INSTANCE_NAME_MARQUEE_DYNAMIC_ROOT][INSTANCE_NAME_MARQUEE_DYNAMIC_CHILD];
			
			if(Math.abs(maqueeClip.x) >= maqueeClip.width) //超出邊界, 所有words撥放完畢, 需重置
			{
				maqueeClip.x = MARQUEE_ENTRANCE_X;
			}
			maqueeClip.x = maqueeClip.x - MARQUEE_MOVE_SPEED;
		}
		
		// Everything in here will be called Every frame.
		public function Update(e:Event):void
		{
			//一些該頁面不變的規則才能放在此
			switch(_selfDefPage)
			{
				case SELF_DEF_PAGE_MAIN:
					Page_WaitingMain();
					break;
				case SELF_DEF_PAGE_WAITING_AUTH:
					Page_WaitingUserAuthorize();
					break;
				case SELF_DEF_PAGE_AUTHORIZED_PURCHASE:
					Page_AuthorizedPurchase();
					break;
				case SELF_DEF_PAGE_NOTICE:
					Page_NoticeMessage();
					break;
				case SELF_DEF_PAGE_PURCHASE_PRODUCT_DETAIL:
					Page_PurchaseProductDetail();
					break;
				case SELF_DEF_PAGE_EXPORTING_CARD:
					Page_ExportingCard();
					break;
				case SELF_DEF_PAGE_MOBILE_CODE_INPUT:
					Page_MobileCodeInput();
					break;
				default:
					Page_NotInitialize();
			}
			CheckUserIdle();
			UpdateMarquee();
			UpdateProductDetail();
			UpdateNoCard();
		}
	}
}
