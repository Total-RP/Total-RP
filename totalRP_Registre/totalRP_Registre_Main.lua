function RegistreOpen(Panel,Arg0)
	FicheJoueurOngletRegistre:Disable();
	FicheJoueurOngletRegistreIcon:SetAlpha(0.5);
	FicheJoueurFond:SetTexture("Interface\\Stationery\\Stationery_ill1.blp");
	FicheJoueurFondDroite:SetTexture("Interface\\Stationery\\Stationery_ill2.blp");
	RegistreFicheButtonListeEpurerIcon:SetTexture("Interface\\ICONS\\Ability_Rogue_Eviscerate.blp");
	FicheJoueurPanelRegistre:Show();
	
	RegistrePanelConsulte:Hide();
	RegistrePanelListe:Hide();
	
	RegistreSousPanelGeneral:Hide();
	RegistreSousPanelDescription:Hide();
	RegistreFrameModelePerso:Hide();
	
	RegistreFicheButtonPanelListe:Show();
	RegistreFicheButtonPanelGeneral:Hide();
	RegistreFicheButtonPanelDescription:Hide();
	RegistreFicheButtonPanelListe:Enable();
	RegistreFicheButtonPanelGeneral:Enable();
	RegistreFicheButtonPanelDescription:Enable();
	
	FichePersonnageBoutonDelete:Hide();
	FichePersonnageBoutonNotesGen:Hide();
	
	if Panel == nil or Panel == "Liste" then
		RegistrePanelListe:Show();
		RegistreFicheButtonPanelListe:Disable();
		RegistreFicheButtonPanelListeIcon:SetAlpha(0.50);
		ChargerListe();
		FicheJoueurPanelTitle:SetText(LISTE);
	else
		RegistreFichePersonnageNomHidden:SetText(Arg0);
		ShowFicheOf(Arg0);
		RegistrePanelConsulte:Show();
		RegistreFicheButtonPanelGeneral:Show();
		RegistreFicheButtonPanelDescription:Show();
		if Panel == "General" then
			RegistreSousPanelGeneral:Show();
			RegistreFicheButtonPanelGeneral:Disable();
			FichePersonnageBoutonDelete:Show();
			FichePersonnageBoutonNotesGen:Show();
			RegistreFicheModelPerso_StartAnim();
			RegistreFicheButtonPanelGeneralIcon:SetAlpha(0.50);
		elseif Panel == "Description" then
			RegistreSousPanelDescription:Show();
			RegistreFicheButtonPanelDescription:Disable();
			FichePersonnageBoutonDelete:Show();
			FichePersonnageBoutonNotesGen:Show();
			RegistreFicheButtonPanelDescriptionIcon:SetAlpha(0.50);
			RegistreFicheModelPerso_StartAnim();
		end
	end
	
end


function ShowFicheOf(nom)
	if TRP_Module_Registre[Royaume][nom] == nil then
		debugMess("Internal error : ShowFicheOf d'une personne inconnue !")
		return;
	end
	local personnage = TRP_Module_Registre[Royaume][nom];
	local relations = TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur];
	if relations == nil then
		relations = 3;
		TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] = relations;
	end
	
	--Affichage :
	FicheJoueurPanelTitle:SetText(TOOLTIP_FICHE..nom);
	
	-- SOUS TITRE
	if personnage["SousTitre"] and personnage["SousTitre"] ~= "" then
		RegistreFicheSousTitre:SetText("< "..personnage["SousTitre"].." >");
	else
		RegistreFicheSousTitre:SetText("");
	end
	-- IN FORMATION DE BASE
	if personnage["Prenom"] and personnage["Prenom"] ~= "" then
		RegistreFichePrenom:SetText("|cffffc300 "..PRENOM.."|cffffffff "..personnage["Prenom"]);
	else
		RegistreFichePrenom:SetText("|cffffc300 "..PRENOM.."|cffffffff "..nom);
	end
	if personnage["Nom"] and personnage["Nom"] ~= "" then
		RegistreFicheNom:SetText("|cffffc300 "..NOM.."|cffffffff "..personnage["Nom"]);
	else
		RegistreFicheNom:SetText("|cffffc300 "..NOM.."|cff999999 "..INCONNU);
	end
	if personnage["Age"] and personnage["Age"] ~= "" then
		RegistreFicheAge:SetText("|cffffc300 "..AGE.."|cffffffff "..personnage["Age"]);
	else
		RegistreFicheAge:SetText("|cffffc300 "..AGE.."|cff999999 "..INCONNU);
	end
	if personnage["Origine"] and personnage["Origine"] ~= "" then
		RegistreFicheNaissance:SetText("|cffffc300 "..NAISSANCE.."|cffffffff "..personnage["Origine"]);
	else
		RegistreFicheNaissance:SetText("|cffffc300 "..NAISSANCE.."|cff999999 "..INCONNU);
	end
	--INFORMATION PHYSIQUE
	if personnage["Taille"] then
		RegistreFicheTaille:SetText("|cffffc300 "..TAILLE.."|cffffffff "..TAILLE_TEXTE[personnage["Taille"]]);
	else
		RegistreFicheTaille:SetText("|cffffc300 "..TAILLE.."|cff999999 "..INCONNU);
	end
	if personnage["Corpulence"] then
		RegistreFicheCorpulence:SetText("|cffffc300 "..CORPULENCE.."|cffffffff "..CORPULENCE_TEXTE[personnage["Corpulence"]]);
	else
		RegistreFicheCorpulence:SetText("|cffffc300 "..CORPULENCE.."|cff999999 "..INCONNU);
	end
	if personnage["Silhouette"] then
		RegistreFicheSilhouette:SetText("|cffffc300 "..SILHOUETTE.."|cffffffff "..SILHOUETTE_TEXTE[personnage["Silhouette"]]);
	else
		RegistreFicheSilhouette:SetText("|cffffc300 "..SILHOUETTE.."|cff999999 "..INCONNU);
	end
	if personnage["QualiteVetement"] then
		RegistreFicheVetement:SetText("|cffffc300 "..QUALITEVETEMENT.."|cffffffff "..QUALITEVETEMENT_TEXTE[personnage["QualiteVetement"]]);
	else
		RegistreFicheVetement:SetText("|cffffc300 "..QUALITEVETEMENT.."|cff999999 "..INCONNU);
	end
	--DESCRIPTION
	if RecollageDescription(nom,true) == "" and personnage["Actuellement"] == "" then
		RegistreFicheDescriScrollText:SetText(NO_DESCR);
	else
		RegistreFicheDescriScrollText:SetText(DESCACTUAL..setTRPColorToString(personnage["Actuellement"])..DESCPHYS..RecollageDescription(nom,true));
	end
	-- ALIGNEMENT
	RegistreFicheAlignementText:SetFont("Fonts\\ARIALN.TTF",16);
	if TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"] and personnage["Ethique"] ~= nil and personnage["Morale"] ~= nil then
		local texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique = getNameAndColorAlignement(nom);
		RegistreFicheAlignementText:SetText("|cff"..deciToHexa(rougeEthique)..deciToHexa(vertEthique).."00"..texteEthique.."|cffffc300 - ".."|cff"..deciToHexa(rougeMorale)..deciToHexa(vertMorale).."00"..texteMorale);
	else
		RegistreFicheAlignementText:SetText(moral_color[4]..TEXTE_ETHIQUE[4].."|cffffc300 - "..moral_color[4]..TEXTE_MORALE[4]);
	end
	--RELATION
	RegistreFicheRelationSlider:SetValue(relations);
	RegistreFicheNomComplet:SetText(relation_color[relations]..nomComplet(RegistreFichePersonnageNomHidden:GetText()));
	-- NOTES
	RegistreFicheNotesScrollText:SetText(TRP_Module_PlayerInfo_Notes[Royaume][nom]);
	-- FRAMEMODEL
	RegistreFicheModelPerso_StartAnim();
	if personnage["Humeur"] ~= nil then
		RegistreFicheHumeurText:SetText(humeur_color[personnage["Humeur"]]..HUMEUR_SET[personnage["Humeur"]]);
	else
		RegistreFicheHumeurText:SetText(humeur_color[7]..HUMEUR_SET[7]);
	end
	if personnage["StatutRP"] ~= nil then
		RegistreFicheStatutRP:SetText(statut_color[personnage["StatutRP"]]..STATUTRP[personnage["StatutRP"]]);
	else
		RegistreFicheStatutRP:SetText(statut_color[3]..STATUTRP[3]);
	end
	-- ICONE PERSONNALISEE
	RegistreFicheButtonPanelGeneralIcon:SetTexture("Interface\\ICONS\\Ability_Warrior_Revenge.blp");
	if personnage["Race"] ~= nil and personnage["Sex"] ~= nil and personnage["Sex"] >= 2 then
		local textureFinale = "Interface\\ICONS\\Achievement_Character_"..textureRace[personnage["Race"]].."_"..textureSex[personnage["Sex"]]..".blp";
		RegistreFicheButtonPanelGeneralIcon:SetTexture(textureFinale);
	end
	
	if TRP_Module_Configuration["Modules"]["Registre"]["bForceUpdate"] then
		TRPSecureSendAddonMessage("GTI",DonnerInfos(),nom);
	end
