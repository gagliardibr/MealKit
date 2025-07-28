MealKit – Aplicativo iOS Modular com MVVM-C

MealKit é um app iOS modular criado para demonstrar proficiência em arquitetura limpa, testabilidade, boas práticas de desenvolvimento, componentização e integração com APIs REST reais.  
Foi desenvolvido como entrega técnica para uma vaga iOS.

-------------------------------------------------------------------------------

Descrição do Projeto

MealKit permite ao usuário:
- Buscar receitas usando a TheMealDB API
- Visualizar uma lista de pratos com imagens e títulos
- Filtrar receitas por categoria ou área de origem

-------------------------------------------------------------------------------

API Utilizada

Integração com a TheMealDB Public API (v1):
- Buscar lista receita e receita por nome: /search.php?s=
- Listar todas as categorias: /list.php?c=list
- Listar todas as áreas: /list.php?a=list
- Filtrar por categoria: /filter.php?c=Seafood
- Filtrar por área: /filter.php?a=Canadian

-------------------------------------------------------------------------------

Arquitetura Adotada: MVVM-C

Por que MVVM-C (Model-View-ViewModel + Coordinator)?

- Escalabilidade com Swift: separação clara de responsabilidades e compatibilidade com ObservableObject facilitam futura adoção de SwiftUI. A transição pode ser feita gradualmente, mantendo a lógica no ViewModel.
- Organização por fluxo: o padrão MVVM-C facilita a navegação desacoplada e a testabilidade, evitando que a lógica de UI fique misturada à navegação.
- Reusabilidade e manutenção: cada camada é isolada, favorecendo mudanças futuras sem causar efeito cascata.
- Responsabilidade única: a ViewModel cuida apenas do estado da tela, o Service trata do backend e o Coordinator da navegação.
- Pronto para ambientes com múltiplas squads e codebase grande: favorece divisão por módulo/feature.

-------------------------------------------------------------------------------

Estrutura de Pastas

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

├── MealKitTests/                - Testes unitários, mocks e snapshots (em andamento)

└── MealKitUITests/              - Testes de UI (em andamento)

-------------------------------------------------------------------------------

Decisões Técnicas e Justificativas

Decisão: Uso de MVVM-C  
Justificativa: Facilita a escalabilidade e a manutenção do projeto em ambientes corporativos, separa responsabilidades, favorece testabilidade e permite futuras migrações parciais para SwiftUI.

Decisão: Organização por Modules/  
Justificativa: Reflete estrutura baseada em domínio, ideal para times trabalhando em paralelo. Garante que regras de negócio, UI e navegação estejam localizadas por funcionalidade.

Decisão: ViewCode + UIKit  
Justificativa: Controle total da renderização, elimina conflitos de Storyboard e permite reaproveitamento de views em testes e previews SwiftUI no futuro.

Decisão: Coordinator e Factory  
Justificativa: Navegação centralizada e desacoplada da interface. Facilitam injeção de dependência e uso de mocks em testes.

Decisão: Camada de Networking isolada  
Justificativa: Permite substituição de URLSession por outras tecnologias (ex: Alamofire) e facilita testes com mocks.

Decisão: Uso de extensões e design system  
Justificativa: Reduz código duplicado e melhora consistência visual e manutenibilidade.

-------------------------------------------------------------------------------

Testes (em andamento)

- Unitários com XCTest
- Mocks de serviços e estados (loading, erro, sucesso)
- Testes visuais com SnapshotTesting
- Preparação para testes de UI com XCUITest

-------------------------------------------------------------------------------

Melhorias Técnicas Futuras

1. Implementar cache com URLCache ou FileManager
2. Criar sistema de favoritos com persistência local (ex: UserDefaults ou CoreData)
3. Tela de detalhe com instruções, ingredientes e vídeo
4. Testes de UI com XCUITest
5. Remote Config para ativação de features em produção
6. Adotar Swift Concurrency com async let e TaskGroup
7. Reestruturação de filtros como módulo independente com comunicação via delegate ou Combine

-------------------------------------------------------------------------------

Para quem está começando

- ViewController exibe os dados
- ViewModel contém a lógica de estado e interação
- Service realiza as requisições HTTP
- Coordinator decide para onde navegar
- Tudo é dividido por funcionalidade, o que torna o app fácil de entender, testar e manter

-------------------------------------------------------------------------------

Autora

Bruna Gagliardi  
Desenvolvedora iOS    
Entrega técnica para vaga iOS
