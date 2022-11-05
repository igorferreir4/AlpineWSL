# AlpineWSL
## [Link para o repositório Oficial/Original](https://github.com/yuk7/AlpineWSL)

Alpine Linux no WSL (Windows 10 1803 ou mais recentes)
Baseado no [wsldl](https://github.com/yuk7/wsldl)

![screenshot](https://raw.githubusercontent.com/wiki/yuk7/wsldl/img/Alpine_Arch_Cent.png)


### [Download](https://github.com/igorferreir4/AlpineWSL/releases/latest)

## Redirecionar portas do WSL para o HOST (PC)
* Baixar os arquivos "PortasWSL.ps1" e "Redirecionar-portas-WSL-para-HOST.bat"
* Colocar ambos na mesma pasta, editar o arquivo "PortasWSL.ps1" e colocar as portas que precisa.
* Executar "Redirecionar-portas-WSL-para-HOST.bat"

## Requisitos
* Windows 10 1803 April 2018 Update x64/arm64 ou mais recentes.
* Windows Subsystem for Linux (WSL) ativado.

## Instalação
#### 1. [Download](https://github.com/igorferreir4/AlpineWSL/releases/latest) do instalador em formato zip

#### 2. Extrair todos os arquivos para uma mesma pasta

#### 3. Executar Alpine.exe para extrair os arquivos e registrar no WSL
O nome do arquivo .exe será o nome da instância a ser registrada no WSL.
Se você renomea-lo, poderá registar com um nome diferente e ter varias instâncias.


## Como usar(para instâncias já instaladas)
#### Argumentos passados para o .exe
```dos
Argumentos:
    <sem argumentos>
      - Abre um novo terminal (shell) com as configurações padrões.

    run <comando>
      - Será executado o comando na instância. Será utilizado o diretório principal da conta usada na instância.

    runp <comando (inclui o caminho do Windows)>
      - Será executado o comando na instância após converter seu caminho.

    config [comando [valor]]
      - `--default-user <usuário>`: Define o usuário padrão da instância para <usuário>.
      - `--default-uid <uid>`: Define o UID do usuário padrão da instância para <uid>.
      - `--append-path <true|false>`: Adiciona ou Retira o diretório do Windows do $PATH
      - `--mount-drive <true|false>`: Ativa ou desativa a montagem dos discos do HOST em /mnt
      - `--default-term <default|wt>`: Define o tipo padrão da janela do terminal. (default = cmd / wt = Windows Terminal)

    get [comando]
      - `--default-uid`: Obtem o UID do usuário padrão da instância.
      - `--append-path`: Obtem a informação se o diretório do Windows está no $PATH.
      - `--mount-drive`: Obtem a informação se os discos do HOST estão sendo montados.
      - `--wsl-version`: Obtem a informação de qual a versão do WSL para esta instância.
      - `--default-term`: Obtem a informação de qual o tipo de terminal para esta instância.
      - `--lxguid`: Obtem o WSL GUID dessa instância.

    backup [comando]
      - `--tar`: Cria o arquivo backup.tar no diretório atual.
      - `--reg`: Cria o arquivo de configurações do registro no diretório atual.

    clean
      - Remove a instância.

    help
      - Mostra toda essa lista de argumentos (em inglês).
```


#### Como remover a instância
```dos
>Alpine.exe clean
```

## How-to-Build
AlpineWSL can build on GNU/Linux or WSL.

`curl`,`bsdtar`,`tar`(gnu) and `sudo` is required for build.
```shell
$ make
```

with flags:
```
$ make ARCH=arm64 OUT_ZIP=Alpine_arm64.zip
```

### Basic Params
|  Parameter |  Value  |  Default  |
| ---- | ---- | ---- |
|  ARCH  |  x64/arm64  | x64 |
|  LNCR_EXE  |  launcher file name  | Alpine.exe |
|  OUT_ZIP  |  zip file name  | Alpine.zip |
|  DLR  |  file downloader  | curl |
|  DLR_FLAGS  |  downloader flags  | -L |
|  BASE_URL  |  base rootfs url  | https:~ |
