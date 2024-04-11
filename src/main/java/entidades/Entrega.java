package entidades;

import java.util.ArrayList;

public class Entrega {

    private Pedido pedido;
    private Entregador entregador;
    private boolean pendente;
    private Endereco enderecoEntrega;
    private double frete;

    public Entrega(Pedido pedido, Entregador entregador, boolean pendente, Endereco enderecoEntrega, double frete) {
        this.pedido = pedido;
        this.entregador = entregador;
        this.pendente = pendente;
        this.enderecoEntrega = enderecoEntrega;
        this.frete = frete;
    }

    public Pedido getPedido() {
        return pedido;
    }

    public void setPedido(Pedido pedido) {
        this.pedido = pedido;
    }

    public Entregador getEntregador() {
        return entregador;
    }

    public void setEntregador(Entregador entregador) {
        this.entregador = entregador;
    }

    public boolean isPendente() {
        return pendente;
    }

    public void setPendente(boolean pendente) {
        this.pendente = pendente;
    }

    public Endereco getEnderecoEntrega() {
        return enderecoEntrega;
    }

    public void setEnderecoEntrega(Endereco enderecoEntrega) {
        this.enderecoEntrega = enderecoEntrega;
    }

    public double getFrete() {
        return frete;
    }

    public void setFrete(double frete) {
        this.frete = frete;
    }
    
    
    
}
