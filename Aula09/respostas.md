# Exercícios Práticos de MongoDB - Aula 09
## Sistema Simplificado de Catálogo de E-commerce

---

## Objetivo
Compreender a flexibilidade do modelo de documentos e praticar operações CRUD essenciais utilizando o `mongosh`.

---

## Estrutura do Banco de Dados

### Banco: `loja_virtual`
### Coleção: `produtos`

Documentos na mesma coleção podem ter campos diferentes de acordo com a categoria, demonstrando a flexibilidade do MongoDB.

---

## Execução do Script

### Via MongoDB Compass
1. Abra o MongoDB Compass
2. Conecte à instância local
3. Acesse a aba **MONGOSH** ou console integrado
4. Copie e execute os comandos do arquivo `loja_virtual_criacao_e_exercicios.js`

### Via Terminal (se mongosh estiver no PATH)
```bash
mongosh --file loja_virtual_criacao_e_exercicios.js
```

---

## Parte 1: Exercício 1 - Criação e Coleções (C do CRUD)

### Objetivo
Criar o banco, coleção e inserir documentos de diferentes categorias.

### Comandos

#### 1.1 Criar/usar o banco
```javascript
use loja_virtual
```
> Cria ou seleciona o banco `loja_virtual`. Se não existir, será criado na primeira inserção.

#### 1.2 Criar a coleção
```javascript
db.createCollection("produtos")
```
> Cria a coleção `produtos`. Nota: A coleção também é criada automaticamente na primeira inserção.

#### 1.3 Inserir um produto com insertOne()
```javascript
db.produtos.insertOne({
  nome: "Smartphone Galaxy A15",
  categoria: "Eletronicos",
  preco: 1299.90,
  marca: "Samsung",
  armazenamento: "128GB",
  cor: "Azul"
})
```
> Insere um único documento. Retorna `{ acknowledged: true, insertedId: ObjectId(...) }`

#### 1.4 Inserir múltiplos produtos com insertMany()
```javascript
db.produtos.insertMany([
  {
    nome: "MongoDB na Pratica",
    categoria: "Livros",
    preco: 79.90,
    autor: "Joao Silva",
    editora: "Tech Books",
    paginas: 320
  },
  {
    nome: "Camiseta Basica",
    categoria: "Roupas",
    preco: 49.90,
    tamanho: "M",
    cor: "Preta",
    material: "Algodao"
  },
  {
    nome: "Tenis Runner Pro",
    categoria: "Calcados",
    preco: 299.90,
    tamanho: 42,
    cor: "Branco",
    marca: "Olympikus"
  }
])
```
> Insere múltiplos documentos. Retorna `{ acknowledged: true, insertedIds: [ObjectId(...), ...] }`

### Resultado Esperado
- ✅ Banco `loja_virtual` criado
- ✅ Coleção `produtos` criada
- ✅ 4 documentos inseridos (1 smartphone + 3 outros de categorias diferentes)

---

## Parte 2: Exercício 2 - Consultas e Filtros (R do CRUD)

### Objetivo
Executar queries de leitura com filtros e projeções.

### 2.1 Listar todos os produtos
```javascript
db.produtos.find().pretty()
```
> Retorna todos os 4 documentos inseridos com formatação.

**Resultado esperado:**
```javascript
[
  {
    _id: ObjectId(...),
    nome: "Smartphone Galaxy A15",
    categoria: "Eletronicos",
    preco: 1299.90,
    marca: "Samsung",
    armazenamento: "128GB",
    cor: "Azul"
  },
  // ... outros documentos
]
```

### 2.2 Buscar produtos com preço superior a 100
```javascript
db.produtos.find({ preco: { $gt: 100 } }).pretty()
```
> Retorna 3 documentos: Smartphone (1299.90), Tenis (299.90), e opcionalmente o Notebook se inserido

**Filtro utilizado:** `$gt` (greater than) - maior que

