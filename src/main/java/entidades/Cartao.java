package entidades;

import java.util.Date;

public class Cartao {
    
    private long numero; // PRIMARY KEY
    private int cvv;
    private Date validade;
    private String nomeTitular;
    private long agencia;
    private String bandeira;

    public Cartao(long numero, int cvv, Date validade, String nomeTitular, long agencia, String bandeira) {
        this.numero = numero;
        this.cvv = cvv;
        this.validade = validade;
        this.nomeTitular = nomeTitular;
        this.agencia = agencia;
        this.bandeira = bandeira;
    }

    public long getNumero() {
        return numero;
    }

    public void setNumero(long numero) {
        this.numero = numero;
    }

    public int getCvv() {
        return cvv;
    }

    public void setCvv(int cvv) {
        this.cvv = cvv;
    }

    public Date getValidade() {
        return validade;
    }

    public void setValidade(Date validade) {
        this.validade = validade;
    }

    public String getNomeTitular() {
        return nomeTitular;
    }

    public void setNomeTitular(String nomeTitular) {
        this.nomeTitular = nomeTitular;
    }

    public long getAgencia() {
        return agencia;
    }

    public void setAgencia(long agencia) {
        this.agencia = agencia;
    }

    public String getBandeira() {
        return bandeira;
    }

    public void setBandeira(String bandeira) {
        this.bandeira = bandeira;
    }
    
}
