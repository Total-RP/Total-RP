function SetTestObjetTooltip()
	local infoTab = {"","","",""};
	local i=0;
	GameTooltip:SetOwner(InventaireSlotTest, "ANCHOR_TOPLEFT");
	GameTooltip:AddLine(CreaObjEditBoxB:GetText(), 1, 1, 1); -- Nom
	if CreaObjCheckBoxA2Edit:GetText() and tonumber(CreaObjCheckBoxA2Edit:GetText()) ~= 0 then
		infoTab[i+1] = STOCKUNIQUE.." ("..CreaObjCheckBoxA2Edit:GetText()..")";
		i = i + 1;
	end
	if tonumber(CreaObjCheckBoxA1Edit:GetText()) > 0 then
		local poids = tonumber(CreaObjCheckBoxA1Edit:GetText());
		if poids < 1000 then
			infoTab[i+1] = POIDSTEXT.." : "..poids.." g";
		else
			infoTab[i+1] = POIDSTEXT.." : "..(poids/1000).." kg";
		end
		i = i + 1;
	end
	if CreaObjCheckBoxA3:GetChecked() and tonumber(CreaObjCheckBoxA3Edit:GetText()) > 1 then
		infoTab[i+1] = "< "..CreaObjCheckBoxA3Edit:GetText().." charge(s) >";
		i = i + 1;
	end
	if CreaObjSliderSousCategorie:GetValue() ~= 1 then
		GameTooltip:AddDoubleLine("< "..TRP_ObjetCategorie[CreaObjSliderCategorie:GetValue()].Nom.." >","< "..TRP_ObjetCategorie[CreaObjSliderCategorie:GetValue()].SousCategorie[CreaObjSliderSousCategorie:GetValue()].." >",1,1,1,1,1,1);
	else
		GameTooltip:AddLine("< "..TRP_ObjetCategorie[CreaObjSliderCategorie:GetValue()].Nom.." >", 1, 1, 1);
	end
	GameTooltip:AddDoubleLine(infoTab[1],infoTab[2],1,1,1,1,1,1);
	GameTooltip:AddDoubleLine(infoTab[3],infoTab[4],1,1,1,1,1,1);

	GameTooltip:AddLine(" ", 1, 1, 1);
	decouperForTooltip(setTRPColorToString("\""..CreaObjEditBoxD:GetText().."\"",true),40,1,0.75,0);
	if CreaObjCheckBoxA3:GetChecked() and CreaObjEditBoxE:GetText() and CreaObjEditBoxE:GetText() ~= "" then
		GameTooltip:AddLine(" ", 1, 1, 1);
		decouperForTooltip( UTILISER.." : "..setTRPColorToString(CreaObjEditBoxE:GetText(),true),40,0,1,0);
	end
	if CreaObjEditBoxF:GetText() and TRP_Module_Documents[CreaObjEditBoxF:GetText()] then
		GameTooltip:AddLine(" ", 1, 1, 1);
		GameTooltip:AddLine(" Associated Document : ", 0, 0.5, 1);
		GameTooltip:AddLine("   |TInterface\\ICONS\\"..TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteIcone"]..".blp:45:45|t", 0, 0.75, 1);
		if TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteTitre"] ~= "" then
			GameTooltip:AddLine("   Title : |cffffffff"..TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteTitre"], 0, 0.75, 1);
		end
		if TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteAuteur"] ~= "" then
			GameTooltip:AddLine("   Author : |cffffffff"..TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteAuteur"], 0, 0.75, 1);
		end
		if TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteDate"] ~= "" then
			GameTooltip:AddLine("   Date : |cffffffff"..TRP_Module_Documents[CreaObjEditBoxF:GetText()]["VignetteDate"], 0, 0.75, 1);
		end
	end
	
	if CreaObjModele.model then
		anchorModeleTo(CreaObjModele.model,FicheJoueur,InventaireSlotTest);
	end

	GameTooltip:Show();
end

function SetObjetPersoTooltip(ID)
	GameTooltip:SetOwner(ObjetPersoSlot1, "ANCHOR_CURSOR");
	local objet = TRP_Module_ObjetsPerso[ID];
	if objet ~= nil then
		GameTooltip:AddLine(objet["Nom"], 1, 1, 1);
		GameTooltip:AddLine(setTRPColorToString("ID : {c}"..ID), 1, 1, 1);
		GameTooltip:AddLine(AUTEUR.." : "..objet["Auteur"], 1, 1, 1);
		GameTooltip:AddLine("   |TInterface\\ICONS\\"..objet["Icone"]..".blp:45:45|t", 0, 0.75, 1);
		decouperForTooltip("\""..setTRPColorToString(objet["Description"].."\"",true),30,1,0.75,0);
		if not objet["Lock"] or objet["Auteur"] == Joueur then
			GameTooltip:AddLine(" ", 1, 1, 1);
			GameTooltip:AddLine("Caracteristics :", 0, 0.6, 1);
			if objet["Poids"] ~= 0 then
				GameTooltip:AddLine("   Weight : |cffffffff"..objet["Poids"].." gram(s)", 0, 0.75, 1);
			end
			if objet["Valeur"] ~= 0 then
				GameTooltip:AddLine("   Value : |cffffffff"..objet["Valeur"].." pieces of gold", 0, 0.75, 1);
			end
			if objet["Unique"] ~= nil then
				GameTooltip:AddLine("   Unique : |cffffffff"..objet["Unique"].." units at max", 0, 0.75, 1);
			end
			if objet["Utilisable"] ~= nil then
				GameTooltip:AddLine("   Utilisation :", 0, 0.6, 1);
				if objet["Utilisable"]["Charges"] ~= 0 then
					GameTooltip:AddLine("      Charge(s) : |cffffffff"..objet["Utilisable"]["Charges"], 0, 0.75, 1);
				else
					GameTooltip:AddLine("      Charge(s) : |cffffffffInfinite", 0, 0.75, 1);
				end
				if objet["Utilisable"]["EmotePrivateOnUse"] ~= nil and objet["Utilisable"]["EmotePrivateOnUse"] ~= "" then
					GameTooltip:AddLine("      On Use message : |cffffaa00\""..string.sub(objet["Utilisable"]["EmotePrivateOnUse"],1,35).."...\"", 0, 0.75, 1);
				end
				if objet["Utilisable"]["EmotePublicOnUse"] ~= nil and objet["Utilisable"]["EmotePublicOnUse"] ~= "" then
					GameTooltip:AddLine("      On Use Emote : |cffffaa00\""..Joueur.." "..string.sub(objet["Utilisable"]["EmotePublicOnUse"],1,35).."...\"", 0, 0.75, 1);
				end
				if objet["Utilisable"]["EmotePrivateOnDeath"] ~= nil and objet["Utilisable"]["EmotePrivateOnDeath"] ~= "" then
					GameTooltip:AddLine("      On Discharge Message : |cffffaa00\""..string.sub(objet["Utilisable"]["EmotePrivateOnDeath"],1,35).."...\"", 0, 0.75, 1);
				end
				if objet["Utilisable"]["EmotePublicOnDeath"] ~= nil and objet["Utilisable"]["EmotePublicOnDeath"] ~= "" then
					GameTooltip:AddLine("      On Discharge Emote : |cffffaa00\""..Joueur.." "..string.sub(objet["Utilisable"]["EmotePublicOnDeath"],1,35).."...\"", 0, 0.75, 1);
				end
			end
		end
		
		GameTooltip:AddLine(" ", 0, 1, 0);
		if objet["Lock"] then
			if objet["Auteur"] == Joueur then
				GameTooltip:AddLine("< You have locked this item >", 1, 0.25, 0.25);
				GameTooltip:AddLine(" ", 0, 1, 0);
				GameTooltip:AddLine(CLICGAUCHE.." : "..EDITEROBJET, 0,1,0);
			else
				GameTooltip:AddLine("< This item has been locked by its creator >", 1, 0.25, 0.25);
				GameTooltip:AddLine(" ", 0, 1, 0);
			end
		else
			GameTooltip:AddLine(CLICGAUCHE.." : "..EDITEROBJET, 0,1,0);
		end
		if not objet["ButinOnly"] or objet["Auteur"] == Joueur then
			GameTooltip:AddLine(CLICGAUCHEMAJ.." : "..AJOUTEROBJET, 1, 0.75,0);
		end
		if UnitName("target") ~= nil and UnitName("target") ~= Joueur 
			and UnitIsPlayer("target") and UnitFactionGroup("target") == UnitFactionGroup("player") then
			GameTooltip:AddLine(CLICGAUCHECTRL.." : "..SENDREF..UnitName("target"),  0.5, 0.5,1);
		end
		
		GameTooltip:AddLine(CLICDROIT.." : "..DELETEOBJET, 1, 0, 0);
	end
	GameTooltip:Show();
end

function DonnerReference(ID)
	if UnitName("target") ~= nil and UnitName("target") ~= Joueur 
	and UnitIsPlayer("target") and UnitFactionGroup("target") == UnitFactionGroup("player") then
		local slot = TRP_Module_ObjetsPerso[ID];
		TRPSecureSendAddonMessage("GRA",ID.."|"..slot["Auteur"].."|"..slot["Nom"].."|"..slot["Icone"],UnitName("target"));
		sendMessage("{o}"..Exchange["ECHANGEREF"]);
	else
		TRPError(ExchangeError["REFCIBLE"]);
	end
end

function ReferenceAskingObjet(objet,sender)
	if string.len(objet[1]) > 16 then return end;
	-- En combat
	if UnitAffectingCombat("player") ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..Joueur..ExchangeError["ISFINGHTING"],sender);
		return;
	end
	-- Occupé
	if ExchangeRefTarget ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..ExchangeError["ALREADYEXCHNAGE"],sender);
		return;
	end
	-- Auto-block ou Banned
	if TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] == 1 or isBanned(sender) then
		TRPSecureSendAddonMessage("SDM",ExchangeError["REFUSAL"]..Joueur..".",sender);
		return;
	end
	
	local ID = objet[1];
	local Auteur = objet[2];
	local Nom = objet[3];
	local Icone = objet[4];

	ExchangeRefTarget = sender;
	
	if ( (not TRP_Module_ObjetsPerso[ID] or (TRP_Module_ObjetsPerso[ID] and TRP_Module_ObjetsPerso[ID]["Auteur"] == Auteur)) and TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] == 3) or TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] == 4 then
		-- Auto accept
		ProceedObjetRefExchange(1,ID,"","","");
	else
		local Message = sender;
		local iconeTex = "|TInterface\\ICONS\\"..Icone..".blp:35:35|t";
		if TRP_Module_ObjetsPerso[ID] then
			if TRP_Module_ObjetsPerso[ID]["Auteur"] == Auteur then -- Même auteur
				if Auteur ~= sender then --L'auteur n'est pas l'envoyeur
					Message = Message..Exchange["REFASKINGD"].."{v}Your version :\n ".."|TInterface\\ICONS\\"..TRP_Module_ObjetsPerso[ID]["Icone"]..".blp:35:35|t".."\n{o}Name : {w}"..TRP_Module_ObjetsPerso[ID]["Nom"].."\n{o}Creator : {w}"..TRP_Module_ObjetsPerso[ID]["Auteur"];
					Message = Message.."\n\n{r}"..sender.."'s version :\n"..iconeTex.."\n{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["REFASKINGBWARNINGB"];
				else -- L'auteur est l'envoyeur
					Message = Message..Exchange["REFASKINGE"]..iconeTex.."\n{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["REFASKINGC"];
				end
			else -- Changement d'auteur !
				Message = Message..Exchange["REFASKINGD"].."{v}Your version :\n ".."|TInterface\\ICONS\\"..TRP_Module_ObjetsPerso[ID]["Icone"]..".blp:35:35|t".."\n{o}Name : {w}"..TRP_Module_ObjetsPerso[ID]["Nom"].."\n{o}Creator : {w}"..TRP_Module_ObjetsPerso[ID]["Auteur"];
				Message = Message.."{r}\n\n"..sender.."'s version :\n"..iconeTex.."\n{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["REFASKINGBWARNING"];
			end
		else -- Pas connaitre
			Message = Message..Exchange["REFASKINGB"]..iconeTex.."\n{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["REFASKINGC"];
		end
		TRPWaitingForInfos = true;
		StaticPopupDialogs["TRP_REF_ASKING"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
		TRP_ShowStaticPopup("TRP_REF_ASKING",nil,nil,ID,Auteur,Nom,Icone);
	end
	
end

function ProceedObjetRefExchange(agree,ID,Auteur,Nom,Icone)
	if agree == 1 then -- Oui
		TRP_Module_ObjetsPerso[ID] = {};
		TRP_Module_ObjetsPerso[ID]["Auteur"] = Auteur;
		TRP_Module_ObjetsPerso[ID]["Nom"] = Nom;
		TRP_Module_ObjetsPerso[ID]["Icone"] = Icone;
		TRP_Module_ObjetsPerso[ID]["Description"] = "";
		TRP_Module_ObjetsPerso[ID]["Type"] = 8;
		TRP_Module_ObjetsPerso[ID]["SousType"] = 1;
		TRP_Module_ObjetsPerso[ID]["Poids"] = 0;
		TRP_Module_ObjetsPerso[ID]["Valeur"] = 0;
		TRPSecureSendAddonMessage("GRS",ID,ExchangeRefTarget);
	else
		TRPSecureSendAddonMessage("SDM",ExchangeError["REFUSAL"]..Joueur..".",ExchangeRefTarget);
	end
	reinitVariableTransfert();
end

function proceedGRS(tableau,sender)
	-- Tableau :
	-- 1 : ID
	local ID = tableau[1];
	local objet = TRP_Module_ObjetsPerso[ID];
	if objet == nil then
		TRPError("Internal error : envoi de donnees : reference inconnue");
		return;
	end
	local message = "";
	-- Etape 1 : description(200)
	TRPSecureSendAddonMessage("GRI",ID.."|".."1|"..objet["Description"],sender);
	-- Etape 2 : Poids(11) - Unique(3) - Categorie(2) - Sous categorie(2) - Valeur(10) - Nom(50) - Icone(50) - Auteur(24) - Model(4)
	message = ID.."|".."2|"..objet["Poids"].."|";
	if objet["Unique"] then
		message = message..objet["Unique"];
	end
	message = message.."|"..objet["Type"].."|"..objet["SousType"].."|"..objet["Valeur"].."|"..tostring(objet["Utilisable"] ~= nil);
	message = message.."|"..objet["Nom"].."|"..objet["Icone"].."|"..objet["Auteur"].."|";
	if objet["3DModel"] then
		message = message..objet["3DModel"].."|";
	end
	TRPSecureSendAddonMessage("GRI",message,sender);
	if objet["Utilisable"] ~= nil then
		-- Etape 3 : charges(3) - tooltip(50) - objetOnUse(16) - objetOnDeath(16) - LierAuDocu(16) - CreateurDocu(24) - Lock(4) - ButinOnly(4) - cooldown(6)
		message = ID.."|".."3|"..objet["Utilisable"]["Charges"].."|"..objet["Utilisable"]["UseTooltip"].."|";
		if objet["Utilisable"]["ObjectOnUse"] then
			message = message..objet["Utilisable"]["ObjectOnUse"];
		end
		message = message.."|";
		if objet["Utilisable"]["ObjectOnDeath"] then
			message = message..objet["Utilisable"]["ObjectOnDeath"];
		end
		message = message.."|";
		if objet["Utilisable"]["LierAuDoc"] then
			message = message..objet["Utilisable"]["LierAuDoc"];
			message = message.."|"..TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["Createur"];
		else
			message = message.."|";
		end
		message = message.."|";
		if objet["Lock"] ~= nil then
			message = message.."true";
		end
		message = message.."|";
		if objet["ButinOnly"] ~= nil then
			message = message.."true";
		end
		message = message.."|";
		if objet["Utilisable"]["Cooldown"] then
			message = message..objet["Utilisable"]["Cooldown"];
		end
		message = message.."|";
		TRPSecureSendAddonMessage("GRI",message,sender);
		if objet["Utilisable"]["EmotePrivateOnUse"] ~= nil and objet["Utilisable"]["EmotePrivateOnUse"] ~= "" then
			-- Etape 4 : Message on Use (200)
			TRPSecureSendAddonMessage("GRI",ID.."|".."4|"..objet["Utilisable"]["EmotePrivateOnUse"],sender);
		end
		if objet["Utilisable"]["EmotePrivateOnDeath"] ~= nil and objet["Utilisable"]["EmotePrivateOnDeath"] ~= "" then
			-- Etape 5 : Message on Death (200)
			TRPSecureSendAddonMessage("GRI",ID.."|".."5|"..objet["Utilisable"]["EmotePrivateOnDeath"],sender);
		end
		-- Etape 6 : Emote use (100) - emote death (100)
		message = ID.."|".."6|"..objet["Utilisable"]["EmotePublicOnUse"].."|"..objet["Utilisable"]["EmotePublicOnDeath"];
		TRPSecureSendAddonMessage("GRI",message,sender);
		-- Etape 7 : sound use (100) - sound death (100)
		message = ID.."|".."7|";
		if objet["Utilisable"]["SoundOnUse"] then
			message = message..objet["Utilisable"]["SoundOnUse"];
		end
		message = message.."|";
		if objet["Utilisable"]["SoundOnDeath"] then
			message = message..objet["Utilisable"]["SoundOnDeath"];
		end
		TRPSecureSendAddonMessage("GRI",message,sender);
		-- Etape 8 : conditions : cible(1) - condiCible(50) - condiUser(50) - Composant(100)
		message = ID.."|".."8|";
		if objet["Utilisable"]["Conditions"] then
			message = message.."1|";
			if objet["Utilisable"]["Conditions"]["User"] then
				message = message..objet["Utilisable"]["Conditions"]["User"];
			end
			message = message.."|";
			if objet["Utilisable"]["Conditions"]["Composants"] then
				message = message..objet["Utilisable"]["Conditions"]["Composants"];
			end
			message = message.."|";
			if objet["Utilisable"]["Conditions"]["Cible"] then
				message = message.."1";
				if objet["Utilisable"]["Conditions"]["Cible"] and objet["Utilisable"]["Conditions"]["Cible"]["Tests"] then
					message = message.."|"..objet["Utilisable"]["Conditions"]["Cible"]["Tests"];
				end
			else
				message = message.."0";
			end
			message = message.."|";
		else
			message = message.."0|";
		end
		TRPSecureSendAddonMessage("GRI",message,sender);
	end
	
	TRPSecureSendAddonMessage("GRI",ID.."|".."10",sender);
	sendMessage("{v}"..Exchange["ECHANGEREFDONE"].." ( Item {w}["..TRP_Module_ObjetsPerso[ID]["Nom"].."]{v} )");
end

function proceedGRI(tableau,sender)
	-- Tableau :
	-- 1 : ID
	-- 2 : etape d'envoi
	-- 3,4,... : informations
	local ID = tableau[1];
	local etape = tableau[2];
	if TRP_Module_ObjetsPerso[ID] == nil then
		TRPError("Internal error : reception de donnees : reference inconnue");
		return;
	end
	
	--debugMess("Etape : "..etape);
	--debugMess(tableau[3]);
	--debugMess(tableau[4]);
	--debugMess(tableau[5]);
	--debugMess(tableau[6]);
	--debugMess(tableau[7]);
	--debugMess(tableau[8]);
	--debugMess(tableau[9]);
	--debugMess(tableau[10]);
	--debugMess(tableau[11]);
	
	if etape == "1" then
		TRP_Module_ObjetsPerso[ID]["Description"] = tableau[3];
	elseif etape == "2" then
		TRP_Module_ObjetsPerso[ID]["Poids"] = tonumber(tableau[3]);
		if tableau[4] and tableau[4] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Unique"] = tonumber(tableau[4]);
		else
			TRP_Module_ObjetsPerso[ID]["Unique"] = nil;
		end
		TRP_Module_ObjetsPerso[ID]["Type"] = tonumber(tableau[5]);
		TRP_Module_ObjetsPerso[ID]["SousType"] = tonumber(tableau[6]);
		TRP_Module_ObjetsPerso[ID]["Valeur"] = tonumber(tableau[7]);
		if tableau[8] == "true" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"] = nil;
			TRP_Module_ObjetsPerso[ID]["Utilisable"] = {};
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnUse"] = "";
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnDeath"] = "";
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnUse"] = "";
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnDeath"] = "";
		elseif tableau[8] == "false" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"] = nil;
		end
		TRP_Module_ObjetsPerso[ID]["Nom"] = tableau[9];
		TRP_Module_ObjetsPerso[ID]["Icone"] = tableau[10];
		TRP_Module_ObjetsPerso[ID]["Auteur"] = tableau[11];
		if tableau[12] and tableau[12] ~= "" then
			TRP_Module_ObjetsPerso[ID]["3DModel"] = tableau[12];
		else
			TRP_Module_ObjetsPerso[ID]["3DModel"] = nil;
		end
	elseif etape == "3" then
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] = tonumber(tableau[3]);
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["UseTooltip"] = tableau[4];
		if tableau[5] ~= nil and tableau[5] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnUse"] = tableau[5];
			if string.len(tableau[5]) == 16 and TRP_Module_ObjetsPerso[tableau[5]] == nil then
				-- Demande de l'objet
				ExchangeRefTarget = sender;
				ProceedObjetRefExchange(1,tableau[5],"","","");
			end
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnUse"] = nil;
		end
		if tableau[6] ~= nil and tableau[6] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnDeath"] = tableau[6];
			if string.len(tableau[6]) == 16 and TRP_Module_ObjetsPerso[tableau[6]] == nil then
				-- Demande de l'objet
				ExchangeRefTarget = sender;
				ProceedObjetRefExchange(1,tableau[6],"","","");
			end
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnDeath"] = nil;
		end
		if tableau[7] ~= nil and tableau[7] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["LierAuDoc"] = tableau[7];
			if TRP_Module_Documents[tableau[7]] == nil then
				ProceedDocument(tableau[7],sender,1,tableau[8]);
			end
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["LierAuDoc"] = nil;
		end
		if tableau[9] ~= nil and tableau[9] == "true" then
			TRP_Module_ObjetsPerso[ID]["Lock"] = true;
		else
			TRP_Module_ObjetsPerso[ID]["Lock"] = nil;
		end
		if tableau[10] ~= nil and tableau[10] == "true" then
			TRP_Module_ObjetsPerso[ID]["ButinOnly"] = true;
		else
			TRP_Module_ObjetsPerso[ID]["ButinOnly"] = nil;
		end
		if tableau[11] and tableau[11] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Cooldown"] = tonumber(tableau[11]);
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Cooldown"] = nil;
		end
	elseif etape == "4" then
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnUse"] = tableau[3];
	elseif etape == "5" then
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnDeath"] = tableau[3];
	elseif etape == "6" then
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnUse"] = tableau[3];
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnDeath"] = tableau[4];
	elseif etape == "7" then
		if tableau[3] ~= nil and tableau[3] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnUse"] = tableau[3];
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnUse"] = nil;
		end
		if tableau[4] ~= nil and tableau[4] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnDeath"] = tableau[4];
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnDeath"] = nil;
		end
	elseif etape == "8" then
		if tableau[3] and tableau[3] == "1" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"] = {};
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"] = nil;
			return;
		end
		if tableau[4] and tableau[4] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"] = tableau[4];
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"]  = nil;
		end
		if tableau[5] and tableau[5] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"] = tableau[5];
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"] = nil;
		end
		if tableau[6] and tableau[6] == "1" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"] = {};
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]  = nil;
			return;
		end
		if tableau[7] and tableau[7] ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"] = tableau[7];
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"] = nil;
		end
	elseif etape == "10" then -- Fin
		if TRPWaitingForInfos then
			TRPWaitingForInfos = nil;
			sendMessage("{v}Item information \""..TRP_Module_ObjetsPerso[ID]["Nom"].."\" succefully received from "..sender..".");
		elseif TRPWaitingForShow then
			TRPWaitingForShow = nil;
			ShowObjetDone(ID,sender);
		end
		refreshInventaire();
	end
