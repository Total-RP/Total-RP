function TRPSecureSendAddonMessage(Prefixe,Message,Cible)

	if Prefixe == nil then
		debugMess("Prefixe nil")
		return;
	elseif Message == nil then
		debugMess("Message nil")
		return;
	elseif Cible == nil then
		debugMess("Cible nil")
		return;
	end
	if isInBgOrArena() then
		return;
	end

	local taille = string.len(Prefixe) + string.len(Message) + 3;
	
	if taille > 254 then
		TRPError("Internal error : Tentative de TRPSecureSendAddonMessage avec une taille de "..taille.."!\nEnvoi annulé !");
		return;
	end
	SendAddonMessage("TRP"..Prefixe,Message, "WHISPER", Cible);

end

function TRPSecureSendAddonMessageToGroupOrRaid(Prefixe,Message)

	if Prefixe == nil then
		debugMess("Prefixe nil")
		return;
	elseif Message == nil then
		debugMess("Message nil")
		return;
	end
	if isInBgOrArena() then
		return;
	end
	
	local taille = string.len(Prefixe) + string.len(Message) + 3;
	
	if taille > 254 then
		TRPError("Internal error : Tentative de TRPSecureSendAddonMessageToGroupOrRaid avec une taille de "..taille.."!\nEnvoi annulé !");
		return;
	end

	if UnitInRaid("player") then
		SendAddonMessage("TRP"..Prefixe,Message, "RAID");
	elseif UnitInParty("player") then
		SendAddonMessage("TRP"..Prefixe,Message, "PARTY");
	end

end

function receiveMessage(prefixe,sender,message)

	--debugMess("prefixe : "..prefixe)
	--debugMess("sender : "..sender)
	--debugMess("message : "..message)


	-- Check ignor\195\169
	if isBanned(sender) then
		return;
	end
	-- Check r\195\169ponse retour
	if  sender == Joueur then
		return;
	end

	if prefixe == "GTR" then -- GET REGISTRE
		EnvoiInfo(sender);
	elseif prefixe == "GTI" then --GET INFO
		RecupInfos(fetchInformations(message),sender);
		TRPSecureSendAddonMessage("GVI",DonnerInfos(),sender);
		DonnerInfosPet(sender);
	elseif prefixe == "GVR" then --GIVE REGISTRE
		RecupRegistre(fetchInformations(message),sender);
	elseif prefixe == "GVD" then --GIVE DESCRIPTION
		RecupDescri(message,sender);
	elseif prefixe == "GVI" then --GIVE INFO
		RecupInfos(fetchInformations(message),sender);
	elseif prefixe == "GVP" then --Give information pet
		RecupInfosPet(fetchInformations(message),sender);
	elseif prefixe == "GOA" then --GIVE OBJET ASKING
		AskingObjet(fetchInformations(message),sender);
	elseif prefixe == "SOA" then --Show Objet Asking
		ShowAskingObjet(fetchInformations(message),sender);
	elseif prefixe == "GOD" then --GIVE OBJET DONE
		GiveObjectDone(fetchInformations(message),sender);
	elseif prefixe == "SDM" then --SEND MESSAGE
		sendMessage("{w}"..message);
	elseif prefixe == "GRA" then --GIVE REFERENCE ASKING
		ReferenceAskingObjet(fetchInformations(message),sender);
	elseif prefixe == "GRI" then --GET REFERENCE  INFOS
		proceedGRI(fetchInformations(message),sender);
	elseif prefixe == "GRS" then --GIVE REFERENCE ALL SEND
		proceedGRS(fetchInformations(message),sender);
	elseif prefixe == "GDA" then --GIVE DOCUMENT ASKING
		AskingDocument(fetchInformations(message),sender);
	elseif prefixe == "GDP" then --GIVE DOCUMENT PROCEED
		SendDocument(fetchInformations(message),sender);
	elseif prefixe == "GDS" then --GIVE DOCUMENT SENDING
		ReceiveDocument(fetchInformations(message),sender);
	elseif prefixe == "SDC" then -- Send Courrier
		ReceptionCourrier(fetchInformations(message),sender);
	elseif prefixe == "COK" then -- Courrier OK
		OKCourrier(fetchInformations(message),sender);
	elseif prefixe == "SSN" then -- Son target
		RecevoirSon(fetchInformations(message),sender);
	elseif prefixe == "SSR" then --Son gr or raid
		RecevoirSonGroupRaid(fetchInformations(message),sender);
	elseif prefixe == "GPI" then -- Give planque infos
		GetPlanqueInfos(fetchInformations(message),sender);
	end
end

function TRPChannelDecode(message, sender)
	if string.sub(message,1,3) ~= "TRP" then 
		return;
	end
	prefix = string.sub(message,4,6);
	local infos = fetchInformations(string.sub(message,7));
	
	if prefix == "GPL" then
		if sender~=Joueur and infos[1] and TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][infos[1]] then
			GivePlanqueInfo(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][infos[1]],sender,infos[1]);
		end
	end
end

function fetchInformations(message)
	local fetchTab = {}
	local i = 1;
	while (string.find(message,"|") and i < 50)
	do
		fetchTab[i] = string.sub(message,1,string.find(message,"|")-1);
		message = string.sub(message,string.find(message,"|")+1,string.len(message));
		i = i + 1;
	end
	fetchTab[i] = string.sub(message,1,string.len(message));
	
	return fetchTab;
