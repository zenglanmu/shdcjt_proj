<%@ page language="java" contentType="text/html; charset=GBK" %> 

<DIV id="workPlanViewSplash" style="display:none" data="">
<input type="hidden" name="workplanIdView" id="workplanIdView">
<div >
            	<div style="padding:10px;">
            					<table style="width:100%;padding:10;" class="ViewForm" >
            						<colgroup>
            							<col width="30%" />
            							<col width="70%"/>
            						</colgroup>
            						<tbody></tbody>
            						<tr class="calLine">
            							<td align="left"><%=SystemEnv.getHtmlLabelName( 16094 ,user.getLanguage())%> </td>
     										<td align="left">
     											<span id="workplanTypeView"></span>
     										</td>
     										
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr >
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 229 ,user.getLanguage())%> </td>
            							<td align="left">
            								<span id="planNameView"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td align="left"  valign="top"><%=SystemEnv.getHtmlLabelName( 433 ,user.getLanguage())%> </td>
            							<td align="left">
            								<div id="descriptionView" style="word-break:break-all;"></div>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
   										<td  align="left"><%=SystemEnv.getHtmlLabelName( 15525 ,user.getLanguage())%> </td>
   										<td align="left">
   											<span id="memberView"></span>
   										</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 15534 ,user.getLanguage())%> </td>
         										<td  align="left">
         											<span id="urgentLevelView"></span>
         										</td>
            						</tr>
            						<tr style="height:0;">
            							<td class="Line" colspan="2" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left" valign="left"><%=SystemEnv.getHtmlLabelName( 15148 ,user.getLanguage())%> </td>
            							<td align="left">
            								<table>
            									<tr>
            										<td align="left">
            											<SPAN ID="remindTypeName"> </SPAN>
            								
            										</td>
            										<td id="remindTimeDescriptionView">
            											<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 19784 ,user.getLanguage())%> </span>:&nbsp;
            											<span id="remindDateBeforeStartView"></span>
		            									<span style="valign:middle"><%=SystemEnv.getHtmlLabelName( 391 ,user.getLanguage())%> </span>&nbsp;
		            									<span id="remindTimeBeforeStartView"></span>
		            									<span style="valign:middle"> <%=SystemEnv.getHtmlLabelName( 15049 ,user.getLanguage())%></span>&nbsp;
		            											
            										</td>
            										
            									</tr>
            									
            								</table>
            								
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 742 ,user.getLanguage())%> </td>
            							<td align="left" valign="middle">
            								<span id="beginDateTimeView"></span>
            								
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr>
            							<td align="left"><%=SystemEnv.getHtmlLabelName( 743 ,user.getLanguage())%> </td>
            							<td align="left">
            								<span id="endDateTimeView"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 783 ,user.getLanguage())%> </td>
            							<td align="left">
            								<span id="crmView"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 857 ,user.getLanguage())%> </td>
            							<td align="left">
            								<span id="docView"></span>
										  		
            							</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 782 ,user.getLanguage())%> </td>
            							<td align="left">
            									<span id="projectView"></span>
										</td>
            						</tr>
            						<tr	style="height:1px;">
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						<tr class="calLine">
            							<td  align="left"><%=SystemEnv.getHtmlLabelName( 1044 ,user.getLanguage())%> </td>
            							<td align="left">
            								<span id="requestView"></span>
            							</td>
            						</tr>
            						<tr	style="height:1px;" >
            							<td colspan="2" class="Line" style="padding:0;"></td>
            						</tr>
            						</tbody>
            					</table>
            				</form>
            			
            </div>
            </div>
       </DIV>