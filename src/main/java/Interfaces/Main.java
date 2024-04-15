package Interfaces;

import java.text.ParseException;
import java.util.Scanner;
import DAO.ProdutoDAO;
import entidades.Produto;
import java.util.Date;

public class Main {

    public static void main(String args[]) {

        Scanner scan = new Scanner(System.in);
        ProdutoDAO produtoDAO;
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
                    
                    try {
                    System.out.println("Digite, respectivamente, o id do produto, o nome do produto,"
                            + " validade, preco, imagem, descrição e restrição de idade");

                    Produto produto = new Produto(scan.nextLong(), scan.next(), data, scan.nextDouble(), scan.next(), scan.next(), scan.nextBoolean());

                    ProdutoDAO.listarProdutos();

                } catch (ParseException ex) {
                    System.out.println(ex.toString());
                }
                break;

                case 3:
                    

                case 4:
                    System.out.println("Digite o Id do Produto: ");
                    ProdutoDAO.removerProduto(scan.nextLong());
                    break;

            }

        } while (opcao != 5);

    }

}
