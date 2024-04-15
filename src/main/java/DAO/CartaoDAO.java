package DAO;

import entidades.*;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.text.SimpleDateFormat;
import java.util.Scanner;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class CartaoDAO {

    public void cadastrarCartao(Cartao cartao) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();
            entityManager.persist(cartao);
            entityManager.getTransaction().commit();

        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }
    }

    public void removerCartao(long numero) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        try {
            entityManager.getTransaction().begin();

            Cartao cartao = entityManager.find(Cartao.class, numero);

            if (cartao != null) {
                entityManager.remove(cartao);
            } else {
                System.out.println("Cartao não cadastrado no sistema");
            }
        } catch (Exception ex) {
            entityManager.getTransaction().rollback();
        } finally {
            entityManager.close();
        }

    }

    public void atualizarCartao(long numero) {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Scanner scan = new Scanner(System.in);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        try {

            Cartao cartao = entityManager.find(Cartao.class, numero);

            if (cartao != null) {
                cartao.setAgencia(scan.nextLong());
                cartao.setCvv(scan.nextInt());
                cartao.setBandeira(scan.next());
                cartao.setValidade(sdf.parse(scan.next()));
                cartao.setNomeTitular(scan.next());
                cartao.setNumero(scan.nextLong());
            }

        } catch (Exception ex) {

            entityManager.getTransaction().rollback();

        } finally {
            entityManager.close();
        }

    }

    public void listarCartoes() {

        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("persistence");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        CriteriaQuery<Cartao> criteria = entityManager.getCriteriaBuilder().createQuery(Cartao.class);
        criteria.select(criteria.from(Cartao.class));

        List<Cartao> cartoes = entityManager.createQuery(criteria).getResultList();

        for (Cartao cartao : cartoes) {
            System.out.println("Bandeira: " + cartao.getBandeira());
            System.out.println("Nome do Titular: " + cartao.getNomeTitular());
            System.out.println("Agencia: " + cartao.getAgencia());
            System.out.println("Cvv: " + cartao.getCvv());
            System.out.println("Validade: " + cartao.getValidade());
            System.out.println("numero: " + cartao.getNumero());
        }
        entityManager.close();
    }

}