end


----------------------------------------------------------------------------------
------ SON GLOBAUX
----------------------------------------------------------------------------------

function notifSoundToLog(sound,from,bGlobal)
	local message = "{w}[{r}"..date("%H:%M:%S").."{w}]|Hplayer:"..from.."|h["..from.."]|h {w}joue le son ";
	if bGlobal then
		message = message.." {v}(Global)";
	else
		message = message.." {c}(Local)";
	end
	message = message..":\n{o}"..sound;
	if TRP_Module_Configuration["Modules"]["Sons"]["LogFrame"] ~= "" then
		getglobal("ChatFrame"..TRP_Module_Configuration["Modules"]["Sons"]["LogFrame"]):AddMessage(setTRPColorToString(message),1,0.5,0);
	else
		DEFAULT_CHAT_FRAME:AddMessage(setTRPColorToString(message),1,0.75,0);
	end
end

function checkFloodTime()
	local temps = TRP_Module_Configuration["Modules"]["Sons"]["AntiSpamCooldown"];
	
	if TRPLASTSOUND == nil or not TRP_Module_Configuration["Modules"]["Sons"]["AntiSpam"] then
		return true;
	elseif time()-TRPLASTSOUND > temps then
		return true
	end
	return false;
end

function RecevoirSon(tab,from)
	if tab[1] then
		if TRP_Module_Registre[Royaume][from] and not TRP_Module_Registre[Royaume][from]["Muted"] and checkFloodTime() then
			if TRP_Module_Configuration["Modules"]["Sons"]["Log"] then
				notifSoundToLog(tab[1],from,false);
			end
			TRPLASTSOUND = time();
			TRPPlaySound(tab[1]);
		end
	else
		TRPError("Receiving her: cheesy");
	end
end

function RecevoirSonGroupRaid(tab,from)
	if tab[1] and tab[2] then
		if tab[2] == "1" or CheckInteractDistance(from,4) then
			if TRP_Module_Registre[Royaume][from] and not TRP_Module_Registre[Royaume][from]["Muted"] and checkFloodTime() then
				if TRP_Module_Configuration["Modules"]["Sons"]["Log"] then
					notifSoundToLog(tab[1],from,tab[2] == "1");
				end
				TRPLASTSOUND = time();
				TRPPlaySound(tab[1]);
			end
		end
	else
		TRPError("Receiving her: cheesy");
	end
end

function TRPPlaySoundGlobal(sound,isGlobal,bMessage)
	local toTarget,toRaid,toGroup; -- A qui envoyer
	
	if not sound then return end
	
	if UnitName("target") and TRP_Module_Registre[Royaume][UnitName("target")] 
		and TRP_Module_Registre[Royaume][UnitName("target")]["Type"] == 1 
		and not UnitInParty("target") and not UnitInRaid("target") then 
			if isGlobal or CheckInteractDistance("target",4) then
				toTarget = UnitName("target");
			else
				if bMessage then
					sendMessage("The target is too far from you to receive a local sound.");
				end
			end
	end
	
	if GetNumRaidMembers() > 0 then
		toRaid = true;
		toGroup = false;
	elseif GetNumPartyMembers() > 0 then
		toRaid = false;
		toGroup = true;
	end
	
	if not toTarget and not toGroup and not toRaid then
		if bMessage then
			sendMessage("{o}Play Sound: You must have selected a valid person or be in a group or a raid.");
		end
	else
		if toTarget then
			TRPSecureSendAddonMessage("SSN",sound,toTarget);
		end
		if toGroup or toRaid then
			TRPSecureSendAddonMessageToGroupOrRaid("SSR",sound.."|"..tostring(isGlobal));
		end
	end
	
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

function hookMyBigChat()
	function totalRP_SendChatMessage( msg, chatType, language, channel )
	
		if string.find(msg,"%%t") and not UnitName("target") then
			TRPError("Vous n'avez pas de cible.");
			return;
		end
	
		if (chatType=="SAY" or chatType=="PARTY" or chatType=="RAID" or chatType=="GUILD" or chatType=="WHISPER" or chatType=="YELL") 
		and TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] == 1 and TRP_Module_Configuration["Modules"]["Communication"]["AutoParenthese"] then
			if string.len(setTRPColorToString("( "..msg.." )",true)) < 251 then
				SavedSendChatMessage( setTRPColorToString("( "..msg.." )",true), chatType, language, channel );
			else
				TRPError("Message trop long.");
			end
			return;
		end
		if string.len(setTRPColorToString(msg,true)) < 255 then
			SavedSendChatMessage( setTRPColorToString(msg,true), chatType, language, channel );
		else
			TRPError("Message trop long.");
		end
	end
	SavedSendChatMessage = SendChatMessage;
	SendChatMessage = totalRP_SendChatMessage;
end

