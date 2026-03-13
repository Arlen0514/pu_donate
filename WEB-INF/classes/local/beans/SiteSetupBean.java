/**
 * SiteSetupBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'site_setup'.
 */
public final class SiteSetupBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "site_setup";

    // Fields variable definition.
    private String ss_id         = "";
    private String ss_title      = "";
    private String ss_keyword    = "";
    private String ss_value      = "";
    private String ss_text       = "";
    private String ss_createdate = "";
    private String ss_createuser = "";
    private String ss_modifydate = "";
    private String ss_modifyuser = "";

    // Default constructor.
    public SiteSetupBean() {}

    // Setters definitions
    public void setSs_id(String ss_id) {
        this.ss_id = ss_id;
    }

    public void setSs_title(String ss_title) {
        this.ss_title = ss_title;
    }

    public void setSs_keyword(String ss_keyword) {
        this.ss_keyword = ss_keyword;
    }

    public void setSs_value(String ss_value) {
        this.ss_value = ss_value;
    }

    public void setSs_text(String ss_text) {
        this.ss_text = ss_text;
    }

    public void setSs_createdate(String ss_createdate) {
        this.ss_createdate = ss_createdate;
    }

    public void setSs_createuser(String ss_createuser) {
        this.ss_createuser = ss_createuser;
    }

    public void setSs_modifydate(String ss_modifydate) {
        this.ss_modifydate = ss_modifydate;
    }

    public void setSs_modifyuser(String ss_modifyuser) {
        this.ss_modifyuser = ss_modifyuser;
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
        vc.add(ss_id);
        vc.add(ss_title);
        vc.add(ss_keyword);
        vc.add(ss_value);
        vc.add(ss_text);
        vc.add(ss_createdate);
        vc.add(ss_createuser);
        vc.add(ss_modifydate);
        vc.add(ss_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getSs_id() {
        return ss_id;
    }

    public String getSs_title() {
        return ss_title;
    }

    public String getSs_keyword() {
        return ss_keyword;
    }

    public String getSs_value() {
        return ss_value;
    }

    public String getSs_text() {
        return ss_text;
    }

    public String getSs_createdate() {
        return ss_createdate;
    }

    public String getSs_createuser() {
        return ss_createuser;
    }

    public String getSs_modifydate() {
        return ss_modifydate;
    }

    public String getSs_modifyuser() {
        return ss_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ss_id", "ss_title", "ss_keyword", "ss_value", 
        "ss_text", "ss_createdate", "ss_createuser", "ss_modifydate", 
        "ss_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String" };
}
