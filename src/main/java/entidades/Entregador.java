package entidades;

import java.util.ArrayList;
import java.util.Date;

public class Entregador extends Pessoa{


    private String veiculo;
    private ArrayList<Entrega> entregas;
    
    public Entregador(String veiculo, ArrayList<Entrega> entregas, Date data) {
        super("a", "56567", "senha", "email", 5656685, data);
        this.veiculo = veiculo;
        this.entregas = entregas;
    }

    public String getVeiculo() {
        return veiculo;
    }

    public void setVeiculo(String veiculo) {
        this.veiculo = veiculo;
    }

    public ArrayList<Entrega> getEntregas() {
        return entregas;
    }

    public void setEntregas(ArrayList<Entrega> entregas) {
        this.entregas = entregas;
    }
    
}