end

function RegistreFicheModelPerso_OnUpdate(elapsed,sequence)

	seqtime = seqtime + (elapsed * 1000);
	RegistreFicheModelPerso:SetSequenceTime(sequence, seqtime);

end

function RegistreFicheModelPerso_StartAnim()
	if UnitName("target") == RegistreFichePersonnageNomHidden:GetText() and CheckInteractDistance("target", 4) then
		RegistreFrameModelePerso:Show();
		seqtime = 0;
		animationPlayed = 67;
		RegistreFicheModelPerso:SetUnit("target");
	else
		RegistreFrameModelePerso:Hide();
	end
end

function SetAttributTo(nom,attribut,valeur)
	if nom == nil or TRP_Module_Registre[Royaume][nom] == nil then
		debugMess("Erreur : SetAttributeTo : nom invalide");
		return;
	elseif attribut == nil then
		debugMess("Erreur : SetAttributeTo : attribut nul");
		return;
	elseif  valeur == nil then
		debugMess("Erreur : SetAttributeTo : valeure nulle");
		return;
	end
	
	if attribut == "Relation" then
		TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] = valeur;
	else
		TRP_Module_Registre[Royaume][nom][attribut] = valeur;
	end
end

function GlobaliserRelation()
	local nom = RegistreFichePersonnageNomHidden:GetText();
	local message = string.gsub(GLOBALBASE,"{target}",nom);
	 message = string.gsub(message,"{col}",relation_color[TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur]]);
	  message = string.gsub(message,"{rel}",RELATIONARRAY[TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur]]);
	table.foreach(TRP_Module_PlayerInfo[Royaume],
		function(personnage)
			TRP_Module_PlayerInfo_Relations[Royaume][nom][personnage] = TRP_Module_PlayerInfo_Relations[Royaume][nom][personnage];
			message = message.."- "..personnage.."\n";
		end);
	TRP_ShowStaticPopup("TRP_REG_GLOBAL_RELATION",GLOBALISERRELATION,message);
end

function ChangeSliderValue()
	RegistreFicheRelation:SetText(relation_color[RegistreFicheRelationSlider:GetValue()]..RELATIONTEXT..RELATIONARRAY[RegistreFicheRelationSlider:GetValue()]);
	RegistreFicheNomComplet:SetText(relation_color[RegistreFicheRelationSlider:GetValue()]..nomComplet(RegistreFichePersonnageNomHidden:GetText()));
	-- Icone
	if UnitName("target") == RegistreFichePersonnageNomHidden:GetText() and RegistreFicheRelationSlider:IsVisible() then
		TargetPortraitButton:SetNormalTexture(relation_texture[RegistreFicheRelationSlider:GetValue()])
	end
end

function RecupDescri(descri,nom) -- Appell\195\169 quand on recois la description de quelqu'un
	Numero = tonumber(string.sub(descri,1,1));
	if TRP_Module_Registre[Royaume][nom]["Description"] == nil or Numero == 1 then
		TRP_Module_Registre[Royaume][nom]["Description"] = nil;
		TRP_Module_Registre[Royaume][nom]["Description"] = {};
	end
	TRP_Module_Registre[Royaume][nom]["Description"][Numero] = string.sub(descri,2);
	RegistreFicheDescriScrollText:SetText(RecollageDescription(nom,true));
	if nom == UnitName("target") then
		changeTarget();
	end
