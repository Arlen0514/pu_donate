/**
 * NumberKeeperBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'number_keeper'.
 */
public final class NumberKeeperBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "number_keeper";

    // Fields variable definition.
    private String nk_id         = "";
    private String nk_type       = "";
    private String nk_prefix     = "";
    private int    nk_sequence   = 0;
    private String nk_createdate = "";
    private String nk_createuser = "";
    private String nk_modifydate = "";
    private String nk_modifyuser = "";

    // Default constructor.
    public NumberKeeperBean() {}

    // Setters definitions
    public void setNk_id(String nk_id) {
        this.nk_id = nk_id;
    }

    public void setNk_type(String nk_type) {
        this.nk_type = nk_type;
    }

    public void setNk_prefix(String nk_prefix) {
        this.nk_prefix = nk_prefix;
    }

    public void setNk_sequence(int nk_sequence) {
        this.nk_sequence = nk_sequence;
    }

    public void setNk_createdate(String nk_createdate) {
        this.nk_createdate = nk_createdate;
    }

    public void setNk_createuser(String nk_createuser) {
        this.nk_createuser = nk_createuser;
    }

    public void setNk_modifydate(String nk_modifydate) {
        this.nk_modifydate = nk_modifydate;
    }

    public void setNk_modifyuser(String nk_modifyuser) {
        this.nk_modifyuser = nk_modifyuser;
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
        vc.add(nk_id);
        vc.add(nk_type);
        vc.add(nk_prefix);
        vc.add(new Integer(nk_sequence));
        vc.add(nk_createdate);
        vc.add(nk_createuser);
        vc.add(nk_modifydate);
        vc.add(nk_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getNk_id() {
        return nk_id;
    }

    public String getNk_type() {
        return nk_type;
    }

    public String getNk_prefix() {
        return nk_prefix;
    }

    public int getNk_sequence() {
        return nk_sequence;
    }

    public String getNk_createdate() {
        return nk_createdate;
    }

    public String getNk_createuser() {
        return nk_createuser;
    }

    public String getNk_modifydate() {
        return nk_modifydate;
    }

    public String getNk_modifyuser() {
        return nk_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "nk_id", "nk_type", "nk_prefix", "nk_sequence", 
        "nk_createdate", "nk_createuser", "nk_modifydate", "nk_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "int", "String", "String", "String", 
        "String" };
}
