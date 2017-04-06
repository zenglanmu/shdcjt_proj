<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page"/>
<%
 char separator = Util.getSeparator() ;
  String operation = Util.null2String(request.getParameter("operation"));
  //搜索操作
  if(operation.equalsIgnoreCase("search")||operation.equalsIgnoreCase("onFirst")||operation.equalsIgnoreCase("onPrev")||operation.equalsIgnoreCase("onNext")||operation.equalsIgnoreCase("onLast")){
    String searchcon=request.getParameter("searchcon");
	searchcon=URLEncoder.encode(searchcon);//用response.sendRedirect来传递需要转码接收方需要解码
	String labelId=request.getParameter("labelId");
	int pageNum=Util.getIntValue(request.getParameter("pageNum"));	
    if (operation.equalsIgnoreCase("search")) pageNum=1;

response.sendRedirect("ManageLabel.jsp?searchcon="+searchcon+"&labelId="+labelId+"&pageNum="+pageNum);
    return ;
  }
//添加操作
    else if(operation.equalsIgnoreCase("addlabel")){ 
  	
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
/*
  	LabelMainManager.resetParameter();
  	LabelMainManager.setIndexdesc(indexdesc);
  	LabelMainManager.setAction(operation);
  	LabelMainManager.setLabelInfo();
  	
	int id =0 ; 	
 	LabelMainManager.resetParameter();
  	LabelMainManager.setIndexdesc(indexdesc);
  	LabelMainManager.selectSigleLabelInfo();
  	if(LabelMainManager.next()) id = LabelMainManager.getId();
  	LabelMainManager.closeStatement();

	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	LabelInfoManager.resetParameter();
	  	LabelInfoManager.setAction(operation);
	  	LabelInfoManager.setIndexid(id);
	  	LabelInfoManager.setLanguageid(Util.getIntValue(langid,0));
	  	String Labelname = Util.fromScreen(request.getParameter("Labelname"+langid),user.getLanguage());
	  	LabelInfoManager.setLabelname(Labelname);
	  	LabelInfoManager.setLabelInfo();
	}
	LabelComInfo.removeLabelCache();
  	response.sendRedirect("ManageLabel.jsp");
*/
  
  	String id_1 = Util.fromScreen(request.getParameter("id_1"),user.getLanguage());
	String cfSql = "";
	if(rs.getDBType().equals("oracle")){
		cfSql="select id from (select id from htmlLabelindex where id="+id_1+") where rownum=1 ";
	}else{
		cfSql = "select top 1 id  from htmlLabelindex where id="+id_1;
	}
	rs.executeSql(cfSql); 
	if(rs.next()){
	response.sendRedirect("/systeminfo/label/addlabel.jsp?errorMsg=1");
	   return;
	} 	
	String indexdesc_1 = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	String para=""+id_1+separator+indexdesc_1;
    rs.executeProc("HtmlLabelIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		String langid=rs.getString("id");
		String labelname = Util.fromScreen(request.getParameter("labelname"+langid),user.getLanguage());
		para=""+id_1+separator+labelname+separator+langid;
		rs.executeProc("HtmlLabelInfo_Insert",para);
	}
	LabelComInfo.addLabeInfoCache(id_1);
    	response.sendRedirect("ManageLabel.jsp");
  	return ;	
 }
 
 //删除操作
 else if(operation.equalsIgnoreCase("deletelabel")){
 /*
 if(Util.getIntValue(user.getSeclevel(),0)<20){
		response.sendRedirect("ManageLabel.jsp");
	}
 */
 	String[] delete_label_id=request.getParameterValues("delete_label_id");
 	if (delete_label_id!=null){
 	
	 for(int i = 0; i < delete_label_id.length; i++){
  	String deleteSql1="delete from HtmlLabelIndex where id=" + delete_label_id[i];
  	String deleteSql2="delete from HtmlLabelInfo where indexid=" + delete_label_id[i];
        rs.executeSql(deleteSql1);
        rs.executeSql(deleteSql2);
        LabelComInfo.removeLabeInfoCache(delete_label_id[i]);
             }}
  	response.sendRedirect("ManageLabel.jsp");
  	return ;

 }
 //修改--采用先删后加的形式
 else if(operation.equalsIgnoreCase("editLabel")){ 
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	int id = Util.getIntValue(request.getParameter("id"),0);
  	
  	rs.executeSql("delete from HtmlLabelIndex where id=" + id);//删除index记录
        rs.executeSql("delete from HtmlLabelInfo where indexid=" + id);//删除info记录
  	/*
  	LabelMainManager.resetParameter();
  	LabelMainManager.setIndexdesc(indexdesc);
  	LabelMainManager.setId(id);
  	LabelMainManager.setAction(operation);
  	LabelMainManager.setLabelInfo();
  	out.print("id is " + id);
  	out.print("indexdesc is " + indexdesc);
	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	LabelInfoManager.resetParameter();
	  	LabelInfoManager.setAction(operation);
	  	LabelInfoManager.setIndexid(id);
	  	LabelInfoManager.setLanguageid(Util.getIntValue(langid,0));
	  	String Labelname = Util.fromScreen(request.getParameter("Labelname"+langid),user.getLanguage());
	  	LabelInfoManager.setLabelname(Labelname);
	  	out.print("Labelname is " + Labelname);
	  	LabelInfoManager.setLabelInfo();
	}
	LabelComInfo.removeLabelCache();
	*/
	
   String para=""+id+separator+indexdesc;
    rs.executeProc("HtmlLabelIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		String langid=rs.getString("id");
		String labelname = Util.fromScreen(request.getParameter("labelname"+langid),user.getLanguage());
		para=""+id+separator+labelname+separator+langid;
		rs.executeProc("HtmlLabelInfo_Insert",para);
	}
	LabelComInfo.addLabeInfoCache(id+"");
 	response.sendRedirect("/systeminfo/label/ManageLabel.jsp");
 }
%>