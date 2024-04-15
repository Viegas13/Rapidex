package entidades;

import java.util.ArrayList;

public class Pedido {

    private long pedido_id;
    private Cliente cliente;
    private Fornecedor fornecedor;
    private ArrayList<Produto> produtos;
    private double preco;

    public Pedido(Cliente cliente, Fornecedor fornecedor, ArrayList<Produto> produtos, double preco) {
        this.cliente = cliente;
        this.fornecedor = fornecedor;
        this.produtos = produtos;
        this.preco = preco;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public Fornecedor getFornecedor() {
        return fornecedor;
    }

    public void setFornecedor(Fornecedor fornecedor) {
        this.fornecedor = fornecedor;
    }

    public ArrayList<Produto> getProdutos() {
        return produtos;
    }

    public void setProdutos(ArrayList<Produto> produtos) {
        this.produtos = produtos;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public long getPedido_id() {
        return pedido_id;
    }

    public void setPedido_id(long pedido_id) {
        this.pedido_id = pedido_id;
    }
}
