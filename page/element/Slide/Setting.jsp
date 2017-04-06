
<%@ include file="/page/element/settingCommon.jsp"%>
<%@ include file="common.jsp"%>
<%@page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%

String sql2=" select name,value from hpelementSetting where eid="+eid;
System.out.println(sql2);
rs_Setting.execute(sql2);
String[] colNames=rs_Setting.getColumnName();
System.out.println(colNames.toString());
HashMap values=new HashMap();
while(rs_Setting.next()){
		values.put(Util.null2String(rs_Setting.getString(colNames[0])),Util.null2String(rs_Setting.getString(colNames[1])));
}
%>
<script type="text/javascript">
	$(function(){
		document.getElementById("slide_t_changeStyle").value="<%=values.get("slide_t_changeStyle")%>";
	});
</script>

	<tr class="line">
		<td><%=SystemEnv.getHtmlLabelName(26286,user.getLanguage())%></td>
		<td class="field"><input name="slide_t_AutoChangeTime" class="inputStyle" style="width:120px" value='<%=Util.null2String((String)values.get("slide_t_AutoChangeTime")) %>'></input><%=SystemEnv.getHtmlLabelName(26287,user.getLanguage())%></td>
	</tr>
	<tr class="line"  >
		<td><%=SystemEnv.getHtmlLabelName(26288,user.getLanguage())%></td>
		<td class="field">
			<select name="slide_t_changeStyle" id="slide_t_changeStyle">
				<option value="uncover" >uncover</option>
				<option value="blindX" >blindX</option>
				<option value="fade" >fade</option>
				<option value="curtainX" >curtainX</option>
				<option value="curtainY" >curtainY</option>
				<option value="fadeZoom" >fadeZoom</option>
			</select>
		</td>
	</tr>
	<tr class="line">
		<td><%=SystemEnv.getHtmlLabelName(26289,user.getLanguage())%></td>
		<td class="field"><input name="slide_t_changeTime" class="inputStyle" style="width:120px" value='<%=Util.null2String((String)values.get("slide_t_changeTime")) %>'></input>∫¡√Î</td>
	</tr>
	<tr class="line" style="display:none;">
		<td><%=SystemEnv.getHtmlLabelName(26290,user.getLanguage())%></td>
		<td class="field">
			<select name="slide_t_changeStyleBar">
				<option><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%> </option>
			</select>
		</td>
	</tr>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19989,user.getLanguage())%> </td>
		<td class="field">
			<%if("1".equals(values.get("slide_t_position"))){ %>
				<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>£∫<input type="radio" checked="checked" name="slide_t_position" value="1">&nbsp;
				<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:<input type="radio" name="slide_t_position" value="2">
				<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:<input type="radio" name="slide_t_position" value="3">
			<%}else if("2".equals(values.get("slide_t_position"))){ %>
				<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>£∫<input type="radio"  name="slide_t_position" value="1">&nbsp;
				<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:<input type="radio" checked="checked"  name="slide_t_position" value="2">
				<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:<input type="radio" name="slide_t_position" value="3">
			<%} else{%>
				<%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%>£∫<input type="radio"  name="slide_t_position" value="1">&nbsp;
				<%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%>:<input type="radio"  name="slide_t_position" value="2">
				<%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%>:<input type="radio" checked="checked" name="slide_t_position" value="3">
			<%} %>
		</td>
	</tr>
	<tr>
		<td></td>
		<td class="field">
			<a href="javascript:void(0);" title="<%=SystemEnv.getHtmlLabelName(22922,user.getLanguage())%>" onclick="window.showModalDialog('/page/element/Slide/SettingBrowser2.jsp?picturetype=2&eid=<%=eid%>','','dialogWidth:880px;dialogHeight:300px;');"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></a>
		</td>
	</tr>
</form>



