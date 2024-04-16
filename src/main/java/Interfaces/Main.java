package Interfaces;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Scanner;
import DAO.*;
import entidades.*;
import java.util.Date;

public class Main {

    public static void main(String args[]) throws ParseException {

        Scanner scan = new Scanner(System.in);
        ProdutoDAO produtoDAO = new ProdutoDAO();
        Date data = new Date();

        int opcao = 0;

        do {
            System.out.println("Sistema de Gerenciamento de Produtos");
            System.out.println(" Digite:\n"
                    + " 1 - Listar Produtos\n"
                    + " 2 - Para Cadastrar Produto\n"
                    + " 3 - Atualizar Produto\n"
                    + " 4 - Excluir Produto\n"
                    + " 5 - Para Sair\n");
            opcao = scan.nextInt();

            switch (opcao) {

                case 1:
                    produtoDAO.listarProdutos();
                    break;
                case 2:

                    Produto produto = new Produto();
                    System.out.println("Digite o id do produto");
                    produto.setId(scan.nextLong());
                    System.out.println("Digite o nome do produto");
                    produto.setNome(scan.next());
                    System.out.println("Sua validade");
                    produto.setValidade(scan.next());
                    System.out.println("O preço");
                    produto.setPreco(scan.nextDouble());
                    System.out.println("A URL do imagem");
                    produto.setImagem(scan.next());
                    System.out.println("A descrição");
                    produto.setDescricao(scan.next());
                    System.out.println("Informe o CNPJ do fornecedor");
                    produto.setFornecedor(scan.nextLong());
                    System.out.println("Restrição por idade (sim ou nao)");
                    produto.setRestritoPorIdade(scan.next());         
                    produtoDAO.cadastrarProduto(produto);

                    break;

                case 3:
                    System.out.println("Digite o Id do Produto: ");
                    produtoDAO.atualizarProduto(scan.nextLong());
                    break;

                case 4:
                    System.out.println("Digite o Id do Produto: ");
                    produtoDAO.removerProduto(scan.nextLong());
                    break;

            }

        } while (opcao != 5);

    }

}
