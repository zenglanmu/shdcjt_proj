INSERT INTO HtmlLabelIndex values(19038,'��ͳ����Ա') 
/
INSERT INTO HtmlLabelIndex values(19039,'��ͳ����Ա����') 
/
INSERT INTO HtmlLabelIndex values(19040,'�ɲ鿴��Ա')
/
INSERT INTO HtmlLabelIndex values(19041,'�ɲ鿴��Ա����') 
/


INSERT INTO HtmlLabelIndex values(19042,'�ճ�ͳ������') 
/
INSERT INTO HtmlLabelInfo VALUES(19038,'��ͳ����Ա',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19038,'member to be statistic',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19039,'��ͳ����Ա����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19039,'the type of the member to be statistic',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19040,'�ɲ鿴��Ա',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19040,'member to visit',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19041,'�ɲ鿴��Ա����',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19041,'the type of the member to visit',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19042,'�ճ�ͳ������',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19042,'Work Pan Report Setting',8) 
/

INSERT INTO HtmlLabelIndex values(19043,'�ճ�ͳ�Ʊ����鿴��Χ') 
/
INSERT INTO HtmlLabelInfo VALUES(19043,'�ճ�ͳ�Ʊ����鿴��Χ',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19043,'Range of Work Plan Report Tracing',8) 
/



insert INTO SystemRights (id,rightdesc,righttype) values (647,'�ճ�ͳ������','3') 
/
insert INTO SystemRightsLanguage (id,languageid,rightname,rightdesc) values (647,7,'�ճ�ͳ������','�ճ�ͳ������') 
/
insert INTO SystemRightsLanguage (id,languageid,rightname,rightdesc) values (647,8,'Work Plan Report Setting','Work Plan Report Setting') 
/
insert INTO SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4147,'�ճ�ͳ������','WorkPlanReportSet:Set',647) 
/



INSERT INTO HtmlLabelIndex values(19057,'�ճ���ͳ��') 
/
INSERT INTO HtmlLabelIndex values(19058,'�ճ���ͳ��') 
/
INSERT INTO HtmlLabelInfo VALUES(19057,'�ճ���ͳ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19057,'Work Plan Weekly Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19058,'�ճ���ͳ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19058,'Work Plan Monthly Report',8) 
/

INSERT INTO HtmlLabelIndex values(19080,'�ճ�ͳ��') 
/
INSERT INTO HtmlLabelInfo VALUES(19080,'�ճ�ͳ��',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19080,'Work Plan Report',8) 
/


CALL MMConfig_U_ByInfoInsert(3,15)
/
CALL MMInfo_Insert(491,19042,'','/workplan/config/WorkPlanReportSetOperation.jsp','mainFrame',3,1,15,0,'',1,'WorkPlanReportSet:Set',0,'','',0,'','',2)
/

CALL LMConfig_U_ByInfoInsert(2,140,0)
/
CALL LMInfo_Insert(150,19057,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/workplan/report/WorkPlanReportListOperation.jsp?type=1',2,140,0,2 )
/

CALL LMConfig_U_ByInfoInsert(2,140,1)
/
CALL LMInfo_Insert(151,19058,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/workplan/report/WorkPlanReportListOperation.jsp?type=2',2,140,1,2 )
/


CREATE TABLE WorkPlanVisitSet 
(
    WorkPlanVisitSetID integer NOT NULL ,
    WorkPlanReportType integer NULL ,
    WorkPlanReportContentID varchar2 (400) ,
    WorkPlanReportSec integer NULL ,
    WorkPlanVisitType integer NULL ,
    WorkPlanVisitContentID varchar2 (400) ,
    WorkPlanVisitSec integer NULL 
)
/


create sequence WorkPlanVisitSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanVisitSet_Tri
before insert on WorkPlanVisitSet
for each row
begin
select WorkPlanVisitSet_id.nextval INTO :new.WorkPlanVisitSetID from dual;
end;
/



CREATE TABLE WorkPlanVisitSetDetail 
(
    WorkPlanVisitSetDetailID integer  NOT NULL ,
    WorkPlanReportType integer NULL ,
    WorkPlanReportContentID integer NULL ,
    WorkPlanReportSec integer NULL ,
    WorkPlanVisitType integer NULL ,
    WorkPlanVisitContentID integer NULL ,
    WorkPlanVisitSec integer NULL ,
    WorkPlanVisitSetID integer NULL 
)
/

create sequence WorkPlanVisitSetDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkPlanVisitSetDetail_Tri
before insert on WorkPlanVisitSetDetail
for each row
begin
select WorkPlanVisitSetDetail_id.nextval INTO :new.WorkPlanVisitSetDetailID from dual;
end;
/