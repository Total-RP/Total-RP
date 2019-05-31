function InventaireOpen(panel)
	FicheJoueurFond:SetTexture("Interface\\Stationery\\AuctionStationery1.blp");
	FicheJoueurFondDroite:SetTexture("Interface\\Stationery\\AuctionStationery2.blp");
	InventaireOngletSacADosIcon:SetTexture("Interface\\Icons\\"..TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Icone"]..".blp");
	InventaireOngletCoffreIcon:SetTexture("Interface\\Icons\\"..TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Icone"]..".blp");
	FicheJoueurOngletInventaire:Disable();
	FicheJoueurPanelInventaire:Show();
	InventaireOngletCoffre:Enable();
	InventaireOngletSacADos:Enable();
	InventaireOngletCreation:Enable();
	InventaireOngletPlanques:Enable();
	PanelInventaireListePlanque:Hide();
	FicheJoueurOngletInventaireIcon:SetAlpha(0.5);
	InventaireOngletCreationIcon:SetAlpha(1);
	InventaireOngletSacADosIcon:SetAlpha(1);
	InventaireOngletPlanquesIcon:SetAlpha(1);
	InventaireOngletCoffreIcon:SetAlpha(1);
	PanelCoffreSacFrame:Show();
	PanelCoffreSacFramePoids:Show();
	
	if panel == nil or panel == "InventaireOngletSacADos" then
		ShowInventaire(1);
	elseif panel == "InventaireOngletCoffre" then
		ShowInventaire(2);
	elseif panel == "InventaireOngletPlanques" then
		ShowInventaire(generatePlanqueID());
	elseif panel == "InventaireOngletMailBoxIn" then
		ShowInventaire(3);
	elseif panel == "InventaireOngletMailBoxOut" then
		ShowInventaire(4);
	elseif panel == "InventaireOngletCreation" then
		ShowObjetPerso();
		InventaireOngletCreation:Disable();
		FicheJoueurPanelTitle:SetText(INVENTAIRECREA);
		InventaireOngletCreationIcon:SetAlpha(0.5);
	elseif panel == "FicheJoueurOngletDocument" then
		PanelOpen(panel);
	else
		ShowInventaire(panel);
	end
end

function ShowInventaire(SacType)
	InventaireFrame:Show();
	MainInventaireFrame:Show();
	ObjetPersoFrame:Hide();

	if SacType == nil then SacType = 1; end
	Reinit_inventaire();
	
	wipe(CoffreTab);
	
	PanelCoffreSlider:SetOrientation("VERTICAL");
	PanelCoffreSlider:Hide();
	PanelCoffreSlider:SetValue(0);
	
	local i=0; -- Le nbr d'objet total
	local j=0; -- Nbr d'objet pris
	local PoidsTotal=0; -- Calcul du poids
	
	if FindPlanqueTab and FindPlanqueTab[SacType] then
		table.foreach(FindPlanqueTab[SacType],
			function(objet)
				if objet ~= "Commentaire" then
					j = j + 1;
					i = i + 1;
					CoffreTab[j] = {};
					CoffreTab[j][1] = SacType..objet;
					CoffreTab[j][2] = FindPlanqueTab[SacType][objet]["ID"];
					CoffreTab[j][3] = FindPlanqueTab[SacType][objet]["Qte"];
				end
		end);
	elseif SacType ~= 3 and SacType ~= 4 then
		table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
			function(objet)
				if objet ~= "Or" and objet ~= "Sacs" then
					i = i + 1;
					if (SacType == 1 and TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == "-1") or
					   (SacType == 2 and TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == "0") or
					   (TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == SacType) then
						local Reference;
						if string.len(TRP_Module_Inventaire[Royaume][Joueur][objet]["ID"]) ~= 16 then
							Reference = TRP_Objects[TRP_Module_Inventaire[Royaume][Joueur][objet]["ID"]];
						else
							Reference = TRP_Module_ObjetsPerso[TRP_Module_Inventaire[Royaume][Joueur][objet]["ID"]];
						end
						if PanelObjetSliderCategorie:GetValue() == 0 or PanelObjetSliderCategorie:GetValue() == Reference["Type"] then
							if PanelObjetSliderSousCategorie:GetValue() == 0 or PanelObjetSliderSousCategorie:GetValue() == Reference["SousType"] then
								j = j + 1;
								CoffreTab[j] = {};
								CoffreTab[j][1] = objet;
								CoffreTab[j][2] = TRP_Module_Inventaire[Royaume][Joueur][objet]["ID"];
								CoffreTab[j][3] = TRP_Module_Inventaire[Royaume][Joueur][objet]["Qte"];
							end
						end
						PoidsTotal = PoidsTotal + TRP_Module_Inventaire[Royaume][Joueur][objet]["Qte"]*Reference["Poids"];
					end
				end
		end);
	elseif SacType == 3 then
		table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"],
			function(slot)
				i = i + 1;
				j = j + 1;
				CoffreTab[j] = {};
				CoffreTab[j][1] = slot;
				CoffreTab[j][2] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["ID"];
				CoffreTab[j][3] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Qte"];
				CoffreTab[j][4] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Cible"];
				CoffreTab[j][5] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Commentaire"];
				CoffreTab[j][6] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Charges"];
		end);
	elseif SacType == 4 then
		table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"],
			function(slot)
				i = i + 1;
				j = j + 1;
				CoffreTab[j] = {};
				CoffreTab[j][1] = slot;
				CoffreTab[j][2] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["ID"];
				CoffreTab[j][3] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Qte"];
				CoffreTab[j][4] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Cible"];
				CoffreTab[j][5] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Commentaire"];
				CoffreTab[j][6] = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Charges"];
		end);
	end
	
	if j > 42 then
		PanelCoffreSlider:Show();
		local total = floor((j-1)/42);
		PanelCoffreSlider:SetMinMaxValues(0,total);
	end
	
	if j == 0 then
		if SacType == 1 then
			PanelInventaireListeEmpty:SetText(SACEMPTY);
		elseif SacType == 2 then
			PanelInventaireListeEmpty:SetText(SACEMPTY);
		elseif SacType == 3 then
			PanelInventaireListeEmpty:SetText("No package received");
		elseif SacType == 4 then
			PanelInventaireListeEmpty:SetText("No pending package");
		else
			PanelInventaireListeEmpty:SetText(SACEMPTY);
		end
	else
		PanelInventaireListeEmpty:SetText("");
	end
	
	-- Triage du tableau
	CoffreTriage();
	
	--Finances
	local totalPlanque = 0;
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"],
		function(planque)
			totalPlanque = totalPlanque + TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Or"];
	end);
	-- Sac Frame calcul
	if SacType == 1 then -- Sac � dos
		InventaireOngletSacADos:Disable();
		InventaireOngletSacADosIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(INVENTAIRESACADOS);
		PanelCoffreSacFrameType:SetText(COFFREFINANCES);
		ArgentText:SetText(TRP_Module_Inventaire[Royaume][Joueur]["Or"]["SacADos"]);
		InventaireSlotSacIcon:SetTexture("Interface\\Icons\\"..TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Icone"]..".blp");
		InventaireSlotSac:SetScript("OnEnter",function ()
			GameTooltip:SetOwner(InventaireSlotSac, "ANCHOR_TOPLEFT");
			GameTooltip:AddLine(TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Nom"],0,1,0);
			GameTooltip:AddLine("< "..COFFREFINANCES.." >",1,1,1);
			GameTooltip:AddLine(" ",1,1,1);
			decouperForTooltip("\""..TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Description"].."\"",35,1,0.75,0);
			GameTooltip:AddLine(" ",1,1,1);
			GameTooltip:AddLine("Bag weight : "..(TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Poids"]/1000).." kg",1,1,1);
			GameTooltip:Show();
		end);
		PoidsTotal = PoidsTotal + (TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Poids"]);
		PanelCoffreSacFramePoidsMax:SetText("Weight max. : 30 kg");
	elseif SacType == 2 then --Coffre Monture
		InventaireOngletCoffre:Disable();
		InventaireOngletCoffreIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(INVENTAIRECOFFRE);
		PanelCoffreSacFrameType:SetText(COFFREVOYAGE);
		ArgentText:SetText(TRP_Module_Inventaire[Royaume][Joueur]["Or"]["Monture"]);
		InventaireSlotSacIcon:SetTexture("Interface\\Icons\\"..TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Icone"]..".blp");
		InventaireSlotSac:SetScript("OnEnter",function ()
			GameTooltip:SetOwner(InventaireSlotSac, "ANCHOR_TOPLEFT");
			GameTooltip:AddLine(TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Nom"],0,1,0);
			GameTooltip:AddLine("< "..COFFREVOYAGE.." >",1,1,1);
			GameTooltip:AddLine(" ",1,1,1);
			decouperForTooltip("\""..TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Description"].."\"",35,1,0.75,0);
			GameTooltip:AddLine(" ",1,1,1);
			GameTooltip:AddLine("Safe weight : "..(TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Poids"]/1000).." kg",1,1,1);
			GameTooltip:Show();
		end);
		PoidsTotal = PoidsTotal + (TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Poids"]);
		PanelCoffreSacFramePoidsMax:SetText("Weight max. : 150 kg");
	elseif SacType == 3 then -- Boite aux lettre
		FicheJoueurPanelTitle:SetText("Inventory : Mailbox (In)");
		PanelCoffreSacFrameType:SetText("Mailbox");
		ArgentText:Hide();
		ArgentText:SetText("RECEPTION");
		InventaireSlotSacIcon:SetTexture("Interface\\ICONS\\INV_Letter_14.blp");
		InventaireSlotSac:SetScript("OnEnter",function ()
			GameTooltip:Hide();
		end);
		PanelCoffreSacFramePoidsMax:SetText("");
		PanelCoffreSacFramePoids:Hide();
	elseif SacType == 4 then -- Boite d'envoi
		FicheJoueurPanelTitle:SetText("Inventory : Mailbox (Out)");
		PanelCoffreSacFrameType:SetText("Box shipments");
		ArgentText:Hide();
		ArgentText:SetText("ENVOI");
		InventaireSlotSacIcon:SetTexture("Interface\\ICONS\\INV_Letter_18.blp");
		InventaireSlotSac:SetScript("OnEnter",function ()
			GameTooltip:Hide();
		end);
		PanelCoffreSacFramePoidsMax:SetText("");
		PanelCoffreSacFramePoids:Hide();
	else -- Planques
		-- Recherche planque
		InventaireOngletPlanques:Disable();
		InventaireOngletPlanquesIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(INVENTAIREPLANQUES);
		PanelCoffreSacFrameType:SetText(PLANQUE);
		local planque = DetectPlanque();
		ArgentText:SetText(planque["Or"]);
		InventaireSlotSacIcon:SetTexture(IconeZone[planque["ContinentNum"]][planque["ZoneNum"]]);
		InventaireSlotSac:SetScript("OnEnter",function ()
			GameTooltip:SetOwner(InventaireSlotSac, "ANCHOR_TOPLEFT");
			GameTooltip:AddLine(PLANQUE,0,1,0);
			GameTooltip:AddLine("< "..planque["Continent"].." >",1,1,1);
			GameTooltip:AddLine("< "..planque["Zone"].." >",1,1,1);
			if planque["SousZone"] ~= "" then
				GameTooltip:AddLine("< "..planque["SousZone"].." >",1,1,1);
			end
			if planque["Commentaire"] ~= nil and planque["Commentaire"] ~= "" then
				GameTooltip:AddLine(" ",1,1,1);
				GameTooltip:AddLine("Notes :",1,1,1);
				local ok = true;
				local morceaux = "\""..string.gsub(planque["Commentaire"],"\n"," ");
				while ok do
					local indice = string.find(morceaux," ",35);
					if indice == nil then
						ok = false;
						GameTooltip:AddLine("|cffff9900  "..morceaux.."\"",1,1,1);
					else
						GameTooltip:AddLine("|cffff9900  "..string.sub(morceaux,1,indice),1,1,1);
						morceaux = string.sub(morceaux,indice);
					end
				end
			end
			GameTooltip:AddLine(" ",1,1,1);
			GameTooltip:AddLine("Coordinates : ",1,1,1);
			GameTooltip:AddLine("< "..planque["CoordX"].." - "..planque["CoordY"].." >",1,1,1);
			GameTooltip:Show();
		end);
		PanelCoffreSacFramePoidsMax:SetText("");
	end
	
	PanelInventaireListePlanque:Show();
	
	--Calcul du poids :
	if not FindPlanqueTab or not FindPlanqueTab[SacType] then
		PanelCoffreSacFramePoids:SetText("Total weight : "..(PoidsTotal/1000).." kg");
		PanelCoffreSacFramePoids:Show();
	else
		PanelCoffreSacFramePoids:Hide();
	end
	
	InventaireSlotSacButtonDeletePlanque:Hide();
	if SacType ~= 1 and  SacType ~= 2 and SacType ~= 3 and SacType ~= 4 and (not FindPlanqueTab or not FindPlanqueTab[SacType])  then
		InventaireSlotSacButtonDeletePlanque:Show();
	end
	
	ChargerSliderCoffreVertical(PanelCoffreSlider:GetValue());
	
end

function listerPlanques()
	local liste="";
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"],
		function(planque)
			liste = liste.."------------------------\n";
			liste = liste.."{o}Continent : {w}"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Continent"];
			liste = liste.."\n{o}Part : {w}"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Zone"];
			liste = liste.."\n{o}Zone : {w}"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["SousZone"];
			liste = liste.."\n{o}Coordinates : {w}X = "..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["CoordX"]..", Y = "..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["CoordY"];
			local numObjet = 0;
			table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
				function(objet)
					if objet ~= "Or" and objet ~= "Sacs" then
						if TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == planque then
							numObjet = numObjet + TRP_Module_Inventaire[Royaume][Joueur][objet]["Qte"];
						end
					end
			end);
			liste = liste.."\n{o}Amount of hidden items : {w}"..numObjet;
			if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Commentaire"] ~= nil and TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Commentaire"] ~= "" then
				liste = liste.."\n{o}Comments :{w}\n\""..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][planque]["Commentaire"].."\"";
			end
			liste = liste.."\n------------------------\n\n";
	end);
	if liste == "" then
		TRPError("You don't have any hiding place.");
	else
		setManualAide("Hiding places List",liste);
	end
end

function DetectPlanque()
	return TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][generatePlanqueID()];
end

function DeletePlanque()
	if DetectPlanque() then
		local pos = generatePlanqueID();
		local plop;
		wipe(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][pos]);
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][pos] = nil;
		
		table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
			function(objet)
				if TRP_Module_Inventaire[Royaume][Joueur][objet]["Sac"] == pos then
					wipe(TRP_Module_Inventaire[Royaume][Joueur][objet]);
					TRP_Module_Inventaire[Royaume][Joueur][objet] = nil;
					plop = true;
				end
		end);
		
		PanelOpen("FicheJoueurOngletInventaire","InventaireOngletSacADos");
		sendMessage("{j}The hiding place has been destroyed.");
		if plop then
			sendMessage("{j}One or more items have been destroyed.");
		end
	else
		TRPError(DeleteMessages["DELETEPLANQUEWARN"]);
	end;
end

function generatePlanqueID()
	if WorldMapFrame:IsVisible() and not bForce then
		return nil;
	end
	SetMapToCurrentZone();
	local x,y = generateCoordonnees();
	local zoneNum = GetCurrentMapZone();
	local continentNum = GetCurrentMapContinent();
	
	return tostring(continentNum..zoneNum..x..y);
end

function CreerPlanque(commentaire)
	SetMapToCurrentZone();
	local zoneNum = GetCurrentMapZone();
	local continentNum = GetCurrentMapContinent();
	local continent = { GetMapContinents() };
	local zone = { GetMapZones(continentNum) };
	local sousZone = "";
	local x,y = GetPlayerMapPosition("player");
	x = math.floor(x * 150);
	y = math.floor(y * 150);
	
	if DetectPlanque() == nil then
		local ID = generatePlanqueID(true);
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["Continent"] = continent[continentNum];
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["Zone"] = GetZoneText();
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["SousZone"] = GetSubZoneText();
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["ContinentNum"] = continentNum;
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["ZoneNum"] = zoneNum;
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["Or"] = 0;
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["CoordX"] = x;
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["CoordY"] = y;
		if commentaire and commentaire ~= "" then
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Planques"][ID]["Commentaire"] = commentaire;
		end
		sendMessage("{v}You create a new hiding place.");
		PanelOpen("FicheJoueurOngletInventaire","InventaireOngletPlanques");
	else
		TRPError("You already have a hiding place here.");
	end
end

function getZoneNum()
	SetMapToCurrentZone();
	local zone = { GetMapZones(GetCurrentMapContinent()) };
	
	for k=1,#zone,1 do
		debugMess(k.." : "..zone[k]);
	end
end

function CoffreTriage()
	-- Tri selon Cat�gorie, Sous Cat�gorie, Nom et enfin Quantit�
	local triTab = {}
	i = 1;
	table.foreach(CoffreTab,
		function(objet)
			local concatene = "";
			local ID = CoffreTab[objet][2];
			local Reference;
			if string.len(ID) ~= 16 then
				Reference = TRP_Objects[ID];
			else
				Reference = TRP_Module_ObjetsPerso[ID];
			end
			concatene = concatene..Reference["Type"]..Reference["SousType"]..Reference["Nom"]..CoffreTab[objet][3].."|"..objet;
			triTab[i] = concatene;
			i = i + 1;
	end);
	table.sort(triTab);
	local newTriTab = {};
	table.foreach(triTab,
		function(objet)
			local Slot = triTab[objet];
			Slot = tonumber(string.sub(Slot,string.find(Slot,"|")+1));
			newTriTab[objet] = CoffreTab[Slot];	
	end);
	CoffreTab = newTriTab;
end

function Reinit_inventaire()
	for k=1,42,1 do --Initialisation
		getglobal("InventaireSlot"..k.."Qte"):SetText("");
		getglobal("InventaireSlot"..k.."Icon"):SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled.blp");
		getglobal("InventaireSlot"..k):SetButtonState("NORMAL");
		getglobal("InventaireSlot"..k):Hide();
	end
end

function Reinit_icones()
	for k=1,42,1 do --Initialisation
		getglobal("ListeIconesSlot"..k.."Url"):SetText("");
		getglobal("ListeIconesSlot"..k.."Icon"):SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled.blp");
		getglobal("ListeIconesSlot"..k):SetButtonState("NORMAL");
		getglobal("ListeIconesSlot"..k):Hide();
	end
end

function calculerListeIcone()
	local recherche = TRPIconeListRecherche:GetText();
	local j = 0;
	
	ListeIconesSlider:Hide();
	ListeIconesSlider:SetValue(0);
	wipe(IconeTab);
	TRPListeIconesEmpty:Hide();
	
	table.foreach(ListeIconeTab,
	function(icone)
		if (recherche ~= "" and string.find(string.lower(ListeIconeTab[icone]),string.lower(recherche)) ~= nil) or recherche == "" then
			IconeTab[j+1] = ListeIconeTab[icone];
			j = j+1;
		end
	end);
	
	if j > 42 then
		local total = floor((j-1)/42);
		ListeIconesSlider:Show();
		ListeIconesSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListeIconesEmpty:Show();
	end
	
	ChargerSliderListeIcones(0);
end

function ChargerSliderListeIcones(num)
	Reinit_icones();
	
	if IconeTab ~= nil then
		for k=1,42,1 do 
			local i = num*42 + k;
			if IconeTab[i] ~= nil then
				getglobal("ListeIconesSlot"..k):Show();
				getglobal("ListeIconesSlot"..k.."Icon"):SetTexture("Interface\\Icons\\"..IconeTab[i]);
				getglobal("ListeIconesSlot"..k.."Url"):SetText(IconeTab[i]);
			end
		end
	end
end

function ChargerSliderCoffreVertical(num)
	
	Reinit_inventaire();
	
	if CoffreTab then
		local i = 1;
		local j = 1;
		table.foreach(CoffreTab,
		function(objet)
			if i > num*42 and i <= (num+1)*42 then
				-- CoffreTab = {slot,ID,Qte}
				local ID = CoffreTab[objet][2];
				local objetID;
				if string.len(ID) == 16 then
					objetID = TRP_Module_ObjetsPerso[ID];
				else
					objetID = TRP_Objects[ID];
				end
				
				if not objetID then
					TRPError("Internal error: Listing of an unknown item.\nID = "..ID);
					return;
				end
				
				if not tonumber(CoffreTab[objet][1]) then
					getglobal("InventaireSlot"..j):Show();
					getglobal("InventaireSlot"..j):SetScript("OnClick", 
						function(self,button,down)
						
					end);
					getglobal("InventaireSlot"..j):SetScript("OnEnter", 
						function() 
							SetObjetTooltip(FindPlanqueTab[string.sub(CoffreTab[objet][1],1,-2)][string.sub(CoffreTab[objet][1],-1)],this,nil,nil,nil,true);
					end);
					if tonumber(CoffreTab[objet][3]) and tonumber(CoffreTab[objet][3]) > 1 then
						getglobal("InventaireSlot"..j.."Qte"):SetText(CoffreTab[objet][3]);
					end
					getglobal("InventaireSlot"..j.."Icon"):SetTexture("Interface\\Icons\\"..objetID["Icone"]..".blp");
				else
					getglobal("InventaireSlot"..j):Show();
					getglobal("InventaireSlot"..j).slot = CoffreTab[objet][1];
					getglobal("InventaireSlot"..j):SetScript("OnClick", 
						function(self,button,down)
							if ArgentText:GetText() == "ENVOI" then
								if  button == "LeftButton" then
									envoyerCourrier(CoffreTab[objet][1]);
								elseif button == "RightButton" then
									StaticPopupDialogs["TRP_INV_DELETE_COURRIER"].text = setTRPColorToString(TRP_ENTETE.." \n ".."Destroy".." :\n\n"..Courrier["DELETEB"]);
									TRP_ShowStaticPopup("TRP_INV_DELETE_COURRIER",nil,nil,CoffreTab[objet][1],2);
								end
							elseif ArgentText:GetText() == "RECEPTION" then
								if  button == "LeftButton" then
									recupCourrier(CoffreTab[objet][1]);
								elseif button == "RightButton" then
									StaticPopupDialogs["TRP_INV_DELETE_COURRIER"].text = setTRPColorToString(TRP_ENTETE.." \n ".."Destroy".." :\n\n"..Courrier["DELETEA"]);
									TRP_ShowStaticPopup("TRP_INV_DELETE_COURRIER",nil,nil,CoffreTab[objet][1],2);
								end
							else
								if button == "RightButton" then
									if IsControlKeyDown() then
										SwitchObjets(CoffreTab[objet][1],1,1);
									elseif IsShiftKeyDown() then
										SwitchObjets(CoffreTab[objet][1],1,0);
									elseif IsAltKeyDown() then
										ShowObjectTo(CoffreTab[objet][1],UnitName("target"));
									else
										DelGameObjet(CoffreTab[objet][1])
									end
								elseif  button == "LeftButton" then
									if IsControlKeyDown() then
										DonnerObjet(CoffreTab[objet][1],UnitName("target"));
									elseif IsShiftKeyDown() then
										if ChatFrameEditBox:IsVisible() then
											ChatFrameEditBox:SetText(ChatFrameEditBox:GetText().."["..objetID["Nom"].."]");
										else
											SendMailBoxSlot:SetText(CoffreTab[objet][1]);
											SendMailBoxID:SetText(CoffreTab[objet][2]);
											SendMailBoxMax:SetText(CoffreTab[objet][3]);
											EnvoiCourrierSaisieQte:SetText(CoffreTab[objet][3]);
											EnvoiCourrierSaisieDestinataire:SetText("");
											EnvoiCourrierSaisieCommentaire:SetText("");
											TRPListePersonnagesType:SetText("1");
											SendMailBox:Show();
										end
									elseif IsAltKeyDown() then
										SendPersoBoxSlot:SetText(CoffreTab[objet][1]);
										SendPersoBoxID:SetText(CoffreTab[objet][2]);
										SendPersoBoxMax:SetText(CoffreTab[objet][3]);
										EnvoiPersoSaisieQte:SetText(CoffreTab[objet][3]);
										EnvoiPersoSaisieDestinataire:SetText("");
										TRPListePersonnagesType:SetText("2");
										SendPersoBox:Show();
									else
										UseObjet(CoffreTab[objet][1]);
									end
								end
							end
					end );
					if CoffreTab[objet][3] > 1 then
						getglobal("InventaireSlot"..j.."Qte"):SetText(CoffreTab[objet][3]);
					end
					getglobal("InventaireSlot"..j.."Icon"):SetTexture("Interface\\Icons\\"..objetID["Icone"]..".blp");
					if not getglobal("InventaireSlot"..j.."Cooldown") then
						CreateFrame("Cooldown","InventaireSlot"..j.."Cooldown",getglobal("InventaireSlot"..j));
						getglobal("InventaireSlot"..j.."Cooldown"):SetAllPoints(getglobal("InventaireSlot"..j));
					end
					getglobal("InventaireSlot"..j):SetScript("OnUpdate", 
						function(self) 
							if objetID["Utilisable"] and objetID["Utilisable"]["Cooldown"] 
							and TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][ID] and time() < TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][ID] then
								local secondes = TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][ID]-time();
								local jour,heure,minutes,message;
								if secondes > 86400 then
									jour = math.floor(secondes/86400);
									if jour == 1 then
										message = "2 d";
									else
										message = jour.." d";
									end
								elseif secondes > 3600 then
									heure = math.floor(secondes/3600);
									if heure == 1 then
										message = "2 h";
									else
										message = heure.." h";
									end
								elseif secondes > 60 then
									minutes = math.floor(secondes/60);
									if minutes == 1 then
										message = "2 m";
									else
										message = minutes.." m";
									end
								else
									message = secondes.." s";
								end
								getglobal(self:GetName().."CooldownText"):SetText("|cffffffff"..message);
								getglobal(self:GetName().."Icon"):SetDesaturated(true);
							else
								if TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][ID] then
									TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][ID] = nil;
									getglobal(self:GetName().."Cooldown"):SetCooldown(0,0);
								end
								getglobal(self:GetName().."CooldownText"):SetText("");
								getglobal(self:GetName().."Icon"):SetDesaturated(false);
							end
							if self:IsMouseOver() and FicheJoueur:GetAlpha() == 1 then
								if ArgentText:GetText() == "ENVOI" then
									GameTooltip:SetOwner(ObjetPersoSlot1, "ANCHOR_CURSOR");
									GameTooltip:AddLine(objetID["Nom"], 1, 1, 1);
									GameTooltip:AddLine("< Unsent Packages >", 1, 1, 1);
									GameTooltip:AddLine("From "..CoffreTab[objet][4], 0, 1, 0);
									if CoffreTab[objet][5] ~= nil and CoffreTab[objet][5] ~= "" then
										decouperForTooltip("\""..CoffreTab[objet][5].."\"",30,1,0.85,1);
									end
									GameTooltip:Show();
								elseif ArgentText:GetText() == "RECEPTION" then
									GameTooltip:SetOwner(ObjetPersoSlot1, "ANCHOR_CURSOR");
									GameTooltip:AddLine(objetID["nom"], 1, 1, 1);
									GameTooltip:AddLine("< Unread Packages >", 1, 1, 1);
									GameTooltip:AddLine("From "..CoffreTab[objet][4], 0, 1, 0);
									if CoffreTab[objet][5] ~= nil and CoffreTab[objet][5] ~= "" then
										decouperForTooltip("\""..CoffreTab[objet][5].."\"",30,1,0.85,1);
									end
									GameTooltip:Show();
								else
									SetObjetTooltip(TRP_Module_Inventaire[Royaume][Joueur][CoffreTab[objet][1]],this);
								end
							end
					end);
				end
				j = j + 1;
			end
			i = i + 1;
		end);
	end

