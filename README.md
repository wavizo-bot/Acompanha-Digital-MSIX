# Acompanha Digital — Pacote MSIX (Microsoft Store)

Repositório de apoio à submissão do aplicativo **Acompanha Digital** à Microsoft Store.

## Identidade no Partner Center

| Campo | Valor |
| --- | --- |
| Nome do pacote (Identity/Name) | `wavizo.AcompanhaDigital` |
| Publisher | `CN=57BB464E-553F-45B6-A4ED-B253157408EB` |
| Publisher Display Name | `wavizo` |
| Package Family Name (PFN) | `wavizo.AcompanhaDigital_c5p81jb0en0bm` |
| Package SID | `S-1-15-2-2762803657-4209078906-3405325233-1722170166-4009831219-4167832670-2166587445` |
| ID da Store | `9NM4GZ6VH86N` |
| Versão do pacote | `1.0.11.0` (app 1.0.11, service worker `acs-digital-v15-miab-etiquetas`) |
| Arquitetura | x64 (Windows.Desktop, MinVersion 10.0.17763.0) |

## Política de privacidade (URL pública)

- **GitHub Pages:** https://wavizo-bot.github.io/Acompanha-Digital-MSIX/politica-privacidade.html
- **Raw (fallback):** https://raw.githubusercontent.com/wavizo-bot/Acompanha-Digital-MSIX/main/politica-privacidade.html

Use uma dessas URLs no campo “Política de privacidade” do Partner Center.

## Conteúdo

| Caminho | Descrição |
| --- | --- |
| `politica-privacidade.html` | Política de privacidade pública (LGPD), versão 1.0.11 |
| `msix/Package.appxmanifest` | Manifesto do pacote (identidade, versão, capacidades, logos) |
| `msix/host/` | Host Win32: .NET Framework 4.7.2 (WPF) + WebView2, sem Visual Studio |
| `msix/www/` | Aplicativo web empacotado (mesmo conteúdo de `www/` do app Android) |
| `msix/assets/` | Logos exigidos pelo Store (StoreLogo, tiles, splash) |
| `msix/build-msix.ps1` | Script de build completo: compilar → empacotar → assinar → verificar |
| `msix/dist/screenshots/` | 6 capturas de tela 1366×768 prontas para a listagem |
| `1024x500.jpg` | Gráfico de destaque (feature graphic) |
| `store-assets/` | Ícones adaptativos (36–512 px), ícone único e splash |
| `store_listing_ms.txt` | Textos prontos para o Partner Center (nome, resumo, descrição, novidades) |
| `store_listing_text.txt` | Textos da Google Play (referência Android) |
| `justificativa.txt` | Respostas do questionário de aceite/assinatura do produto |
| `COMO-INSTALAR.md` | Instruções do build Android/Capacitor (referência) |

## Build do pacote (sem Visual Studio)

Pré-requisitos: **.NET SDK 8** (`dotnet`, https://dot.net) e **Windows 10/11 SDK**
(`makeappx.exe` e `signtool.exe`).

```powershell
powershell -ExecutionPolicy Bypass -File msix\build-msix.ps1
```

O script:

1. compila `msix/host` (net472, `Platform=x64`);
2. monta o layout (manifesto + `www/` + binários + `assets/`);
3. gera `msix/dist/wavizo.AcompanhaDigital_<versão>_x64.msix` (`makeappx`);
4. assina com o certificado `CN=57BB464E-553F-45B6-A4ED-B253157408EB`
   (thumbprint `93F250E24074A804684F9E390D36DBB662DF27AF`, válido até 02/10/2029);
5. verifica a assinatura (`signtool verify /pa`).

### Sobre o host

O host é um aplicativo WPF mínimo (.NET Framework 4.7.2 (ou 4.8) já presentes no
Windows, portanto sem dependência de runtime) com uma única `WebView2`. Ele
serve o app pelo host virtual `https://app.acompanha.local/`, o que mantém
**IndexedDB e Service Worker funcionando dentro do pacote** (arquivos `file://`
não têm essas APIs). Nenhum recurso do sistema é solicitado além de
`runFullTrust` e `internetClient`.

## Teste local (sideload)

```powershell
Add-AppxPackage -Path msix\dist\wavizo.AcompanhaDigital_1.0.11.0_x64.msix
# depois do teste:
Get-AppxPackage wavizo.AcompanhaDigital | Remove-AppxPackage
```

## Submissão no Partner Center

1. **Packages → + Submission** (ou nova submissão) para o app `9NM4GZ6VH86N`.
2. Enviar o `.msix` de `msix/dist/` (assinado; o Store re-assina com o certificado da loja).
3. Preencher os campos com os textos de **`store_listing_ms.txt`**
   (nome, resumo ≤200, descrição, “O que há de novo”).
4. Anexar as **6 capturas** de `msix/dist/screenshots/` (mínimo 1) e, opcionalmente,
   o gráfico `1024x500.jpg`.
5. Colar a **URL da política de privacidade** (GitHub Pages acima).
6. Responder o questionário de aceite com **`justificativa.txt`**
   (`runFullTrust`, `internetClient`, OCR embutido, IndexedDB local, WebView2;
   o manifesto **não** declara protocolos http/https).
7. Categorias sugeridas: Produtividade / Utilitários — preço: grátis — idioma: pt-BR.

## Notas

- Aplicativo independente, não governamental. 100% offline; dados apenas no
  computador (IndexedDB local do WebView2).
- Sem conta, servidor, analytics, anúncios, compras ou SDKs de terceiros.
- Contato do desenvolvedor: mmr05@hotmail.com
