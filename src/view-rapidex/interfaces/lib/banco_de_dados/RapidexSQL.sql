CREATE TABLE Fornecedor (
    CNPJ VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    telefone BIGINT
);

CREATE TABLE Cliente(
    CPF VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    senha VARCHAR(255),
    email VARCHAR(255),
    telefone BIGINT,
    dataNascimento DATE
);

CREATE TABLE Entregador(
    CPF VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    senha VARCHAR(255),
    email VARCHAR(255),
    telefone BIGINT,
    dataNascimento DATE,
    veiculo VARCHAR(255)

);

CREATE TABLE Endereco (
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(11),
    entregador_cpf VARCHAR(11),
    bairro VARCHAR(255),
    rua VARCHAR(255),
    numero INT,
    CEP BIGINT,
    complemento VARCHAR(255),
    referencia VARCHAR(255),
    PRIMARY KEY (cliente_cpf, CEP),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF),
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ),
    FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF)
);


CREATE TABLE Produto (
    id BIGINT PRIMARY KEY,
    nome VARCHAR(255),
    validade VARCHAR(10),
    preco FLOAT,
    imagem VARCHAR(255),
    descricao VARCHAR(255),
    fornecedor_cnpj BIGINT,
    restritoPorIdade VARCHAR(10),
    quantidade INT
	--FOREIGN KEY () REFERENCES Endereco()
);


CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY,
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(14),
	entregador_cpf VARCHAR(14),
    preco FLOAT,
	FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF),
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ)
);

CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY,
    pedido_id INT,
    entregador_cpf VARCHAR(255),
    pendente BOOLEAN,
    endereco_cliente_cpf VARCHAR(255),
    endereco_CEP BIGINT,
    frete FLOAT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id),
    FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF),
    FOREIGN KEY (endereco_cliente_cpf, endereco_CEP) REFERENCES Endereco(cliente_cpf, CEP)
);

CREATE TABLE Cartao (
    numero BIGINT PRIMARY KEY,
    cvv INT,
    validade DATE,
    nomeTitular VARCHAR(255),
    agencia BIGINT,
    bandeira VARCHAR(255),
    cliente_cpf VARCHAR(255),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF)
);