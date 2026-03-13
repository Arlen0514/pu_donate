/**
 * AdminUserBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'admin_user'.
 */
public final class AdminUserBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "admin_user";

    // Fields variable definition.
    private String au_id         = "";
    private String au_account    = "";
    private String au_name       = "";
    private String au_password   = "";
    private String au_email      = "";
    private String au_createdate = "";
    private String au_createuser = "";
    private String au_modifydate = "";
    private String au_modifyuser = "";

    // Default constructor.
    public AdminUserBean() {}

    // Setters definitions
    public void setAu_id(String au_id) {
        this.au_id = au_id;
    }

    public void setAu_account(String au_account) {
        this.au_account = au_account;
    }

    public void setAu_name(String au_name) {
        this.au_name = au_name;
    }

    public void setAu_password(String au_password) {
        this.au_password = au_password;
    }

    public void setAu_email(String au_email) {
        this.au_email = au_email;
    }

    public void setAu_createdate(String au_createdate) {
        this.au_createdate = au_createdate;
    }

    public void setAu_createuser(String au_createuser) {
        this.au_createuser = au_createuser;
    }

    public void setAu_modifydate(String au_modifydate) {
        this.au_modifydate = au_modifydate;
    }

    public void setAu_modifyuser(String au_modifyuser) {
        this.au_modifyuser = au_modifyuser;
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
        vc.add(au_id);
        vc.add(au_account);
        vc.add(au_name);
        vc.add(au_password);
        vc.add(au_email);
        vc.add(au_createdate);
        vc.add(au_createuser);
        vc.add(au_modifydate);
        vc.add(au_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getAu_id() {
        return au_id;
    }

    public String getAu_account() {
        return au_account;
    }

    public String getAu_name() {
        return au_name;
    }

    public String getAu_password() {
        return au_password;
    }

    public String getAu_email() {
        return au_email;
    }

    public String getAu_createdate() {
        return au_createdate;
    }

    public String getAu_createuser() {
        return au_createuser;
    }

    public String getAu_modifydate() {
        return au_modifydate;
    }

    public String getAu_modifyuser() {
        return au_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "au_id", "au_account", "au_name", "au_password", 
        "au_email", "au_createdate", "au_createuser", "au_modifydate", 
        "au_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String" };
}