end

function deleteCourrier(slot,Courriertype)
	if Courriertype == 1 then
		if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot] ~= nil then
			wipe(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]);
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot] = nil;
		else
			TRPError("Internal Error: Delete Mail In delete slot nonexistent.\nSlot "..slot)
		end
	elseif Courriertype == 2 then
		if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot] ~= nil then
			GetObjets(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["ID"],-1,TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Qte"],TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Charges"])
			wipe(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]);
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot] = nil;
		else
			TRPError("Internal Error: Delete mail Out delete nonexistent slot.\nSlot "..slot)
		end
	end
	refreshInventaire();
end

function proceedEnvoiCourrier()
	local ID = SendMailBoxID:GetText();
	local Cible = string.gsub(EnvoiCourrierSaisieDestinataire:GetText()," ","");
	local Slot = SendMailBoxSlot:GetText();
	local Qte = tonumber(EnvoiCourrierSaisieQte:GetText());
	local Commentaire = EnvoiCourrierSaisieCommentaire:GetText();
	
	if Cible ~= "" and Qte > 0 then
		sendCourrier(ID,Qte,TRP_Module_Inventaire[Royaume][Joueur][Slot]["Charges"],Commentaire,Cible);
		proceedDeleteObject(Slot,Qte);
		SendMailBox:Hide();
	end
	