**Resultado esperado:**
- Smartphone Galaxy A15 (R$ 1299.90)
- Tenis Runner Pro (R$ 299.90)
- (Notebook Ultra X se incluído - R$ 3899.90)

### 2.3 Listar apenas produtos da categoria "Eletronicos"
```javascript
db.produtos.find({ categoria: "Eletronicos" }).pretty()
```
> Retorna 1 ou 2 documentos da categoria Eletronicos

**Resultado esperado:**
- Smartphone Galaxy A15

### 2.4 Buscar apenas nome e preço (sem o _id)
```javascript
db.produtos.find({}, { nome: 1, preco: 1, _id: 0 }).pretty()
```
> Usa projeção: `1` para incluir, `0` para excluir

**Resultado esperado:**
```javascript
[
  { nome: "Smartphone Galaxy A15", preco: 1299.90 },
  { nome: "MongoDB na Pratica", preco: 79.90 },
  { nome: "Camiseta Basica", preco: 49.90 },
  { nome: "Tenis Runner Pro", preco: 299.90 }
]
```

---

## Parte 3: Exercício 3 - Atualização Dinâmica (U do CRUD)

### Objetivo
Atualizar documentos de forma parcial usando operadores de modificação.

### 3.1 Atualizar o preço de um produto específico
```javascript
db.produtos.updateOne(
  { nome: "Smartphone Galaxy A15" },
  { $set: { preco: 1199.90 } }
)
```
> Operador `$set`: atualiza apenas o campo especificado, mantendo os outros intactos

**Resultado esperado:**
```javascript
{ acknowledged: true, matchedCount: 1, modifiedCount: 1 }
```

### 3.2 Adicionar campo "estoque" em todos os produtos
```javascript
db.produtos.updateMany(
  {},
  { $set: { estoque: 50 } }
)
```
> `{}` como filtro significa "todos os documentos"

**Resultado esperado:**
```javascript
{ acknowledged: true, matchedCount: 4, modifiedCount: 4 }
```

**Novo documento:**
```javascript
{
  _id: ObjectId(...),
  nome: "Smartphone Galaxy A15",
  categoria: "Eletronicos",
  preco: 1199.90,        // ← preço atualizado
  marca: "Samsung",
  armazenamento: "128GB",
  cor: "Azul",
  estoque: 50            // ← novo campo
}
```

### 3.3 Marcar produtos da categoria "Roupas" com promocao: true
```javascript
db.produtos.updateMany(
  { categoria: "Roupas" },
  { $set: { promocao: true } }
)
```
> Atualiza apenas documentos onde `categoria` é "Roupas"

**Resultado esperado:**
```javascript
{ acknowledged: true, matchedCount: 1, modifiedCount: 1 }
```

**Documento atualizado:**
```javascript
{
  _id: ObjectId(...),
  nome: "Camiseta Basica",
  categoria: "Roupas",
  preco: 49.90,
  tamanho: "M",
  cor: "Preta",
  material: "Algodao",
  estoque: 50,
  promocao: true         // ← novo campo
}
```

---

## Parte 4: Exercício 4 - Exclusão de Dados (D do CRUD)

### Objetivo
Remover documentos de forma seletiva.

### 4.1 Remover um produto específico
```javascript
db.produtos.deleteOne({ nome: "Camiseta Basica" })
```
> Remove o primeiro documento que corresponde ao filtro

**Resultado esperado:**
```javascript
{ acknowledged: true, deletedCount: 1 }
```

**Após esta operação:** 3 documentos restam na coleção

### 4.2 Remover todos os produtos de uma categoria
```javascript
db.produtos.deleteMany({ categoria: "Livros" })
```
> Remove todos os documentos que correspondem ao filtro

**Resultado esperado:**
```javascript
{ acknowledged: true, deletedCount: 1 }
```

**Após esta operação:** 2 documentos restam na coleção

---

## Estado Final da Coleção

