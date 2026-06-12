``` sql
CREATE TABLE categorias (
    categoria_id INTEGER,
    categoria_nome TEXT
);

CREATE TABLE produtos (
    produto_id INTEGER,
    produto_nome TEXT,
    preco INTEGER,
    categoria_id INTEGER
);

CREATE TABLE clientes (
    cliente_id INTEGER,
    nome TEXT
);

CREATE TABLE pedidos (
    pedido_id INTEGER,
    cliente_id INTEGER,
    produto_id INTEGER,
    quantidade INTEGER
);
```
