/**
 * FileDetailBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/08/29 18:00:13
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'file_detail'.
 */
public final class FileDetailBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "file_detail";

    // Fields variable definition.
    private String fd_id         = "";
    private String fk_id         = "";
    private String fd_upcategory = "";
    private String fd_category   = "";
    private String fd_title      = "";
    private String fd_file       = "";
    private String fd_file_type  = "";
    private String fd_image      = "";
    private String fd_video      = "";
    private String fd_chinavideo = "";
    private String fd_content    = "";
    private String fd_url        = "";
    private String fd_target     = "";
    private String fd_display    = "";
    private String fd_lang       = "";
    private String fd_code       = "";
    private int    fd_showseq    = 0;
    private String fd_createdate = "";
    private String fd_createuser = "";
    private String fd_modifydate = "";
    private String fd_modifyuser = "";

    // Default constructor.
    public FileDetailBean() {}

    // Setters definitions
    public void setFd_id(String fd_id) {
        this.fd_id = fd_id;
    }

    public void setFk_id(String fk_id) {
        this.fk_id = fk_id;
    }

    public void setFd_upcategory(String fd_upcategory) {
        this.fd_upcategory = fd_upcategory;
    }

    public void setFd_category(String fd_category) {
        this.fd_category = fd_category;
    }

    public void setFd_title(String fd_title) {
        this.fd_title = fd_title;
    }

    public void setFd_file(String fd_file) {
        this.fd_file = fd_file;
    }

    public void setFd_file_type(String fd_file_type) {
        this.fd_file_type = fd_file_type;
    }

    public void setFd_image(String fd_image) {
        this.fd_image = fd_image;
    }

    public void setFd_video(String fd_video) {
        this.fd_video = fd_video;
    }

    public void setFd_chinavideo(String fd_chinavideo) {
        this.fd_chinavideo = fd_chinavideo;
    }

    public void setFd_content(String fd_content) {
        this.fd_content = fd_content;
    }

    public void setFd_url(String fd_url) {
        this.fd_url = fd_url;
    }

    public void setFd_target(String fd_target) {
        this.fd_target = fd_target;
    }

    public void setFd_display(String fd_display) {
        this.fd_display = fd_display;
    }

    public void setFd_lang(String fd_lang) {
        this.fd_lang = fd_lang;
    }

    public void setFd_code(String fd_code) {
        this.fd_code = fd_code;
    }

    public void setFd_showseq(int fd_showseq) {
        this.fd_showseq = fd_showseq;
    }

    public void setFd_createdate(String fd_createdate) {
        this.fd_createdate = fd_createdate;
    }

    public void setFd_createuser(String fd_createuser) {
        this.fd_createuser = fd_createuser;
    }

    public void setFd_modifydate(String fd_modifydate) {
        this.fd_modifydate = fd_modifydate;
    }

    public void setFd_modifyuser(String fd_modifyuser) {
        this.fd_modifyuser = fd_modifyuser;
    }

    // Convert the fields name, type, value into a Vector.
    public Vector beanContent() {
        Vector content = new Vector();
        // Field names.
        content.add(_fnames);
        // Field java types.
        content.add(_ftypes);
        // Field values.
        Vector vc = new Vector();
        vc.add(fd_id);
        vc.add(fk_id);
        vc.add(fd_upcategory);
        vc.add(fd_category);
        vc.add(fd_title);
        vc.add(fd_file);
        vc.add(fd_file_type);
        vc.add(fd_image);
        vc.add(fd_video);
        vc.add(fd_chinavideo);
        vc.add(fd_content);
        vc.add(fd_url);
        vc.add(fd_target);
        vc.add(fd_display);
        vc.add(fd_lang);
        vc.add(fd_code);
        vc.add(new Integer(fd_showseq));
        vc.add(fd_createdate);
        vc.add(fd_createuser);
        vc.add(fd_modifydate);
        vc.add(fd_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getFd_id() {
        return fd_id;
    }

    public String getFk_id() {
        return fk_id;
    }

    public String getFd_upcategory() {
        return fd_upcategory;
    }

    public String getFd_category() {
        return fd_category;
    }

    public String getFd_title() {
        return fd_title;
    }

    public String getFd_file() {
        return fd_file;
    }

    public String getFd_file_type() {
        return fd_file_type;
    }

    public String getFd_image() {
        return fd_image;
    }

    public String getFd_video() {
        return fd_video;
    }

    public String getFd_chinavideo() {
        return fd_chinavideo;
    }

    public String getFd_content() {
        return fd_content;
    }

    public String getFd_url() {
        return fd_url;
    }

    public String getFd_target() {
        return fd_target;
    }

    public String getFd_display() {
        return fd_display;
    }

    public String getFd_lang() {
        return fd_lang;
    }

    public String getFd_code() {
        return fd_code;
    }

    public int getFd_showseq() {
        return fd_showseq;
    }

    public String getFd_createdate() {
        return fd_createdate;
    }

    public String getFd_createuser() {
        return fd_createuser;
    }

    public String getFd_modifydate() {
        return fd_modifydate;
    }

    public String getFd_modifyuser() {
        return fd_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "fd_id", "fk_id", "fd_upcategory", "fd_category", 
        "fd_title", "fd_file", "fd_file_type", "fd_image", 
        "fd_video", "fd_chinavideo", "fd_content", "fd_url", 
        "fd_target", "fd_display", "fd_lang", "fd_code", 
        "fd_showseq", "fd_createdate", "fd_createuser", "fd_modifydate", 
        "fd_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "int", "String", "String", "String", "String" };
}
