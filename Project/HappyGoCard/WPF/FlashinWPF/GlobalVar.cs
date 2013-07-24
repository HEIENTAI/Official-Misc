using System;
using System.Collections.Generic;
using System.Text;

/// 此專案解決兩個問題:
/// 1. 在 C# WPF 環境中嵌入 SWF file ( embaded .swf file in WPF project)
/// 2. 讓 Flash 與 C# 專案能夠互相傳遞參數溝通 ( pass arguments between Flash actionscript App and WPF csharp App)

namespace FlashinWPF
{
    /// <summary>
    /// 此類別存放全局變量
    /// </summary>
    class GlobalVar
    {
        //public const string MAINSWF_FILE = "EITest.swf"; //sample
        //public const string MAINSWF_FILE = "sample.swf"; //
        public const string MAINSWF_FILE = "page_all_v3.swf";
    }
}
