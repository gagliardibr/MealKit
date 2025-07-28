# MealKit – Aplicativo iOS Modular com MVVM-C

MealKit é um aplicativo iOS modular desenvolvido para demonstrar proficiência em arquitetura limpa, testabilidade, boas práticas de desenvolvimento, componentização e integração com APIs REST reais.  
Este projeto foi criado como entrega técnica para uma vaga de desenvolvedor(a) iOS.

---

## Descrição do Projeto

O aplicativo permite ao usuário:

- Buscar receitas usando a TheMealDB API
- Visualizar uma lista de pratos com imagens e títulos
- Filtrar receitas por categoria ou área de origem

---

## API Utilizada

Integração com a [TheMealDB Public API (v1)](https://www.themealdb.com/api.php):

- Buscar lista de receitas ou por nome: `/search.php?s=`
- Listar todas as categorias: `/list.php?c=list`
- Listar todas as áreas: `/list.php?a=list`
- Filtrar por categoria: `/filter.php?c=Seafood`
- Filtrar por área: `/filter.php?a=Canadian`

---

## Arquitetura Adotada: MVVM-C

### Por que escolhemos MVVM-C (Model - View - ViewModel - Coordinator)?

- **Escalabilidade com Swift:** a separação clara de responsabilidades permite transição gradual para SwiftUI mantendo a lógica intacta no ViewModel.
- **Organização por fluxo:** facilita a testabilidade e desacopla a navegação da UI.
- **Reusabilidade e manutenção:** isolamento de camadas evita efeitos colaterais em refatorações.
- **Responsabilidade única:** ViewModel trata o estado da tela, Service lida com rede, Coordinator cuida da navegação.
- **Adoção em ambientes com múltiplas squads:** ideal para grandes codebases com equipes paralelas.

---

## Estrutura de Pastas

```text
MealKit/
├── App/                          - AppDelegate e AppCoordinator
├── Modules/
│   ├── MealList/                 - Tela principal de receitas
│   ├── MealDetail/              - Tela de detalhes (em construção)
│   └── Filters/                 - Filtros por categoria/área
├── Networking/                  - Camada de requisições + erros
├── UI/                          - Componentes reutilizáveis + Design System
├── Extensions/                  - Extensões úteis (UIColor, etc)
├── Common/                      - Enums, strings e constantes
├── Resources/                   - Imagens, assets (futuro)
├── MealKitTests/                - Testes unitários, mocks e snapshots
└── MealKitUITests/              - Testes de UI (em estruturação)
```

---

## Decisões Técnicas e Justificativas

**Uso de MVVM-C**  
Facilita a escalabilidade, testabilidade e organização de grandes projetos. Compatível com ambientes modernos e adoção futura de SwiftUI.

**Organização por módulos (Modules/)**  
Favorece o trabalho em equipes paralelas e separação de contexto por funcionalidade.

**View Code + UIKit**  
Elimina Storyboard, melhora reuso e clareza do layout, facilita testes e futuras migrações para SwiftUI.

**Coordinator e Factory**  
Desacoplamento completo da navegação e controle claro de injeções de dependência.

**Networking isolado por protocolo**  
Flexível, testável e facilmente substituível por outro client (como Alamofire).

**Extensões e Design System**  
Reduz repetição e melhora consistência visual e semântica entre componentes.

**Uso da biblioteca SDWebImage**  
Cache e carregamento eficiente de imagens remotas, com suporte a placeholders, cancelamento de requisições e integração direta com `UIImageView`.

**Uso da biblioteca SPM** 

Para este projeto foi utilizado o **Swift Package Manager (SPM)**.

### Por que escolhemos o SPM?

- Integrado nativamente ao Xcode (desde a versão 11)
- Evita a necessidade de arquivos `.xcworkspace`
- Menor configuração local para novos desenvolvedores

### Comparativo com outros gerenciadores

```
| Gerenciador     | Prós                                              | Contras                                                     |
|-----------------|---------------------------------------------------|-------------------------------------------------------------|
| **SPM**         | Nativo, simples, leve, moderno                    | Nem todas libs ainda estão disponíveis                      |
| **CocoaPods**   | Amplo suporte de libs, popular                    | Mais lento, gera `.xcworkspace`, pode causar conflitos      |
| **Carthage**    | Builds binários, bom para libs privadas           | Mais difícil de configurar, requer scripts adicionais       |
```

---

## Capturas de Tela (em andamento)

Espaço reservado para imagens do app:

- [ ] Lista de receitas carregadas
- [ ] Aplicação de filtros (categoria ou área)
- [ ] Estado de erro com mensagem amigável
- [ ] Tela de detalhes (quando implementada)

---

## Testes

- Unitários com XCTest
- Mocks para serviços, estados de erro, loading e sucesso
- Testes de Snapshot com `SnapshotTesting`
- Estrutura inicial pronta para testes de UI com XCUITest

---

## Melhorias Técnicas Futuras

1. Implementar cache com `URLCache` ou `FileManager`
2. Persistência de favoritos com `UserDefaults` ou `CoreData`
3. Funcionalidade de planejamento de refeições semanais
4. Paginação e carregamento incremental de resultados
5. Tela de detalhe com instruções e ingredientes
6. Remote Config para gerenciamento de funcionalidades
7. Isolamento de filtros como módulo próprio com delegate ou Combine

---

## Para quem está começando

- `ViewController` exibe os dados na tela
- `ViewModel` gerencia o estado e a lógica da tela
- `Service` realiza as chamadas para a API
- `Coordinator` decide qual tela abrir
- Tudo está separado por funcionalidade para facilitar entendimento e manutenção

---

## Como rodar o projeto

1. Clone este repositório:

```bash
git clone https://github.com/gagliardibr/MealKit.git
```

2. Abra com o Xcode (versão 14 ou superior):

```bash
open MealKit.xcodeproj
```

3. Aguarde a resolução automática de dependências via Swift Package Manager (SPM):

- SnapshotTesting  
- iOSSnapshotTestCase  
- SDWebImage  

4. Caso necessário: `File > Packages > Resolve Package Versions`

5. Selecione o target `MealKit` e execute com `Command + R`

---

## Autora

**Bruna Gagliardi**  
Desenvolvedora iOS    
Entrega técnica para vaga de desenvolvedor(a) iOS.