end

function RecupRegistre(infos,nom)
	-- Ajouter au registre si il y est pas
	if TRP_Module_Registre[Royaume][nom] == nil then
		AjouterAuRegistre(nom);
	end

	TRP_Module_Registre[Royaume][nom]["Prenom"] = infos[1];
	TRP_Module_Registre[Royaume][nom]["Nom"] = infos[2];
	TRP_Module_Registre[Royaume][nom]["Titre"] = infos[3];
	TRP_Module_Registre[Royaume][nom]["SousTitre"] = infos[4];
	TRP_Module_Registre[Royaume][nom]["Age"] = infos[5];
	TRP_Module_Registre[Royaume][nom]["Origine"] = infos[6];
	TRP_Module_Registre[Royaume][nom]["Taille"] = tonumber(infos[7]);
	TRP_Module_Registre[Royaume][nom]["Corpulence"] = tonumber(infos[8]);
	TRP_Module_Registre[Royaume][nom]["Silhouette"] = tonumber(infos[9]);
	TRP_Module_Registre[Royaume][nom]["QualiteVetement"] = tonumber(infos[10]);
	-- Infos 11 et 12 == ancienne version de l'alignement
	TRP_Module_Registre[Royaume][nom]["Type"] = 1;
	TRP_Module_Registre[Royaume][nom]["VerNum"] = tonumber(infos[13]);
	TRP_Module_Registre[Royaume][nom]["Morale"] = tonumber(infos[14]);
	TRP_Module_Registre[Royaume][nom]["Ethique"] = tonumber(infos[15]);
	if not TRP_Module_Registre[Royaume][nom]["Morale"] then
		TRP_Module_Registre[Royaume][nom]["Morale"] = 0;
	end
	if not TRP_Module_Registre[Royaume][nom]["Ethique"] then
		TRP_Module_Registre[Royaume][nom]["Ethique"] = 0;
	end
	
	
	TRP_Module_Registre[Royaume][nom]["Description"] = {};
	
	if (RegistreFicheButtonPanelGeneral:IsVisible() or RegistreFicheButtonPanelDescription:IsVisible()) and RegistreFichePersonnageNomHidden:GetText() == nom then -- On refresh sa fiche uniquement si elle est actuellement visible
		PanelOpen("FicheJoueurOngletRegistre","General",nom);
	elseif RegistrePanelListe:IsVisible() then -- Si liste visible, on la refresh aussi
		PanelOpen("FicheJoueurOngletRegistre","Liste");
	end -- Si pas, cela veut dire que la personne a été ajoutée automatiquement à la sélection
	if nom == UnitName("target") or nom == UnitName("mouseover") then
		changeTarget();
		MouseOverTooltip(true);
	end
	debugMess(DATAOK..nom..".");
end

function confirmDeletePersonnage(nom)
	TRP_ShowStaticPopup("TRP_REG_DELETE_PERSO",DELETEPERSO.." "..nom,TRP_TEXT_STATIC_POPUP.TRP_REG_DELETE_PERSO..CAREFULL,nom);
end

function deletePersonnage(nom)
	if nom == nil then
		debugMess("Erreur : Suppression NIL");
		return;
	end
	if TRP_Module_Registre[Royaume][nom] ~= nil then
		wipe(TRP_Module_Registre[Royaume][nom]);
		TRP_Module_Registre[Royaume][nom] = nil;
	end
	debugMess("Suppression de "..nom.." r\195\169ussie.");
	if UnitName("target") == nom then
		changeTarget();
	end
	if FicheJoueur:IsVisible() then
		PanelOpen("FicheJoueurOngletRegistre","Liste");
	end
end

function epurerListe()
	table.foreach(TRP_Module_Registre[Royaume],
		function(personnage)
			if not TRP_Module_Registre[Royaume][personnage]["Connu"] then
				wipe(TRP_Module_Registre[Royaume][personnage]);
				TRP_Module_Registre[Royaume][personnage] = nil;
			end
	end);
	ChargerListe();
end

-------------------------------------------------------------------------------
--  TRAITEMENT DE DESCRIPTIONS
-------------------------------------------------------------------------------

function DecoupageDescription(description)
	local ok = true;
	local morceaux = string.reverse(description);
	local i = 1;
	
	TRP_Module_PlayerInfo[Royaume][Joueur]["Description"] = nil;
	TRP_Module_PlayerInfo[Royaume][Joueur]["Description"] = {};
	
	while ok do
		local indice = string.find(morceaux," ",-200);
		
		if string.len(morceaux) < 200 then -- Dernier Morceaux
			TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][i] = string.reverse(morceaux);
			ok = false;
		elseif indice == nil then
			if string.len(morceaux) > 200 then -- Pas d'espace dans les 200 derniers charactères : erreur
				StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..TRPWARNING.."\n\n"..ERROR_DESCR);
				TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
				ok = false;
			end
		else
			TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][i] = string.reverse(string.sub(morceaux,indice));
			i = i + 1;
			morceaux = string.sub(morceaux,1,indice-1);
		end
	end
end

function isBanned(nom)
	if TRP_Module_PlayerInfo_Relations[Royaume][nom] ~= nil and TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] == 1 then
		return true;
	else
		return false;
	end
end

function RecollageDescription(nom,color) -- color true = color, color false = rien, color nil = balises

	DescriptionCollee = ""; -- Renvoie au minimum un string vide.
	if nom == Joueur then
		table.foreach(TRP_Module_PlayerInfo[Royaume][Joueur]["Description"],
		function(DescriptionNum)
			DescriptionCollee = DescriptionCollee..TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][DescriptionNum];
		end);
	else
		if TRP_Module_Registre[Royaume][nom]["Description"] ~= nil then
			table.foreach(TRP_Module_Registre[Royaume][nom]["Description"],
			function(DescriptionNum)
				DescriptionCollee = DescriptionCollee..TRP_Module_Registre[Royaume][nom]["Description"][DescriptionNum];
			end);
		end
	end
	if color == true then -- Pour affichage TRP
		DescriptionCollee = setTRPColorToString(DescriptionCollee);
	elseif color == false then
		DescriptionCollee = setTRPColorToString(DescriptionCollee,true);
	end
	return DescriptionCollee;
end

