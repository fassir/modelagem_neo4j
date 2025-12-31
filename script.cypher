// ==========================================
// 1. DEFINIÇÃO DE CONSTRAINTS (Esquema)
// Garante integridade e performance de busca
// ==========================================

// Unique IDs para Entidades Principais
CREATE CONSTRAINT user_id_unique IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT movie_id_unique IF NOT EXISTS FOR (m:Movie) REQUIRE m.id IS UNIQUE;
CREATE CONSTRAINT series_id_unique IF NOT EXISTS FOR (s:Series) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT actor_id_unique IF NOT EXISTS FOR (a:Actor) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT director_id_unique IF NOT EXISTS FOR (d:Director) REQUIRE d.id IS UNIQUE;

// Unique Name para Gêneros (evita duplicar "Action")
CREATE CONSTRAINT genre_name_unique IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;

// ==========================================
// 2. CRIAÇÃO DE DADOS DE REFERÊNCIA
// Gêneros, Diretores e Atores
// ==========================================

// Gêneros
MERGE (g1:Genre {name: 'Sci-Fi'})
MERGE (g2:Genre {name: 'Action'})
MERGE (g3:Genre {name: 'Drama'})
MERGE (g4:Genre {name: 'Comedy'})
MERGE (g5:Genre {name: 'Crime'})
MERGE (g6:Genre {name: 'Fantasy'})

// Diretores
MERGE (d1:Director {id: 'd001', name: 'Christopher Nolan'})
MERGE (d2:Director {id: 'd002', name: 'Quentin Tarantino'})
MERGE (d3:Director {id: 'd003', name: 'Vince Gilligan'}) // Creator/Director
MERGE (d4:Director {id: 'd004', name: 'Bong Joon-ho'})
MERGE (d5:Director {id: 'd005', name: 'Greta Gerwig'})

// Atores
MERGE (a1:Actor {id: 'a001', name: 'Leonardo DiCaprio'})
MERGE (a2:Actor {id: 'a002', name: 'Keanu Reeves'})
MERGE (a3:Actor {id: 'a003', name: 'Bryan Cranston'})
MERGE (a4:Actor {id: 'a004', name: 'Emilia Clarke'})
MERGE (a5:Actor {id: 'a005', name: 'Steve Carell'})
MERGE (a6:Actor {id: 'a006', name: 'Uma Thurman'})
MERGE (a7:Actor {id: 'a007', name: 'Song Kang-ho'})
MERGE (a8:Actor {id: 'a008', name: 'Cillian Murphy'})

// ==========================================
// 3. CATALOGAÇÃO DE CONTEÚDO (Filmes e Séries)
// Criando nós e conectando com Staff/Gênero
// ==========================================

// --- Filmes (6 Itens) ---

// Inception
MERGE (m1:Movie {id: 'm001', title: 'Inception', year: 2010})
MERGE (m1)-[:IN_GENRE]->(g1)
MERGE (d1)-[:DIRECTED]->(m1)
MERGE (a1)-[:ACTED_IN]->(m1)
MERGE (a8)-[:ACTED_IN]->(m1)

// The Matrix
MERGE (m2:Movie {id: 'm002', title: 'The Matrix', year: 1999})
MERGE (m2)-[:IN_GENRE]->(g1)
MERGE (m2)-[:IN_GENRE]->(g2)
MERGE (a2)-[:ACTED_IN]->(m2)

// Pulp Fiction
MERGE (m3:Movie {id: 'm003', title: 'Pulp Fiction', year: 1994})
MERGE (m3)-[:IN_GENRE]->(g5)
MERGE (d2)-[:DIRECTED]->(m3)
MERGE (a6)-[:ACTED_IN]->(m3)

// Parasite
MERGE (m4:Movie {id: 'm004', title: 'Parasite', year: 2019})
MERGE (m4)-[:IN_GENRE]->(g3)
MERGE (m4)-[:IN_GENRE]->(g5)
MERGE (d4)-[:DIRECTED]->(m4)
MERGE (a7)-[:ACTED_IN]->(m4)

// Barbie
MERGE (m5:Movie {id: 'm005', title: 'Barbie', year: 2023})
MERGE (m5)-[:IN_GENRE]->(g4)
MERGE (d5)-[:DIRECTED]->(m5)

// Oppenheimer
MERGE (m6:Movie {id: 'm006', title: 'Oppenheimer', year: 2023})
MERGE (m6)-[:IN_GENRE]->(g3)
MERGE (d1)-[:DIRECTED]->(m6)
MERGE (a8)-[:ACTED_IN]->(m6)

