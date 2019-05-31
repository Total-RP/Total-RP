function AideClick(nom)
	TRPAideFrame:Show();
	if TEXTE_AIDE_BUTTON[nom] ~= nil then
		AideCreaObjText:SetText(TEXTE_AIDE_BUTTON[nom]["Nom"]);
		CreaObjScrollAideText:SetText(setTRPColorToString(TEXTE_AIDE_BUTTON[nom]["Texte"]));
	else
		AideCreaObjText:SetText();
		CreaObjScrollAideText:SetText("There is no help yet for this option");
	end
end

function setManualAide(titre,message)
	AideCreaObjText:SetText(titre);
	CreaObjScrollAideText:SetText(setTRPColorToString(message));
	TRPAideFrame:Show();
end

function TRPError(message)
	sendMessage("{r}"..message);
	UIErrorsFrame:AddMessage(message, 1.0, 0.0, 0.0, 53, 5);
end

function deciToHexa(number)
	number = math.floor(number*255);
	local num1 = math.fmod(number, 16);
	local num2 = math.floor(number/16);
	if num2 == 10 then
		num2 = "A";
	elseif num2 == 11 then
		num2 = "B";
	elseif num2 == 12 then
		num2 = "C";
	elseif num2 == 13 then
		num2 = "D";
	elseif num2 == 14 then
		num2 = "E";
	elseif num2 == 15 then
		num2 = "F";
	end
	if num1 == 10 then
		num1 = "A";
	elseif num1 == 11 then
		num1 = "B";
	elseif num1 == 12 then
		num1 = "C";
	elseif num1 == 13 then
		num1 = "D";
	elseif num1 == 14 then
		num1 = "E";
	elseif num1 == 15 then
		num1 = "F";
	end
	return ""..num2..num1;
end


