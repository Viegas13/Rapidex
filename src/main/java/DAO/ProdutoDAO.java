package DAO;

import entidades.Produto;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.Scanner;
import javax.persistence.criteria.CriteriaQuery;
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
            } else {
                System.out.println("Produto não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }
    
    public void atualizarProduto (long id) {
        
        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner (System.in);
        
        try {
            
            Produto produto = entityManager.find(Produto.class, id);
            
            if (produto != null) {
            
                produto.setId(scan.nextLong());
                produto.setImagem(scan.next());
                produto.setNome(scan.next());
                produto.setDescricao(scan.next());
                produto.setPreco(scan.nextDouble());
            }
            
        } catch (Exception ex) {
            
            entityManager.getTransaction().rollback();
            
        } finally {
            entityManager.close();
        }
        
    }
    
    public void listarProdutos () {
        
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