end

function proceedEnvoiPerso()
	local ID = SendPersoBoxID:GetText();
	local Cible = string.gsub(EnvoiPersoSaisieDestinataire:GetText()," ","");
	local Slot = SendPersoBoxSlot:GetText();
	local Qte = tonumber(EnvoiPersoSaisieQte:GetText());
	local royaumes = SendPersoBoxRoyaume:GetText();
	
	if Cible ~= "" and Qte > 0 and royaumes ~= nil then
		if TRP_Module_Inventaire[royaumes][Cible] ~= nil then
			envoiToPerso(ID,Cible,royaumes,TRP_Module_Inventaire[Royaume][Joueur][Slot]["Charges"],Qte);
			proceedDeleteObject(Slot,Qte);
			SendPersoBox:Hide();
		else
			TRPError("Internal error: character nonexistent.\nMe = "..tostring(Cible).."\nrealm = "..tostring(royaumes))
		end
	end
	
end

function envoiToPerso(ID,Cible,Royaumes,Charges,Qte)
	if TRP_Module_Inventaire[Royaumes][Cible] ~= nil then
		-- Envoi par courrier
		local i=1;
		while i<5000 do
			if TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)] == nil then
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)] = {};
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)]["ID"] = ID;
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)]["Qte"] = Qte;
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)]["Charges"] = Charges;
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)]["Cible"] = Joueur;
				TRP_Module_Inventaire[Royaumes][Cible]["Sacs"]["InBox"][tostring(i)]["Commentaire"] = "";
				break;
			end
			i = i+1;
		end
		sendMessage("{v}You sent a package to "..cible.." of the realm \""..Royaumes.."\".");
		refreshInventaire();
	else
		TRPError("Internal error: character non existent.\nMe = "..tostring(Cible).."\nrealm = "..tostring(Royaumes))
	end
