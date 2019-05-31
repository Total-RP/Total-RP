function TRPInitialisationUI()
	--Graphic stuff
	FicheJoueurOngletFicheIcon:SetTexture("Interface\\ICONS\\INV_Misc_GroupLooking.blp");
	FicheJoueurOngletInventaireIcon:SetTexture("Interface\\ICONS\\INV_Box_01.blp");
	FicheJoueurOngletRegistreIcon:SetTexture("Interface\\ICONS\\INV_Misc_Book_02.blp");
	FicheJoueurOngletOptionsIcon:SetTexture("Interface\\ICONS\\INV_Misc_Wrench_02.blp");
	RegistreFicheButtonPanelGeneralIcon:SetTexture("Interface\\ICONS\\Spell_Holy_DivineSpirit.blp");
	RegistreFicheButtonPanelDescriptionIcon:SetTexture("Interface\\ICONS\\INV_Misc_Note_05.blp");
	RegistreFicheButtonPanelListeIcon:SetTexture("Interface\\ICONS\\INV_Misc_Book_08.blp");
	InventaireOngletCreationIcon:SetTexture("Interface\\ICONS\\INV_Gizmo_02.blp");
	InventaireOngletCreationDocuIcon:SetTexture("Interface\\ICONS\\INV_Gizmo_02.blp");
	FicheJoueurOngletDocumentIcon:SetTexture("Interface\\ICONS\\INV_Letter_11.blp");
	FicheJoueurOngletDocumentDocuIcon:SetTexture("Interface\\ICONS\\INV_Letter_11.blp");
	local race,enRace = UnitRace("player");
	FicheJoueurRegistreButtonGeneralIcon:SetTexture("Interface\\ICONS\\Achievement_Character_"..textureRace[enRace].."_"..textureSex[UnitSex("player")]..".blp");
	FicheJoueurRegistreButtonDescriptionIcon:SetTexture("Interface\\ICONS\\INV_Misc_Note_05.blp");
	FicheJoueurRegistreButtonStatistiquesIcon:SetTexture("Interface\\ICONS\\INV_Scroll_12.blp");
	
	ActionBarPosition();
	
	TRPListeIcones:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeIconesSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeIconesSlider:GetValue() > mini then
			ListeIconesSlider:SetValue(ListeIconesSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeIconesSlider:GetValue() < maxi then
			ListeIconesSlider:SetValue(ListeIconesSlider:GetValue()+1);
		end
	end);
	
	RegistrePanelListe:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeButtonSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeButtonSlider:GetValue() > mini then
			ListeButtonSlider:SetValue(ListeButtonSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeButtonSlider:GetValue() < maxi then
			ListeButtonSlider:SetValue(ListeButtonSlider:GetValue()+1);
		end
	end);
	
	ObjetPersoFrame:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = PanelObjetPersoSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and PanelObjetPersoSlider:GetValue() > mini then
			PanelObjetPersoSlider:SetValue(PanelObjetPersoSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and PanelObjetPersoSlider:GetValue() < maxi then
			PanelObjetPersoSlider:SetValue(PanelObjetPersoSlider:GetValue()+1);
		end
	end);
	
	MainInventaireFrame:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = PanelCoffreSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and PanelCoffreSlider:GetValue() > mini then
			PanelCoffreSlider:SetValue(PanelCoffreSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and PanelCoffreSlider:GetValue() < maxi then
			PanelCoffreSlider:SetValue(PanelCoffreSlider:GetValue()+1);
		end
	end);
	
	PanelDocumentsListe:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = PanelDocumentsListeSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and PanelDocumentsListeSlider:GetValue() > mini then
			PanelDocumentsListeSlider:SetValue(PanelDocumentsListeSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and PanelDocumentsListeSlider:GetValue() < maxi then
			PanelDocumentsListeSlider:SetValue(PanelDocumentsListeSlider:GetValue()+1);
		end
	end);
	
	TRPListeObjets:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeObjetsSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeObjetsSlider:GetValue() > mini then
			ListeObjetsSlider:SetValue(ListeObjetsSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeObjetsSlider:GetValue() < maxi then
			ListeObjetsSlider:SetValue(ListeObjetsSlider:GetValue()+1);
		end
	end);
	
	TRPListeDocuments:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeDocumentsSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeDocumentsSlider:GetValue() > mini then
			ListeDocumentsSlider:SetValue(ListeDocumentsSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeDocumentsSlider:GetValue() < maxi then
			ListeDocumentsSlider:SetValue(ListeDocumentsSlider:GetValue()+1);
		end
	end);
	
	TRPListePersonnages:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListePersonnagesSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListePersonnagesSlider:GetValue() > mini then
			ListePersonnagesSlider:SetValue(ListePersonnagesSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListePersonnagesSlider:GetValue() < maxi then
			ListePersonnagesSlider:SetValue(ListePersonnagesSlider:GetValue()+1);
		end
	end);
	
	TRPListeSound:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeSoundSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeSoundSlider:GetValue() > mini then
			ListeSoundSlider:SetValue(ListeSoundSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeSoundSlider:GetValue() < maxi then
			ListeSoundSlider:SetValue(ListeSoundSlider:GetValue()+1);
		end
	end);
	
	TRPListePlaySound:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListePlaySoundSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListePlaySoundSlider:GetValue() > mini then
			ListePlaySoundSlider:SetValue(ListePlaySoundSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListePlaySoundSlider:GetValue() < maxi then
			ListePlaySoundSlider:SetValue(ListePlaySoundSlider:GetValue()+1);
		end
	end);
	
	TRPListeModele:SetScript("OnMouseWheel",function(arg1,arg2,arg3) 
		local mini,maxi = ListeModeleSlider:GetMinMaxValues();
		if tonumber(arg2) == 1 and ListeModeleSlider:GetValue() > mini then
			ListeModeleSlider:SetValue(ListeModeleSlider:GetValue()-1);
		elseif tonumber(arg2) == -1 and ListeModeleSlider:GetValue() < maxi then
			ListeModeleSlider:SetValue(ListeModeleSlider:GetValue()+1);
		end
	end);
	
	-- Flash des raccourcis
	CreateFrame("Cooldown","TRPRaccFlashSacADos",BarreActionsSacADos);
	TRPRaccFlashSacADos:SetAllPoints(BarreActionsSacADos);
	CreateFrame("Cooldown","TRPRaccFlashCoffre",BarreActionsCoffre);
	TRPRaccFlashCoffre:SetAllPoints(BarreActionsCoffre);
	CreateFrame("Cooldown","TRPRaccFlashPlanque",BarreActionsPlanques);
	TRPRaccFlashPlanque:SetAllPoints(BarreActionsPlanques);
	
	CreateFrame("Cooldown","TRPInvFlashSacADos",InventaireOngletSacADos);
	TRPInvFlashSacADos:SetAllPoints(InventaireOngletSacADos);
	CreateFrame("Cooldown","TRPInvFlashCoffre",InventaireOngletCoffre);
	TRPInvFlashCoffre:SetAllPoints(InventaireOngletCoffre);
	CreateFrame("Cooldown","TRPInvFlashPlanque",InventaireOngletPlanques);
	TRPInvFlashPlanque:SetAllPoints(InventaireOngletPlanques);
	
