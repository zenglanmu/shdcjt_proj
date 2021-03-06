ALTER TABLE workflow_base ADD  titleFieldId integer null
/
ALTER TABLE workflow_base ADD  keywordFieldId integer null
/

CREATE TABLE Workflow_Keyword(
	id integer NOT NULL ,
	keywordName varchar2(60) NULL ,
	keywordDesc varchar2(200) NULL ,
	parentId integer NULL ,
	isLast char(1) NULL ,
	isKeyword char(1) NULL ,
	showOrder number(6,2) NULL 
)
/

create sequence Workflow_Keyword_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Workflow_Keyword_Tri
before insert on Workflow_Keyword
for each row
begin
select Workflow_Keyword_id.nextval into :new.id from dual;
end;
/


insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('综合经济','综合经济',-1,'0','0',1.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('工交、能源、邮电','工交、能源、邮电',-1,'0','0',2.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('旅游、城乡建设、环保','旅游、城乡建设、环保',-1,'0','0',3.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('农业、林业、水利、气象','农业、林业、水利、气象',-1,'0','0',4.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('财政、金融','财政、金融',-1,'0','0',5.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('贸易','贸易',-1,'0','0',6.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('外事','外事',-1,'0','0',7.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('公安、司法、监察','公安、司法、监察',-1,'0','0',8.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('民政、劳动人事','民政、劳动人事',-1,'0','0',9.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('科、教、文、卫、体','科、教、文、卫、体',-1,'0','0',10.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('国防','国防',-1,'0','0',11.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('秘书、行政','秘书、行政',-1,'0','0',12.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
values('综合党团','综合党团',-1,'0','0',13.00)
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
select '计划','计划',id,'0','1',14.00
  from  Workflow_Keyword
  where keywordName='综合经济'
/
insert into Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder)
select '规划','规划',id,'1','1',15.00
  from  Workflow_Keyword
  where keywordName='计划'
/

update Workflow_Keyword set parentId=0 where parentId<0
/