end

function ReceptionCourrier(tab,sender)
	local Slot = tab[1];
	local ID = tab[2];
	local Qte = tonumber(tab[3]);
	local Charges;
	local Commentaire = tab[5];
	
	if tab[4] ~= nil and tab[4] ~= "" then
		Charges = tonumber(tab[4]);
	end
	receiveCourrier(ID,Qte,Charges,Commentaire,sender,Slot)
end

function envoyerCourrier(slot)
	if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot] ~= nil then
		local message = "";
		message = message..slot.."|"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["ID"].."|"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Qte"].."|";
		if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Charges"] then
			message = message..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Charges"];
		end
		message = message.."|"..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Commentaire"];
		TRPSecureSendAddonMessage("SDC",message,TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Cible"]);
		sendMessage("{j}Attempt to send a package to "..TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]["Cible"].." ...");
	else
		TRPError("Internal error: send mail slot non existent.\nSlot "..slot);
	end
end

function recupCourrier(slot)
	if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot] ~= nil then
		local ID = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["ID"];
		local Qte = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Qte"];
		local Charges = TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][slot]["Charges"];
		if canReceiveObjet(ID,Qte) ~= 2 then
			GetObjets(ID,-1,Qte,Charges);
			deleteCourrier(slot,1);
			sendMessage("{v}You picked up your package.");
		else
			TRPError(ExchangeError["CANTUNIQUESELF"]);
		end
	else
		TRPError("Internal error: recup mail slot non existent.\nSlot "..slot);
	end
end

function receiveCourrier(ID,Qte,Charges,Comment,From,SlotTarget)
	local i=1;
	while i<5000 do
		if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)] == nil then
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)] = {};
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)]["ID"] = ID;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)]["Qte"] = Qte;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)]["Charges"] = Charges;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)]["Cible"] = From;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"][tostring(i)]["Commentaire"] = Comment;
			break;
		end
		i = i+1;
	end
	if string.len(ID) == 16 and not TRP_Module_ObjetsPerso[ID] then
		--Demande de l'objet
		ExchangeRefTarget = From;
		ProceedObjetRefExchange(1,ID,"","","");
	end
	TRPSecureSendAddonMessage("COK",SlotTarget,From);
	sendMessage("{v}You have received a package from "..From..". Go to a mailbox to retrieve it.");
	refreshInventaire();
end

function OKCourrier(tab, sender)
	local slot = tab[1];
	if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot] then
		wipe(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot]);
		TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][slot] = nil;
		sendMessage("{v}"..sender.." has succefuly received your package.");
		refreshInventaire();
	else
		TRPError("Internal error: Unable to delete the package sent.\nSlot "..slot);
	end
end

function sendCourrier(ID,Qte,Charges,Comment,For)
	local i=1;
	while i<5000 do
		if TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)] == nil then
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)] = {};
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)]["ID"] = ID;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)]["Qte"] = Qte;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)]["Charges"] = Charges;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)]["Cible"] = For;
			TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"][tostring(i)]["Commentaire"] = Comment;
			break;
		end
		i = i+1;
	end
	sendMessage("{j}Your package is now waiting to be sent.");
end

function CheckCourrier()
	local count = 0;
	local Message = "{v}Courrier:";
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["InBox"], function()
		count = count + 1;
	end);
	if count > 0 then
		Message = Message.."\n\n{j}You have "..count.." packages awaiting to be sent. Go to the mailbox.";
	end
	count = 0;
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["OutBox"], function()
		count = count + 1;
	end);
	if count > 0 then
		Message = Message.."\n\n{j}You have "..count.." packages awaiting to be retreived. Go to the mailbox.";
	end
	if Message ~= "{v}Courrier:" then
		StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE..Message);
		TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
	end
end

function ShowObjectTo(slot,cible)
	if TRP_Module_Inventaire[Royaume][Joueur][slot] then
		local ID = TRP_Module_Inventaire[Royaume][Joueur][slot]["ID"];
		local charges = TRP_Module_Inventaire[Royaume][Joueur][slot]["Charges"];
		if not charges then charges = 0 end;
		local objet;
		if string.len(ID) == 16 then
			objet = TRP_Module_ObjetsPerso[ID];
		else
			objet = TRP_Objects[ID];
		end
		TRPSecureSendAddonMessage("SOA",ID.."|"..charges,cible);
		SendChatMessage("is showing ["..objet["Nom"].."] to "..cible..".","EMOTE");
	end
end

function ShowAskingObjet(objet,sender)
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
		TRPSecureSendAddonMessage("SDM",ExchangeError["SHOW"]..Joueur..".",sender);
		return;
	end
	
	local ID = objet[1];
	local Charge = objet[2];
	local objet;
	if string.len(ID) == 16 then
		objet = TRP_Module_ObjetsPerso[ID];
		if not objet then
			ExchangeRefTarget = sender;
			TRPWaitingForShow = true;
			ProceedObjetRefExchange(1,ID,"","","");
			return;
		end
	else
		objet = TRP_Objects[ID];
		if not objet then
			return;
		end
	end
	ShowObjetDone(ID,sender);
end

function ShowObjetDone(ID,sender)
	local objet;
	if string.len(ID) == 16 then
		objet = TRP_Module_ObjetsPerso[ID];
	else
		objet = TRP_Objects[ID];
	end
	if not objet then
		TRPError("Internal error: unknown ShowObjetDone with ID !");
		return;
	end
	
	if objet["Utilisable"] and objet["Utilisable"]["LierAuDoc"] and TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]] then
		if not FicheJoueur:IsVisible() then
			PanelOpen("FicheJoueurOngletInventaire");
		end
		afficheDocument(objet["Utilisable"]["LierAuDoc"]);
	end

	local Message = sender.." is showing you this item :\n\n";
	Message = Message.."{v}|TInterface\\ICONS\\"..objet["Icone"]..".blp:50:50|t".."\n["..objet["Nom"].."]\n";
	Message = Message.."\n{w}Description :\n{o}\""..objet["Description"].."\"\n\n";
	if tonumber(objet["Poids"]) ~= 0 then
		Message = Message.."{w}Weight : {o}"..objet["Poids"].." grams\n\n";
	end
	if TRP_ObjetCategorie[objet["Type"]] and TRP_ObjetCategorie[objet["Type"]].SousCategorie[objet["SousType"]] then
		Message = Message.."{w}< "..TRP_ObjetCategorie[objet["Type"]].Nom.." >\n< "..TRP_ObjetCategorie[objet["Type"]].SousCategorie[objet["SousType"]].." >"
	end
	StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
	TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
