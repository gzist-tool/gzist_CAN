# 设置各个请求参数
Param(
    # 登录方式：0：电脑客户端登录 1：手机客户端登录
    $METHOD = '0',
    # 用户账号
    $ACCOUNT = '',
    # 用户密码
    $PASSWORD = '',
    # 登录设备的MAC 地址（xx-xx-xx-xx-xx-xx）[为空则自动获取]
    $MAC = '',
    # 登录设备的IP 地址（IPv4）[为空则自动获取]
    $IP = '',
    # 获取MAC和IP的网卡名称[为空则使用自定义]
    $ADAPTERNAME = '以太网'
)

#=======================================================================
# 使用变量存储获取适配器的结果
$adapter = Get-NetAdapter -Name $ADAPTERNAME
# 检查是否成功获取到适配器
if ($adapter) {
    $adapterName = $($adapter.Name)
    if ( $MAC ) {
        $macAddress = $MAC -replace '-'
    }
    else {
        # 获取适配器的 MAC 地址
        $macAddress = $adapter.MacAddress -replace '-'
    }
    if ( $IP) {
        $ipAddress = $IP
    }
    else {
        # 获取适配器的 IP 地址（IPv4）
        $ipAddress = (Get-NetIPAddress -InterfaceAlias $ADAPTERNAME -AddressFamily IPv4).IPAddress
    }
}
else {
    $adapterName = "适配器未找到"
    if ( $MAC -and $IP ) {
        $macAddress = $MAC -replace '-'
        $ipAddress = $IP
    }
    else {
        Write-Output "缺少参数，脚本将退出."
        exit
    }
}

Write-Output "网卡: $adapterName"
Write-Output "MAC:  $macAddress"
Write-Output "IP:   $ipAddress"

# 设置请求的基础URL
$baseURL = "http://10.0.10.252:801/eportal/?c=Portal&a=login&login_method=1&wlan_ac_ip=10.128.255.142"

$user_account = ",$METHOD,$ACCOUNT"
$user_password = $PASSWORD
$wlan_user_mac = $macAddress
$wlan_user_ip = $ipAddress

# 构建完整的URL
$fullURL = "$baseURL&user_account=$user_account&user_password=$user_password&wlan_user_ip=$wlan_user_ip&wlan_user_mac=$wlan_user_mac"

# 执行HTTP GET请求
$response = Invoke-RestMethod -Uri $fullURL -Method GET

# 将Unicode转换为文本
$decodedResponse = [regex]::Unescape($response)

# 显示解码后的文本
Write-Output $decodedResponse
