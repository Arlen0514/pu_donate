/**
 * DonateHistoryBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2026/04/01 15:14:18
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'donate_history'.
 */
public final class DonateHistoryBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "donate_history";

    // Fields variable definition.
    private String dh_id                      = "";
    private String dh_no                      = "";
    private String dh_main                    = "";
    private String mp_id                      = "";
    private String dr_id                      = "";
    private String dr_no                      = "";
    private String rs_id                      = "";
    private String rs_no                      = "";
    private String rs_status                  = "";
    private String dh_status                  = "";
    private String dh_mis                     = "";
    private String dh_collect                 = "";
    private String dh_calculate               = "";
    private String dh_donatedate              = "";
    private int    dh_total                   = 0;
    private int    dh_foreign_total           = 0;
    private String dh_currency                = "";
    private String dh_currency_other          = "";
    private String dh_donate_project_category = "";
    private String dh_donate_college          = "";
    private String dh_donate_department       = "";
    private String dh_donate_project          = "";
    private String dh_donate_project_no       = "";
    private String dh_donate_project_title    = "";
    private String dh_donate_unit             = "";
    private String dh_donate_unit_title       = "";
    private String dh_donate_attribute        = "";
    private String dh_donate_attribute_title  = "";
    private String dh_paymethod               = "";
    private String dh_financialname           = "";
    private String dh_num                     = "";
    private String dh_num_unit                = "";
    private String dh_typespec                = "";
    private String dh_placedate               = "";
    private String dh_placelocaction          = "";
    private String dh_name                    = "";
    private String dh_pid                     = "";
    private String dh_phone                   = "";
    private String dh_cellphone               = "";
    private String dh_email                   = "";
    private String dh_identity_type           = "";
    private String dh_identity                = "";
    private String dh_identity_thank          = "";
    private String dh_identity_year           = "";
    private String dh_identity_dept           = "";
    private String dh_unit                    = "";
    private String dh_job                     = "";
    private String dh_foreign                 = "";
    private String dh_county                  = "";
    private String dh_city                    = "";
    private String dh_zipcode                 = "";
    private String dh_address                 = "";
    private String dh_remark                  = "";
    private String dh_memo                    = "";
    private String dh_receipt_status          = "";
    private String dh_receipt_title           = "";
    private String dh_receipt_county          = "";
    private String dh_receipt_city            = "";
    private String dh_receipt_zipcode         = "";
    private String dh_receipt_address         = "";
    private String dh_same_name               = "";
    private String dh_same_address            = "";
    private String dh_public                  = "";
    private String dh_tax                     = "";
    private String dh_credit_card_no          = "";
    private String dh_authorization_code      = "";
    private String dh_expiration_year         = "";
    private String dh_expiration_month        = "";
    private String dh_debit_due_year          = "";
    private String dh_debit_due_month         = "";
    private String dh_regular_type            = "";
    private int    dh_regular_period          = 0;
    private int    dh_remain_period           = 0;
    private String dh_bank_no                 = "";
    private String dh_code                    = "";
    private String dh_lang                    = "";
    private String dh_createdate              = "";
    private String dh_createuser              = "";
    private String dh_modifydate              = "";
    private String dh_modifyuser              = "";

    // Default constructor.
    public DonateHistoryBean() {}

    // Setters definitions
    public void setDh_id(String dh_id) {
        this.dh_id = dh_id;
    }

    public void setDh_no(String dh_no) {
        this.dh_no = dh_no;
    }

    public void setDh_main(String dh_main) {
        this.dh_main = dh_main;
    }

    public void setMp_id(String mp_id) {
        this.mp_id = mp_id;
    }

    public void setDr_id(String dr_id) {
        this.dr_id = dr_id;
    }

    public void setDr_no(String dr_no) {
        this.dr_no = dr_no;
    }

    public void setRs_id(String rs_id) {
        this.rs_id = rs_id;
    }

    public void setRs_no(String rs_no) {
        this.rs_no = rs_no;
    }

    public void setRs_status(String rs_status) {
        this.rs_status = rs_status;
    }

    public void setDh_status(String dh_status) {
        this.dh_status = dh_status;
    }

    public void setDh_mis(String dh_mis) {
        this.dh_mis = dh_mis;
    }

    public void setDh_collect(String dh_collect) {
        this.dh_collect = dh_collect;
    }

    public void setDh_calculate(String dh_calculate) {
        this.dh_calculate = dh_calculate;
    }

    public void setDh_donatedate(String dh_donatedate) {
        this.dh_donatedate = dh_donatedate;
    }

    public void setDh_total(int dh_total) {
        this.dh_total = dh_total;
    }

    public void setDh_foreign_total(int dh_foreign_total) {
        this.dh_foreign_total = dh_foreign_total;
    }

    public void setDh_currency(String dh_currency) {
        this.dh_currency = dh_currency;
    }

    public void setDh_currency_other(String dh_currency_other) {
        this.dh_currency_other = dh_currency_other;
    }

    public void setDh_donate_project_category(String dh_donate_project_category) {
        this.dh_donate_project_category = dh_donate_project_category;
    }

    public void setDh_donate_college(String dh_donate_college) {
        this.dh_donate_college = dh_donate_college;
    }

    public void setDh_donate_department(String dh_donate_department) {
        this.dh_donate_department = dh_donate_department;
    }

    public void setDh_donate_project(String dh_donate_project) {
        this.dh_donate_project = dh_donate_project;
    }

    public void setDh_donate_project_no(String dh_donate_project_no) {
        this.dh_donate_project_no = dh_donate_project_no;
    }

    public void setDh_donate_project_title(String dh_donate_project_title) {
        this.dh_donate_project_title = dh_donate_project_title;
    }

    public void setDh_donate_unit(String dh_donate_unit) {
        this.dh_donate_unit = dh_donate_unit;
    }

    public void setDh_donate_unit_title(String dh_donate_unit_title) {
        this.dh_donate_unit_title = dh_donate_unit_title;
    }

    public void setDh_donate_attribute(String dh_donate_attribute) {
        this.dh_donate_attribute = dh_donate_attribute;
    }

    public void setDh_donate_attribute_title(String dh_donate_attribute_title) {
        this.dh_donate_attribute_title = dh_donate_attribute_title;
    }

    public void setDh_paymethod(String dh_paymethod) {
        this.dh_paymethod = dh_paymethod;
    }

    public void setDh_financialname(String dh_financialname) {
        this.dh_financialname = dh_financialname;
    }

    public void setDh_num(String dh_num) {
        this.dh_num = dh_num;
    }

    public void setDh_num_unit(String dh_num_unit) {
        this.dh_num_unit = dh_num_unit;
    }

    public void setDh_typespec(String dh_typespec) {
        this.dh_typespec = dh_typespec;
    }

    public void setDh_placedate(String dh_placedate) {
        this.dh_placedate = dh_placedate;
    }

    public void setDh_placelocaction(String dh_placelocaction) {
        this.dh_placelocaction = dh_placelocaction;
    }

    public void setDh_name(String dh_name) {
        this.dh_name = dh_name;
    }

    public void setDh_pid(String dh_pid) {
        this.dh_pid = dh_pid;
    }

    public void setDh_phone(String dh_phone) {
        this.dh_phone = dh_phone;
    }

    public void setDh_cellphone(String dh_cellphone) {
        this.dh_cellphone = dh_cellphone;
    }

    public void setDh_email(String dh_email) {
        this.dh_email = dh_email;
    }

    public void setDh_identity_type(String dh_identity_type) {
        this.dh_identity_type = dh_identity_type;
    }

    public void setDh_identity(String dh_identity) {
        this.dh_identity = dh_identity;
    }

    public void setDh_identity_thank(String dh_identity_thank) {
        this.dh_identity_thank = dh_identity_thank;
    }

    public void setDh_identity_year(String dh_identity_year) {
        this.dh_identity_year = dh_identity_year;
    }

    public void setDh_identity_dept(String dh_identity_dept) {
        this.dh_identity_dept = dh_identity_dept;
    }

    public void setDh_unit(String dh_unit) {
        this.dh_unit = dh_unit;
    }

    public void setDh_job(String dh_job) {
        this.dh_job = dh_job;
    }

    public void setDh_foreign(String dh_foreign) {
        this.dh_foreign = dh_foreign;
    }

    public void setDh_county(String dh_county) {
        this.dh_county = dh_county;
    }

    public void setDh_city(String dh_city) {
        this.dh_city = dh_city;
    }

    public void setDh_zipcode(String dh_zipcode) {
        this.dh_zipcode = dh_zipcode;
    }

    public void setDh_address(String dh_address) {
        this.dh_address = dh_address;
    }

    public void setDh_remark(String dh_remark) {
        this.dh_remark = dh_remark;
    }

    public void setDh_memo(String dh_memo) {
        this.dh_memo = dh_memo;
    }

    public void setDh_receipt_status(String dh_receipt_status) {
        this.dh_receipt_status = dh_receipt_status;
    }

    public void setDh_receipt_title(String dh_receipt_title) {
        this.dh_receipt_title = dh_receipt_title;
    }

    public void setDh_receipt_county(String dh_receipt_county) {
        this.dh_receipt_county = dh_receipt_county;
    }

    public void setDh_receipt_city(String dh_receipt_city) {
        this.dh_receipt_city = dh_receipt_city;
    }

    public void setDh_receipt_zipcode(String dh_receipt_zipcode) {
        this.dh_receipt_zipcode = dh_receipt_zipcode;
    }

    public void setDh_receipt_address(String dh_receipt_address) {
        this.dh_receipt_address = dh_receipt_address;
    }

    public void setDh_same_name(String dh_same_name) {
        this.dh_same_name = dh_same_name;
    }

    public void setDh_same_address(String dh_same_address) {
        this.dh_same_address = dh_same_address;
    }

    public void setDh_public(String dh_public) {
        this.dh_public = dh_public;
    }

    public void setDh_tax(String dh_tax) {
        this.dh_tax = dh_tax;
    }

    public void setDh_credit_card_no(String dh_credit_card_no) {
        this.dh_credit_card_no = dh_credit_card_no;
    }

    public void setDh_authorization_code(String dh_authorization_code) {
        this.dh_authorization_code = dh_authorization_code;
    }

    public void setDh_expiration_year(String dh_expiration_year) {
        this.dh_expiration_year = dh_expiration_year;
    }

    public void setDh_expiration_month(String dh_expiration_month) {
        this.dh_expiration_month = dh_expiration_month;
    }

    public void setDh_debit_due_year(String dh_debit_due_year) {
        this.dh_debit_due_year = dh_debit_due_year;
    }

    public void setDh_debit_due_month(String dh_debit_due_month) {
        this.dh_debit_due_month = dh_debit_due_month;
    }

    public void setDh_regular_type(String dh_regular_type) {
        this.dh_regular_type = dh_regular_type;
    }

    public void setDh_regular_period(int dh_regular_period) {
        this.dh_regular_period = dh_regular_period;
    }

    public void setDh_remain_period(int dh_remain_period) {
        this.dh_remain_period = dh_remain_period;
    }

    public void setDh_bank_no(String dh_bank_no) {
        this.dh_bank_no = dh_bank_no;
    }

    public void setDh_code(String dh_code) {
        this.dh_code = dh_code;
    }

    public void setDh_lang(String dh_lang) {
        this.dh_lang = dh_lang;
    }

    public void setDh_createdate(String dh_createdate) {
        this.dh_createdate = dh_createdate;
    }

    public void setDh_createuser(String dh_createuser) {
        this.dh_createuser = dh_createuser;
    }

    public void setDh_modifydate(String dh_modifydate) {
        this.dh_modifydate = dh_modifydate;
    }

    public void setDh_modifyuser(String dh_modifyuser) {
        this.dh_modifyuser = dh_modifyuser;
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
        vc.add(dh_id);
        vc.add(dh_no);
        vc.add(dh_main);
        vc.add(mp_id);
        vc.add(dr_id);
        vc.add(dr_no);
        vc.add(rs_id);
        vc.add(rs_no);
        vc.add(rs_status);
        vc.add(dh_status);
        vc.add(dh_mis);
        vc.add(dh_collect);
        vc.add(dh_calculate);
        vc.add(dh_donatedate);
        vc.add(new Integer(dh_total));
        vc.add(new Integer(dh_foreign_total));
        vc.add(dh_currency);
        vc.add(dh_currency_other);
        vc.add(dh_donate_project_category);
        vc.add(dh_donate_college);
        vc.add(dh_donate_department);
        vc.add(dh_donate_project);
        vc.add(dh_donate_project_no);
        vc.add(dh_donate_project_title);
        vc.add(dh_donate_unit);
        vc.add(dh_donate_unit_title);
        vc.add(dh_donate_attribute);
        vc.add(dh_donate_attribute_title);
        vc.add(dh_paymethod);
        vc.add(dh_financialname);
        vc.add(dh_num);
        vc.add(dh_num_unit);
        vc.add(dh_typespec);
        vc.add(dh_placedate);
        vc.add(dh_placelocaction);
        vc.add(dh_name);
        vc.add(dh_pid);
        vc.add(dh_phone);
        vc.add(dh_cellphone);
        vc.add(dh_email);
        vc.add(dh_identity_type);
        vc.add(dh_identity);
        vc.add(dh_identity_thank);
        vc.add(dh_identity_year);
        vc.add(dh_identity_dept);
        vc.add(dh_unit);
        vc.add(dh_job);
        vc.add(dh_foreign);
        vc.add(dh_county);
        vc.add(dh_city);
        vc.add(dh_zipcode);
        vc.add(dh_address);
        vc.add(dh_remark);
        vc.add(dh_memo);
        vc.add(dh_receipt_status);
        vc.add(dh_receipt_title);
        vc.add(dh_receipt_county);
        vc.add(dh_receipt_city);
        vc.add(dh_receipt_zipcode);
        vc.add(dh_receipt_address);
        vc.add(dh_same_name);
        vc.add(dh_same_address);
        vc.add(dh_public);
        vc.add(dh_tax);
        vc.add(dh_credit_card_no);
        vc.add(dh_authorization_code);
        vc.add(dh_expiration_year);
        vc.add(dh_expiration_month);
        vc.add(dh_debit_due_year);
        vc.add(dh_debit_due_month);
        vc.add(dh_regular_type);
        vc.add(new Integer(dh_regular_period));
        vc.add(new Integer(dh_remain_period));
        vc.add(dh_bank_no);
        vc.add(dh_code);
        vc.add(dh_lang);
        vc.add(dh_createdate);
        vc.add(dh_createuser);
        vc.add(dh_modifydate);
        vc.add(dh_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getDh_id() {
        return dh_id;
    }

    public String getDh_no() {
        return dh_no;
    }

    public String getDh_main() {
        return dh_main;
    }

    public String getMp_id() {
        return mp_id;
    }

    public String getDr_id() {
        return dr_id;
    }

    public String getDr_no() {
        return dr_no;
    }

    public String getRs_id() {
        return rs_id;
    }

    public String getRs_no() {
        return rs_no;
    }

    public String getRs_status() {
        return rs_status;
    }

    public String getDh_status() {
        return dh_status;
    }

    public String getDh_mis() {
        return dh_mis;
    }

    public String getDh_collect() {
        return dh_collect;
    }

    public String getDh_calculate() {
        return dh_calculate;
    }

    public String getDh_donatedate() {
        return dh_donatedate;
    }

    public int getDh_total() {
        return dh_total;
    }

    public int getDh_foreign_total() {
        return dh_foreign_total;
    }

    public String getDh_currency() {
        return dh_currency;
    }

    public String getDh_currency_other() {
        return dh_currency_other;
    }

    public String getDh_donate_project_category() {
        return dh_donate_project_category;
    }

    public String getDh_donate_college() {
        return dh_donate_college;
    }

    public String getDh_donate_department() {
        return dh_donate_department;
    }

    public String getDh_donate_project() {
        return dh_donate_project;
    }

    public String getDh_donate_project_no() {
        return dh_donate_project_no;
    }

    public String getDh_donate_project_title() {
        return dh_donate_project_title;
    }

    public String getDh_donate_unit() {
        return dh_donate_unit;
    }

    public String getDh_donate_unit_title() {
        return dh_donate_unit_title;
    }

    public String getDh_donate_attribute() {
        return dh_donate_attribute;
    }

    public String getDh_donate_attribute_title() {
        return dh_donate_attribute_title;
    }

    public String getDh_paymethod() {
        return dh_paymethod;
    }

    public String getDh_financialname() {
        return dh_financialname;
    }

    public String getDh_num() {
        return dh_num;
    }

    public String getDh_num_unit() {
        return dh_num_unit;
    }

    public String getDh_typespec() {
        return dh_typespec;
    }

    public String getDh_placedate() {
        return dh_placedate;
    }

    public String getDh_placelocaction() {
        return dh_placelocaction;
    }

    public String getDh_name() {
        return dh_name;
    }

    public String getDh_pid() {
        return dh_pid;
    }

    public String getDh_phone() {
        return dh_phone;
    }

    public String getDh_cellphone() {
        return dh_cellphone;
    }

    public String getDh_email() {
        return dh_email;
    }

    public String getDh_identity_type() {
        return dh_identity_type;
    }

    public String getDh_identity() {
        return dh_identity;
    }

    public String getDh_identity_thank() {
        return dh_identity_thank;
    }

    public String getDh_identity_year() {
        return dh_identity_year;
    }

    public String getDh_identity_dept() {
        return dh_identity_dept;
    }

    public String getDh_unit() {
        return dh_unit;
    }

    public String getDh_job() {
        return dh_job;
    }

    public String getDh_foreign() {
        return dh_foreign;
    }

    public String getDh_county() {
        return dh_county;
    }

    public String getDh_city() {
        return dh_city;
    }

    public String getDh_zipcode() {
        return dh_zipcode;
    }

    public String getDh_address() {
        return dh_address;
    }

    public String getDh_remark() {
        return dh_remark;
    }

    public String getDh_memo() {
        return dh_memo;
    }

    public String getDh_receipt_status() {
        return dh_receipt_status;
    }

    public String getDh_receipt_title() {
        return dh_receipt_title;
    }

    public String getDh_receipt_county() {
        return dh_receipt_county;
    }

    public String getDh_receipt_city() {
        return dh_receipt_city;
    }

    public String getDh_receipt_zipcode() {
        return dh_receipt_zipcode;
    }

    public String getDh_receipt_address() {
        return dh_receipt_address;
    }

    public String getDh_same_name() {
        return dh_same_name;
    }

    public String getDh_same_address() {
        return dh_same_address;
    }

    public String getDh_public() {
        return dh_public;
    }

    public String getDh_tax() {
        return dh_tax;
    }

    public String getDh_credit_card_no() {
        return dh_credit_card_no;
    }

    public String getDh_authorization_code() {
        return dh_authorization_code;
    }

    public String getDh_expiration_year() {
        return dh_expiration_year;
    }

    public String getDh_expiration_month() {
        return dh_expiration_month;
    }

    public String getDh_debit_due_year() {
        return dh_debit_due_year;
    }

    public String getDh_debit_due_month() {
        return dh_debit_due_month;
    }

    public String getDh_regular_type() {
        return dh_regular_type;
    }

    public int getDh_regular_period() {
        return dh_regular_period;
    }

    public int getDh_remain_period() {
        return dh_remain_period;
    }

    public String getDh_bank_no() {
        return dh_bank_no;
    }

    public String getDh_code() {
        return dh_code;
    }

    public String getDh_lang() {
        return dh_lang;
    }

    public String getDh_createdate() {
        return dh_createdate;
    }

    public String getDh_createuser() {
        return dh_createuser;
    }

    public String getDh_modifydate() {
        return dh_modifydate;
    }

    public String getDh_modifyuser() {
        return dh_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "dh_id", "dh_no", "dh_main", "mp_id", 
        "dr_id", "dr_no", "rs_id", "rs_no", 
        "rs_status", "dh_status", "dh_mis", "dh_collect", 
        "dh_calculate", "dh_donatedate", "dh_total", "dh_foreign_total", 
        "dh_currency", "dh_currency_other", "dh_donate_project_category", "dh_donate_college", 
        "dh_donate_department", "dh_donate_project", "dh_donate_project_no", "dh_donate_project_title", 
        "dh_donate_unit", "dh_donate_unit_title", "dh_donate_attribute", "dh_donate_attribute_title", 
        "dh_paymethod", "dh_financialname", "dh_num", "dh_num_unit", 
        "dh_typespec", "dh_placedate", "dh_placelocaction", "dh_name", 
        "dh_pid", "dh_phone", "dh_cellphone", "dh_email", 
        "dh_identity_type", "dh_identity", "dh_identity_thank", "dh_identity_year", 
        "dh_identity_dept", "dh_unit", "dh_job", "dh_foreign", 
        "dh_county", "dh_city", "dh_zipcode", "dh_address", 
        "dh_remark", "dh_memo", "dh_receipt_status", "dh_receipt_title", 
        "dh_receipt_county", "dh_receipt_city", "dh_receipt_zipcode", "dh_receipt_address", 
        "dh_same_name", "dh_same_address", "dh_public", "dh_tax", 
        "dh_credit_card_no", "dh_authorization_code", "dh_expiration_year", "dh_expiration_month", 
        "dh_debit_due_year", "dh_debit_due_month", "dh_regular_type", "dh_regular_period", 
        "dh_remain_period", "dh_bank_no", "dh_code", "dh_lang", 
        "dh_createdate", "dh_createuser", "dh_modifydate", "dh_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "int", "int", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "int", "int", "String", "String", "String", "String", 
        "String", "String", "String" };
}