end

function OpenListeIcones(saisie)
	TRPListeIconesSaisie:SetText(saisie);
	TRPIconeListRecherche:SetText("");
	TRPListeIcones:Show();
	TRPIconeListRecherche:SetFocus();
	calculerListeIcone();
	ShadeSecondPlan(0.5);
end

function OpenListeObjets(saisie)
	TRPListeObjetsSaisie:SetText(saisie);
	TRPObjetListRecherche:SetText("");
	TRPListeObjets:Show();
	TRPObjetListRecherche:SetFocus();
	calculerListeObjet();
	ShadeSecondPlan(0.5);
end

function OpenListeDocuments(saisie)
	TRPListeDocumentsSaisie:SetText(saisie);
	TRPDocumentListRecherche:SetText("");
	TRPListeDocuments:Show();
	TRPDocumentListRecherche:SetFocus();
	calculerListeDocument();
	ShadeSecondPlan(0.5);
end

function OpenListePersonnages(saisie,plop)
	TRPListePersonnagesSaisie:SetText(saisie);
	TRPPersonnageListRecherche:SetText("");
	TRPListePersonnages:Show();
	TRPPersonnageListRecherche:SetFocus();
	calculerListePersonnage(plop);
	ShadeSecondPlan(0.5);
end

function OpenListeSound(saisie)
	TRPListeSoundSaisie:SetText(saisie);
	TRPSoundListRecherche:SetText("");
	TRPListeSound:Show();
	TRPSoundListRecherche:SetFocus();
	calculerListeSound();
	ShadeSecondPlan(0.5);
