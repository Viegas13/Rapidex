package DAO;

import entidades.Produto;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.Scanner;
import jakarta.persistence.criteria.CriteriaQuery;
import java.util.List;

public class ProdutoDAO {

    public void cadastrarProduto(Produto produto) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();
            entityManager.persist(produto);
            entityManager.getTransaction().commit();

        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }
    }

    public void removerProduto(long id) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();

            Produto produto = entityManager.find(Produto.class, id);

            if (produto != null) {
                entityManager.remove(produto);
                entityManager.getTransaction().commit();
            } else {
                System.out.println("Produto não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }

    public void atualizarProduto(long id) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner(System.in);

        try {

            Produto produto = entityManager.find(Produto.class, id);

            if (produto != null) {

                System.out.println("Insira a nova url de imagem:");
                produto.setImagem(scan.next());
                System.out.println("Insira o novo nome:");
                produto.setNome(scan.next());
                System.out.println("Insira o nova descrição:");
                produto.setDescricao(scan.next());
                System.out.println("Insira o novo preço:");
                produto.setPreco(scan.nextDouble());
                
                entityManager.getTransaction().begin();
                entityManager.persist(produto);
                entityManager.getTransaction().commit();
            }

        } catch (Exception ex) {

            entityManager.getTransaction().rollback();

        } finally {
            entityManager.close();
        }

    }

    public void listarProdutos() {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        CriteriaQuery<Produto> criteria = entityManager.getCriteriaBuilder().createQuery(Produto.class);
        criteria.select(criteria.from(Produto.class));

        List<Produto> produtos = entityManager.createQuery(criteria).getResultList();

        for (Produto produto : produtos) {
            System.out.println("Nome: " + produto.getNome());
            System.out.println("ID: " + produto.getId());
            System.out.println("Descrição: " + produto.getDescricao());
            System.out.println("Preco: " + produto.getPreco());
        }
        entityManager.close();
    }

}