Após todos os exercícios, a coleção terá aproximadamente 2 documentos:

```javascript
db.produtos.find().pretty()
```

**Resultado esperado:**
```javascript
[
  {
    _id: ObjectId(...),
    nome: "Smartphone Galaxy A15",
    categoria: "Eletronicos",
    preco: 1199.90,
    marca: "Samsung",
    armazenamento: "128GB",
    cor: "Azul",
    estoque: 50
  },
  {
    _id: ObjectId(...),
    nome: "Tenis Runner Pro",
    categoria: "Calcados",
    preco: 299.90,
    tamanho: 42,
    cor: "Branco",
    marca: "Olympikus",
    estoque: 50
  }
]
```

---

## Resumo de Operações CRUD

| Operação | Método | Descrição |
|----------|--------|-----------|
| **CREATE** | `insertOne()` | Insere um documento |
| **CREATE** | `insertMany()` | Insere múltiplos documentos |
| **READ** | `find()` | Busca documentos com filtros |
| **READ** | `find({}, projection)` | Busca com projeção de campos |
| **UPDATE** | `updateOne()` | Atualiza o primeiro documento que corresponde |
| **UPDATE** | `updateMany()` | Atualiza todos os documentos que correspondem |
| **DELETE** | `deleteOne()` | Remove o primeiro documento que corresponde |
| **DELETE** | `deleteMany()` | Remove todos os documentos que correspondem |

---

## Operadores Utilizados

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `$gt` | Greater than (maior que) | `{ preco: { $gt: 100 } }` |
| `$set` | Define o valor de um campo | `{ $set: { preco: 1199.90 } }` |
| `{}` | Filtro vazio (todos) | `find({})` retorna tudo |

---

## Flexibilidade do MongoDB Demonstrada

✅ **Campos diferentes por categoria:**
- Smartphone: `marca`, `armazenamento`, `cor`
- Livro: `autor`, `editora`, `paginas`
- Roupa: `tamanho`, `material`
- Calçado: `tamanho`, `marca`

✅ **Adição dinâmica de campos:**
- Campo `estoque` adicionado a todos os produtos sem necessidade de migração
- Campo `promocao` adicionado apenas a produtos específicos

✅ **Sem esquema rígido:**
- Não é necessário definir estrutura prévia
- Cada documento pode evoluir independentemente

---

## Como Executar o Script Completo

### Arquivo: `loja_virtual_criacao_e_exercicios.js`

Contém todos os comandos acima em ordem sequencial. Para executar:

**Via Compass:**
1. Console integrado → copiar e colar conteúdo do arquivo
2. Ou: MONGOSH → `source('loja_virtual_criacao_e_exercicios.js')`

**Via Terminal:**
```bash
mongosh --file loja_virtual_criacao_e_exercicios.js
```

---

## Notas Importantes

- **_id**: Campo criado automaticamente pelo MongoDB como chave primária (ObjectId)
- **$gt, $lt, $eq**: Operadores de comparação do MongoDB
- **pretty()**: Formata a saída JSON de forma legível
- **Projeção**: `{ campo: 1 }` inclui, `{ campo: 0 }` exclui
- **Atomicdidade**: updateMany e deleteMany operam em múltiplos documentos, mas cada operação individual é atômica

---

## Script Completo - Passo a Passo

Este é o script completo que pode ser executado no MongoDB Compass ou via terminal com `mongosh`.

### Executar no Compass
1. Abra MongoDB Compass
2. Clique em **MONGOSH** (aba do console)
3. Copie e cole o código abaixo

### Executar via Terminal
```bash
mongosh --file loja_virtual_criacao_e_exercicios.js
```

---

## Código Completo com Explicações

