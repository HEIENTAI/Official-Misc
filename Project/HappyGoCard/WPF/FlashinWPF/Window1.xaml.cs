using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Shapes;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Forms.Integration; //20130611 add

//Ambivalent define
using Path = System.IO.Path;


namespace FlashinWPF
{
    /// <summary>
    /// Interaction logic for Window1.xaml implemented by Jijia Huang, jijiatc@hotmail.com
    /// </summary>

    public partial class Window1 : Window
    {
        public SWFStation _swf = null;
        public WindowsFormsHost _host; //20130611 add

        public Window1()
        {
            InitializeComponent();
        }

        /// Loaded method, Defined in xaml : 
        private void WindowLoaded(object sender, RoutedEventArgs e)
        {
            // 创建 host 对象
            //System.Windows.Forms.Integration.WindowsFormsHost host = new System.Windows.Forms.Integration.WindowsFormsHost(); //20130611 marked
            _host = new WindowsFormsHost(); //20130611 add

            _swf = new SWFStation();
            _host.Child = _swf.Player; // 装载.Player

            // 将 host 对象嵌入FlashGrid
            this.FlashGrid.Children.Add(_host);

            // 设置 .swf 文件相对路径
            string swfPath = System.Environment.CurrentDirectory + Path.AltDirectorySeparatorChar + GlobalVar.MAINSWF_FILE;
            _swf.LoadMovie(swfPath);
        }

        /// <summary>
        /// DEBUG 面板送出訊息給 Flash
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button_debug_Click(object sender, RoutedEventArgs e)
        {
            if(_swf == null)
                return;

            List<String> args = new List<string>();
            //args.Add(text_debug_commandnum.Text); //指令編號
            args.Add(text_debug_arg.Text); //參數1


            _swf.Player.Stop();
            _swf.Player.StopPlay();

            //this.Controls.Remove();
            //this.Controls.Remove(axFlash);

            _swf.SendASCommand(Convert.ToInt32(text_debug_commandnum.Text), args);
            _swf.Player.Stop();

            this.FlashGrid.Children.Remove(_host); //20130611 add test
        }
    }
}
