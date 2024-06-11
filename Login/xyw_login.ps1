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
        Write-Output "ȱ�ٲ������ű����˳�."
        exit
    }
}

Write-Output "����: $adapterName"
Write-Output "MAC:  $macAddress"
Write-Output "IP:   $ipAddress"

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
Write-Output $decodedResponse
