<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
   boolean canSetDocPopUp = HrmUserVarify.checkUserRight("Docs:SetPopUp", user);
   if(!canSetDocPopUp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
   }

   String docsid = Util.null2String(request.getParameter("docsid"));
   String operate = Util.null2String(request.getParameter("operate"));
   String isShowPop = "0";
   String sqlstr = "";
   
   String startDate = Util.null2String(request.getParameter("startDate"));
   String endDate = Util.null2String(request.getParameter("endDate"));
   String pop_num = Util.null2String(request.getParameter("pop_num"));
   String pop_hight = Util.null2String(request.getParameter("pop_hight"));
   String pop_width = Util.null2String(request.getParameter("pop_width"));
   
   if("save".equals(operate)){
      sqlstr = "insert into DocPopUpInfo(docid,pop_startdate,pop_enddate,pop_num,pop_hight,pop_width,is_popnum) values ("+docsid+",'"+startDate+"','"+endDate+"','"+pop_num+"','"+pop_hight+"','"+pop_width+"',0)";
      RecordSet.executeSql(sqlstr);
   }
   if("update".equals(operate)){
     sqlstr = "update DocPopUpInfo set pop_startdate = '"+startDate+"',pop_enddate = '"+endDate+"',pop_num = '"+pop_num+"',pop_hight = '"+pop_hight+"',pop_width ='"+pop_width+"' where docid = "+docsid;
     RecordSet.executeSql(sqlstr);
   }
   if("delete".equals(operate)){
     RecordSet.executeSql("delete from DocPopUpInfo where docid = "+docsid);
   }
   
   RecordSet.executeSql("select * from DocPopUpInfo where docid = "+docsid);
   if(RecordSet.next()){
     startDate = RecordSet.getString("pop_startdate");
     endDate = RecordSet.getString("pop_enddate");
     pop_num = RecordSet.getString("pop_num");
     pop_hight = RecordSet.getString("pop_hight");
     pop_width = RecordSet.getString("pop_width");
     isShowPop = "1";
   }

%>

<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = "";
	String needfav = "";
	String needhelp = "";
