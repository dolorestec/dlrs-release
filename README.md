# DLRS - Image Docker

## Descrição

Imagem para execução de aplicações em Python 3.11


## Workflows
### Build and Push
- Arquivo: `.github/workflows/build-and-push.yml`
- Descrição: Executa o build da imagem e faz o push para o Docker Hub
- Branch: `develop`, `main`
- Evento: `push`, `workflow_dispatch`
- Workflow: `build-and-push`
- Steps:
     - `variables` - Define as variáveis de ambiente
     - `build-push` - Executa o build e push da imagem