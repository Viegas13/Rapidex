package DAO;

import entidades.Cliente;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.Scanner;
import jakarta.persistence.criteria.CriteriaQuery;
import java.util.List;

public class ClienteDAO {

    public void cadastrarProduto(Cliente cliente) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();
            entityManager.persist(cliente);
            entityManager.getTransaction().commit();

        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }
    }

    public void removerProduto(String CPF) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();

            Cliente cliente = entityManager.find(Cliente.class, CPF);

            if (cliente != null) {
                entityManager.remove(cliente);
            } else {
                System.out.println("Endereço não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }

    public void atualizarProduto(String CPF) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner(System.in);

        try {

            Cliente cliente = entityManager.find(Cliente.class, CPF);

            if (cliente != null) {

                cliente.setCPF(scan.next());
                cliente.setNome(scan.next());
                cliente.setEmail(scan.next());
                cliente.setSenha(scan.next());
                cliente.setTelefone(scan.nextLong());
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

        CriteriaQuery<Cliente> criteria = entityManager.getCriteriaBuilder().createQuery(Cliente.class);
        criteria.select(criteria.from(Cliente.class));

        List<Cliente> clientes = entityManager.createQuery(criteria).getResultList();

        for (Cliente cliente : clientes) {
            System.out.println("CPF: " + cliente.getCPF());
            System.out.println("Nome: " + cliente.getNome());
            System.out.println("Email: " + cliente.getEmail());
            System.out.println("Senha: " + cliente.getSenha());
            System.out.println("Número: " + cliente.getTelefone());
        }
        entityManager.close();
    }

}
