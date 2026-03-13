/**
 * AdminMapFunctionBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'admin_map_function'.
 */
public final class AdminMapFunctionBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "admin_map_function";

    // Fields variable definition.
    private String amf_id         = "";
    private String au_id          = "";
    private String mf_id          = "";
    private String amf_createdate = "";
    private String amf_createuser = "";

    // Default constructor.
    public AdminMapFunctionBean() {}

    // Setters definitions
    public void setAmf_id(String amf_id) {
        this.amf_id = amf_id;
    }

    public void setAu_id(String au_id) {
        this.au_id = au_id;
    }

    public void setMf_id(String mf_id) {
        this.mf_id = mf_id;
    }

    public void setAmf_createdate(String amf_createdate) {
        this.amf_createdate = amf_createdate;
    }

    public void setAmf_createuser(String amf_createuser) {
        this.amf_createuser = amf_createuser;
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
        vc.add(amf_id);
        vc.add(au_id);
        vc.add(mf_id);
        vc.add(amf_createdate);
        vc.add(amf_createuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getAmf_id() {
        return amf_id;
    }

    public String getAu_id() {
        return au_id;
    }

    public String getMf_id() {
        return mf_id;
    }

    public String getAmf_createdate() {
        return amf_createdate;
    }

    public String getAmf_createuser() {
        return amf_createuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "amf_id", "au_id", "mf_id", "amf_createdate", 
        "amf_createuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String" };
}
