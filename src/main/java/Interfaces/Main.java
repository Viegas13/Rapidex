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

                    System.out.println("Digite, respectivamente, o id do produto, o nome do produto,"
                            + " validade, preco, imagem, descrição e restrição de idade");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    Produto produto = new Produto(scan.nextLong(), scan.next(), scan.next(), scan.nextDouble(), scan.next(), scan.next(), scan.nextLong(), scan.next());

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