end

function DonnerObjet(emplacement,cible,Charges,Qte)
	if Qte ~= nil then
		Qte = tonumber(Qte); --Securité
	end
	
	local slot = TRP_Module_Inventaire[Royaume][Joueur][emplacement];
	
	if slot["Sac"] ~= "-1" then
		TRPError(ExchangeError["MUSTINSAC"]);
		return;
	elseif UnitName("target") == nil or UnitName("target") == Joueur or not UnitIsPlayer("target") or UnitFactionGroup("target") ~= UnitFactionGroup("player") then
		TRPError(ExchangeError["NOTARGET"]);
		return;
	elseif CheckInteractDistance("target",3) == nil then
		TRPError(ExchangeError["NORANGE"]);
		return;
	end

	local objet;
	if string.len(slot["ID"]) ~= 16 then
		objet = TRP_Objects[slot["ID"]];
	else
		objet = TRP_Module_ObjetsPerso[slot["ID"]];
	end
	if Qte == nil then
		if objet["Utilisable"] then
			Charges = slot["Charges"];
		end
		if slot["Qte"] > 1 then
			-- Choix Quantite
			StaticPopupDialogs["TRP_INV_GIVE_AMOUNT"].text = setTRPColorToString(TRP_ENTETE.." \n ".."Quantity to give ?\nMax : "..slot["Qte"]);
			TRP_ShowStaticPopup("TRP_INV_GIVE_AMOUNT",nil,nil,emplacement,cible,Charges,slot["Qte"],true,slot["Qte"]);
		else
			-- Qte egale 
			DonnerObjet(emplacement,cible,Charges,1);
		end
	elseif Qte > 0 then
		if Charges ~= nil then
			TRPSecureSendAddonMessage("GOA",slot["ID"].."|"..objet["Nom"].."|"..Qte.."|"..Charges,cible);
		else
			TRPSecureSendAddonMessage("GOA",slot["ID"].."|"..objet["Nom"].."|"..Qte,cible);
		end
		sendMessage("{o}"..Exchange["SENDED"]..cible);
	end
end

function AskingObjet(objet,sender)
	if string.len(objet[1]) > 16 then return end;

	if UnitAffectingCombat("player") ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..Joueur..ExchangeError["ISFINGHTING"],sender);
		return;
	end

	if ExchangeTarget ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..ExchangeError["ALREADYEXCHNAGE"],sender);
		return;
	end

	if TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"] == 1 or isBanned(sender) then
		TRPSecureSendAddonMessage("SDM",ExchangeError["REFUSAL"]..Joueur..".",sender);
		return;
	end

	
	local ID = objet[1];
	local Nom = objet[2];
	local Qte = objet[3];
	local charges = objet[4];
	
	if charges == "" then
		charges = nil;
	end	
	
	
	local Message = sender;
	if string.len(ID) ~= 16 then -- Objet pré-construit
		if TRP_Objects[ID] ~= nil then
			ExchangeTarget = sender;
			local iconeTex = "|TInterface\\ICONS\\"..TRP_Objects[ID]["Icone"]..".blp:35:35|t\n";
			if charges and tonumber(charges) ~= 0 then
				Message = Message.." wants to give you :\n\n"..iconeTex..Qte.."x     "..Nom.."\n["..charges.." charge(s)] \n\n{o}Do you accept ?";
			else
				Message = Message.." wants to give you :\n\n"..iconeTex..Qte.."x     "..Nom.." \n\n{o}Do you accept ?";
			end
			StaticPopupDialogs["TRP_OBJ_ASKING"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
			TRP_ShowStaticPopup("TRP_OBJ_ASKING",nil,nil,ID,Nom,Qte,charges);
		else
			TRPSecureSendAddonMessage("SDM",ExchangeError["HASNOTREF"],sender);
		end
	else -- Objet perso
		ExchangeTarget = sender;
		local iconeTex = "";
		if TRP_Module_ObjetsPerso[ID] then
			iconeTex = "|TInterface\\ICONS\\"..TRP_Module_ObjetsPerso[ID]["Icone"]..".blp:35:35|t\n";
		end
		if charges and tonumber(charges) ~= 0 then
			Message = Message.." wants to give you :\n\n"..iconeTex..Qte.."x     "..Nom.."\n["..charges.." charge(s)] \n\n{o}Do you accept ?";
		else
			Message = Message.." wants to give you :\n\n"..iconeTex..Qte.."x     "..Nom.." \n\n{o}Do you accept ?";
		end
		StaticPopupDialogs["TRP_OBJ_ASKING"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
		TRP_ShowStaticPopup("TRP_OBJ_ASKING",nil,nil,ID,Nom,Qte,charges);
	end
end

function GiveObjectDone(objet,sender)
	local ID = tostring(objet[1]);
	local Qte = tonumber(objet[2]);
	local charges,object;
	local ok = false;
    if objet[3] ~= nil then
		charges = tonumber(objet[3]);
	end
	object = GetObjectWithID(ID);
	
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
	function(Emplacement)
		if Emplacement ~= "Or" and Emplacement ~= "Sacs" and TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["ID"] == ID then
			if TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] >= Qte then
				if (object["Utilisable"] and (charges == TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Charges"])) or not object["Utilisable"] then
					TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] = TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] - Qte;
					if TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] == 0 then
						TRP_Module_Inventaire[Royaume][Joueur][Emplacement] = nil;
					end
					refreshInventaire();
					ok = true;
					sendMessage("{j} "..Qte.."x{v}["..object["Nom"].."]{j} given to "..sender..".");
				end
			end
		end
	end);
	if not ok then
		TRPError("Internal error: Can not find the deleted object during the response back from a sending object.\nObjet : "..tostring(ID).."\nQte : "..tostring(Qte).."\nCharges : "..tostring(charges));
	end
end

function ProceedObjetExchange(num,ID,Nom,Qte,Charges)
	if num == 1 then -- Oui
			local targetSave = ExchangeTarget;
			
			reinitVariableTransfert();
			
			local objet;
			if string.len(ID) == 16 then
				objet = TRP_Module_ObjetsPerso[ID];
				if objet == nil then
					createEmptyObjetWithID(ID);
					objet = TRP_Module_ObjetsPerso[ID];
					TRPSecureSendAddonMessage("GRS",ID,targetSave);
				end
			else
				objet = TRP_Objects[ID];
			end
			
			if objet == nil then
				TRPError("Internal error: ProceedObjetExchange, unknown object.\nID : "..ID);
			end
			
			
			local code = canReceiveObjet(ID,Qte);
			if code == 1 then -- OK !
				GetObjets(ID,"-1",tonumber(Qte),Charges);
				sendMessage("{j} "..Qte.."x{v}["..Nom.."]{j} added to the backpack (received from "..targetSave..").");
				if Charges then
					TRPSecureSendAddonMessage("GOD",ID.."|"..Qte.."|"..Charges,targetSave);
				else
					TRPSecureSendAddonMessage("GOD",ID.."|"..Qte,targetSave);
				end
			elseif code == 2 then -- Unique
				TRPSecureSendAddonMessage("SDM","{r}"..Joueur..ExchangeError["CANTUNIQUE"],targetSave);
				TRPError(ExchangeError["CANTUNIQUESELF"]);
			end
	else
		TRPSecureSendAddonMessage("SDM",ExchangeError["REFUSAL"]..Joueur..".",ExchangeTarget);
	end
	ExchangeTarget = nil;
end

function fetchInformationsEnter(message)
	local fetchTab = {};
	local i = 1;
	while (string.find(message,"\n") and i < 50)
	do
		fetchTab[i] = string.sub(message,1,string.find(message,"\n")-1);
		message = string.sub(message,string.find(message,"\n")+1,string.len(message));
		i = i + 1;
	end
	fetchTab[i] = string.sub(message,1,string.len(message));
	
	return fetchTab;
end

function VerifierInventaire(texte)

	local tableau = fetchInformationsEnter(texte);
	local retour = true;
	local i = 1;
	TabInvToDelete = {};
	table.foreach(tableau, function(range) 
		local ObjectFound;
		local ID = string.sub(tableau[range],1,string.find(tableau[range]," ")-1);
		tableau[range] = string.sub(tableau[range],string.len(ID)+2);
		local Qte = tonumber(string.sub(tableau[range],1,string.find(tableau[range]," ")-1));
		local bDelete = string.sub(string.reverse(tableau[range]),1,1);
		
		--debugMess("ID = "..tostring(ID));
		--debugMess("Qte = "..tostring(Qte));
		--debugMess("bDelete = "..tostring(bDelete));
		
		if ID and Qte and bDelete then
			if string.len(ID) ~= 16 then
				ObjectFound = TRP_Objects[ID];
			else
				ObjectFound = TRP_Module_ObjetsPerso[ID];
			end
			local SlotFound = GetSlotWithIDAndQte(ID,Qte);
			if not SlotFound then
				retour = false;
				if ObjectFound then
					TRPError("Missing component : ["..ObjectFound["Nom"].."].")
				else
					TRPError("Missing component.")
				end
				return;
			elseif bDelete == "1" then
				TabInvToDelete[i] = {};
				TabInvToDelete[i]["Slot"] = SlotFound;
				TabInvToDelete[i]["Qte"] = Qte;
				i = i + 1;
			end
		end
	end);
	return retour;
