/**
 * WriteHistoryBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/03/21 10:23:46
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'write_history'.
 */
public final class WriteHistoryBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "write_history";

    // Fields variable definition.
    private String wh_id         = "";
    private String data_id       = "";
    private String wh_status     = "";
    private String wh_account    = "";
    private String wh_limit_date = "";
    private String wh_pay_date   = "";
    private String wh_pay_time   = "";
    private String wh_payment    = "";
    private int    wh_total      = 0;
    private String wh_remark     = "";
    private String wh_code       = "";
    private String wh_createdate = "";
    private String wh_createuser = "";
    private String wh_modifydate = "";
    private String wh_modifyuser = "";

    // Default constructor.
    public WriteHistoryBean() {}

    // Setters definitions
    public void setWh_id(String wh_id) {
        this.wh_id = wh_id;
    }

    public void setData_id(String data_id) {
        this.data_id = data_id;
    }

    public void setWh_status(String wh_status) {
        this.wh_status = wh_status;
    }

    public void setWh_account(String wh_account) {
        this.wh_account = wh_account;
    }

    public void setWh_limit_date(String wh_limit_date) {
        this.wh_limit_date = wh_limit_date;
    }

    public void setWh_pay_date(String wh_pay_date) {
        this.wh_pay_date = wh_pay_date;
    }

    public void setWh_pay_time(String wh_pay_time) {
        this.wh_pay_time = wh_pay_time;
    }

    public void setWh_payment(String wh_payment) {
        this.wh_payment = wh_payment;
    }

    public void setWh_total(int wh_total) {
        this.wh_total = wh_total;
    }

    public void setWh_remark(String wh_remark) {
        this.wh_remark = wh_remark;
    }

    public void setWh_code(String wh_code) {
        this.wh_code = wh_code;
    }

    public void setWh_createdate(String wh_createdate) {
        this.wh_createdate = wh_createdate;
    }

    public void setWh_createuser(String wh_createuser) {
        this.wh_createuser = wh_createuser;
    }

    public void setWh_modifydate(String wh_modifydate) {
        this.wh_modifydate = wh_modifydate;
    }

    public void setWh_modifyuser(String wh_modifyuser) {
        this.wh_modifyuser = wh_modifyuser;
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
        vc.add(wh_id);
        vc.add(data_id);
        vc.add(wh_status);
        vc.add(wh_account);
        vc.add(wh_limit_date);
        vc.add(wh_pay_date);
        vc.add(wh_pay_time);
        vc.add(wh_payment);
        vc.add(new Integer(wh_total));
        vc.add(wh_remark);
        vc.add(wh_code);
        vc.add(wh_createdate);
        vc.add(wh_createuser);
        vc.add(wh_modifydate);
        vc.add(wh_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getWh_id() {
        return wh_id;
    }

    public String getData_id() {
        return data_id;
    }

    public String getWh_status() {
        return wh_status;
    }

    public String getWh_account() {
        return wh_account;
    }

    public String getWh_limit_date() {
        return wh_limit_date;
    }

    public String getWh_pay_date() {
        return wh_pay_date;
    }

    public String getWh_pay_time() {
        return wh_pay_time;
    }

    public String getWh_payment() {
        return wh_payment;
    }

    public int getWh_total() {
        return wh_total;
    }

    public String getWh_remark() {
        return wh_remark;
    }

    public String getWh_code() {
        return wh_code;
    }

    public String getWh_createdate() {
        return wh_createdate;
    }

    public String getWh_createuser() {
        return wh_createuser;
    }

    public String getWh_modifydate() {
        return wh_modifydate;
    }

    public String getWh_modifyuser() {
        return wh_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "wh_id", "data_id", "wh_status", "wh_account", 
        "wh_limit_date", "wh_pay_date", "wh_pay_time", "wh_payment", 
        "wh_total", "wh_remark", "wh_code", "wh_createdate", 
        "wh_createuser", "wh_modifydate", "wh_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "int", "String", "String", "String", "String", "String", 
        "String" };
}
