<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/homepage/element/content/Common.jsp" %>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		strsqlwhere 格式为 条件1^,^条件2...
		perpage  显示页数
		linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList
	*/

%>
<TABLE id='_contenttable_<%=eid%>' class="Econtent"  width="100%">
<TR>
    <TD width="1px"></TD>
    <TD width="*">      
    <TABLE width="100%">          
     <%
int mailId = 0;
String priority = "";
String senddate = "";

int size=fieldIdList.size();
           int rowcount=0;
           String imgSymbol="";
           if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
			
	        strsqlwhere = Util.StringReplace(strsqlwhere, "^,^"," & ");
	   		
	   		
	   		ArrayList setList=Util.TokenizerString(strsqlwhere,"&");
   		//if()
	   		if(setList.size()>1){
	   			rs.executeSql("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' AND folderId>=0 ORDER BY senddate DESC");
	   			//System.out.println("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' AND folderId>=0 ORDER BY senddate DESC");
	   		}else if(setList.size()>0){
	   			//checked2 = "checked";
	   		
	   			if(setList.get(0).equals("1")){
	   				
	   				rs.executeSql("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' and isInternal='1' AND folderId>=0 ORDER BY senddate DESC");
	   			}else{
	   				
	   				rs.executeSql("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' and (isInternal!=1 or isInternal is null) AND folderId>=0 ORDER BY senddate DESC");
	   			}
	   		}
	   		
	   		//rs.executeSql("SELECT * FROM MailResource WHERE resourceid="+user.getUID()+" AND status='0' AND folderId>=0 ORDER BY senddate DESC");
           while(rs.next() && rowcount<perpage && size>0){
				  mailId = rs.getInt("id");
				  priority = rs.getString("priority");
				  senddate = rs.getString("senddate");
				 
           %>
            <TR  height="18px">
                <TD width="8"><%=imgSymbol%></TD>
                <%
                    
                    for(int i=0;i<size;i++){
                        String fieldId=(String)fieldIdList.get(i);
                        String columnName=(String)fieldColumnList.get(i);
                        String strIsDate=(String)fieldIsDate.get(i);
                        String fieldTransMethod=(String)fieldTransMethodList.get(i);
                        String fieldwidth=(String)fieldWidthList.get(i);
                        String linkurl=(String)linkurlList.get(i);
                        String valuecolumn=(String)valuecolumnList.get(i);
                        String isLimitLength=(String)isLimitLengthList.get(i);
                        String showValue="";                    
                        String cloumnValue=Util.null2String(rs.getString(columnName));
                        String urlValue=Util.null2String(rs.getString(valuecolumn));
                        String url="/email/new/MailInBox.jsp?mailid="+mailId;
                        String titleValue=cloumnValue;                  
                        if("1".equals(isLimitLength))   cloumnValue=hpu.getLimitStr(eid,fieldId,cloumnValue,user,hpid,subCompanyId);
    
                       
                        if("1".equals(linkmode))
                            showValue="<a href='"+url+"' target='_self'><font class='font'>"+cloumnValue+"</font></a>";
                        else 
                            showValue="<a href=\"javascript:openFullWindowForXtable('"+url+"')\"><font class='font'>"+cloumnValue+"</font></a>";
                   

								
        %>
<%if("subject".equals(columnName)){%>
<TD width="<%=fieldwidth%>" <%if("1".equals(isLimitLength)) out.println(" title=\""+titleValue+"\"");%>><%=showValue%></TD>
<%}%>
<%if("priority".equals(columnName)){%>
<TD>
	<font class='font'>
	<%if(priority.equals("3")){out.print(SystemEnv.getHtmlLabelName(2086, user.getLanguage()));}
		else if(priority.equals("2")){out.print(SystemEnv.getHtmlLabelName(15533, user.getLanguage()));}
		else if(priority.equals("4")){out.print(SystemEnv.getHtmlLabelName(19952, user.getLanguage()));}%>
	</font>
</TD>
<%}%>
<%if("senddate".equals(columnName)){%>
<TD align="right"><font class='font'><%=senddate%></font></TD>
<%}%>
                <%}%>
            </TR>
            <%
            rowcount++;     
            if(rowcount<perpage){%>
                <TR class='sparator' style="height:1px" height=1px><td colspan=<%=size+1%> style='padding:0px'></td></TR>
            <%}%>
            
            <%}%>

<%if(rowcount==perpage){%>
<TR class='sparator' style="height:1px" height=1px><td colspan=<%=size+1%> style='padding:0px'></td></TR>
<%}%>
<TR height="18px">
<TD width="8"><%=imgSymbol%></TD>
<td colspan="<%=size%>">
	<font class='font'>
	<%=SystemEnv.getHtmlLabelName(20265,user.getLanguage())%>:
	<%
	rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");
	while(rs.next()){
	%>
	<%=rs.getString("accountName")%><span id="span<%=rs.getInt("id")%><%=eid%>" style="font:12px MS Shell Dlg,Verdana"><img src="/images/loading2.gif" style="height:16px;vertical-align:middle"/></span>
	<iframe id="iframe<%=rs.getInt("id")%><%=eid%>" style='display:none'
			style="width:0;height:0" 
			src="/email/UnreadOnMailServer.jsp?mailAccountId=<%=rs.getInt("id")%>" 
			onload="showUnreadNumber(<%=rs.getInt("id")%><%=eid%>)"></iframe>
	<%}%>
	&nbsp;<a href="javascript:gotoMail()" style="color:blue;text-decoration:underline"><%=SystemEnv.getHtmlLabelName(20267,user.getLanguage())%></a>
	</font>
</td>
</TR>

    </TABLE>
    </TD>
    <TD width="1px"></TD>
</TR>
</TABLE>

<script>
	//
	function gotoMail(){
		//$(".menuItem[levelid='536']",parent.document.body).trigger("click");
		if($(".menuItem[levelid='536']",parent.document.body).length>0){
			$(".menuItem[levelid='536']",parent.document.body).trigger("click");
		}else{
			$("#tbl",$("#LeftMenuFrame",parent.document.body)[0].contentWindow.document.body).find("td[extra='myEmail']").trigger("click");
			window.open("/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime(), "mainFrame");
		}
		
	}
</script>