function FragmenterEnEmote(texte,perso,myChatFrame,event,langue,personnage) -- Ne reçois QUE du texte RP
	local textRestant = texte;
	local type = strsub(event, 10);
	local info = ChatTypeInfo[type];
	
	local icone = "";
	if TRP_Module_Configuration["Modules"]["Communication"]["IconeRelation"] and TRP_Module_PlayerInfo_Relations[Royaume][personnage] and TRP_Module_PlayerInfo_Relations[Royaume][personnage][Joueur] and TRP_Module_PlayerInfo_Relations[Royaume][personnage][Joueur] ~= 3 then
		icone = "|T"..relation_texture[TRP_Module_PlayerInfo_Relations[Royaume][personnage][Joueur]]..":20:20|t"
	end
	
	while TRP_Module_Configuration["Modules"]["Communication"]["EmoteDetect"] and (event ~= "CHAT_MSG_YELL") and 
		(string.find(textRestant,"%<.*%>") or string.find(textRestant,"%*.*%*"))  do
		
		local preTexte;
		local EmoteTexte;
		local postTexte;
		
		-- Catching de l'emote
		if string.find(textRestant,"%<.*%>") then
			preTexte = string.sub(textRestant,1,string.find(textRestant,"%<")-1);
			EmoteTexte = string.sub(textRestant,string.find(textRestant,"%<")+1,string.find(textRestant,"%>")-1); -- Du texte Emote
			postTexte = string.sub(textRestant,string.find(textRestant,"%>")+1);
		elseif string.find(textRestant,"%*.*%*") then
			preTexte = string.sub(textRestant,1,string.find(textRestant,"%*")-1);
			EmoteTexte = string.match(textRestant,"%*.*%*");
			postTexte = string.sub(textRestant,string.len(preTexte)+string.len(EmoteTexte)+1);
			EmoteTexte = string.sub(EmoteTexte,2,string.len(EmoteTexte)-1);
		end
		
		-- D�tection d'un tag de language (haxx pour Lore,temporaire)
		if string.find(preTexte,"%[%a*%]") then
			preTexte = textRestant;
			EmoteTexte = "";
			postTexte = "";
		end
		
		-- Suppression de la majuscule de d�but d'�mote
		if string.find(string.sub(EmoteTexte,1,1),"%u") then
			EmoteTexte = string.lower(string.sub(EmoteTexte,1,1))..string.sub(EmoteTexte,2);
		end
		
		if preTexte ~= "" and preTexte ~= " " then
			myChatFrame:AddMessage(setTRPColorToString(preTabDiscu[event].."["..icone..perso..postTabDiscu[event]..langue..preTexte),info.r,info.g,info.b,info.id);
		end
		if EmoteTexte ~= "" and EmoteTexte ~= " " then
			if event == "CHAT_MSG_SAY" then
				myChatFrame:AddMessage(setTRPColorToString(langue..preTabDiscu[event]..""..perso.."|r "..EmoteTexte.."."),ChatTypeInfo["EMOTE"].r,ChatTypeInfo["EMOTE"].g,ChatTypeInfo["EMOTE"].b,ChatTypeInfo["EMOTE"].id);
			else
				myChatFrame:AddMessage(setTRPColorToString(langue..preTabDiscu[event]..""..perso.."|r "..EmoteTexte.."."),math.abs(info.r-0.15),math.abs(info.g-0.15),math.abs(info.b-0.15),info.id);
			end
		end
		if not string.find(postTexte,"%<.*%>") and not string.find(postTexte,"%*.*%*") then
			if postTexte ~= "" and postTexte ~= " " then
				myChatFrame:AddMessage(setTRPColorToString(preTabDiscu[event].."["..icone..perso..postTabDiscu[event]..langue..postTexte),info.r,info.g,info.b,info.id);
			end
			textRestant = "";
		else
			textRestant = postTexte;
		end
	end
	
	if textRestant ~= "" and textRestant ~= " " then
		myChatFrame:AddMessage(setTRPColorToString(preTabDiscu[event].."["..icone..perso..postTabDiscu[event]..langue..textRestant),info.r,info.g,info.b,info.id);
	end
	
end

