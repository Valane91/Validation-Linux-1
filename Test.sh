var=0
ROUGE='\033[1;31m'
VERT='\033[1;32m'
JAUNE='\033[1;33m'
BLEU='\033[1;34m'
ROSE='\033[1;35m'
CYAN='\033[1;36m'
GRIS='\033[1;37m'
NC='\033[0m'


while [ true ]
do
  echo -e "\t\t\t${CYAN} ------------------------------------------------------------------------${NC}"
  echo -e "\t\t\t${CYAN}|  Menu d'option de l'installation de la vagrante et de la virtual box   |${NC}"
  echo -e "\t\t\t${CYAN} ------------------------------------------------------------------------${NC}"

  echo -e "1. Afficher les vagrant disponibles"
  echo -e "2. Installer une vagrant et une virtual box dans un dossier"
  echo -e "3. Lancer une vagrant dans un dossier ayant déjà une vagrant installée"
  echo -e "4. sortir"
  read option


  if [ $option -eq 1 ]
  then
    echo -e "${BLEU} Affichage des vagrant disponibles ${NC}"
    vagrant global-status
    echo -e "\n"
  elif [ $option -eq 2 ]
  then
    echo -e "${BLEU} Menu d'installation de la vagrant ${NC}"
    echo -e "\n"
    ls
    echo -e "\n"
    echo -e "${CYAN}1ère étape : choisissez un dossier dans lequel installer la vagrant${NC}"
    echo -e "${CYAN}(Si le dossier n'existe pas il sera automatiquement créé)${NC}"
    read nomDuDossier

    if [ ! -d $nomDuDossier ]
    then
       mkdir $nomDuDossier
       echo -e "${ROUGE}Le dossier ${ROSE}\"$nomDuDossier\"${ROUGE} ou mettre la vagrant n'existait pas, donc a été créé${NC}"
    fi

    cd $nomDuDossier

    echo -e "${BLEU}\nListe des dossiers et fichiers disponibles sur \"${ROSE}$nomDuDossier\" :${NC}"
    ls

    echo -e "${CYAN}\n2ème étape : choisissez un dossier dans ${VERT}\"$nomDuDossier\"${CYAN} dans lequel mettre vos data${NC}"
    echo -e "${CYAN}(Si le dossier n'existe pas il sera automatiquement créé)${NC}"
    read data


    if [ ! -d $data ]
    then
      mkdir $data
      echo -e "${ROUGE}Le dossier ${ROSE}\"$data\"${ROUGE} où mettre vos data n'existait pas, donc a été créé${NC}"
    fi

    echo -e "${CYAN}\n3ème étape ! choisissez la PathSyncFolder "
    read pathSyncFolder

    (vagrant init 2> error.sh || echo -e "${ROUGE}ERROR : Il semblerait que la vagrant ait déjà été installée dans ce dossier ${NC}")

    sed -i -e "s/config.vm.box = \"base\"/config.vm.box = \"xenial.box\"/g" Vagrantfile
    sed -i -e "s/# config.vm.network \"private_network\", ip: \"192.168.33.10\"/config.vm.network \"private_network\", ip: \"192.168.33.10\"/g" Vagrantfile
    sed -i -e "s,# config.vm.synced_folder, config.vm.synced_folder ,g" Vagrantfile
    sed -i -e "s,../data,$dossierData, g" Vagrantfile
    sed -i -e "s,/vagrant_data,$pathSyncFolder, g" Vagrantfile

    cd ".."

  elif [ $option -eq 3 ]
  then
    while [ true ]
    do

      echo -e "\n${BLEU} Menu de lancement de la vagrant \n${NC}"

      ls

      echo -e "\n"
      echo -e "1. Choisir un dossier où lancer la Vagrant"
      echo -e "2. Sortir"
      read sousOption
      if [ $sousOption -eq 1 ]
      then
        echo -e "\n${CYAN}Taper le nom du dossier : ${NC}"
        read nomDuDossier

        if [ ! -d $nomDuDossier ]
        then
            echo -e "${ROUGE}ERROR : Ce dossier n'existe pas\n${NC}"
        else
          cd $nomDuDossier

          if [ ! -e "Vagrantfile" ]
          then
            echo -e "${ROUGE}ERROR : Il semblerait que la Vagrant n'ait pas été installée dans ce dossier${NC}/n"
          else
            (vagrant up 2> error.sh || echo "${ROUGE}ERROR : Il semblerait que la vagrant a été mal installé${NC}")
            (vagrant ssh 2> error.sh || echo "")
          fi

          cd ".."
        fi
      elif [ $sousOption -eq 2 ]
      then
        break;
      else
        echo -e "${ROUGE}\nERROR : Ceci n'est pas une commande valide ${NC}"
      fi
    done
  elif [ $option -eq 4 ]
  then
    exit
  else
    echo -e "${ROUGE}\nERROR : Ceci n'est pas une commande valide ${NC}"
  fi
done
