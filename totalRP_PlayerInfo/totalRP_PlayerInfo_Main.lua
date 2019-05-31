function FicheJoueurOpen(tab,edit)
	FicheJoueurFond:SetTexture("Interface\\Stationery\\Stationery_UC1.blp");
	FicheJoueurFondDroite:SetTexture("Interface\\Stationery\\Stationery_UC2.blp");
	FicheJoueurPanelFiche:Show();
	FicheJoueurRegistreButtonGeneralIcon:SetAlpha(1);
	FicheJoueurRegistreButtonDescriptionIcon:SetAlpha(1);
	FicheJoueurRegistreButtonStatistiquesIcon:SetAlpha(1);
	FicheJoueurOngletFicheIcon:SetAlpha(0.5);
	-- Panels
	FicheJoueurPanelRegistreGeneral:Hide();
	FicheJoueurPanelRegistreGeneralEdition:Hide();
	FicheJoueurPanelRegistreDescription:Hide();
	FicheJoueurPanelRegistreDescriptionEdition:Hide();
	FicheJoueurPanelRegistreStatistiques:Hide();
	FicheJoueurPanelRegistreStatistiquesEdition:Hide();
	-- Onglets
	FicheJoueurRegistreButtonGeneral:Disable();
	FicheJoueurRegistreButtonDescription:Disable();
	FicheJoueurRegistreButtonStatistiques:Disable();
	FicheJoueurOngletFiche:Disable();
	-- Boutons
	FicheJoueurRegistreButtonEdition:Hide();
	FicheJoueurRegistreButtonCharger:Hide();
	FicheJoueurRegistreButtonSauver:Hide();
	FicheJoueurRegistreButtonSauverSous:Hide();
	
	ChargerDonneesJoueur();
	
	if tab==nil or tab==GENERAL_TEXT then
		FicheJoueurRegistreButtonDescription:Enable();
		FicheJoueurRegistreButtonStatistiques:Enable();
		FicheJoueurRegistreButtonGeneralIcon:SetAlpha(0.5);
		if edit then
			FicheJoueurPanelRegistreGeneralEdition:Show();
			FicheJoueurRegistreButtonSauver:Show();
			FicheJoueurRegistreButtonSauverSous:Show();
			FicheJoueurPanelTitle:SetText(EDITPANELGENERAL);
			FicheJoueurNomSaisie:SetFocus();
		else
			FicheJoueurPanelRegistreGeneral:Show();
			FicheJoueurRegistreButtonEdition:Show();
			FicheJoueurRegistreButtonCharger:Show();
			FicheJoueurPanelTitle:SetText(JOUEURPANELGENERAL);
		end
	elseif tab==DESCRIPTIONTEXT then
		FicheJoueurRegistreButtonGeneral:Enable();
		FicheJoueurRegistreButtonStatistiques:Enable();
		FicheJoueurRegistreButtonDescriptionIcon:SetAlpha(0.5);
		if edit then
			FicheJoueurPanelRegistreDescriptionEdition:Show();
			FicheJoueurRegistreButtonSauver:Show();
			FicheJoueurRegistreButtonSauverSous:Show();
			FicheJoueurPanelTitle:SetText(EDITPANELDESCRI);
			DescriActuelleSaisieEdit:SetFocus();
		else
			FicheJoueurPanelRegistreDescription:Show();
			FicheJoueurRegistreButtonEdition:Show();
			FicheJoueurRegistreButtonCharger:Show();
			FicheJoueurPanelTitle:SetText(JOUEURPANELDESCRI);
		end
	elseif tab=="Statistiques" then
		FicheJoueurRegistreButtonDescription:Enable();
		FicheJoueurRegistreButtonGeneral:Enable();
		FicheJoueurRegistreButtonStatistiquesIcon:SetAlpha(0.5);
		if edit then
			FicheJoueurRegistreButtonSauver:Show();
			FicheJoueurRegistreButtonSauverSous:Show();
			FicheJoueurPanelTitle:SetText("Sheet : Caracteristics : Edit");
			FicheJoueurPanelRegistreStatistiquesEdition:Show();
		else
			FicheJoueurRegistreButtonEdition:Show();
			FicheJoueurRegistreButtonCharger:Show();
			FicheJoueurPanelTitle:SetText("Sheet : Caracteristics");
			FicheJoueurPanelRegistreStatistiques:Show();
		end
	end
	
	-- Habillement du joueur
	FicheJoueurModel:SetUnit("player");
	FicheJoueurModel:Undress();
	if ShowingHelm() and GetInventoryItemLink("player", 1) then
		FicheJoueurModel:TryOn(GetInventoryItemLink("player", 1)); 
	end
	slot = 2;
	while slot < 11 do
		if GetInventoryItemLink("player", slot) then 
			FicheJoueurModel:TryOn(GetInventoryItemLink("player", slot)); 
		end
		slot = slot + 1;
	end
	--seqtime = 0;
	--animationPlayed = 67;

