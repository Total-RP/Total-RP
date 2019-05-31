--[[
	Total RP, an role-play add-on by Telkostrasz (Conseil des Ombres - Eu/Fr)
]]--

function totalRP_OnLoad()
	this:RegisterForClicks( "LeftButtonUp", "RightButtonUp" );
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
end

function totalRP_OnEvent()
	if(event=="ADDON_LOADED" and arg1=="totalRP") then
		TotalRPOnLoad();
	elseif(event=="CHAT_MSG_ADDON" and string.sub(arg1, 1, 3) == "TRP" ) then
		receiveMessage(string.sub(arg1, 4, 6),arg4,arg2);
	elseif(event=="PLAYER_TARGET_CHANGED") then
		-- Adaptation de l'icone du portrait et de la taille du menu
		changeTarget();
		local cible,royaume = UnitName("target");
		if CheckInteractDistance("target", 4) and not royaume and cible and UnitIsPlayer("target") and cible~=Joueur and UnitFactionGroup("target") == UnitFactionGroup("player") and not TRP_Module_Registre[Royaume][cible] and not isBanned(nom) then
			TRPSecureSendAddonMessage("GTI",DonnerInfos(),cible);
		end
		-- La connection au channel ne peut se faire au d\195\169marrage.
		if TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] and not RSPInit then
			if GetChannelName("xtensionxtooltip2") ~= 0 then
				SendRSPInformations();
			end
		end
		--Courrier
		if not CourrierInit then
			CourrierInit = true;
			CheckCourrier();
		end
	elseif(event=="CHAT_MSG_CHANNEL") then
		--Spécifique au Module Registre
		if TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] and string.lower(arg9) == string.lower("xtensionxtooltip2") then
			desaoulage = string.gsub(arg1, "%.%.%.hips !", "");
			DecodeRSP(desaoulage,arg2);
			TRPChannelDecode(arg1, arg2);
		end
	elseif(event=="PLAYER_REGEN_DISABLED") then -- Marche uniquement quand aggro.
		-- Ouverture / Fermeture auto du menu :
		if TRP_Module_Configuration["Modules"]["General"]["bCloseInCombat"] then
			CloseAll();
			TRPCadreResumeRSPStyle:Hide();
			OpenMainMenu(false);
		end
	elseif(event=="UPDATE_MOUSEOVER_UNIT") then
		if GetChannelName("xtensionxtooltip2") == 0 and TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] then
			JoinChannelByName("xtensionxtooltip2");
		end
		local nom,royaume = UnitName("mouseover");
		if CheckInteractDistance("mouseover", 4) and not royaume and nom and UnitIsPlayer("mouseover") and nom~=Joueur and UnitFactionGroup("mouseover") == UnitFactionGroup("player") and TRP_Module_Registre[Royaume][nom] and not isBanned(nom) then
			TRPSecureSendAddonMessage("GTI",DonnerInfos(),nom);
			DonnerInfosPet(nom);
		end
		MouseOverTooltip();
	end
end

function TotalRPOnLoad()
	-- Initialisation de la langue :
	SetLocalisation();
	-- Initialisation des variables de sauvegarde :
	AdaptOldVariable();
	SetTRP_Module_Registre();
	SetTRP_Module_PlayerInfo();
	SetTRP_Module_Inventaire();
	SetTRP_Module_Configuration();
	-- Patchage
	Patchage();
	-- Check d'integrité
	CheckIntegrity();
	-- Initialisation de la position des éléments de l'UI :
	SetTRP_Interface_OnLoad();
	-- Initialisation terminée !!
	sendMessage(MESSAGE_ACCEUIL);
	if TRP_Module_Configuration["Modules"]["Registre"]["bRappel"] then
		RappelInfos();
	end
end

function DeleteOldSavedVariables()
	if TRP_PlayerInfo then
		wipe(TRP_PlayerInfo);
		TRP_PlayerInfo = nil;
	end
	if TRP_Notes then
		wipe(TRP_Notes);
		TRP_Notes = nil;
	end
	if TRP_Relations then
		wipe(TRP_Relations);
		TRP_Relations = nil;
	end
	if TRP_Registre then
		wipe(TRP_Registre);
		TRP_Registre = nil;
	end
	if TRP_Documents then
		wipe(TRP_Documents);
		TRP_Documents = nil;
	end
	if TRP_Inventaire then
		wipe(TRP_Inventaire);
		TRP_Inventaire = nil;
	end
	if TRP_ObjectPerso then
		wipe(TRP_ObjectPerso);
		TRP_ObjectPerso = nil;
	end
	if PlayerConfigurationTRP then
		wipe(PlayerConfigurationTRP);
		PlayerConfigurationTRP = nil;
	end
