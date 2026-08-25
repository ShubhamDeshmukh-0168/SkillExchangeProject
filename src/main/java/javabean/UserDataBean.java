package javabean;

import java.io.InputStream;
import java.io.Serializable;

/**
 * JavaBean Class for storing and accessing user data
 */
@SuppressWarnings("serial")
public class UserDataBean implements Serializable {

    // User personal details
    private String fname;
    private String lname;

    // Credentials
    private String username;
    private String pass;

    // Contact and identification
    private String email;
    private long phno;

    // Skills
    private String skillToTeach;
    private String skillToLearn;

    // Other info
    private int rating;
    private InputStream image;

    // No-arg constructor
    public UserDataBean() {}

    // Getters and Setters
    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getPhno() {
        return phno;
    }

    public void setPhno(long phno) {
        this.phno = phno;
    }

    public String getSkillToTeach() {
        return skillToTeach;
    }

    public void setSkillToTeach(String skillToTeach) {
        this.skillToTeach = skillToTeach;
    }

    public String getSkillToLearn() {
        return skillToLearn;
    }

    public void setSkillToLearn(String skillToLearn) {
        this.skillToLearn = skillToLearn;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public InputStream getImage() {
        return image;
    }

    public void setImage(InputStream image) {
        this.image = image;
    }
}