end

function IncrementerVerNum()
	TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"] = TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"] + 1;
	if TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"] > 9999 then
		TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"] = 0;
	end
end

function RappelInfos()
	local message;
	message = "|cffffaa00Total RP\n------------------"
			  .."\n|cffffaa00Your current character is : |cff00ff00"..nomComplet(Joueur)
			  .."\n|cffffaa00Your mood : "..humeur_color[TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"]]..HUMEUR_SET[TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"]]
			  .."\n|cffffaa00Your status : "..statut_color[TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"]]..STATUTRPSMALL[TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"]];
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] ~= nil and TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] ~= "" then
		message = message..setTRPColorToString("\n\n{o}Your current description :\n{w}\""..TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"].."{w}\"");
	end
	RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"]);
end

function setMorale(adapt)
	adapt = adapt + TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"];
	if adapt > 1000 then
		adapt = 1000;
	elseif adapt < 0 then
		adapt = 0;
	end
	TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"] = adapt;
end

function setEthique(adapt)
	adapt = adapt + TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"];
	if adapt > 1000 then
		adapt = 1000;
	elseif adapt < 0 then
		adapt = 0;
	end
	TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"] = adapt;
end

function getNameAndColorAlignement(nom,Ethique,Morale)

	if not nom and not Ethique and not Morale then return nil,nil,nil,nil,nil,nil end;

	local vertMorale,rougeMorale,texteMorale,texteEthique,vertEthique,rougeEthique;
	
	if not Ethique and not Morale then
		if nom == Joueur then
			Morale = TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"];
			Ethique = TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"];
		elseif TRP_Module_Registre[Royaume][nom] and TRP_Module_Registre[Royaume][nom]["Morale"] then
			Morale = TRP_Module_Registre[Royaume][nom]["Morale"];
			Ethique = TRP_Module_Registre[Royaume][nom]["Ethique"];
		end
	end
	
	texteMorale = "Neutral";
	texteEthique = "Neutral";
	if Morale == 0 then
		texteMorale = "Unknown";
		vertMorale = 0.5;
		rougeMorale = 0.5;
	elseif Morale >= 500 then
		vertMorale = 1;
		rougeMorale = (500 - (Morale-500))/500;
		if Morale >= 800 then
			texteMorale = "Good";
		elseif Morale >= 600 then
			texteMorale = "Good";
		end
	else
		vertMorale = (Morale/500);
		rougeMorale = 1;
		if Morale <= 200 then
			texteMorale = "Evil";
		elseif Morale <= 400  then
			texteMorale = "Evil";
		end
	end
	if Ethique == 0 then
		texteEthique = "Unknown";
		vertEthique = 0.5;
		rougeEthique = 0.5;
	elseif Ethique >= 500 then
		vertEthique = 1;
		rougeEthique = (500 - (Ethique-500))/500;
		if Ethique >=800 then
			texteEthique = "Lawfull";
		elseif Ethique >= 600 then
			texteEthique = "Lawfull";
		end
	else
		vertEthique = (Ethique/500);
		rougeEthique = 1;
		if Ethique <= 200 then
			texteEthique = "Chaotic";
		elseif Ethique <= 400  then
			texteEthique = "Chaotic";
		end
	end
	
	return texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique;