function EnvoiInfo(cible)
	debugMess(cible..QUERYARSKING);
	result = FormatInformations();
	TRPSecureSendAddonMessage("GVR", result, cible);
	local i = 1;
	while true do
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][i] ~= nil then
			toSend = i..TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][i];
			TRPSecureSendAddonMessage("GVD", toSend, cible);
			i = i+1;
		else
			break;
		end
	end
end

function FormatInformations()
	local info = "";
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"].."|"; -- 25
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"].."|"; -- 25
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"].."|"; -- 25
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"].."|"; -- 50
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Age"].."|"; -- 9
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"].."|"; -- 25
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"].."|"; -- 1
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"].."|"; -- 1
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"].."|"; -- 1
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"].."|"; -- 1
	info = info.."4|4|"; -- Ancienne version de l'alignement, pour éviter les probleme avec ceux qui ont une vieille version -- 2
	info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"].."|"; -- 4

	if TRP_Module_Configuration["Modules"]["Registre"]["bSendAlignement"] then
		info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"].."|"; -- 3
		info = info..TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"].."|"; -- 3
	else
		info = info.."0|0|";
	end
	
	-- 15 élément => 15 
	-- Total actuel = 190
	-- Dispo = 110

	return info;
end

function DonnerInfos()
	-- 1 : Version de TRP : 4
	-- 2 : Version du profil : 4
	-- 3 : Humeur : 1
	-- 4 : StatutRP : 1
	-- 5 : Description actuelle : 230
	-- Total : 244/248
	local demande = "";
	demande = demande..TRP_version.."|";
	demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"].."|";
	demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"].."|";
	demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"].."|";
	demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"];
	return demande;
end

function RecupInfos(infos,sender)
	if not tonumber(infos[1]) then return end
	--[[ Plus nécéssaire vu que TRP 1.106 est la dernière version de TRP 1 :)
	if TRP_Module_Configuration["Modules"]["General"]["bNotifyNewVersion"] and tonumber(TRP_version) < tonumber(infos[1]) and not hasBeenAlerted then
		-- Message de mise à jour
		if not FicheJoueur:IsVisible() then
			PanelOpen("FicheJoueurOngletOptions","General");
		end
		StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..TOTALRP.."\n\n"..NEWVERSION..string.sub(infos[1],1,1).."."..string.sub(infos[1],2,2).." (Build "..infos[1]..")");
		TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
		hasBeenAlerted = true;
	end]]
	
	if TRP_Module_Registre[Royaume][sender] == nil then
		-- Demander Info
		AjouterAuRegistre(sender);
		TRPSecureSendAddonMessage("GTR","",sender);
		changeTarget();
	else
		if TRP_Module_Registre[Royaume][sender]["VerNum"] ~= tonumber(infos[2]) then
			TRPSecureSendAddonMessage("GTR","",sender);
		end
	end
	
	TRP_Module_Registre[Royaume][sender]["Humeur"] = tonumber(infos[3]);
	TRP_Module_Registre[Royaume][sender]["StatutRP"] = tonumber(infos[4]);
	TRP_Module_Registre[Royaume][sender]["Actuellement"] = infos[5];
	
	
	MouseOverTooltip(true);
end

------------------------------------------------------------------
----- PET
------------------------------------------------------------------

function DonnerInfosPet(sender)
	for i=1,GetNumCompanions("CRITTER") do
		local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("CRITTER", i);
		if issummoned then
			if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName] then
				local demande = creatureName.."|";
				demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"].."|";
				demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"].."|";
				demande = demande..tostring(TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["bMount"]);
				TRPSecureSendAddonMessage("GVP",demande,sender);
			end
		end
	end
	local monture = GetActualMountName();
	if monture and TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture] then
		local demande = monture.."|";
		demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Nom"].."|";
		demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Description"].."|";
		demande = demande..tostring(TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["bMount"]);
		TRPSecureSendAddonMessage("GVP",demande,sender);
		return;
	end
	
	local pet = UnitName("pet");
	if pet and TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][pet] then
		local demande = pet.."|";
		demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][pet]["Nom"].."|";
		demande = demande..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][pet]["Description"].."|";
		demande = demande..tostring(TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][pet]["bMount"]);
		TRPSecureSendAddonMessage("GVP",demande,sender);
		return;
	end
end

function RecupInfosPet(tab,sender)
	SavePetInfos(sender,tab[1],tab[2],tab[3],tab[4]);
end

function SavePetInfos(maitre,petName,Nom,Descri,bMount)
	if maitre and petName and Nom and Descri then
		if maitre == Joueur then
			if not TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][petName] then
				TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][petName] = {}
			end
			TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][petName]["Nom"] = Nom;
			TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][petName]["Description"] = Descri;
			TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][petName]["bMount"] = bMount;
		else
			if TRP_Module_Registre[Royaume][maitre] then
				if not TRP_Module_Registre[Royaume][maitre]["Pet"] then
					TRP_Module_Registre[Royaume][maitre]["Pet"] = {};
				end
				if not TRP_Module_Registre[Royaume][maitre]["Pet"][petName] then
					TRP_Module_Registre[Royaume][maitre]["Pet"][petName] = {};
				end
				TRP_Module_Registre[Royaume][maitre]["Pet"][petName]["Nom"] = Nom;
				TRP_Module_Registre[Royaume][maitre]["Pet"][petName]["Description"] = Descri;
				TRP_Module_Registre[Royaume][maitre]["Pet"][petName]["bMount"] = bMount;
				if bMount and bMount == "true" then
					MouseOverTooltip(true);
				end
			end
		end
	end
end

function GetActualMountName()
	for i=1,GetNumCompanions("MOUNT") do
		local creatureID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i);
		if issummoned then
			return creatureName; 
		end
	end
	return nil;
end

