/**
 * MemberProfileBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/05/02 17:16:13
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'member_profile'.
 */
public final class MemberProfileBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "member_profile";

    // Fields variable definition.
    private String mp_id          = "";
    private String mp_fb_id       = "";
    private String mc_id          = "";
    private String mp_status      = "";
    private String mp_mail_status = "";
    private String at_id          = "";
    private String mp_account     = "";
    private String mp_password    = "";
    private String mp_name        = "";
    private String mp_gender      = "";
    private String mp_country     = "";
    private String mp_personid    = "";
    private String mp_birthday    = "";
    private String mp_phone       = "";
    private String mp_cellphone   = "";
    private String mp_fax         = "";
    private String mp_county      = "";
    private String mp_city        = "";
    private String mp_zipcode     = "";
    private String mp_address     = "";
    private String mp_email       = "";
    private String mp_unit        = "";
    private String mp_job         = "";
    private int    mp_total       = 0;
    private String mp_regcode     = "";
    private String mp_command     = "";
    private String mp_mome        = "";
    private String mp_code        = "";
    private String mp_createdate  = "";
    private String mp_createuser  = "";
    private String mp_modifydate  = "";
    private String mp_modifyuser  = "";

    // Default constructor.
    public MemberProfileBean() {}

    // Setters definitions
    public void setMp_id(String mp_id) {
        this.mp_id = mp_id;
    }

    public void setMp_fb_id(String mp_fb_id) {
        this.mp_fb_id = mp_fb_id;
    }

    public void setMc_id(String mc_id) {
        this.mc_id = mc_id;
    }

    public void setMp_status(String mp_status) {
        this.mp_status = mp_status;
    }

    public void setMp_mail_status(String mp_mail_status) {
        this.mp_mail_status = mp_mail_status;
    }

    public void setAt_id(String at_id) {
        this.at_id = at_id;
    }

    public void setMp_account(String mp_account) {
        this.mp_account = mp_account;
    }

    public void setMp_password(String mp_password) {
        this.mp_password = mp_password;
    }

    public void setMp_name(String mp_name) {
        this.mp_name = mp_name;
    }

    public void setMp_gender(String mp_gender) {
        this.mp_gender = mp_gender;
    }

    public void setMp_country(String mp_country) {
        this.mp_country = mp_country;
    }

    public void setMp_personid(String mp_personid) {
        this.mp_personid = mp_personid;
    }

    public void setMp_birthday(String mp_birthday) {
        this.mp_birthday = mp_birthday;
    }

    public void setMp_phone(String mp_phone) {
        this.mp_phone = mp_phone;
    }

    public void setMp_cellphone(String mp_cellphone) {
        this.mp_cellphone = mp_cellphone;
    }

    public void setMp_fax(String mp_fax) {
        this.mp_fax = mp_fax;
    }

    public void setMp_county(String mp_county) {
        this.mp_county = mp_county;
    }

    public void setMp_city(String mp_city) {
        this.mp_city = mp_city;
    }

    public void setMp_zipcode(String mp_zipcode) {
        this.mp_zipcode = mp_zipcode;
    }

    public void setMp_address(String mp_address) {
        this.mp_address = mp_address;
    }

    public void setMp_email(String mp_email) {
        this.mp_email = mp_email;
    }

    public void setMp_unit(String mp_unit) {
        this.mp_unit = mp_unit;
    }

    public void setMp_job(String mp_job) {
        this.mp_job = mp_job;
    }

    public void setMp_total(int mp_total) {
        this.mp_total = mp_total;
    }

    public void setMp_regcode(String mp_regcode) {
        this.mp_regcode = mp_regcode;
    }

    public void setMp_command(String mp_command) {
        this.mp_command = mp_command;
    }

    public void setMp_mome(String mp_mome) {
        this.mp_mome = mp_mome;
    }

    public void setMp_code(String mp_code) {
        this.mp_code = mp_code;
    }

    public void setMp_createdate(String mp_createdate) {
        this.mp_createdate = mp_createdate;
    }

    public void setMp_createuser(String mp_createuser) {
        this.mp_createuser = mp_createuser;
    }

    public void setMp_modifydate(String mp_modifydate) {
        this.mp_modifydate = mp_modifydate;
    }

    public void setMp_modifyuser(String mp_modifyuser) {
        this.mp_modifyuser = mp_modifyuser;
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
        vc.add(mp_id);
        vc.add(mp_fb_id);
        vc.add(mc_id);
        vc.add(mp_status);
        vc.add(mp_mail_status);
        vc.add(at_id);
        vc.add(mp_account);
        vc.add(mp_password);
        vc.add(mp_name);
        vc.add(mp_gender);
        vc.add(mp_country);
        vc.add(mp_personid);
        vc.add(mp_birthday);
        vc.add(mp_phone);
        vc.add(mp_cellphone);
        vc.add(mp_fax);
        vc.add(mp_county);
        vc.add(mp_city);
        vc.add(mp_zipcode);
        vc.add(mp_address);
        vc.add(mp_email);
        vc.add(mp_unit);
        vc.add(mp_job);
        vc.add(new Integer(mp_total));
        vc.add(mp_regcode);
        vc.add(mp_command);
        vc.add(mp_mome);
        vc.add(mp_code);
        vc.add(mp_createdate);
        vc.add(mp_createuser);
        vc.add(mp_modifydate);
        vc.add(mp_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getMp_id() {
        return mp_id;
    }

    public String getMp_fb_id() {
        return mp_fb_id;
    }

    public String getMc_id() {
        return mc_id;
    }

    public String getMp_status() {
        return mp_status;
    }

    public String getMp_mail_status() {
        return mp_mail_status;
    }

    public String getAt_id() {
        return at_id;
    }

    public String getMp_account() {
        return mp_account;
    }

    public String getMp_password() {
        return mp_password;
    }

    public String getMp_name() {
        return mp_name;
    }

    public String getMp_gender() {
        return mp_gender;
    }

    public String getMp_country() {
        return mp_country;
    }

    public String getMp_personid() {
        return mp_personid;
    }

    public String getMp_birthday() {
        return mp_birthday;
    }

    public String getMp_phone() {
        return mp_phone;
    }

    public String getMp_cellphone() {
        return mp_cellphone;
    }

    public String getMp_fax() {
        return mp_fax;
    }

    public String getMp_county() {
        return mp_county;
    }

    public String getMp_city() {
        return mp_city;
    }

    public String getMp_zipcode() {
        return mp_zipcode;
    }

    public String getMp_address() {
        return mp_address;
    }

    public String getMp_email() {
        return mp_email;
    }

    public String getMp_unit() {
        return mp_unit;
    }

    public String getMp_job() {
        return mp_job;
    }

    public int getMp_total() {
        return mp_total;
    }

    public String getMp_regcode() {
        return mp_regcode;
    }

    public String getMp_command() {
        return mp_command;
    }

    public String getMp_mome() {
        return mp_mome;
    }

    public String getMp_code() {
        return mp_code;
    }

    public String getMp_createdate() {
        return mp_createdate;
    }

    public String getMp_createuser() {
        return mp_createuser;
    }

    public String getMp_modifydate() {
        return mp_modifydate;
    }

    public String getMp_modifyuser() {
        return mp_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "mp_id", "mp_fb_id", "mc_id", "mp_status", 
        "mp_mail_status", "at_id", "mp_account", "mp_password", 
        "mp_name", "mp_gender", "mp_country", "mp_personid", 
        "mp_birthday", "mp_phone", "mp_cellphone", "mp_fax", 
        "mp_county", "mp_city", "mp_zipcode", "mp_address", 
        "mp_email", "mp_unit", "mp_job", "mp_total", 
        "mp_regcode", "mp_command", "mp_mome", "mp_code", 
        "mp_createdate", "mp_createuser", "mp_modifydate", "mp_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "int", "String", "String", "String", "String", 
        "String", "String", "String", "String" };
}
