/**
 * DonateRecordBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/07/03 16:09:39
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'donate_record'.
 */
public final class DonateRecordBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "donate_record";

    // Fields variable definition.
    private String dr_id                   = "";
    private String dr_no                   = "";
    private String dh_id                   = "";
    private String dh_no                   = "";
    private String dr_status               = "";
    private String dr_donatedate           = "";
    private String dr_name                 = "";
    private String dr_identity             = "";
    private String dr_currency             = "";
    private int    dr_total                = 0;
    private String dr_donate_item_category = "";
    private String dr_donate_item          = "";
    private String dr_donate_item_title    = "";
    private String dr_code                 = "";
    private String dr_lang                 = "";
    private String dr_createdate           = "";
    private String dr_createuser           = "";
    private String dr_modifydate           = "";
    private String dr_modifyuser           = "";

    // Default constructor.
    public DonateRecordBean() {}

    // Setters definitions
    public void setDr_id(String dr_id) {
        this.dr_id = dr_id;
    }

    public void setDr_no(String dr_no) {
        this.dr_no = dr_no;
    }

    public void setDh_id(String dh_id) {
        this.dh_id = dh_id;
    }

    public void setDh_no(String dh_no) {
        this.dh_no = dh_no;
    }

    public void setDr_status(String dr_status) {
        this.dr_status = dr_status;
    }

    public void setDr_donatedate(String dr_donatedate) {
        this.dr_donatedate = dr_donatedate;
    }

    public void setDr_name(String dr_name) {
        this.dr_name = dr_name;
    }

    public void setDr_identity(String dr_identity) {
        this.dr_identity = dr_identity;
    }

    public void setDr_currency(String dr_currency) {
        this.dr_currency = dr_currency;
    }

    public void setDr_total(int dr_total) {
        this.dr_total = dr_total;
    }

    public void setDr_donate_item_category(String dr_donate_item_category) {
        this.dr_donate_item_category = dr_donate_item_category;
    }

    public void setDr_donate_item(String dr_donate_item) {
        this.dr_donate_item = dr_donate_item;
    }

    public void setDr_donate_item_title(String dr_donate_item_title) {
        this.dr_donate_item_title = dr_donate_item_title;
    }

    public void setDr_code(String dr_code) {
        this.dr_code = dr_code;
    }

    public void setDr_lang(String dr_lang) {
        this.dr_lang = dr_lang;
    }

    public void setDr_createdate(String dr_createdate) {
        this.dr_createdate = dr_createdate;
    }

    public void setDr_createuser(String dr_createuser) {
        this.dr_createuser = dr_createuser;
    }

    public void setDr_modifydate(String dr_modifydate) {
        this.dr_modifydate = dr_modifydate;
    }

    public void setDr_modifyuser(String dr_modifyuser) {
        this.dr_modifyuser = dr_modifyuser;
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
        vc.add(dr_id);
        vc.add(dr_no);
        vc.add(dh_id);
        vc.add(dh_no);
        vc.add(dr_status);
        vc.add(dr_donatedate);
        vc.add(dr_name);
        vc.add(dr_identity);
        vc.add(dr_currency);
        vc.add(new Integer(dr_total));
        vc.add(dr_donate_item_category);
        vc.add(dr_donate_item);
        vc.add(dr_donate_item_title);
        vc.add(dr_code);
        vc.add(dr_lang);
        vc.add(dr_createdate);
        vc.add(dr_createuser);
        vc.add(dr_modifydate);
        vc.add(dr_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getDr_id() {
        return dr_id;
    }

    public String getDr_no() {
        return dr_no;
    }

    public String getDh_id() {
        return dh_id;
    }

    public String getDh_no() {
        return dh_no;
    }

    public String getDr_status() {
        return dr_status;
    }

    public String getDr_donatedate() {
        return dr_donatedate;
    }

    public String getDr_name() {
        return dr_name;
    }

    public String getDr_identity() {
        return dr_identity;
    }

    public String getDr_currency() {
        return dr_currency;
    }

    public int getDr_total() {
        return dr_total;
    }

    public String getDr_donate_item_category() {
        return dr_donate_item_category;
    }

    public String getDr_donate_item() {
        return dr_donate_item;
    }

    public String getDr_donate_item_title() {
        return dr_donate_item_title;
    }

    public String getDr_code() {
        return dr_code;
    }

    public String getDr_lang() {
        return dr_lang;
    }

    public String getDr_createdate() {
        return dr_createdate;
    }

    public String getDr_createuser() {
        return dr_createuser;
    }

    public String getDr_modifydate() {
        return dr_modifydate;
    }

    public String getDr_modifyuser() {
        return dr_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "dr_id", "dr_no", "dh_id", "dh_no", 
        "dr_status", "dr_donatedate", "dr_name", "dr_identity", 
        "dr_currency", "dr_total", "dr_donate_item_category", "dr_donate_item", 
        "dr_donate_item_title", "dr_code", "dr_lang", "dr_createdate", 
        "dr_createuser", "dr_modifydate", "dr_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "int", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
