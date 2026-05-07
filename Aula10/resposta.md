# Respostas dos Exercícios de MongoDB - Aula 10

## Parte 1: Modelagem de Dados

1.  **Incorporação (Embedding)**

    **Resposta:** Inserir os módulos dentro do documento do curso melhora o desempenho de leitura porque esses dados são acessados juntos com frequência. A consulta que busca informações de um curso não precisa fazer múltiplas leituras em coleções diferentes, reduzindo I/O e latência.

    **Exemplo de documento:**
    ```js
    db.cursos.insertOne({
      titulo: "MongoDB para Desenvolvedores",
      descricao: "Aprenda modelagem e consultas avançadas",
      duracao_horas: 40,
      modulos: [
        { nome: "Introdução ao NoSQL", carga_horaria: 2 },
        { nome: "CRUD e Operadores", carga_horaria: 5 },
        { nome: "Agregação e Índices", carga_horaria: 8 }
      ]
    });
    ```

2.  **Referência (Reference)**

    **Resposta:** Referenciar o instrutor é preferível quando o instrutor pode ministrar vários cursos e seus dados podem mudar. Isso evita duplicação de dados, facilita atualizações únicas e garante consistência entre cursos que compartilham o mesmo instrutor.

    **Exemplo de documentos:**
    ```js
    const instrutor = {
      _id: ObjectId("642e2b1d5f1a2c3d4e5f6789"),
      nome: "Maria Silva",
      especialidade: "Banco de Dados NoSQL",
      email: "maria.silva@cursos.com"
    };
    db.instrutores.insertOne(instrutor);

    db.cursos.insertOne({
      titulo: "MongoDB Avançado",
      descricao: "Performance, replicação e agregação",
      instrutor_id: instrutor._id,
      duracao_horas: 32
    });
    ```

## Parte 2: Consultas e Filtros

1.  **Filtro de Existência:**

    ```js
    db.clientes.find({ email: { $exists: true, $ne: null } });
    ```

2.  **Filtro de Comparação:**

    ```js
    db.clientes.find({ idade: { $gte: 21 } });
    ```

3.  **Filtro Complexo:**

    ```js
    db.clientes.find({
      "endereco.cidade": "São Paulo",
      idade: { $lt: 30 }
    });
    ```

## Parte 3: Aggregation Framework (Relatórios)

**Pipeline de agregação:**

```js
db.vendas.aggregate([
  { $match: { status: "concluída" } },
  { $group: {
      _id: "$categoria",
      total_quantidade: { $sum: "$quantidade" }
  } },
  { $project: {
      categoria: "$_id",
      total_quantidade: 1,
      _id: 0
  } }
]);
```
