package entidades;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class Produto {

    @Id
    private long id; // PRIMARY KEY
    
    private String nome;
    private String validade;
    private double preco;
    private String imagem;
    private String descricao;
    private long fornecedor_cnpj;
    private String restritoPorIdade;

    public Produto() {
        
    }
    
    public Produto(long id, String nome, String validade, double preco, String imagem, String descricao, long cnpjFornecedor, String restritoPorIdade) {
        this.id = id;
        this.nome = nome;
        this.validade = validade;
        this.preco = preco;
        this.imagem = imagem;
        this.descricao = descricao;
        this.fornecedor_cnpj = cnpjFornecedor;
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

    public String getValidade() {
        return validade;
    }

    public void setValidade(String validade) {
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

    public long getFornecedor() {
        return fornecedor_cnpj;
    }

    public void setFornecedor(long fornecedor) {
        this.fornecedor_cnpj = fornecedor;
    }

    public String isRestritoPorIdade() {
        return restritoPorIdade;
    }

    public void setRestritoPorIdade(String restritoPorIdade) {
        this.restritoPorIdade = restritoPorIdade;
    }
    
    
}