end

function OpenListePlaySound()
	TRPPlaySoundListRecherche:SetText("");
	TRPListePlaySound:Show();
	calculerListePlaySound();
end

function OpenListeModele(frame)
	TRPModeleListRecherche:SetText("");
	TRPListeModele:Show();
	TRPListeModele.frame = frame;
	calculerListeModele();
	ShadeSecondPlan(0.5);
end

function SetTRP_Interface_OnLoad()
	TRP_InitialiseStaticPopup();
	IconePosition();
	TRPInitialisationUI();
	setDoubleClicSurPortrait();
	ChangeStatutRP(TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"]);
	-- Hooking
	if TRP_Module_Configuration["Modules"]["Communication"]["UseTRPChat"] then
		TRPHookAll();
	end
	GameTooltip:SetScript("OnTooltipSetUnit", MouseOverTooltip);
	----------------------
	initPetButton();
	PlayerFrame:SetScript("OnUpdate", function(self,elapsed)
		PlayerFrame_OnUpdate(self,elapsed);
		local prename = TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"];
		if prename == "" then
			prename = Joueur;
		end
		if TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] ~= 1 then
			prename = "{v}"..prename;
		else
			prename = "{r}"..prename;
		end
		PlayerName:SetText(setTRPColorToString(prename));
	end);
	for i=1,4 do
		getglobal("PartyMemberFrame"..i):SetScript("OnUpdate",function(self,elapsed)
			PartyMemberFrame_OnUpdate(self, elapsed);
			local name = UnitName("party"..i);
			local couleur = "|cffaaaaff";
			if TRP_Module_PlayerInfo_Relations[Royaume][name] and TRP_Module_PlayerInfo_Relations[Royaume][name][Joueur] then
				couleur = relation_color[TRP_Module_PlayerInfo_Relations[Royaume][name][Joueur]];
			end
			if TRP_Module_Registre[Royaume][name] and TRP_Module_Registre[Royaume][name]["Prenom"] and TRP_Module_Registre[Royaume][name]["Prenom"] ~= "" then
				name = TRP_Module_Registre[Royaume][name]["Prenom"];
			end
			if name then
				getglobal("PartyMemberFrame"..i.."Name"):SetText(couleur..name);
			end
		end);
	end
end

