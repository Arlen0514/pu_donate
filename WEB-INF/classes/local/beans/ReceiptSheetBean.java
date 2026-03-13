/**
 * ReceiptSheetBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/09/26 16:48:36
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'receipt_sheet'.
 */
public final class ReceiptSheetBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "receipt_sheet";

    // Fields variable definition.
    private String rs_id             = "";
    private String rs_no             = "";
    private String rs_print          = "";
    private String rs_multi          = "";
    private String rs_status         = "";
    private String dh_id             = "";
    private String dh_no             = "";
    private String dh_order_name     = "";
    private String dh_pid            = "";
    private String dh_compid         = "";
    private int    dh_total          = 0;
    private String dh_total_cn       = "";
    private String dh_receipt        = "";
    private String dh_order_county   = "";
    private String dh_order_city     = "";
    private String dh_order_zip_code = "";
    private String dh_order_address  = "";
    private String rs_donateitem     = "";
    private String rs_handle         = "";
    private String rs_stamp          = "";
    private String rs_stamp2         = "";
    private String rs_stamp3         = "";
    private String rs_stamp4         = "";
    private String rs_date           = "";
    private String rs_type           = "";
    private String rs_code           = "";
    private String rs_lang           = "";
    private String dh_donatedate     = "";
    private String rs_createdate     = "";
    private String rs_createuser     = "";
    private String rs_modifydate     = "";
    private String rs_modifyuser     = "";

    // Default constructor.
    public ReceiptSheetBean() {}

    // Setters definitions
    public void setRs_id(String rs_id) {
        this.rs_id = rs_id;
    }

    public void setRs_no(String rs_no) {
        this.rs_no = rs_no;
    }

    public void setRs_print(String rs_print) {
        this.rs_print = rs_print;
    }

    public void setRs_multi(String rs_multi) {
        this.rs_multi = rs_multi;
    }

    public void setRs_status(String rs_status) {
        this.rs_status = rs_status;
    }

    public void setDh_id(String dh_id) {
        this.dh_id = dh_id;
    }

    public void setDh_no(String dh_no) {
        this.dh_no = dh_no;
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

    public void setDh_receipt(String dh_receipt) {
        this.dh_receipt = dh_receipt;
    }

    public void setDh_order_county(String dh_order_county) {
        this.dh_order_county = dh_order_county;
    }

    public void setDh_order_city(String dh_order_city) {
        this.dh_order_city = dh_order_city;
    }

    public void setDh_order_zip_code(String dh_order_zip_code) {
        this.dh_order_zip_code = dh_order_zip_code;
    }

    public void setDh_order_address(String dh_order_address) {
        this.dh_order_address = dh_order_address;
    }

    public void setRs_donateitem(String rs_donateitem) {
        this.rs_donateitem = rs_donateitem;
    }

    public void setRs_handle(String rs_handle) {
        this.rs_handle = rs_handle;
    }

    public void setRs_stamp(String rs_stamp) {
        this.rs_stamp = rs_stamp;
    }

    public void setRs_stamp2(String rs_stamp2) {
        this.rs_stamp2 = rs_stamp2;
    }

    public void setRs_stamp3(String rs_stamp3) {
        this.rs_stamp3 = rs_stamp3;
    }

    public void setRs_stamp4(String rs_stamp4) {
        this.rs_stamp4 = rs_stamp4;
    }

    public void setRs_date(String rs_date) {
        this.rs_date = rs_date;
    }

    public void setRs_type(String rs_type) {
        this.rs_type = rs_type;
    }

    public void setRs_code(String rs_code) {
        this.rs_code = rs_code;
    }

    public void setRs_lang(String rs_lang) {
        this.rs_lang = rs_lang;
    }

    public void setDh_donatedate(String dh_donatedate) {
        this.dh_donatedate = dh_donatedate;
    }

    public void setRs_createdate(String rs_createdate) {
        this.rs_createdate = rs_createdate;
    }

    public void setRs_createuser(String rs_createuser) {
        this.rs_createuser = rs_createuser;
    }

    public void setRs_modifydate(String rs_modifydate) {
        this.rs_modifydate = rs_modifydate;
    }

    public void setRs_modifyuser(String rs_modifyuser) {
        this.rs_modifyuser = rs_modifyuser;
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
        vc.add(rs_id);
        vc.add(rs_no);
        vc.add(rs_print);
        vc.add(rs_multi);
        vc.add(rs_status);
        vc.add(dh_id);
        vc.add(dh_no);
        vc.add(dh_order_name);
        vc.add(dh_pid);
        vc.add(dh_compid);
        vc.add(new Integer(dh_total));
        vc.add(dh_total_cn);
        vc.add(dh_receipt);
        vc.add(dh_order_county);
        vc.add(dh_order_city);
        vc.add(dh_order_zip_code);
        vc.add(dh_order_address);
        vc.add(rs_donateitem);
        vc.add(rs_handle);
        vc.add(rs_stamp);
        vc.add(rs_stamp2);
        vc.add(rs_stamp3);
        vc.add(rs_stamp4);
        vc.add(rs_date);
        vc.add(rs_type);
        vc.add(rs_code);
        vc.add(rs_lang);
        vc.add(dh_donatedate);
        vc.add(rs_createdate);
        vc.add(rs_createuser);
        vc.add(rs_modifydate);
        vc.add(rs_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getRs_id() {
        return rs_id;
    }

    public String getRs_no() {
        return rs_no;
    }

    public String getRs_print() {
        return rs_print;
    }

    public String getRs_multi() {
        return rs_multi;
    }

    public String getRs_status() {
        return rs_status;
    }

    public String getDh_id() {
        return dh_id;
    }

    public String getDh_no() {
        return dh_no;
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

    public String getDh_receipt() {
        return dh_receipt;
    }

    public String getDh_order_county() {
        return dh_order_county;
    }

    public String getDh_order_city() {
        return dh_order_city;
    }

    public String getDh_order_zip_code() {
        return dh_order_zip_code;
    }

    public String getDh_order_address() {
        return dh_order_address;
    }

    public String getRs_donateitem() {
        return rs_donateitem;
    }

    public String getRs_handle() {
        return rs_handle;
    }

    public String getRs_stamp() {
        return rs_stamp;
    }

    public String getRs_stamp2() {
        return rs_stamp2;
    }

    public String getRs_stamp3() {
        return rs_stamp3;
    }

    public String getRs_stamp4() {
        return rs_stamp4;
    }

    public String getRs_date() {
        return rs_date;
    }

    public String getRs_type() {
        return rs_type;
    }

    public String getRs_code() {
        return rs_code;
    }

    public String getRs_lang() {
        return rs_lang;
    }

    public String getDh_donatedate() {
        return dh_donatedate;
    }

    public String getRs_createdate() {
        return rs_createdate;
    }

    public String getRs_createuser() {
        return rs_createuser;
    }

    public String getRs_modifydate() {
        return rs_modifydate;
    }

    public String getRs_modifyuser() {
        return rs_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "rs_id", "rs_no", "rs_print", "rs_multi", 
        "rs_status", "dh_id", "dh_no", "dh_order_name", 
        "dh_pid", "dh_compid", "dh_total", "dh_total_cn", 
        "dh_receipt", "dh_order_county", "dh_order_city", "dh_order_zip_code", 
        "dh_order_address", "rs_donateitem", "rs_handle", "rs_stamp", 
        "rs_stamp2", "rs_stamp3", "rs_stamp4", "rs_date", 
        "rs_type", "rs_code", "rs_lang", "dh_donatedate", 
        "rs_createdate", "rs_createuser", "rs_modifydate", "rs_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "int", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String" };
}