function FragmenterDialogue(texte,perso,langue,statut,arg7,myChatFrame,event,coloredName)
	local textRestant = texte;
	local color = relation_color[3];
	local personnage=perso;
	local personnageHRP;
	local finalLangue = "";
	local type = strsub(event, 10);
	local info = ChatTypeInfo[type];
	
	if ((UnitFactionGroup("player") == "Alliance" and langue ~= "Commun" and langue ~= "Common") or 
	(UnitFactionGroup("player") == "Horde" and langue ~= "Orc" and langue ~= "Orcish")) and langue ~= "" then
		finalLangue = "["..langue.."] ";
	end
	
	-- Search for icon links and replace them with texture links.
	if ( arg7 < 1 or ( arg7 >= 1 and CHAT_SHOW_ICONS ~= "0" ) ) then
		local term;
		for tag in string.gmatch(textRestant, "%b{}") do
			term = strlower(string.gsub(tag, "[{}]", ""));
			if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
				textRestant = string.gsub(textRestant, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
			end
		end
	end
	
	-- Calcul de la couleur du perso + lien de whisp + nom
	if TRP_Module_Configuration["Modules"]["Communication"]["UseColorName"] then
		if perso == Joueur then
			color = "{v}";
		elseif TRP_Module_PlayerInfo_Relations[Royaume][perso] and TRP_Module_PlayerInfo_Relations[Royaume][perso][Joueur] then
			color = relation_color[TRP_Module_PlayerInfo_Relations[Royaume][perso][Joueur]];
		end
	elseif info.colorNameByClass then
		color = string.sub(coloredName,1,10);
	else
		color = "";
	end
	if perso ~= Joueur and TRP_Module_Registre[Royaume][perso] ~= nil then
		if TRP_Module_Registre[Royaume][perso]["Prenom"] and TRP_Module_Registre[Royaume][perso]["Prenom"] ~= "" then
			personnage = TRP_Module_Registre[Royaume][perso]["Prenom"];
		end
		if TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] and TRP_Module_Registre[Royaume][perso]["Nom"] ~= nil and TRP_Module_Registre[Royaume][perso]["Nom"] ~= "" then
			personnage = personnage.." "..TRP_Module_Registre[Royaume][perso]["Nom"];
		end
	elseif perso == Joueur and TRP_Module_PlayerInfo[Royaume][perso]["Prenom"] ~= "" then
		personnage = TRP_Module_PlayerInfo[Royaume][perso]["Prenom"];
		if TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] and TRP_Module_PlayerInfo[Royaume][perso]["Nom"] ~= "" then
			personnage = personnage.." "..TRP_Module_PlayerInfo[Royaume][perso]["Nom"];
		end
	end
	personnage = "|Hplayer:"..perso.."|h"..color..personnage.."|h";
	personnageHRP = "|Hplayer:"..perso.."|h"..color..perso.."|h";
	

	local secu = 1;
	while string.find(textRestant,"%|%H.*%:.*%|%h.*%(.*%).*%|%h") and secu < 10 do
		local preTexte = string.sub(textRestant,1,string.find(textRestant,"%|H")-1); -- text avant
		local postTexte = string.sub(textRestant,string.len(preTexte)+1); -- Du texte HRP
		postTexte = string.gsub(postTexte,"%(","%[",1);
		postTexte = string.gsub(postTexte,"%)","%]",1);
		textRestant = preTexte..postTexte;
		secu = secu + 1;
	end
	
	-- Detection d'HRP
	if TRP_Module_Configuration["Modules"]["Communication"]["HRPDetect"] then
		textRestant = string.gsub(textRestant,"%:%)","%:%]");
		textRestant = string.gsub(textRestant,"%:%-%)","%:%-%]");
		while string.find(textRestant,"%((.*%))") do
			local preTexte = string.sub(textRestant,1,string.find(textRestant,"%(")-1); -- Text RP
			local hrpTexte = string.sub(textRestant,string.find(textRestant,"%("),string.find(textRestant,"%)")); -- Text HRP
			local postTexte = string.sub(textRestant,string.find(textRestant,"%)")+2); -- Text RP or HRP
			
			-- D�tection d'un tag de language (haxx pour Lore, temporaire)
			if string.find(preTexte,"%[%a*%]") then
				preTexte = textRestant;
				hrpTexte = "";
				postTexte = "";
			end
			
			if preTexte ~= "" and preTexte ~= " " then
				FragmenterEnEmote(preTexte,personnage,myChatFrame,event,finalLangue,perso); -- On l'envoie dans la machine � d�tection d'�motes
			end
			if hrpTexte ~= "" and hrpTexte ~= " " then
				if TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"] and TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"] ~= "" then
					getglobal("ChatFrame"..TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"]):AddMessage(setTRPColorToString(preTabDiscu[event].."["..personnageHRP.."|r][OOC] : "..finalLangue..hrpTexte),math.abs(info.r-0.2),math.abs(info.g-0.2),math.abs(info.b-0.2));
				else
					myChatFrame:AddMessage(setTRPColorToString(preTabDiscu[event].."["..personnageHRP.."|r][OOC] : "..finalLangue..hrpTexte),math.abs(info.r-0.2),math.abs(info.g-0.2),math.abs(info.b-0.2));
				end
			end
			if not string.find(textRestant,"%(.*%)") then
				if postTexte ~= "" and postTexte ~= " " then
					FragmenterEnEmote(postTexte,personnage,myChatFrame,event,finalLangue,perso); -- On l'envoie dans la machine � d�tection d'�motes
				end
				textRestant = "";
			else
				textRestant = postTexte;
			end
		end
		if textRestant ~= "" and textRestant ~= " " then
			FragmenterEnEmote(textRestant,personnage,myChatFrame,event,finalLangue,perso); -- On l'envoie dans la machine � d�tection d'�motes
		end
	else
		FragmenterEnEmote(textRestant,personnage,myChatFrame,event,finalLangue,perso); -- On l'envoie dans la machine � d�tection d'�motes
	end
	
	if (event == "CHAT_MSG_WHISPER") then
		ChatEdit_SetLastTellTarget(perso);
		if ( myChatFrame.tellTimer and (GetTime() > myChatFrame.tellTimer) ) then
			PlaySound("TellMessage");
		end
		myChatFrame.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
		FCF_FlashTab(myChatFrame);
	end
end

function AnalyserEmote(emote,perso,myChatFrame,event,coloredName)
	local color = relation_color[3];
	local personnage=perso;
	local type = strsub(event, 10);
	local info = ChatTypeInfo[type];
	local infoNpc = ChatTypeInfo["MONSTER_EMOTE"];
	
	-- Calcul de la couleur du perso + lien de whisp + nom
	if TRP_Module_Configuration["Modules"]["Communication"]["UseColorName"] then
		if perso == Joueur then
			color = "{v}";
		elseif TRP_Module_PlayerInfo_Relations[Royaume][perso] ~= nil and TRP_Module_PlayerInfo_Relations[Royaume][perso][Joueur] then
			color = relation_color[TRP_Module_PlayerInfo_Relations[Royaume][perso][Joueur]];
		end
	elseif info.colorNameByClass then
		color = string.sub(coloredName,1,10);
	else
		color = "";
	end
	if perso ~= Joueur and TRP_Module_Registre[Royaume][perso] ~= nil then
		if TRP_Module_Registre[Royaume][perso]["Prenom"] and TRP_Module_Registre[Royaume][perso]["Prenom"] ~= "" then
			personnage = TRP_Module_Registre[Royaume][perso]["Prenom"];
		end
		if TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] and TRP_Module_Registre[Royaume][perso]["Nom"] ~= nil and TRP_Module_Registre[Royaume][perso]["Nom"] ~= "" then
			personnage = personnage.." "..TRP_Module_Registre[Royaume][perso]["Nom"];
		end
	elseif perso == Joueur and TRP_Module_PlayerInfo[Royaume][perso]["Prenom"] ~= "" then
		personnage = TRP_Module_PlayerInfo[Royaume][perso]["Prenom"];
		if TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] and TRP_Module_PlayerInfo[Royaume][perso]["Nom"] ~= "" then
			personnage = personnage.." "..TRP_Module_PlayerInfo[Royaume][perso]["Nom"];
		end
	end
	personnage = "|Hplayer:"..perso.."|h"..color..personnage.."|h";
	
	if event == "CHAT_MSG_TEXT_EMOTE" then
		if perso == Joueur then
			myChatFrame:AddMessage(setTRPColorToString("|r"..emote),info.r,info.g,info.b,info.id);
		else
			myChatFrame:AddMessage(setTRPColorToString(personnage.."|r "..string.sub(emote,string.len(perso)+2)),info.r,info.g,info.b,info.id);
		end
	elseif string.sub(emote,1,1) == "|" then
		local trace = "|Hplayer:"..perso.."|h[-]|h";
		if string.find(emote,"Says:  ") then
			local Nom = string.sub(emote,3,string.find(emote,"Says:  ")-2);
			local phrase = string.sub(emote,string.find(emote,"Says:  ")+6);
			local NpcSay = ChatTypeInfo["MONSTER_SAY"];
			myChatFrame:AddMessage(trace.." "..setTRPColorToString(Nom.." Says:  "..phrase),NpcSay.r,NpcSay.g,NpcSay.b,NpcSay.id);
		else
			myChatFrame:AddMessage(trace.." "..setTRPColorToString(string.sub(emote,3)),infoNpc.r,infoNpc.g,infoNpc.b,infoNpc.id);
		end
	else
		myChatFrame:AddMessage(setTRPColorToString(personnage.."|r "..emote),info.r,info.g,info.b,info.id);
	end
