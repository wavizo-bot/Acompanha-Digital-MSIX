using Microsoft.UI.Xaml;
using Microsoft.Web.WebView2.Core;

namespace AcompanhaDigital;

public sealed partial class MainWindow : Window
{
    public MainWindow()
    {
        this.InitializeComponent();
        InitializeWebView();
    }

    private async void InitializeWebView()
    {
        await webView.EnsureCoreWebView2Async(null);
        webView.CoreWebView2.Settings.AreDefaultContextMenusEnabled = false;
        webView.CoreWebView2.Settings.AreDevToolsEnabled = false;
        webView.CoreWebView2.Settings.IsStatusBarEnabled = false;
        webView.CoreWebView2.Settings.IsZoomControlEnabled = false;
        
        // Navigate to local PWA files
        var localPath = System.IO.Path.Combine(AppContext.BaseDirectory, "www", "index.html");
        webView.CoreWebView2.Navigate($"file:///{localPath.Replace("\\", "/")}");
    }
}