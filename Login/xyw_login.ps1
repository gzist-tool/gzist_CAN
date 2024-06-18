# ���ø����������
Param(
    # ��¼��ʽ��0�����Կͻ��˵�¼ 1���ֻ��ͻ��˵�¼
    $METHOD = '0',
    # �û��˺�
    $ACCOUNT = '',
    # �û�����
    $PASSWORD = '',
    # ��¼�豸��MAC ��ַ��xx-xx-xx-xx-xx-xx��[Ϊ�����Զ���ȡ]
    $MAC = '',
    # ��¼�豸��IP ��ַ��IPv4��[Ϊ�����Զ���ȡ]
    $IP = '',
    # ��ȡMAC��IP����������[Ϊ����ʹ���Զ���]
    $ADAPTERNAME = '��̫��'
)
function Output_Log {
    param (
        [string]$outStr,
        [string]$fileName
    )
    $fullDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "====== $fullDateTime ======
$outStr
============== End ==============" | Tee-Object -Append -FilePath "$fileName.log"
}

#=======================================================================
if (!($ACCOUNT -and $PASSWORD)) {
    $outstr = "ȱ���˺Ż����룬�ű����˳�."
    Output_Log -outStr $outstr -fileName "Login_Error_($ACCOUNT)"
    exit
}
#=======================================================================
# ʹ�ñ����洢��ȡ�������Ľ��
$adapter = Get-NetAdapter -Name $ADAPTERNAME
# ����Ƿ�ɹ���ȡ��������
if ($adapter) {
    $adapterName = $($adapter.Name)
    if ( $MAC ) {
        $macAddress = $MAC -replace '-'
    }
    else {
        # ��ȡ�������� MAC ��ַ
        $macAddress = $adapter.MacAddress -replace '-'
    }
    if ( $IP) {
        $ipAddress = $IP
    }
    else {
        # ��ȡ�������� IP ��ַ��IPv4��
        $ipAddress = (Get-NetIPAddress -InterfaceAlias $ADAPTERNAME -AddressFamily IPv4).IPAddress
    }
}
else {
    $adapterName = "������δ�ҵ�"
    if ( $MAC -and $IP ) {
        $macAddress = $MAC -replace '-'
        $ipAddress = $IP
    }
    else {
        $outstr = "ȱ��MAC��IP���ű����˳�."
        Output_Log -outStr $outstr -fileName "Login_Error_($ACCOUNT)"
        exit
    }
}

# ��������Ļ���URL
$baseURL = "http://10.0.10.252:801/eportal/?c=Portal&a=login&login_method=1&wlan_ac_ip=10.128.255.142"

$user_account = ",$METHOD,$ACCOUNT"
$user_password = $PASSWORD
$wlan_user_mac = $macAddress
$wlan_user_ip = $ipAddress

# ����������URL
$fullURL = "$baseURL&user_account=$user_account&user_password=$user_password&wlan_user_ip=$wlan_user_ip&wlan_user_mac=$wlan_user_mac"

# ִ��HTTP GET����
$response = Invoke-RestMethod -Uri $fullURL -Method GET

# ��Unicodeת��Ϊ�ı�
$decodedResponse = [regex]::Unescape($response)

# ��ʾ�������ı�
$outstr = "����: $adapterName
MAC:  $macAddress
IP:   $ipAddress
���: $decodedResponse"
Output_Log -outStr $outstr -fileName "Login_Info_($ACCOUNT-$macAddress)"