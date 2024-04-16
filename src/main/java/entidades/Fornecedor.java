package entidades;

import java.util.ArrayList;
import jakarta.persistence.*;

@Entity
public class Fornecedor {
    
    private String nome;
    private String CNPJ; // PRIMARY KEY
    private Endereco endereco;
    private String email;
    private ArrayList<Produto> produtos;
    private long telefone;

    public Fornecedor(String nome, String CNPJ, Endereco endereco, String email, ArrayList<Produto> produtos, long telefone) {
        this.nome = nome;
        this.CNPJ = CNPJ;
        this.endereco = endereco;
        this.email = email;
        this.produtos = produtos;
        this.telefone = telefone;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCNPJ() {
        return CNPJ;
    }

    public void setCNPJ(String CNPJ) {
        this.CNPJ = CNPJ;
    }

    public Endereco getEndereco() {
        return endereco;
    }

    public void setEndereco(Endereco endereco) {
        this.endereco = endereco;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public ArrayList<Produto> getProdutos() {
        return produtos;
    }

    public void setProdutos(ArrayList<Produto> produtos) {
        this.produtos = produtos;
    }

    public long getTelefone() {
        return telefone;
    }

    public void setTelefone(long telefone) {
        this.telefone = telefone;
    }
    
}