end

function StatsAlignAdapt()
	local Morale = TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"];
	local Ethique = TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"];
	local texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique = getNameAndColorAlignement(Joueur);
	StatsMoralePointeur:SetPoint("TOP",-93 + ((186/1000)*Morale),-52);
	StatsMorale:SetText("Morality : "..texteMorale);
	StatsMoraleFond:SetTexture(rougeMorale,vertMorale,0,0.5);
	StatsMorale:SetTextColor(rougeMorale,vertMorale,0);
	StatsEthiquePointeur:SetPoint("TOP",-93 + ((186/1000)*Ethique),-92);
	StatsEthique:SetText("Ethics : "..texteEthique);
	StatsEthiqueFond:SetTexture(rougeEthique,vertEthique,0,0.5);
	StatsEthique:SetTextColor(rougeEthique,vertEthique,0);
end

function PopupStatsAlignAdapt()
	local Morale = PopupAlignementMoraleSlider:GetValue();
	local Ethique = PopupAlignementEthiqueSlider:GetValue();
	local texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique = getNameAndColorAlignement(nil,Ethique,Morale);
	PopupAlignementMoraleSliderText:SetText("Morality : "..texteMorale);
	PopupAlignementMoraleSliderText:SetTextColor(rougeMorale,vertMorale,0);
	PopupAlignementEthiqueSliderText:SetText("Ethics : "..texteEthique);
	PopupAlignementEthiqueSliderText:SetTextColor(rougeEthique,vertEthique,0);
end

function EnregistrerDonneesJoueur()
	TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"] = FicheJoueurNomSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] = FicheJoueurPrenomSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"] = FicheJoueurTitreSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"] = FicheJoueurSousTitreSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Age"] = FicheJoueurAgeSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"] = FicheJoueurOrigineSaisie:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"] = FicheJoueurEditTaille:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"] = FicheJoueurEditCorpulence:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"] = FicheJoueurEditSilhouette:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"] = FicheJoueurEditVetements:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"] = FicheJoueurEditQualite:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"] = FicheJoueurEditClasseVisible:GetChecked();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] = DescriActuelleSaisieEdit:GetText();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"] = PopupAlignementMoraleSlider:GetValue();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"] = PopupAlignementEthiqueSlider:GetValue();
	IncrementerVerNum();
	DecoupageDescription(DescriPhysiqueSaisieEdit:GetText());
	SendRSPInformations();
	if UnitName("target") == Joueur then
		changeTarget();
	end
end

