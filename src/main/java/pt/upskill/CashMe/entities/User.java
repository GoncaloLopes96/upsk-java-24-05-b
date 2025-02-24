package pt.upskill.CashMe.entities;

import jakarta.persistence.*;
import pt.upskill.CashMe.models.SignUpModel;

@Entity
@Table(name = "users") // Mapeia explicitamente para a tabela "user"
public class User {

    @Id
    @GeneratedValue
    private Long id;

    private boolean admin;

    private String name;
    @Column(nullable = false, unique = true)
    private String username;
    @Column(nullable = false)
    private String password;

    @ManyToOne
    private Store currentStore;

    // Construtor vazio necessário para JPA
    public User() {}

    public User(SignUpModel model) {
        this.name = model.getName();
        this.username = model.getUsername();
        this.password = model.getPassword(); //encriptar aqui!
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Column(nullable = false)
    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public Store getCurrentStore() {
        return currentStore;
    }

    public void setCurrentStore(Store currentStore) {
        this.currentStore = currentStore;
    }
}