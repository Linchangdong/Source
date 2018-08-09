drop table T_YSB_WEIXINUSER;
create table T_YSB_WEIXINUSER
(
	[FUSERID] [int] IDENTITY(1,1) NOT NULL,--家长内码ID
	[FWEIXINPUBLICNO] [nvarchar](50) NOT NULL DEFAULT ' ',--微信公共号ID
	[FOPENID] [nvarchar](28) NULL DEFAULT ' ',
	[FSUBSCRIBE] [nvarchar](100) NULL DEFAULT ' ',
	[FNICKNAME] [nvarchar](100) NULL DEFAULT ' ',
	[FSEX] [nvarchar](10) NULL DEFAULT ' ',
	[FLANGUAGE] [nvarchar](50) NULL DEFAULT ' ',
	[FCITY] [nvarchar](50) NULL DEFAULT ' ',
	[FPROVINCE] [nvarchar](50) NULL DEFAULT ' ',
	[FCOUNTRY] [nvarchar](50) NULL DEFAULT ' ',
	[FHEADIMGURL] [nvarchar](100) NULL DEFAULT ' ',
	[FSUBSCRIBE_TIME] [bigint] NOT NULL DEFAULT 0,
	[FUNIONID] [nvarchar](50) NULL DEFAULT ' ',
	[FGROUPID] [bigint] NOT NULL DEFAULT 0,
	[FPHONENO] [nvarchar](50) NOT NULL DEFAULT ' ',--电话号码
	[FBANKNO] [nvarchar](50) NOT NULL DEFAULT ' ',--银行账号
	CONSTRAINT [PK_dbo.PK_YSB_WEIXINUSER] PRIMARY KEY CLUSTERED 
	(
		[FUSERID] ASC
	)
) ;

drop table T_YSB_WEIXINUSER_L;
create table T_YSB_WEIXINUSER_L
(
	[FPKID] [int] IDENTITY(1,1) NOT NULL,--多语言内码
	[FLOCALEID] [int] NOT NULL DEFAULT 0,--多语言类别，2052--简体中文
	[FUSERID] [int] NOT NULL DEFAULT 0,--家长内码ID
	[FNAME] [nvarchar](50) NOT NULL DEFAULT ' ',--家长名称
	[FADDRESS] [nvarchar](255) NOT NULL DEFAULT ' ',--银行开户地址
	[FBANKNAME] [nvarchar](255) NOT NULL DEFAULT ' ',--银行账户
	CONSTRAINT [PK_dbo.PK_YSB_WEIXINUSER_L] PRIMARY KEY CLUSTERED 
	(
		[FPKID] ASC
	)
);