end

function createEmptyObjet() --  Celui utilisé par le bouton +
	local ID = GenerateID();
	TRP_Module_ObjetsPerso[ID] = {};
	TRP_Module_ObjetsPerso[ID]["Icone"] = "Ability_Druid_Cower";
	TRP_Module_ObjetsPerso[ID]["Auteur"] = Joueur;
	TRP_Module_ObjetsPerso[ID]["Nom"] = "New item";
	TRP_Module_ObjetsPerso[ID]["Description"] = "Description.";
	TRP_Module_ObjetsPerso[ID]["Type"] = 8;
	TRP_Module_ObjetsPerso[ID]["SousType"] = 1;
	TRP_Module_ObjetsPerso[ID]["Poids"] = 0;
	TRP_Module_ObjetsPerso[ID]["Valeur"] = 0;
	sendMessage("{j}"..NEWOBJETNOTIFY);
	EditObjetPerso(ID);
end

function createEmptyObjetForDocument(IDDocu) --  Objet pré-construit pour être lié à un document
	if not IDDocu or not TRP_Module_Documents[IDDocu] then
		return;
	end
	local ID = GenerateID();
	TRP_Module_ObjetsPerso[ID] = {};
	TRP_Module_ObjetsPerso[ID]["Icone"] = "INV_Scroll_12";
	TRP_Module_ObjetsPerso[ID]["Auteur"] = Joueur;
	TRP_Module_ObjetsPerso[ID]["Nom"] = "New item associated to a document";
	TRP_Module_ObjetsPerso[ID]["Description"] = "Description.";
	TRP_Module_ObjetsPerso[ID]["Type"] = 8;
	TRP_Module_ObjetsPerso[ID]["SousType"] = 1;
	TRP_Module_ObjetsPerso[ID]["Poids"] = 0;
	TRP_Module_ObjetsPerso[ID]["Valeur"] = 0;
	TRP_Module_ObjetsPerso[ID]["Utilisable"] = {};
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] = 0;
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["UseTooltip"] = "Consult the document";
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnUse"] = "";
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnUse"] = "";
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnDeath"] = "";
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnDeath"] = "";
	TRP_Module_ObjetsPerso[ID]["Utilisable"]["LierAuDoc"] = IDDocu;
	sendMessage("{j}"..NEWOBJETNOTIFY);
	EditObjetPerso(ID);
