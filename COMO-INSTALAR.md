# ACS Digital no Android Studio (Capacitor)

Projeto Capacitor pronto para o app **ACS Digital** (arquivo único, 100% offline).
Não há bundler/Vite: o `pnpm run build` apenas copia `ACS-Digital.html` para `www/index.html`.

## Requisitos
- Node 18+ e pnpm
- Android Studio recente (com SDK 35 e JDK 17 — as versões atuais já trazem)
- Um aparelho Android via USB (com "Depuração USB" ativa) ou um emulador

## Primeira vez (neste diretório)

```bash
pnpm install
pnpm approve-builds                                  # aprove os scripts das deps do Capacitor
pnpm run build                                       # copia ACS-Digital.html -> www/index.html
npx cap add android                                  # UMA ÚNICA VEZ: cria a pasta android/
npx @capacitor/assets generate --android             # gera ícones e splash com a arte ACS
npx cap sync android
npx cap open android
```

No Android Studio: aguarde o Gradle Sync terminar, selecione o aparelho/emulador e clique em **Run ▶**.

Para gerar o APK de distribuição: **Build → Build Bundle(s)/APK(s) → Build APK(s)**.

## Rotina de atualização (quando o ACS-Digital.html mudar)

Substitua o arquivo `ACS-Digital.html` na raiz deste projeto e rode:

```bash
pnpm run build
npx cap sync android
npx cap open android
```

## Observações importantes

- **appId `br.acsdigital.app`** (em `capacitor.config.json`): é permanente após o primeiro
  build — troque ANTES da primeira compilação se quiser outro identificador.
- Os dados dos moradores ficam no **IndexedDB do WebView** e persistem no aparelho.
- O app funciona totalmente offline; nenhuma permissão de internet é necessária.
- `assets/icon-only.png` e `assets/splash.png` são a arte oficial (ícone anexado pelo usuário).
- `assets/icons/*.png` e `www/icons/*.png` são os PNGs do PWA (36/48/72/96/144/192/512).
- `www/manifest.webmanifest` é o manifesto do PWA (referenciado no `<head>` do index.html).
- `www/sw.js` é o service worker (faz cache do app offline e checa novas versões via `version.json`).
- `www/version.json` é onde a versão do PWA é definida — bump esse arquivo a cada release.
- O botão VOLTAR do app é interno; o botão físico do Android navega dentro do app
  e não fecha o aplicativo quando o menu está na tela (comportamento do escudo de histórico).
  Em dispositivos com Capacitor nativo, há também um listener `backButton` que fecha
  modal aberto antes de voltar a navegação.

## Recursos da versão 1.1 (update2)

Reorganização de menus, nova página 📆 CALENDÁRIO com aniversários + exames + consultas,
ícones de status nos cartões de visita domiciliar (✅🚺🚼‼️❗📖), formatadores de
data (dd/mm/aaaa) e hora (00h00), situação ↩️ DEVOLVIDO em guias, renomeação das
situações de agendamento (ENTREGUE/ENTREGUE/AVISADO/NÃO ENTREGUE), persistência local
de etiquetas/guias/agendamentos/visitas por cartão cidadão/CPF/CNS + endereço,
auto-exclusão de órfãos após 180 dias, modal EXPORTAR com checkboxes,
quarto slot de importação para JSON exportado pelo próprio app, e checagem de
atualização do PWA.
