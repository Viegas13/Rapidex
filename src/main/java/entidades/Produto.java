package entidades;

import java.util.Date;

public class Produto {

    private long id;
    private String nome;
    private Date validade;
    private double preco;
    private String imagem;
    private String descricao;
    private Fornecedor fornecedor;
    private boolean restritoPorIdade;

    public Produto(long id, String nome, Date validade, double preco, String imagem, String descricao, boolean restritoPorIdade) {
        this.id = id;
        this.nome = nome;
        this.validade = validade;
        this.preco = preco;
        this.imagem = imagem;
        this.descricao = descricao;
        this.restritoPorIdade = restritoPorIdade;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Date getValidade() {
        return validade;
    }

    public void setValidade(Date validade) {
        this.validade = validade;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public String getImagem() {
        return imagem;
    }

    public void setImagem(String imagem) {
        this.imagem = imagem;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Fornecedor getFornecedor() {
        return fornecedor;
    }

    public void setFornecedor(Fornecedor fornecedor) {
        this.fornecedor = fornecedor;
    }

    public boolean isRestritoPorIdade() {
        return restritoPorIdade;
    }

    public void setRestritoPorIdade(boolean restritoPorIdade) {
        this.restritoPorIdade = restritoPorIdade;
    }
    
    
}