function initPetButton()
	for i=1,12 do
		getglobal("CompanionButton"..i):SetScript("OnEnter", function(self) 
			if self.creatureID then
				if ( PetPaperDollFrameCompanionFrame.mode == "CRITTER" ) then
					for i=1,GetNumCompanions("CRITTER") do
						local ID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("CRITTER", i);
						if ID == self.creatureID then
							GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
							GameTooltip:AddLine(setTRPColorToString("{v}"..creatureName));
							GameTooltip:AddLine(setTRPColorToString("{w}Instant"));
							GameTooltip:AddLine(setTRPColorToString("{o}Click to summon your companion."));
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]
							and (TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"] ~= "" or 
							TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"] ~= "") then
								GameTooltip:AddLine(setTRPColorToString(" "));
								GameTooltip:AddLine(setTRPColorToString("{o}Customizing companion :"));
								if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"] ~= "" then
									GameTooltip:AddLine(setTRPColorToString("{w}Name :{v} "..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"]));
								else
									GameTooltip:AddLine(setTRPColorToString("{w}Name :{v} "..creatureName));
								end
								if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"] ~= "" then
									GameTooltip:AddLine(setTRPColorToString("{w}Description :"))
									decouperForTooltip("\""..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"].."\"",35,1,0.75,0);
								end
							end
							GameTooltip:AddLine(setTRPColorToString(" "));
							GameTooltip:AddLine(setTRPColorToString("{v}Ctrl + click to customize the companion"));
							GameTooltip:Show();
						end
					end
				elseif ( PetPaperDollFrameCompanionFrame.mode == "MOUNT" ) then
					for i=1,GetNumCompanions("MOUNT") do
						local ID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i);
						if ID == self.creatureID then
							GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
							GameTooltip:AddLine(setTRPColorToString("{v}"..creatureName));
							GameTooltip:AddLine(setTRPColorToString("{w}Instant"));
							GameTooltip:AddLine(setTRPColorToString("{o}Click to summon your mount."));
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]
							and (TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"] ~= "" or 
							TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"] ~= "") then
								GameTooltip:AddLine(setTRPColorToString(" "));
								GameTooltip:AddLine(setTRPColorToString("{o}Customizing the mount :"));
								if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"] ~= "" then
									GameTooltip:AddLine(setTRPColorToString("{w}Name :{v} "..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Nom"]));
								else
									GameTooltip:AddLine(setTRPColorToString("{w}Name :{v} "..creatureName));
								end
								if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"] ~= "" then
									GameTooltip:AddLine(setTRPColorToString("{w}Description :"))
									decouperForTooltip("\""..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][creatureName]["Description"].."\"",35,1,0.75,0);
								end
							end
							GameTooltip:AddLine(setTRPColorToString(" "));
							GameTooltip:AddLine(setTRPColorToString("{v}Ctrl + click to customize the mount"));
							GameTooltip:Show();
						end
					end
				end
			end
		end);
	end
end

function openPetPage(nom,bMount)
	TRPModifyPetInfo.creatureName = nom;
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nom] then
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nom]["Nom"] then
			TRPModifyPetInfoNomSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nom]["Nom"]);
		else
			TRPModifyPetInfoNomSaisie:SetText(nom);
		end
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nom]["Description"] then
			TRPModifyPetInfoDescriSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nom]["Description"]);
		else
			TRPModifyPetInfoDescriSaisie:SetText("");
		end
	else
		TRPModifyPetInfoNomSaisie:SetText("");
		TRPModifyPetInfoDescriSaisie:SetText("");
	end
	TRPModifyPetInfoNomSaisie:SetFocus();
	if bMount then
		TRPModifyPetInfoNom:SetText("Mount name :");
	else
		TRPModifyPetInfoNom:SetText("Companion name :");
	end
	TRPModifyPetInfoBoutonSave:SetScript("OnClick",function()
		SavePetInfos(Joueur,nom,TRPModifyPetInfoNomSaisie:GetText(),TRPModifyPetInfoDescriSaisie:GetText(),bMount)
		TRPModifyPetInfo:Hide();
	end);
	TRPModifyPetInfo:Show()
end

function CompanionButton_OnModifiedClick(self)
	local id = self.spellID;
	if IsControlKeyDown() then
		if ( PetPaperDollFrameCompanionFrame.mode == "CRITTER" ) then
			for i=1,GetNumCompanions("CRITTER") do
				local ID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("CRITTER", i);
				if id == creatureSpellID then
					openPetPage(creatureName,false);
				end
			end
		elseif ( PetPaperDollFrameCompanionFrame.mode == "MOUNT" ) then
			for i=1,GetNumCompanions("MOUNT") do
				local ID, creatureName, creatureSpellID, icon, issummoned = GetCompanionInfo("MOUNT", i);
				if creatureSpellID == id then
					openPetPage(creatureName,true);
				end
			end
		end
	elseif ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			local spellName = GetSpellInfo(id);
			ChatEdit_InsertLink(spellName);
		else
			local spellLink = GetSpellLink(id)
			ChatEdit_InsertLink(spellLink);
		end
	elseif ( IsModifiedClick("PICKUPACTION") ) then
		CompanionButton_OnDrag(self);
	end
	PetPaperDollFrame_UpdateCompanions();	--Set up the highlights again
end

------------------------------------------------------------------
------------------------------------------------------------------

function AjouterAuRegistre(nom, selected)

	TRP_Module_Registre[Royaume][nom] = {};
	if TRP_Module_PlayerInfo_Relations[Royaume][nom] == nil then
		TRP_Module_PlayerInfo_Relations[Royaume][nom] = {};
	end
	if TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] == nil then
		TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] = 3;
	end
	if TRP_Module_PlayerInfo_Notes[Royaume][nom] == nil then
		TRP_Module_PlayerInfo_Notes[Royaume][nom] = NO_NOTES;
	end
	TRP_Module_Registre[Royaume][nom]["Faction"] = UnitFactionGroup("player");
	if selected then
		GenererNotes(nom);
		local race, raceEn = UnitRace("target");
		TRP_Module_Registre[Royaume][nom]["Race"] = raceEn;
		TRP_Module_Registre[Royaume][nom]["Sex"] = UnitSex("target");
		TRP_Module_Registre[Royaume][nom]["Connu"] = true;
		TRP_Module_Registre[Royaume][nom]["Faction"] = UnitFactionGroup("target");
	end
	TRP_Module_Registre[Royaume][nom]["Description"] = {};
	TRP_Module_Registre[Royaume][nom]["Type"] = 3;
	TRP_Module_Registre[Royaume][nom]["Humeur"] = 7;
	TRP_Module_Registre[Royaume][nom]["VerNum"] = 0;
	TRP_Module_Registre[Royaume][nom]["Actuellement"] = "";
	TRP_Module_Registre[Royaume][nom]["Date"] = date("%d/%m/%y");
	if TRP_Module_Configuration["Modules"]["Registre"]["bNotifyAjout"] then
		sendMessage("{j}".."|Hplayer:"..nom.."|h[|cffaaaaff"..nom.."{j}]|h"..AJOUTREG);
	end
	if nom == UnitName("target") then
		changeTarget();
	end
	if RegistrePanelListe:IsVisible() then
		PanelOpen("FicheJoueurOngletRegistre","Liste");
	end
