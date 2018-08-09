
drop table T_YSB_WEIXINSTUDENT;
create table T_YSB_WEIXINSTUDENT
(
	[FSTUDENTID] [int] IDENTITY(1,1) NOT NULL,
	[FUSERID] [int] NOT NULL,
	[FSCHOOLTYPE] [char](1) NOT NULL DEFAULT ' ',--1幼儿园，2小学
	[FCLASS] [varchar](10) NOT NULL DEFAULT ' ',--班级 
	[FBIRTHDAY] [DATETIME] NULL,--出生年月
	[FSEX] [char](1) NULL DEFAULT ' ',--1男，2女
	[FHEIGHT] [int] NOT NULL DEFAULT 0,--身高
	[FWEIGHT] [int] NOT NULL DEFAULT 0,--体重
	CONSTRAINT [PK_dbo.PK_YSB_WEIXINSTUDENT] PRIMARY KEY CLUSTERED 
	(
		[FSTUDENTID] ASC
	)
) ;

drop table T_YSB_WEIXINSTUDENT_L;
create table T_YSB_WEIXINSTUDENT_L
(
	[FPKID] [int] IDENTITY(1,1) NOT NULL,--内码
	[FLOCALEID] [int] NOT NULL DEFAULT 0,--2052中文
	[FSTUDENTID] [int] NOT NULL DEFAULT 0,--外键
	[FNAME] [nvarchar](50) NOT NULL DEFAULT ' ',--名称
	CONSTRAINT [PK_dbo.PK_YSB_WEIXINSTUDENT_L] PRIMARY KEY CLUSTERED 
	(
		[FPKID] ASC
	)
);