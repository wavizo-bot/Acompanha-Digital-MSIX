# Acompanha Digital — Pacote MSIX (Microsoft Store)

Repositório de suporte à submissão do aplicativo **Acompanha Digital** (pacote `app.acompanha.digital`, v1.0.2) à Microsoft Store.

## Política de Privacidade (URL pública)

- **Página (GitHub Pages):** https://wavizo-bot.github.io/Acompanha-Digital-MSIX/politica-privacidade.html
- **Raw (fallback):** https://raw.githubusercontent.com/wavizo-bot/Acompanha-Digital-MSIX/main/politica-privacidade.html

Use uma dessas URLs no campo "Política de privacidade" do Partner Center.

## Conteúdo

| Caminho | Descrição |
| --- | --- |
| `politica-privacidade.html` | Política de privacidade pública (LGPD) |
| `msix/` | Projeto MSIX: `build-msix.ps1`, `Package.appxmanifest`, `assets/` (logos) e `www/` (app web empacotado) |
| `1024x500.jpg` | Gráfico de destaque da loja (1024x500) |
| `store-assets/` | Ícones adaptativos (36–512px), ícone único e splash |
| `store_listing_text.txt` | Texto pronto para a listagem na loja |
| `COMO-INSTALAR.md` | Instruções de instalação |

## Próximos passos da submissão

1. Executar `msix/build-msix.ps1` em máquina com Visual Studio 2022 + Windows App SDK 1.5+
2. Assinar o MSIX com certificado da loja (Partner Center)
3. Rodar o Windows App Certification Kit (WACK)
4. Publicar `politica-privacidade.html` em URL pública (este repositório / GitHub Pages)
5. Anexar screenshots (mín. 2, ideal 6) e o gráfico de destaque `1024x500.jpg`

## Notas

- Aplicativo independente, não governamental. 100% offline; dados apenas no aparelho (IndexedDB/local).
- Sem conta, servidor, analytics, anúncios, compras ou SDKs de terceiros.
- Contato do desenvolvedor: mmr05@hotmail.com