end

function GenererNotes(nom)
	if UnitName("target") ~= nom then
		StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..GENNOTES.."\n\n"..GENNOTESBAD);
		TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
		return;
	end
	local guilde,grade = GetGuildInfo("target");
	local classe = UnitClass("target");
	local faction = UnitFactionGroup("target");
	local cercle = UnitLevel("target");
	local race = UnitRace("target");
	local genre = UnitSex("target");
	local informations = "----------------------------------------\nInformation :\n----------------------------------------\n";
	
	informations = informations.."- Faction : "..faction.."\n";
	informations = informations.."- Race : "..race.."\n";
	informations = informations.."- Class : "..classe.."\n";
	if guilde == nil or guilde == "" then 
		informations = informations.."- Guild : < Aucune >\n" 
		grade = nil;
	else 
		informations = informations.."- Guild : < "..guilde.." >\n"
		if grade == nil or grade == "" then
			informations = informations.."- Rank : < Aucun >\n";
		else
			informations = informations.."- Rank : < "..grade.." >\n";
		end
	end
	informations = informations.."- Level : "..cercle.."\n";
	if genre == 2 then
		informations = informations.."- Sex : Male\n";
	elseif genre == 3 then
		informations = informations.."- Sex : Female\n";
	end
	informations = informations.."----------------------------------------"; -- Place les info a la fin des notes
	TRP_Module_PlayerInfo_Notes[Royaume][nom] = TRP_Module_PlayerInfo_Notes[Royaume][nom].."\n\n"..informations;
	RegistreFicheNotesScrollText:SetText(TRP_Module_PlayerInfo_Notes[Royaume][nom]);
end

function ChargerListe()
	local i = 0;
	local j = 0;
	local num = ListeTypeSlider:GetValue();
	local numB = ListeTypeBSlider:GetValue();
	
	wipe(PersoTab);
	getTabMember();
	ListeButtonSlider:SetOrientation("VERTICAL");
	ListeButtonSlider:Hide();
	ListeButtonSlider:SetValue(0);
	FicheListeTypeTri:SetText(TRIAGE_SET[num+1]);
	FicheListeTypeBTri:SetText(TRIAGEB_SET[numB+1]);
	table.foreach(TRP_Module_Registre[Royaume],
		function(liste)
			if liste ~= Joueur then
				i = i + 1;
				if TRP_Module_PlayerInfo_Relations[Royaume][liste][Joueur] == nil then
					TRP_Module_PlayerInfo_Relations[Royaume][liste][Joueur] = 3;
				end
				local matching = string.lower(ListeSaisieRecherche:GetText());
				local matchingB = string.lower(nomComplet(liste));
				if string.find(matchingB,matching) or string.find(liste,matching) then
					if num == 0 or TRP_Module_PlayerInfo_Relations[Royaume][liste][Joueur] == num or (TRP_Module_PlayerInfo_Relations[Royaume][liste][Joueur] == nil and num == 3) then -- Check relation
						if numB == 0 or numB == TRP_Module_Registre[Royaume][liste]["Type"] then
							if (ListeConnectedCheck:GetChecked() and TabMember[liste]) or not ListeConnectedCheck:GetChecked() then
								j = j + 1;
								PersoTab[j] = liste;
							end
						end
					end
				end
			end;
		end);
	RegistreFicheNomComplet:SetText(j..LISTETOTAL..i..")");
	RegistreFicheSousTitre:SetText(LISTELEGENDE);
	
	if j > 0 then
		PanelRegistreListeEmpty:SetText("");
	else
		PanelRegistreListeEmpty:SetText(LISTEEMPTYREG);
	end

	if j > 10 then
		ListeButtonSlider:Show();
		local total = floor((j-1)/10);
		ListeButtonSlider:SetMinMaxValues(0,total);
	end
	
	-- Tri de PersoTab[j] 
	table.sort(PersoTab);
	
	ChargerListeVertical(ListeButtonSlider:GetValue());
end

function cacherCroixDeletePerso()
	for k=0,9,1 do --Initialisation
		getglobal("ListeButtonPerso"..k.."Delete"):Hide();
	end
end

function getTabMember()
	local id, name;
	wipe(TabMember);
	for i=1, MAX_CHANNEL_BUTTONS, 1 do
		name = GetChannelDisplayInfo(i);
		if name == "xtensionxtooltip2" then
			id = i;
			break;
		end
	end
	local i=1;
	while GetChannelRosterInfo(id, i) and i < 250 do
		name = GetChannelRosterInfo(id, i);
		TabMember[name] = 1;
		i = i + 1;
	end
end