function changeTarget()

	local cible = UnitName("target");
	
	if not TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStylePersistant"] then
		TRPCadreResumeRSPStyle:Hide();
	end
	TargetPortraitButton:Hide();
	
	if cible == nil then 
		return;
	end
	
	if UnitIsPlayer("target") then
		SetTargetPortraitButton();
		if TRP_Module_Registre[Royaume][cible] then
			local race, raceEn = UnitRace("target");
			local faction = UnitFactionGroup("target");
			TRP_Module_Registre[Royaume][cible]["Faction"] = faction;
			TRP_Module_Registre[Royaume][cible]["Race"] = raceEn;
			TRP_Module_Registre[Royaume][cible]["Sex"] = UnitSex("target");
			TRP_Module_Registre[Royaume][cible]["Connu"] = true;
			if TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyle"] and UnitAffectingCombat("player") == nil then
				TRPCadreResumeRSPStyle:Show();
				TRPCadreResumeRSPStyle:SetAlpha(TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyleAlpha"]/100);
				local message = "\n";
				message = message..nomComplet(cible).."\n";
				if TRP_Module_Registre[Royaume][cible]["SousTitre"] ~= nil and TRP_Module_Registre[Royaume][cible]["SousTitre"] ~= "" then
					message = message.."< "..TRP_Module_Registre[Royaume][cible]["SousTitre"].." >\n";
				end
				message = message.."\n";
				if TRP_Module_Registre[Royaume][cible]["Actuellement"] ~= nil and TRP_Module_Registre[Royaume][cible]["Actuellement"] ~= "" then
					message = message.."{o}"..ACTUELLEMENT.." :\n\"{w}";
					message = message..TRP_Module_Registre[Royaume][cible]["Actuellement"].."{o}\"\n\n";
				end
				if RecollageDescription(cible) ~= "" then
					message = message.."{o}"..DESCRIPTIONTEXT.." :\n\"{w}";
					message = message..RecollageDescription(cible).."{o}\"\n\n";
				end
				if TRP_Module_PlayerInfo_Relations[Royaume][cible] ~= nil and TRP_Module_PlayerInfo_Relations[Royaume][cible][Joueur] ~= nil then
					message = message.."{o}Relationship\n|T"..relation_texture[TRP_Module_PlayerInfo_Relations[Royaume][cible][Joueur]]..":50:50:0:0|t";
				end
				TRPCadreResumeRSPStyleTexte:SetText(setTRPColorToString(message));
			end
		end
		if TRP_Module_Registre[Royaume][cible] and TRP_Module_Registre[Royaume][cible]["Prenom"] and TRP_Module_Registre[Royaume][cible]["Prenom"] ~= "" then
			TargetFrameTextureFrameName:SetText(TRP_Module_Registre[Royaume][cible]["Prenom"]);
		elseif cible == Joueur and TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] ~= "" then
			TargetFrameTextureFrameName:SetText(TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"]);
		end
	else
		--SetTargetNPCPortraitButton();
	end
end

function hookMyNewFrame()
	function totalRP_FCF_OpenNewWindow(name)
		sendMessage("{o}Create a chat window: This feature has been disabled by the interface of Total RP!");
		sendMessage("{o}Use the list on the TRP shortcuts bar to activate Chat windows !");
	end
	SavedFCF_OpenNewWindow = FCF_OpenNewWindow;
	FCF_OpenNewWindow = totalRP_FCF_OpenNewWindow;
end

function LanguageMenu_Click(self)
	ChatFrame1.editBox.language = GetLanguageByIndex(self:GetID());
	ChatMenu:Hide();
end

SLASH_TOTALRP1 = '/trp';
function SlashCmdList.TOTALRP(msg, editbox)
	local command = string.match(msg,"%w+");
	local parametre1;
	if command then
		parametre1 = string.sub(msg,string.find(msg,"%w+")+string.len(command)+1);
		if parametre1 then
			parametre1 = string.lower(parametre1);
		end
		command = string.lower(command);
	end
	if command == "statusrp" then
		if parametre1 and (parametre1 == "rp" or parametre1 == "hrp") then
			if parametre1 == "rp" then
				ChangeStatutRP(2);
			else
				ChangeStatutRP(1);
			end
		else
			sendMessage("{o}Command 'Change Status RP': Valid settings: Status RP: rp (IC) or hrp (OOC).");
		end
	elseif command == "charachter" then
		if parametre1 and (parametre1 == "1" or parametre1 == "2" or parametre1 == "3" or parametre1 == "4" or parametre1 == "5") then
			LoadPerso(parametre1);
		else
			sendMessage("{o}Command 'Load Character': Valid settings: Character Slot: 1,2,3,4 or 5.");
		end
	elseif command == "currently" then
		if parametre1 and string.match(parametre1,"%\".*%\"") == parametre1 then
			local description = string.sub(parametre1,2,string.len(parametre1)-1);
			TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] = string.sub(description,1,200);
			IncrementerVerNum();
			sendMessage("{v}New current description :\n{o}\""..string.sub(description,1,200).."\"");
		else
			sendMessage("{o}Command 'Change Current description': Valid settings: New current description in quotes.");
		end
	elseif command == "localSound" then
		if parametre1 and parametre1 ~= " " and parametre1 ~= "" then
			TRPPlaySound(parametre1);
			TRPPlaySoundGlobal(parametre1,false,false);
		else
			sendMessage("{o}Command 'Local Sound': Invalid parameter: path from the root of the game and without the extension 'wav.'.");
		end
	elseif command == "globalSound" then
		if parametre1 and parametre1 ~= " " and parametre1 ~= "" then
			TRPPlaySound(parametre1);
			TRPPlaySoundGlobal(parametre1,"1",false);
		else
			sendMessage("{o}Command 'Global Sound': Invalid parameter: path from the root of the game and without the extension 'wav.'.");
		end
	elseif command == "pet" then
		if UnitName("pet") then
			openPetPage(UnitName("pet"),false);
		else
			sendMessage("{o}Command 'Pet': You must have summon your pet.");
		end
	elseif command == "gps" then
		TRPGPS();
	elseif command == "objet" then
		if parametre1 and parametre1 ~= " " and parametre1 ~= "" then
			if TRP_Module_ObjetsPerso[parametre1] or TRP_Objects[parametre1] then
				local Slot = GetSlotWithIDAndQte(parametre1,1,"-1");
				if Slot then
					UseObjet(Slot);
				else
					sendMessage("{r}You do not have this item in your backpack.");
				end
			else
				sendMessage("{r}Command 'Item' : Unknown Item ID.");
			end
		else
			sendMessage("{o}Command 'Item' : Invalid Parameter: Item ID.");
		end
	else
		sendMessage("{j}List of valid commands of Total RP :");
		sendMessage("{j}--------------------------------");
		sendMessage("{j}/trp statusrp #status");
		sendMessage("{j}/trp character #slot");
		sendMessage("{j}/trp currently \"Current Description\"");
		sendMessage("{j}/trp localSound \\Path\\");
		sendMessage("{j}/trp globalSound \\Path\\");
		sendMessage("{j}/trp item #Id");
		sendMessage("{j}/trp pet");
		sendMessage("{j}/trp gps");
		sendMessage("{j}--------------------------------");
	end
