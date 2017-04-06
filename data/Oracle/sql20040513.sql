drop TRIGGER Tri_Update_HrmRoleMembersShare
/

drop TRIGGER Tri_URole_workflow_createlist
/

delete HrmRoleMembers where resourceid = 2
/

delete hrmrolemembers where roleid not in (select id from HrmRoles )
/



CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
        docid_1	 integer;
	    crmid_1	 integer;
	    prjid_1	 integer;
	    cptid_1	 integer;
        sharelevel_1  integer;
        departmentid_1 integer;
	    subcompanyid_1 integer;
        seclevel_1	 integer;
        countrec      integer;
        countdelete   integer;
        countinsert   integer;
		managerstr_11 varchar2(200); 
        oldroleid_1 integer;
        oldresourceid_1 integer;
        contractid_1	 integer;/*2003-11-06�����*/
        contractroleid_1 integer ;   /*2003-11-06�����*/
        sharelevel_Temp integer ;  /*2003-11-06�����*/
        
/* ĳһ���˼���һ����ɫ�����ڽ�ɫ�еļ������߽��д���,������������������˹����ķ�Χ,����Ҫɾ��
ԭ�й�����Ϣ,ֻ��Ҫ�ж����ӵĲ���, �����ڽ�ɫ�м���Ľ��ͻ���ɾ��ĳһ����Ա,ֻ��ɾ��ȫ������ϸ��,����������Դһ��
�˵Ĳ��Ż��߰�ȫ����ı�Ĳ��� */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;
oldroleid_1 :=  :old.roleid; 
oldresourceid_1 := :old.resourceid;

if countdelete is null then
    countdelete := 0 ;
else 
    if countinsert is null then
        countinsert := 0 ;
    end if ;
end if ;


if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;

if resourceid_1 = 1 then 
    return ;
end if ;

/* �����ɾ��ԭ�����ݣ������ɱ��е�Ȩ����������һ */
if (countdelete > 0) then
    select seclevel into seclevel_1  from hrmresource where id = oldresourceid_1 ;
    if seclevel_1 is not null then
        Doc_DirAcl_DUserP_RoleChange (oldresourceid_1, oldroleid_1, oldrolelevel_1, seclevel_1);
    end if;
end if;
/* ��������������ݣ������ɱ��е�Ȩ����������һ */
if (countinsert > 0) then
    select  seclevel into seclevel_1 from hrmresource where id = resourceid_1;
    if seclevel_1 is not null then
        Doc_DirAcl_GUserP_RoleChange (resourceid_1, roleid_1, rolelevel_1, seclevel_1);
    end if;
end if;


