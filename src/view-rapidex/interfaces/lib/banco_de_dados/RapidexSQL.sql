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
    endereco_id VARCHAR(255), --endereco_id -> união de CEP + CPF (feito no código)
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(14),
    bairro VARCHAR(255),
    rua VARCHAR(255),
    numero INT,
    CEP VARCHAR(255),
    complemento VARCHAR(255),
    referencia VARCHAR(255),
    PRIMARY KEY (endereco_id),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ) ON DELETE CASCADE
);

CREATE TABLE Produto (
    produto_id int PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    nome VARCHAR(255),
    validade DATE,
    preco FLOAT,
    imagem VARCHAR(255) NOT NULL,
    descricao VARCHAR(255),
    fornecedor_cnpj VARCHAR(255),
    restritoPorIdade boolean,
    quantidade INT
    --FOREIGN KEY () REFERENCES Endereco()
);

CREATE TYPE Status_pedido AS ENUM ('pendente', 'em preparo', 'aceito', 'pronto', 'retirado', 'chegou', 'cancelado', 'concluido');
-- pendente -> acabou de criar o pedido
-- em preparo -> fornecedor marca que começou o preparo
-- aceito -> algum entregador aceitou o pedido para realizar entrega
-- pronto -> entregador pode buscar
-- retirado -> forncedor marca no app que entregou o pedido ao entregador
-- cancelado -> cancelou

-- Tabela Pedido com ON DELETE CASCADE
CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    cliente_cpf VARCHAR(255),
    fornecedor_cnpj VARCHAR(14),
    preco FLOAT,
    frete FLOAT,
    data_de_entrega DATE,
    endereco_entrega VARCHAR(255), --endereco_entrega -> união de CEP + CPF (feito no código)
    status_pedido Status_pedido DEFAULT 'pendente',
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_cnpj) REFERENCES Fornecedor(CNPJ)
);

CREATE TYPE Status_entrega AS ENUM ('aguardando_retirada', 'a_caminho', 'chegou', 'entregue', 'cancelado');
-- aguardando retirada -> entregador aceitou e não marcou que está indo
-- a caminho -> entregador marca que está indo
-- chegou -> entregador marca que chegou
-- entregue -> entregador marca no app que terminou a entrega
-- cancelado -> cancelou

-------------------------------------- (o que eles veêm)
-- linha do tempo de estados para cliente -> "pendente" - "em preparo"(fornecedor marcou) - 
-- "a caminho"(entregador marcou) - "chegou"

-- linha do tempo de estados para entregador -> "em preparo" - "pronto"


-- Tabela Entrega com ON DELETE CASCADE
CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    pedido_id INT,
    entregador_cpf VARCHAR(255),
    status_entrega Status_entrega,
    endereco_retirada VARCHAR(255),
    endereco_entrega VARCHAR(255), --endereco_entrega -> união de CEP + CPF (feito no código)
    valor_final FLOAT
    --FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE,
    --FOREIGN KEY (entregador_cpf) REFERENCES Entregador(CPF) ON DELETE CASCADE,
    --FOREIGN KEY (endereco_entrega) REFERENCES Endereco(endereco_id) ON DELETE CASCADE
);

-- Tabela Cartao com ON DELETE CASCADE
CREATE TABLE Cartao (
    numero BIGINT PRIMARY KEY,
    cpf_titular VARCHAR(20),
    cvv INT,
    validade DATE,
    nomeTitular VARCHAR(255),
    agencia BIGINT,
    bandeira VARCHAR(255),
    
    cliente_cpf VARCHAR(255),
    FOREIGN KEY (cliente_cpf) REFERENCES Cliente(CPF) ON DELETE CASCADE
);

CREATE TABLE Item_Pedido (
    item_pedido_id int PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    produto_id int,
    pedido_id int,
    quantidade int,
    valor_total float,
    cliente_cpf VARCHAR(20),

    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id) ON DELETE CASCADE
);