end

function UseObjet(SlotNum)
	local slot = TRP_Module_Inventaire[Royaume][Joueur][SlotNum];
	if slot then -- Slot non vide
		local objet;
		if string.len(slot["ID"]) ~= 16 then
			objet = TRP_Objects[slot["ID"]];
		else
			objet = TRP_Module_ObjetsPerso[slot["ID"]];
		end
		if objet["Utilisable"] then
			if objet["Utilisable"]["Cooldown"] then
				if TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][slot["ID"]] then
					if time() < tonumber(TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][slot["ID"]]) then
						TRPError("The item is not ready yet.");
						return;
					end
				end
			end
			if objet["Utilisable"]["Conditions"] then
				if objet["Utilisable"]["Conditions"]["User"] then
					if not VerifierConditions(objet["Utilisable"]["Conditions"]["User"],"player") then
						TRPError("You can't use this item.");
						return;
					end
				end
				if objet["Utilisable"]["Conditions"]["Cible"] then
					local nom = UnitName("target");
					if not nom then
						TRPError("You don't have any target.");
						return;
					end
					if objet["Utilisable"]["Conditions"]["Cible"]["Tests"] then
						if not VerifierConditions(objet["Utilisable"]["Conditions"]["Cible"]["Tests"],"target") then
							TRPError("Incorrect target.");
							return;
						end
					end
				end
				if objet["Utilisable"]["Conditions"]["Composants"] then
					if not VerifierInventaire(objet["Utilisable"]["Conditions"]["Composants"]) then
						return;
					end
				end
			end
			
			if setTRPColorToString(objet["Utilisable"]["ObjectOnUse"]) ~= "" then -- Utiliser les OnUse
				local can;
				if objet["Utilisable"]["ObjectOnUseQte"] then
					can = canReceiveObjet(objet["Utilisable"]["ObjectOnUse"],objet["Utilisable"]["ObjectOnUseQte"])
				else
					can = canReceiveObjet(objet["Utilisable"]["ObjectOnUse"],1);
				end
				if can == 2 then
					TRPError("You can not have more unity of this object.");
					return;
				end
			end
			
			local onDeath;
			---- DECOUNTABLE
			if objet["Utilisable"]["Charges"] ~= 0 then
				TRP_Module_Inventaire[Royaume][Joueur][SlotNum]["Qte"] = TRP_Module_Inventaire[Royaume][Joueur][SlotNum]["Qte"] - 1;
				-- Add un objet de charge - 1 
				if TRP_Module_Inventaire[Royaume][Joueur][SlotNum]["Charges"] > 1 then
					InvAddObjet(slot["ID"],TRP_Module_Inventaire[Royaume][Joueur][SlotNum]["Charges"] - 1,slot["Sac"]);
				else
					onDeath = true;
				end
				-- DELETE 
				if TRP_Module_Inventaire[Royaume][Joueur][SlotNum]["Qte"] < 1 then
					TRP_Module_Inventaire[Royaume][Joueur][SlotNum] = nil;
				end
			end
			----  MESSAGE
			--On Use
			local messaged = false;
			if setTRPColorToString(objet["Utilisable"]["EmotePublicOnUse"]) ~= "" and string.gsub(setTRPColorToString(objet["Utilisable"]["EmotePublicOnUse"])," ","") ~= "" then
				SendChatMessage(objet["Utilisable"]["EmotePublicOnUse"],"EMOTE");
			end
			if setTRPColorToString(objet["Utilisable"]["EmotePrivateOnUse"]) ~= "" and string.gsub(setTRPColorToString(objet["Utilisable"]["EmotePrivateOnUse"])," ","") ~= "" then
				sendMessage("{j}["..objet["Nom"].."] :\n{o}\""..objet["Utilisable"]["EmotePrivateOnUse"].."{o}\"",TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"],true);
				messaged = true;
			end
			-- On Death
			if onDeath and setTRPColorToString(objet["Utilisable"]["EmotePublicOnDeath"]) ~= "" and string.gsub(setTRPColorToString(objet["Utilisable"]["EmotePublicOnDeath"])," ","") ~= "" then
				SendChatMessage(objet["Utilisable"]["EmotePublicOnDeath"],"EMOTE");
			end
			if onDeath and setTRPColorToString(objet["Utilisable"]["EmotePrivateOnDeath"]) ~= "" and string.gsub(setTRPColorToString(objet["Utilisable"]["EmotePrivateOnDeath"])," ","") ~= "" then
				if messaged then
					sendMessage("{o}\""..objet["Utilisable"]["EmotePrivateOnDeath"].."\"",TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"],true);
				else
					sendMessage("{j}["..objet["Nom"].."] :\n{o}\""..objet["Utilisable"]["EmotePrivateOnDeath"].."\"",TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"],true);
				end
			end
			---- SOUND
			if onDeath and objet["Utilisable"]["SoundOnDeath"] then -- Utiliser les OnDeath
				TRPPlaySound(objet["Utilisable"]["SoundOnDeath"]);
				TRPPlaySoundGlobal(objet["Utilisable"]["SoundOnDeath"]);
			elseif objet["Utilisable"]["SoundOnUse"] then -- Utiliser les OnUse
				TRPPlaySound(objet["Utilisable"]["SoundOnUse"]);
				TRPPlaySoundGlobal(objet["Utilisable"]["SoundOnUse"]);
			end
			---- CREATION OBJET
			-- On Use
			if setTRPColorToString(objet["Utilisable"]["ObjectOnUse"]) ~= "" then -- Utiliser les OnUse
				if TRP_Module_ObjetsPerso[objet["Utilisable"]["ObjectOnUse"]] or TRP_Objects[objet["Utilisable"]["ObjectOnUse"]] then
					if objet["Utilisable"]["ObjectOnUseQte"] then
						GetObjets(objet["Utilisable"]["ObjectOnUse"],slot["Sac"],objet["Utilisable"]["ObjectOnUseQte"],nil);
					else
						GetObjets(objet["Utilisable"]["ObjectOnUse"],slot["Sac"],1,nil);
					end
				else
					TRPError("Error: You do not have the associated item of this item.");
				end
			end
			-- On Death
			if onDeath and setTRPColorToString(objet["Utilisable"]["ObjectOnDeath"]) ~= "" then -- Utiliser les OnDeath
				if TRP_Module_ObjetsPerso[objet["Utilisable"]["ObjectOnDeath"]] or TRP_Objects[objet["Utilisable"]["ObjectOnDeath"]] then
					if objet["Utilisable"]["ObjectOnDeathQte"] then
						GetObjets(objet["Utilisable"]["ObjectOnDeath"],slot["Sac"],objet["Utilisable"]["ObjectOnDeathQte"],nil);
					else
						GetObjets(objet["Utilisable"]["ObjectOnDeath"],slot["Sac"],1,nil);
					end
				else
					TRPError("Error: You do not have the associated item of this item.");
				end
			end
			
			if objet["Utilisable"]["Cooldown"] then
				TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][slot["ID"]] = time() + tonumber(objet["Utilisable"]["Cooldown"]);
			end
			
			if TabInvToDelete then
				table.foreach(TabInvToDelete, function(range)
					proceedDeleteObject(TabInvToDelete[range]["Slot"],TabInvToDelete[range]["Qte"]);
				end);
				wipe(TabInvToDelete);
				TabInvToDelete = nil;
			end
			
			if objet["Utilisable"]["LierAuDoc"] then
				if TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]] then
					PanelOpen("FicheJoueurOngletInventaire");
					afficheDocument(objet["Utilisable"]["LierAuDoc"]);
				else
					TRPError("Error: You do not have the associated document of this item.");
				end
			elseif MainInventaireFrame:IsVisible() then
				refreshInventaire();
			end
		end
	end
end

