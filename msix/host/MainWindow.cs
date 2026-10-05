using System;
using System.IO;
using System.Windows;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.Wpf;

namespace AcompanhaDigital
{
    public class MainWindow : Window
    {
        private readonly WebView2 webView;

        public MainWindow()
        {
            Title = "Acompanha Digital";
            Width = 1280;
            Height = 720;
            MinWidth = 360;
            MinHeight = 640;

            webView = new WebView2
            {
                HorizontalAlignment = HorizontalAlignment.Stretch,
                VerticalAlignment = VerticalAlignment.Stretch
            };
            Content = webView;

            Loaded += OnLoaded;
        }

        private async void OnLoaded(object sender, RoutedEventArgs e)
        {
            try
            {
                await webView.EnsureCoreWebView2Async(null);

                CoreWebView2Settings s = webView.CoreWebView2.Settings;
                s.AreDefaultContextMenusEnabled = false;
                s.AreDevToolsEnabled = false;
                s.IsStatusBarEnabled = false;
                s.IsZoomControlEnabled = false;

                string wwwRoot = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "www");
                webView.CoreWebView2.SetVirtualHostNameToFolderMapping(
                    "app.acompanha.local",
                    wwwRoot,
                    CoreWebView2HostResourceAccessKind.Allow);

                webView.CoreWebView2.Navigate("https://app.acompanha.local/index.html");
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Falha ao iniciar o aplicativo:\n\n" + ex.Message,
                    "Acompanha Digital",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }
    }
}