```javascript
use loja_virtual

db.createCollection("produtos")

db.produtos.insertOne({
  nome: "Smartphone Galaxy A15",
  categoria: "Eletronicos",
  preco: 1299.90,
  marca: "Samsung",
  armazenamento: "128GB",
  cor: "Azul"
})

db.produtos.insertMany([
  {
    nome: "MongoDB na Pratica",
    categoria: "Livros",
    preco: 79.90,
    autor: "Joao Silva",
    editora: "Tech Books",
    paginas: 320
  },
  {
    nome: "Camiseta Basica",
    categoria: "Roupas",
    preco: 49.90,
    tamanho: "M",
    cor: "Preta",
    material: "Algodao"
  },
  {
    nome: "Tenis Runner Pro",
    categoria: "Calcados",
    preco: 299.90,
    tamanho: 42,
    cor: "Branco",
    marca: "Olympikus"
  }
])

print('--- Todos os produtos ---')
db.produtos.find().pretty()

print('--- Produtos com preco > 100 ---')
db.produtos.find({ preco: { $gt: 100 } }).pretty()

print('--- Produtos da categoria Eletronicos ---')
db.produtos.find({ categoria: "Eletronicos" }).pretty()

print('--- Apenas nome e preco ---')
db.produtos.find({}, { nome: 1, preco: 1, _id: 0 }).pretty()

print('--- Atualizando preco do Smartphone ---')
db.produtos.updateOne(
  { nome: "Smartphone Galaxy A15" },
  { $set: { preco: 1199.90 } }
)

print('--- Adicionando campo estoque para todos os produtos ---')
db.produtos.updateMany(
  {},
  { $set: { estoque: 50 } }
)

print('--- Marcando promocao para produtos da categoria Roupas ---')
db.produtos.updateMany(
  { categoria: "Roupas" },
  { $set: { promocao: true } }
)

print('--- Exibindo produtos atualizados ---')
db.produtos.find().pretty()

print('--- Removendo um produto especifico ---')
db.produtos.deleteOne({ nome: "Camiseta Basica" })

print('--- Removendo todos os produtos da categoria Livros ---')
db.produtos.deleteMany({ categoria: "Livros" })

print('--- Exibindo produtos finais ---')
db.produtos.find().pretty()
```

---

## Resumo da Execução

| Passo | Operação | Comando | Resultado |
|-------|----------|---------|-----------|
| 1 | Criar banco | `use loja_virtual` | Banco criado |
| 2 | Criar coleção | `db.createCollection("produtos")` | Coleção criada |
| 3 | Inserir 1 | `insertOne({...})` | 1 documento adicionado |
| 4 | Inserir múltiplos | `insertMany([...])` | 3 documentos adicionados |
| 5 | Listar todos | `find().pretty()` | 4 documentos exibidos |
| 6 | Filtrar por preço | `find({ preco: { $gt: 100 } })` | 2 documentos encontrados |
| 7 | Filtrar por categoria | `find({ categoria: "Eletronicos" })` | 1 documento encontrado |
| 8 | Projeção | `find({}, { nome: 1, preco: 1 })` | Apenas 2 campos exibidos |
| 9 | Atualizar preço | `updateOne(..., { $set: { preco: 1199.90 } })` | 1 documento modificado |
| 10 | Adicionar campo | `updateMany({}, { $set: { estoque: 50 } })` | 4 documentos modificados |
| 11 | Atualizar condicional | `updateMany({ categoria: "Roupas" }, ...)` | 1 documento modificado |
| 12 | Visualizar | `find().pretty()` | Estado atual exibido |
| 13 | Deletar um | `deleteOne({ nome: "Camiseta Basica" })` | 1 documento removido |
| 14 | Deletar múltiplos | `deleteMany({ categoria: "Livros" })` | 1 documento removido |
| 15 | Resultado final | `find().pretty()` | 2 documentos restantes |

---

## Referências

- [MongoDB Official Documentation](https://docs.mongodb.com/)
- [MongoDB CRUD Operations](https://docs.mongodb.com/manual/crud/)
- [MongoDB Query Operators](https://docs.mongodb.com/manual/reference/operator/query/)