end

function createEmptyObjetWithID(ID) -- Celui utilisé dans l'envoi de référence
	TRP_Module_ObjetsPerso[ID] = {};
	TRP_Module_ObjetsPerso[ID]["Icone"] = "Ability_Druid_Cower";
	TRP_Module_ObjetsPerso[ID]["Auteur"] = Joueur;
	TRP_Module_ObjetsPerso[ID]["Nom"] = "New item";
	TRP_Module_ObjetsPerso[ID]["Description"] = "Description.";
	TRP_Module_ObjetsPerso[ID]["Type"] = 8;
	TRP_Module_ObjetsPerso[ID]["SousType"] = 1;
	TRP_Module_ObjetsPerso[ID]["Poids"] = 0;
	TRP_Module_ObjetsPerso[ID]["Valeur"] = 0;
end

function createEmptyObjetWithOtherID(oID) -- Celui utilisé par la création depuis
	if TRP_Module_ObjetsPerso[oID] ~= nil or TRP_Objects[oID] ~= nil then
		local ID = GenerateID();
		local objet;
		TRP_Module_ObjetsPerso[ID] = {};
		if string.len(oID) == 16 then
			objet = TRP_Module_ObjetsPerso[oID];
		else
			objet = TRP_Objects[oID];
		end
		
		TotalRP_tcopy(TRP_Module_ObjetsPerso[ID], objet)
		TRP_Module_ObjetsPerso[ID]["Auteur"] = Joueur;

		sendMessage("{j}"..NEWOBJETNOTIFY);
		EditObjetPerso(ID);
	else
		TRPError("Internal error : créer référence depuis, oID inconnu.\noID : "..tostring(oID));
	end
	PanelObjetPersoFromHidden:SetText("");
