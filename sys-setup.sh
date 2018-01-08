# update système
# sudo apt-get remove -y libappstream3
# sudo apt-get update -y

sudo apt-get remove -y libappstream3
sudo apt-get update -y
# sudo apt-get install -y openssh-server
# ssh-keygen -t rsa -b 4096

# changement de la configuration réseau

echo "quelle adresse IP voulez-vous pour cette machine?"
read FUTURE_ADRESSE_IP
echo "quel masque de sous-réseau voulez-vous pour cette machine?"
read FUTUR_MASQUE_SOUS_RESEAU
echo "quelle est l'adresse IP du routeur?"
read ADRESSE_IP_DU_ROUTEUR

sudo rm -f ./nvl-config-reseau
# sudo rm -f ./etc-ntwk-interfaces.bckup
sudo cp -f /etc/network/interfaces ./etc-ntwk-interfaces.bckup
cat /etc/network/interfaces >> ./nvl-config-reseau
echo "auto enp0s3" >> ./nvl-config-reseau
echo "iface enp0s3 inet static" >> ./nvl-config-reseau
echo "         address $FUTURE_ADRESSE_IP" >> ./nvl-config-reseau
echo "         netmask $FUTUR_MASQUE_SOUS_RESEAU" >> ./nvl-config-reseau
echo "         gateway $ADRESSE_IP_DU_ROUTEUR" >> ./nvl-config-reseau
echo "         dns-nameservers 8.8.8.8, 8.8.4.4" >> ./nvl-config-reseau


sudo rm -f /etc/network/interfaces
sudo cp ./nvl-config-reseau /etc/network/interfaces

# installation openssh
sudo apt-get remove -y openssh-server
sudo apt-get install -y openssh-server
clear
echo "ne cherches pas à comprendre, appuies 4 fois (comptes bien 4) sur Entrée pour continuer"
read
ssh-keygen -t rsa -b 4096

clear
echo "Quand tu appuieras sur la touche entrée, la VM va redémarrer, attends qu'elle redémarre, puis continues avec la suite des instructions."
read FIN
sudo reboot -h now
