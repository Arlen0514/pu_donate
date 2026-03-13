/**
 * MisFunctionBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'mis_function'.
 */
public final class MisFunctionBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "mis_function";

    // Fields variable definition.
    private String mf_id         = "";
    private String mf_name       = "";
    private String mf_folder     = "";
    private String mf_status     = "";
    private String mf_image1     = "";
    private String mf_image2     = "";
    private String mf_topimage   = "";
    private String mf_bgcolor1   = "";
    private String mf_bgcolor2   = "";
    private String mf_type       = "";
    private String mf_url        = "";
    private String mf_upfunction = "";
    private int    mf_priority   = 0;
    private String mf_createdate = "";
    private String mf_createuser = "";
    private String mf_modifydate = "";
    private String mf_modifyuser = "";

    // Default constructor.
    public MisFunctionBean() {}

    // Setters definitions
    public void setMf_id(String mf_id) {
        this.mf_id = mf_id;
    }

    public void setMf_name(String mf_name) {
        this.mf_name = mf_name;
    }

    public void setMf_folder(String mf_folder) {
        this.mf_folder = mf_folder;
    }

    public void setMf_status(String mf_status) {
        this.mf_status = mf_status;
    }

    public void setMf_image1(String mf_image1) {
        this.mf_image1 = mf_image1;
    }

    public void setMf_image2(String mf_image2) {
        this.mf_image2 = mf_image2;
    }

    public void setMf_topimage(String mf_topimage) {
        this.mf_topimage = mf_topimage;
    }

    public void setMf_bgcolor1(String mf_bgcolor1) {
        this.mf_bgcolor1 = mf_bgcolor1;
    }

    public void setMf_bgcolor2(String mf_bgcolor2) {
        this.mf_bgcolor2 = mf_bgcolor2;
    }

    public void setMf_type(String mf_type) {
        this.mf_type = mf_type;
    }

    public void setMf_url(String mf_url) {
        this.mf_url = mf_url;
    }

    public void setMf_upfunction(String mf_upfunction) {
        this.mf_upfunction = mf_upfunction;
    }

    public void setMf_priority(int mf_priority) {
        this.mf_priority = mf_priority;
    }

    public void setMf_createdate(String mf_createdate) {
        this.mf_createdate = mf_createdate;
    }

    public void setMf_createuser(String mf_createuser) {
        this.mf_createuser = mf_createuser;
    }

    public void setMf_modifydate(String mf_modifydate) {
        this.mf_modifydate = mf_modifydate;
    }

    public void setMf_modifyuser(String mf_modifyuser) {
        this.mf_modifyuser = mf_modifyuser;
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
        vc.add(mf_id);
        vc.add(mf_name);
        vc.add(mf_folder);
        vc.add(mf_status);
        vc.add(mf_image1);
        vc.add(mf_image2);
        vc.add(mf_topimage);
        vc.add(mf_bgcolor1);
        vc.add(mf_bgcolor2);
        vc.add(mf_type);
        vc.add(mf_url);
        vc.add(mf_upfunction);
        vc.add(new Integer(mf_priority));
        vc.add(mf_createdate);
        vc.add(mf_createuser);
        vc.add(mf_modifydate);
        vc.add(mf_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getMf_id() {
        return mf_id;
    }

    public String getMf_name() {
        return mf_name;
    }

    public String getMf_folder() {
        return mf_folder;
    }

    public String getMf_status() {
        return mf_status;
    }

    public String getMf_image1() {
        return mf_image1;
    }

    public String getMf_image2() {
        return mf_image2;
    }

    public String getMf_topimage() {
        return mf_topimage;
    }

    public String getMf_bgcolor1() {
        return mf_bgcolor1;
    }

    public String getMf_bgcolor2() {
        return mf_bgcolor2;
    }

    public String getMf_type() {
        return mf_type;
    }

    public String getMf_url() {
        return mf_url;
    }

    public String getMf_upfunction() {
        return mf_upfunction;
    }

    public int getMf_priority() {
        return mf_priority;
    }

    public String getMf_createdate() {
        return mf_createdate;
    }

    public String getMf_createuser() {
        return mf_createuser;
    }

    public String getMf_modifydate() {
        return mf_modifydate;
    }

    public String getMf_modifyuser() {
        return mf_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "mf_id", "mf_name", "mf_folder", "mf_status", 
        "mf_image1", "mf_image2", "mf_topimage", "mf_bgcolor1", 
        "mf_bgcolor2", "mf_type", "mf_url", "mf_upfunction", 
        "mf_priority", "mf_createdate", "mf_createuser", "mf_modifydate", 
        "mf_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "int", "String", 
        "String", "String", "String" };
}
