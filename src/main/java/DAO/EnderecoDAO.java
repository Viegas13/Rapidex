package DAO;

import entidades.Endereco;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.Scanner;
import jakarta.persistence.criteria.CriteriaQuery;
import java.util.List;

public class EnderecoDAO {

    public void cadastrarProduto(Endereco endereco) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();
            entityManager.persist(endereco);
            entityManager.getTransaction().commit();

        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }
    }

    public void removerProduto(String CEP) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();

            Endereco endereco = entityManager.find(Endereco.class, CEP);

            if (endereco != null) {
                entityManager.remove(endereco);
            } else {
                System.out.println("Endereço não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }

    public void atualizarProduto(String CEP) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner(System.in);

        try {

            Endereco endereco = entityManager.find(Endereco.class, CEP);

            if (endereco != null) {

                endereco.setPessoa_cpf(scan.next());
                endereco.setCEP(scan.nextByte());
                endereco.setBairro(scan.next());
                endereco.setRua(scan.next());
                endereco.setNumero(scan.nextInt());
                endereco.setComplemento(scan.next());
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

        CriteriaQuery<Endereco> criteria = entityManager.getCriteriaBuilder().createQuery(Endereco.class);
        criteria.select(criteria.from(Endereco.class));

        List<Endereco> enderecos = entityManager.createQuery(criteria).getResultList();

        for (Endereco endereco : enderecos) {
            System.out.println("CPF titular: " + endereco.getPessoa_cpf());
            System.out.println("CEP: " + endereco.getCEP());
            System.out.println("Bairro: " + endereco.getBairro());
            System.out.println("Rua: " + endereco.getRua());
            System.out.println("Número: " + endereco.getNumero());
            System.out.println("Complemento: " + endereco.getComplemento());
        }
        entityManager.close();
    }
}