end

function EditObjetPerso(ID)
	if TRP_Module_ObjetsPerso[ID] == nil then
		TRPError("Internal error : edition d'un objet inexistant");
	elseif TRP_Module_ObjetsPerso[ID]["Lock"] and TRP_Module_ObjetsPerso[ID]["Auteur"] ~= Joueur then
		TRPError("Item locked : You have to be the creator in order to edit it.");
	else
		AfficheEditObjetPerso(ID, (TRP_Module_ObjetsPerso[ID]["Auteur"] ~= Joueur));
	end
end

function GenerateID()
	return date("%m%d%y%H%M%S")..math.random(1000,9999);
end

function DeleteObjetPerso(ID)
	if TRP_Module_ObjetsPerso[ID] ~= nil then
		table.foreach(TRP_Module_Inventaire,
		function(royaume)
			table.foreach(TRP_Module_Inventaire[royaume],
			function(joueur)
				table.foreach(TRP_Module_Inventaire[royaume][joueur],
				function(slot)
					if slot ~= "Or" and slot ~= "Sacs" then
						if TRP_Module_Inventaire[royaume][joueur][slot]["ID"] == ID then
							wipe(TRP_Module_Inventaire[royaume][joueur][slot]);
							TRP_Module_Inventaire[royaume][joueur][slot] = nil;
						end
					end;
				end)
			end)
		end);
		wipe(TRP_Module_ObjetsPerso[ID])
		TRP_Module_ObjetsPerso[ID] = nil;
		ShowObjetPerso();
		GameTooltip:Hide();
		sendMessage("{j}"..DELOBJETNOTIFY,1,1,0);
	end
end

function detectError()
	return true;
end

