<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 java.util.List,
                 weaver.docs.docs.FieldParam,
                 java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<%
    String method = Util.null2String(request.getParameter("method"));
    String formlabel = Util.null2String(request.getParameter("formlabel"));
    String viewtype = Util.null2String(request.getParameter("viewtype"));
    int scopeorder = Util.getIntValue(request.getParameter("scopeorder"),0);
    int parentid = Util.getIntValue(request.getParameter("parentid"),0);
    int id = Util.getIntValue(request.getParameter("id"),0);

    if(method.equals("add")){
        id = CustomFieldTreeManager.addTreeField("HrmCustomFieldByInfoType", formlabel, viewtype, parentid, scopeorder);
    }else if(method.equals("edit")){
        CustomFieldTreeManager.editTreeField(id, "HrmCustomFieldByInfoType", formlabel, viewtype, parentid, scopeorder);
    }else if(method.equals("delete")){
        CustomFieldTreeManager.deleteTreeField(id, "HrmCustomFieldByInfoType");
    }


    int scopeId = id;
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    if(method.equals("add")||method.equals("edit")){
        String[] fieldlable = request.getParameterValues("fieldlable");
        String[] fieldid = request.getParameterValues("fieldid");
        String[] fieldhtmltype = request.getParameterValues("fieldhtmltype");
        String[] type = request.getParameterValues("type");
        String[] flength = request.getParameterValues("flength");
        String[] ismand = request.getParameterValues("ismand");
        String[] selectitemid = request.getParameterValues("selectitemid");
        String[] selectitemvalue = request.getParameterValues("selectitemvalue");


        //if(fieldlable!=null&&fieldhtmltype!=null&&type!=null&&flength!=null){
        //    for(int i=0; i<fieldlable.length ; i++){
        //        System.out.print(fieldid[i]+"\t");
        //        System.out.print(fieldlable[i]+"\t");
        //        System.out.print(fieldhtmltype[i]+"\t");
        //        System.out.print(type[i]+"\t");
        //        System.out.println(flength[i]+"\t");
        //    }
        //}
        //System.out.println("--------------------------------------");
        //if(selectitemid!=null&&selectitemvalue!=null){
        //    for(int i=0; i<selectitemid.length ; i++){
        //        System.out.print(selectitemid[i]+"\t");
        //        System.out.println(selectitemvalue[i]+"\t");
        //    }
        //}
        //
        //System.out.println("=======================================");


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
                    fp.setBrowser(Util.getIntValue(type[i],-1));
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
            }
        }
        cfm.deleteFields(delFields);
        response.sendRedirect("EditHrmCustomField.jsp?id="+id);
        return;
    }else if(method.equals("delete")){
        cfm.delete();
        if(parentid!=0){
            response.sendRedirect("EditHrmCustomField.jsp?id="+parentid);
            return;
        }else{
            response.sendRedirect("HrmCustomFieldManager.jsp");
            return;
        }
    }



%>