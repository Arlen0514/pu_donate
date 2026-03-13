/**
 * ContentProfileBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2026/01/09 09:45:07
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'content_profile'.
 */
public final class ContentProfileBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "content_profile";

    // Fields variable definition.
    private String cp_id             = "";
    private String cp_no             = "";
    private String cp_title          = "";
    private String cp_subtitle       = "";
    private String cp_desc           = "";
    private String cp_upcategory     = "";
    private String cp_category       = "";
    private String cp_content        = "";
    private String cp_content2       = "";
    private String cp_name           = "";
    private String cp_phone          = "";
    private String cp_email          = "";
    private String cp_usage          = "";
    private String cp_attr           = "";
    private String cp_image          = "";
    private String cp_mobile         = "";
    private String cp_file           = "";
    private String cp_alt            = "";
    private String cp_video          = "";
    private String cp_url            = "";
    private int    cp_goal           = 0;
    private String cp_show_goal      = "";
    private String cp_target         = "";
    private String cp_display        = "";
    private int    cp_showseq        = 0;
    private String cp_emitdate       = "";
    private String cp_restdate       = "";
    private String cp_lang           = "";
    private String cp_code           = "";
    private String cp_webtitle       = "";
    private String cp_robots         = "";
    private String cp_revisit_after  = "";
    private String cp_keywords       = "";
    private String cp_description    = "";
    private String cp_copyright      = "";
    private String cp_seo_head_track = "";
    private String cp_seo_body_track = "";
    private String cp_createdate     = "";
    private String cp_createuser     = "";
    private String cp_modifydate     = "";
    private String cp_modifyuser     = "";

    // Default constructor.
    public ContentProfileBean() {}

    // Setters definitions
    public void setCp_id(String cp_id) {
        this.cp_id = cp_id;
    }

    public void setCp_no(String cp_no) {
        this.cp_no = cp_no;
    }

    public void setCp_title(String cp_title) {
        this.cp_title = cp_title;
    }

    public void setCp_subtitle(String cp_subtitle) {
        this.cp_subtitle = cp_subtitle;
    }

    public void setCp_desc(String cp_desc) {
        this.cp_desc = cp_desc;
    }

    public void setCp_upcategory(String cp_upcategory) {
        this.cp_upcategory = cp_upcategory;
    }

    public void setCp_category(String cp_category) {
        this.cp_category = cp_category;
    }

    public void setCp_content(String cp_content) {
        this.cp_content = cp_content;
    }

    public void setCp_content2(String cp_content2) {
        this.cp_content2 = cp_content2;
    }

    public void setCp_name(String cp_name) {
        this.cp_name = cp_name;
    }

    public void setCp_phone(String cp_phone) {
        this.cp_phone = cp_phone;
    }

    public void setCp_email(String cp_email) {
        this.cp_email = cp_email;
    }

    public void setCp_usage(String cp_usage) {
        this.cp_usage = cp_usage;
    }

    public void setCp_attr(String cp_attr) {
        this.cp_attr = cp_attr;
    }

    public void setCp_image(String cp_image) {
        this.cp_image = cp_image;
    }

    public void setCp_mobile(String cp_mobile) {
        this.cp_mobile = cp_mobile;
    }

    public void setCp_file(String cp_file) {
        this.cp_file = cp_file;
    }

    public void setCp_alt(String cp_alt) {
        this.cp_alt = cp_alt;
    }

    public void setCp_video(String cp_video) {
        this.cp_video = cp_video;
    }

    public void setCp_url(String cp_url) {
        this.cp_url = cp_url;
    }

    public void setCp_goal(int cp_goal) {
        this.cp_goal = cp_goal;
    }

    public void setCp_show_goal(String cp_show_goal) {
        this.cp_show_goal = cp_show_goal;
    }

    public void setCp_target(String cp_target) {
        this.cp_target = cp_target;
    }

    public void setCp_display(String cp_display) {
        this.cp_display = cp_display;
    }

    public void setCp_showseq(int cp_showseq) {
        this.cp_showseq = cp_showseq;
    }

    public void setCp_emitdate(String cp_emitdate) {
        this.cp_emitdate = cp_emitdate;
    }

    public void setCp_restdate(String cp_restdate) {
        this.cp_restdate = cp_restdate;
    }

    public void setCp_lang(String cp_lang) {
        this.cp_lang = cp_lang;
    }

    public void setCp_code(String cp_code) {
        this.cp_code = cp_code;
    }

    public void setCp_webtitle(String cp_webtitle) {
        this.cp_webtitle = cp_webtitle;
    }

    public void setCp_robots(String cp_robots) {
        this.cp_robots = cp_robots;
    }

    public void setCp_revisit_after(String cp_revisit_after) {
        this.cp_revisit_after = cp_revisit_after;
    }

    public void setCp_keywords(String cp_keywords) {
        this.cp_keywords = cp_keywords;
    }

    public void setCp_description(String cp_description) {
        this.cp_description = cp_description;
    }

    public void setCp_copyright(String cp_copyright) {
        this.cp_copyright = cp_copyright;
    }

    public void setCp_seo_head_track(String cp_seo_head_track) {
        this.cp_seo_head_track = cp_seo_head_track;
    }

    public void setCp_seo_body_track(String cp_seo_body_track) {
        this.cp_seo_body_track = cp_seo_body_track;
    }

    public void setCp_createdate(String cp_createdate) {
        this.cp_createdate = cp_createdate;
    }

    public void setCp_createuser(String cp_createuser) {
        this.cp_createuser = cp_createuser;
    }

    public void setCp_modifydate(String cp_modifydate) {
        this.cp_modifydate = cp_modifydate;
    }

    public void setCp_modifyuser(String cp_modifyuser) {
        this.cp_modifyuser = cp_modifyuser;
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
        vc.add(cp_id);
        vc.add(cp_no);
        vc.add(cp_title);
        vc.add(cp_subtitle);
        vc.add(cp_desc);
        vc.add(cp_upcategory);
        vc.add(cp_category);
        vc.add(cp_content);
        vc.add(cp_content2);
        vc.add(cp_name);
        vc.add(cp_phone);
        vc.add(cp_email);
        vc.add(cp_usage);
        vc.add(cp_attr);
        vc.add(cp_image);
        vc.add(cp_mobile);
        vc.add(cp_file);
        vc.add(cp_alt);
        vc.add(cp_video);
        vc.add(cp_url);
        vc.add(new Integer(cp_goal));
        vc.add(cp_show_goal);
        vc.add(cp_target);
        vc.add(cp_display);
        vc.add(new Integer(cp_showseq));
        vc.add(cp_emitdate);
        vc.add(cp_restdate);
        vc.add(cp_lang);
        vc.add(cp_code);
        vc.add(cp_webtitle);
        vc.add(cp_robots);
        vc.add(cp_revisit_after);
        vc.add(cp_keywords);
        vc.add(cp_description);
        vc.add(cp_copyright);
        vc.add(cp_seo_head_track);
        vc.add(cp_seo_body_track);
        vc.add(cp_createdate);
        vc.add(cp_createuser);
        vc.add(cp_modifydate);
        vc.add(cp_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getCp_id() {
        return cp_id;
    }

    public String getCp_no() {
        return cp_no;
    }

    public String getCp_title() {
        return cp_title;
    }

    public String getCp_subtitle() {
        return cp_subtitle;
    }

    public String getCp_desc() {
        return cp_desc;
    }

    public String getCp_upcategory() {
        return cp_upcategory;
    }

    public String getCp_category() {
        return cp_category;
    }

    public String getCp_content() {
        return cp_content;
    }

    public String getCp_content2() {
        return cp_content2;
    }

    public String getCp_name() {
        return cp_name;
    }

    public String getCp_phone() {
        return cp_phone;
    }

    public String getCp_email() {
        return cp_email;
    }

    public String getCp_usage() {
        return cp_usage;
    }

    public String getCp_attr() {
        return cp_attr;
    }

    public String getCp_image() {
        return cp_image;
    }

    public String getCp_mobile() {
        return cp_mobile;
    }

    public String getCp_file() {
        return cp_file;
    }

    public String getCp_alt() {
        return cp_alt;
    }

    public String getCp_video() {
        return cp_video;
    }

    public String getCp_url() {
        return cp_url;
    }

    public int getCp_goal() {
        return cp_goal;
    }

    public String getCp_show_goal() {
        return cp_show_goal;
    }

    public String getCp_target() {
        return cp_target;
    }

    public String getCp_display() {
        return cp_display;
    }

    public int getCp_showseq() {
        return cp_showseq;
    }

    public String getCp_emitdate() {
        return cp_emitdate;
    }

    public String getCp_restdate() {
        return cp_restdate;
    }

    public String getCp_lang() {
        return cp_lang;
    }

    public String getCp_code() {
        return cp_code;
    }

    public String getCp_webtitle() {
        return cp_webtitle;
    }

    public String getCp_robots() {
        return cp_robots;
    }

    public String getCp_revisit_after() {
        return cp_revisit_after;
    }

    public String getCp_keywords() {
        return cp_keywords;
    }

    public String getCp_description() {
        return cp_description;
    }

    public String getCp_copyright() {
        return cp_copyright;
    }

    public String getCp_seo_head_track() {
        return cp_seo_head_track;
    }

    public String getCp_seo_body_track() {
        return cp_seo_body_track;
    }

    public String getCp_createdate() {
        return cp_createdate;
    }

    public String getCp_createuser() {
        return cp_createuser;
    }

    public String getCp_modifydate() {
        return cp_modifydate;
    }

    public String getCp_modifyuser() {
        return cp_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "cp_id", "cp_no", "cp_title", "cp_subtitle", 
        "cp_desc", "cp_upcategory", "cp_category", "cp_content", 
        "cp_content2", "cp_name", "cp_phone", "cp_email", 
        "cp_usage", "cp_attr", "cp_image", "cp_mobile", 
        "cp_file", "cp_alt", "cp_video", "cp_url", 
        "cp_goal", "cp_show_goal", "cp_target", "cp_display", 
        "cp_showseq", "cp_emitdate", "cp_restdate", "cp_lang", 
        "cp_code", "cp_webtitle", "cp_robots", "cp_revisit_after", 
        "cp_keywords", "cp_description", "cp_copyright", "cp_seo_head_track", 
        "cp_seo_body_track", "cp_createdate", "cp_createuser", "cp_modifydate", 
        "cp_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "int", 
        "String", "String", "String", "int", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String" };
}
