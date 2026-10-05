# Acompanha Digital — Pacote MSIX (Microsoft Store)

Repo de suporte a submissao v1.0.11 (`wavizo.AcompanhaDigital`, Store ID `9NM4GZ6VH86N`).

## Privacidade (URL publica p/ Partner Center)

- Pages: https://wavizo-bot.github.io/Acompanha-Digital-MSIX/politica-privacidade.html
- Raw: https://raw.githubusercontent.com/wavizo-bot/Acompanha-Digital-MSIX/main/politica-privacidade.html

## Conteudo

- `politica-privacidade.html` — politica LGPD publica
- `msix/` — build-msix.ps1, Package.appxmanifest, assets, www
- `1024x500.jpg` — grafico destaque 1024x500
- `store-assets/` — icones 36-512 + splash
- `store_listing_text.txt` — textos da listagem PT-BR
- `COMO-INSTALAR.md` — build + WACK + Partner Center

## Build (VS2022 + WinAppSDK 1.5+)

powershell msix/build-msix.ps1
Assinar MSIX (Partner Center) - Rodar WACK - Subir no Partner Center.

App offline, sem conta/servidor/ads. Contato: mmr05@hotmail.com