end

function SetItemRef(link, text, button, chatFrame)
	if ( strsub(link, 1, 6) == "player" ) then
		local namelink, isGMLink;
		if ( strsub(link, 7, 8) == "GM" ) then
			namelink = strsub(link, 10);
			isGMLink = true;
		else
			namelink = strsub(link, 8);
		end
		
		local name, lineid, chatType, chatTarget = strsplit(":", namelink);
		if ( name and (strlen(name) > 0) ) then
			if ( IsModifiedClick("CHATLINK") ) then
				local staticPopup;
				staticPopup = StaticPopup_Visible("ADD_IGNORE");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_MUTE");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_FRIEND");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_GUILDMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_TEAMMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_RAIDMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("CHANNEL_INVITE");
				if ( staticPopup ) then
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				if ( ChatEdit_GetActiveWindow() ) then
					ChatEdit_InsertLink(name);
				elseif ( HelpFrameOpenTicketEditBox:IsVisible() ) then
					HelpFrameOpenTicketEditBox:Insert(name);
				else
					SendWho(WHO_TAG_NAME..name);					
				end
				
			elseif ( button == "RightButton" and (not isGMLink) ) then
				if IsControlKeyDown() then
					AfficherLeMenuDropDownChat(name,lineid);
				else
					FriendsFrame_ShowDropdown(name, 1, lineid, chatType, chatFrame);
				end
			else
				ChatFrame_SendTell(name, chatFrame);
			end
		end
		return;
	elseif ( strsub(link, 1, 8) == "BNplayer" ) then
		local namelink = strsub(link, 10);
		
		local name, presenceID, lineid, chatType, chatTarget = strsplit(":", namelink);
		if ( name and (strlen(name) > 0) ) then
			if ( IsModifiedClick("CHATLINK") ) then
				local staticPopup;
				staticPopup = StaticPopup_Visible("ADD_IGNORE");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_MUTE");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_FRIEND");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_GUILDMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_TEAMMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("ADD_RAIDMEMBER");
				if ( staticPopup ) then
					-- If add ignore dialog is up then enter the name into the editbox
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				staticPopup = StaticPopup_Visible("CHANNEL_INVITE");
				if ( staticPopup ) then
					_G[staticPopup.."EditBox"]:SetText(name);
					return;
				end
				if ( ChatEdit_GetActiveWindow() ) then
					ChatEdit_InsertLink(name);
				elseif ( HelpFrameOpenTicketEditBox:IsVisible() ) then
					HelpFrameOpenTicketEditBox:Insert(name);				
				end
				
			elseif ( button == "RightButton" ) then
				if ( not BNIsSelf(presenceID) ) then
					FriendsFrame_ShowBNDropdown(name, 1, nil, chatType, chatFrame, nil, BNet_GetPresenceID(name));
				end
			else
				if ( not BNIsSelf(presenceID) ) then
					ChatFrame_SendTell(name, chatFrame);
				end
			end
		end
		return;
	elseif ( strsub(link, 1, 7) == "channel" ) then
		if ( IsModifiedClick("CHATLINK") ) then
			local chanLink = strsub(link, 9);
			local chatType, chatTarget = strsplit(":", chanLink);
			if ( strupper(chatType) == "BN_CONVERSATION" ) then
				BNListConversation(chatTarget);
			else
				ToggleFriendsFrame(4);
			end
		elseif ( button == "LeftButton" ) then
			local chanLink = strsub(link, 9);
			local chatType, chatTarget = strsplit(":", chanLink);
			
			if ( strupper(chatType) == "CHANNEL" ) then
				if ( GetChannelName(tonumber(chatTarget))~=0 ) then
					ChatFrame_OpenChat("/"..chatTarget, chatFrame);
				end
			elseif ( strupper(chatType) == "BN_CONVERSATION" ) then
				if ( BNGetConversationInfo(chatTarget) ) then
					ChatFrame_OpenChat("/"..(chatTarget + MAX_WOW_CHAT_CHANNELS), chatFrame);
				end
			else
				ChatFrame_OpenChat("/"..chatType, chatFrame);
			end
		elseif ( button == "RightButton" ) then
			local chanLink = strsub(link, 9);
			local chatType, chatTarget = strsplit(":", chanLink);
			if not ( (strupper(chatType) == "CHANNEL" and GetChannelName(tonumber(chatTarget)) == 0) or	--Don't show the dropdown if this is a channel we are no longer in.
				(strupper(chatType) == "BN_CONVERSATION" and not BNGetConversationInfo(chatTarget)) ) then	--Or a conversation we are no longer in.
				ChatChannelDropDown_Show(chatFrame, strupper(chatType), chatTarget, Chat_GetColoredChatName(strupper(chatType), chatTarget));
			end
		end
		return;
	elseif ( strsub(link, 1, 6) == "GMChat" ) then
		GMChatStatusFrame_OnClick();
		return;
	end
	
	if ( IsModifiedClick() ) then
		local fixedLink = GetFixedLink(text);
		HandleModifiedItemClick(fixedLink);
	else
		ShowUIPanel(ItemRefTooltip);
		if ( not ItemRefTooltip:IsShown() ) then
			ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		ItemRefTooltip:SetHyperlink(link);
	end