end

function AdaptOldVariable()
	local bNew = nil;
	if TRP_Module_PlayerInfo == nil then
		TRP_Module_PlayerInfo = { };
		TotalRP_tcopy(TRP_Module_PlayerInfo,TRP_PlayerInfo);
		if TRP_Module_PlayerInfo ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_PlayerInfo_Notes == nil then
		TRP_Module_PlayerInfo_Notes = { };
		TotalRP_tcopy(TRP_Module_PlayerInfo_Notes,TRP_Notes);
		if TRP_Module_PlayerInfo_Notes ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_PlayerInfo_Relations == nil then	
		TRP_Module_PlayerInfo_Relations = { };
		TotalRP_tcopy(TRP_Module_PlayerInfo_Relations,TRP_Relations);
		if TRP_Module_PlayerInfo_Relations ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_Registre == nil then
		TRP_Module_Registre = { };
		TotalRP_tcopy(TRP_Module_Registre,TRP_Registre);
		if TRP_Module_Registre ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_Documents == nil then
		TRP_Module_Documents = { };
		TotalRP_tcopy(TRP_Module_Documents,TRP_Documents);
		if TRP_Module_Documents ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_Configuration == nil then
		TRP_Module_Configuration = { };
		TotalRP_tcopy(TRP_Module_Configuration,PlayerConfigurationTRP);
		if TRP_Module_Configuration ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_Inventaire == nil then
		TRP_Module_Inventaire = { };
		TotalRP_tcopy(TRP_Module_Inventaire,TRP_Inventaire);
		if TRP_Module_Inventaire ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	if TRP_Module_ObjetsPerso == nil then
		TRP_Module_ObjetsPerso = { };
		TotalRP_tcopy(TRP_Module_ObjetsPerso,TRP_ObjectPerso);
		if TRP_Module_ObjetsPerso ~= nil then
			bNew = false;
		else
			bNew = true;
		end
	end
	DeleteOldSavedVariables();

	--DEFAULT_CHAT_FRAME:AddMessage("bNew = "..tostring(bNew),0,1,0);
end

function Patchage()
	if TRP_Module_Configuration ~= nil and TRP_Module_Configuration["Modules"] ~= nil 
		and TRP_Module_Configuration["Modules"]["Actions"] ~= nil 
		and TRP_Module_Configuration["Modules"]["Actions"]["PosX"] ~= nil then
		TRP_Module_Configuration["Modules"]["Actions"]["PosX"] = nil;
	end
	if TRP_Module_Configuration ~= nil and TRP_Module_Configuration["Modules"] ~= nil 
		and TRP_Module_Configuration["Modules"]["Actions"] ~= nil 
		and TRP_Module_Configuration["Modules"]["Actions"]["PosY"] ~= nil then
		TRP_Module_Configuration["Modules"]["Actions"]["PosY"] = nil;
	end
end

function CheckIntegrity()
	table.foreach(TRP_Module_Documents,
		function(ID)
			checkDocumentIntegrity(ID);
	end);
	table.foreach(TRP_Module_ObjetsPerso,
		function(ID)
			if ID == "" or string.len(ID) ~= 16 then
				TRP_Module_ObjetsPerso[ID] = nil;
			end
	end);
	table.foreach(TRP_Module_Inventaire,
		function(royaume)
			table.foreach(TRP_Module_Inventaire[royaume],
				function(perso)
					table.foreach(TRP_Module_Inventaire[royaume][perso],
						function(Slot)
							if TRP_Module_Inventaire[royaume][perso][Slot]["ID"] then
								-- A enlever quand on utilisera les objet
								if string.len(TRP_Module_Inventaire[royaume][perso][Slot]["ID"]) ~= 16 then
									wipe(TRP_Module_Inventaire[royaume][perso][Slot]);
									TRP_Module_Inventaire[royaume][perso][Slot] = nil;
								end
								-- Objet inexistant
								if not TRP_Module_ObjetsPerso[TRP_Module_Inventaire[royaume][perso][Slot]["ID"]] and not TRP_Objects[TRP_Module_Inventaire[royaume][perso][Slot]["ID"]] then
									wipe(TRP_Module_Inventaire[royaume][perso][Slot]);
									TRP_Module_Inventaire[royaume][perso][Slot] = nil;
								end
							end
					end);
			end);
	end);
	sendMessage("Saved variables verified (and corrected if necessary).",0,1,0);
end
