package entidades;

import java.util.ArrayList;
import java.util.Date;

public class Cliente extends Pessoa{
    
    private ArrayList<Cartao> cartoes;
    public Cliente(String nome, String CPF, String senha, String email, long telefone, ArrayList<Cartao> cartoes, Date data) {
        super(nome, CPF, senha, email, telefone,data);
        this.cartoes = cartoes;
    }

    public ArrayList<Cartao> getCartoes() {
        return cartoes;
    }

    public void setCartoes(ArrayList<Cartao> cartoes) {
        this.cartoes = cartoes;
    }

    public int getCliente_id() {
        return cliente_id;
    }
}