function ChargerListeVertical(num)
	for k=0,9,1 do --Initialisation
		getglobal("ListeButtonPerso"..k):Hide();
		getglobal("ListeButtonPerso"..k):SetText(FICHE);
		getglobal("ListeButtonPerso"..k.."Text"):Hide();
		getglobal("ListeButtonPerso"..k.."Icon"):Hide();
	end
	cacherCroixDeletePerso();
	
	-- Construction du tableau de nom;
	
	if PersoTab ~= nil then
		local i = 1;
		local j = 0;
		table.foreach(PersoTab,
		function(PersonnageButton)
			if i > num*10 and i <= (num+1)*10 then
				local Nom = PersoTab[PersonnageButton];
				getglobal("ListeButtonPerso"..j):Show();
				getglobal("ListeButtonPerso"..j):SetScript("OnClick", function() PanelOpen("FicheJoueurOngletRegistre","General",Nom) end );
				getglobal("ListeButtonPerso"..j.."Text"):Show();
				getglobal("ListeButtonPerso"..j.."Date"):SetText(TRP_Module_Registre[Royaume][Nom]["Date"]);
				getglobal("ListeButtonPerso"..j.."DeleteNom"):SetText(Nom);
				local NomComplet = relation_color[TRP_Module_PlayerInfo_Relations[Royaume][Nom][Joueur]];
				if TRP_Module_Registre[Royaume][Nom]["Prenom"] and TRP_Module_Registre[Royaume][Nom]["Prenom"] ~= "" then
					NomComplet = NomComplet..TRP_Module_Registre[Royaume][Nom]["Prenom"];
				else
					NomComplet = NomComplet..Nom;
				end
				if TRP_Module_Registre[Royaume][Nom]["Nom"] and TRP_Module_Registre[Royaume][Nom]["Nom"] ~= "" then
					NomComplet = NomComplet.." "..TRP_Module_Registre[Royaume][Nom]["Nom"];
				end
				if TabMember[Nom] then
					local prefixe = "(";
					if TabMember[Nom] then
						prefixe = prefixe.."|TInterface\\BUTTONS\\UI-CheckBox-Check.blp:25:25|t";
					end
					prefixe = prefixe..") ";
					NomComplet = prefixe..NomComplet;
				end
				
				getglobal("ListeButtonPerso"..j.."Text"):SetText(NomComplet);
				if TRP_Module_Registre[Royaume][Nom]["Faction"] == "Alliance" then
					getglobal("ListeButtonPerso"..j.."Icon"):SetTexture("Interface\\BattlefieldFrame\\Battleground-Alliance.blp");
				elseif TRP_Module_Registre[Royaume][Nom]["Faction"] == "Horde" then
					getglobal("ListeButtonPerso"..j.."Icon"):SetTexture("Interface\\BattlefieldFrame\\Battleground-Horde.blp");
				end
				getglobal("ListeButtonPerso"..j.."Icon"):Show();
				j = j + 1;
			end
			i = i + 1;
		end);
	end
end

function nomComplet(nom)

	if nom == nil or nom == "" then
		return "Erreur de Nom";
	end

	local Prenom = nom;
	local NomFamille = "";
	local Titre = "";
	local tableau;

	if nom == Joueur then
		tableau = TRP_Module_PlayerInfo;
	else
		tableau = TRP_Module_Registre;
	end
	if tableau == nil then return "Not loaded yet." end -- Si tentative de nomComplet avant la fin du chargement de l'add-on
	
	if tableau[Royaume][nom]~=nil and tableau[Royaume][nom]["Titre"] ~= nil and tableau[Royaume][nom]["Titre"] ~= "" then
		Titre = tableau[Royaume][nom]["Titre"].." ";
	end
	if tableau[Royaume][nom]~=nil and tableau[Royaume][nom]["Prenom"] ~= nil and tableau[Royaume][nom]["Prenom"] ~= "" then
		Prenom = tableau[Royaume][nom]["Prenom"];
	end
	if tableau[Royaume][nom]~=nil and tableau[Royaume][nom]["Nom"] ~= nil and tableau[Royaume][nom]["Nom"] ~= "" then
		NomFamille = " "..tableau[Royaume][nom]["Nom"];
	end

	return tostring(Titre..Prenom..NomFamille);
end

function DecodeRSP(arg1, arg2) -- R\195\169cup\195\169ration des info de ["xtensionxtooltip2"] . C'est crade comme fonction : normal ca viens de FlagRSP2
	if string.find(arg1,"<") == nil then 
		return;
	end
	if arg2 == Joueur then
		RSPInit = true;
		return;
	end
	-- arg1 = l'information , arg2 = le personnage
	if TRP_Module_Registre[Royaume][arg2] ~= nil then
		if TRP_Module_Registre[Royaume][arg2]["Type"] == 1 or isBanned(nom) then
			return; -- Joueur TRP ou joueur banni !
		else
			TRP_Module_Registre[Royaume][arg2]["Type"] = 2;--Joueur RSP
		end
	end
	
	if string.find(string.sub(arg1,2,string.len(arg1)),"<") ~= nil then 
		firstBrack = string.find(string.sub(arg1,2,string.len(arg1)),"<");
		firstComm = string.sub(arg1,1,firstBrack);
		rest = string.sub(arg1,firstBrack+1, string.len(arg1));
		DecodeRSP(firstComm, arg2);
		DecodeRSP(rest, arg2);
	elseif string.find(string.sub(arg1,2,string.len(arg1)),"<") == nil then 
 		--Sous Titre
		if string.sub(arg1, 1, 3) == "<T>" then
			if string.sub(arg1, 4, string.len(arg1)) ~= "" then 
				if TRP_Module_Registre[Royaume][arg2] == nil then
					AjouterAuRegistre(arg2);
					TRP_Module_Registre[Royaume][arg2]["Nom"] = "";
					TRP_Module_Registre[Royaume][arg2]["Titre"] = "";
					TRP_Module_Registre[Royaume][arg2]["SousTitre"] = "";
					TRP_Module_Registre[Royaume][arg2]["Type"] = 2;
				end
				TRP_Module_Registre[Royaume][arg2]["SousTitre"] = string.sub(arg1, 4, string.len(arg1));
				if arg2 == UnitName("target") then
					changeTarget();
				end
			end
		--Titre et Nom
		elseif string.sub(arg1, 1, 3) == "<AN" then
			local cAN = string.sub(arg1,4,4);
			if cAN == "1" then
				if string.sub(arg1, 6, string.len(arg1)) ~= "" then 
					if TRP_Module_Registre[Royaume][arg2] == nil then
						AjouterAuRegistre(arg2);
						TRP_Module_Registre[Royaume][arg2]["Nom"] = "";
						TRP_Module_Registre[Royaume][arg2]["Titre"] = "";
						TRP_Module_Registre[Royaume][arg2]["SousTitre"] = "";
						TRP_Module_Registre[Royaume][arg2]["Type"] = 2;
					end
					TRP_Module_Registre[Royaume][arg2]["Titre"] = string.sub(arg1, 6, string.len(arg1));
				end
			elseif cAN == "3" then
				if string.sub(arg1, 6, string.len(arg1)) ~= "" then 
					if TRP_Module_Registre[Royaume][arg2] == nil then
						AjouterAuRegistre(arg2);
						TRP_Module_Registre[Royaume][arg2]["Nom"] = "";
						TRP_Module_Registre[Royaume][arg2]["Titre"] = "";
						TRP_Module_Registre[Royaume][arg2]["SousTitre"] = "";
						TRP_Module_Registre[Royaume][arg2]["Type"] = 2;
					end
					TRP_Module_Registre[Royaume][arg2]["Nom"] = string.sub(arg1, 6, string.len(arg1));
					TRPSecureSendAddonMessage("GTI",DonnerInfos(),arg2);
				end
			end
			if arg2 == UnitName("target") then
					changeTarget();
			end
		-- Description
		elseif (string.sub(arg1, 1, 2) == "<D" and tonumber(string.sub(arg1, 3, 4)) ~= nil ) then
			local position = tonumber(string.sub(arg1, 3, 4))
			local descri = string.gsub(string.sub(arg1, 6, string.len(arg1)),"\\l","\n");
			descri = string.gsub(descri,"\\eod","")
			if descri ~= "" then 
				if TRP_Module_Registre[Royaume][arg2] == nil then
					AjouterAuRegistre(arg2);
					TRP_Module_Registre[Royaume][arg2]["Nom"] = "";
					TRP_Module_Registre[Royaume][arg2]["Titre"] = "";
					TRP_Module_Registre[Royaume][arg2]["SousTitre"] = "";
					TRP_Module_Registre[Royaume][arg2]["Type"] = 2;
				end
				local pattern = "%[Ce joueur utilise Total RP!%]"
				if string.find(descri,pattern) ~= nil then
					descri = string.gsub(descri,pattern,"");
					TRP_Module_Registre[Royaume][arg2]["Type"] = 1;
				end
				if TRP_Module_Registre[Royaume][arg2]["Description"] == nil then
					TRP_Module_Registre[Royaume][arg2]["Description"] = {};
				end
				TRP_Module_Registre[Royaume][arg2]["Description"][position] = descri;
			end
			if arg2 == UnitName("target") then
					changeTarget();
			end
		end
	end