end

function GetSpamListeTable()
	local myTable = {};
	local index = 1;
	local ok = true;
	local reste = TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectList"];
	while ok do
		local indice = string.find(reste,"\n");

		if indice then -- Fin de ligne
			myTable[index] = string.sub(reste,1,indice-1);
			reste = string.sub(reste,indice+1);
			index = index + 1;
		else -- Fin de texte
			ok = false;
			if reste ~= "" then
				myTable[index] = reste;
			end
		end
	end
	
	return myTable;
end

function hookMyFrameEvent()
	function totalRP_ChatFrame_OnEvent( self, event, ... )
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = ...;
		local Affiche=1;
		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12);
		
		if TRP_Module_Configuration["Modules"]["Communication"]["SpamDetect"] then
			if (event == "CHAT_MSG_SAY") or (event == "CHAT_MSG_YELL") or (event == "CHAT_MSG_WHISPER" and not string.find( arg1, "<LoRe5>" )) then
				local onSort = false;
				local motTable = GetSpamListeTable();
				table.foreach(motTable,function(mot) 
					local ok,ret = pcall(strfind,arg1,motTable[mot]);
					if not ok then
						TRPError("Pattern de spam-detect foireux ! : "..tostring(motTable[mot]));
					elseif ret then
						onSort = true;
					end
				end);
				if onSort then
					if TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"] and TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"] ~= "" then
						local message = "{o}   --------------\nSpam from {w}|Hplayer:"..arg2.."|h["..arg2.."]|h\n{o}Message : {w}\n\"";
						message = message..arg1.."\"\n{o}À {v}"..date("%Hh%M").."\n{o}--------------";
						getglobal("ChatFrame"..TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"]):AddMessage(setTRPColorToString(message),1,1,1);
					end
					return;
				end
			end
		end
		
		--Detection HRP :
		if TRP_Module_Configuration["Modules"]["Communication"]["UseTRPChat"] then
			if (event == "CHAT_MSG_SAY") or (event == "CHAT_MSG_YELL") or (event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_RAID") or 
				(event == "CHAT_MSG_GUILD") or (event == "CHAT_MSG_OFFICER") or (event == "CHAT_MSG_RAID_LEADER") or (event == "CHAT_MSG_PARTY_LEADER")
				or (event == "CHAT_MSG_WHISPER" and not string.find( arg1, "<LoRe5>" )) 
				or (event == "CHAT_MSG_WHISPER_INFORM" and not string.find( arg1, "<LoRe5>" ))	then
				FragmenterDialogue(arg1,arg2,arg3,arg6,arg7,self,event,coloredName);
				Affiche = 0;
			elseif (event == "CHAT_MSG_EMOTE") or (event == "CHAT_MSG_TEXT_EMOTE") then
				AnalyserEmote(arg1,arg2,self,event,coloredName);
				Affiche = 0;
			end
		end
		
		if Lore_ChatFrame_OnEvent then
			Affiche = handleLoreCompatibilite(Affiche,self, event, ...);
		end
		
		if (Affiche == 1) then
			Saved_ChatFrame_OnEvent( self, event, ... );
		end
	end
	if Lore_ChatFrame_OnEvent then
		Saved_ChatFrame_OnEvent = Lore_ChatFrame_OnEvent;
	else
		Saved_ChatFrame_OnEvent = ChatFrame_OnEvent;
	end
	ChatFrame_OnEvent = totalRP_ChatFrame_OnEvent;
end

function TRPUnhookAll()
	if Lore_ChatFrame_OnEvent then
		Lore_ChatFrame_OnEvent = Saved_ChatFrame_OnEvent;
	else
		ChatFrame_OnEvent = Saved_ChatFrame_OnEvent;
	end
	SendChatMessage = SavedSendChatMessage;
	FCF_OpenNewWindow = SavedFCF_OpenNewWindow;
	
	Saved_ChatFrame_OnEvent = nil;
	SavedSendChatMessage = nil;
	SavedFCF_OpenNewWindow = nil;
end

function TRPHookAll()
	hookMyBigChat(); -- Hook du chat pour la modification de paroles.
	hookMyNewFrame(); -- Hook de la création d'une nouvelle fenêtre.
	hookMyFrameEvent(); -- Hook de la réception de message dans la frame
end

--Comptatibilité avec Lore
--(Dieu qu'ils ont codé ça comme des cochons ....)
function handleLoreCompatibilite(Affiche ,self, event, ... )
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
	
	-- Quand on recois une traduction Lore
	if( event == "CHAT_MSG_WHISPER" ) then
		if ( string.find( arg1, "<LoRe5>" ) ) then
			Lore_debugger("040 Lore answer received from " .. arg2);
			Lore_HookEvent = Lore_HookEvent + 1;
			Affiche = 0;
			if ( Lore_PrevMsg ~= arg1 ) then
				if (arg2 == Lore_PrevRequestName) and (Lore_PreviousRequestCount > 0) then
					Lore_PreviousRequestCount = Lore_PreviousRequestCount - 1;
					local temp_LoreSkill = Lore_CurrentSkill;
					Lore_CurrentSkill = Lore_PrevRequestSkill;
					Lore_PartialTrans = 1;
					Lore_debugger("026 Translation activated: Partial");
					arg1 = string.gsub( arg1, "([^%a]*)([%a]*)", Lore_Translate );
					Lore_CurrentSkill = temp_LoreSkill;
				end
				-- Faire intervenir les options de TRP pour le choix de la fenetre
				local tab = TRP_Module_Configuration["Modules"]["Communication"];
				local color = "|cff"..deciToHexa(tab["LoreColorR"])..deciToHexa(tab["LoreColorG"])..deciToHexa(tab["LoreColorB"]);
				if TRP_Module_Registre[Royaume][arg2] and TRP_Module_Registre[Royaume][arg2]["Prenom"] and TRP_Module_Registre[Royaume][arg2]["Prenom"] ~= "" then
					arg2 = TRP_Module_Registre[Royaume][arg2]["Prenom"];
				elseif arg2 == Joueur and TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] ~= "" then
					arg2 = TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"];
				end
				if TRP_Module_Configuration["Modules"]["Communication"]["LoreFrameCheck"] and TRP_Module_Configuration["Modules"]["Communication"]["LoreFrame"] ~= "" then
					getglobal("ChatFrame"..TRP_Module_Configuration["Modules"]["Communication"]["LoreFrame"]):AddMessage(color.."["..arg2.."] : ".. string.sub( arg1, 8, string.len(arg1) ), 1, 0.75, 0 );
				else
					DEFAULT_CHAT_FRAME:AddMessage(color.."["..arg2.."] : "..string.sub( arg1, 8, string.len(arg1) ), 1, 0.75, 0 );
				end
				Lore_PrevMsg = arg1; -- for antiduplicate
			end
		else
			Lore_debugger("040 Whisper received, not recognised as LORE whisper");
		end
	end
	
	-- Quand on envoie une traduction � quelqu'un (pour pas que le whisp s'affiche)
	if( event == "CHAT_MSG_WHISPER_INFORM" ) then
		if ( string.find( arg1, "<LoRe5>" ) ) then
			Lore_debugger("041 Lore answer sent to " .. arg2 );
			Lore_HookEvent = Lore_HookEvent + 1;
			Affiche = 0;
			if (string.find( arg1, "test executed." )) then
				Lore_Text_SelfTest:SetText("Self-test: Stage 3 - Self-test completed\nSuccess: Auto-translation should work.");
				Lore_Text_SelfTest:SetTextColor(0.1, 1.0, 0.1);
			end
		else
			Lore_debugger("041 Whisper inform, not recognised as LORE whisper");
		end
	end
	
	-- Le d�tecteur de language marqu�, avec envoi de requete.
	if ( ( arg2 ~= Lore_Name ) and ( arg1 ~= nil ) ) then -- Si le gars qui a caus� n'est pas moi et qu'il a dit quelque chose de concret.
		if ( event == "CHAT_MSG_SAY" ) or ( event == "CHAT_MSG_YELL" ) or ( event == "CHAT_MSG_MONSTER_SAY" ) or ( event == "CHAT_MSG_MONSTER_YELL" ) or ( event == "CHAT_MSG_PARTY" ) or ( event == "CHAT_MSG_RAID" ) or ( event == "CHAT_MSG_GUILD" ) or ( event == "CHAT_MSG_OFFICER" ) then
			local index = 0; -- index de la table des langues
			local i = 0;
			local lang1 = "";
			local langskill = 100;
			local monlan = ""; -- Tag de language propre � wow (Par exemple : Darnassien)

			--  On v�rifie si le language est un des language de wow, sauf le commun. (Par exemple : Darnassien)
			if ( ( arg3 ~= ALLIANCE_COMMON) and ( arg3 ~= HORDE_COMMON ) ) then
				monlan = " " .. arg3;
			end

			-- Check if a default or custom language is used and on the tablet (find by tag)
			if ( table.getn( Lore_Cycle[ Lore_Name ] ) > 0 ) then --Si il existe au moins une langue dans ma table des langue
				for i = 1, table.getn( Lore_Cycle[ Lore_Name ] ), 1 do -- Pour chaque langue de ma table des langue
					if ( string.find( monlan .. arg1, Lore_Cycle[ Lore_Name ][i] ) == 2 ) then -- Si on trouve le tag d'une de mes langue dans le message
						-- On a trouv� le bon language, adaptation du skill ...etc
						index = i;
						lang1 = Lore_Cycle[ Lore_Name ][i];
						langskill = tonumber(Lore_Skill[ Lore_Name ][i]);
					end
				end
			end

			-- Si on a pas trouv� le bon language parmis mes languages, et que la langue du message est en commun
			if ( ( index == 0 ) and ( ( arg3 == ALLIANCE_COMMON) or ( arg3 == HORDE_COMMON ) ) ) then
				if ( table.getn( Lore_Cycle[ Lore_Name ] ) > 0 ) then -- On refait une recherche
					for i = 1, table.getn( Lore_Cycle[ Lore_Name ] ), 1 do -- Dans la table de mes langues
						if ( arg3 == Lore_Cycle[ Lore_Name ][i] ) then -- On check si on cause le commun
							-- On a trouv� le bon language commun, adaptation du skill ...etc
							index = i;
							lang1 = Lore_Cycle[ Lore_Name ][i];
							langskill = tonumber(Lore_Skill[ Lore_Name ][i]);
						end
					end
				end
			end

			-- On continue uniquement si on a trouv� le language ad�quat
			if ( index > 0 ) then
				-- On prend en compte le skill du language
				if ( langskill < 100 ) then
					if not ( (Lore_Screen==1) and ( ( event == "CHAT_MSG_PARTY" ) or ( event == "CHAT_MSG_RAID" ) or ( event == "CHAT_MSG_GUILD" ) or ( event == "CHAT_MSG_OFFICER" ) ) ) then
						local temp_LoreSkill = Lore_CurrentSkill;
						Lore_CurrentSkill = langskill;
						Lore_PartialTrans = 1;
						Lore_debugger("026 Translation activated: Partial");
						arg1 = string.gsub( arg1, "([^%a]*)([%a]*)", Lore_Translate );
						Lore_CurrentSkill = temp_LoreSkill;
					end
				end
				-- Et on fait notre putain de requete sur le channel xtensionxtooltip2.
				if ( ( GetChannelName( "xtensionxtooltip2" ) > 0 ) and ( Lore_Autotrans ~= -1 ) and ( arg2 ~= Lore_Name ) and ( event ~= "CHAT_MSG_MONSTER_SAY" ) and ( event ~= "CHAT_MSG_MONSTER_YELL" ) and ( lang1 ~= ALLIANCE_COMMON ) and ( lang1 ~= HORDE_COMMON ) ) then
					if ( GetNumLanguages() > 0 ) then
						local langbydefault = 0;
						for j = 1, GetNumLanguages(), 1 do
							if (lang1 == GetLanguageByIndex( j )) then
								langbydefault = 1;
							end
						end
						if (langbydefault == 0) then
							Lore_debugger("042 Translation request sent to " .. arg2);
							Lore_SendChatMessage( "LORE::TR::" .. arg2 , "CHANNEL", GetDefaultLanguage(), GetChannelName( "xtensionxtooltip2" ) );
							Lore_PrevRequestSkill = langskill;
							if (Lore_PrevRequestSkill ~= 100) then
								if arg2 == Lore_PrevRequestName then
									-- send another request
									Lore_PreviousRequestCount = Lore_PreviousRequestCount + 1;
									if Lore_PreviousRequestCount > 10 then
										Lore_PreviousRequestCount = 5;
									end
								else
									Lore_PreviousRequestCount = 1;
									Lore_PrevRequestName = arg2;
								end
							else
								Lore_PreviousRequestName = "";
								Lore_PreviousRequestCount = 0;
							end
						end
					end
				end
			end
		end
	end
	
	
	--On jete un oeil sur le channel xtensionxtooltip2 pour y choper les requetes
	if ( Lore_HookEvent > 0 ) then -- Si on a d�ja trait� le message d'une mani�re ou d'une autre, on ne traite pas xtensionxtooltip2
		if( ( event == "CHAT_MSG_SYSTEM" ) or ( event == "CHAT_MSG_WHISPER_INFORM" ) or (event == "CHAT_MSG_CHANNEL") or ( event == "CHAT_MSG_WHISPER" and string.find( arg1, "<LoRe5>" ) ) ) then
			Lore_HookEvent = Lore_HookEvent - 1;
			Affiche = 0;
		end
	else -- En gros il veut pas traiter le channel si on est d�j� en train de faire autre chose
		if(event == "CHAT_MSG_CHANNEL") then
			if ( arg9 == "xtensionxtooltip2" ) then
				if ( arg1 == "LORE::TR::" .. Lore_Name ) or ( arg1 == "Lore, tr, " .. Lore_Name .. "." ) then -- Si c'est une requete
					-- On envoi notre derni�re traduction en date au joueur.
					if ( ( Lore_LastSaid ~= "" ) and ( LoreToPlayer ~= arg2 ) and not( Lore_isInBanlist( arg2 ) ) ) then
						Lore_debugger("043 Translation Request received from " .. arg2);
						Lore_PrevMsg = arg1;
						LoreToPlayer = arg2;
						Lore_SendChatMessage( "<LoRe5>" .. Lore_LastSaid , "WHISPER", GetDefaultLanguage(), arg2 );
						Lore_debugger("044 Translation sent to " .. arg2);
					else
						if ( Lore_isInBanlist( arg2 ) ) then -- Sauf si ce trou de bal est banni
							Lore_debugger("Translation request denied; Player in banlist");
						end
					end
				end
				-- On r�agis en plus si la personne qui nous emmerde est ... nous m�me !
				if ( arg1 == "LORE::ST::" .. Lore_Name ) or ( arg1 == "Lore, the Sunken Temple, " .. Lore_Name .. "." ) then -- latter is a Eloquence fix. Damn Eloquence!
					-- C'est le fameux test totalement useless
					Lore_Text_SelfTest:SetText("Self-test: Stage 2 - ST request received\nFailed: Tell not sent or not recog.");
					Lore_SendChatMessage( "<LoRe5> Self-test executed. Auto-translation works properly.", "WHISPER", GetDefaultLanguage(), arg2 );
				end
				if ( arg1 == "LORE::LR::" .. string.lower( Lore_Name ) ) or ( arg1 == "Lore, lr, " .. Lore_Name .. "." ) then -- latter is a Eloquence fix. Damn Eloquence!
					-- Ah, je savais meme pas qu'on pouvais demander � quelqu'un la liste des language qu'il connais
					if ( LoreToPlayer ~= arg2 ) then
						if ( table.getn( Lore_Cycle[ Lore_Name ] ) > 0 ) then
							Lore_PrevMsg = arg1;
							LoreToPlayer = arg2;
							Lore_debugger("045 Language Request received from " .. arg2);
							if ( Lore_Autotrans == 0 ) then
								s = "I understand ";
								for i = 1, table.getn( Lore_Cycle[ Lore_Name ] ), 1 do
									if ( i > 1 ) then
										s = s .. ", ";
									end
									s = s .. Lore_Cycle[ Lore_Name ][i];
									if ( tonumber(Lore_Skill[ Lore_Name ][i]) < 100 ) then
										s = s .. "(" .. Lore_Skill[ Lore_Name ][i] .. "%)";
									end
								end
								Lore_SendChatMessage( "<LoRe5>" .. s, "WHISPER", GetDefaultLanguage(), arg2 );
							else
								Lore_SendChatMessage( "<LoRe5>OOC: I have auto-translation switched off, won't get translations.", "WHISPER", GetDefaultLanguage(), arg2 );
							end
						else
							SendChatMessage( "<LoRe5>I don't know any languages.", "WHISPER", GetDefaultLanguage(), arg2 );
						end
					end
				end
				if ( (arg1 == "LORE::VER::" .. string.lower( strsub( Lore_Name, 1 )) or arg1 == "Lore, ver, " .. strsub( Lore_Name, 1 ) .. "." ) and ( Lore_PrevMsg ~= arg1 ) ) then
					-- send your Lore version number to the requesting player
					Lore_debugger("046 Version Request received from " .. arg2);
					Lore_PrevMsg = arg1;
					Lore_SendChatMessage( "<LoRe5>OOC: My Lore version is v" .. Lore_Version , "WHISPER", GetDefaultLanguage(), arg2 );
				end

				Affiche = 1;
			end
		end
	end
	
	return Affiche;
end
