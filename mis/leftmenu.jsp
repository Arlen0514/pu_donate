<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// Current top function record.
	TableRecord ctmf = (TableRecord)session.getAttribute("current_top");
	Vector <TableRecord> _clmfs = null;
	
	// Current left function records(level 2).
	_clmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { ctmf.getValue("mf_id") }, "mf_priority");
	
	String drf_upfunction = StringTool.validString((String)session.getAttribute("upfunction"),"");
	String upfunction = StringTool.validString(request.getParameter("upfunction"),drf_upfunction);
	session.setAttribute("upfunction", upfunction);
	
	String new_url = request.getServletPath();
%>
        
                            <!--左側-->
                            <div class="left_mis">

                                <!-- 分類切換按鈕 -->
                                <div class="category_changeButton">
                                    <a href="javascript:void(0);">
                                        <%=app_ctmf.getString("mf_name") %>
                                    </a>
                                </div>
                                
                                <!--左側選單列表-->	
                                <div class="leftListArea">
<%
	//有第二層 
	for (TableRecord  _clmf: _clmfs) {
		boolean have_first = false;
	 	Vector <TableRecord> amf_lefts = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?", new Object[] { app_user.getValue("au_id"), _clmf.getString("mf_id") });
		if (amf_lefts.size() > 0 || app_user.getString("au_account").equals("root")) have_first = true;
		if (have_first){ 
			// 確認是否有下一層
			boolean have_second = false;
			Vector <TableRecord> second_lmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { _clmf.getString("mf_id") }, "mf_priority");
			if (second_lmfs.size() > 0 ) have_second = true;
			
			boolean onpen_list = _clmf.getString("mf_id").equals(upfunction);
			
			// 確認網址是否為此，為此哲當前模式
			boolean this_fun = false;
			
		if(have_second){ 
		
%>
                                    <div class="leftList<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
                                        
                                        <!--功能名稱-->
                                        <div class="leftList_title">
                                            
                                            <a href="javascript:void(0);">
                                                 <%=_clmf.getString("mf_name") %>
                                            </a>
                                            <!--方向標誌-->
                                            <div class="leftList_icon direction">
                                                <!--方向標誌_向下展開-->
                                                <i class="material-icons down">keyboard_arrow_down</i>
                                                <!--方向標誌_向上收合-->
                                                <i class="material-icons up">keyboard_arrow_up</i>
                                            </div>
                                        </div>
                                        
                                        <!--展開選單-->
                                        <div class="leftList_open<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
			<%for(TableRecord second_lmf : second_lmfs){
				Vector check_second_lmfs = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?",
						new Object[] { app_user.getValue("au_id"), second_lmf.getString("mf_id") });
				
				String conf_url = ctmf.getString("mf_folder") +"/" + second_lmf.getString("mf_url");
				if (check_second_lmfs.size() > 0 || app_user.getString("au_account").equals("root")) {
					this_fun = new_url.indexOf(conf_url)>-1;
			%>    	                            
                                            <div class="leftList_open_list<%=this_fun?" active":"" %>"><!-- 當前模式 class加上active -->
                                                
                                                <div class="leftList_sec_area">
                                                    <div class="leftList_sec_title<%=this_fun?" active":"" %>"><!-- 當前模式 class加上active -->
                                                        <a href="../<%=ctmf.getString("mf_folder") %>/<%=second_lmf.getString("mf_url") %>?upfunction=<%=_clmf.getString("mf_id") %>" >
                                                            <%=second_lmf.getString("mf_name") %>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
				<%} %>
			<%} %>                            
                            

                                        </div>
                                    </div>
			<%
				}else if(!have_second && have_first){
					String conf_url = ctmf.getString("mf_folder") +"/" + _clmf.getString("mf_url");
					this_fun = new_url.indexOf(conf_url)>-1;
			%> 
                                    <div class="leftList<%=this_fun?" active":"" %>">  <%--=onpen_list?" active":"" --%>                                       
                                        <!--功能名稱-->
                                        <div class="leftList_title<%=this_fun?" active":"" %>">                                            
                                            <a href="../<%=ctmf.getString("mf_folder") %>/<%=_clmf.getString("mf_url") %>?upfunction=0">
                            						<%=_clmf.getString("mf_name") %>
                                            </a>
                                        </div>
                                    </div>
			<%}%>
		<%} %>
	<%} %>	
                                    
                                </div>
                            </div>