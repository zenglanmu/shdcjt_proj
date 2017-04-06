<%@ page import="weaver.docs.docs.DocComInfo" %>
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp" %>

<%
String noticeImg = (String)valueList.get(nameList.indexOf("noticeimg"));
String noticeTitle = (String)valueList.get(nameList.indexOf("noticetitle"));
String noticeContent = (String) valueList.get(nameList.indexOf("noticecontent"));
String direction = (String) valueList.get(nameList.indexOf("direction"));
String scrollDelay = (String) valueList.get(nameList.indexOf("scrollDelay"));

String selectLeft="";
String selectRight="";
if(direction.equals("left")){
	selectLeft = "selected";
}else if(direction.equals("right")){
	selectRight = "selected";
}
DocComInfo dci=new DocComInfo();	 			
String strSrcContentName=dci.getMuliDocName2(noticeContent);
%>



		<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%>
			</TD>
			<TD class="field">
				<INPUT style="width:98%" TYPE="text" class=filetree title=<%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%> value="<%=noticeImg %>" name="_noticeimg_<%=eid%>" >
				
			</TD>
		</TR>
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
			<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
			</TD>
			<TD class="field">
				<INPUT style="width:98%" TYPE="text" class=inputstyle title=<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%> value="<%=noticeTitle %>" name="_noticetitle_<%=eid%>" id="_noticetitle_<%=eid%>">
				
			</TD>
		</TR>		
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
		<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>
			</TD>
		<TD> 
			<BUTTON class=Browser type="button" onclick=onShowDoc(_noticecontent_<%=eid%>,spandocids_<%=eid %>,<%=eid %>)></BUTTON>
			<input type='hidden' id="_noticecontent_<%=eid%>"  name="_noticecontent_<%=eid%>" value="<%=noticeContent %>" />
		 	<SPAN ID=spandocids_<%=eid %>><%=strSrcContentName%></SPAN>
			</TD>
		</TR>		
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
			<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(20281,user.getLanguage())%>
			</TD>
			<TD class="field">
			
			<select name="_direction_<%=eid%>">
				<option value='left'  <%=selectLeft %>><%=SystemEnv.getHtmlLabelName(20282,user.getLanguage())%></option>
				<option value='right' <%=selectRight %>><%=SystemEnv.getHtmlLabelName(20283,user.getLanguage())%></option>
			</select>
			</TD>
		</TR>		
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
		</TR>
			<TR>
			<TD>
				&nbsp;<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%>
			</TD>
			<TD class="field">
				<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%> style="WIDTH: 30px" value="<%=scrollDelay %>" name="_scrollDelay_<%=eid%>" onkeypress="ItemCount_KeyPress()" > ms
			</TD>
		</TR>		
		<TR vAlign=top>
			<TD class=line colSpan=2></TD>
		</TR>
	</TABLE>
</form>
<script type="text/javascript">
	function onchanges(eid){
		var v = document.getElementById("_noticetitle_"+eid).value;
		document.getElementById("_noticetitle_"+eid).value = v.replace(/'/g,"\\'");
	}
	
</script>
