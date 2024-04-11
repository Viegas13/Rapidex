package entidades;

public class Endereco {
    
    private String bairro;
    private String rua;
    private int numero;
    private long CEP;
    private String complemento;

    public Endereco(String bairro, String rua, int numero, long CEP, String complemento) {
        this.bairro = bairro;
        this.rua = rua;
        this.numero = numero;
        this.CEP = CEP;
        this.complemento = complemento;
    }

    public String getBairro() {
        return bairro;
    }

    public void setBairro(String bairro) {
        this.bairro = bairro;
    }

    public String getRua() {
        return rua;
    }

    public void setRua(String rua) {
        this.rua = rua;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public long getCEP() {
        return CEP;
    }

    public void setCEP(long CEP) {
        this.CEP = CEP;
    }

    public String getComplemento() {
        return complemento;
    }

    public void setComplemento(String complemento) {
        this.complemento = complemento;
    }
    
}