function setTRPColorToString(text,colorDelete)

	if not text then return "" end;

	if colorDelete then
		text = string.gsub(text,"{r}","");
		text = string.gsub(text,"{v}","");
		text = string.gsub(text,"{b}","");
		text = string.gsub(text,"{j}","");
		text = string.gsub(text,"{p}","");
		text = string.gsub(text,"{c}","");
		text = string.gsub(text,"{w}","");
		text = string.gsub(text,"{n}","");
	    text = string.gsub(text,"{o}","");
		text = string.gsub(text,"{(%x%x%x%x%x%x)}","");
		text = string.gsub(text,"{li}","");
	else
		text = string.gsub(text,"{r}","|cffff0000");
		text = string.gsub(text,"{v}","|cff00ff00");
		text = string.gsub(text,"{b}","|cff0000ff");
		text = string.gsub(text,"{j}","|cffffff00");
		text = string.gsub(text,"{p}","|cffff00ff");
		text = string.gsub(text,"{c}","|cff00ffff");
		text = string.gsub(text,"{w}","|cffffffff");
		text = string.gsub(text,"{n}","|cff000000");
		text = string.gsub(text,"{o}","|cffffaa00");
		text = string.gsub(text,"{(%x%x%x%x%x%x)}","|cff%1");
		text = string.gsub(text,"{li}","\n");
	end
	
	text = string.gsub(text,"{ba}","||");
	local x,y = generateCoordonnees();
	text = string.gsub(text,"{cx}",x);
	text = string.gsub(text,"{cy}",y);
	text = string.gsub(text,"{csz}",tostring(GetSubZoneText()));
	
	if UnitName("target") and UnitIsPlayer("target") then
		local classeT = UnitClass("target");
		local raceT = UnitRace("target");
		local nomT = UnitName("target");
		text = string.gsub(text,"{%%tCla}",classeT);
		text = string.gsub(text,"{%%tRac}",raceT);
		text = string.gsub(text,"{%%tcla}",string.lower(classeT));
		text = string.gsub(text,"{%%trac}",string.lower(raceT));
		if TRP_Module_Registre[Royaume][nomT] then
			if TRP_Module_Registre[Royaume][nomT]["Nom"] then
				text = string.gsub(text,"{%%tnom}",TRP_Module_Registre[Royaume][nomT]["Nom"]);
			else
				text = string.gsub(text,"{%%tnom}","");
			end
			if TRP_Module_Registre[Royaume][nomT]["Prenom"] then
				text = string.gsub(text,"{%%tpre}",TRP_Module_Registre[Royaume][nomT]["Prenom"]);
			else
				text = string.gsub(text,"{%%tpre}","");
			end
			if TRP_Module_Registre[Royaume][nomT]["Origine"] then
				text = string.gsub(text,"{%%tori}",TRP_Module_Registre[Royaume][nomT]["Origine"]);
			else
				text = string.gsub(text,"{%%tori}","");
			end
			if TRP_Module_Registre[Royaume][nomT]["Age"] then
				text = string.gsub(text,"{%%tage}",TRP_Module_Registre[Royaume][nomT]["Age"]);
			else
				text = string.gsub(text,"{%%tage}","");
			end
			if TRP_Module_Registre[Royaume][nomT]["Titre"] then
				text = string.gsub(text,"{%%ttit}",TRP_Module_Registre[Royaume][nomT]["Titre"]);
			else
				text = string.gsub(text,"{%%ttit}","");
			end
			text = string.gsub(text,"{%%tnot}",nomComplet(nomT));
		end
		-- Changement du %t en Prenom TRP
		if string.find(text,"%%t") then
			if TRP_Module_Registre[Royaume][nomT] and TRP_Module_Registre[Royaume][nomT]["Prenom"] then
				text = string.gsub(text,"%%t",TRP_Module_Registre[Royaume][nomT]["Prenom"]);
			elseif nomT == Joueur then
				text = string.gsub(text,"%%t",TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"]);
			else
				text = string.gsub(text,"%%t",nomT);
			end
		end
	else
		text = string.gsub(text,"{%%t","{");
	end
	
	if UnitName("target") then
		local nom = UnitName("target")
		text = string.gsub(text,"%%t",nom);
	end
	local i=0;
	while string.find(text,"{rand%d%d%d}") and i<5 do
		local number = tonumber(string.sub(text,string.find(text,"{rand%d+}") + 5,string.find(text,"{rand%d+}") + 7));
		text = string.gsub(text,"{rand%d%d%d}",math.random(number),1);
		i = i+1;
	end
	
	text = string.gsub(text,"{no}",Joueur);
	text = string.gsub(text,"{nom}",TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"]);
	text = string.gsub(text,"{pre}",TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"]);
	text = string.gsub(text,"{ori}",TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"]);
	text = string.gsub(text,"{age}",TRP_Module_PlayerInfo[Royaume][Joueur]["Age"]);
	text = string.gsub(text,"{tit}",TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"]);
	text = string.gsub(text,"{not}",nomComplet(Joueur));
	local classe = UnitClass("player");
	local race = UnitRace("player");
	text = string.gsub(text,"{Cla}",classe);
	text = string.gsub(text,"{Rac}",race);
	text = string.gsub(text,"{cla}",string.lower(classe));
	text = string.gsub(text,"{rac}",string.lower(race));

	i=0;
	while string.find(text,"{%[.+%].+%<%>.+}") and i<200 do
		--debugMess(text,true);
		--local start = string.find(text,"{%[.+%].+%<%>.+}");
		--local final = string.find(text,"}",start);
		local x = string.find(string.reverse(text),"%{");
		local n = string.len(text);
		local start = - x + n + 1;
		local final = string.find(text,"}",start);
		local mode = "player";
		
		--debugMess("start "..tostring(start))
		--debugMess("final "..tostring(final))
		
		if not final or final <= start or not string.find(text,"%[",start) or not string.find(text,"%]",start) then
			break;
		end
		local debutOption = string.find(text,"%[",start)+1;
		local FinOption = string.find(text,"%]",start)-1;

		local Options = {};
		
		if string.sub(text,debutOption,debutOption) == "%" then
			debutOption = debutOption + 1;
			mode = "target";
		elseif string.sub(text,debutOption,debutOption) == "*" then
			debutOption = debutOption + 1;
			mode = "mouseover";
		end

		local k = 1;
		while string.find(string.sub(text,debutOption,FinOption),"%$") and i<200 do
			Options[k] = string.sub(text,debutOption,string.find(text,"%$",debutOption)-1);
			debutOption = string.find(text,"%$",debutOption)+1;
			if debutOption >= FinOption then break end;
			k = k+1;
			i=i+1;
		end
		if debutOption < FinOption then
			return text;
		end
		
		local Oui = string.sub(text,FinOption+2,string.find(text,"%<%>",FinOption)-1);
		local Non = string.sub(text,string.find(text,"%<%>",FinOption)+2,string.find(text,"%}",start)-1);
		local nextTo;
		
		local reponse = checkConditionString(Options,mode);
		
		if reponse == true then
			nextTo = string.sub(text,1,start-1)..Oui..string.sub(text,final+1);
			text = nextTo;
		elseif reponse == false then
			nextTo = string.sub(text,1,start-1)..Non..string.sub(text,final+1);
			text = nextTo;
		else
			break;
		end

		i=i+1;
	end

	--i=0;
	--while string.find(text,"%[son%:.+%]") and i<10 do
	--	local debut = string.find(text,"%[son%:.+%]");
	--	local son = string.sub(text,string.find(text,"%[son%:.+%]"));
	--	son =  string.sub(son,1,string.find(son,"%]"));
	--	local url =  string.sub(son,6,-2);
	--	DEFAULT_CHAT_FRAME:AddMessage(tostring(url),1,1,1);
	--	if TRP_LISTE_SOUNDS[url] then
	--		TRPPlaySoundGlobal(TRP_LISTE_SOUNDS[url]["Url"],false,false);
	--		TRPPlaySound(TRP_LISTE_SOUNDS[url]["Url"])
	--		DEFAULT_CHAT_FRAME:AddMessage(tostring(TRP_LISTE_SOUNDS[url]["Url"]),1,1,1);
	--	end
	--	text = string.sub(text,1,debut-1)..string.sub(text,debut+string.len(son));
	--	i = i + 1;
	--end

	return text;
end

function VerifierConditions(conditions,cible)
	local i=1;
	local k = 1;
	local Options = {};
	while string.find(conditions,"%$") and i<10 do
		Options[k] = string.sub(conditions,1,string.find(conditions,"%$")-1);
		conditions = string.sub(conditions,string.len(Options[k])+2);
		k = k+1;
		i=i+1;
	end
	return checkConditionString(Options,cible);
end

function checkConditionString(options,cible)
	local condition = true;
	
	if not options or #options == 0 then
		return nil;
	end
	
	if not UnitName(cible) then
		return false;
	end
	
	table.foreach(options,
		function(option)
			local prefixe = string.sub(options[option],1,3);
			local arguments;
			if string.find(options[option],"%:") then
				arguments = string.sub(options[option],string.find(options[option],"%:")+1);
			end
			
			--debugMess("Prefixe = "..prefixe,true);
			--debugMess("Arguments = "..tostring(arguments),true);
			
			--Securité
			if not string.match(prefixe,"%l%l%l") then -- Le prefixe doit etre une succession de 3 lettres minuscules
				condition = nil;
				return;
			end
			
			if prefixe == "sex" then
				condition = checkConditionStringSex(arguments,cible);
			elseif prefixe == "rac" then
				condition = condition and checkConditionStringRace(arguments,cible);
			elseif prefixe == "cla" then
				condition = condition and checkConditionStringClasse(arguments,cible);
			elseif prefixe == "nom" then
				condition = condition and checkConditionStringNom(arguments,cible);
			elseif prefixe == "eta" then
				condition = condition and checkConditionStringEtat(arguments,cible);
			elseif prefixe == "typ" then
				condition = condition and checkConditionStringType(arguments,cible);
			elseif prefixe == "fam" then
				condition = condition and checkConditionStringFamille(arguments,cible);
			elseif prefixe == "tar" then
				condition = condition and checkConditionStringTarget(arguments);
			elseif prefixe == "ran" then
				condition = condition and checkConditionStringRandom(arguments);
			elseif prefixe == "heu" then
				condition = condition and checkConditionStringHeure(arguments);
			elseif prefixe == "con" then
				condition = condition and checkConditionStringContinent(arguments);
			elseif prefixe == "zon" then
				condition = condition and checkConditionStringZone(arguments);
			elseif prefixe == "szo" then
				condition = condition and checkConditionStringSousZone(arguments);
			elseif prefixe == "coo" then
				condition = condition and checkConditionStringCoord(arguments);
			elseif prefixe == "sta" then
				condition = condition and checkConditionStringStatutRP(arguments,cible);
			elseif string.len(prefixe) == 3 then
				TRPError("Synthax error in test : Unknown prefix \""..tostring(prefixe).."\".");
				condition = nil;
				return;
			end
			if condition == false then
				return;
			end
	end);
		
	return condition;
end

function checkConditionStringCoord(arguments)
	if arguments == "" or not arguments or not string.find(arguments,"%d+%-%d+%-%d+") then
		return nil;
	end
	local x = tonumber(string.sub(arguments,1,string.find(arguments,"%-")-1));
	local y = tonumber(string.sub(arguments,string.find(arguments,"%-")+1,string.find(arguments,"%-",string.find(arguments,"%-")+1)-1));
	local aire = tonumber(string.sub(arguments,string.find(arguments,"%-",string.find(arguments,"%-")+1)+1));
	local actuX,actuY = generateCoordonnees();
	return actuX-aire <= x and actuX+aire >= x  and actuY-aire <= y and actuY+aire >= y;
end

function checkConditionStringContinent(arguments)
	if arguments == "" or not arguments then
		return nil;
	end
	return tostring(GetCurrentMapContinent()) == arguments;
end

function checkConditionStringZone(arguments)
	if arguments == "" or not arguments then
		return nil;
	end
	return tostring(GetCurrentMapZone()) == arguments;
end

function checkConditionStringSousZone(arguments)
	if arguments == "" or not arguments then
		return nil;
	end
	return tostring(GetSubZoneText()) == arguments;
end

function checkConditionStringStatutRP(arguments,cible)
	if arguments ~= "rp" and arguments ~= "hrp" then
		return nil;
	end

	local nom = UnitName(cible);
	if not nom then
		return false;
	end
	if nom == Joueur then
		if arguments == "rp" then
			return TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] == 2;
		else
			return TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] == 1;
		end
	else
		if TRP_Module_Registre[Royaume][nom] then
			if arguments == "rp" then
				return TRP_Module_Registre[Royaume][nom]["StatutRP"] == 2;
			else
				return TRP_Module_Registre[Royaume][nom]["StatutRP"] == 1;
			end
		else
			return false;
		end
	end
end

function checkConditionStringHeure(arguments)
	if arguments == "" or not arguments or not string.find(arguments,"%d%d%-%d%d") then
		return nil;
	end
	local heure = tonumber(date("%H"));
	local heureDebut = tonumber(string.sub(arguments,1,2));
	local heureFin = tonumber(string.sub(arguments,4,5));
	if heureDebut < heureFin then
		return heure >= heureDebut and heure <= heureFin;
	else
		return not (heure < heureDebut and heure > heureFin);
	end
end

function checkConditionStringEtat(arguments,cible)
	if arguments ~= "m" and arguments ~= "v" then
		return nil;
	end
	if arguments == "m" then
		return UnitIsDead(cible);
	elseif arguments == "v" then
		return UnitIsAlive(cible);
	end
end

function checkConditionStringNom(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	return UnitName(cible) == arguments;
end

function checkConditionStringRandom(arguments)
	if arguments == "" or not arguments or not string.find(arguments,"%d+%-%d+") then
		return nil;
	end
	local top = string.sub(arguments,1,string.find(arguments,"%-")-1);
	local down = string.sub(arguments,string.find(arguments,"%-")+1);
	return math.random(tonumber(top)) >= tonumber(down);
end

function checkConditionStringSex(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	if (not string.find(arguments,"m") and not string.find(arguments,"f")) or string.len(arguments) > 1 then
		return nil;
	elseif arguments == "f" then
		return UnitSex(cible) == 3;
	elseif arguments == "m" then
		return UnitSex(cible) == 2;
	end
end

function checkConditionStringType(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	local secu=1;
	local indice = 1;
	local retour = true;
	local Type = string.lower(string.sub(tostring(UnitCreatureType(cible)),1,3));

	while string.len(string.sub(arguments,indice)) > 1 and secu<20 do
		local test = string.sub(arguments,indice,indice+2);
		local negatif = false;
		if string.sub(test,1,1) == "-" then
			test = string.sub(arguments,indice+1,indice+3);
			negatif = true;
		end
		if negatif then
			if string.lower(test) == Type then
				retour = false;
			end
			indice = indice + 4;
		else
			if string.lower(test) ~= Type then
				retour = false;
			end
			indice = indice + 3;
		end
		secu = secu+1;
	end
	return retour;
end

function checkConditionStringFamille(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	local secu=1;
	local indice = 1;
	local retour = true;
	local Type = string.lower(string.sub(tostring(UnitCreatureFamily(cible)),1,3));

	while string.len(string.sub(arguments,indice)) > 1 and secu<20 do
		local test = string.sub(arguments,indice,indice+2);
		local negatif = false;
		if string.sub(test,1,1) == "-" then
			test = string.sub(arguments,indice+1,indice+3);
			negatif = true;
		end
		if negatif then
			if string.lower(test) == Type then
				retour = false;
			end
			indice = indice + 4;
		else
			if string.lower(test) ~= Type then
				retour = false;
			end
			indice = indice + 3;
		end
		secu = secu+1;
	end
	return retour;
end

function checkConditionStringRace(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	local secu=1;
	local indice = 1;
	local retour = true;
	local bidon2, race = UnitRace(cible);
	race = string.lower(string.sub(race,1,2));
	while string.len(string.sub(arguments,indice)) > 1 and secu<20 do
		local test = string.sub(arguments,indice,indice+1);
		local negatif = false;
		if string.sub(test,1,1) == "-" then
			test = string.sub(arguments,indice+1,indice+2);
			negatif = true;
		end
		if negatif then
			if string.lower(test) == race then
				retour = false;
			end
			indice = indice + 3;
		else
			if string.lower(test) ~= race then
				retour = false;
			end
			indice = indice + 2;
		end
		secu = secu+1;
	end
	return retour;
end

function checkConditionStringClasse(arguments,cible)
	if arguments == "" or not arguments then
		return nil;
	end
	local secu=1;
	local indice = 1;
	local retour = true;
	local bidon ,classe = UnitClass(cible);
	classe = string.lower(string.sub(classe,1,2));
	while string.len(string.sub(arguments,indice)) > 1 and secu<20 do
		local test = string.sub(arguments,indice,indice+1);
		local negatif = false;
		if string.sub(test,1,1) == "-" then
			test = string.sub(arguments,indice+1,indice+2);
			negatif = true;
		end
		if negatif then
			if string.lower(test) == classe then
				retour = false;
			end
			indice = indice + 3;
		else
			if string.lower(test) ~= classe then
				retour = false;
			end
			indice = indice + 2;
		end
		secu = secu+1;
	end
	return retour;
end

function checkConditionStringTarget(arguments)
	if not arguments or arguments == "" then
		return UnitName("target") ~= nil and UnitName("target") ~= Joueur;
	else
		return UnitName("target") ~= nil and UnitName("target") == arguments;
	end
end

function TRPPlaySound(soundFile)
	if GetCVar("Sound_EnableSFX") == "1" and TRP_Module_Configuration["Modules"]["Sons"]["Activate"] then
		PlaySoundFile(""..soundFile..".wav"); 
		PlaySoundFile(""..soundFile..".mp3");
	end
	return false;
end

function decouperForTooltip(text,taille,Rouge,Vert,Bleu,bColor)
	local ok = true;
	local morceaux = text;
	local texte;
	while ok do
		local indice = string.find(morceaux," ",taille);
		local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1);
		if passageLigne then -- On a trouvé un passage à la ligne
			texte = string.sub(morceaux,1,passageLigne-1);
			morceaux = string.sub(morceaux,passageLigne+1);
		elseif indice then -- Fin de ligne
			texte = string.sub(morceaux,1,indice);
			if string.len(string.sub(morceaux,1,indice)) > taille then
				taille = string.len(string.sub(morceaux,1,indice))
			end
			morceaux = string.sub(morceaux,indice+1);
		else -- Fin de texte
			ok = false;
			texte = morceaux;
		end
		if bColor then
			texte = setTRPColorToString(texte);
		end
		if texte == "" then
			texte = " ";
		end
		GameTooltip:AddLine(texte, Rouge, Vert, Bleu);
	end
end

function decouperText(text,taille)
	local ok = true;
	local morceaux = text;
	local textFinal = "";
	while ok do
		local indice = string.find(morceaux," ",taille);
		if indice == nil then
			ok = false;
			textFinal = textFinal..morceaux;
		else
			textFinal = textFinal..string.sub(morceaux,1,indice).."\n";
			morceaux = string.sub(morceaux,indice);
		end
	end
	return textFinal;
end

function debugMess(mes,noTag)
	if TRP_Module_Configuration["Modules"]["General"]["bDebug"] then
		if mes == nil then mes = "nil" end
		if noTag then
			mes = "[TRP-DEBUG] "..mes;
		else
			mes = setTRPColorToString("{c}[TRP-DEBUG] {o}"..mes);
		end
		if TRP_Module_Configuration["Modules"]["General"]["DebugFrame"] and TRP_Module_Configuration["Modules"]["General"]["DebugFrame"] ~= "" then
			getglobal("ChatFrame"..TRP_Module_Configuration["Modules"]["General"]["DebugFrame"]):AddMessage(mes,1,1,1);
		else
			DEFAULT_CHAT_FRAME:AddMessage(mes,1,1,1);
		end
	end
end

function ErrorWithStack(msg)
   msg = msg.."\n"..debugstack()
   _ERRORMESSAGE(msg)
end

function sendMessage(mes,frame,backPrefix)
	local prefix = "[TRP] ";
	if backPrefix then prefix = "" end
	if mes == nil then mes = "nil" end
	if not frame or not string.find(frame,"[1-7]") then
		DEFAULT_CHAT_FRAME:AddMessage(setTRPColorToString("{w}"..prefix..mes),1,1,1);
	else
		getglobal("ChatFrame"..frame):AddMessage(setTRPColorToString("{w}"..prefix..mes),1,1,1);
	end
end

function reinitVariableTransfert()
	ExchangeTarget = nil;
	ExchangeRefTarget = nil;
end

function SetTRP_Module_Configuration()
		
	if TRP_Module_Configuration == nil then
		TRP_Module_Configuration = {};
	end
	if TRP_Module_Configuration["Modules"] == nil then
		TRP_Module_Configuration["Modules"] = {};
	end
	if TRP_Module_Configuration["Modules"]["General"] == nil then
		TRP_Module_Configuration["Modules"]["General"] = {};
	end
	if TRP_Module_Configuration["Modules"]["General"]["bDebug"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["bDebug"] = false;
	end
	if TRP_Module_Configuration["Modules"]["General"]["DebugFrame"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["DebugFrame"] = "";
	end
	if TRP_Module_Configuration["Modules"]["General"]["bCloseInCombat"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["bCloseInCombat"] = true;
	end
	if TRP_Module_Configuration["Modules"]["General"]["MiniMapIconDegree"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["MiniMapIconDegree"] = 210;
	end
	if TRP_Module_Configuration["Modules"]["General"]["MiniMapIconPosition"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["MiniMapIconPosition"] = 80;
	end
	if TRP_Module_Configuration["Modules"]["General"]["bNotifyNewVersion"] == nil then
		TRP_Module_Configuration["Modules"]["General"]["bNotifyNewVersion"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bForceUpdate"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bForceUpdate"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bNotifyAjout"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bNotifyAjout"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bRappel"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bRappel"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyle"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyle"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStylePersistant"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStylePersistant"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyleAlpha"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyleAlpha"] = 100;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bSendAlignement"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bSendAlignement"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"] == nil then
		TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"] = true;
	end
	
	if TRP_Module_Configuration["Modules"]["Documents"] == nil then
		TRP_Module_Configuration["Modules"]["Documents"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Documents"]["Niveau"] == nil then
		TRP_Module_Configuration["Modules"]["Documents"]["Niveau"] = 3;
	end

	if TRP_Module_Configuration["Modules"]["Inventaire"] == nil then
		TRP_Module_Configuration["Modules"]["Inventaire"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] == nil then
		TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] = 3;
	end
	if TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"] == nil then
		TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"] = "";
	end
	
	if TRP_Module_Configuration["Modules"]["Tooltip"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Use"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["SousTitre"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["SousTitre"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Actuellement"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Actuellement"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Description"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Description"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Alignement"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Alignement"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Relation"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Relation"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Humeur"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Humeur"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Guilde"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Guilde"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Couper"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["Couper"] = 100;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["CouperTitre"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["CouperTitre"] = 100;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["AideInventaire"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["AideInventaire"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["DocuInventaire"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["DocuInventaire"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Tooltip"]["BarreDeVie"] == nil then
		TRP_Module_Configuration["Modules"]["Tooltip"]["BarreDeVie"] = true;
	end
	
	if TRP_Module_Configuration["Modules"]["Actions"] == nil then
		TRP_Module_Configuration["Modules"]["Actions"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Actions"]["Alpha"] == nil then
		TRP_Module_Configuration["Modules"]["Actions"]["Alpha"] = 75;
	end
	if TRP_Module_Configuration["Modules"]["Actions"]["Lock"] == nil then
		TRP_Module_Configuration["Modules"]["Actions"]["Lock"] = false;
	end
	
	if TRP_Module_Configuration["Modules"]["Communication"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["AutoParenthese"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["AutoParenthese"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["UseTRPChat"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["UseTRPChat"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["HRPDetect"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["HRPDetect"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["EmoteDetect"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["EmoteDetect"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"] = "";
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["SpamDetect"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["SpamDetect"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectList"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectList"] = 
		"gamepowa\nWOWqueen\nwow%-europe%.cn\nfunnygold%.net\nPVPBank%.com\nselfgold%.com\ni g h e y %. c o m"
		.."\ncoolgolds%.com\nluckwar%.com\nPvPbank%.com";
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"] = 7;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["UseColorName"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["UseColorName"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["LoreFrameCheck"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["LoreFrameCheck"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["LoreFrame"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["LoreFrame"] = "";
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["LoreColorR"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["LoreColorR"] = 255;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["LoreColorG"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["LoreColorG"] = 255;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["LoreColorB"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["LoreColorB"] = 255;
	end
	if TRP_Module_Configuration["Modules"]["Communication"]["IconeRelation"] == nil then
		TRP_Module_Configuration["Modules"]["Communication"]["IconeRelation"] = true;
	end
	
	if TRP_Module_Configuration["Modules"]["Sons"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"] = {};
	end
	if TRP_Module_Configuration["Modules"]["Sons"]["Activate"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"]["Activate"] = true;
	end
	if TRP_Module_Configuration["Modules"]["Sons"]["Log"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"]["Log"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Sons"]["LogFrame"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"]["LogFrame"] = "6";
	end
	if TRP_Module_Configuration["Modules"]["Sons"]["AntiSpam"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"]["AntiSpam"] = false;
	end
	if TRP_Module_Configuration["Modules"]["Sons"]["AntiSpamCooldown"] == nil then
		TRP_Module_Configuration["Modules"]["Sons"]["AntiSpamCooldown"] = 0;
	end
end

function SetTRP_Module_Registre()
	if (TRP_Module_Registre == nil) then
		TRP_Module_Registre = {};
	end
	if (TRP_Module_Registre[Royaume] == nil) then
		TRP_Module_Registre[Royaume] = {};
	end
	if (TRP_Module_PlayerInfo_Relations == nil) then
		TRP_Module_PlayerInfo_Relations = {};
	end
	if (TRP_Module_PlayerInfo_Relations[Royaume] == nil) then
		TRP_Module_PlayerInfo_Relations[Royaume] = {};
	end
	if (TRP_Module_PlayerInfo_Notes == nil) then
		TRP_Module_PlayerInfo_Notes = {};
	end
	if (TRP_Module_PlayerInfo_Notes[Royaume] == nil) then
		TRP_Module_PlayerInfo_Notes[Royaume] = {};
	end
end

function SetTRP_Module_Inventaire()
	if (TRP_Module_Inventaire == nil) then
		TRP_Module_Inventaire = {};
	end
	if (TRP_Module_Inventaire[Royaume] == nil) then
		TRP_Module_Inventaire[Royaume] = {};
	end
	if (TRP_Module_Inventaire[Royaume][Joueur] == nil) then
		TRP_Module_Inventaire[Royaume][Joueur] = {};
	end
	if (TRP_Module_Inventaire[Royaume][Joueur]["Or"] == nil) then
		TRP_Module_Inventaire[Royaume][Joueur]["Or"] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Or"]["SacADos"] = 0;
		TRP_Module_Inventaire[Royaume][Joueur]["Or"]["Monture"] = 0;
	end
	if (TRP_Module_Inventaire[Royaume][Joueur]["Sacs"] == nil) then
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"] = "1";
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"] = "1";
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"] = {};
	end
	if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"] == nil then
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"] = {};
	end
	if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"] == nil then
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"] = {};
	end
	if TRP_Module_ObjetsPerso == nil then
		TRP_Module_ObjetsPerso = {};
	end
	if (TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"] == nil) then
		TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"] = {};
	end
end

function SetTRP_Module_PlayerInfo()
	if (TRP_Module_PlayerInfo == nil) then
		TRP_Module_PlayerInfo = {};
	end
	if (TRP_Module_PlayerInfo[Royaume] == nil) then
		TRP_Module_PlayerInfo[Royaume] = {};
	end
	if (TRP_Module_PlayerInfo[Royaume][Joueur] == nil) then
		TRP_Module_PlayerInfo[Royaume][Joueur] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Ok"] = 0;
		TRP_Module_PlayerInfo[Royaume][Joueur]["ClasseApparente"] = 0;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] = Joueur;
		TRP_Module_PlayerInfo[Royaume][Joueur]["TypeVetement"] = 3;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"] = 7;
		TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"] = 2;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Titre"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["Nom"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["Age"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["Origine"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["Taille"] = 3;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Corpulence"] = 3;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Silhouette"] = 2;
		TRP_Module_PlayerInfo[Royaume][Joueur]["VerNum"] = 0;
		TRP_Module_PlayerInfo[Royaume][Joueur]["QualiteVetement"] = 2;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Morale"] = 500;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Ethique"] = 500;
		TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] = "";
		TRP_Module_PlayerInfo[Royaume][Joueur]["Description"] = {};
	end

	if not TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"] then
		TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"] = {};
	end

	if TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"] == nil then
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"]["1"] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"]["2"] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"]["3"] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"]["4"] = {};
		TRP_Module_PlayerInfo[Royaume][Joueur]["Sauvegarde"]["5"] = {};
	end
	
	if (TRP_Module_Documents == nil) then
		TRP_Module_Documents = {};
	end
end

function TRPReinitAll()
	DeleteOldSavedVariables();
	TRP_Module_Configuration = nil;
	TRP_Module_Registre = nil;
	TRP_Module_PlayerInfo_Relations = nil;
	TRP_Module_PlayerInfo_Notes = nil;
	TRP_Module_Inventaire = nil;
	TRP_Module_ObjetsPerso = nil;
	TRP_Module_PlayerInfo = nil;
	TRP_Module_Documents = nil;
	ReloadUI();
end

function foundInTableString(tab,found)
	local foundOk = false;
	table.foreach(tab,
		function(option)
			if string.find(found,tab[option]) then
				foundOk = true;
			end
	end);
	return foundOk;
end

function isInBgOrArena()
	for i=1,MAX_BATTLEFIELD_QUEUES do
		if GetBattlefieldStatus(i) == "active" or IsActiveBattlefieldArena() ~= nil then
			return true;
		end
	end
	return false;
end

-- Thanks to - Mikk - http://www.wowwiki.com/Table_Helpers :)
-- Même si bon ... C'est de la bête récursivité :p
function TotalRP_tcopy(to, from)
	if to == nil or from == nil then return end
    for k,v in pairs(from) do
		if(type(v)=="table") then
			to[k] = {};
			TotalRP_tcopy(to[k], v);
		else
			to[k] = v;
		end
    end
end

function generateCoordonnees()
	if WorldMapFrame:IsVisible() then
		return 0,0;
	end
	SetMapToCurrentZone();
	local x,y = GetPlayerMapPosition("player");
	if x and y then
		x = math.floor(x * 250);
		y = math.floor(y * 250);
	else
		x = "<unknown>";
		y = "<unknown>";
	end
	return x,y;
end

function TRPGPS()
	local x,y = generateCoordonnees();
	sendMessage("{j}Actual location :\nContinent : "..tostring(GetCurrentMapContinent()).."\nZone : "..tostring(GetCurrentMapZone()).."\nSub-Zone : "..tostring(GetSubZoneText()).."\nX : "..tostring(x).."  , Y : "..tostring(y));
end

