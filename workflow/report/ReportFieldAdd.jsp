<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));

String isBill = Util.null2String(request.getParameter("isBill"));

String formID = Util.null2String(request.getParameter("formID"));

int dbordercount = Integer.parseInt(Util.null2String(request.getParameter("dbordercount")));

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/workflow/report/ReportEdit.jsp?id="+id+",_top} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportEdit.jsp?id="+id+",_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post>


<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>
<%
// }
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

  <TABLE class="viewform">
  
    <COLGROUP> <COL width="28%"> <COL width="14%"> <COL width="14%"> <COL width="30%"> <COL width="14%"><TBODY> 
    <TR class="Title"> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15510,user.getLanguage())%></TH>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line1" colSpan=5 ></TD>
    </TR>
    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15511,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(18558,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(17736,user.getLanguage())%> / <%=SystemEnv.getHtmlLabelName(18559,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
    </tr>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=5 ></TD>
    </TR>
    
<%-----------    xwj for td2974 20051026     B E G I N   -----------%>
  <%
    int tmpcount = 0;
    tmpcount += 1;
    boolean isshow=false;
    int isstat=-1;
    int dborder=-1;
    String dbordertype = "";
    int compositororder = 0;
    String dsporder="";
    rs.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid=-1");
    if(rs.next()){
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      dsporder=rs.getString("dsporder");
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR>
      <TD>
      <%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>(requestname)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-1">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>>
      </TD>
      <%String strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
      </td>
      <td class=Field>
           <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
      </td>
      <td class=Field>
      <%
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount1%>)">
           <%}%>
    
           <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
			             </select>
			       
			     <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
    
    <%
     tmpcount += 1;
     isshow=false;
     isstat=-1;
     dborder=-1;
     dbordertype = "";
     compositororder = 0;
     dsporder="";
    rs.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid=-2");
    if(rs.next()){
      isshow=true;
      isstat=rs.getInt("isstat");
      dborder=rs.getInt("dborder");
      dsporder=rs.getString("dsporder");
      if(!"".equals(rs.getString("dbordertype"))){
       dbordertype=rs.getString("dbordertype");
      }
      if(rs.getInt("compositororder") != -1){
       compositororder = rs.getInt("compositororder");
      }
    
    }
  %>
  <TR> 
      <TD>
      <%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>(requestlevel)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="-2">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>>
      </TD>
      <%strtmpcount1 =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount1%>)">
      </td>
      <td class=Field>
         <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
      </td>
      <td class=Field>
      <%
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount1%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount1%>)">
           <%}%>
    
           <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
			             </select>
			       
			     <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount1%>)">
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkDsporder(<%=strtmpcount1%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
<%----------    xwj for td2974 20051026     E N D   -----------%>

<%
int linecolor=0;
String sql="";
if(isBill.equals("0")){
  /*
  1、workflow_formdict,workflow_formdictdetail 两张表的分开，是极糟糕的设计！使得必须使用union操作；
  2、由于workflow_formfield.fieldorder 字段针对头和明细分别记录顺序，使得在union之后对fieldorder使用order by 失去意义；
  3、针对问题2，对 workflow_formfield.fieldorder 作 +100 的操作，以便union后排序，100能够满足绝对多数单据对头字段的要求；
  4、检索字段实际存储类型，屏蔽不能排序字段的排序操作；
  5、添加(明细)标记时要区分sql与oracle的操作差异
  */
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("select bf.*  from                                                                             \n");
	sqlSB.append(" (select workflow_formfield.fieldid      as id,                                               \n");
	sqlSB.append("         fieldname                       as name,                                             \n");
	sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                            \n");
	sqlSB.append("         workflow_formfield.fieldorder as fieldorder,                                         \n");
	sqlSB.append("         workflow_formdict.fielddbtype   as dbtype,                                           \n");
	sqlSB.append("         workflow_formdict.fieldhtmltype as httype,                                           \n");
	sqlSB.append("         workflow_formdict.type as type                                                       \n");
	sqlSB.append("    from workflow_formfield, workflow_formdict, workflow_fieldlable                           \n");
	sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
	sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
	sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
	sqlSB.append("     and workflow_formdict.id = workflow_formfield.fieldid                                    \n");
	sqlSB.append("     and workflow_formfield.formid = " + formID + "                                           \n");
	sqlSB.append("     and (workflow_formfield.isdetail <> '1' or workflow_formfield.isdetail is null)          \n");
	sqlSB.append("  union                                                                                       \n");
	sqlSB.append("  select workflow_formfield.fieldid as id,                                                    \n");
	sqlSB.append("         fieldname as name,                                                                   \n");
	if(rs.getDBType().equals("oracle")){
		sqlSB.append("         concat(workflow_fieldlable.fieldlable,' (明细)') as label,                       \n");
	}else if(rs.getDBType().equals("db2")){
		sqlSB.append("         concat(workflow_fieldlable.fieldlable,' (明细)') as label,                       \n");
	}else{
		sqlSB.append("         workflow_fieldlable.fieldlable + ' (明细)' as label,                             \n");
	}
	sqlSB.append("         workflow_formfield.fieldorder + 100 as fieldorder,                                   \n");
	sqlSB.append("         workflow_formdictdetail.fielddbtype as dbtype,                                       \n");
	sqlSB.append("         workflow_formdictdetail.fieldhtmltype as httype,                                     \n");
	sqlSB.append("         workflow_formdictdetail.type as type                                                 \n");
	sqlSB.append("    from workflow_formfield, workflow_formdictdetail, workflow_fieldlable                     \n");
	sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
	sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
	sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
	sqlSB.append("     and workflow_formdictdetail.id = workflow_formfield.fieldid                              \n");
	sqlSB.append("     and workflow_formfield.formid =" + formID + "                                            \n");
	sqlSB.append("     and (workflow_formfield.isdetail = '1' or workflow_formfield.isdetail is not null)) bf   \n");
	sqlSB.append(" left join (Select * from Workflow_ReportDspField where reportid = " + id + " ) rf            \n");
	sqlSB.append("   on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)                                           \n");
	sqlSB.append("   order by rf.dsporder                                                                       \n");
	sql = sqlSB.toString();
}else if(isBill.equals("1")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("  select bf.* from (                              \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.fieldhtmltype as httype,          \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
	sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("      from workflow_billfield wfbf                \n");
	sqlSB.append("     where wfbf.billid = " + formID + " AND wfbf.viewtype = 0                       \n");
	sqlSB.append("    Union                                         \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.fieldhtmltype as httype,          \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
	sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("		  from workflow_billfield wfbf              \n");
	sqlSB.append("		 where wfbf.billid = " + formID + " AND wfbf.viewtype = 1                     \n");
	sqlSB.append("  ) bf left join (Select * from Workflow_ReportDspField                             \n");
	sqlSB.append("  where reportid = " + id + ") rf on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)  \n");
	sqlSB.append("  order by rf.dsporder, bf.dsporder, bf.detailtable                                 \n");
	sql = sqlSB.toString();
}
rs.executeSql(sql);
while(rs.next()){
if(rs.getString("type").equals("226")||rs.getString("type").equals("227")||rs.getString("type").equals("224")||rs.getString("type").equals("225")){
	//屏蔽集成浏览按钮-zzl
	continue;
}
tmpcount += 1;
String fieldid = rs.getString("id"); 
String label = rs.getString("label");
String dbtype= rs.getString("dbtype");
if(isBill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
	int viewType = rs.getInt("viewType");
	if(viewType == 1){
		label += " (明细)";
	}
}
/*-----  xwj for td2974 20051026   B E G I N  ----*/
isshow=false;
isstat=-1;
dborder=-1;
dbordertype = ""; //added by xwj for td2099 on 2005-06-06
compositororder = 0; //added by xwj for td2099 on 2005-06-06
dsporder="";
/*-----  xwj for td2974 20051026   E N D  ----*/
rs1.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldid="+fieldid);
if(rs1.next()){
  isshow=true;
  isstat=rs1.getInt("isstat");
  dborder=rs1.getInt("dborder");
  dsporder=rs1.getString("dsporder");//modified by xwj for td2974 20051026
  //added by xwj for td2099 on 2005-06-06
  if(!"".equals(rs1.getString("dbordertype"))){
  dbordertype=rs1.getString("dbordertype");
  }
  if(rs1.getInt("compositororder") != -1){
      compositororder = rs1.getInt("compositororder");
  }
}

rs1.executeSql("select * from Workflow_ReportDspField where reportid="+id+" and fieldidbak = "+ fieldid);
if(rs1.next()){
	  dsporder=rs1.getString("dsporder");
}


%>

    <TR> 
      <TD>
      
      <%-----  Modefied  by xwj on 2005-06-06 for td2099   begin  ----%>
      
      <%=label%>
      (<%=rs.getString("name")%>)<!--added by xwj on 20051026 for td2974-->
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=label%>> <!--added by xwj for td2099 on 20050606-->
      </TD>
      <%String strtmpcount =(new Integer(tmpcount)).toString();%>
      <td class=Field>
        <input type="checkbox" name='<%="isshow_"+tmpcount%>' value="1" <%if(isshow){%> checked <%}%> onclick="onCheckShow(<%=strtmpcount%>)">
      </td>
      <td class=Field>
      
       <!-- Modified  by xwj on 20051026 for td2974 begin -->
       <%
       if("1".equals(rs.getString("httype")) && ( "2".equals(rs.getString("type"))||"3".equals(rs.getString("type"))||"4".equals(rs.getString("type")) )){
        if(isshow){%>
          <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" <%if(isstat==1){%> checked <%}%> >
          <%}else{%>
           <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" disabled="true">
          <%}
      }
      else{%>
        <input type="checkbox" name='<%="isstat_"+tmpcount%>' value="1" style="visibility:hidden">
      <%}%>
      <!-- Modified  by xwj on 20051026 for td2974 end -->
      
      </td>
      <td class=Field>
      
        
        
        <%--
           1. 在报表中不显示或者不属于可排序类型的字段不参与该报表的字段排序设置
           2. 增加多字段排序方式
           3. 增加排序类型 "desc" or "asc"
           4. 增加排序关键字顺序
        --%>
        
      
       
        <%
        if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){
           if(isshow){
             %>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" onclick="onCheck(<%=strtmpcount%>)"  <%if(dborder==1){%> checked <%}%>>
           <%}
           else{%>
               <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" disabled="true" onclick="onCheck(<%=strtmpcount%>)">
           <%}
        }
        else{%>
              <input type="checkbox" name='<%="dborder_"+tmpcount%>' value="1" style="visibility:hidden">
          
           <%}%>
         
        <%
          if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){%>
            
                   <select name='<%="dbordertype_"+tmpcount%>' <%if((dborder != 1 && isshow == true) || isshow == false){%>disabled="true"<%}%>>
                    <option value="n" <%if(!"a".equals(dbordertype) && !"d".equals(dbordertype)){%>selected<%}%>>--</option>
						        <option value="a" <%if("a".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(339,user.getLanguage())%> </option>
				            <option value="d" <%if("d".equals(dbordertype)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(340,user.getLanguage())%> </option>
			             </select>
			        
			    <%}
			    else{%>
			     <select name='<%="dbordertype_"+tmpcount%>'  style="visibility:hidden">
                 <option value="n">--</option>
			     </select>
			    <%}%>
			    
			     <%
            if(!(dbtype.equals("text") || dbtype.equals("ntext") || dbtype.equals("image"))){%>
          
              <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" <%if((dborder!=1 && isshow == true) || isshow == false){%>value="" disabled="true"<%}else{%>value=<%=compositororder%><%}%> onblur="checkCompositororder(<%=strtmpcount%>)">
            <%}
            else{%>
              <input type="text" onKeyPress="Count_KeyPress('compositororder_',<%=strtmpcount%>)" class=Inputstyle name='<%="compositororder_"+tmpcount%>' size="6" value="" style="visibility:hidden" onblur="checkCompositororder(<%=strtmpcount%>)">
             
            <%}%>
       
      </td>
      
      <TD class=Field>
         <%if(isshow){%>
         <%--Modefied  by xwj on 20051026 for td2974--%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  onblur="checkDsporder(<%=strtmpcount%>)">
         <%}
         else{%>
         <%--Modefied  by xwj on 20051026 for td2974--%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%> disabled = "true" onblur="checkDsporder(<%=strtmpcount%>)">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
     <%-----  Modefied  by xwj on 2005-06-06 for td2099   end   ----%>
     
<% } %>

  <input type="hidden" name=operation value=formfieldadd>
	<input type="hidden" name=reportid value=<%=id%>>
  <input type="hidden" name=tmpcount value=<%=tmpcount%>>
    </TBODY> 
  </TABLE>
  
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>   
</tr>
</table>

 </form>

<script language="javascript">
var isenabled;
if(<%=dbordercount%>>0)
  isenabled=false;
else
  isenabled=true;

<!-- Modified  by xwj on 2005-06-06 for td2099 begin -->
function submitData()
{    
 if (check_form(frmMain,'fieldidimage')){
	len = document.forms[0].elements.length;
  var i=0;
  var index;
  var selectName;
  var checkName;
  var lableName; 
  var compositororderName;
  submit = true;   

  var rowsum1 = 0;
  for(i=len-1; i >= 0;i--) {
    
    if (document.forms[0].elements[i].name.substring(0,8)=='dborder_'){
    index = document.forms[0].elements[i].name.substring(8,document.forms[0].elements[i].name.length);
    checkName = "dborder_" + index;
    selectName = "dbordertype_" + index;
    lableName = "lable_" + index;
    compositororderName = "compositororder_" + index;
    if(document.all(checkName).checked == true){
        if(document.all(selectName).value=="n"){
        	alert ("[" + document.all(lableName).value + "] <%=SystemEnv.getHtmlLabelName(23276,user.getLanguage())%>!");
          submit = false;
          break;
        }
    }
   }
  }
  if(submit){
   if(checkSame()){<!-- Modified  by xwj on 20051031 for td2974  -->
   //提交表单之前，将所有禁用的输入框状态改为可用，否则其值不能保存到数据库中。
    var num = <%=tmpcount%>;
    for(var i=1; i<=num; i++){
        document.all("dsporder_" + i).disabled = false;
    }
   	frmMain.submit();
   }
  }
}
}


<!-- Modified  by xwj on 20051031 for td2974 begin -->
function checkSame(){
var num = <%=tmpcount%>;
var showcount = 0;
var ordervalue = "";
var tempcount = -1;
var checkcount = 0;
for(i=1;i<=num;i++){
if(document.all("isshow_"+i).checked == true){
showcount = showcount+1;
}
}
var arr = new Array(showcount);
for(i=1;i<=num;i++){
	if(document.all("isshow_"+i).checked == true){
		tempcount = tempcount + 1;
		arr[tempcount] = document.all("dsporder_"+i).value;
		if(arr[tempcount] == ""){
			alert("<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>");
			return false;
		}
	}
}


for(i=1;i<=num;i++){
checkcount = 0;
if(document.all("isshow_"+i).checked == true){
ordervalue = document.all("dsporder_"+i).value;
 for(a=0;a<arr.length;a++){
   if(parseFloat(ordervalue) == parseFloat(arr[a])){
   checkcount = checkcount + 1;
   }
 }
 if(checkcount>1){
 	alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage()) %>!");
  return false;
 }
}
}
return true;
}
<!-- Modified  by xwj on 20051031 for td2974 end -->


function selectType(index){
 if(document.all("dbordertype_" + index).value == "a" || document.all("dbordertype_" + index).value == "d"){
      document.all("dborder_" + index).checked = true;
 }
 else{
      document.all("dborder_" + index).checked = false;
 }
}

 
 
function onCheck(index)
{
  <%--
  len = document.forms[0].elements.length;
  var i=0;
  var rowsum1 = 0;
  for(i=len-1; i >= 0;i--) {
    if (document.forms[0].elements[i].name.substring(0,8)=='dborder_' && document.forms[0].elements[i].name.substring(8,document.forms[0].elements[i].name.length) != row){
      document.forms[0].elements[i].disabled =isenabled;
    }
  }
  if(isenabled==true)
    isenabled=false;
  else
    isenabled=true;
    --%>
   if(document.all("dborder_" + index).checked == true){
      document.all("dbordertype_" + index).disabled = false;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = false;
      document.all("compositororder_" + index).value = "0";
      
      
 }
 else{
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      document.all("compositororder_" + index).value = "";
 }
}

function onCheckShow(index)
{
   if(document.all("isshow_" + index).checked){
      document.all("isstat_" + index).disabled = false;
      document.all("dborder_" + index).disabled = false;
      document.all("dsporder_" + index).disabled = false;
      //document.all("dsporder_" + index).value = "0";
   } else{
      document.all("dborder_" + index).disabled = true;
      document.all("dborder_" + index).checked = false;
      document.all("dbordertype_" + index).disabled = true;
      document.all("dbordertype_" + index).selectedIndex = 0;
      document.all("compositororder_" + index).disabled = true;
      //document.all("compositororder_" + index).value = "";
      document.all("isstat_" + index).disabled = true;
      document.all("isstat_" + index).checked = false;
      document.all("dsporder_" + index).disabled = true;
      //document.all("dsporder_" + index).value = "";
   }
}

function checkDsporder(index){ //Modified  by xwj on 20051026 for td2974
     var dsporderValue;
     if(document.all("dsporder_" + index).value == ""){
        document.all("dsporder_" + index).value = "0.00";
     }
     else{
     checkdecimal_length(index,2);
     }
}

function checkCompositororder(index){
     if(document.all("compositororder_" + index).value == ""){
       document.all("compositororder_" + index).value = "0";
     }
     
}


function Count_KeyPress(name,index)
{
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57)) 
  {
     window.event.keyCode=0;
  }
}

<!-- Modified  by xwj on 2005-06-06 for td2099 end -->
 
 
function bak(){
  document.forms[0].elements[i].enabled==false;
  alert(document.forms[0].elements[i].name.substringData(0,8));
}


<!-- Modified  by xwj on 20051026 for td2974 begin -->

function checkdecimal_length(index,maxlength)
{
	var  elementname = "dsporder_" + index;
	if(!isNaN(parseInt(document.all(elementname).value)) && (maxlength > 0)){
		inputTemp = document.all(elementname).value ;
		if (inputTemp.indexOf(".") !=-1)
		{
			inputTemp = inputTemp.substring(inputTemp.indexOf(".")+1,inputTemp.length);
		}
		if (inputTemp.length > maxlength)
		{
			var tempvalue = document.all(elementname).value;
			tempvalue = tempvalue.substring(0,tempvalue.length-inputTemp.length+maxlength);
			document.all(elementname).value = tempvalue;
		}
	}
}

function Count_KeyPress1(name,index)
{
 var elementname = name + index;
 tmpvalue = document.all(elementname).value;
 var count = 0;
 var len = -1;
 if(elementname){
 len = tmpvalue.length;
 }
 for(i = 0; i < len; i++){
    if(tmpvalue.charAt(i) == "."){
    count++;     
    }
 }
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==46 || window.event.keyCode==45) || (window.event.keyCode==46 && count == 1))
  {  
     
     window.event.keyCode=0;
     
  }
}
<!-- Modified  by xwj on 20051026 for td2974 end -->
</script>
</BODY></HTML>