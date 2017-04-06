ALTER TABLE blog_sysSetting   ADD  attachmentDir VARCHAR2(4000) NULL
/
INSERT INTO blog_app(name,isActive,appType,sort,iconPath) VALUES('156',1,'attachment',7,'')
/

    declare
    val_id integer;
    val_tempid integer;
    val_managerid integer;
    val_tempmanagerid integer;
    var_managetstr VARCHAR2(1000);
    var_hrmcount integer;
    cursor cursor0 is SELECT id,managerid FROM HrmResource order by id;
    begin
        var_managetstr:='';
        val_tempmanagerid:=0;
        if cursor0%isopen = false then
            open cursor0;
        end if;
        
        fetch cursor0 into val_id,val_managerid;
        while cursor0%found loop
           WHILE val_managerid<>0 AND val_managerid IS NOT NULL AND val_managerid<>val_tempmanagerid and instr(var_managetstr||',',','||to_char(val_managerid)||',',1)=0 loop
              val_tempmanagerid:=val_managerid;
              SELECT count(*) into var_hrmcount FROM HrmResource WHERE id=val_managerid;
              if var_hrmcount>0 then
                 begin
	              SELECT id into val_tempid FROM HrmResource WHERE id=val_managerid;
	              SELECT managerid into val_managerid FROM HrmResource WHERE id=val_managerid;
	              var_managetstr:=var_managetstr||','||to_char(val_tempid);
	             end; 
	          end if; 
	          var_hrmcount:=0;
           end loop;
           
           var_managetstr:=var_managetstr||',';
           UPDATE HrmResource SET managerstr=var_managetstr WHERE id=val_id;
           var_managetstr:='';
           
           fetch cursor0 into val_id,val_managerid;
        end loop;
        
        close cursor0;
    end;    
/