function ChargerDonneesJoueur()
	
	--Charger Info Consultation :
	FicheJoueurNomComplet:SetText(nomComplet(Joueur));
	if TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"] ~= "" then
		FicheJoueurSousTitre:SetText("< "..TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"].." >");
	else
		FicheJoueurSousTitre:SetText("");
	end
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] ~= "" then
		FicheJoueurPrenom:SetText("|cffffc300 "..PRENOM.."|cffffffff "..TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"]);
	else
		FicheJoueurPrenom:SetText("|cffffc300 "..PRENOM.."|cffffffff "..Joueur);
	end
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"] ~= "" then
		FicheJoueurNom:SetText("|cffffc300 "..NOM.."|cffffffff "..TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"]);
	else
		FicheJoueurNom:SetText("|cffffc300 "..NOM.."|cff999999 "..INCONNU);
	end
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Age"] ~= "" then
		FicheJoueurAge:SetText("|cffffc300 "..AGE.."|cffffffff "..TRP_Module_PlayerInfo[Royaume][Joueur]["Age"]);
	else
		FicheJoueurAge:SetText("|cffffc300 "..AGE.."|cff999999 "..INCONNU);
	end
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"] ~= "" then
		FicheJoueurOrigine:SetText("|cffffc300 "..NAISSANCE.."|cffffffff "..TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"]);
	else
		FicheJoueurOrigine:SetText("|cffffc300 "..NAISSANCE.."|cff999999 "..INCONNU);
	end
	FicheJoueurTaille:SetText("|cffffc300 "..TAILLE.."|cffffffff "..TAILLE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"]]);
	FicheJoueurCorpulence:SetText("|cffffc300 "..CORPULENCE.."|cffffffff "..CORPULENCE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"]]);
	FicheJoueurSilhouette:SetText("|cffffc300 "..SILHOUETTE.."|cffffffff "..SILHOUETTE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"]]);
	FicheJoueurQualiteVetement:SetText("|cffffc300 "..QUALITEVETEMENT.."|cffffffff "..QUALITEVETEMENT_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"]]);
	FicheJoueurTypeVetement:SetText("|cffffc300 "..TYPEVETEMENT.."|cffffffff "..TYPEVETEMENT_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"]]);
	if TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"] == 1 then
		FicheJoueurClasseApparente:SetText("|cffffc300 "..CLASSEAPPA.."|cffffffff "..OUI);
	else
		FicheJoueurClasseApparente:SetText("|cffffc300 "..CLASSEAPPA.."|cffffffff "..NON);
	end
	FicheJoueurStatutSlider:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"]);
	FicheJoueurHumeurSlider:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"]);
	--Charger Info Edition :
	FicheJoueurNomSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"]);
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] == nil or TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] == "" then
		FicheJoueurPrenomSaisie:SetText(Joueur)
	else
		FicheJoueurPrenomSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"])
	end
	FicheJoueurTitreSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"]);
	FicheJoueurSousTitreSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"]);
	FicheJoueurAgeSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Age"]);
	FicheJoueurOrigineSaisie:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"]);
	
	FicheJoueurEditTaille:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"]);
	FicheJoueurEditCorpulence:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"]);
	FicheJoueurEditSilhouette:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"]);
	FicheJoueurEditVetements:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"]);
	FicheJoueurEditQualite:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"]);
	FicheJoueurEditClasseVisible:SetChecked(TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"])
	
	DescriPhysiqueSaisie:SetText(RecollageDescription(Joueur,true));
	DescriPhysiqueSaisieEdit:SetText(RecollageDescription(Joueur));
	
	DescriActuelleSaisie:SetText(setTRPColorToString(TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"]));
	DescriActuelleSaisieEdit:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"]);
	
	PopupAlignementMoraleSlider:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"]);
	PopupAlignementEthiqueSlider:SetValue(TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"]);
end

function FicheJoueurModel_OnUpdate(elapsed,sequence)

	seqtime = seqtime + (elapsed * 1000);
	FicheJoueurModel:SetSequenceTime(sequence, seqtime);

end

function ChangeHumeur(num)
	seqtime = 0;
	animationPlayed = anim_humeur[num];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"] = num;
	FicheJoueurHumeurSelected:SetText(humeur_color[num]..HUMEUR.." : "..HUMEUR_SET[num]);
end

function ChangeStatutRP(num)
	if not num then return end -- Ptite s�curit� vu que la fonction est appell� par des truc pas net ;)
	TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] = num;
	
	if FicheJoueurPanelFiche:IsVisible() then
		PanelOpen("FicheJoueurOngletFiche");
		seqtime = 0;
		animationPlayed = anim_humeur[num+7];
		FicheJoueurStatut:SetText(statut_color[num]..STATUT.." : "..STATUTRPSMALL[num]);
	end
	if num == 1 then
		sendMessage("{j}You are now playing out of your character {r}(OCC){j}.");
	elseif num == 2 then
		sendMessage("{j}You are now playing your character {v}(IC){j}.");
	end
	
	if UnitName("target") == Joueur then
		changeTarget();
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] then
		SendRSPInformationsSMALL();
	end
end

function changeAbsStatut(bouton)
	if UnitIsAFK("player") then
		SendChatMessage("","AFK");
	elseif UnitIsDND("player") then
		SendChatMessage("","DND");
	else
		if bouton == "LeftButton" then
			SendChatMessage("","AFK");
		else
			SendChatMessage("","DND");
		end
	end
end

function activateRSP()
	if TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] and GetChannelName("xtensionxtooltip2") == 0 then
		JoinChannelByName("xtensionxtooltip2");
	end
end

function SendRSPInformationsSMALL()
	local statutRP = "<CS"..TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"].."><RP3>";
	local channelRSP, channelRSPName = GetChannelName("xtensionxtooltip2");
	SendChatMessage(statutRP, "CHANNEL", GetDefaultLanguage("player"), channelRSP);
end

function SendRSPInformations()
	local soustitre = "<T>"..TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"];
	local nom = "<AN3>"..TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"];
	local prefixe = "<AN1>"..TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"];
	local statutRP = "<CS"..TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"].."><RP3>";
	local channelRSP, channelRSPName = GetChannelName("xtensionxtooltip2");
	
	SendChatMessage(soustitre..nom..prefixe..statutRP, "CHANNEL", GetDefaultLanguage("player"), channelRSP);
	
	local description = "";
	position = 1;
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Description"] and TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][1] and TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][1] ~= "" then
		while TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][position] and TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][position] ~= "" do
			local texte = TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][position];
			SendChatMessage("<D0"..position..">"..string.gsub(texte,"\n","\\l"),"CHANNEL", GetDefaultLanguage("player"), channelRSP);
			position = position + 1;
		end
	end
	SendChatMessage("<D0"..position..">"..string.gsub(PUBRSP,"\n","\\l").."\\eod","CHANNEL", GetDefaultLanguage("player"), channelRSP);
end

function AfficheSavePerso()
	SavePersonnage:Show();
	table.foreach(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"],
	function(personnage)
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Prenom"] then
			if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"] and TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"] ~= "" then
				getglobal("SavePersoSlot"..personnage):SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"]);
			else
				getglobal("SavePersoSlot"..personnage):SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Prenom"]);
			end
		else
			getglobal("SavePersoSlot"..personnage):SetText(personnage.." : Unused")
		end
	end);
end

function AfficheLoadPerso()
	LoadPersonnage:Show();
	table.foreach(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"],
	function(personnage)
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Prenom"] then
			getglobal("LoadPersoSlot"..personnage):Enable();
			if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"] and TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"] ~= "" then
				getglobal("LoadPersoSlot"..personnage):SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Texte"]);
			else
				getglobal("LoadPersoSlot"..personnage):SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][personnage]["Prenom"]);
			end
		else
			getglobal("LoadPersoSlot"..personnage):Disable();
			getglobal("LoadPersoSlot"..personnage):SetText("Unused")
		end
	end);
