<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1F9BD4,50:2E75B6,100:16265F&height=200&section=header&text=modelagem_neo4j&fontSize=48&fontColor=ffffff&fontAlignY=38&desc=Sistema%20de%20Recomendação%20com%20Banco%20de%20Grafos&descAlignY=58&descSize=18" width="100%"/>

[![Neo4j](https://img.shields.io/badge/Neo4j-4.4-008CC1?style=for-the-badge&logo=neo4j&logoColor=white)](https://neo4j.com/)
[![Cypher](https://img.shields.io/badge/Cypher-Query%20Language-00A0DC?style=for-the-badge&logo=neo4j&logoColor=white)](https://neo4j.com/developer/cypher/)
[![Graph DB](https://img.shields.io/badge/Graph-Database-brightgreen?style=for-the-badge&logo=graphql&logoColor=white)](https://neo4j.com/)

[![Neo4j](https://img.shields.io/badge/Neo4j-008CC1?style=flat-square&logo=neo4j&logoColor=white)](https://neo4j.com/)
[![Cypher](https://img.shields.io/badge/Cypher-00A0DC?style=flat-square&logo=neo4j&logoColor=white)](https://neo4j.com/developer/cypher/)
[![Graph](https://img.shields.io/badge/Graph%20DB-4DB33D?style=flat-square)](https://neo4j.com/)

</div>

---

## 🎯 Sobre o Projeto

Sistema de **recomendação de filmes e séries** modelado como banco de grafos no **Neo4j**, utilizando a linguagem de consulta **Cypher**. O projeto demonstra boas práticas de engenharia de dados para grafos — idempotência com `MERGE`, separação de responsabilidades e consultas de recomendação colaborativa.

O modelo aproveita a natureza relacional dos grafos para encontrar padrões que bancos relacionais tradicionais resolveriam com múltiplos JOINs custosos.

---

## 🗂️ Estrutura do Repositório

```
modelagem_neo4j/
├── script.cypher        # Script principal — criação do grafo e consultas
└── README.md
```

---

## 🧩 Modelo de Grafos

<div align="center">

### Nós (Nodes)

| Rótulo | Propriedades principais | Descrição |
|--------|------------------------|-----------|
| `User` | `id`, `name`, `age` | Usuário da plataforma |
| `Movie` | `id`, `title`, `year` | Filme cadastrado |
| `Series` | `id`, `title`, `seasons` | Série cadastrada |
| `Genre` | `name` | Gênero cinematográfico |
| `Actor` | `id`, `name` | Ator/Atriz |
| `Director` | `id`, `name` | Diretor(a) |

### Relacionamentos (Relationships)

| Relacionamento | De → Para | Propriedades |
|----------------|-----------|--------------|
| `WATCHED` | `User → Movie/Series` | `rating: Float` |
| `IN_GENRE` | `Movie/Series → Genre` | — |
| `ACTED_IN` | `Actor → Movie/Series` | `role: String` |
| `DIRECTED` | `Director → Movie/Series` | — |

</div>

---

## 🔄 Diagrama do Grafo

```
(User) --[WATCHED {rating}]--> (Movie)
(User) --[WATCHED {rating}]--> (Series)
(Movie) --[IN_GENRE]--> (Genre)
(Series) --[IN_GENRE]--> (Genre)
(Actor) --[ACTED_IN]--> (Movie)
(Actor) --[ACTED_IN]--> (Series)
(Director) --[DIRECTED]--> (Movie)
(Director) --[DIRECTED]--> (Series)

Exemplo de caminho de recomendação:
(User A) -[WATCHED]-> (Movie X) -[IN_GENRE]-> (Genre Y)
                                                    ^
(User B) -[WATCHED]-> (Movie Z) -[IN_GENRE]---------'
```

---

## 💡 Tecnologias

<div align="center">

[![My Skills](https://skillicons.dev/icons?i=graphql&theme=dark)](https://neo4j.com/)

</div>

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| Neo4j | 4.4+ | Banco de grafos |
| Cypher | — | Linguagem de consulta |
| Neo4j Desktop | 1.5+ | Ambiente local de desenvolvimento |
| Neo4j Browser | — | Visualização do grafo |

---

## 🚀 Como Executar

<details>
<summary><strong>📋 Pré-requisitos</strong></summary>

- [Neo4j Desktop](https://neo4j.com/download/) instalado
- Projeto criado com banco de dados ativo (versão 4.x ou superior)
- Plugin APOC habilitado (opcional, para funções auxiliares)

</details>

<details>
<summary><strong>▶️ Passo a passo</strong></summary>

1. **Abra o Neo4j Desktop** e inicie o banco de dados local.
2. **Acesse o Neo4j Browser** (geralmente em `http://localhost:7474`).
3. **Copie o conteúdo** de `script.cypher`.
4. **Cole no editor** do Neo4j Browser e execute bloco a bloco.
5. **Visualize o grafo** clicando nos nós retornados.

```cypher
-- Verificar dados criados
MATCH (n) RETURN labels(n), count(n) ORDER BY count(n) DESC;
```

</details>

---

## 🔍 Exemplos de Consultas

<details>
<summary><strong>📽️ Recomendação colaborativa (usuários similares)</strong></summary>

```cypher
// Encontra filmes assistidos por usuários com gostos similares
MATCH (u:User {name: "Ana"})-[:WATCHED]->(m:Movie)<-[:WATCHED]-(similar:User)
MATCH (similar)-[:WATCHED]->(rec:Movie)
WHERE NOT (u)-[:WATCHED]->(rec)
RETURN rec.title AS recomendacao, count(*) AS popularidade
ORDER BY popularidade DESC
LIMIT 10;
```

</details>

<details>
<summary><strong>🎭 Recomendação por gênero favorito</strong></summary>

```cypher
// Filmes do gênero mais assistido pelo usuário que ele ainda não viu
MATCH (u:User {name: "Carlos"})-[:WATCHED]->(m:Movie)-[:IN_GENRE]->(g:Genre)
WITH u, g, count(*) AS vezes
ORDER BY vezes DESC LIMIT 1
MATCH (rec:Movie)-[:IN_GENRE]->(g)
WHERE NOT (u)-[:WATCHED]->(rec)
RETURN rec.title AS recomendacao, g.name AS genero
LIMIT 10;
```

</details>

<details>
<summary><strong>⭐ Top filmes por rating médio</strong></summary>

```cypher
MATCH (:User)-[w:WATCHED]->(m:Movie)
RETURN m.title AS filme, round(avg(w.rating), 2) AS rating_medio, count(w) AS total_views
ORDER BY rating_medio DESC, total_views DESC
LIMIT 10;
```

</details>

---

## ⚙️ Boas Práticas Aplicadas

<details>
<summary><strong>🔐 Idempotência com MERGE vs CREATE</strong></summary>

| Operação | Uso recomendado |
|----------|----------------|
| `MERGE` | Nós e relacionamentos que não devem ser duplicados (usuários, filmes, gêneros) |
| `CREATE` | Eventos únicos que podem ocorrer múltiplas vezes |
| `MERGE ... ON CREATE SET` | Definir propriedades apenas na primeira criação |
| `MERGE ... ON MATCH SET` | Atualizar propriedades em upserts |

```cypher
// Padrão idempotente usado no projeto
MERGE (u:User {id: $userId})
ON CREATE SET u.name = $name, u.age = $age, u.createdAt = datetime()
ON MATCH SET u.lastLogin = datetime();
```

</details>

<details>
<summary><strong>📐 Índices para performance</strong></summary>

```cypher
CREATE INDEX user_id IF NOT EXISTS FOR (u:User) ON (u.id);
CREATE INDEX movie_id IF NOT EXISTS FOR (m:Movie) ON (m.id);
CREATE INDEX series_id IF NOT EXISTS FOR (s:Series) ON (s.id);
CREATE INDEX genre_name IF NOT EXISTS FOR (g:Genre) ON (g.name);
```

</details>

---

## 📊 Vantagens do Modelo em Grafos

```
Banco Relacional (JOINs necessários para recomendação):
  users → watched → movies → movie_genres → genres
  4 JOINs + subconsultas correlacionadas

Neo4j (traversal nativo):
  (User)-[:WATCHED]->(Movie)-[:IN_GENRE]->(Genre)
  1 padrão de traversal — O(log n) vs O(n²)
```

Bancos de grafos são **10x a 1000x mais rápidos** que relacionais para consultas de múltiplos saltos (multi-hop) típicas de sistemas de recomendação.

---

## 👤 Autor

<div align="center">

**Fabio Piassi**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/fabio-piassi)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/fassir)

</div>

---

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:16265F,50:2E75B6,100:1F9BD4&height=120&section=footer" width="100%"/>
