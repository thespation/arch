#!/bin/bash
# Desenvolvido pelo William Santos
# contato: thespation@gmail.com ou https://github.com/thespation

# Cores (tabela de cores: https://gist.github.com/avelino/3188137)
VERM="\033[1;31m"	#Deixa a saída na cor vermelho
VERD="\033[0;32m"	#Deixa a saída na cor verde
CIAN="\033[0;36m"	#Deixa a saída na cor ciano
NORM="\033[0m"		#Volta para a cor padrão

set -e #Termina, em caso de erro de execução

# Alias de instalação
PAC='sudo pacman -S --needed' 	#Comando de instalação pelo repositório oficial
YAY='yay -S --needed'			#Instalação pelo repositórioda comunidade
NCON='--noconfirm'				#Instalar sem confirmação
GIT='git clone'					#Responsável por clonar o repositório
REPO="https://aur.archlinux.org/yay.git"	#Repositório

# Verificação da distro base
VERI () {
	ID=`lsb_release -i`		#Identifica qual é a distro
	RELEASE=`lsb_release -r`	#Identifica a versão da distro
	if [[ $ID = "Distributor ID:	Arch" ]]; then
		echo -e "${VERD}[*] Sistema suportado, instalação seguirá"
		echo -e "${VERD}[*] $ID" ${NORM}
		ATUALIZAR
	else	
		clear; echo -e "${VERM}[!] Sistema não suportado"
		echo -e "[!] Esse script vou desenvolvido para rodar no Arch\n" ${NORM}
fi
}

# Responsável por atualizar os sistema antes da instalação da base
ATUALIZAR () {
	echo -e "${CIAN}[ ] Atualizar sistema" ${NORM}
		sudo pacman -Syyuu ${NCON}
	echo -e "${VERD}[*] Sistema atualizado com sucesso\n" ${NORM}
	BASE
}

# Responsável por instalar a base bspwm
BASE () {
	echo -e "\n${CIAN}[ ] Instalar base bspwm" ${NORM}
		${PAC} bspwm sxhkd wget curl git rofi dunst feh thunar xfce4-terminal xorg-xsetroot \
		networkmanager xfconf xsettingsd xfce4-power-manager ${NCON}
	echo -e "${VERD}[*] Base bspwm instalada" ${NORM}
	COMP
}

# Responsável por instalar os apps complementares
COMP () {
	echo -e "\n${CIAN}[ ] Instalar Apps complementares" ${NORM}
		${PAC} geany xarchiver zip gzip unrar unzip tar thunar-archive-plugin arandr \
		noto-fonts-emoji gnome-disk-utility catfish baobab meld ${NCON}
	echo -e "${VERD}[*] Apps complementares instalados\n" ${NORM}
	ETAPA1
}

# Habilitar yay
ETAPA1 () {
	echo -e "\n${CIAN}[ ] Habilitar YAY em seu sistema" ${NORM}
		${PAC} base-devel git ${NCONF}
	echo -e "${VERD}[*] Pré requisitos instalados (base-devel e git)\n" ${NORM}

	if [[ -d /tmp/yay ]]; then #Verifica se repositório já foi baixado
		ETAPA2
	else
		echo -e "\n${CIAN}[ ] Baixar repositório ${REPO}" ${NORM}
			cd /tmp/ && ${GIT} ${REPO}
		echo -e "${VERD}[*] Repositório na pasta temporária\n" ${NORM}
		ETAPA2
fi
}

ETAPA2 () {
	echo -e "\n${CIAN}[ ] Iniciar processo de instalação" ${NORM}
		cd /tmp/yay && makepkg -si &&
	echo -e "${VERD}[*] Yay instalado e habilitado para uso\n" ${NORM}

	echo -e "\n${CIAN}[ ] Iniciar processo de atualização" ${NORM}
		yay -Syu ${NCONF}
	echo -e "${VERD}[*] Base YAY Atualizada\n" ${NORM}
	APPSCOMPLE
}

# Responsável por instalar os apps yay
APPSCOMPLE () {
	echo -e "\n${CIAN}[ ] Instalar Apps YAY" ${NORM}
		${YAY} polybar ksuperkey ly xfce-polkit networkmanager-dmenu-git alacritty-git ${NCON} #/usr/lib/xfce-polkit/xfce-polkit
	echo -e "${VERD}[*] Apps YAY instalados\n" ${NORM}
	
	echo -e "\n${CIAN}[ ] Habilitar gestor de login Ly"
		sudo systemctl enable ly
	echo -e "${VERD}[*] Ly habilitado com sucesso/n"
	PERSARCHC
}

# Responsável por acrescentar os temas e ícones do Archcraft
PERSARCHC () {
	curl -s https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/temas.sh | bash
	curl -s https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/icones.sh | bash
	
	#bash < <(curl -s https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/temas.sh)
	#wget -q https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/temas.sh -O -
	#wget -O - https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/temas.sh | bash
	#fonte: https://stackoverflow.com/questions/5735666/execute-bash-script-from-url
	
	echo -e "\n${VERD}[i] Final do script\n"
}

# Iniciar verificação
clear
VERI