end

function getInfoSaveNum(num)
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Prenom"] == nil then
		return "Pas de donn\195\169es";
	else
		local message = "|cffff7500"..GENERAL_TEXT;
		message = message.."\n|cff77ff77"..PRENOM.." |cffffffff"..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Titre"].." "..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Prenom"].." "..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Nom"];
		message = message.."\n|cff77ff77"..TITRE.." |cffffffff"..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["SousTitre"];
		message = message.."\n|cff77ff77"..AGE.." |cffffffff"..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Age"];
		message = message.."\n|cff77ff77"..NAISSANCE.." |cffffffff"..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Origine"];
		message = message.."\n|cff77ff77"..ALIGNEMENT.." :\n".."|cffffc300< "..moral_color[ceil(tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Ethique"])/333)]..TEXTE_ETHIQUE[ceil(tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Ethique"])/333)].."|cffffc300 - "..moral_color[ceil(tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Morale"])/333)]..TEXTE_MORALE[ceil(tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Morale"])/333)].."|cffffc300 >";
		message = message.."\n\n|cffff7500"..PHYSIQUE;
		message = message.."\n|cff77ff77"..TAILLE.." |cffffffff"..TAILLE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Taille"]];
		message = message.."\n|cff77ff77"..CORPULENCE.." |cffffffff"..CORPULENCE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Corpulence"]];
		message = message.."\n|cff77ff77"..SILHOUETTE.." |cffffffff"..SILHOUETTE_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Silhouette"]];
		message = message.."\n|cff77ff77"..TYPEVETEMENT.." |cffffffff"..TYPEVETEMENT_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["TypeVetement"]];
		message = message.."\n|cff77ff77"..QUALITEVETEMENT.." |cffffffff"..QUALITEVETEMENT_TEXTE[TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["QualiteVetement"]];
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Actuellement"] ~= nil and TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Actuellement"] ~= "" then
			message = message.."\n\n|cffff7500"..ACTUELLEMENT.." :\n|cffffffff"..decouperText( string.gsub(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Actuellement"],"\n",""),50);
		end
		if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Description"][1] ~= nil then
			local description = string.gsub(TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][num]["Description"][1],"\n","").."...";
			message = message.."\n\n|cffff7500"..DESCRIPTIONTEXT.." :\n|cffffffff"..setTRPColorToString(decouperText(description,50));
		end
		return message;
	end
end

function SavePerso(slot,texte)
	EnregistrerDonneesJoueur();
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Prenom"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["ClasseApparente"] = TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["TypeVetement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Titre"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Nom"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["SousTitre"] = TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Age"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Age"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Origine"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Taille"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Corpulence"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Silhouette"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["QualiteVetement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Morale"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Ethique"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Description"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Description"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Actuellement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"];
	TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Texte"] = texte;
	sendMessage("{j}Character succefully saved !");
	SavePersonnage:Hide();
	if FicheJoueurRegistreButtonGeneral:IsEnabled() ~= 1 then
		PanelOpen("FicheJoueurOngletFiche",GENERAL_TEXT,false)
	elseif FicheJoueurRegistreButtonDescription:IsEnabled() ~= 1 then
		PanelOpen("FicheJoueurOngletFiche",DESCRIPTIONTEXT,false)
	elseif FicheJoueurRegistreButtonStatistiques:IsEnabled() ~= 1 then
		PanelOpen("FicheJoueurOngletFiche","Statistiques",false)
	end
end

function LoadPerso(slot)
	if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot] and TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Prenom"] then
		TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Prenom"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["ClasseApparente"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["TypeVetement"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Titre"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Nom"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["SousTitre"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Age"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Age"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Origine"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Taille"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Corpulence"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Silhouette"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["QualiteVetement"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Morale"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Ethique"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Description"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Description"]
		TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Actuellement"]
		IncrementerVerNum();
		if not TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Texte"] then
			TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Texte"] = TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Prenom"]
		end
		sendMessage("{j}Character Information \""..TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"][slot]["Texte"].."\" succefully loaded !");
		LoadPersonnage:Hide();
		if FicheJoueurPanelFiche:IsVisible() then
			if FicheJoueurRegistreButtonGeneral:IsEnabled() ~= 1 then
				PanelOpen("FicheJoueurOngletFiche",GENERAL_TEXT,false)
			elseif FicheJoueurRegistreButtonDescription:IsEnabled() ~= 1 then
				PanelOpen("FicheJoueurOngletFiche",DESCRIPTIONTEXT,false)
			elseif FicheJoueurRegistreButtonStatistiques:IsEnabled() ~= 1 then
				PanelOpen("FicheJoueurOngletFiche","Statistiques",false)
			end
		end
	else
		sendMessage("{j}Unused character slot.");
	end
end