function DelGameObjet(Slot)
	if TRP_Module_Inventaire[Royaume][Joueur][Slot] ~= nil then
	local Message;
		if TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"] > 1 then -- Choix de quantité
			if string.len(TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]) == 16 then
				Message = JETER.."{v}["..TRP_Module_ObjetsPerso[TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]]["Nom"].."]{w} ?\n\nQuantity to drop ?\nMaximum : "..TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"];
			else
				Message = JETER.."{v}["..TRP_Objects[TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]]["Nom"].."]{w} ?\n\nQuantity to drop ?.\nMaximum : "..TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"];
			end
			StaticPopupDialogs["TRP_INV_DELETE_OBJECT_AMOUNT"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
			TRP_ShowStaticPopup("TRP_INV_DELETE_OBJECT_AMOUNT",nil,nil,Slot,nil,nil,nil,1,TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"]);
		else
			if string.len(TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]) == 16 then
				Message = JETER.."{v}["..TRP_Module_ObjetsPerso[TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]]["Nom"].."]{w} ?\n\n"..CONFIRMSUPPOBJET;
			else
				Message = JETER.."{v}["..TRP_Objects[TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]]["Nom"].."]{w} ?\n\n"..CONFIRMSUPPOBJET;
			end
			StaticPopupDialogs["TRP_INV_DELETE_OBJECT"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
			TRP_ShowStaticPopup("TRP_INV_DELETE_OBJECT",nil,nil,Slot,1);
		end
	end
end

function proceedDeleteObject(Slot,num)
	if TRP_Module_Inventaire[Royaume][Joueur][Slot] ~= nil then
		if not num then return end;
		local objet = GetObjectWithID(TRP_Module_Inventaire[Royaume][Joueur][Slot]["ID"]);
		if objet and objet["Nom"] then
			sendMessage("{j} "..num.."x{v}["..objet["Nom"].."]{j} removed from your inventory.");
		end
		TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"] = TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"] - num;
		if TRP_Module_Inventaire[Royaume][Joueur][Slot]["Qte"] < 1 then
			wipe(TRP_Module_Inventaire[Royaume][Joueur][Slot]);
			TRP_Module_Inventaire[Royaume][Joueur][Slot] = nil;
		end
		if MainInventaireFrame:IsVisible() then
			refreshInventaire();
		end
	else
		sendMessage("{r}Internal error: Deleting an object\nSlot = "..tostring(Slot).."\nNum = "..tostring(num));
	end
end

function GetObjectWithID(ID)
	if string.len(ID) ~= 16 then
		return TRP_Objects[ID];
	else
		return TRP_Module_ObjetsPerso[ID];
	end
end

function GetSlotWithIDAndQte(ID,Qte,Sac)
	return table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
		function(Emplacement)
			if Emplacement ~= "Or" and Emplacement ~= "Sacs" and TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["ID"] == ID
			and (Qte == nil or TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] >= Qte) and 
			(Sac == nil or TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Sac"] == Sac) then
				return Emplacement;
			end
		end);
end

function canReceiveObjet(ObjetID,Qte)
	-- 1 => OK
	-- 2 => Dépassement Unique
	local code=0;
	local objet;
	local count=0;

	objet = GetObjectWithID(ObjetID);
	--Compter pour le unique
	if objet then
		if objet["Unique"] ~= nil then
			table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
			function(Emplacement)
				if Emplacement ~= "Or" and Emplacement ~= "Sacs" and TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["ID"] == ObjetID then
					count = count + TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"];
				end
			end);
			if count + Qte > objet["Unique"] then
				code = 2;
			else
				code = 1;
			end
		else
			code = 1;
		end
	else
		TRPError("Internal error : canReceiveObjet avec ID d'un objet inconnu.\nID : "..tostring(ObjetID))
	end
	
	if code == 0 then
		TRPError("Internal error : canReceiveObjet avec code == 0.\nID : "..tostring(ObjetID).."\nQte : "..tostring(Qte));
	end
	return code;
end

function GetObjets(ObjetID,bagType,Qte,Charges)
	ObjetID = tostring(ObjetID); -- Securité
	bagType = tostring(bagType); -- Securité
	if not Qte then Qte = 1 end
	local code = canReceiveObjet(ObjetID,Qte);
	if code == 1 then
		for i=1,Qte,1 do
			InvAddObjet(ObjetID,Charges,bagType);
		end
		if bagType == "-1" then
			TRPRaccFlashSacADos:SetCooldown(0,0);
			TRPInvFlashSacADos:SetCooldown(0,0);
		elseif bagType == "0" then
			TRPRaccFlashCoffre:SetCooldown(0,0);
			TRPInvFlashCoffre:SetCooldown(0,0);
		else
			TRPRaccFlashPlanque:SetCooldown(0,0);
			TRPInvFlashPlanque:SetCooldown(0,0);
		end
	elseif code == 2 then
		TRPError(ExchangeError["CANTUNIQUESELF"]);
	end
end

function InvAddObjet(ObjetID,Charges,bagType)

	ObjetID = tostring(ObjetID) -- juste au cas où ...
	local Objet;
	if string.len(ObjetID) == 16 and TRP_Module_ObjetsPerso[ObjetID] ~= nil then
		Objet = TRP_Module_ObjetsPerso[ObjetID];
	elseif TRP_Objects[ObjetID] ~= nil then
		Objet = TRP_Objects[ObjetID];
	else
		debugMess("Erreur GameObjet introuvable, ObjetID = "..ObjetID)
		return false;
	end
	-- Si pas charges : charges par défaut
	if Charges == nil and Objet["Utilisable"] then
		Charges = Objet["Utilisable"]["Charges"];
	else
		Charges = tonumber(Charges);
	end
	-- Recherche d'empilement
	local ok = false;
	table.foreach(TRP_Module_Inventaire[Royaume][Joueur],
	function(Emplacement)
		if Emplacement ~= "Or" and Emplacement ~= "Sacs" and TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["ID"] == ObjetID then
			if TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Sac"] == bagType then
				if not TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Charges"] or TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Charges"] == Charges or TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Charges"] == 0 then
					if TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] < 999 then
						TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] = TRP_Module_Inventaire[Royaume][Joueur][Emplacement]["Qte"] + 1;
						ok = true;
						refreshInventaire();
						return;
					end
				end
			end
		end
	end);
	-- Nouvel emplacement
	if not ok then
		local i = 1;
		while i < 5000 do
			if TRP_Module_Inventaire[Royaume][Joueur][tostring(i)] == nil then
				TRP_Module_Inventaire[Royaume][Joueur][tostring(i)] = {};
				TRP_Module_Inventaire[Royaume][Joueur][tostring(i)]["ID"] = ObjetID;
				TRP_Module_Inventaire[Royaume][Joueur][tostring(i)]["Charges"] = Charges;
				TRP_Module_Inventaire[Royaume][Joueur][tostring(i)]["Qte"] = 1;
				TRP_Module_Inventaire[Royaume][Joueur][tostring(i)]["Sac"] = bagType;
				refreshInventaire();
				return true;
			end
			i = i + 1;
		end
	end
	
	return false;
end

function SwitchObjets(slot,Qte,dest)
	local emplacement = TRP_Module_Inventaire[Royaume][Joueur][tostring(slot)];

	if Qte == nil then
		Qte = emplacement["Qte"];
	end

	if emplacement["Sac"] == "-1" then -- Depuis sac � dos
		if dest == 0 then -- Vers coffre
			if IsMounted() == nil then
					TRPError(ObjectError["NOMOUNT"]);
					return;
			else
				littleSupress(slot,Qte);
				GetObjets(emplacement["ID"],0,Qte,emplacement["Charges"]);
			end
		elseif dest == 1 then -- Vers planque
			if DetectPlanque() == nil then
				TRPError(ObjectError["NOPLANQUE"]);
				return;
			else
				littleSupress(slot,Qte);
				GetObjets(emplacement["ID"],generatePlanqueID(),Qte,emplacement["Charges"]);
			end
		end
	elseif emplacement["Sac"] == "0" then -- Depuis coffre
		if IsMounted() == nil then
				TRPError(ObjectError["NOMOUNT"]);
			return;
		end
		if dest == 1 then -- Vers Sac à dos
			littleSupress(slot,Qte);
			GetObjets(emplacement["ID"],-1,Qte,emplacement["Charges"]);
		elseif dest == 0 then -- Vers planque
			if DetectPlanque() == nil then
				TRPError(ObjectError["NOPLANQUE"]);
				return;
			else
				littleSupress(slot,Qte);
				GetObjets(emplacement["ID"],generatePlanqueID(),Qte,emplacement["Charges"]);
			end
		end
	else -- Depuis planque
		if DetectPlanque() == nil then
			TRPError(ObjectError["NOPLANQUE"]);
			return;
		end
		if dest == 0 then -- Vers Sac � dos
			littleSupress(slot,Qte);
			GetObjets(emplacement["ID"],-1,Qte,emplacement["Charges"]);
		elseif dest == 1 then -- Vers coffre
			if IsMounted() == nil then
					TRPError(ObjectError["NOMOUNT"]);
					return;
			else
				littleSupress(slot,Qte);
				GetObjets(emplacement["ID"],0,Qte,emplacement["Charges"]);
			end
		end
	end
end

function littleSupress(slot,Qte)
	TRP_Module_Inventaire[Royaume][Joueur][tostring(slot)]["Qte"] = TRP_Module_Inventaire[Royaume][Joueur][tostring(slot)]["Qte"] - Qte;
	if TRP_Module_Inventaire[Royaume][Joueur][tostring(slot)]["Qte"] < 1 then
		TRP_Module_Inventaire[Royaume][Joueur][tostring(slot)] = nil;
	end
end

function refreshInventaire()
	--Refresh
	if FicheJoueurPanelInventaire:IsVisible() then
		if PanelCoffreSacFrameType:GetText() == COFFREFINANCES then
			InventaireOpen("InventaireOngletSacADos");
		elseif PanelCoffreSacFrameType:GetText() == COFFREVOYAGE then
			if IsMounted() then
				InventaireOpen("InventaireOngletCoffre");
			else
				TRPError("Vous get off your mount.");
				InventaireOpen("InventaireOngletSacADos");
			end
		elseif PanelCoffreSacFrameType:GetText() == PLANQUE then
			if DetectPlanque() ~= nil then
				InventaireOpen("InventaireOngletPlanques");
			else
				TRPError("You are too far from your hiding place.");
				InventaireOpen("InventaireOngletSacADos");
			end
		elseif ArgentText:GetText() == "ENVOI" then
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletMailBoxOut");
		elseif ArgentText:GetText() == "RECEPTION" then
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletMailBoxIn");
		end
	end