// --- Séries (4 Itens) ---

// Breaking Bad
MERGE (s1:Series {id: 's001', title: 'Breaking Bad', year: 2008})
MERGE (s1)-[:IN_GENRE]->(g5)
MERGE (s1)-[:IN_GENRE]->(g3)
MERGE (d3)-[:DIRECTED]->(s1)
MERGE (a3)-[:ACTED_IN]->(s1)

// Game of Thrones
MERGE (s2:Series {id: 's002', title: 'Game of Thrones', year: 2011})
MERGE (s2)-[:IN_GENRE]->(g6)
MERGE (s2)-[:IN_GENRE]->(g3)
MERGE (a4)-[:ACTED_IN]->(s2)

// The Office
MERGE (s3:Series {id: 's003', title: 'The Office', year: 2005})
MERGE (s3)-[:IN_GENRE]->(g4)
MERGE (a5)-[:ACTED_IN]->(s3)

// Stranger Things (Sem diretor/ator específico neste dataset simplificado)
MERGE (s4:Series {id: 's004', title: 'Stranger Things', year: 2016})
MERGE (s4)-[:IN_GENRE]->(g1)
MERGE (s4)-[:IN_GENRE]->(g6)


// ==========================================
// 4. CRIAÇÃO DE USUÁRIOS E INTERAÇÕES
// 10 Usuários e relacionamentos WATCHED
// ==========================================

MERGE (u1:User {id: 'u001', name: 'Ana Silva'})
MERGE (u2:User {id: 'u002', name: 'Bruno Santos'})
MERGE (u3:User {id: 'u003', name: 'Carla Dias'})
MERGE (u4:User {id: 'u004', name: 'Daniel Oliveira'})
MERGE (u5:User {id: 'u005', name: 'Eduarda Lima'})
MERGE (u6:User {id: 'u006', name: 'Felipe Costa'})
MERGE (u7:User {id: 'u007', name: 'Gabriela Rocha'})
MERGE (u8:User {id: 'u008', name: 'Hugo Martins'})
MERGE (u9:User {id: 'u009', name: 'Isabela Ferreira'})
MERGE (u10:User {id: 'u010', name: 'João Pereira'})

// Interações (WATCHED com Rating)
// Ana ama Nolan
MERGE (u1)-[:WATCHED {rating: 5.0}]->(m1) // Inception
MERGE (u1)-[:WATCHED {rating: 4.5}]->(m6) // Oppenheimer

// Bruno gosta de ação
MERGE (u2)-[:WATCHED {rating: 4.0}]->(m2) // Matrix
MERGE (u2)-[:WATCHED {rating: 5.0}]->(s1) // Breaking Bad

// Carla é fã de comédia
MERGE (u3)-[:WATCHED {rating: 5.0}]->(s3) // The Office
MERGE (u3)-[:WATCHED {rating: 3.5}]->(m5) // Barbie

// Daniel (Crítico exigente)
MERGE (u4)-[:WATCHED {rating: 2.0}]->(m5)
MERGE (u4)-[:WATCHED {rating: 5.0}]->(m3) // Pulp Fiction

// Eduarda
MERGE (u5)-[:WATCHED {rating: 4.8}]->(s2) // GoT
MERGE (u5)-[:WATCHED {rating: 4.0}]->(s4) // Stranger Things

// Felipe
MERGE (u6)-[:WATCHED {rating: 5.0}]->(m4) // Parasite

// Gabriela
MERGE (u7)-[:WATCHED {rating: 3.0}]->(m1)
MERGE (u7)-[:WATCHED {rating: 5.0}]->(s3)

// Hugo (Fã de clássicos)
MERGE (u8)-[:WATCHED {rating: 5.0}]->(m3)
MERGE (u8)-[:WATCHED {rating: 4.5}]->(s1)

// Isabela
MERGE (u9)-[:WATCHED {rating: 4.0}]->(m6)
// MERGE (u9)-[:WATCHED {rating: 4.2}]->(a8) // ERRO CONCEITUAL: Usuário não assiste ator, assiste filme. Corrigido abaixo.
// Nota: O relacionamento WATCHED deve ser apenas para Movie/Series conforme schema.
MERGE (u9)-[:WATCHED {rating: 4.5}]->(m6)

// João (Maratonista)
MERGE (u10)-[:WATCHED {rating: 4.0}]->(s1)
MERGE (u10)-[:WATCHED {rating: 4.0}]->(s2)
MERGE (u10)-[:WATCHED {rating: 3.5}]->(s3)
MERGE (u10)-[:WATCHED {rating: 4.5}]->(s4)