<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CostCenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ResourceUtil" class="weaver.hrm.resource.ResourceUtil" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int depid = Util.getIntValue(request.getParameter("id"),1);
rs.executeProc("HrmDepartment_SelectByID",""+depid);
String departmentmark="";
String departmentname = "";
//int supdepid = 0;
String supdepid = "";
String allsupdepid = "";
int subcompanyid=0;
int showorder = 0;
String canceled = "0";
int coadjutant=0;    
String departmentcode = "";
String zzjgbmfzr = "";//组织机构部门负责人
String zzjgbmfgld = "";//组织机构部门分管领导
String jzglbmfzr = "";//矩阵管理部门负责人
String jzglbmfgld = "";//矩阵管理部分分管领导

if(rs.next()){
	departmentmark = Util.toScreen(rs.getString("departmentmark"),user.getLanguage());
	departmentname = Util.toScreen(rs.getString("departmentname"),user.getLanguage());
	//supdepid = rs.getInt("supdepid");
	supdepid = Util.toScreen(rs.getString("supdepid"),user.getLanguage());	
	allsupdepid = Util.toScreen(rs.getString("allsupdepid"),user.getLanguage());	
	subcompanyid = Util.getIntValue(rs.getString("subcompanyid1"),0);	
	showorder = Util.getIntValue(rs.getString("showorder"),0);
	canceled = Util.toScreen(rs.getString("canceled"),user.getLanguage());	
	departmentcode = Util.toScreen(rs.getString("departmentcode"),user.getLanguage());
    coadjutant = Util.getIntValue(rs.getString("coadjutant"),0);
    zzjgbmfzr = Util.null2String(rs.getString("zzjgbmfzr"));//组织机构部门负责人
    zzjgbmfgld = Util.null2String(rs.getString("zzjgbmfgld"));//组织机构部门分管领导
    jzglbmfzr = Util.null2String(rs.getString("jzglbmfzr"));//矩阵管理部门负责人
    jzglbmfgld = Util.null2String(rs.getString("jzglbmfgld"));//矩阵管理部分分管领导
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int deplevel=0;
if(detachable==1){
    deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user))
        deplevel=2;
}
boolean canlinkbudget = HrmUserVarify.checkUserRight("SubBudget:Maint", user);
boolean canlinkexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, depid) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = departmentname+","+departmentmark;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	if(deplevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(179,user.getLanguage())+",/hrm/search/HrmResourceSearchTmp.jsp?department="+depid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	if(deplevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17899,user.getLanguage())+",/hrm/company/HrmDepartmentAdd.jsp?subcompanyid="+subcompanyid+"&supdepid="+supdepid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17900,user.getLanguage())+",/hrm/company/HrmDepartmentAdd.jsp?subcompanyid="+subcompanyid+"&supdepid="+depid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
     if(deplevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
	 }
}
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(122,user.getLanguage())+",/hrm/company/HrmDepartmentRoles.jsp?id="+depid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+",/hrm/jobtitles/HrmJobTitles.jsp?departmentid="+depid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	if(canlinkexpense){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(428,user.getLanguage())+",/fna/report/expense/FnaExpenseDetail.jsp?organizationid="+depid+"&organizationtype=2,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
		
	if( canlinkbudget ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(386,user.getLanguage())+",/fna/budget/FnaBudgetView.jsp?organizationid="+depid+"&organizationtype=2,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
if(HrmUserVarify.checkUserRight("HrmDepartment:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+12+" and relatedid="+depid+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+12+" and relatedid="+depid+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="HrmDepartmentEdit.jsp?id=<%=depid%>" method=post>

  <TABLE class=ViewForm width="100%">
    <TBODY> <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%"> 
    <TR class=Title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      <TD>&nbsp;</TD>
      <TH><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
    </TR>
    <TR vAlign=top> 
      <TD> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="40%"> <COL width="60%"> <TBODY> 
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <%=departmentmark%>
              </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
            <TD class=FIELD><nobr> 
              <%=departmentname%></TD>
          </TR> 
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--                   
          <TR> 
            <TD>成本中心</TD>
            <TD class=FIELD>
            <table>
            <%
            String sql = "select * from HrmCostcenter where departmentid = "+depid;
            rs.executeSql(sql);
            while(rs.next()){
            %>
            <tr><td>
            <a href="HrmCostcenterDsp.jsp?id=<%=rs.getString("id")%>">
            <%=rs.getString("costcentermark")%>-<%=rs.getString("costcentername")%>
            </a>
            </td></tr>
            <%}%>
            
            </table>
            </TD>
          </TR>
-->          
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15772,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=DepartmentComInfo.getDepartmentname(supdepid)%>
            </TD>
          </TR>          
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></TD>
            <TD class=FIELD><nobr>
              <%=ResourceComInfo.getLastname(""+coadjutant)%></TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=showorder%>
            </TD>
          </TR>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(22279,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=depid%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=departmentcode%>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 

          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=ResourceUtil.getHrmShowNameHref(zzjgbmfzr)%>
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=ResourceUtil.getHrmShowNameHref(zzjgbmfgld)%>
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=ResourceUtil.getHrmShowNameHref(jzglbmfzr)%>
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          <TR style="display:none"> 
            <TD><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=ResourceUtil.getHrmShowNameHref(jzglbmfgld)%>
            </TD>
          </TR>
          <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
          
          
          </TBODY> 
        </TABLE>
      </TD>
      <TD>&nbsp;</TD>
      <TD> 
        <table class=ViewForm width="100%">
          <colgroup> <col width="40%"> <col width="60%"> 
          <tr class=Spacing style="height:2px"> 
            <td class=Line1 colspan=2></td>
          </tr>
          
         <%         
         while(CompanyComInfo.next()){         	         	
         	String curid=CompanyComInfo.getCompanyid();         	
         	int curid_int = Util.getIntValue(curid);
         	String curname = "";
//         	if(companyid == curid_int){         	 
         	 curname = CompanyComInfo.getCompanyname();
         	
         	String 	tmpid = DepartmentComInfo.getSubcompanyid1(""+depid);
         	
         	
         %>
         <tr> 
            <td><a href="HrmCompanyEdit.jsp?id=<%=curid%>"><%=curname%></a></td>
            <td class=FIELD> 
            <a href="HrmDepartment.jsp?companyid=<%=curid%>&subcompanyid=<%=subcompanyid%>"><%=SubCompanyComInfo.getSubCompanyname(tmpid)%></a>              
            </td>
          </tr>
             <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
         
         <%
             break;
         }
         
//         }
%>
        </table>
      </TD>
    </TR>
          
  </TABLE>
   <input class=inputstyle type=hidden name=operation value="add">
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function submitData() {
 frmMain.submit();
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=depid%>&userid=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmDepartmentDsp.jsp?id=<%=depid%>";
	            }else{
	              alert("<%=SystemEnv.getHtmlLabelName(22157, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
  }
}

 function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=depid%>&cancelFlag=1&userid=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmDepartmentDsp.jsp?id=<%=depid%>";
				  return;
	            } 
                if(ajax.responseText == 0) {
	              alert("<%=SystemEnv.getHtmlLabelName(24296, user.getLanguage())%>");
	              return;
	            }
	            if(ajax.responseText == 2) {
	              alert("<%=SystemEnv.getHtmlLabelName(24297, user.getLanguage())%>");
	              return;
	            }
            }catch(e){
                return false;
            }
        }
     }
   }
 }
</script>

</BODY></HTML>
