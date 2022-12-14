#!/bin/bash
# Desenvolvido pelo William Santos
# contato: thespation@gmail.com ou https://github.com/thespation

# Cores (tabela de cores: https://gist.github.com/avelino/3188137)
VERM="\033[1;31m"	#Deixa a saída na cor vermelho
VERD="\033[0;32m"	#Deixa a saída na cor verde
CIAN="\033[0;36m"	#Deixa a saída na cor ciano
NORM="\033[0m"		#Volta para a cor padrão

#set -e #Termina, em caso de erro de execução

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
		echo -e "${VERD}[i] Sistema suportado, instalação seguirá"
		echo -e "${VERD}[i] $ID" ${NORM}
		ATUALIZAR
	else	
		clear; echo -e "${VERM}[!] Sistema não suportado"
		echo -e "[!] Esse script foi desenvolvido para rodar no Arch\n" ${NORM}
fi
}

# Responsável por atualizar os sistema antes da instalação da base
ATUALIZAR () {
	echo -e "\n${CIAN}[ ] Atualizar sistema" ${NORM}
		sudo pacman -Syyuu ${NCON}
	echo -e "${VERD}[*] Sistema atualizado com sucesso\n" ${NORM}
	BASE
}

# Responsável por instalar a base bspwm
BASE () {
	echo -e "${CIAN}[ ] Instalar base bspwm" ${NORM}
		${PAC} bspwm sxhkd wget curl git rofi dunst feh thunar xfce4-terminal xorg-xsetroot nano \
		networkmanager xfconf xsettingsd xfce4-power-manager xorg-server xorg-xinit xorg-apps ${NCON}
	echo -e "${VERD}[*] Base bspwm instalada" ${NORM}
	COMP
}

# Responsável por instalar os apps complementares
COMP () {
	echo -e "\n${CIAN}[ ] Instalar Apps complementares" ${NORM}
		${PAC} geany xarchiver zip gzip unrar unzip tar thunar-archive-plugin arandr \
		noto-fonts-emoji gnome-disk-utility catfish baobab meld xdg-user-dirs ${NCON}
	echo -e "${VERD}[*] Apps complementares instalados\n" ${NORM}
	ETAPA1
}

# Habilitar yay
ETAPA1 () {
	echo -e "${CIAN}[ ] Habilitar YAY em seu sistema" ${NORM}
		${PAC} base-devel git ${NCONF}
	echo -e "${VERD}[*] Pré requisitos instalados (base-devel e git)\n" ${NORM}

	if [[ -d /tmp/yay ]]; then #Verifica se repositório já foi baixado
		ETAPA2
	else
	echo -e "${CIAN}[ ] Baixar repositório ${REPO}" ${NORM}
		cd /tmp/ && ${GIT} ${REPO}
	echo -e "${VERD}[*] Repositório na pasta temporária\n" ${NORM}
	ETAPA2
fi
}

ETAPA2 () {
	echo -e "${CIAN}[ ] Iniciar processo de instalação" ${NORM}
		cd /tmp/yay && makepkg -si &&
	echo -e "${VERD}[*] Yay instalado e habilitado para uso\n" ${NORM}

	echo -e "${CIAN}[ ] Iniciar processo de atualização" ${NORM}
		yay -Syu ${NCONF}
	echo -e "${VERD}[*] Base YAY Atualizada\n" ${NORM}
	APPSCOMPLE
}

# Responsável por instalar os apps yay
APPSCOMPLE () {
	echo -e "${CIAN}[ ] Instalar Apps YAY" ${NORM}
		${YAY} polybar ksuperkey ly-git xfce-polkit networkmanager-dmenu-git alacritty-git ${NCON} #/usr/lib/xfce-polkit/xfce-polkit
	echo -e "${VERD}[*] Apps YAY instalados\n" ${NORM}
	
	echo -e "${CIAN}[ ] Habilitar gestor de login Ly"
		sudo systemctl enable ly.service
	echo -e "${VERD}[*] Ly habilitado com sucesso/n"
	PERSONA
}

# Responsável por instalar os apps yay
PERSONA () {
	echo -e "${CIAN}[ ] Iniciar personalizações" ${NORM}
	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	xdg-user-dirs-update
	echo -e "${VERD}[ ] Personalizações concluídas/n" ${NORM}
	PERSARCHC
}

# Responsável por acrescentar os temas e ícones do Archcraft
PERSARCHC () {
	curl -s https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/temas.sh | bash
	curl -s https://raw.githubusercontent.com/thespation/dpux_bspwm/main/scripts/icones.sh | bash
	echo -e "\n${VERD}[i] Final do script\n" ${NORM}
}

# Iniciar verificação
clear
VERI