if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* �µĽ�ɫ����Ϊ�ܲ��� */
     

	/* ------- DOC ���� ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
				end if;
			end if;
        end loop;



	/* ------- CRM ���� ------- */

		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
			
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			
			else if sharelevel_1 = 2  then
			
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
			end if;
			end if;
		end loop;
	   


	/* ------- PROJ ���� ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
             
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;
	
  



	/* ------- CPT ���� ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2 then 
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;

        /* ------- �ͻ���ͬ���� �ܲ� 2003-11-06�����------- */

        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and t2.rolelevel=2)
            loop
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then 
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;
        end loop;   
    end if;
    
        
    if rolelevel_1 = '1' then        /* �µĽ�ɫ����Ϊ�ֲ��� */
    

	/* ------- DOC ���� ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
			end if;
			end if;
		end loop;


	/* ------- CRM ���� ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
	   end loop;

  

	/* ------- PRJ ���� ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;
	

      

	/* ------- CPT ���� ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;

         /* ------- �ͻ���ͬ���� �ֲ� 2003-11-06�����------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 
            and (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 ))
            loop
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else   
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1  ;
                    end if;
                end if;
            end loop;
        end loop; 

    end if;
        
    
    if rolelevel_1 = '0'     then     /* Ϊ�½�ʱ���趨����Ϊ���ż� */
    

        /* ------- DOC ���� ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM ���� ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;
        
  

	/* ------- PRJ ���� ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop;
 


	/* ------- CPT ���� ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end if;
			end if;
		end loop; 
        
        /* ------- �ͻ���ͬ���� ���� 2003-11-06�����------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and 
            (t2.rolelevel=0 and t1.department=departmentid_1 ))
            loop    
               select count(contractid) into countrec from ContractShareDetail 
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0  then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail 
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2 
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;  
                    end if;
                end if;      
            end loop;

        end loop;   

    end if;
       

else 

if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* ��Ϊɾ�����߼��𽵵� */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* ɾ��ԭ�еĸ��˵������ĵ�������Ϣ */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  �����е���Ϣ�ַŵ� temptablevalue �� */
    /*  �Լ������Ļ����� owner �����¿��Ա༭ */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* �Լ��¼����ĵ� */
    /* �����¼� */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* ���ĵ��Ĺ�����õ�Ȩ�� , �������ֳ���������, ��ɫ����һ������.����һ������,�����ѯ̫��*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers_Tri  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼    */
			end if;
		end if;
    end loop ;

    /* ����ʱ���е�����д�빲���� */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  ���� ------- */


    /* ɾ��ԭ�еĸ��˵����пͻ�������Ϣ */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  �����е���Ϣ�ַŵ� temptablevaluecrm �� */
    /*  �Լ��� manager �Ŀͻ� 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* �Լ��¼��Ŀͻ� 3 */
    /* �����¼� */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* ��Ϊcrm����Ա�ܿ����Ŀͻ� */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* �ɿͻ��Ĺ�����õ�Ȩ�� 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* ����ʱ���е�����д�빲���� */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	end loop;





    /* ------- PROJ ���� ------- */



    /*  �����е���Ϣ�ַŵ� temptablevaluePrj �� */
    /*  �Լ�����Ŀ2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* �Լ��¼�����Ŀ3 */
    /* �����¼� */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;


 
    /* ��Ϊ��Ŀ����Ա�ܿ�������Ŀ4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;

	 


    /* ����Ŀ�Ĺ�����õ�Ȩ�� 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) 
    
	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then 
        
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;

	

    /* ��Ŀ��Ա5 (�ڲ��û�) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ; 
        if countrec = 0  then
        
            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* ɾ��ԭ�е������Ա��ص�������ĿȨ */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* ����ʱ���е�����д�빲���� */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;
    



    /* ------- CPT ���� ------- */


    /*  �����е���Ϣ�ַŵ� temptablevalueCpt �� */
    /*  �Լ����ʲ�2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;





    /* �Լ��¼����ʲ�1 */
    /* �����¼� */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;

 
   
    /* ���ʲ��Ĺ�����õ�Ȩ�� 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers_Tri  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
        
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;

    


    /* ɾ��ԭ�е������Ա��ص������ʲ�Ȩ */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* ����ʱ���е�����д�빲���� */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;	

    
    
    
    /* ------- �ͻ���ͬ����2003-11-06����� ------- */ 
    
    /* �Լ��¼��Ŀͻ���ͬ 3 */
     
    managerstr_11:=concat('%,',concat(to_char(resourceid_1), ',%' ));
    for subcontractid_cursor in
    (select id from CRM_Contract
    where (manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

 /*  �Լ��� manager �Ŀͻ���ͬ 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1)
    loop
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;
    
    /* ��Ϊ�ͻ���ͬ����Ա�ܿ����� */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
       (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2  
       where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 
       and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 ) 
       or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
       
         loop
            select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
            if countrec = 0 then  
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1 
                and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail 
                     set sharelevel = 2 where contractid = contractid_1 
                     and userid = resourceid_1 and usertype = 1;
                end if;
            end if;  
         end loop;
        
    end loop;
    
      /* �ɿͻ���ͬ�Ĺ�����õ�Ȩ�� 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2 
     where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  
     or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then  
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract 
            where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
               update temptablevaluecontract set sharelevel = sharelevel_1 
               where contractid = contractid_1;
            end if;
         end if;
    end loop;



    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel 
    from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers_Tri  t3  
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 
    and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel 
    and t2.seclevel<=seclevel_1 
    and ( (t2.rolelevel=0  and t1.department=departmentid_1) 
    or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
     
        loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;  
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
              update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
         end if;   
         end loop;
    
    
    /* �Լ��¼��Ŀͻ���ͬ  (�ͻ�������������)*/
    
    managerstr_11:= concat('%,',concat(to_char(resourceid_1),',%')); 


    for subcontractid_cursor in   
    (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where ( t1.manager in 
    (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11) ) 
    and (t2.crmId = t1.id))
    loop     
        select count(contractid) into countrec from temptablevaluecontract
        where contractid = contractid_1;
        if countrec = 0  then
              insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;    
 
    /*  �Լ��� manager �Ŀͻ� (�ͻ�������������) */
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
        loop
          insert into temptablevaluecontract values(contractid_1, 1);
        end loop;


    /* ɾ��ԭ�е������Ա��ص�����Ȩ */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* ����ʱ���е�����д�빲���� */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) 
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;
    
    end if; 
    /* ������ɫɾ�����߼��𽵵͵Ĵ��� */
end if ;
end ;
/


CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare 
    workflowid_1 integer ;
	type_1 integer ;
 	objid_1 integer ;
	level_n integer ;
    level2_n integer ;
	userid_1 integer ;
begin
    delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0  ;
    for tmp_cursor in ( select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid=t2.nodeid and t2.id = t3.groupid )
    loop
        workflowid_1 := tmp_cursor.workflowid ;
        type_1 := tmp_cursor.type ;
        objid_1 := tmp_cursor.objid ;
        level_n := tmp_cursor.level_n ;
        level2_n := tmp_cursor.level2_n ;
        
        if type_1 = 1 then
            for tmp_cursor2 in ( select id from HrmResource where departmentid = objid_1 and seclevel >= level_n and seclevel <= level2_n ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
        
        if type_1 = 2 then
            for tmp_cursor2 in ( SELECT resourceid FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n ) 
            loop 
                userid_1 := tmp_cursor2.resourceid ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
        
        if type_1 = 3 then
            insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,objid_1,0);
        end if ;
        
	    if type_1 = 30 then
            for tmp_cursor2 in ( select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n and seclevel <= level2_n ) 
            loop 
                userid_1 := tmp_cursor2.id ;
                insert into workflow_createrlist(workflowid,userid,usertype) values(workflowid_1,userid_1,0) ;
            end loop ;
        end if ;
    end loop ;
end ;
/

delete FROM workflow_base WHERE formid = 30
/