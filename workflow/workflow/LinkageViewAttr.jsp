<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<html>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");

		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int wfid = Util.getIntValue(request.getParameter("wfid"),0);
    int formid = Util.getIntValue(request.getParameter("formid"),0);
    int isbill = Util.getIntValue(request.getParameter("isbill"),0);
    if(!ajax.equals("1")){
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
ArrayList nodeidlist=new ArrayList();
ArrayList nodenamelist=new ArrayList();
String nodeids="";
String nodenames="";
String selectfields="";
String selectfieldnames="";
String selectfieldvalues="";
String selectfieldvaluenames="";
String firstnodeid="0";
String firstselectfieldid="0";
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
    String tnodeid=""+WFNodeMainManager.getNodeid();
    String tnodename=WFNodeMainManager.getNodename();
    String tnodetype=WFNodeMainManager.getNodetype();
    if(tnodetype.equals("3")) continue;
    if(nodeids.equals("")){
        nodeids=tnodeid;
        nodenames=tnodename;
        firstnodeid=tnodeid;
    }else{
        nodeids+=","+tnodeid;
        nodenames+=","+tnodename;
    }
    nodeidlist.add(tnodeid);
    nodenamelist.add(tnodename);
}
WfLinkageInfo wfli=new WfLinkageInfo();
wfli.setFormid(formid);
wfli.setIsbill(isbill);
wfli.setWorkflowid(wfid);
wfli.setLangurageid(user.getLanguage());
ArrayList[] selectfield=wfli.getSelectFieldByEdit(Util.getIntValue(firstnodeid));
ArrayList selectfieldlist=selectfield[0];
ArrayList selectfieldnamelist=selectfield[1];
ArrayList selectfieldisdetaillist=selectfield[2];
for(int i=0;i<selectfieldlist.size();i++){
    if(selectfields.equals("")){
        selectfields=(String)selectfieldlist.get(i)+"_"+selectfieldisdetaillist.get(i);
        selectfieldnames=(String)selectfieldnamelist.get(i);
        firstselectfieldid=(String)selectfieldlist.get(i);
    }else{
        selectfields+=","+selectfieldlist.get(i)+"_"+selectfieldisdetaillist.get(i);
        selectfieldnames+=","+selectfieldnamelist.get(i);
    }
}
ArrayList[] selectvalues=wfli.getSelectFieldItem(Util.getIntValue(firstselectfieldid));
ArrayList selectfieldvaluelist=selectvalues[0];
ArrayList selectfieldvaluenamelist=selectvalues[1];
for(int i=0;i<selectfieldvaluelist.size();i++){
    if(selectfieldvalues.equals("")){
        selectfieldvalues=(String)selectfieldvaluelist.get(i);
        selectfieldvaluenames=(String)selectfieldvaluenamelist.get(i);
    }else{
        selectfieldvalues+=","+selectfieldvaluelist.get(i);
        selectfieldvaluenames+=","+selectfieldvaluenamelist.get(i);
    }
}
%>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(21683,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(21684,user.getLanguage());
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:linkageviewattrsubmit(this),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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
<form name="frmlinkageviewattr" method="post" action="linkageviewattr_operation.jsp" >
    <input type=hidden name="ajax" value="<%=ajax%>">
    <input type=hidden name="wfid" value="<%=wfid%>">
    <input type=hidden name="formid" value="<%=formid%>">
    <input type=hidden name="isbill" value="<%=isbill%>">
       <TABLE class=ListStyle cellspacing=1 id="lavaoTable"  width="100%">
  <COLGROUP>
  <COL width="5%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="15%">
  <COL width="20%">
  <TBODY>
  <TR>
    <TD colSpan=2><b><%=SystemEnv.getHtmlLabelName(21694,user.getLanguage())%></b></TD>
    <TD colSpan=4 align="right">
    <a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='linkagevaaddrow("<%=nodeids%>","<%=nodenames%>","<%=selectfields%>","<%=selectfieldnames%>","<%=selectfieldvalues%>","<%=selectfieldvaluenames%>")'><img src="/js/swfupload/add.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage())%></a>
	&nbsp;
	<a style="color:#262626;cursor:pointer;TEXT-DECORATION:none"  onclick="linkagevadelrow()"><img src="/js/swfupload/delete.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%></a>
    </TD></TR>
  <TR class="Spacing"><TD class="Line1" colSpan=6 style="padding: 0"></TD></TR>
  <TR class=Header >
  <TH width="5%"><input type='checkbox' class=inputstyle name='checkall' onclick="linkagevaselectall()"></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(21686,user.getLanguage())%></TH>
  <TH width="20%"><%=SystemEnv.getHtmlLabelName(21687,user.getLanguage())%></TH>
  <TH width="25%"><%=SystemEnv.getHtmlLabelName(21688,user.getLanguage())%></TH>
  <TH width="10%"><%=SystemEnv.getHtmlLabelName(21689,user.getLanguage())%></TH>
  </TR>
  <%
  String checkfield="";
  String sql="";
  int i=0;
  sql="select * from workflow_viewattrlinkage where workflowid="+wfid+" order by nodeid,selectfieldid,selectfieldvalue";

  rs.executeSql(sql);
  while(rs.next()){
      String nodeid=Util.null2String(rs.getString("nodeid"));
      String selectfieldid=Util.null2String(rs.getString("selectfieldid"));
      String selectfieldvalue=Util.null2String(rs.getString("selectfieldvalue"));
      String changefieldids=Util.null2String(rs.getString("changefieldids"));
      String viewattr=Util.null2String(rs.getString("viewattr"));
      checkfield+="nodeid_"+i+",selectfieldid_"+i+",selectfieldvalue_"+i+",changefieldids_"+i+",";
      ArrayList changefieldidlist=Util.TokenizerString(changefieldids,",");
      ArrayList[] tempselectfield=wfli.getSelectFieldByEdit(Util.getIntValue(nodeid));
      ArrayList tselectfieldidlist=tempselectfield[0];
      ArrayList tselectfieldnamelist=tempselectfield[1];
      ArrayList tselectfieldisdetaillist=tempselectfield[2];
      ArrayList[] tempselectfieldvalue=wfli.getSelectFieldItem(Util.getIntValue(selectfieldid.substring(0,selectfieldid.indexOf("_"))));
      ArrayList tselectfieldvaluelist=tempselectfieldvalue[0];
      ArrayList tselectfieldvaluenamelist=tempselectfieldvalue[1];
      int index=selectfieldid.indexOf("_");
      String viewtype="";
      int tselectfieldid=0;
      if(index!=-1){
          tselectfieldid=Util.getIntValue(selectfieldid.substring(0,index));
          viewtype=selectfieldid.substring(index+1);
      }
      wfli.setViewtype(viewtype);
      wfli.setFieldid(tselectfieldid);
      ArrayList[] tempfield=wfli.getFieldsByEdit(Util.getIntValue(nodeid));
      ArrayList tfieldidlist=tempfield[0];
      ArrayList tfieldnamelist=tempfield[1];
      int notnodeid=nodeidlist.indexOf(nodeid);
      int notselectfield=tselectfieldidlist.indexOf(selectfieldid.substring(0,selectfieldid.indexOf("_")));
      int notselectfieldvalue=tselectfieldvaluelist.indexOf(selectfieldvalue);
      String fieldnames="";
      for(int j=0;j<changefieldidlist.size();j++){
          String tfieldid=(String)changefieldidlist.get(j);
          tfieldid=tfieldid.substring(0,tfieldid.indexOf("_"));
          int _index=tfieldidlist.indexOf(tfieldid);
          if(_index<0||selectfieldid.equals(changefieldidlist.get(j))){
              fieldnames+="<br><font style=\"background-color:red\">"+wfli.getFieldnames(Util.getIntValue(tfieldid))+"</font>";
          }else{
              fieldnames+="<br>"+tfieldnamelist.get(_index);
          }
      }
  %>
  <TR <%if(i%2==0){%>CLASS="DataDark"<%}else{%>class="DataLight" <%}%>>
      <TD><input type='checkbox' class=inputstyle name='check_node' value='<%=i%>'></TD>
      <TD><select class=inputstyle name='nodeid_<%=i%>' onchange="lavachangenode(this.value,<%=i%>)">
      <%if(notnodeid==-1){%>
          <option value="" style="background-color:red"><%=SystemEnv.getHtmlLabelName(21696,user.getLanguage())%></option>
      <%}%>
      <%for(int j=0;j<nodeidlist.size();j++){%>
          <option value="<%=nodeidlist.get(j)%>" <%if(nodeid.equals(nodeidlist.get(j))){%>selected<%}%>><%=nodenamelist.get(j)%></option>
      <%}%>
      </select>
      <span id="nodeid_<%=i%>span"><%if(nodeidlist.size()<1){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
      </TD>
      <TD><select class=inputstyle name='selectfieldid_<%=i%>' onchange="lavachangefield(this.value,<%=i%>)">
      <%if(notselectfield==-1){%>
          <option value="" style="background-color:red"><%=SystemEnv.getHtmlLabelName(21697,user.getLanguage())%></option>
      <%}%>
      <%for(int j=0;j<tselectfieldidlist.size();j++){%>
          <option value="<%=tselectfieldidlist.get(j)+"_"+tselectfieldisdetaillist.get(j)%>" <%if(tselectfieldidlist.get(j).equals(selectfieldid.substring(0,selectfieldid.indexOf("_")))){%>selected<%}%>><%=tselectfieldnamelist.get(j)%></option>
      <%}%>
      </select>
      <span id="selectfieldid_<%=i%>span"><%if(tselectfieldidlist.size()<1){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
      </TD>
      <TD><select class=inputstyle name='selectfieldvalue_<%=i%>'>
      <%if(notselectfieldvalue==-1){%>
          <option value="" style="background-color:red"><%=SystemEnv.getHtmlLabelName(21698,user.getLanguage())%></option>
      <%}%>
      <%for(int j=0;j<tselectfieldvaluelist.size();j++){%>
          <option value="<%=tselectfieldvaluelist.get(j)%>" <%if(selectfieldvalue.equals(tselectfieldvaluelist.get(j))){%>selected<%}%>><%=tselectfieldvaluenamelist.get(j)%></option>
      <%}%>
      </select>
      <span id="selectfieldvalue_<%=i%>span"><%if(tselectfieldvaluelist.size()<1){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
      </TD>
      <TD>
          <button type='button' class=Browser onclick="lavaShowMultiField('changefieldidsspan_<%=i%>','changefieldids_<%=i%>',nodeid_<%=i%>.value,selectfieldid_<%=i%>.value)"></button><SPAN id="changefieldidsspan_<%=i%>"><%if(changefieldids.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}else{%><%=fieldnames%><%}%></SPAN>
          <input type='hidden' class=inputstyle name='changefieldids_<%=i%>' value="<%=changefieldids%>">
      </TD>
      <TD><select class=inputstyle name='viewattr_<%=i%>' onchange="">
      <option value="2" <%if(viewattr.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option>
      <option value="1" <%if(viewattr.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
      </select>
      </TD>
  </TR>
  <%i++;}%>
 </TBODY></TABLE>
 <input type='hidden' id="linkage_rownum" name="linkage_rownum" value="<%=i%>">
<input type='hidden' id="linkage_indexnum" name="linkage_indexnum" value="<%=i%>">
<input type='hidden' id="checkfield" name="checkfield" value="<%=checkfield%>">
</form>



    </td>
		</tr>
        <tr>
        <td valign="bottom">
<table class=ReportStyle valign="bottom">
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(21708,user.getLanguage())%></B>:<BR><%=SystemEnv.getHtmlLabelName(21709,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>:</B><%=SystemEnv.getHtmlLabelName(21711,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21686,user.getLanguage())%>:</B><%=SystemEnv.getHtmlLabelName(21712,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21687,user.getLanguage())%>:</B><%=SystemEnv.getHtmlLabelName(21713,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21688,user.getLanguage())%>:</B><%=SystemEnv.getHtmlLabelName(21714,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21689,user.getLanguage())%>:</B><%=SystemEnv.getHtmlLabelName(21715,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>:</B><font style="background-color:red"><%=SystemEnv.getHtmlLabelName(21716,user.getLanguage())%></font>
<BR>
</TD>
</TR>
</TBODY>
</table>
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


<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function linkageviewattrsubmit(obj)
{
	if (check_form(frmlinkageviewattr,frmlinkageviewattr.checkfield.value)){
		frmlinkageviewattr.submit();
        obj.disabled=true;
    }
}
function linkagevaselectall(){
    len = document.frmlinkageviewattr.elements.length;
    var i=0;
    for(i=len-1; i >= 0;i--) {
       if (document.frmlinkageviewattr.elements[i].name=='check_node'){
           document.frmlinkageviewattr.elements[i].checked=document.frmlinkageviewattr.checkall.checked;
       }
    }
}
function linkagevaaddrow(nodeids,nodenames,selectfieldids,selectfieldnames,selectvalues,selectvaluenames){
    var nodeidarray=nodeids.split(",");
    var nodenamearray=nodenames.split(",");
    var selectfieldidarray=selectfieldids.split(",");
    var selectfieldnamearray=selectfieldnames.split(",");
    var selectvaluearray=selectvalues.split(",");
    var selectvaluenamearray=selectvaluenames.split(",");
    var oTable=document.all('lavaoTable');
    var curindex=parseInt(document.all('linkage_rownum').value);
    var rowindex=parseInt(document.all('linkage_indexnum').value);
    var ncol = 6;
    var oRow = oTable.insertRow(-1);
    for(j=0; j<ncol; j++) {
        var oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		oCell.style.background= "#E7E7E7";
		switch(j) {
            case 0:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox' class=inputstyle name='check_node' value='"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 1:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='nodeid_"+rowindex+"' onchange='lavachangenode(this.value,"+rowindex+")'>"
                for(i=0;i<nodeidarray.length;i++){
                    sHtml+="<option value='"+nodeidarray[i]+"'>"+nodenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='nodeid_"+rowindex+"span'>";
                if(nodeids==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 2:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldid_"+rowindex+"' onchange='lavachangefield(this.value,"+rowindex+")'>";
                for(i=0;i<selectfieldidarray.length;i++){
                    sHtml+="<option value='"+selectfieldidarray[i]+"'>"+selectfieldnamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldid_"+rowindex+"span'>";
                if(selectfieldids==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml
                oCell.appendChild(oDiv);
                break;
            }
            case 3:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='selectfieldvalue_"+rowindex+"'>";
                for(i=0;i<selectvaluearray.length;i++){
                    sHtml+="<option value='"+selectvaluearray[i]+"'>"+selectvaluenamearray[i]+"</option>";
                }
                sHtml+="</select><span id='selectfieldvalue_"+rowindex+"span'>";
                if(selectvalues==""){
                    sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
                }
                sHtml+="</span>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 4:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<button type='button' class=Browser onclick='lavaShowMultiField(\"changefieldidsspan_"+rowindex+"\",\"changefieldids_"+
                            rowindex+"\",nodeid_"+rowindex+".value,selectfieldid_"+rowindex+".value)'></button><SPAN id='changefieldidsspan_"+rowindex+
                            "'><IMG src='/images/BacoError.gif' align=absMiddle></SPAN><input type='hidden' class=inputstyle name='changefieldids_"+rowindex+"'>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
            case 5:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<select class=inputstyle name='viewattr_"+rowindex+"'>";
                sHtml+="<option value=2><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%></option> ";
                sHtml+="<option value=1><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>";
                sHtml+="</select>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }
        }
    }
    document.all('checkfield').value = document.all('checkfield').value+"nodeid_"+rowindex+",selectfieldid_"+rowindex+",selectfieldvalue_"+rowindex+",changefieldids_"+rowindex+",";
    document.all("linkage_rownum").value = curindex+1 ;
    document.all('linkage_indexnum').value = rowindex+1;
}
function linkagevadelrow(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
        var oTable=document.all('lavaoTable');
        curindex=parseInt(document.all("linkage_rownum").value);
        len = document.frmlinkageviewattr.elements.length;
        var i=0;
        var rowsum1 = 0;
        for(i=len-1; i >= 0;i--) {
            if (document.frmlinkageviewattr.elements[i].name=='check_node')
                rowsum1 += 1;
        }
        for(i=len-1; i >= 0;i--) {
            if (document.frmlinkageviewattr.elements[i].name=='check_node'){
                if(document.frmlinkageviewattr.elements[i].checked==true) {
                    document.all('checkfield').value = (document.all('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
                    document.all('checkfield').value = (document.all('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
                    document.all('checkfield').value = (document.all('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
                    document.all('checkfield').value = (document.all('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
                    oTable.deleteRow(rowsum1+2);
                    curindex--;
                }
                rowsum1 -=1;
            }
        }
        document.all("linkage_rownum").value=curindex;
    }
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
function lavachangenode(nodeid,rownum){
    fieldsel=document.all("selectfieldid_"+rownum);
    fieldselspan=document.all("selectfieldid_"+rownum+"span");
    changefieldids=document.all("changefieldids_"+rownum);
    changefieldidspan=document.all("changefieldidsspan_"+rownum);
    clearOptionsCodeSeqSet(fieldsel);
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&languageid=<%=user.getLanguage()%>&option=selfield&nodeid="+nodeid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues==""){
                fieldselspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
                fieldsel.options.add(new Option("",""));
                lavachangefield("",rownum);
            }else{
                fieldselspan.innerHTML="";

                var selefields=returnvalues.split(",");
                for(var i=0; i<selefields.length; i++){
                    var itemids=selefields[i].split("$");
                    fieldsel.options.add(new Option(itemids[1],itemids[0]));
                    if(i==0) {
                        lavachangefield(itemids[0],rownum);
                        oldfieldsel.value=itemids[0];
                    }
                }
            }
            changefieldids.value="";
            changefieldidspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
            }catch(e){}
        }
    }
}
function lavachangefield(fieldid,rownum){
    fieldvaluesel=document.all("selectfieldvalue_"+rownum);
    fieldvalueselspan=document.all("selectfieldvalue_"+rownum+"span");
    changefieldids=document.all("changefieldids_"+rownum);
    changefieldidspan=document.all("changefieldidsspan_"+rownum);
    oldfieldsel=document.all("oldselectfieldid_"+rownum);
    clearOptionsCodeSeqSet(fieldvaluesel);
    var ajax=ajaxinit();
    ajax.open("POST", "WorkflowSelectAjax.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("workflowid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&languageid=<%=user.getLanguage()%>&option=selfieldvalue&fieldid="+fieldid);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            var returnvalues=ajax.responseText;
            if(returnvalues==""){
                fieldvalueselspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
                fieldvaluesel.options.add(new Option("",""));
            }else{
                fieldvalueselspan.innerHTML="";
                var selefieldvalues=returnvalues.split(",");

                for(var i=0; i<selefieldvalues.length; i++){
                    var itemids=selefieldvalues[i].split("$");
                    fieldvaluesel.options.add(new Option(itemids[1],itemids[0]));
                }
            }
            changefieldids.value="";
            changefieldidspan.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
            }catch(e){}
        }
    }
}
function encode(str){
    return escape(str);
}
</script>
<script language="VBScript">
sub lavaShowMultiField(spanname,hiddenidname,nodeid,fieldid)
    url=encode("/workflow/field/MultiWorkflowFieldBrowser.jsp?wfid=<%=wfid%>&nodeid="+nodeid+"&selfieldid="+fieldid+"&fieldids="+hiddenidname.value)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	issame = false
	if (Not IsEmpty(id)) then
        If id(0) <> "" and id(0) <> "0" Then
            spanname.innerHtml = id(1)
            hiddenidname.value=id(0)
	    else
            spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
            hiddenidname.value=""
        end if
    end if
end sub
</script>
<%}%>
</body>
</html>