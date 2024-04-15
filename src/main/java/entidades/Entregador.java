package entidades;

import java.util.ArrayList;
import java.util.Date;

public class Entregador extends Pessoa {

    private String tipoVeiculo;
    private String marcaVeiculo;
    private String placaVeiculo;
    private long numeroCNH;
    private ArrayList<Entrega> entregas;

    public Entregador(String tipoVeiculo, String marcaVeiculo, String placaVeiculo, long numeroCNH, ArrayList<Entrega> entregas, Date data) {
        super("a", "56567", "senha", "email", 5656685, data);
        this.tipoVeiculo = tipoVeiculo;
        this.marcaVeiculo = marcaVeiculo;
        this.placaVeiculo = placaVeiculo;
        this.numeroCNH = numeroCNH;
        this.entregas = entregas;
    }

    public String getTipoVeiculo() {
        return tipoVeiculo;
    }

    public void setTipoVeiculo(String tipoVeiculo) {
        this.tipoVeiculo = tipoVeiculo;
    }

    public String getMarcaVeiculo() {
        return marcaVeiculo;
    }

    public void setMarcaVeiculo(String marcaVeiculo) {
        this.marcaVeiculo = marcaVeiculo;
    }

    public String getPlacaVeiculo() {
        return placaVeiculo;
    }

    public void setPlacaVeiculo(String placaVeiculo) {
        this.placaVeiculo = placaVeiculo;
    }

    public long getNumeroCNH() {
        return numeroCNH;
    }

    public void setNumeroCNH(long numeroCNH) {
        this.numeroCNH = numeroCNH;
    }

    public ArrayList<Entrega> getEntregas() {
        return entregas;
    }

    public void setEntregas(ArrayList<Entrega> entregas) {
        this.entregas = entregas;
    }

}