end

function AfficherLeMenuDropDownChat(name,lineid)
	TRPCHATNAME = name;
	if TRPCHATNAME then
		UIDropDownMenu_Initialize(TRP_Chat_DropDownMenu, TRP_Chat_DropDownMenu_OnLoad, "MENU");
		TRP_Chat_DropDownMenu.lineID = lineid;
		ToggleDropDownMenu(1, nil, TRP_Chat_DropDownMenu, "cursor");
	end
end

function TRP_Chat_DropDownMenu_OnLoad()
	UIDropDownMenu_SetWidth(TRP_Chat_DropDownMenu, 20);
	UIDropDownMenu_SetButtonWidth(TRP_Chat_DropDownMenu, 15);
	info = {};
	info.text = "TotalRP";
	info.isTitle = true;
	UIDropDownMenu_AddButton(info);
	if TRPCHATNAME == Joueur then
		info = {};
		info.text = TRPCHATNAME.."'s sheet";
		info.func = function() PanelOpen("FicheJoueurOngletFiche") end;
		UIDropDownMenu_AddButton(info);
	elseif TRP_Module_Registre[Royaume][TRPCHATNAME] then
		info = {};
		info.text = TRPCHATNAME.."'s sheet";
		info.func = function() PanelOpen("FicheJoueurOngletRegistre","General",TRPCHATNAME) end;
		UIDropDownMenu_AddButton(info);
		info = {};
		info.text = "Add to the TRP BlackList";
		info.func = function() 
			TRP_Module_PlayerInfo_Relations[Royaume][TRPCHATNAME][Joueur] = 1; 
			sendMessage("|Hplayer:"..TRPCHATNAME.."|h{r}[{n}"..TRPCHATNAME.."{r}]|h is now ignore by TRP. All his attempts to interact with you will fail.")
		end;
		UIDropDownMenu_AddButton(info);
		info = {};
		if TRP_Module_Registre[Royaume][TRPCHATNAME]["Muted"] then
			info.text = "Unmute";
			info.func = function() 
				TRP_Module_Registre[Royaume][TRPCHATNAME]["Muted"] = nil;
			end;
			UIDropDownMenu_AddButton(info);
		else
			info.text = "Mute";
			info.func = function() 
				TRP_Module_Registre[Royaume][TRPCHATNAME]["Muted"] = true;
			end;
			UIDropDownMenu_AddButton(info);
		end
	else
		info = {};
		info.text = "Add to the Register";
		info.func = function() AjouterAuRegistre(TRPCHATNAME) end;
		UIDropDownMenu_AddButton(info);
	end
	info = {};
	info.text = "Cancel";
	info.func = function() end;
	UIDropDownMenu_AddButton(info);
end

--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, true, function]  --  Check the button if true or function returns true
info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, true]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.fontObject = [FONT] -- font object replacement for Normal and Highlight
info.menuTable = [TABLE] -- This contains an array of info tables to be displayed as a child menu
]]