function EnregistrerObjetPerso()
	local ID = tostring(CreaObjEditBoxA:GetText());
	
	if TRP_Module_ObjetsPerso[ID] == nil then
		TRP_Module_ObjetsPerso[ID] = {};
	end
	
	TRP_Module_ObjetsPerso[ID]["Auteur"] = Joueur;
	TRP_Module_ObjetsPerso[ID]["Nom"] = CreaObjEditBoxB:GetText();
	if InventaireSlotTestIcon:SetTexture("Interface\\Icons\\"..CreaObjOptionC:GetText()..".blp") == nil then
		TRP_Module_ObjetsPerso[ID]["Icone"] = "INV_Misc_QuestionMark";
	else
		TRP_Module_ObjetsPerso[ID]["Icone"] = CreaObjOptionC:GetText();
	end
	TRP_Module_ObjetsPerso[ID]["Description"] = CreaObjEditBoxD:GetText();
	TRP_Module_ObjetsPerso[ID]["Type"] = CreaObjSliderCategorie:GetValue();
	TRP_Module_ObjetsPerso[ID]["SousType"] = CreaObjSliderSousCategorie:GetValue();
	TRP_Module_ObjetsPerso[ID]["Poids"] = tonumber(CreaObjCheckBoxA1Edit:GetText());
	if CreaObjCheckBoxA2Edit:GetText() and tonumber(CreaObjCheckBoxA2Edit:GetText()) ~= 0 then --Unique
		TRP_Module_ObjetsPerso[ID]["Unique"] = tonumber(CreaObjCheckBoxA2Edit:GetText());
	else
		TRP_Module_ObjetsPerso[ID]["Unique"] = nil;
	end
	if CreaObjCheckBoxLock:GetChecked() then --Lock
		TRP_Module_ObjetsPerso[ID]["Lock"] = true;
	else
		TRP_Module_ObjetsPerso[ID]["Lock"] = nil;
	end
	
	if CreaObjModele.model then
		TRP_Module_ObjetsPerso[ID]["3DModel"] = CreaObjModele.model;
	else
		TRP_Module_ObjetsPerso[ID]["3DModel"] = nil;
	end
	
	if CreaObjButinOnly:GetChecked() then
		TRP_Module_ObjetsPerso[ID]["ButinOnly"] = true;
	else
		TRP_Module_ObjetsPerso[ID]["ButinOnly"] = nil;
	end
	
	if CreaObjCheckBoxA3:GetChecked() then
		if TRP_Module_ObjetsPerso[ID]["Utilisable"] ~= nil then
			wipe(TRP_Module_ObjetsPerso[ID]["Utilisable"]);
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"] = {};
		end
		if tonumber(CreaObjCheckBoxA3Edit:GetText()) == nil then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] = 0;
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] = tonumber(CreaObjCheckBoxA3Edit:GetText());
		end
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["UseTooltip"] = CreaObjEditBoxE:GetText();
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnUse"] = CreaObjEditBoxG:GetText();
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnUse"] = CreaObjEditBoxH:GetText();
		if CreaObjEditBoxI:GetText() ~= "" and TRP_Module_ObjetsPerso[CreaObjEditBoxI:GetText()] or TRP_Objects[CreaObjEditBoxI:GetText()] then --Check d'existance de l'objet
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnUse"] = CreaObjEditBoxI:GetText();
		end
		if CreaObjBoutonUseCreate.Qte then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnUseQte"] = CreaObjBoutonUseCreate.Qte;
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnUseQte"] = 1;
		end
		if CreaObjBoutonDeathCreate.Qte then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnDeathQte"] = CreaObjBoutonDeathCreate.Qte;
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnDeathQte"] = 1;
		end
		if CreaObjCheckBoxPlaySound:GetChecked() and CreaObjEditBoxJ:GetText() and CreaObjEditBoxJ:GetText() ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnUse"] = CreaObjEditBoxJ:GetText();
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnUse"] = nil;
		end
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePrivateOnDeath"] = CreaObjEditBoxK:GetText();
		TRP_Module_ObjetsPerso[ID]["Utilisable"]["EmotePublicOnDeath"] = CreaObjEditBoxL:GetText();
		if CreaObjEditBoxM:GetText() ~= "" and TRP_Module_ObjetsPerso[CreaObjEditBoxM:GetText()] or TRP_Objects[CreaObjEditBoxM:GetText()]  then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["ObjectOnDeath"] = CreaObjEditBoxM:GetText();
		end
		if CreaObjCheckBoxDeathSound:GetChecked() and CreaObjEditBoxN:GetText() and CreaObjEditBoxN:GetText() ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["SoundOnDeath"] = CreaObjEditBoxN:GetText();
		end
		if CreaObjEditBoxF:GetText() and TRP_Module_Documents[CreaObjEditBoxF:GetText()] then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["LierAuDoc"] = CreaObjEditBoxF:GetText();
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["LierAuDoc"] = nil;
		end
		if CreaObjCheckBoxCooldown:GetChecked() and CreaObjEditBoxCooldown:GetText() and CreaObjEditBoxCooldown:GetText() ~= "" then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Cooldown"] = CreaObjEditBoxCooldown:GetText();
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Cooldown"] = nil;
		end
		if CreaObjCheckBoxConditions:GetChecked() then
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"] = {};
			if CreaObjCheckBoxCiblage:GetChecked() then
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"] = {};
				if CreaObjCheckBoxCiblageCondSupp:GetChecked() and CreaObjEditBoxCiblageCondSupp:GetText() and CreaObjEditBoxCiblageCondSupp:GetText() ~= "" then
					TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"] = CreaObjEditBoxCiblageCondSupp:GetText()
				else
					TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"] = nil;
				end
			else
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"] = nil;
			end
			if CreaObjCheckBoxUserCondSupp:GetChecked() and CreaObjEditBoxUserCondSupp:GetText() and CreaObjEditBoxUserCondSupp:GetText() ~= "" then
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"] = CreaObjEditBoxUserCondSupp:GetText()
			else
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"] = nil;
			end
			if CreaObjCheckBoxInventaire:GetChecked() and CreaObjEditBoxInventaire:GetText() and CreaObjEditBoxInventaire:GetText() ~= "" then
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"] = CreaObjEditBoxInventaire:GetText()
			else
				TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"] = nil;
			end	
		else
			TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"] = nil;
		end
	else
		TRP_Module_ObjetsPerso[ID]["Utilisable"] = nil;
	end
	
	table.foreach(TRP_Module_Inventaire,
		function(royaume)
			table.foreach(TRP_Module_Inventaire[royaume],
			function(joueur)
				local i = 0;
				table.foreach(TRP_Module_Inventaire[royaume][joueur],
				function(slot)
					if slot ~= "Or" and slot ~= "Sacs" then
						if TRP_Module_Inventaire[royaume][joueur][slot]["ID"] == ID then
							if TRP_Module_ObjetsPerso[ID]["Utilisable"] == nil then
								TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] = nil;
							elseif TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] == 0 then
								TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] = 0;
							elseif TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] > 0 then
								if TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] == nil or TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] == 0 or TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] > TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"] then
									TRP_Module_Inventaire[royaume][joueur][slot]["Charges"] = TRP_Module_ObjetsPerso[ID]["Utilisable"]["Charges"];
								end
							end
							i = i + TRP_Module_Inventaire[royaume][joueur][slot]["Qte"];
						end
					end;
				end)
				if TRP_Module_ObjetsPerso[ID]["Unique"] ~= nil and i > TRP_Module_ObjetsPerso[ID]["Unique"] then
					-- Message
					local toDelete = i - TRP_Module_ObjetsPerso[ID]["Unique"];
					sendMessage(setTRPColorToString("{r}Warning :\n{w}You changed the amount max of unit you can carry. {o}Although you actually carry more than that amount.{w}\nIn order to correct that you just lose "..toDelete.." units."));
					table.foreach(TRP_Module_Inventaire[royaume][joueur],
					function(slot)
						if slot ~= "Or" and slot ~= "Sacs" then
							if TRP_Module_Inventaire[royaume][joueur][slot]["ID"] == ID then
								if TRP_Module_Inventaire[royaume][joueur][slot]["Qte"] >= toDelete then
									proceedDeleteObject(slot,toDelete);
									toDelete = 0;
								else
									toDelete = toDelete - TRP_Module_Inventaire[royaume][joueur][slot]["Qte"];
									proceedDeleteObject(slot,TRP_Module_Inventaire[royaume][joueur][slot]["Qte"]);
								end
								if toDelete < 1 then
									return;
								end
							end
						end;
					end)
				end
			end)
		end);
	PanelOpen("FicheJoueurOngletInventaire","InventaireOngletCreation");
end

function CreaObjGoToPanel(panel)
	CreaObjPanelGeneral:Hide();
	CreaObjPanelUtilisationEffet:Hide();
	CreaObjPanelUtilisationCondition:Hide();
	CreaObjPanelButin:Hide();
	CreaObjPanelAdvance:Hide();
	CreaObjBoutonPanelUtilisationEffet:Enable();
	CreaObjBoutonPanelUtilisationCondition:Enable();
	CreaObjBoutonPanelButin:Enable();
	CreaObjBoutonPanelGeneral:Enable();
	CreaObjBoutonPanelAdvance:Enable();
	
	getglobal("CreaObjPanel"..panel):Show();
	getglobal("CreaObjBoutonPanel"..panel):Disable();
	FicheJoueurPanelTitle:SetText(OUTILCREATION.." : "..panel);
end

