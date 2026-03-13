/**
 * PaymentHistoryBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/03/01 14:05:59
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'payment_history'.
 */
public final class PaymentHistoryBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "payment_history";

    // Fields variable definition.
    private String ph_id         = "";
    private String data_id       = "";
    private String ph_no         = "";
    private String ph_name       = "";
    private String ph_payment    = "";
    private String ph_status     = "";
    private String ph_bank_no    = "";
    private String ph_account    = "";
    private String ph_limitdate  = "";
    private String ph_paydate    = "";
    private String ph_barcode1   = "";
    private String ph_barcode2   = "";
    private String ph_barcode3   = "";
    private String ph_qrcode     = "";
    private String ph_amount     = "";
    private String ph_fee        = "";
    private String ph_post       = "";
    private String ph_return_no  = "";
    private String ph_return_msg = "";
    private String ph_note       = "";
    private String ph_error      = "";
    private String ph_memo       = "";
    private String ph_code       = "";
    private String ph_lang       = "";
    private String ph_createdate = "";
    private String ph_createuser = "";
    private String ph_modifydate = "";
    private String ph_modifyuser = "";

    // Default constructor.
    public PaymentHistoryBean() {}

    // Setters definitions
    public void setPh_id(String ph_id) {
        this.ph_id = ph_id;
    }

    public void setData_id(String data_id) {
        this.data_id = data_id;
    }

    public void setPh_no(String ph_no) {
        this.ph_no = ph_no;
    }

    public void setPh_name(String ph_name) {
        this.ph_name = ph_name;
    }

    public void setPh_payment(String ph_payment) {
        this.ph_payment = ph_payment;
    }

    public void setPh_status(String ph_status) {
        this.ph_status = ph_status;
    }

    public void setPh_bank_no(String ph_bank_no) {
        this.ph_bank_no = ph_bank_no;
    }

    public void setPh_account(String ph_account) {
        this.ph_account = ph_account;
    }

    public void setPh_limitdate(String ph_limitdate) {
        this.ph_limitdate = ph_limitdate;
    }

    public void setPh_paydate(String ph_paydate) {
        this.ph_paydate = ph_paydate;
    }

    public void setPh_barcode1(String ph_barcode1) {
        this.ph_barcode1 = ph_barcode1;
    }

    public void setPh_barcode2(String ph_barcode2) {
        this.ph_barcode2 = ph_barcode2;
    }

    public void setPh_barcode3(String ph_barcode3) {
        this.ph_barcode3 = ph_barcode3;
    }

    public void setPh_qrcode(String ph_qrcode) {
        this.ph_qrcode = ph_qrcode;
    }

    public void setPh_amount(String ph_amount) {
        this.ph_amount = ph_amount;
    }

    public void setPh_fee(String ph_fee) {
        this.ph_fee = ph_fee;
    }

    public void setPh_post(String ph_post) {
        this.ph_post = ph_post;
    }

    public void setPh_return_no(String ph_return_no) {
        this.ph_return_no = ph_return_no;
    }

    public void setPh_return_msg(String ph_return_msg) {
        this.ph_return_msg = ph_return_msg;
    }

    public void setPh_note(String ph_note) {
        this.ph_note = ph_note;
    }

    public void setPh_error(String ph_error) {
        this.ph_error = ph_error;
    }

    public void setPh_memo(String ph_memo) {
        this.ph_memo = ph_memo;
    }

    public void setPh_code(String ph_code) {
        this.ph_code = ph_code;
    }

    public void setPh_lang(String ph_lang) {
        this.ph_lang = ph_lang;
    }

    public void setPh_createdate(String ph_createdate) {
        this.ph_createdate = ph_createdate;
    }

    public void setPh_createuser(String ph_createuser) {
        this.ph_createuser = ph_createuser;
    }

    public void setPh_modifydate(String ph_modifydate) {
        this.ph_modifydate = ph_modifydate;
    }

    public void setPh_modifyuser(String ph_modifyuser) {
        this.ph_modifyuser = ph_modifyuser;
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
        vc.add(ph_id);
        vc.add(data_id);
        vc.add(ph_no);
        vc.add(ph_name);
        vc.add(ph_payment);
        vc.add(ph_status);
        vc.add(ph_bank_no);
        vc.add(ph_account);
        vc.add(ph_limitdate);
        vc.add(ph_paydate);
        vc.add(ph_barcode1);
        vc.add(ph_barcode2);
        vc.add(ph_barcode3);
        vc.add(ph_qrcode);
        vc.add(ph_amount);
        vc.add(ph_fee);
        vc.add(ph_post);
        vc.add(ph_return_no);
        vc.add(ph_return_msg);
        vc.add(ph_note);
        vc.add(ph_error);
        vc.add(ph_memo);
        vc.add(ph_code);
        vc.add(ph_lang);
        vc.add(ph_createdate);
        vc.add(ph_createuser);
        vc.add(ph_modifydate);
        vc.add(ph_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getPh_id() {
        return ph_id;
    }

    public String getData_id() {
        return data_id;
    }

    public String getPh_no() {
        return ph_no;
    }

    public String getPh_name() {
        return ph_name;
    }

    public String getPh_payment() {
        return ph_payment;
    }

    public String getPh_status() {
        return ph_status;
    }

    public String getPh_bank_no() {
        return ph_bank_no;
    }

    public String getPh_account() {
        return ph_account;
    }

    public String getPh_limitdate() {
        return ph_limitdate;
    }

    public String getPh_paydate() {
        return ph_paydate;
    }

    public String getPh_barcode1() {
        return ph_barcode1;
    }

    public String getPh_barcode2() {
        return ph_barcode2;
    }

    public String getPh_barcode3() {
        return ph_barcode3;
    }

    public String getPh_qrcode() {
        return ph_qrcode;
    }

    public String getPh_amount() {
        return ph_amount;
    }

    public String getPh_fee() {
        return ph_fee;
    }

    public String getPh_post() {
        return ph_post;
    }

    public String getPh_return_no() {
        return ph_return_no;
    }

    public String getPh_return_msg() {
        return ph_return_msg;
    }

    public String getPh_note() {
        return ph_note;
    }

    public String getPh_error() {
        return ph_error;
    }

    public String getPh_memo() {
        return ph_memo;
    }

    public String getPh_code() {
        return ph_code;
    }

    public String getPh_lang() {
        return ph_lang;
    }

    public String getPh_createdate() {
        return ph_createdate;
    }

    public String getPh_createuser() {
        return ph_createuser;
    }

    public String getPh_modifydate() {
        return ph_modifydate;
    }

    public String getPh_modifyuser() {
        return ph_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ph_id", "data_id", "ph_no", "ph_name", 
        "ph_payment", "ph_status", "ph_bank_no", "ph_account", 
        "ph_limitdate", "ph_paydate", "ph_barcode1", "ph_barcode2", 
        "ph_barcode3", "ph_qrcode", "ph_amount", "ph_fee", 
        "ph_post", "ph_return_no", "ph_return_msg", "ph_note", 
        "ph_error", "ph_memo", "ph_code", "ph_lang", 
        "ph_createdate", "ph_createuser", "ph_modifydate", "ph_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String" };
}
