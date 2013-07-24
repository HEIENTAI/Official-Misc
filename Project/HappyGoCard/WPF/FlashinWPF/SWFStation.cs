using System;
using System.IO;
using System.Xml;
using System.ComponentModel;
using System.Data;
//using System.Drawing;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using AxShockwaveFlashObjects;

namespace FlashinWPF
{
    /// 處理單一指令的 method 委派。
    public delegate void CommandHandleMethod(XmlNodeList argumentNodes);

    /// <summary>
    /// 與 Flash 溝通窗口, handle send and recieve for shock wave flash
    /// Author : Swings Huang
    /// Last modified: 2013.03.21
    /// </summary>
    public class SWFStation
    {
        private const string AS_COMMAND_SPLITTER = ";" ; //指令分隔符號
        private const string AS_RECIEVE_METHOD_NAME = "WPFCommand"; //actionscript 端用來接收訊息的 method 之命名
        private AxShockwaveFlash _swfPlayer;
        private Dictionary<int, CommandHandleMethod> _commandMethods = null; // 以指令編號為 key 的處理 method 集合

        public SWFStation()
        {
            _swfPlayer = new AxShockwaveFlashObjects.AxShockwaveFlash(); //实例化 axShockwaveFlash
            _commandMethods = new Dictionary<int,CommandHandleMethod>();
            SetAllCommandMethod();
        }

        /// <summary>
        /// 設置所有[處理Flash傳來參數]的 method
        /// Notice: 要新增一種處理 Flash ActionScript 指令的 method, 請在此擴充
        /// </summary>
        public void SetAllCommandMethod()
        {
            _commandMethods.Add(1100, ASCommand_1100);
            _commandMethods.Add(2000, ASCommand_2000);
            _commandMethods.Add(2100, ASCommand_2100);
            _commandMethods.Add(3000, ASCommand_3000);
        }

        /// <summary>
        /// 載入 flash file
        /// </summary>
        public void LoadMovie(string swfPath)
        {
            if (_swfPlayer == null)
                return;
            _swfPlayer.Movie = swfPath;

            // flash init
            //_swfPlayer.Dock = System.Windows.Forms.DockStyle.Fill;
            //_swfPlayer.Enabled = true;
            //_swfPlayer.Location = new System.Drawing.Point(0, 0);
            //_swfPlayer.Name = "axShockwaveFlash1";
            //_swfPlayer.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axShockwaveFlash1.OcxState")));
            //_swfPlayer.Size = new System.Drawing.Size(600, 500);
            _swfPlayer.TabIndex = 0;
            _swfPlayer.FlashCall += new _IShockwaveFlashEvents_FlashCallEventHandler(this.RecieveCallEvent);
            //_swfPlayer.Play();

            //Send("test 00123");

            //_swfPlayer.Controls.Remove(_swfPlayer);
        }

        public AxShockwaveFlash Player
        {
            get { return _swfPlayer; }
        }

        private void Send(string command)
        {
            // name - Flash function
            // arguments - function parameters
            _swfPlayer.CallFunction("<invoke name=\"" + AS_RECIEVE_METHOD_NAME  + "\" returntype=\"xml\">" +
                                    "<arguments><string>" + command + "</string></arguments></invoke>");
        }

        public void SendASCommand(int commandNumber, List<String> arguments)
        {
            String mergedCommad = String.Format("{0:0000}", commandNumber) ;
            String argStr = String.Empty;
            for (int i = 0; i < arguments.Count; i++)
            {
                argStr = argStr + AS_COMMAND_SPLITTER + arguments[i];
            }

            mergedCommad = mergedCommad + argStr;
            Send(mergedCommad);
        }

        /// 寫入一筆除錯用 LOG
        public void WriteDebugLog(string message)
        {
            string fileName = string.Format("WPFDebug_{0}{1}{2}.txt", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            //if (File.Exists(fileName))
            //    File.Delete(fileName);

            using (StreamWriter outfile = new StreamWriter(fileName, true, Encoding.Unicode))
            {
                outfile.Write(message + string.Format("    {0}.{1}.{2}_{3}:{4}:{5}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                                        DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second) + "\r\n");
            }
        }

        /// <summary>
        /// Reciving message from flash
        /// </summary>
        /// <param name="message"></param>
        private void RecieveCallEvent(object sender, _IShockwaveFlashEvents_FlashCallEvent e)
        {
            try
            {
                // message is in xml format so we need to parse it
                XmlDocument document = new XmlDocument();
                document.LoadXml(e.request);
                // get attributes to see which command flash is trying to call
                XmlAttributeCollection attributes = document.FirstChild.Attributes;
                String command = attributes.Item(0).InnerText;
                // get parameters
                XmlNodeList arguments = document.GetElementsByTagName("arguments"); //document.Get
                if (arguments == null)
                    return;
                if (arguments.Count == 0)
                    return;
                XmlNodeList list = arguments.Item(0).ChildNodes;

                // Interpret command
                switch (command)
                {
                    case "ASCommand": //Action Script command from Flash
                        HandleASCommand(list);
                        break;
                    case "Some_Other_Command": 
                        break;
                }

            }
            catch (Exception except)
            {
                Console.WriteLine(except.Message);
                WriteDebugLog(except.Message);
            }
        }

        //------------------  ActionScript Command Section ---------------------
        /// <summary>
        /// ActionScript 指令函式進入點
        /// </summary>
        private void HandleASCommand(XmlNodeList node)
        {
            try
            {
                if (node == null)
                    return;

                //20130610, 指令和參數改為用 SEPARATOR 合併 7100,AAA,BBB
                //if (node.Count <= 1)
                //    return;
                //int commandNumber = Convert.ToInt32(node[0].InnerText); //取得指令編號

                string cmd = node[0].InnerText; //取得指令編號
                string[] arguments = cmd.Split(',');
                int commandNumber = Convert.ToInt32(arguments[0]);
                
                if(_commandMethods==null)
                {
                    Console.WriteLine("commandMethods is null");
                    return;
                }

                if(!_commandMethods.ContainsKey(commandNumber))
                {
                    WriteDebugLog(string.Format( "Command Number {0} Not defined !", commandNumber));
                    return;
                }

                _commandMethods[commandNumber].Invoke(node); //呼叫處理函式
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        private void ASCommand_1100(XmlNodeList node)
        {

        }

        private void ASCommand_2000(XmlNodeList node)
        {

        }

        private void ASCommand_2100(XmlNodeList node)
        {

        }

        private void ASCommand_3000(XmlNodeList node)
        {

        }
        //------------------  ActionScript Command Section End------------------        
    }
}