function AfficheEditObjetPerso(ID,auteur)

	if TRP_Module_ObjetsPerso[ID] == nil then
		TRPError("Internal error : edition d'un objet inexistant");
	end
	
	local objet = TRP_Module_ObjetsPerso[ID];

	InventaireFrame:Hide();
	CreateObjetFrame:Show();
	
	--CreaObjBoutonPanelUtilisationCondition:Hide();
	CreaObjBoutonPanelButin:Hide();
	
	CreaObjGoToPanel("General");
	
	if auteur then
		StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..TRPWARNING.."\n\n"..AVERTIAUTEUR);
		TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
	end
	InventaireSlotTestQte:SetText("");
	CreaObjCheckBoxA3:SetChecked(false);
	CreaObjEditBoxJ:SetText("");
	CreaObjEditBoxI:SetText("");
	CreaObjEditBoxM:SetText("");
	CreaObjEditBoxN:SetText("");
	CreaObjEditBoxF:SetText("");
	CreaObjEditBoxG:SetText("");
	CreaObjEditBoxH:SetText("");
	CreaObjEditBoxK:SetText("");
	CreaObjEditBoxL:SetText("");
	CreaObjEditBoxE:SetText("");
	CreaObjEditBoxCooldown:SetText("");
	CreaObjModele.model = nil;
	CreaObjBoutonUseCreate.Qte = nil;
	CreaObjBoutonDeathCreate.Qte = nil;
	
	CreaObjCheckBoxPlaySound:SetChecked(false);
	CreaObjCheckBoxDeathSound:SetChecked(false);
	CreaObjCheckBoxCooldown:SetChecked(false);
	CreaObjCheckBoxInventaire:SetChecked(false);
	
	CreaObjCheckBoxConditions:SetChecked(false);
	CreaObjCheckBoxCiblage:SetChecked(false);
	CreaObjCheckBoxCiblageCondSupp:SetChecked(false);
	CreaObjCheckBoxUserCondSupp:SetChecked(false);
	CreaObjCheckBoxInventaire:SetChecked(false);
	CreaObjEditBoxUserCondSupp:SetText("");
	CreaObjEditBoxCiblageCondSupp:SetText("");
	CreaObjEditBoxInventaire:SetText("");
	
	CreaObjEditBoxA:SetText(ID);
	CreaObjEditBoxB:SetText(objet["Nom"]);
	CreaObjOptionC:SetText(objet["Icone"]);
	CreaObjEditBoxD:SetText(objet["Description"]);
	CreaObjCheckBoxA1Edit:SetText(objet["Poids"]);
	
	CreaObjOptionDCount:SetText("( "..string.len(CreaObjEditBoxD:GetText()).." / 200 )")
	InventaireSlotTestIcon:SetTexture("Interface\\Icons\\"..CreaObjEditBoxC:GetText()..".blp");
	CreateObjetNumber:SetText(ID);
	
	CreaObjSliderCategorie:SetMinMaxValues(1, #(TRP_ObjetCategorie));
	CreaObjSliderCategorie:SetValue(objet["Type"]);
	CreaObjSliderSousCategorie:SetValue(objet["SousType"]);
	
	CreaObjCheckBoxLock:SetChecked(objet["Lock"]~=nil);
	CreaObjButinOnly:SetChecked(objet["ButinOnly"]~=nil);
	
	if TRP_Module_ObjetsPerso[ID]["3DModel"] then
		CreaObjModele.model = TRP_Module_ObjetsPerso[ID]["3DModel"];
	end
	
	if objet["Unique"] == nil then
		CreaObjCheckBoxA2Edit:SetText("0");
	else
		CreaObjCheckBoxA2Edit:SetText(objet["Unique"]);
	end
	
	if objet["Utilisable"] == nil then
		CreaObjCheckBoxA3:SetChecked(false);
	else
		CreaObjCheckBoxA3:SetChecked(true);
		if objet["Utilisable"]["UseTooltip"] and objet["Utilisable"]["UseTooltip"] ~= "" then
			CreaObjEditBoxE:SetText(objet["Utilisable"]["UseTooltip"]);
		end
		CreaObjCheckBoxA3Edit:SetText(objet["Utilisable"]["Charges"]);
		
		CreaObjEditBoxG:SetText(tostring(objet["Utilisable"]["EmotePrivateOnUse"]));
		CreaObjEditBoxH:SetText(tostring(objet["Utilisable"]["EmotePublicOnUse"]));
		CreaObjEditBoxK:SetText(tostring(objet["Utilisable"]["EmotePrivateOnDeath"]));
		CreaObjEditBoxL:SetText(tostring(objet["Utilisable"]["EmotePublicOnDeath"]));
		
		CreaObjCheckBoxPlaySound:SetChecked(objet["Utilisable"]["SoundOnUse"]~=nil);
		CreaObjCheckBoxDeathSound:SetChecked(objet["Utilisable"]["SoundOnDeath"]~=nil);
		
		if objet["Utilisable"]["ObjectOnUse"] then
			CreaObjEditBoxI:SetText(objet["Utilisable"]["ObjectOnUse"]);
		end
		if objet["Utilisable"]["ObjectOnUseQte"] then
			CreaObjBoutonUseCreate.Qte = objet["Utilisable"]["ObjectOnUseQte"];
		end
		if objet["Utilisable"]["ObjectOnDeathQte"] then
			CreaObjBoutonDeathCreate.Qte = objet["Utilisable"]["ObjectOnDeathQte"];
		end
		if objet["Utilisable"]["SoundOnUse"] then
			CreaObjEditBoxJ:SetText(objet["Utilisable"]["SoundOnUse"]);
		end
		if objet["Utilisable"]["ObjectOnDeath"] then
			CreaObjEditBoxM:SetText(objet["Utilisable"]["ObjectOnDeath"]);
		end
		if objet["Utilisable"]["SoundOnDeath"] then
			CreaObjEditBoxN:SetText(objet["Utilisable"]["SoundOnDeath"]);
		end
		if objet["Utilisable"]["LierAuDoc"] then
			CreaObjEditBoxF:SetText(objet["Utilisable"]["LierAuDoc"]);
		end
		if objet["Utilisable"]["Cooldown"] then
			CreaObjEditBoxCooldown:SetText(objet["Utilisable"]["Cooldown"]);
			CreaObjCheckBoxCooldown:SetChecked(true);
		end
		if objet["Utilisable"]["Conditions"] then
			CreaObjCheckBoxConditions:SetChecked(true);
			if TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"] then
				CreaObjCheckBoxCiblage:SetChecked(true);
				if TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"] then
					CreaObjCheckBoxCiblageCondSupp:SetChecked(true);
					CreaObjEditBoxCiblageCondSupp:SetText(TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Cible"]["Tests"]);
				end
			end
			if TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"] then
				CreaObjCheckBoxUserCondSupp:SetChecked(true);
				CreaObjEditBoxUserCondSupp:SetText(TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["User"]);
			end
			if TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"] then
				CreaObjCheckBoxInventaire:SetChecked(true);
				CreaObjEditBoxInventaire:SetText(TRP_Module_ObjetsPerso[ID]["Utilisable"]["Conditions"]["Composants"]);
			end
		end
	end
	CreaObjEditBoxA:SetFocus();
end

function ShowObjetPerso()
	InventaireFrame:Show();
	MainInventaireFrame:Hide();
	ObjetPersoFrame:Show();
	PanelObjetPersoSlider:Hide();
	PanelObjetPersoSlider:SetValue(0);
	ObjetPersoEmpty:Hide();
	
	wipe(ObjPersoTab);
	
	local i = 0;
	table.foreach(TRP_Module_ObjetsPerso,
	function(ID)
	
		if PanelObjetPersoSliderCategorie:GetValue() == 0 or PanelObjetPersoSliderCategorie:GetValue() == TRP_Module_ObjetsPerso[ID]["Type"] then
			if PanelObjetPersoSliderSousCategorie:GetValue() == 0 or PanelObjetPersoSliderSousCategorie:GetValue() == TRP_Module_ObjetsPerso[ID]["SousType"] then
				if PanelObjetPersoListeRecherche:GetText() == "" or string.find(string.lower(TRP_Module_ObjetsPerso[ID]["Nom"]),string.lower(PanelObjetPersoListeRecherche:GetText())) ~= nil then
					ObjPersoTab[i+1] = ID;
					i = i+1;
				end
			end
		end
		
	end);
	
	if i > 42 then
		local total = floor((i-1)/42);
		PanelObjetPersoSlider:SetMinMaxValues(0,total);
		PanelObjetPersoSlider:Show();
	elseif i == 0 then
		ObjetPersoEmpty:Show();
	end
	
	triageObjetPersoList();
	
	ChargerSliderObjetPersoVertical(PanelObjetPersoSlider:GetValue());

end

function triageObjetPersoList()
	
end

function ChargerSliderObjetPersoVertical(num)
	
	Reinit_inventairePerso();
	
	if ObjPersoTab then
		local i = 1;
		local j = 1;
		table.foreach(ObjPersoTab,
		function(index)
			if i > num*42 and i <= (num+1)*42 then
				local ID = ObjPersoTab[index];
				getglobal("ObjetPersoSlot"..j):Show();
				getglobal("ObjetPersoSlot"..j.."Icon"):SetTexture("Interface\\ICONS\\"..TRP_Module_ObjetsPerso[ID]["Icone"]..".blp");
				if TRP_Module_ObjetsPerso[ID]["Auteur"] == Joueur then
					getglobal("ObjetPersoSlot"..j.."Icon"):SetVertexColor(0,1,0);
				elseif TRP_Module_ObjetsPerso[ID]["ButinOnly"] then
					getglobal("ObjetPersoSlot"..j.."Icon"):SetVertexColor(1,0,0);
				else
					getglobal("ObjetPersoSlot"..j.."Icon"):SetVertexColor(1,1,1);
				end
				if TRP_Module_ObjetsPerso[ID]["Lock"] then
					getglobal("ObjetPersoSlot"..j.."Lock"):SetText("|TInterface\\BUTTONS\\UI-GroupLoot-Pass-Up.blp:20:20|t");
					if TRP_Module_ObjetsPerso[ID]["Auteur"] ~= Joueur then
						getglobal("ObjetPersoSlot"..j.."Icon"):SetDesaturated(true);
					else
						getglobal("ObjetPersoSlot"..j.."Icon"):SetDesaturated(false);
					end
				else
					getglobal("ObjetPersoSlot"..j.."Lock"):SetText("");
					getglobal("ObjetPersoSlot"..j.."Icon"):SetDesaturated(false);
				end
				getglobal("ObjetPersoSlot"..j):SetScript("OnClick", 
					function(self,button,down)
						if button == "LeftButton" then
							if IsControlKeyDown() and TRP_Module_ObjetsPerso[ID] ~= nil then
								DonnerReference(ID);
							elseif IsShiftKeyDown() and TRP_Module_ObjetsPerso[ID] ~= nil then
								if not TRP_Module_ObjetsPerso[ID]["ButinOnly"] or TRP_Module_ObjetsPerso[ID]["Auteur"] == Joueur then
									local message = "{v}["..TRP_Module_ObjetsPerso[ID]["Nom"].."]{w}\n";
									StaticPopupDialogs["TRP_INV_AJOUT_OBJ_PERSO"].text = setTRPColorToString(TRP_ENTETE.." \n "..message.."\nQuantity to add to your backpack ?");
									TRP_ShowStaticPopup("TRP_INV_AJOUT_OBJ_PERSO",nil,nil,ID,nil,nil,nil,true,1);
								else
									TRPError("You can't add yourself this item to your backpack");
								end
							else
								EditObjetPerso(ID);
							end
						elseif button == "RightButton" then
							if TRP_Module_ObjetsPerso[ID] ~= nil then
								StaticPopupDialogs["TRP_INV_DELETE_REF"].text = setTRPColorToString(TRP_ENTETE.." \n "..DELETEREF.."\n\n"..CONFIRMSUPPREF);
								TRP_ShowStaticPopup("TRP_INV_DELETE_REF",nil,nil,ID);
							end
						end
				end );
				getglobal("ObjetPersoSlot"..j):SetScript("OnEnter", 
					function()
						SetObjetPersoTooltip(ID);
				end );

				j = j + 1;
			end
			i = i + 1;
		end);
	end
end

function Reinit_inventairePerso()
	local i = 1;
	while i <= 42 do
		getglobal("ObjetPersoSlot"..i):Hide();
		i = i + 1;
	end
end

function Reinit_objets()
	for k=1,42,1 do --Initialisation
		getglobal("ListeObjetsSlot"..k.."ID"):SetText("");
		getglobal("ListeObjetsSlot"..k.."Icon"):SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled.blp");
		getglobal("ListeObjetsSlot"..k):SetButtonState("NORMAL");
		getglobal("ListeObjetsSlot"..k):Hide();
	end
end

function calculerListeObjet()
	local recherche = TRPObjetListRecherche:GetText();
	local j = 0;
	
	ListeObjetsSlider:Hide();
	ListeObjetsSlider:SetValue(0);
	wipe(ObjetTab);
	TRPListeObjetsEmpty:Hide();
	
	--[[
	table.foreach(TRP_Objects,
	function(ID)
		if (recherche ~= "" and string.find(string.lower(TRP_Objects[ID]["Nom"]),string.lower(recherche)) ~= nil) or recherche == "" then
			if not TRP_Objects[ID]["Lock"] then
				ObjetTab[j+1] = ID;
				j = j+1;
			end
		end
	end);
	]]
	table.foreach(TRP_Module_ObjetsPerso,
	function(ID)
		if (recherche ~= "" and string.find(string.lower(TRP_Module_ObjetsPerso[ID]["Nom"]),string.lower(recherche)) ~= nil) or recherche == "" then
			if not TRP_Module_ObjetsPerso[ID]["Lock"] or TRP_Module_ObjetsPerso[ID]["Auteur"] == Joueur then
				ObjetTab[j+1] = ID;
				j = j+1;
			end
		end
	end);
	
	table.sort(ObjetTab);
	
	if j > 42 then
		local total = floor((j-1)/42);
		ListeObjetsSlider:Show();
		ListeObjetsSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListeObjetsEmpty:Show();
	end
	
	ChargerSliderListeObjets(0);
end

function ChargerSliderListeObjets(num)
	Reinit_objets();
	
	if ObjetTab ~= nil then
		for k=1,42,1 do 
			local i = num*42 + k;
			if ObjetTab[i] ~= nil then
				getglobal("ListeObjetsSlot"..k):Show();
				getglobal("ListeObjetsSlot"..k.."ID"):SetText(ObjetTab[i]);
				if string.len(ObjetTab[i]) == 16 then
					getglobal("ListeObjetsSlot"..k.."Icon"):SetTexture("Interface\\Icons\\"..TRP_Module_ObjetsPerso[ObjetTab[i]]["Icone"]..".blp");
				else
					getglobal("ListeObjetsSlot"..k.."Icon"):SetTexture("Interface\\Icons\\"..TRP_Objects[ObjetTab[i]]["Icone"]..".blp");
				end
			end
		end
	end
end

function Reinit_Sound()
	for k=1,42,1 do --Initialisation
		getglobal("ListeSoundSlot"..k.."Url"):SetText("");
		getglobal("ListeSoundSlot"..k.."Nom"):SetText("");
		getglobal("ListeSoundSlot"..k.."Categorie"):SetText("");
		getglobal("ListeSoundSlot"..k.."Icon"):SetTexture("Interface\\ICONS\\INV_Misc_GroupLooking.blp");
		getglobal("ListeSoundSlot"..k):SetButtonState("NORMAL");
		getglobal("ListeSoundSlot"..k):Hide();
	end
end

function calculerListeSound()
	local recherche = TRPSoundListRecherche:GetText();
	local j = 0;
	
	ListeSoundSlider:Hide();
	ListeSoundSlider:SetValue(0);
	wipe(SoundTab);
	TRPListeSoundEmpty:Hide();
	

	table.foreach(TRP_LISTE_SOUNDS,
	function(nom)
		if (recherche ~= "" and string.find(string.lower(nom),string.lower(recherche)) ~= nil) or (recherche ~= "" 
			and string.find(string.lower(TRP_LISTE_SOUNDS[nom]["Categorie"]),string.lower(recherche)) ~= nil) or recherche == "" then
			SoundTab[j+1] = nom;
			j = j+1;
		end
	end);
	
	table.sort(SoundTab);
	
	if j > 42 then
		local total = floor((j-1)/42);
		ListeSoundSlider:Show();
		ListeSoundSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListeSoundEmpty:Show();
	end
	
	ChargerSliderListeSound(0);
end

function ChargerSliderListeSound(num)
	Reinit_Sound();
	if SoundTab ~= nil then
		for k=1,42,1 do 
			local i = num*42 + k;
			if SoundTab[i] ~= nil then
				local nom = SoundTab[i];
				getglobal("ListeSoundSlot"..k):Show();
				getglobal("ListeSoundSlot"..k.."Url"):SetText(TRP_LISTE_SOUNDS[nom]["Url"]);
				getglobal("ListeSoundSlot"..k.."Categorie"):SetText(TRP_LISTE_SOUNDS[nom]["Categorie"]);
				getglobal("ListeSoundSlot"..k.."Nom"):SetText(nom);
				if TRP_LISTE_SOUNDS_ICON[TRP_LISTE_SOUNDS[nom]["Categorie"]] then
					getglobal("ListeSoundSlot"..k.."Icon"):SetTexture(TRP_LISTE_SOUNDS_ICON[TRP_LISTE_SOUNDS[nom]["Categorie"]]);
				end
			end
		end
	end
end

--------------------

function Reinit_PlaySound()
	for k=1,49,1 do --Initialisation
		getglobal("ListePlaySoundSlot"..k.."Url"):SetText("");
		getglobal("ListePlaySoundSlot"..k.."Nom"):SetText("");
		getglobal("ListePlaySoundSlot"..k.."Categorie"):SetText("");
		getglobal("ListePlaySoundSlot"..k.."Icon"):SetTexture("Interface\\ICONS\\INV_Misc_GroupLooking.blp");
		getglobal("ListePlaySoundSlot"..k):SetButtonState("NORMAL");
		getglobal("ListePlaySoundSlot"..k):Hide();
	end
end

function calculerListePlaySound()
	local recherche = TRPPlaySoundListRecherche:GetText();
	local j = 0;
	
	ListePlaySoundSlider:Hide();
	ListePlaySoundSlider:SetValue(0);
	wipe(PlaySoundTab);
	TRPListePlaySoundEmpty:Hide();
	

	table.foreach(TRP_LISTE_SOUNDS,
	function(nom)
		if (recherche ~= "" and string.find(string.lower(nom),string.lower(recherche)) ~= nil) or (recherche ~= "" 
			and string.find(string.lower(TRP_LISTE_SOUNDS[nom]["Categorie"]),string.lower(recherche)) ~= nil) or recherche == "" then
			PlaySoundTab[j+1] = nom;
			j = j+1;
		end
	end);
	
	table.sort(PlaySoundTab);
	
	if j > 42 then
		local total = floor((j-1)/49);
		ListePlaySoundSlider:Show();
		ListePlaySoundSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListePlaySoundEmpty:Show();
	end
	
	ChargerSliderListePlaySound(0);
end

function ChargerSliderListePlaySound(num)
	Reinit_PlaySound();
	if PlaySoundTab ~= nil then
		for k=1,49,1 do 
			local i = num*49 + k;
			if PlaySoundTab[i] ~= nil then
				local nom = PlaySoundTab[i];
				getglobal("ListePlaySoundSlot"..k):Show();
				getglobal("ListePlaySoundSlot"..k.."Url"):SetText(TRP_LISTE_SOUNDS[nom]["Url"]);
				getglobal("ListePlaySoundSlot"..k.."Categorie"):SetText(TRP_LISTE_SOUNDS[nom]["Categorie"]);
				getglobal("ListePlaySoundSlot"..k.."Nom"):SetText(nom);
				if TRP_LISTE_SOUNDS_ICON[TRP_LISTE_SOUNDS[nom]["Categorie"]] then
					getglobal("ListePlaySoundSlot"..k.."Icon"):SetTexture(TRP_LISTE_SOUNDS_ICON[TRP_LISTE_SOUNDS[nom]["Categorie"]]);
				end
			end
		end
	end
end

-------------------------------------

function Reinit_Modele()
	for k=1,49,1 do --Initialisation
		getglobal("ListeModeleSlot"..k).Nom = nil;
		getglobal("ListeModeleSlot"..k).Url = nil;
		getglobal("ListeModeleSlot"..k).Scale = nil;
		getglobal("ListeModeleSlot"..k.."Icon"):SetTexture("Interface\\ICONS\\INV_Misc_GroupLooking.blp");
		getglobal("ListeModeleSlot"..k):SetButtonState("NORMAL");
		getglobal("ListeModeleSlot"..k):Hide();
	end
end

function calculerListeModele()
	local recherche = TRPModeleListRecherche:GetText();
	local j = 0;
	
	ListeModeleSlider:Hide();
	ListeModeleSlider:SetValue(0);
	wipe(ModeleTab);
	TRPListeModeleEmpty:Hide();
	

	table.foreach(TRP_OBJETS_MODEL,
	function(nom)
		if (recherche ~= "" and string.find(string.lower(TRP_OBJETS_MODEL[nom]["Nom"]),string.lower(recherche)) ~= nil) or (recherche ~= "" 
			and string.find(string.lower(TRP_OBJETS_MODEL[nom]["Url"]),string.lower(recherche)) ~= nil) or recherche == "" then
			ModeleTab[j+1] = nom;
			j = j+1;
		end
	end);
	
	table.sort(ModeleTab);
	
	if j > 42 then
		local total = floor((j-1)/49);
		ListeModeleSlider:Show();
		ListeModeleSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListeModeleEmpty:Show();
		TRPListeModeleEmpty:SetText("No 3D Model");
	end
	
	ChargerSliderListeModele(0);
end

function ChargerSliderListeModele(num)
	Reinit_Modele();
	if ModeleTab ~= nil then
		for k=1,49,1 do 
			local i = num*49 + k;
			if ModeleTab[i] ~= nil then
				local nom = ModeleTab[i];
				getglobal("ListeModeleSlot"..k):Show();
				getglobal("ListeModeleSlot"..k).Url = TRP_OBJETS_MODEL[nom]["Url"];
				getglobal("ListeModeleSlot"..k).Scale = TRP_OBJETS_MODEL[nom]["Scale"];
				getglobal("ListeModeleSlot"..k).Nom = nom;
				
				getglobal("ListeModeleSlot"..k):SetScript("OnEnter", function() 
					GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT");
					GameTooltip:AddLine(tostring(TRP_OBJETS_MODEL[nom]["Nom"]),0,1,0);
					GameTooltip:AddLine("File : "..tostring(this.Url),1,0.75,0);
					GameTooltip:AddLine("Size factor : "..tostring(this.Scale),1,0.75,0);
					GameTooltip:Show();
					anchorModeleTo(this.Nom,TRPListeModele,this);
				end);
				getglobal("ListeModeleSlot"..k):SetScript("OnLeave", function() 
					TRP_Objet_3D_Apercu:Hide();
					GameTooltip:Hide();
				end);
			end
		end
	end
end

function anchorModeleTo(modelNom,frame,button)
	if modelNom and TRP_OBJETS_MODEL[modelNom] then
		local model = TRP_OBJETS_MODEL[modelNom]["Url"];
		local scale = TRP_OBJETS_MODEL[modelNom]["Scale"];
		TRP_Objet_3D_Apercu:SetParent(frame);
		TRP_Objet_3D_Apercu:ClearAllPoints();
		TRP_Objet_3D_Apercu:SetPoint("TOP", button, "BOTTOM",0,0);
		TRP_Objet_3D_Apercu:Show();
		TRP_Objet_3D_PlayerModel:SetModel(model);
		TRP_Objet_3D_PlayerModel:SetModelScale(scale);
		if TRP_OBJETS_MODEL[modelNom]["Pos"] then
			TRP_Objet_3D_PlayerModel:SetPosition(TRP_OBJETS_MODEL[modelNom]["Pos"].X,TRP_OBJETS_MODEL[modelNom]["Pos"].Y,TRP_OBJETS_MODEL[modelNom]["Pos"].Z);
		else
			TRP_Objet_3D_PlayerModel:SetPosition(0,0,0);
		end
	end
end

function findPlanqueHere()
	local channelRSP, channelRSPName = GetChannelName("xtensionxtooltip2");
	if channelRSP then
		SendChatMessage("TRPGPL"..generatePlanqueID(), "CHANNEL", GetDefaultLanguage("player"), channelRSP);
		if FindPlanqueTab then
			wipe(FindPlanqueTab);
		else
			FindPlanqueTab = {};
		end
	end
end

function GivePlanqueInfo(planque,cible,planqueID)
	local message = planque["Commentaire"].."|";
	local i = 0;
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
		function(objet)
			if TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] and TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == planqueID and i < 5 then
				i = i + 1;
				message = message..TRP_Module_Inventaire[Royaume][Joueur][objet]["ID"].."|"..TRP_Module_Inventaire[Royaume][Joueur][objet]["Qte"].."|";
			end
	end);
	
	TRPSecureSendAddonMessage("GPI",message,cible);