%>
<html>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<FORM id=weaver name=weaver action="PopUpDocSet.jsp" method=post>
<input type=hidden name="operate">
<input type=hidden name="docsid">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	
	<tr style="height: 10px!important;">
		<td height="10"></td>
	</tr>
	<tr>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<TABLE class=ViewForm>
							<COLGROUP>
								<COL width="30%">
								<COL width="70%">
							<TBODY>
								<TR>
									<TD colSpan=2>
										<B><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></B>
									</TD>
								</TR>
								<TR class=Spacing style="height: 1px!important;">
									<TD class=Line1 colSpan=2></TD>
								</TR>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(21879,user.getLanguage())%>
									</TD>
									<TD class="field">
										<input class="inputStyle" type="radio"
										 id="isShow_id"	name="isShow_id" value="1" <%if("1".equals(isShowPop)) out.println("checked"); %> onclick="showOrHidenFun(1)">
									</TD>
								</TR>
								<tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
								<TR>
									<TD>
										<%=SystemEnv.getHtmlLabelName(21880,user.getLanguage())%>
									</TD>
									<TD class="field">
										<input class="inputStyle" type="radio"
										id="isShow_id"	name="isShow_id" value="0" onclick="showOrHidenFun(0)">
									</TD>
								</TR>
								<tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
							</TBODY>
						</TABLE>
						<DIV id="showDiv_id" <%if("1".equals(isShowPop)){ %>style="display:block"<%}else{ %>style="display:none"<%}%>>
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>
                                     <TR>
                                        <TD colSpan=2><B><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></B></TD>
									 </TR>	
									 <TR class=Spacing style="height: 1px!important;">
									   <TD class=Line1 colSpan=2></TD>
								     </TR>							
                                     <TR>
                                      <TD><%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%></TD>
                                      <TD class=Line >
                                      <BUTTON class=Calendar type="button" onclick="getPfStartDate()"></BUTTON> 
										 <SPAN id=startDateSpan>
										 <%if("1".equals(isShowPop)){ %><%=startDate%>
										 <%}else{%>
										  <img src='/images/BacoError.gif' align=absmiddle>
										 <%}%>
										 </SPAN>&nbsp;- &nbsp;
										 <BUTTON class=Calendar type="button" onclick="getPfEndDate()"></BUTTON> 
										 <SPAN id=endDateSpan>
										 <%if("1".equals(isShowPop)){ %><%=endDate%>
										 <%}else{%>
										  <img src='/images/BacoError.gif' align=absmiddle>
										 <%}%>
										 </SPAN>
									     <input class=InputStyle  type="hidden" id="startDate" name="startDate" value="<%=startDate%>">
										 <input class=InputStyle  type="hidden" id="endDate" name="endDate" value="<%=endDate%>">
                                      </TD>
									 </TR>
									 <tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
                                     <TR>
                                      <TD><%=SystemEnv.getHtmlLabelName(21881,user.getLanguage())%></TD>
                                      <TD class=Line >                                       
                                        <INPUT class=InputStyle name="pop_num" type="text" value="<%=pop_num%>"  onBlur='checknumber("pop_num");checkinput("pop_num","descimage")' onchange='checkinput("pop_num","descimage")'>
                                        <SPAN id=descimage><%if(!"1".equals(isShowPop)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN>                                      
                                      </TD>
									 </TR>
									 <tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
									 <TR>
                                      <TD><%=SystemEnv.getHtmlLabelName(21882,user.getLanguage())%></TD>
                                      <TD class=Line ><input class=InputStyle  type="text" name="pop_hight" onBlur='checknumber("pop_hight")' value="<%=pop_hight%>"></TD>
									 </TR>
									 <tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
									 <TR>
                                      <TD><%=SystemEnv.getHtmlLabelName(21884,user.getLanguage())%></TD>
                                      <TD class=Line ><input class=InputStyle  type="text" name="pop_width" onBlur='checknumber("pop_width")' value="<%=pop_width%>"></TD>
									 </TR>
									 <tr style="height: 1px!important;"><td class=Line colSpan=2></td></tr>
                                </TBODY>
                              </TABLE>
                         </div>
					</td>
				</tr>
			</TABLE>
		</td>
	</tr>
</table>	
</FORM>
</body>
<script type='text/javascript'>
  var delFlag = 0;
  function showOrHidenFun(obj){
     var showtemp = document.getElementById('isShow_id').value;
     if(showtemp == obj){
       delFlag = 0;
       document.getElementById('showDiv_id').style.display = "";
     }else{  
	   delFlag = 1;
       document.getElementById('showDiv_id').style.display = "none";
     }
  }
  
  function doSave(obj){
     var showflag = <%=isShowPop%>;
     if(showflag == 1 && delFlag == 1){  	
        document.getElementById('startDate').value = "";
	    document.getElementById('endDate').value = "";
	    document.getElementById('pop_num').value = "";
	    document.getElementById('pop_hight').value = "";
	    document.getElementById('pop_width').value = ""; 
	    document.getElementById('startDateSpan').innerHTML = "";
	    document.getElementById('endDateSpan').innerHTML = "";
      	weaver.operate.value="delete";
      	weaver.docsid.value=<%=docsid%>;
        document.weaver.submit();
        obj.disabled=true;
	    obj.hide();
        parent._table.reLoad();
     }else{
	   if(!document.getElementById('isShow_id').checked){
		 obj.disabled=true;
		 obj.hide();
		 return false;
	    }
	    if(check_form(weaver,'startDate,endDate,pop_num')){
	      if(showflag == 1){
	        weaver.operate.value="update";
	      }else{
	        weaver.operate.value="save";
	      }
	      weaver.docsid.value=<%=docsid%>;
	      document.weaver.submit();
	      obj.disabled=true;
		  obj.hide();
	      parent._table.reLoad();
	   }
     }
  }
</script>
<SCRIPT language="javascript"  src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
