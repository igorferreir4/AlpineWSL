# to other machines (besides the Windows machine running WSL2 running the service) on
# the local network.  It can be set up to run on startup of Windows through Task Scheduler Triggers,
# as described here: https://github.com/microsoft/WSL/issues/4150
# This script must be run with administrator priveledges.

$lines_with_IP_addresses = bash.exe -c "ip addr | grep -Ee 'inet.*eth0'"
$regex = [regex] "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
$potential_IP_addresses = $regex.Matches($lines_with_IP_addresses) | % { $_.value }

if ( $potential_IP_addresses ) {
  $wsl2_IP_address = $potential_IP_addresses[0];
  echo "Usando IP do WSL2 $wsl2_IP_address
";
}
else {
  echo "Parando script, o IP do WSL2 nao foi encontrado.";
  exit;
}

#[Portas]

#Todas as portas que deseja redirecionar separadas por virgula
$ports = @(80, 443, 27001, 8096);


#[IP Estático]
#Você pode escolher um ip estático para configurar o redirecionamento
$addr = '0.0.0.0';
$ports_as_string = $ports -join ",";


#Remove Firewall Exception Rules
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
echo "Abrindo portas: $ports";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_as_string -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_as_string -Action Allow -Protocol TCP";

foreach ($port in $ports) {
  echo "Deletando regra v4parav4 de porta=$port no ip=$addr";
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  echo "Adicionando regra v4parav4 de porta=$port no ip=$addr redirecionando para porta=$port no ip=$wsl2_IP_address";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$wsl2_IP_address";
}


$windows_ipv4 = (Get-NetIPAddress | Where-Object { $_.AddressState -eq "Preferred" -and $_.PrefixOrigin -eq "DHCP" }).IPAddress
echo "Use $windows_ipv4 e porta # para conectar a sua tarefa a partir de outros dispositivos na rede local."

pause