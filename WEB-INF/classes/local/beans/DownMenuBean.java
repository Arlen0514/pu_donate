/**
 * DownMenuBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2025/05/02 17:16:13
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'down_menu'.
 */
public final class DownMenuBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "down_menu";

    // Fields variable definition.
    private String dm_id             = "";
    private String dm_title          = "";
    private String dm_subtitle       = "";
    private String dm_image          = "";
    private String dm_image2         = "";
    private String dm_icon           = "";
    private String dm_desc           = "";
    private String dm_content        = "";
    private String dm_upcategory     = "";
    private String dm_category       = "";
    private String dm_lock           = "";
    private int    dm_showseq        = 0;
    private String dm_lang           = "";
    private String dm_code           = "";
    private String dm_webtitle       = "";
    private String dm_robots         = "";
    private String dm_revisit_after  = "";
    private String dm_keywords       = "";
    private String dm_description    = "";
    private String dm_copyright      = "";
    private String dm_seo_head_track = "";
    private String dm_seo_body_track = "";
    private String dm_createdate     = "";
    private String dm_createuser     = "";
    private String dm_modifydate     = "";
    private String dm_modifyuser     = "";

    // Default constructor.
    public DownMenuBean() {}

    // Setters definitions
    public void setDm_id(String dm_id) {
        this.dm_id = dm_id;
    }

    public void setDm_title(String dm_title) {
        this.dm_title = dm_title;
    }

    public void setDm_subtitle(String dm_subtitle) {
        this.dm_subtitle = dm_subtitle;
    }

    public void setDm_image(String dm_image) {
        this.dm_image = dm_image;
    }

    public void setDm_image2(String dm_image2) {
        this.dm_image2 = dm_image2;
    }

    public void setDm_icon(String dm_icon) {
        this.dm_icon = dm_icon;
    }

    public void setDm_desc(String dm_desc) {
        this.dm_desc = dm_desc;
    }

    public void setDm_content(String dm_content) {
        this.dm_content = dm_content;
    }

    public void setDm_upcategory(String dm_upcategory) {
        this.dm_upcategory = dm_upcategory;
    }

    public void setDm_category(String dm_category) {
        this.dm_category = dm_category;
    }

    public void setDm_lock(String dm_lock) {
        this.dm_lock = dm_lock;
    }

    public void setDm_showseq(int dm_showseq) {
        this.dm_showseq = dm_showseq;
    }

    public void setDm_lang(String dm_lang) {
        this.dm_lang = dm_lang;
    }

    public void setDm_code(String dm_code) {
        this.dm_code = dm_code;
    }

    public void setDm_webtitle(String dm_webtitle) {
        this.dm_webtitle = dm_webtitle;
    }

    public void setDm_robots(String dm_robots) {
        this.dm_robots = dm_robots;
    }

    public void setDm_revisit_after(String dm_revisit_after) {
        this.dm_revisit_after = dm_revisit_after;
    }

    public void setDm_keywords(String dm_keywords) {
        this.dm_keywords = dm_keywords;
    }

    public void setDm_description(String dm_description) {
        this.dm_description = dm_description;
    }

    public void setDm_copyright(String dm_copyright) {
        this.dm_copyright = dm_copyright;
    }

    public void setDm_seo_head_track(String dm_seo_head_track) {
        this.dm_seo_head_track = dm_seo_head_track;
    }

    public void setDm_seo_body_track(String dm_seo_body_track) {
        this.dm_seo_body_track = dm_seo_body_track;
    }

    public void setDm_createdate(String dm_createdate) {
        this.dm_createdate = dm_createdate;
    }

    public void setDm_createuser(String dm_createuser) {
        this.dm_createuser = dm_createuser;
    }

    public void setDm_modifydate(String dm_modifydate) {
        this.dm_modifydate = dm_modifydate;
    }

    public void setDm_modifyuser(String dm_modifyuser) {
        this.dm_modifyuser = dm_modifyuser;
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
        vc.add(dm_id);
        vc.add(dm_title);
        vc.add(dm_subtitle);
        vc.add(dm_image);
        vc.add(dm_image2);
        vc.add(dm_icon);
        vc.add(dm_desc);
        vc.add(dm_content);
        vc.add(dm_upcategory);
        vc.add(dm_category);
        vc.add(dm_lock);
        vc.add(new Integer(dm_showseq));
        vc.add(dm_lang);
        vc.add(dm_code);
        vc.add(dm_webtitle);
        vc.add(dm_robots);
        vc.add(dm_revisit_after);
        vc.add(dm_keywords);
        vc.add(dm_description);
        vc.add(dm_copyright);
        vc.add(dm_seo_head_track);
        vc.add(dm_seo_body_track);
        vc.add(dm_createdate);
        vc.add(dm_createuser);
        vc.add(dm_modifydate);
        vc.add(dm_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getDm_id() {
        return dm_id;
    }

    public String getDm_title() {
        return dm_title;
    }

    public String getDm_subtitle() {
        return dm_subtitle;
    }

    public String getDm_image() {
        return dm_image;
    }

    public String getDm_image2() {
        return dm_image2;
    }

    public String getDm_icon() {
        return dm_icon;
    }

    public String getDm_desc() {
        return dm_desc;
    }

    public String getDm_content() {
        return dm_content;
    }

    public String getDm_upcategory() {
        return dm_upcategory;
    }

    public String getDm_category() {
        return dm_category;
    }

    public String getDm_lock() {
        return dm_lock;
    }

    public int getDm_showseq() {
        return dm_showseq;
    }

    public String getDm_lang() {
        return dm_lang;
    }

    public String getDm_code() {
        return dm_code;
    }

    public String getDm_webtitle() {
        return dm_webtitle;
    }

    public String getDm_robots() {
        return dm_robots;
    }

    public String getDm_revisit_after() {
        return dm_revisit_after;
    }

    public String getDm_keywords() {
        return dm_keywords;
    }

    public String getDm_description() {
        return dm_description;
    }

    public String getDm_copyright() {
        return dm_copyright;
    }

    public String getDm_seo_head_track() {
        return dm_seo_head_track;
    }

    public String getDm_seo_body_track() {
        return dm_seo_body_track;
    }

    public String getDm_createdate() {
        return dm_createdate;
    }

    public String getDm_createuser() {
        return dm_createuser;
    }

    public String getDm_modifydate() {
        return dm_modifydate;
    }

    public String getDm_modifyuser() {
        return dm_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "dm_id", "dm_title", "dm_subtitle", "dm_image", 
        "dm_image2", "dm_icon", "dm_desc", "dm_content", 
        "dm_upcategory", "dm_category", "dm_lock", "dm_showseq", 
        "dm_lang", "dm_code", "dm_webtitle", "dm_robots", 
        "dm_revisit_after", "dm_keywords", "dm_description", "dm_copyright", 
        "dm_seo_head_track", "dm_seo_body_track", "dm_createdate", "dm_createuser", 
        "dm_modifydate", "dm_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "int", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