end

--[[ Backup

function refreshInventaire()
	--Refresh
	if FicheJoueurPanelInventaire:IsVisible() then
		if PanelCoffreSacFrameType:GetText() == COFFREFINANCES then
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletSacADos");
		elseif PanelCoffreSacFrameType:GetText() == COFFREVOYAGE then
			if IsMounted() then
				PanelOpen("FicheJoueurOngletInventaire","InventaireOngletCoffre");
			else
				TRPError("Vous \195\170tes descendu votre monture.");
				PanelOpen("FicheJoueurOngletInventaire","InventaireOngletSacADos");
			end
		elseif PanelCoffreSacFrameType:GetText() == PLANQUE then
			if DetectPlanque() ~= nil then
				PanelOpen("FicheJoueurOngletInventaire","InventaireOngletPlanques");
			else
				TRPError("Vous vous \195\170tes \195\169loign\195\169 de votre planque.");
				PanelOpen("FicheJoueurOngletInventaire","InventaireOngletSacADos");
			end
		elseif ArgentText:GetText() == "ENVOI" then
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletMailBoxOut");
		elseif ArgentText:GetText() == "RECEPTION" then
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletMailBoxIn");
		end
	end
end

]]

function SetObjetTooltip(tableauInventaire,bouton,bTransaction,Prix,PrixMax,bPlanque)
	GameTooltip:SetOwner(bouton, "ANCHOR_TOPLEFT");
	
	if tableauInventaire == nil then
		GameTooltip:AddLine(EMPLACEMENTLIBRE, 1, 1, 1);
	else
		local objet;
		local infoTab = {"","","",""};
		local i=0;
		
		if string.len(tableauInventaire["ID"]) ~= 16 then
			objet = TRP_Objects[tableauInventaire["ID"]];
		else
			objet = TRP_Module_ObjetsPerso[tableauInventaire["ID"]];
		end
		
		if tableauInventaire["Qte"] == nil then
			tableauInventaire["Qte"] = 1;
		end
		
		anchorModeleTo(objet["3DModel"],FicheJoueur,bouton);
		
		if objet["Unique"] ~= nil then
			infoTab[i+1] = STOCKUNIQUE.." ("..objet["Unique"]..")";
			i = i + 1;
		end
		if tableauInventaire["Qte"]*objet["Poids"] > 0 then
			local poids = tableauInventaire["Qte"]*objet["Poids"];
			if poids < 1000 then
				infoTab[i+1] = POIDSTEXT.." : "..poids.." g";
			else
				infoTab[i+1] = POIDSTEXT.." : "..(poids/1000).." kg";
			end
			i = i + 1;
		end
		if objet["Utilisable"] ~= nil and objet["Utilisable"]["Charges"] > 1 then
			if tableauInventaire["Charges"] == nil then
				tableauInventaire["Charges"] = objet["Utilisable"]["Charges"];
			end
			infoTab[i+1] = "< "..tableauInventaire["Charges"].." charge(s) >";
			i = i + 1;
		end
		
		GameTooltip:AddLine(objet["Nom"], 1, 1, 1);
		if objet["SousType"] ~= 1 and TRP_ObjetCategorie[objet["Type"]] and TRP_ObjetCategorie[objet["Type"]].SousCategorie[objet["SousType"]] then
			GameTooltip:AddDoubleLine("< "..TRP_ObjetCategorie[objet["Type"]].Nom.." >","< "..TRP_ObjetCategorie[objet["Type"]].SousCategorie[objet["SousType"]].." >",1,1,1,1,1,1);
		elseif TRP_ObjetCategorie[objet["Type"]] then
			GameTooltip:AddLine("< "..TRP_ObjetCategorie[objet["Type"]].Nom.." >", 1, 1, 1);
		end
		
		GameTooltip:AddDoubleLine(infoTab[1],infoTab[2],1,1,1,1,1,1);
		GameTooltip:AddDoubleLine(infoTab[3],infoTab[4],1,1,1,1,1,1);

		GameTooltip:AddLine(" ", 1, 1, 1);
		decouperForTooltip(setTRPColorToString("\""..objet["Description"].."\"",true),40,1,0.75,0);
		
		if  objet["Utilisable"] ~= nil and objet["Utilisable"]["UseTooltip"] ~= nil and objet["Utilisable"]["UseTooltip"] ~= "" then
			GameTooltip:AddLine(" ", 1, 1, 1);
			GameTooltip:AddLine( UTILISER.." : "..setTRPColorToString(objet["Utilisable"]["UseTooltip"]),0,1,0);
		end
		
		if  objet["Utilisable"] and objet["Utilisable"]["Cooldown"] then
			if TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][tableauInventaire["ID"]] and TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][tableauInventaire["ID"]] > time() then
				GameTooltip:AddLine(" ", 1, 1, 1);
				local secondes = TRP_Module_Inventaire[Royaume][Joueur]["Cooldown"][tableauInventaire["ID"]]-time();
				local jour,heure,minutes,message;
				if secondes > 86400 then
					jour = math.floor(secondes/86400);
					if jour == 1 then
						message = "2 d";
					else
						message = jour.." d";
					end
				elseif secondes > 3600 then
					heure = math.floor(secondes/3600);
					if heure == 1 then
						message = "2 h";
					else
						message = heure.." h";
					end
				elseif secondes > 60 then
					minutes = math.floor(secondes/60);
					if minutes == 1 then
						message = "2 min";
					else
						message = minutes.." min";
					end
				else
					message = secondes.." sec";
				end
				GameTooltip:AddLine( "Cooldown : "..message,1,1,1);
			end
		end
		
		if objet["Utilisable"] ~= nil and objet["Utilisable"]["LierAuDoc"] ~= nil then
			GameTooltip:AddLine(" ", 1, 1, 1);
			GameTooltip:AddLine(" Related document : ", 0, 0.5, 1);
			if TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]] ~= nil then
				GameTooltip:AddLine("   |TInterface\\ICONS\\"..TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteIcone"]..".blp:45:45|t", 0, 0.75, 1);
				if TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteTitre"] ~= "" then
					GameTooltip:AddLine("   Title : |cffffffff"..setTRPColorToString(TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteTitre"]), 0, 0.75, 1);
				end
				if TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteAuteur"] ~= "" then
					GameTooltip:AddLine("   Author : |cffffffff"..setTRPColorToString(TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteAuteur"]), 0, 0.75, 1);
				end
				if TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteDate"] ~= "" then
					GameTooltip:AddLine("   Date : |cffffffff"..setTRPColorToString(TRP_Module_Documents[objet["Utilisable"]["LierAuDoc"]]["VignetteDate"]), 0, 0.75, 1);
				end
			else
				GameTooltip:AddLine(" Error: you do not have the \ ninformationof the associated document.", 1, 0, 0);
			end
		end
		
		if TRP_Module_Configuration["Modules"]["Tooltip"]["AideInventaire"] and not bTransaction and not bPlanque then
			GameTooltip:AddLine(" ", 1, 1, 1);
			GameTooltip:AddLine(CLICGAUCHEMAJ.." : ".."Prepare a package",1,0.4,1);
			GameTooltip:AddLine(CLICGAUCHEALT.." : ".."Send to ... (Account)",0.4,1,0.7);

			if tableauInventaire["Sac"] == "-1" then -- Depuis sac à dos
				if IsMounted() then
					GameTooltip:AddLine("|cff00ffff"..CLICDROITMAJ.." : "..PLACEDANSCOFFRE,1,0.4,0.4);
				end
				if DetectPlanque() then
					GameTooltip:AddLine("|cff00ffff"..CLICDROITCTRL.." : "..PLACEDANSPLANQUE,1,0.4,0.4);
				end
			elseif tableauInventaire["Sac"] == "0" then -- Depuis coffre
				GameTooltip:AddLine("|cff00ffff"..CLICDROITCTRL.." : "..PLACEDANSSAC,1,0.4,0.4);
				if DetectPlanque() then
					GameTooltip:AddLine("|cff00ffff"..CLICDROITMAJ.." : "..PLACEDANSPLANQUE,1,0.4,0.4);
				end
			else -- Depuis planque
				GameTooltip:AddLine("|cff00ffff"..CLICDROITMAJ.." : "..PLACEDANSSAC,1,0.4,0.4);
				if IsMounted() then
					GameTooltip:AddLine("|cff00ffff"..CLICDROITCTRL.." : "..PLACEDANSCOFFRE,1,0.4,0.4);
				end
			end
			
			if tableauInventaire["Sac"] == "-1" and UnitName("target") ~= nil and UnitName("target") ~= Joueur 
				and UnitIsPlayer("target") and UnitFactionGroup("target") == UnitFactionGroup("player") 
				and CheckInteractDistance("target",3) ~= nil then
				GameTooltip:AddLine(CLICGAUCHECTRL.." : "..DONNER..UnitName("target"), 0.5, 0.5,1);
				GameTooltip:AddLine("Right click + Alt".." : ".."Show to "..UnitName("target"), 0.5, 0.5,1);
			end
			GameTooltip:AddLine(CLICDROIT.." : "..JETEROBJET,1,0.4,0.4);
		end
	end
	GameTooltip:Show();
end
