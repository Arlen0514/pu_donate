/**
 * AdminLogBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'admin_log'.
 */
public final class AdminLogBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "admin_log";

    // Fields variable definition.
    private String al_id         = "";
    private String al_logtype    = "";
    private String al_logdate    = "";
    private String al_remoteip   = "";
    private String au_id         = "";
    private String al_createdate = "";
    private String al_createuser = "";
    private String al_modifydate = "";
    private String al_modifyuser = "";

    // Default constructor.
    public AdminLogBean() {}

    // Setters definitions
    public void setAl_id(String al_id) {
        this.al_id = al_id;
    }

    public void setAl_logtype(String al_logtype) {
        this.al_logtype = al_logtype;
    }

    public void setAl_logdate(String al_logdate) {
        this.al_logdate = al_logdate;
    }

    public void setAl_remoteip(String al_remoteip) {
        this.al_remoteip = al_remoteip;
    }

    public void setAu_id(String au_id) {
        this.au_id = au_id;
    }

    public void setAl_createdate(String al_createdate) {
        this.al_createdate = al_createdate;
    }

    public void setAl_createuser(String al_createuser) {
        this.al_createuser = al_createuser;
    }

    public void setAl_modifydate(String al_modifydate) {
        this.al_modifydate = al_modifydate;
    }

    public void setAl_modifyuser(String al_modifyuser) {
        this.al_modifyuser = al_modifyuser;
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
        vc.add(al_id);
        vc.add(al_logtype);
        vc.add(al_logdate);
        vc.add(al_remoteip);
        vc.add(au_id);
        vc.add(al_createdate);
        vc.add(al_createuser);
        vc.add(al_modifydate);
        vc.add(al_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getAl_id() {
        return al_id;
    }

    public String getAl_logtype() {
        return al_logtype;
    }

    public String getAl_logdate() {
        return al_logdate;
    }

    public String getAl_remoteip() {
        return al_remoteip;
    }

    public String getAu_id() {
        return au_id;
    }

    public String getAl_createdate() {
        return al_createdate;
    }

    public String getAl_createuser() {
        return al_createuser;
    }

    public String getAl_modifydate() {
        return al_modifydate;
    }

    public String getAl_modifyuser() {
        return al_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "al_id", "al_logtype", "al_logdate", "al_remoteip", 
        "au_id", "al_createdate", "al_createuser", "al_modifydate", 
        "al_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String" };
}
