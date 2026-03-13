/**
 * ReceiptListBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/08/15 11:07:19
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'receipt_list'.
 */
public final class ReceiptListBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "receipt_list";

    // Fields variable definition.
    private String rl_id         = "";
    private String rs_no         = "";
    private String dh_id         = "";
    private String dh_no         = "";
    private String dh_name       = "";
    private String dh_order_name = "";
    private String dh_pid        = "";
    private String dh_compid     = "";
    private int    dh_total      = 0;
    private String dh_total_cn   = "";
    private String dh_paymethod  = "";
    private String dh_receipt    = "";
    private String rl_donateitem = "";
    private String rl_code       = "";
    private String rl_lang       = "";
    private String rl_createdate = "";
    private String rl_createuser = "";
    private String rl_modifydate = "";
    private String rl_modifyuser = "";

    // Default constructor.
    public ReceiptListBean() {}

    // Setters definitions
    public void setRl_id(String rl_id) {
        this.rl_id = rl_id;
    }

    public void setRs_no(String rs_no) {
        this.rs_no = rs_no;
    }

    public void setDh_id(String dh_id) {
        this.dh_id = dh_id;
    }

    public void setDh_no(String dh_no) {
        this.dh_no = dh_no;
    }

    public void setDh_name(String dh_name) {
        this.dh_name = dh_name;
    }

    public void setDh_order_name(String dh_order_name) {
        this.dh_order_name = dh_order_name;
    }

    public void setDh_pid(String dh_pid) {
        this.dh_pid = dh_pid;
    }

    public void setDh_compid(String dh_compid) {
        this.dh_compid = dh_compid;
    }

    public void setDh_total(int dh_total) {
        this.dh_total = dh_total;
    }

    public void setDh_total_cn(String dh_total_cn) {
        this.dh_total_cn = dh_total_cn;
    }

    public void setDh_paymethod(String dh_paymethod) {
        this.dh_paymethod = dh_paymethod;
    }

    public void setDh_receipt(String dh_receipt) {
        this.dh_receipt = dh_receipt;
    }

    public void setRl_donateitem(String rl_donateitem) {
        this.rl_donateitem = rl_donateitem;
    }

    public void setRl_code(String rl_code) {
        this.rl_code = rl_code;
    }

    public void setRl_lang(String rl_lang) {
        this.rl_lang = rl_lang;
    }

    public void setRl_createdate(String rl_createdate) {
        this.rl_createdate = rl_createdate;
    }

    public void setRl_createuser(String rl_createuser) {
        this.rl_createuser = rl_createuser;
    }

    public void setRl_modifydate(String rl_modifydate) {
        this.rl_modifydate = rl_modifydate;
    }

    public void setRl_modifyuser(String rl_modifyuser) {
        this.rl_modifyuser = rl_modifyuser;
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
        vc.add(rl_id);
        vc.add(rs_no);
        vc.add(dh_id);
        vc.add(dh_no);
        vc.add(dh_name);
        vc.add(dh_order_name);
        vc.add(dh_pid);
        vc.add(dh_compid);
        vc.add(new Integer(dh_total));
        vc.add(dh_total_cn);
        vc.add(dh_paymethod);
        vc.add(dh_receipt);
        vc.add(rl_donateitem);
        vc.add(rl_code);
        vc.add(rl_lang);
        vc.add(rl_createdate);
        vc.add(rl_createuser);
        vc.add(rl_modifydate);
        vc.add(rl_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getRl_id() {
        return rl_id;
    }

    public String getRs_no() {
        return rs_no;
    }

    public String getDh_id() {
        return dh_id;
    }

    public String getDh_no() {
        return dh_no;
    }

    public String getDh_name() {
        return dh_name;
    }

    public String getDh_order_name() {
        return dh_order_name;
    }

    public String getDh_pid() {
        return dh_pid;
    }

    public String getDh_compid() {
        return dh_compid;
    }

    public int getDh_total() {
        return dh_total;
    }

    public String getDh_total_cn() {
        return dh_total_cn;
    }

    public String getDh_paymethod() {
        return dh_paymethod;
    }

    public String getDh_receipt() {
        return dh_receipt;
    }

    public String getRl_donateitem() {
        return rl_donateitem;
    }

    public String getRl_code() {
        return rl_code;
    }

    public String getRl_lang() {
        return rl_lang;
    }

    public String getRl_createdate() {
        return rl_createdate;
    }

    public String getRl_createuser() {
        return rl_createuser;
    }

    public String getRl_modifydate() {
        return rl_modifydate;
    }

    public String getRl_modifyuser() {
        return rl_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "rl_id", "rs_no", "dh_id", "dh_no", 
        "dh_name", "dh_order_name", "dh_pid", "dh_compid", 
        "dh_total", "dh_total_cn", "dh_paymethod", "dh_receipt", 
        "rl_donateitem", "rl_code", "rl_lang", "rl_createdate", 
        "rl_createuser", "rl_modifydate", "rl_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "int", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