end

function Reinit_Personnages()
	for k=1,42,1 do --Initialisation
		getglobal("ListePersonnagesSlot"..k.."ID"):SetText("");
		getglobal("ListePersonnagesSlot"..k.."Royaume"):SetText("");
		getglobal("ListePersonnagesSlot"..k.."Icon"):SetTexture("Interface\\ICONS\\INV_Misc_GroupLooking.blp");
		getglobal("ListePersonnagesSlot"..k):SetButtonState("NORMAL");
		getglobal("ListePersonnagesSlot"..k):Hide();
	end
end

function calculerListePersonnage(selfPerso)
	local recherche = TRPPersonnageListRecherche:GetText();
	local j = 0;
	
	ListePersonnagesSlider:Hide();
	ListePersonnagesSlider:SetValue(0);
	wipe(PersonnageTab);
	TRPListePersonnagesEmpty:Hide();
	
	if TRPListePersonnagesType:GetText() == "2" then
		table.foreach(TRP_Module_PlayerInfo,
		function(royaumes)
			table.foreach(TRP_Module_PlayerInfo[royaumes],
				function(perso)
					if (recherche ~= "" and string.find(string.lower(perso),string.lower(recherche)) ~= nil) or (recherche ~= "" 
						and string.find(string.lower(royaumes),string.lower(recherche)) ~= nil) or recherche == "" then
						if royaumes ~= Royaume or (royaumes == Royaume and perso ~= Joueur) then
							PersonnageTab[j+1] = {};
							PersonnageTab[j+1][1] = perso;
							PersonnageTab[j+1][2] = royaumes;
							j = j+1;
						end
					end
			end);
		end);
	else
		table.foreach(TRP_Module_Registre[Royaume],
		function(perso)
			if (recherche ~= "" and string.find(string.lower(perso),string.lower(recherche)) ~= nil) or recherche == "" then
				PersonnageTab[j+1] = {};
				PersonnageTab[j+1][1] = perso;
				j = j+1;
			end
		end);
	end
	
	--table.sort(PersonnageTab);
	
	if j > 42 then
		local total = floor((j-1)/42);
		ListePersonnagesSlider:Show();
		ListePersonnagesSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListePersonnagesEmpty:Show();
	end
	
	ChargerSliderListePersonnages(0);
end

function ChargerSliderListePersonnages(num)
	Reinit_Personnages();
	if PersonnageTab ~= nil then
		for k=1,42,1 do 
			local i = num*42 + k;
			if PersonnageTab[i] ~= nil then
				getglobal("ListePersonnagesSlot"..k):Show();
				getglobal("ListePersonnagesSlot"..k.."ID"):SetText(PersonnageTab[i][1]);
				if PersonnageTab[i][2] ~= nil then
					getglobal("ListePersonnagesSlot"..k.."Royaume"):SetText(PersonnageTab[i][2]);
					if TRP_Module_PlayerInfo[PersonnageTab[i][2]][PersonnageTab[i][1]]["Race"] ~= nil and TRP_Module_PlayerInfo[PersonnageTab[i][2]][PersonnageTab[i][1]]["Sex"] ~= nil and TRP_Module_PlayerInfo[PersonnageTab[i][2]][PersonnageTab[i][1]]["Sex"] >= 2 then
						local textureFinale = "Interface\\ICONS\\Achievement_Character_"..textureRace[TRP_Module_PlayerInfo[PersonnageTab[i][2]][PersonnageTab[i][1]]["Race"]].."_"..textureSex[TRP_Module_PlayerInfo[PersonnageTab[i][2]][PersonnageTab[i][1]]["Sex"]]..".blp";
						getglobal("ListePersonnagesSlot"..k.."Icon"):SetTexture(textureFinale);
					end
				else
					if TRP_Module_Registre[Royaume][PersonnageTab[i][1]]["Race"] ~= nil and TRP_Module_Registre[Royaume][PersonnageTab[i][1]]["Sex"] ~= nil and TRP_Module_Registre[Royaume][PersonnageTab[i][1]]["Sex"] >= 2 then
						local textureFinale = "Interface\\ICONS\\Achievement_Character_"..textureRace[TRP_Module_Registre[Royaume][PersonnageTab[i][1]]["Race"]].."_"..textureSex[TRP_Module_Registre[Royaume][PersonnageTab[i][1]]["Sex"]]..".blp";
						getglobal("ListePersonnagesSlot"..k.."Icon"):SetTexture(textureFinale);
					end
				end
			end
		end
	end
end