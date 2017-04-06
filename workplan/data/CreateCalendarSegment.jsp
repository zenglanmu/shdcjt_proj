<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="recordSetCreateSegment" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
%>
<div id="editBox" class="editBox" style="display:none;">
            	<div style="padding:10px;">
            	<input name="workplanId" id="workplanId" type="hidden"/>
            				<form action="" name="editBox">
            					<table style="width:100%;padding:10;" class="ViewForm" >
            						<colgroup>
            							<col width="80px" />
            							<col width="0px"/>
            							<col width="*"/>
            						</colgroup>
            						<tbody></tbody>
            						<tr class="calLine">
            							<td align="left"><%=SystemEnv.getHtmlLabelName( 16094 ,user.getLanguage())%></td>
     										<td></td>
     										<td align="left">
     										  <select id="workPlanTypeSelect" name="workPlanTypeSelect" onchange="jQuery('#workPlanType').val(this.value)">
     										     <option value="0"><%=SystemEnv.getHtmlLabelName( 15090 ,user.getLanguage())%> </option>
     										  </select>
     										  <INPUT type=hidden id="workPlanType" name="workPlanType" value="">
     										</td>
     										
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr >
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 229 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<input name="planName" id="planName" style="width:90%" class="InputStyle styled input" style="" size="30" onblur="if(this.value)$(this).next().hide();else $(this).next().show()"/>
            								<img align="absmiddle" src="/images/BacoError.gif">
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td align="left"  valign="top"><%=SystemEnv.getHtmlLabelName( 433 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<textarea id="description" name="description" rows="5" class="InputStyle styled textarea" style="width: 90%;" onblur="if(this.value)$(this).next().hide();else $(this).next().show()"></textarea>
            								<img align="absmiddle" src="/images/BacoError.gif">
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
   										<td  align="left"><%=SystemEnv.getHtmlLabelName( 15525 ,user.getLanguage())%> </td>
   										<td></td>
   										<td align="left">
   											<button type="button" class="Browser" onclick="onShowResource('memberIDs','memberIDsSpan')"></button>
   											<input type="hidden" class="" name="memberIDs" id="memberIDs" /> 
   											<span id="memberIDsSpan" ></span>
   										</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 15534 ,user.getLanguage())%> </td>
         										<td></td>
         										<td  align="left">
         											<select id="urgentLevel" class="styled" name="urgentLevel">
         												<option value="1"><%=SystemEnv.getHtmlLabelName( 154 ,user.getLanguage())%> </option>
         												<option value="2"><%=SystemEnv.getHtmlLabelName( 15533 ,user.getLanguage())%> </option>
         												<option value="3"><%=SystemEnv.getHtmlLabelName( 2087 ,user.getLanguage())%> </option>
         											</select>
         										</td>
            						</tr>
            						<tr style="height:0;">
            							<td class="Line" colspan="3" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left" valign="top"><%=SystemEnv.getHtmlLabelName( 15148 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<table>
            									<tr>
            										<td align="left"><select class="styled" id="remindType" name="remindType" class="float:left;" onchange="if($.event.fix(event).target.value!=1)$('#remindInfo').show();else $('#remindInfo').hide()">
            												<option value="1"> <%=SystemEnv.getHtmlLabelName( 19782 ,user.getLanguage())%> </option>
            												<option value="2"><%=SystemEnv.getHtmlLabelName( 22825,user.getLanguage())%> </option>
            												<option value="3"><%=SystemEnv.getHtmlLabelName(  71 ,user.getLanguage())%> </option>
            											</select></td>
            										<td align="left">
            											
            								
            										</td>
            									</tr>
            									<tr  id="remindInfo">
            										<td colspan=2>
            											<table>
			            									<tr>
			            										<td style="display:none;">
			            											<input type="hidden" name="remindId"/>
			            										</td>
			            										<td>
			            											
			            										</td>
			            										<td>
			            											<input type="checkbox" name="remindBeforeStart" id="remindBeforeStart" value="1" />
			            											<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 19784 ,user.getLanguage())%> </span>
			            											<input style="width:30px" class="InputStyle styled input" value="0" name="remindDateBeforeStart" id="remindDateBeforeStart"/>
			            											<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>
			            											<input style="width:30px" class="InputStyle styled input" value="10" name="remindTimeBeforeStart" id="remindTimeBeforeStart"/>
			            											<span style="valign:middle"> <%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%></span>
			            										</td>
			            										
			            									</tr>
			            									<tr>
			            										<td ></td>
			            										<td>
			            											<input type="checkbox" name="remindBeforeEnd" id="remindBeforeEnd" value="1"/>
			            											<span><%=SystemEnv.getHtmlLabelName( 19785 ,user.getLanguage())%> </span>
			            											<input style="width:30px" value="0" class="InputStyle styled input"   name="remindDateBeforeEnd" id="remindDateBeforeEnd" />
			            											<span><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>
			            											<input style="width:30px" value="10" class="InputStyle styled input"  name="remindTimeBeforeEnd" id="remindTimeBeforeEnd"/>
			            											<span><%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%>  </span>
			            										</td>
			            									</tr>
			            								</table>
            										</td>
            									</tr>
            								</table>
            								
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 742 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left" valign="middle">
            								<button type="button" class="Calendar" onclick="getTheDate('beginDate', 'beginDateSpan')"></button>
            								<input type="hidden" name="beginDate"  id="beginDate"/>
            								<span style="height: 16px;" id="beginDateSpan"></span>
            								<button type="button" class="Calendar"  onclick="onWorkPlanShowTime('beginTimeSpan','beginTime')"></button>
            								<input type="hidden" name="beginTime"  id="beginTime"/>
            								<span id="beginTimeSpan">00-00</span>
            								
            							</td>
            						</tr>
            						<tr>
            							<td align="left"><%=SystemEnv.getHtmlLabelName( 743 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<button type="button" class="Calendar"  onclick="getTheDate('endDate', 'endDateSpan')"></button>
            								<input type="hidden" name="endDate"  id="endDate"/>
            								<span id="endDateSpan">2012-01-09</span>
            								<button type="button" class="Calendar" onclick="onWorkPlanShowTime('endTimeSpan','endTime')"></button>
            								<input type="hidden" name="endTime"  id="endTime"/>
            								<span id="endTimeSpan">23:59</span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 783 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<button type="button" class="Browser" onclick="onshowCrms('crmIDs','crmIDsSpan')"></button>
            								<INPUT  type="hidden" id="crmIDs" name="crmIDs" value="" >
            								<span id="crmIDsSpan"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 857 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<button type="button" class="Browser" onclick="onShowDoc('docIDs','docIDsSpan')" ></button>
            								<INPUT  type="hidden" name="docIDs" id="docIDs"/>
            								<span id="docIDsSpan"></span>
										  		
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 782 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            									<button type="button" class="Browser" onclick="onShowProject('projectIDs','projectIDsSpan')" ></button>
												<INPUT  type="hidden" id="projectIDs" name="projectIDs"/>
												<span id="projectIDsSpan"></span>
										</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 1044 ,user.getLanguage())%> </td>
            							<td></td>
            							<td align="left">
            								<button type="button" class="Browser" onclick="onshowRequest('requestIDs','requestIDsSpan')"></button>
            								<INPUT  type="hidden" name="requestIDs"  id="requestIDs"/>
											<span id="requestIDsSpan"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;" >
            							<td colspan="3" class="Line" style="padding:0;"></td>
            						</tr>
            						</tbody>
            					</table>
            				</form>
            			
            </div>
            </div>