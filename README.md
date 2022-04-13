//userInfo DB

CREATE TABLE Userinfo(
 userEmail          varchar2(50) primary key,
 userPw             varchar2(128) not null,
 userNick           varchar2(30) not null,
 userBirth          varchar2(10) not null,
 userAge            number(4) not null,
 userGender         varchar2(10) not null,
 userPst            number(10) not null,
 userAddress        varchar2(200) not null,
 userProfileImg     varchar2(300),
 userProfileMsg     varchar2(300),
 userFollower       number(10) default 0,
 userFollowing      number(10) default 0,
 userAuthority      varchar2(20),
 userJoindate       date default sysdate not null,
 userVisitdate      date
);

alter table userinfo
 add constraint user_nick_uk unique(usernick);
 
commit;

--1차 추가
alter table userinfo
 modify userProfileMsg varchar2(900); --한글 300자까지 입력됨

alter table userinfo
 rename column userAddress to userAddress1; 

alter table userinfo
 add userAddress2 varchar2(200);

commit;

--2차 추가(채팅 테이블)
CREATE TABLE chatRoom(
 roomNum    number(10),
 roomId     varchar2(30) primary key,
 pubId      varchar2(50) not null,
 subId      varchar2(50) not null
);

CREATE SEQUENCE CHAT_ROOM_SEQ NOCACHE;

alter table chatRoom
 add pubImg varchar2(300);

alter table chatRoom
 add subImg varchar2(300);
 
alter table chatRoom
 modify roomId varchar2(200);

COMMIT;

--3차 추가
alter table userinfo
 modify userNick varchar2(70);
 
alter table chatRoom
 add pubNick varchar2(70);

alter table chatRoom
 add subNick varchar2(70);
 
alter table chatRoom
 add constraint chatRoom_nick_fk foreign key(pubnick) references userinfo(usernick);

alter table chatRoom
 add constraint chatRoom_nick2_fk foreign key(subnick) references userinfo(usernick);

--트리거 두개 주석 풀고 각각 드래그해서 ctrl+enter 해 
/*create or replace TRIGGER chatRoom_nick_update 
 after UPDATE OF usernick ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET pubnick = :NEW.usernick 
 WHERE pubnick = :OLD.usernick;
end;*/

/*create or replace TRIGGER chatRoom_nick2_update 
 after UPDATE OF usernick ON userinfo FOR EACH ROW 
 BEGIN UPDATE chatroom 
 SET subnick = :NEW.usernick 
 WHERE subnick = :OLD.usernick;
end;*/

CREATE TABLE chatMessage(
 m_roomId     varchar2(30),
 m_pubId      varchar2(50) not null,
 m_pubNick    varchar2(70) not null,
 m_subId      varchar2(50) not null,
 m_subNick    varchar2(70) not null,
 m_message    varchar2(2000),
 m_sendTime   date default sysdate not null
);

alter table chatMessage
 modify m_roomId varchar2(200);
 
ALTER TABLE chatMessage MODIFY (m_roomId NOT NULL);

alter table chatMessage
 add pubImg varchar2(300);

alter table chatMessage
 add subImg varchar2(300);
 
alter table chatMessage
 rename column pubImg to m_pubImg;

alter table chatMessage
 rename column subImg to m_subImg;

alter table chatMessage
 add m_num number(20) primary key;
 
CREATE SEQUENCE CHAT_MSG_SEQ NOCACHE;

alter table chatMessage
 modify m_sendTime varchar2(70);
 
alter table chatMessage
 add m_sendId varchar2(50);
 
alter table chatMessage drop column m_message;

alter table chatMessage
 add m_pubMsg varchar2(2000);

alter table chatMessage
 add m_subMsg varchar2(2000);
 
ALTER TABLE chatMessage MODIFY m_sendTime DEFAULT NULL;
 
ALTER TABLE chatmessage
ADD CONSTRAINT msg_cascade_chat
  FOREIGN KEY (m_roomId)
  REFERENCES chatRoom(roomId)
  ON DELETE CASCADE;

commit;
