/**
 * NightRunBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/07/03 16:09:39
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'night_run'.
 */
public final class NightRunBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "night_run";

    // Fields variable definition.
    private String nr_id         = "";
    private String nr_status     = "";
    private String nr_keyword    = "";
    private String nr_title      = "";
    private String nr_patten     = "";
    private String nr_path       = "";
    private String nr_day        = "";
    private String nr_time       = "";
    private int    nr_interval   = 0;
    private int    nr_delay      = 0;
    private String nr_code       = "";
    private String nr_lang       = "";
    private String nr_createdate = "";
    private String nr_createuser = "";
    private String nr_modifydate = "";
    private String nr_modifyuser = "";

    // Default constructor.
    public NightRunBean() {}

    // Setters definitions
    public void setNr_id(String nr_id) {
        this.nr_id = nr_id;
    }

    public void setNr_status(String nr_status) {
        this.nr_status = nr_status;
    }

    public void setNr_keyword(String nr_keyword) {
        this.nr_keyword = nr_keyword;
    }

    public void setNr_title(String nr_title) {
        this.nr_title = nr_title;
    }

    public void setNr_patten(String nr_patten) {
        this.nr_patten = nr_patten;
    }

    public void setNr_path(String nr_path) {
        this.nr_path = nr_path;
    }

    public void setNr_day(String nr_day) {
        this.nr_day = nr_day;
    }

    public void setNr_time(String nr_time) {
        this.nr_time = nr_time;
    }

    public void setNr_interval(int nr_interval) {
        this.nr_interval = nr_interval;
    }

    public void setNr_delay(int nr_delay) {
        this.nr_delay = nr_delay;
    }

    public void setNr_code(String nr_code) {
        this.nr_code = nr_code;
    }

    public void setNr_lang(String nr_lang) {
        this.nr_lang = nr_lang;
    }

    public void setNr_createdate(String nr_createdate) {
        this.nr_createdate = nr_createdate;
    }

    public void setNr_createuser(String nr_createuser) {
        this.nr_createuser = nr_createuser;
    }

    public void setNr_modifydate(String nr_modifydate) {
        this.nr_modifydate = nr_modifydate;
    }

    public void setNr_modifyuser(String nr_modifyuser) {
        this.nr_modifyuser = nr_modifyuser;
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
        vc.add(nr_id);
        vc.add(nr_status);
        vc.add(nr_keyword);
        vc.add(nr_title);
        vc.add(nr_patten);
        vc.add(nr_path);
        vc.add(nr_day);
        vc.add(nr_time);
        vc.add(new Integer(nr_interval));
        vc.add(new Integer(nr_delay));
        vc.add(nr_code);
        vc.add(nr_lang);
        vc.add(nr_createdate);
        vc.add(nr_createuser);
        vc.add(nr_modifydate);
        vc.add(nr_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getNr_id() {
        return nr_id;
    }

    public String getNr_status() {
        return nr_status;
    }

    public String getNr_keyword() {
        return nr_keyword;
    }

    public String getNr_title() {
        return nr_title;
    }

    public String getNr_patten() {
        return nr_patten;
    }

    public String getNr_path() {
        return nr_path;
    }

    public String getNr_day() {
        return nr_day;
    }

    public String getNr_time() {
        return nr_time;
    }

    public int getNr_interval() {
        return nr_interval;
    }

    public int getNr_delay() {
        return nr_delay;
    }

    public String getNr_code() {
        return nr_code;
    }

    public String getNr_lang() {
        return nr_lang;
    }

    public String getNr_createdate() {
        return nr_createdate;
    }

    public String getNr_createuser() {
        return nr_createuser;
    }

    public String getNr_modifydate() {
        return nr_modifydate;
    }

    public String getNr_modifyuser() {
        return nr_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "nr_id", "nr_status", "nr_keyword", "nr_title", 
        "nr_patten", "nr_path", "nr_day", "nr_time", 
        "nr_interval", "nr_delay", "nr_code", "nr_lang", 
        "nr_createdate", "nr_createuser", "nr_modifydate", "nr_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "int", "int", "String", "String", "String", "String", 
        "String", "String" };
}
