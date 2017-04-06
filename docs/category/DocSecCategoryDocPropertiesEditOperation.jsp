<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>

<%
String method = Util.null2String(request.getParameter("method"));
char flag=Util.getSeparator();
int userid=user.getUID();
AclManager am = new AclManager();
CategoryManager cm = new CategoryManager();

int secid = Util.getIntValue(request.getParameter("secCategoryId"),0);
int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secid),0);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),0);
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equalsIgnoreCase("save") ){

    String[] fieldlable = request.getParameterValues("fieldlable");
    String[] fieldid = request.getParameterValues("fieldid");
    String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
    String[] type = request.getParameterValues("type");
    String[] flength = request.getParameterValues("flength");
    String[] ismand = request.getParameterValues("ismand");
    String[] selectitemid = request.getParameterValues("selectitemid");
    String[] selectitemvalue = request.getParameterValues("selectitemvalue");
    String[] definebroswerType = request.getParameterValues("definebroswerType");

    int scopeId = secid;

    CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory",scopeId);
    List delFields = cfm.getAllFields2();
    FieldParam fp = new FieldParam();
    if(fieldlable!=null&&fieldid!=null&&fieldhtmltype!=null&&type!=null&&ismand!=null&&flength!=null){
        int selectIndex = 0;
        for(int i=0; i<fieldlable.length ; i++){
            if(type[i].equals("")){
                type[i] = "0";
            }
            delFields.remove(fieldid[i]);
            if(fieldhtmltype[i].equals("1")){
                fp.setSimpleText(Util.getIntValue(type[i],-1),flength[i]);
            }else if(fieldhtmltype[i].equals("2")){
                fp.setText();
            }else if(fieldhtmltype[i].equals("3")){
                //fp.setBrowser(Util.getIntValue(type[i],-1));
				if(type[i].equals("161")||type[i].equals("162")){
					fp.setBrowser(Util.getIntValue(type[i],-1),definebroswerType[i]);
				}else{
					fp.setBrowser(Util.getIntValue(type[i],-1));
				}
            }else if(fieldhtmltype[i].equals("4")){
                fp.setCheck();
            }else if(fieldhtmltype[i].equals("5")){
                fp.setSelect();
            }else{
                continue;
            }
            int temId = cfm.checkField(Util.getIntValue(fieldid[i]),fieldlable[i],fp.getFielddbtype(),fp.getFieldhtmltype(),type[i],ismand[i],String.valueOf(i));
            if(fieldhtmltype[i].equals("5")&&temId != -1){
                ArrayList temItemValue = new ArrayList();
                ArrayList temItemName = new ArrayList();
                for(;selectIndex<selectitemid.length;selectIndex++){
                    if(selectitemid[selectIndex].equals("--")){
                        selectIndex++;
                        break;
                    }
                    temItemValue.add(selectitemid[selectIndex]);
                    temItemName.add(selectitemvalue[selectIndex]);
                }
                cfm.checkSelectField(temId, temItemValue, temItemName);
            }
            
            if(temId!=-1) fieldid[i] = temId+"";
        }
    }
    cfm.deleteFields(delFields);
    
    String[] settingPropertyId = request.getParameterValues("propertyid");
    String[] settingType = request.getParameterValues("stype");
    String[] settingLabelId = request.getParameterValues("labelId");
    String[] settingIsCustom = request.getParameterValues("isCustom");
    String[] settingScope = request.getParameterValues("scope");
    String[] settingScopeId = request.getParameterValues("scopeid");
    String[] settingFieldId = request.getParameterValues("fieldid1");
    String[] settingVisible = request.getParameterValues("visible");
    String[] settingCustomName = request.getParameterValues("customName");
    String[] settingColumnWidth = request.getParameterValues("columnWidth");
    String[] settingMustInput = request.getParameterValues("mustInput");
	for(int i=0;i<settingPropertyId.length;i++){
		int tmpId = Util.getIntValue(settingPropertyId[i],-1);
		int tmpSecCategoryId = secid;
		int tmpViewindex = i+1;
		int tmpType = Util.getIntValue(settingType[i],0);
		int tmpLabelId = Util.getIntValue(settingLabelId[i],-1);
		int tmpVisible = Util.getIntValue(settingVisible[i],1);
		String tmpCustomName = settingCustomName[i];
		//String tmpCustomName = new String(settingCustomName[i].getBytes("ISO-8859-1"),"GBK");
		int tmpColumnWidth = Util.getIntValue(settingColumnWidth[i],1);
		int tmpMustInput = Util.getIntValue(settingMustInput[i],1);
		int tmpIsCustom = Util.getIntValue(settingIsCustom[i],0);
		String tmpScope = settingScope[i];
		int tmpScopeId = Util.getIntValue(settingScopeId[i],-1);
		int tmpFieldId = Util.getIntValue(settingFieldId[i],-1);
		tmpCustomName=tmpCustomName.replaceAll("@"," ");
    	if(settingIsCustom[i].equals("1")){//如果自定义字段
    	    for(int j=0;j<fieldlable.length;j++){
   				if(fieldlable[j].equals(tmpCustomName.substring(0,tmpCustomName.lastIndexOf("(")))){
   					tmpScope = "DocCustomFieldBySecCategory";
   					tmpScopeId = secid;
   					tmpFieldId = Util.getIntValue(fieldid[j]);
   					break;
   				}
   			}
    	}
    	
    	if(tmpId==-1){
			RecordSet.executeSql("insert into DocSecCategoryDocProperty"
					+"(secCategoryId,viewindex,type,labelid,visible,customName,columnWidth,mustInput,isCustom,scope,scopeid,fieldid)"
					+"values("
					+tmpSecCategoryId+","
					+tmpViewindex+","
					+tmpType+","
					+tmpLabelId+","
					+tmpVisible+","
					+"'"+tmpCustomName+"'"+","
					+tmpColumnWidth+","
					+tmpMustInput+","
					+tmpIsCustom+","
					+"'"+tmpScope+"'"+","
					+tmpScopeId+","
					+tmpFieldId+")"
				);
    	} else {
			RecordSet.executeSql("update DocSecCategoryDocProperty"
					+" set secCategoryId = " + tmpSecCategoryId
					+" ,viewindex = " + tmpViewindex
					+" ,type = " + tmpType
					+" ,labelid = " + tmpLabelId
					+" ,visible = " + tmpVisible
					+" ,customName = " + "'" + tmpCustomName + "'"
					+" ,columnWidth = " + tmpColumnWidth
					+" ,mustInput = " + tmpMustInput
					+" ,isCustom = " + tmpIsCustom
					+" ,scope = " + "'"+tmpScope + "'"
					+" ,scopeid = " + tmpScopeId
					+" ,fieldid = " + tmpFieldId
					+" where id = " + tmpId
				);
    	}
	}
	
	String delFieldIds = "";
	for(Iterator it = delFields.iterator();it.hasNext();){
		delFieldIds += ","+(String) it.next();
	}
	if(delFieldIds.startsWith(",")) delFieldIds = delFieldIds.substring(1);
	if(delFieldIds!=null&&!"".equals(delFieldIds))
	RecordSet.executeSql("delete from DocSecCategoryDocProperty where "
			+ " secCategoryId = " + secid
			+ " and fieldid in (" + delFieldIds + ")"
	);
	
	
    SubCategoryComInfo.removeMainCategoryCache();
	SecCategoryComInfo.removeMainCategoryCache();
	
	
	SecCategoryDocPropertiesComInfo.removeCache();
	SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
	
	
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=5");
}
%>