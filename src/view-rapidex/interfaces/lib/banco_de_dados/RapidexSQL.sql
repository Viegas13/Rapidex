CREATE TABLE Fornecedor (
    CNPJ VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    telefone VARCHAR(255)
);

CREATE TABLE Cliente(
    CPF VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    senha VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    dataNascimento DATE
);

CREATE TABLE Entregador(
    CPF VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    senha VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    dataNascimento DATE,
    veiculo VARCHAR(255)
);

-- Tabela Endereco com ON DELETE CASCADE
CREATE TABLE Endereco (
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(11),
    entregador_cpf VARCHAR(11),
    bairro VARCHAR(255),
    rua VARCHAR(255),
    numero INT,
    CEP VARCHAR(255),
    complemento VARCHAR(255),
    referencia VARCHAR(255),
    PRIMARY KEY (cliente_cpf, CEP),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ),
    FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF)
);

CREATE TABLE Produto (
    nome VARCHAR(255),
    validade VARCHAR(10),
    preco FLOAT,
    imagem bytea,
    descricao VARCHAR(255),
    fornecedor_cnpj VARCHAR(255),
    restritoPorIdade VARCHAR(10),
    quantidade INT
    --FOREIGN KEY () REFERENCES Endereco()
);

-- Tabela Pedido com ON DELETE CASCADE
CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY,
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(14),
    entregador_cpf VARCHAR(14),
    preco FLOAT,
    FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF) ON DELETE CASCADE,
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ)
);

-- Tabela Entrega com ON DELETE CASCADE
CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY,
    pedido_id INT,
    entregador_cpf VARCHAR(255),
    pendente BOOLEAN,
    endereco_cliente_cpf VARCHAR(255),
    endereco_CEP VARCHAR(255),
    frete FLOAT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE,
    FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF) ON DELETE CASCADE,
    FOREIGN KEY (endereco_cliente_cpf, endereco_CEP) REFERENCES Endereco(cliente_cpf, CEP) ON DELETE CASCADE
);

-- Tabela Cartao com ON DELETE CASCADE
CREATE TABLE Cartao (
    numero BIGINT PRIMARY KEY,
    cvv INT,
    validade DATE,
    nomeTitular VARCHAR(255),
    agencia BIGINT,
    bandeira VARCHAR(255),
    cliente_cpf VARCHAR(255),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE
);
