<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
response.setDateHeader("Expires",0);
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<%
String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
if(superiorFieldId.equals("")){
	superiorFieldId="0";
}

String currentTreeDocFieldId="";
String currentTreeDocFieldName="";
String currentSuperiorFieldId="";
String currentIsLast="";

StringBuffer treeStr = new StringBuffer("[");

DocTreeDocFieldComInfo.setTofirstRow();
int treecnt = 0;
while(DocTreeDocFieldComInfo.next()){
 	currentSuperiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId();
    if(!currentSuperiorFieldId.equals(superiorFieldId)) {
			continue;
    }

 	currentTreeDocFieldId = DocTreeDocFieldComInfo.getId();
 	currentTreeDocFieldName = DocTreeDocFieldComInfo.getTreeDocFieldName();
 	currentIsLast = DocTreeDocFieldComInfo.getIsLast();

	if (treecnt != 0) {
		treeStr.append(", ");
	}
	treecnt++;
 	treeStr.append("{ ");
 	
 	treeStr.append("id:\"" + currentTreeDocFieldId + "\", ");
 	treeStr.append("pId:\"" + superiorFieldId + "\", ");
 	
    //text
    treeStr.append("name:\"");
    treeStr.append(
    Util.replace(
        		Util.replace(
   				Util.replace(
   				Util.replace(
   				Util.replace(
				currentTreeDocFieldName
        		,"<","&lt;",0)
        		,">","&gt;",0)
        		,"&","&amp;",0)
        		,"'","&apos;",0)
        		,"\"","&quot;",0)        		
        		);
    treeStr.append("\", ");


    //action
    treeStr.append("url:\"");
    treeStr.append("javascript:onClickTreeDocField("+currentTreeDocFieldId+");");
    treeStr.append("\", ");
		
    if(!"1".equals(currentIsLast)){
        //icon
        treeStr.append("iconClose:\"/images/treemaker/clsfld.gif\", ");
        //openIcon
        treeStr.append("iconOpen:\"/images/treemaker/openfld.gif\", ");
        //src
        treeStr.append("ajaxParam:\"superiorFieldId=" + currentTreeDocFieldId + "\", ");
        treeStr.append("isParent:true, ");
    }else{
        //icon
        treeStr.append("icon:\"/images/treemaker/link.gif\", ");
	}
    //target
    treeStr.append("target:\"_self\" ");      
    treeStr.append(" }");
           
}
treeStr.append("]");
System.out.println(treeStr.toString());
out.print(treeStr.toString()); 
%>