end

function GetPlanqueInfos(tab, sender)
	if not FindPlanqueTab or FindPlanqueTab[sender] then
		return;
	end
	FindPlanqueTab[sender] = {};
	FindPlanqueTab[sender]["Commentaire"] = tab[1];
	if tab[2] and tab[2] ~= "" then
		FindPlanqueTab[sender]["1"] = {};
		FindPlanqueTab[sender]["1"]["ID"] = tab[2];
		FindPlanqueTab[sender]["1"]["Qte"] = tonumber(tab[3]);
	end
	if tab[4] and tab[4] ~= "" then
		FindPlanqueTab[sender]["2"] = {};
		FindPlanqueTab[sender]["2"]["ID"] = tab[4];
		FindPlanqueTab[sender]["2"]["Qte"] = tonumber(tab[5]);
	end
	if tab[6] and tab[6] ~= "" then
		FindPlanqueTab[sender]["3"] = {};
		FindPlanqueTab[sender]["3"]["ID"] = tab[6];
		FindPlanqueTab[sender]["3"]["Qte"] = tonumber(tab[7]);
	end
	if tab[8] and tab[8] ~= "" then
		FindPlanqueTab[sender]["4"] = {};
		FindPlanqueTab[sender]["4"]["ID"] = tab[8];
		FindPlanqueTab[sender]["4"]["Qte"] = tonumber(tab[9]);
	end
	if tab[10] and tab[10] ~= "" then
		FindPlanqueTab[sender]["5"] = {};
		FindPlanqueTab[sender]["5"]["ID"] = tab[10];
		FindPlanqueTab[sender]["5"]["Qte"] = tonumber(tab[11]);
	end
	
	table.foreach(FindPlanqueTab[sender],
		function(objet)
			if objet == "Commentaire" then
				debugMess("Commentaire : "..FindPlanqueTab[sender][objet]);
			else
				debugMess("Objet "..objet.." : "..FindPlanqueTab[sender][objet]["ID"].."  x"..FindPlanqueTab[sender][objet]["Qte"]);
				if not TRP_Module_ObjetsPerso[FindPlanqueTab[sender][objet]["ID"]] then
					-- Demande de l'objet
					ExchangeRefTarget = sender;
					ProceedObjetRefExchange(1,FindPlanqueTab[sender][objet]["ID"],"","","");
				end
			end
	end);
	PanelOpen("FicheJoueurOngletInventaire",sender);
end
