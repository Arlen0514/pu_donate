/**
 * AdProfileBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'ad_profile'.
 */
public final class AdProfileBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "ad_profile";

    // Fields variable definition.
    private String ap_id             = "";
    private String ap_no             = "";
    private String ap_title          = "";
    private String ap_desc           = "";
    private String ap_upcategory     = "";
    private String ap_category       = "";
    private String ap_content        = "";
    private String ap_image          = "";
    private String ap_mobile         = "";
    private String ap_file           = "";
    private String ap_alt            = "";
    private String ap_url            = "";
    private String ap_target         = "";
    private String ap_display        = "";
    private int    ap_showseq        = 0;
    private String ap_emitdate       = "";
    private String ap_restdate       = "";
    private String ap_lang           = "";
    private String ap_code           = "";
    private String ap_webtitle       = "";
    private String ap_robots         = "";
    private String ap_revisit_after  = "";
    private String ap_keywords       = "";
    private String ap_description    = "";
    private String ap_copyright      = "";
    private String ap_seo_head_track = "";
    private String ap_seo_body_track = "";
    private String ap_createdate     = "";
    private String ap_createuser     = "";
    private String ap_modifydate     = "";
    private String ap_modifyuser     = "";

    // Default constructor.
    public AdProfileBean() {}

    // Setters definitions
    public void setAp_id(String ap_id) {
        this.ap_id = ap_id;
    }

    public void setAp_no(String ap_no) {
        this.ap_no = ap_no;
    }

    public void setAp_title(String ap_title) {
        this.ap_title = ap_title;
    }

    public void setAp_desc(String ap_desc) {
        this.ap_desc = ap_desc;
    }

    public void setAp_upcategory(String ap_upcategory) {
        this.ap_upcategory = ap_upcategory;
    }

    public void setAp_category(String ap_category) {
        this.ap_category = ap_category;
    }

    public void setAp_content(String ap_content) {
        this.ap_content = ap_content;
    }

    public void setAp_image(String ap_image) {
        this.ap_image = ap_image;
    }

    public void setAp_mobile(String ap_mobile) {
        this.ap_mobile = ap_mobile;
    }

    public void setAp_file(String ap_file) {
        this.ap_file = ap_file;
    }

    public void setAp_alt(String ap_alt) {
        this.ap_alt = ap_alt;
    }

    public void setAp_url(String ap_url) {
        this.ap_url = ap_url;
    }

    public void setAp_target(String ap_target) {
        this.ap_target = ap_target;
    }

    public void setAp_display(String ap_display) {
        this.ap_display = ap_display;
    }

    public void setAp_showseq(int ap_showseq) {
        this.ap_showseq = ap_showseq;
    }

    public void setAp_emitdate(String ap_emitdate) {
        this.ap_emitdate = ap_emitdate;
    }

    public void setAp_restdate(String ap_restdate) {
        this.ap_restdate = ap_restdate;
    }

    public void setAp_lang(String ap_lang) {
        this.ap_lang = ap_lang;
    }

    public void setAp_code(String ap_code) {
        this.ap_code = ap_code;
    }

    public void setAp_webtitle(String ap_webtitle) {
        this.ap_webtitle = ap_webtitle;
    }

    public void setAp_robots(String ap_robots) {
        this.ap_robots = ap_robots;
    }

    public void setAp_revisit_after(String ap_revisit_after) {
        this.ap_revisit_after = ap_revisit_after;
    }

    public void setAp_keywords(String ap_keywords) {
        this.ap_keywords = ap_keywords;
    }

    public void setAp_description(String ap_description) {
        this.ap_description = ap_description;
    }

    public void setAp_copyright(String ap_copyright) {
        this.ap_copyright = ap_copyright;
    }

    public void setAp_seo_head_track(String ap_seo_head_track) {
        this.ap_seo_head_track = ap_seo_head_track;
    }

    public void setAp_seo_body_track(String ap_seo_body_track) {
        this.ap_seo_body_track = ap_seo_body_track;
    }

    public void setAp_createdate(String ap_createdate) {
        this.ap_createdate = ap_createdate;
    }

    public void setAp_createuser(String ap_createuser) {
        this.ap_createuser = ap_createuser;
    }

    public void setAp_modifydate(String ap_modifydate) {
        this.ap_modifydate = ap_modifydate;
    }

    public void setAp_modifyuser(String ap_modifyuser) {
        this.ap_modifyuser = ap_modifyuser;
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
        vc.add(ap_id);
        vc.add(ap_no);
        vc.add(ap_title);
        vc.add(ap_desc);
        vc.add(ap_upcategory);
        vc.add(ap_category);
        vc.add(ap_content);
        vc.add(ap_image);
        vc.add(ap_mobile);
        vc.add(ap_file);
        vc.add(ap_alt);
        vc.add(ap_url);
        vc.add(ap_target);
        vc.add(ap_display);
        vc.add(new Integer(ap_showseq));
        vc.add(ap_emitdate);
        vc.add(ap_restdate);
        vc.add(ap_lang);
        vc.add(ap_code);
        vc.add(ap_webtitle);
        vc.add(ap_robots);
        vc.add(ap_revisit_after);
        vc.add(ap_keywords);
        vc.add(ap_description);
        vc.add(ap_copyright);
        vc.add(ap_seo_head_track);
        vc.add(ap_seo_body_track);
        vc.add(ap_createdate);
        vc.add(ap_createuser);
        vc.add(ap_modifydate);
        vc.add(ap_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getAp_id() {
        return ap_id;
    }

    public String getAp_no() {
        return ap_no;
    }

    public String getAp_title() {
        return ap_title;
    }

    public String getAp_desc() {
        return ap_desc;
    }

    public String getAp_upcategory() {
        return ap_upcategory;
    }

    public String getAp_category() {
        return ap_category;
    }

    public String getAp_content() {
        return ap_content;
    }

    public String getAp_image() {
        return ap_image;
    }

    public String getAp_mobile() {
        return ap_mobile;
    }

    public String getAp_file() {
        return ap_file;
    }

    public String getAp_alt() {
        return ap_alt;
    }

    public String getAp_url() {
        return ap_url;
    }

    public String getAp_target() {
        return ap_target;
    }

    public String getAp_display() {
        return ap_display;
    }

    public int getAp_showseq() {
        return ap_showseq;
    }

    public String getAp_emitdate() {
        return ap_emitdate;
    }

    public String getAp_restdate() {
        return ap_restdate;
    }

    public String getAp_lang() {
        return ap_lang;
    }

    public String getAp_code() {
        return ap_code;
    }

    public String getAp_webtitle() {
        return ap_webtitle;
    }

    public String getAp_robots() {
        return ap_robots;
    }

    public String getAp_revisit_after() {
        return ap_revisit_after;
    }

    public String getAp_keywords() {
        return ap_keywords;
    }

    public String getAp_description() {
        return ap_description;
    }

    public String getAp_copyright() {
        return ap_copyright;
    }

    public String getAp_seo_head_track() {
        return ap_seo_head_track;
    }

    public String getAp_seo_body_track() {
        return ap_seo_body_track;
    }

    public String getAp_createdate() {
        return ap_createdate;
    }

    public String getAp_createuser() {
        return ap_createuser;
    }

    public String getAp_modifydate() {
        return ap_modifydate;
    }

    public String getAp_modifyuser() {
        return ap_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ap_id", "ap_no", "ap_title", "ap_desc", 
        "ap_upcategory", "ap_category", "ap_content", "ap_image", 
        "ap_mobile", "ap_file", "ap_alt", "ap_url", 
        "ap_target", "ap_display", "ap_showseq", "ap_emitdate", 
        "ap_restdate", "ap_lang", "ap_code", "ap_webtitle", 
        "ap_robots", "ap_revisit_after", "ap_keywords", "ap_description", 
        "ap_copyright", "ap_seo_head_track", "ap_seo_body_track", "ap_createdate", 
        "ap_createuser", "ap_modifydate", "ap_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "int", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String" };
}
