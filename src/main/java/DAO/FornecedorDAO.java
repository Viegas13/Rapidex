package DAO;

import entidades.Fornecedor;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.Scanner;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class FornecedorDAO {

    public void cadastrarProduto(Fornecedor fornecedor) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();
            entityManager.persist(fornecedor);
            entityManager.getTransaction().commit();

        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }
    }

    public void removerProduto(String CNPJ) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();

            Fornecedor fornecedor = entityManager.find(Fornecedor.class, CNPJ);

            if (fornecedor != null) {
                entityManager.remove(fornecedor);
            } else {
                System.out.println("Fornecedor não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }

    public void atualizarProduto(String CNPJ) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner(System.in);

        try {

            Fornecedor fornecedor = entityManager.find(Fornecedor.class, CNPJ);

            if (fornecedor != null) {

                fornecedor.setNome(scan.next());
                fornecedor.setCNPJ(scan.next());
                fornecedor.setEmail(scan.next());
                fornecedor.setTelefone(scan.nextLong());

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

        CriteriaQuery<Fornecedor> criteria = entityManager.getCriteriaBuilder().createQuery(Fornecedor.class);
        criteria.select(criteria.from(Fornecedor.class));

        List<Fornecedor> fornecedores = entityManager.createQuery(criteria).getResultList();

        for (Fornecedor fornecedor : fornecedores) {
            System.out.println("Nome: " + fornecedor.getNome());
            System.out.println("CNPJ: " + fornecedor.getCNPJ());
            System.out.println("Email: " + fornecedor.getEmail());
            System.out.println("Telefone: " + fornecedor.getTelefone());
        }
        entityManager.close();
    }

}
