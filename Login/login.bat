@REM ��¼��ʽ��0�����Կͻ��˵�¼ 1���ֻ��ͻ��˵�¼
set "METHOD=0"
@REM �û��˺�
set "ACCOUNT="
@REM �û�����
set "PASSWORD="
@REM ��¼�豸��MAC ��ַ��xx-xx-xx-xx-xx-xx��[Ϊ�����Զ���ȡ]
set "MAC="
@REM ��¼�豸��IP ��ַ��IPv4��[Ϊ�����Զ���ȡ]
set "IP="
@REM ��ȡMAC��IP����������[Ϊ����ʹ���Զ���]
set "ADAPTERNAME=��̫��"
@REM ��ʼ�������ַ���
set "ARGS="

@REM ���������ַ���
if not "%METHOD%"=="" set "ARGS=%ARGS% -METHOD %METHOD%"
if not "%ACCOUNT%"=="" set "ARGS=%ARGS% -ACCOUNT %ACCOUNT%"
if not "%PASSWORD%"=="" set "ARGS=%ARGS% -PASSWORD %PASSWORD%"
if not "%MAC%"=="" set "ARGS=%ARGS% -MAC %MAC%"
if not "%IP%"=="" set "ARGS=%ARGS% -IP %IP%"
if not "%ADAPTERNAME%"=="" set "ARGS=%ARGS% -ADAPTERNAME %ADAPTERNAME%"

PowerShell set-executionpolicy remotesigned
PowerShell .\xyw_login.ps1 %ARGS%