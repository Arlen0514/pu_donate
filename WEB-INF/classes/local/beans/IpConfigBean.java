/**
 * IpConfigBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'ip_config'.
 */
public final class IpConfigBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "ip_config";

    // Fields variable definition.
    private String ic_id         = "";
    private String ic_ip         = "";
    private String ic_code       = "";
    private String ic_createdate = "";
    private String ic_createuser = "";
    private String ic_modifydate = "";
    private String ic_modifyuser = "";

    // Default constructor.
    public IpConfigBean() {}

    // Setters definitions
    public void setIc_id(String ic_id) {
        this.ic_id = ic_id;
    }

    public void setIc_ip(String ic_ip) {
        this.ic_ip = ic_ip;
    }

    public void setIc_code(String ic_code) {
        this.ic_code = ic_code;
    }

    public void setIc_createdate(String ic_createdate) {
        this.ic_createdate = ic_createdate;
    }

    public void setIc_createuser(String ic_createuser) {
        this.ic_createuser = ic_createuser;
    }

    public void setIc_modifydate(String ic_modifydate) {
        this.ic_modifydate = ic_modifydate;
    }

    public void setIc_modifyuser(String ic_modifyuser) {
        this.ic_modifyuser = ic_modifyuser;
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
        vc.add(ic_id);
        vc.add(ic_ip);
        vc.add(ic_code);
        vc.add(ic_createdate);
        vc.add(ic_createuser);
        vc.add(ic_modifydate);
        vc.add(ic_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getIc_id() {
        return ic_id;
    }

    public String getIc_ip() {
        return ic_ip;
    }

    public String getIc_code() {
        return ic_code;
    }

    public String getIc_createdate() {
        return ic_createdate;
    }

    public String getIc_createuser() {
        return ic_createuser;
    }

    public String getIc_modifydate() {
        return ic_modifydate;
    }

    public String getIc_modifyuser() {
        return ic_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ic_id", "ic_ip", "ic_code", "ic_createdate", 
        "ic_createuser", "ic_modifydate", "ic_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String" };
}
