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
        await webView.EnsureCoreWebView2Async();
        webView.CoreWebView2.Settings.AreDefaultContextMenusEnabled = false;
        webView.CoreWebView2.Settings.AreDevToolsEnabled = false;
        webView.CoreWebView2.Settings.IsStatusBarEnabled = false;
        webView.CoreWebView2.Settings.IsZoomControlEnabled = false;

        // Serve arquivos locais via host virtual https:// (necessario p/ IndexedDB + Service Worker).
        var wwwRoot = System.IO.Path.Combine(AppContext.BaseDirectory, "www");
        webView.CoreWebView2.SetVirtualHostNameToFolderMapping(
            "app.acompanha.local", wwwRoot,
            Microsoft.Web.WebView2.Core.CoreWebView2HostResourceAccessKind.Allow);
        webView.CoreWebView2.Navigate("https://app.acompanha.local/index.html");
    }
}