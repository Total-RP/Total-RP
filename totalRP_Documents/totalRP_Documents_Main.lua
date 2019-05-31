function DocumentsOpen(Panel,Arg0)
	FicheJoueurPanelDocuments:Show();
	FicheJoueurOngletInventaire:Disable();
	FicheJoueurOngletInventaireIcon:SetAlpha(0.5);
	FicheJoueurOngletDocument:Disable();
	FicheJoueurOngletDocumentIcon:SetAlpha(0.5);
	FicheJoueurFond:SetTexture("Interface\\Stationery\\AuctionStationery1.blp");
	FicheJoueurFondDroite:SetTexture("Interface\\Stationery\\AuctionStationery2.blp");
	PanelDocumentsListe:Hide();
	PanelDocumentsConsulte:Hide();
	PanelDocumentsModifier:Hide();
	InventaireOngletSacADosDocuIcon:SetTexture("Interface\\Icons\\"..TRP_SacsADos[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["SacADos"]]["Icone"]..".blp");
	InventaireOngletCoffreDocuIcon:SetTexture("Interface\\Icons\\"..TRP_CoffreMonture[TRP_Module_Inventaire[Royaume][Joueur]["Sacs"]["Monture"]]["Icone"]..".blp");
	
	if Panel == nil or Panel == "DocumentsPanelListe" then
		FicheJoueurPanelTitle:SetText(DOCUMENT);
		PanelDocumentsListe:Show();
		DocumentsChargerListe();
	elseif Panel == "DocumentsPanelConsulte" then
		PanelDocumentsConsulte:Show();
		afficheDocument(Arg0);
	elseif Panel == "DocumentsPanelModifier" then
		PanelDocumentsModifier:Show();
		FicheJoueurPanelTitle:SetText(EDITIONDUCO);
		afficheDocumentModifier(Arg0);
	end
end

function DocumentsChargerListe()
	local count=0;
	
	PanelDocumentsListeSlider:SetOrientation("VERTICAL");
	PanelDocumentsListeSlider:Hide();
	PanelDocumentsListeSlider:SetValue(0);
	
	wipe(DocumentsTab);
	
	table.foreach(TRP_Module_Documents,
	function(document)
		if PanelDocumentListeRecherche:GetText() == "" or string.find(string.lower(TRP_Module_Documents[document]["VignetteTitre"]),string.lower(PanelDocumentListeRecherche:GetText())) or
			string.find(string.lower(TRP_Module_Documents[document]["Createur"]),string.lower(PanelDocumentListeRecherche:GetText())) then
			DocumentsTab[count] = document;
			count = count + 1;
		end
	end);
	
	if count > 5 then
		PanelDocumentsListeSlider:Show();
		local total = ceil(count/5)-1;
		PanelDocumentsListeSlider:SetMinMaxValues(0,total);
	end
	
	--Triage par nom pour le moment
	table.sort(DocumentsTab);
	
	if count == 0 then
		PanelDocumentsListeEmpty:SetText(EMPTYLISTDOC);
	else
		PanelDocumentsListeEmpty:SetText("");
	end
	
	ChargerSliderDocumentVertical(PanelDocumentsListeSlider:GetValue());
end

function Reinit_Documents()
	for i=1,5,1 do
		getglobal("DocumentsSlot"..i):Hide();
		getglobal("DocumentsSlot"..i.."Edit"):Hide();
		getglobal("DocumentsSlot"..i.."Delete"):Hide();
	end
	Reinit_DocumentsEdit();
end

function Reinit_DocumentsEdit()
	for i=1,5,1 do
		getglobal("DocumentsSlot"..i.."Edit"):Hide();
		getglobal("DocumentsSlot"..i.."Delete"):Hide();
	end
end

function ChargerSliderDocumentVertical(num)
	Reinit_Documents();
	
	if DocumentsTab ~= nil then
		local i = 1;
		local j = 1;
		table.foreach(DocumentsTab,
		function(document)
			if i > num*5 and i <= (num+1)*5 then
				-- DocumentsTab = reference
				local ID = DocumentsTab[document];

				getglobal("DocumentsSlot"..j.."Icon"):SetTexture("Interface\\Icons\\"..TRP_Module_Documents[ID]["VignetteIcone"]..".blp");
				getglobal("DocumentsSlot"..j.."Titre"):SetText(setTRPColorToString(TRP_Module_Documents[ID]["VignetteTitre"]));
				getglobal("DocumentsSlot"..j.."Auteur"):SetText("|cffff9900Author : |cffffffff"..setTRPColorToString(TRP_Module_Documents[ID]["VignetteAuteur"]));
				getglobal("DocumentsSlot"..j.."Date"):SetText("|cffff9900Date : |cffffffff"..setTRPColorToString(TRP_Module_Documents[ID]["VignetteDate"]));
				getglobal("DocumentsSlot"..j.."ID"):SetText(ID);
				getglobal("DocumentsSlot"..j):Show();
				getglobal("DocumentsSlot"..j):Enable();
				getglobal("DocumentsSlot"..j):SetScript("OnClick", 
					function(self,button,down)
						if IsControlKeyDown() then
							donnerDocument(ID);
						else
							if TRP_Module_Documents[ID]["Createur"] ~= Joueur then
								TRPError("You are not the creator of this document.\nYou have to use the associated item to consulte the document\nIf this document don't possessed any associated item, warn the creator.");
							else
								afficheDocument(ID);
							end
						end
				end );
				getglobal("DocumentsSlot"..j):SetScript("OnUpdate", 
					function(self)
						if TRP_Module_Documents[ID]["Createur"] ~= Joueur then
							getglobal(self:GetName().."Icon"):SetVertexColor(1, 0, 0);
						else
							getglobal(self:GetName().."Icon"):SetVertexColor(1, 1, 1);
						end
				end );
				
				j = j + 1;
			end
			i = i + 1;
		end);
	end
end

function donnerDocument(ID)

	local document = TRP_Module_Documents[ID];
	
	if document == nil then
		TRPError("Internal error : Donner une document inexistant");
		return;
	elseif UnitName("target") == nil or UnitName("target") == Joueur or not UnitIsPlayer("target") or UnitFactionGroup("target") ~= UnitFactionGroup("player") then
		TRPError(ExchangeError["NOTARGET"]);
		return;
	elseif CheckInteractDistance("target",3) == nil then
		TRPError(ExchangeError["NORANGE"]);
		return;
	end
	TRPSecureSendAddonMessage("GDA",ID.."|"..document["Createur"].."|"..document["VignetteTitre"],UnitName("target"));
	sendMessage("{o}Document trade query sent to "..UnitName("target")..".");
end

function AskingDocument(docu,sender)
	if string.len(objet[1]) > 16 then return end;
	if UnitAffectingCombat("player") ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..Joueur..ExchangeError["ISFINGHTING"],sender);
		return;
	end
	
	if ExchangeTarget ~= nil then
		TRPSecureSendAddonMessage("SDM","{r}"..ExchangeError["ALREADYEXCHNAGE"],sender);
		return;
	end
	
	local ID = docu[1];
	local Auteur = docu[2];
	local Nom = docu[3];
	
	ExchangeTarget = sender;
	
	if not TRP_Module_Documents[ID] or (TRP_Module_Documents[ID] and TRP_Module_Documents[ID]["Createur"] == Auteur and Auteur == sender and TRP_Module_Configuration["Modules"]["Documents"]["Niveau"] == 3) or TRP_Module_Configuration["Modules"]["Documents"]["Niveau"] == 4 then
		--auto accept
		ProceedDocument(ID,sender,1,Auteur);
	else
		local Message = sender;
		local Titre;
		if TRP_Module_Documents[ID] ~= nil then -- Connu !
			if TRP_Module_Documents[ID]["Createur"] == Auteur then -- Meme auteur
				if Auteur ~= sender then --L'auteur n'est pas l'envoyeur
					Titre = Exchange["DOCUREFASKINGMAJ"];
					Message = Message..Exchange["DOCUREFASKINGD"].."{v}Your version :\n {o}Name : {w}"..TRP_Module_Documents[ID]["VignetteTitre"].."\n{o}Creator : {w}"..TRP_Module_Documents[ID]["Createur"];
					Message = Message.."\n\n{r}"..sender.."'s version :\n {o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["DOCUREFASKINGBWARNINGB"];
				else -- L'auteur est l'envoyeur
					Titre = Exchange["DOCUREFASKINGMAJ"];
					Message = Message..Exchange["DOCUREFASKINGE"].."{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["DOCUREFASKINGC"];
				end
			else -- Changement d'auteur !
				Titre = Exchange["DOCUREFASKINGMAJ"];
				Message = Message..Exchange["DOCUREFASKINGD"].."{v}Votre version :\n {o}Name : {w}"..TRP_Module_Documents[ID]["VignetteTitre"].."\n{o}Creator : {w}"..TRP_Module_Documents[ID]["Createur"];
				Message = Message.."{r}\n\n"..sender.."'s version :\n {o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["DOCUREFASKINGBWARNING"];
			end
		else -- Pas connaitre
			Titre = Exchange["DOCUREFASKING"];
			Message = Message..Exchange["DOCUREFASKINGB"].."{o}Name : {w}"..Nom.."\n{o}Creator : {w}"..Auteur..Exchange["DOCUREFASKINGC"];
		end
		TRPWaitingForInfos = true;
		StaticPopupDialogs["TRP_DOC_ASKING"].text = setTRPColorToString(TRP_ENTETE.." \n "..Message);
		TRP_ShowStaticPopup("TRP_DOC_ASKING",nil,nil,ID,ExchangeTarget,Auteur);
	end
end

function ProceedDocument(ID,Cible,Num,Auteur)
	if Num == 1 then --Accept
		if TRP_Module_Documents[ID] == nil then
			createDocumentWithID(ID);
		end
		TRP_Module_Documents[ID]["Createur"] = Auteur;
		TRPSecureSendAddonMessage("GDP",ID,Cible);
	else --Refusal
		TRPSecureSendAddonMessage("SDM",ExchangeError["REFUSAL"]..Joueur..".",Cible);
	end
	reinitVariableTransfert();
end

function SendDocument(docu,sender)
	local ID = docu[1];
	local document = TRP_Module_Documents[ID];
	-- De base : ID(16) - Etape (3)
	if document ~= nil then
		--Vignette : titre(51) - Auteur(51) - Date (51) - Icone(51)  = 204
		TRPSecureSendAddonMessage("GDS",ID.."|".."0|"..document["VignetteTitre"].."|"..document["VignetteAuteur"].."|"..document["VignetteDate"].."|"..document["VignetteIcone"],sender);
		--Titre : titre(81) - Font(3) - Taille(3) - Surligne(2) - Ombre(4) - Align(2) - DifX(4) - DifY(4)
		--Signature : titre(81) - Font(3) - Taille(3) - Surligne(2) - Ombre(4) - Align(2) - DifX(4) - DifY(4)
		local message = document["Titre"]["Titre"].."|"..document["Titre"]["Font"].."|"..document["Titre"]["Taille"].."|"..document["Titre"]["Surligner"].."|"..document["Titre"]["Ombre"].."|"
						..document["Titre"]["Alignement"].."|"..document["Titre"]["DifX"].."|"..document["Titre"]["DifY"].."|"..
						document["Signature"]["Auteur"].."|"..document["Signature"]["Font"].."|"..document["Signature"]["Taille"].."|"..document["Signature"]["Surligner"].."|"..
						document["Signature"]["Ombre"].."|"..document["Signature"]["Alignement"].."|"..document["Signature"]["DifX"].."|"..document["Signature"]["DifY"];
		TRPSecureSendAddonMessage("GDS",ID.."|".."1|"..message,sender);
		--Image 1 : Nom(81) - taille x(4) - Taille Y(4) - pos X(4) - Pos y(4) - Alpha(4) 
		--Image 2 : Nom(81) - taille x(4) - Taille Y(4) - pos X(4) - Pos y(4) - Alpha(4) 
		local message = document["Images"]["Image1"]["Nom"].."|"..document["Images"]["Image1"]["SizeX"].."|"..document["Images"]["Image1"]["SizeY"].."|"..document["Images"]["Image1"]["PosX"]
						.."|"..document["Images"]["Image1"]["PosY"].."|"..document["Images"]["Image1"]["Alpha"].."|"..
						document["Images"]["Image2"]["Nom"].."|"..document["Images"]["Image2"]["SizeX"].."|"..document["Images"]["Image2"]["SizeY"].."|"..document["Images"]["Image2"]["PosX"]
						.."|"..document["Images"]["Image2"]["PosY"].."|"..document["Images"]["Image2"]["Alpha"];
		TRPSecureSendAddonMessage("GDS",ID.."|".."2|"..message,sender);
		--Image 3 : Nom(81) - taille x(4) - Taille Y(4) - pos X(4) - Pos y(4) - Alpha(4) 
		-- Texte : Font(3) - Taille(3) - Surligne(2) - Ombre(4) - Align(2) 
		-- Background : number(3)
		-- Option : lock(2) - lier(2)
		local message = document["Images"]["Image3"]["Nom"].."|"..document["Images"]["Image3"]["SizeX"].."|"..document["Images"]["Image3"]["SizeY"].."|"..document["Images"]["Image3"]["PosX"]
						.."|"..document["Images"]["Image3"]["PosY"].."|"..document["Images"]["Image3"]["Alpha"].."|"..
						document["Texte"]["Font"].."|"..document["Texte"]["Taille"].."|"..document["Texte"]["Surligner"].."|"..document["Texte"]["Ombre"]
						.."|"..document["Texte"]["Alignement"].."|"..document["Background"].."|";
		
		if document["Lock"] then
			message = message.."true";
		end
		message = message.."|";
		if document["Lier"] then
			message = message.."true";
		end
		
		TRPSecureSendAddonMessage("GDS",ID.."|".."3|"..message,sender);
		local i=1;
		table.foreach(document["Texte"]["Texte"],
		function(texte)
			TRPSecureSendAddonMessage("GDS",ID.."|".."4|"..i.."|"..document["Texte"]["Texte"][texte],sender);
			i = i+1;
		end);
		-- Etape 10 : fin d'envoi
		TRPSecureSendAddonMessage("GDS",ID.."|".."10",sender);
	else
		TRPError("Internal error : envois d'info d'un document inexistant");
	end
end

function ReceiveDocument(docu,sender)
	-- 1 : ID
	local ID = docu[1];
	-- 2 : Etape
	local etape = tonumber(docu[2]);
	-- 3,4,5 ... info
	if TRP_Module_Documents[ID] ~= nil then
		if etape == 0 then
			--Vignette
			TRP_Module_Documents[ID]["VignetteIcone"] = docu[6];
			TRP_Module_Documents[ID]["VignetteTitre"] = docu[3];
			TRP_Module_Documents[ID]["VignetteAuteur"] = docu[4];
			TRP_Module_Documents[ID]["VignetteDate"] = docu[5];
			if PanelDocumentsListe:IsVisible() then
				PanelOpen("FicheJoueurOngletDocument","DocumentsPanelListe");
			end
		elseif etape == 1 then
			TRP_Module_Documents[ID]["Titre"]["Titre"] = docu[3];
			TRP_Module_Documents[ID]["Titre"]["Font"] = tonumber(docu[4]);
			TRP_Module_Documents[ID]["Titre"]["Taille"] = tonumber(docu[5]);
			TRP_Module_Documents[ID]["Titre"]["Surligner"] = tonumber(docu[6]);
			TRP_Module_Documents[ID]["Titre"]["Ombre"] = tonumber(docu[7]);
			TRP_Module_Documents[ID]["Titre"]["Alignement"] = tonumber(docu[8]);
			TRP_Module_Documents[ID]["Titre"]["DifX"] = tonumber(docu[9]);
			TRP_Module_Documents[ID]["Titre"]["DifY"] = tonumber(docu[10]);
			TRP_Module_Documents[ID]["Signature"]["Auteur"] = docu[11];
			TRP_Module_Documents[ID]["Signature"]["Font"] = tonumber(docu[12]);
			TRP_Module_Documents[ID]["Signature"]["Taille"] = tonumber(docu[13]);
			TRP_Module_Documents[ID]["Signature"]["Surligner"] = tonumber(docu[14]);
			TRP_Module_Documents[ID]["Signature"]["Ombre"] = tonumber(docu[15]);
			TRP_Module_Documents[ID]["Signature"]["Alignement"] = tonumber(docu[16]);
			TRP_Module_Documents[ID]["Signature"]["DifX"] = tonumber(docu[17]);
			TRP_Module_Documents[ID]["Signature"]["DifY"] = tonumber(docu[18]);
		elseif etape == 2 then
			TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"] = docu[3];
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"] = tonumber(docu[4]);
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"] = tonumber(docu[5]);
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"] = tonumber(docu[6]);
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"] = tonumber(docu[7]);
			TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"] = tonumber(docu[8]);
			TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"] = docu[9];
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"] = tonumber(docu[10]);
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"] = tonumber(docu[11]);
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"] = tonumber(docu[12]);
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"] = tonumber(docu[13]);
			TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"] = tonumber(docu[14]);
		elseif etape == 3 then
			TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"] = docu[3];
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"] = tonumber(docu[4]);
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"] = tonumber(docu[5]);
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"] = tonumber(docu[6]);
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"] = tonumber(docu[7]);
			TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"] = tonumber(docu[8]);
			TRP_Module_Documents[ID]["Texte"]["Font"] = tonumber(docu[9]);
			TRP_Module_Documents[ID]["Texte"]["Taille"] = tonumber(docu[10]);
			TRP_Module_Documents[ID]["Texte"]["Surligner"] = tonumber(docu[11]);
			TRP_Module_Documents[ID]["Texte"]["Ombre"] = tonumber(docu[12]);
			TRP_Module_Documents[ID]["Texte"]["Alignement"] = tonumber(docu[13]);
			TRP_Module_Documents[ID]["Background"] = tonumber(docu[14]);
			if docu[15] ~= nil and docu[15] == "true" then
				TRP_Module_Documents[ID]["Lock"] = true;
			else
				TRP_Module_Documents[ID]["Lock"] = nil;
			end
			if docu[16] ~= nil and docu[16] == "true" then
				TRP_Module_Documents[ID]["Lier"] = true;
			else
				TRP_Module_Documents[ID]["Lier"] = nil;
			end
		elseif etape == 4 then
			if tonumber(docu[3]) == 1 then
				TRP_Module_Documents[ID]["Texte"]["Texte"] = nil;
				TRP_Module_Documents[ID]["Texte"]["Texte"] = {};
			end
			TRP_Module_Documents[ID]["Texte"]["Texte"][tonumber(docu[3])] = docu[4];
		elseif etape == 10 then -- Fin de transaction
			checkDocumentIntegrity(ID);
			TRPSecureSendAddonMessage("SDM","{v}"..Joueur.." has succefully receive your document \""..TRP_Module_Documents[ID]["VignetteTitre"].."\".",sender);
			if TRPWaitingForInfos then
				TRPWaitingForInfos = nil;
				sendMessage("{v}You succefully receive the document \""..TRP_Module_Documents[ID]["VignetteTitre"].."\" from "..sender..".");
			end
			if PanelDocumentsConsulte:IsVisible() and PanelDocumentsNomHidden:GetText() == ID then
				PanelOpen("FicheJoueurOngletDocument","DocumentsPanelConsulte",PanelDocumentsNomHidden:GetText());
			end
			ExchangeTarget = nil;
		end
	else
		TRPError("Internal error : reception d'info d'un document inexistant");
	end
end

function checkDocumentIntegrity(ID)
	if TRP_Module_Documents[ID] ~= nil then
		if string.match(ID,"[%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d]") == nil then
			debugMess("Document périmé : suppresion\nId = "..ID);
			wipe(TRP_Module_Documents[ID]);
			TRP_Module_Documents[ID] = nil;
			return;
		end
		if TRP_Module_Documents[ID]["Createur"] == nil then
			TRP_Module_Documents[ID]["Createur"] = Joueur;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Createur");
		end
		if TRP_Module_Documents[ID]["VignetteIcone"] == nil then
			TRP_Module_Documents[ID]["VignetteIcone"] = "INV_Scroll_12";
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = VignetteIcone");
		end
		if TRP_Module_Documents[ID]["VignetteTitre"] == nil then
			TRP_Module_Documents[ID]["VignetteTitre"] = "Nouveau document";
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = VignetteTitre");
		end
		if TRP_Module_Documents[ID]["VignetteAuteur"] == nil then
			TRP_Module_Documents[ID]["VignetteAuteur"] = "(Inconnu)";
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = VignetteAuteur");
		end
		if TRP_Module_Documents[ID]["VignetteDate"] == nil then
			TRP_Module_Documents[ID]["VignetteDate"] = "(Inconnue)";
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = VignetteDate");
		end
		if TRP_Module_Documents[ID]["Texte"] == nil then
			TRP_Module_Documents[ID]["Texte"] = {};
			TRP_Module_Documents[ID]["Texte"]["Texte"] = {};
			TRP_Module_Documents[ID]["Texte"]["Font"] = 1;
			TRP_Module_Documents[ID]["Texte"]["Taille"] = 11;
			TRP_Module_Documents[ID]["Texte"]["Surligner"] = 1;
			TRP_Module_Documents[ID]["Texte"]["Ombre"] = 100;
			TRP_Module_Documents[ID]["Texte"]["Alignement"] = 1;
			TRP_Module_Documents[ID]["Titre"] = {};
			TRP_Module_Documents[ID]["Titre"]["Titre"] = "Nouveau document";
			TRP_Module_Documents[ID]["Titre"]["Font"] = 1;
			TRP_Module_Documents[ID]["Titre"]["Taille"] = 11;
			TRP_Module_Documents[ID]["Titre"]["Surligner"] = 1;
			TRP_Module_Documents[ID]["Titre"]["Ombre"] = 100;
			TRP_Module_Documents[ID]["Titre"]["Alignement"] = 2;
			TRP_Module_Documents[ID]["Titre"]["DifX"] = 165;
			TRP_Module_Documents[ID]["Titre"]["DifY"] = 360;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte");
		else
			if TRP_Module_Documents[ID]["Texte"]["Texte"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Texte"] = {};
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Texte");
			end
			if TRP_Module_Documents[ID]["Texte"]["Font"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Font"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Font");
			end
			if TRP_Module_Documents[ID]["Texte"]["Taille"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Taille"] = 11;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Taille");
			end
			if TRP_Module_Documents[ID]["Texte"]["Surligner"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Surligner"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Surligner");
			end
			if TRP_Module_Documents[ID]["Texte"]["Ombre"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Ombre"] = 100;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Ombre");
			end
			if TRP_Module_Documents[ID]["Texte"]["Alignement"] == nil then
				TRP_Module_Documents[ID]["Texte"]["Alignement"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Texte : Alignement");
			end
		end
		if TRP_Module_Documents[ID]["Titre"] == nil then
			TRP_Module_Documents[ID]["Titre"] = {};
			TRP_Module_Documents[ID]["Titre"]["Titre"] = "Nouveau document";
			TRP_Module_Documents[ID]["Titre"]["Font"] = 1;
			TRP_Module_Documents[ID]["Titre"]["Taille"] = 11;
			TRP_Module_Documents[ID]["Titre"]["Surligner"] = 1;
			TRP_Module_Documents[ID]["Titre"]["Ombre"] = 100;
			TRP_Module_Documents[ID]["Titre"]["Alignement"] = 2;
			TRP_Module_Documents[ID]["Titre"]["DifX"] = 165;
			TRP_Module_Documents[ID]["Titre"]["DifY"] = 360;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre");
		else
			if TRP_Module_Documents[ID]["Titre"]["Titre"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Titre"] = "Nouveau document";
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Titre");
			end
			if TRP_Module_Documents[ID]["Titre"]["Font"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Font"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Font");
			end
			if TRP_Module_Documents[ID]["Titre"]["Taille"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Taille"] = 11;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Taille");
			end
			if TRP_Module_Documents[ID]["Titre"]["Surligner"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Surligner"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Surligner");
			end
			if TRP_Module_Documents[ID]["Titre"]["Ombre"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Ombre"] = 100;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Ombre");
			end
			if TRP_Module_Documents[ID]["Titre"]["Alignement"] == nil then
				TRP_Module_Documents[ID]["Titre"]["Alignement"] = 2;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : Alignement");
			end
			if TRP_Module_Documents[ID]["Titre"]["DifX"] == nil then
				TRP_Module_Documents[ID]["Titre"]["DifX"] = 165;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : DifX");
			end
			if TRP_Module_Documents[ID]["Titre"]["DifY"] == nil then
				TRP_Module_Documents[ID]["Titre"]["DifY"] = 360;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Titre : DifY");
			end
		end
		
		if TRP_Module_Documents[ID]["Signature"] == nil then
			TRP_Module_Documents[ID]["Signature"] = {};
			TRP_Module_Documents[ID]["Signature"]["Auteur"] = "(Inconnu)";
			TRP_Module_Documents[ID]["Signature"]["Font"] = 1;
			TRP_Module_Documents[ID]["Signature"]["Taille"] = 11;
			TRP_Module_Documents[ID]["Signature"]["Surligner"] = 1;
			TRP_Module_Documents[ID]["Signature"]["Ombre"] = 100;
			TRP_Module_Documents[ID]["Signature"]["Alignement"] = 2;
			TRP_Module_Documents[ID]["Signature"]["DifX"] = 165;
			TRP_Module_Documents[ID]["Signature"]["DifY"] = 360;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature");
		else
			if TRP_Module_Documents[ID]["Signature"]["Auteur"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Auteur"] = "(Inconnu)";
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Auteur");
			end
			if TRP_Module_Documents[ID]["Signature"]["Font"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Font"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Font");
			end
			if TRP_Module_Documents[ID]["Signature"]["Taille"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Taille"] = 11;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Taille");
			end
			if TRP_Module_Documents[ID]["Signature"]["Surligner"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Surligner"] = 1;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Surligner");
			end
			if TRP_Module_Documents[ID]["Signature"]["Ombre"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Ombre"] = 100;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Ombre");
			end
			if TRP_Module_Documents[ID]["Signature"]["Alignement"] == nil then
				TRP_Module_Documents[ID]["Signature"]["Alignement"] = 2;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : Alignement");
			end
			if TRP_Module_Documents[ID]["Signature"]["DifX"] == nil then
				TRP_Module_Documents[ID]["Signature"]["DifX"] = 165;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : DifX");
			end
			if TRP_Module_Documents[ID]["Signature"]["DifY"] == nil then
				TRP_Module_Documents[ID]["Signature"]["DifY"] = 360;
				debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Signature : DifY");
			end
		end
		if TRP_Module_Documents[ID]["Background"] == nil then
			TRP_Module_Documents[ID]["Background"] = 1;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Background");
		end
		if TRP_Module_Documents[ID]["Images"] == nil then
			TRP_Module_Documents[ID]["Images"] = {};
			TRP_Module_Documents[ID]["Images"]["Image1"] = {};
			TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"] = "";
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"] = 165;
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"] = 220;
			TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image2"] = {};
			TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"] = "";
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"] = 165;
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"] = 220;
			TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image3"] = {};
			TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"] = "";
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"] = 100;
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"] = 165;
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"] = 220;
			TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"] = 100;
			debugMess("CheckIntegrity :\nID = "..ID.."\nAttribut = Images");
		else
			if TRP_Module_Documents[ID]["Images"]["Image1"] == nil then
				TRP_Module_Documents[ID]["Images"]["Image1"] = {};
				TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"] = "";
				TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"] = 165;
				TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"] = 220;
				TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"] = 100;
			else
				-- TO DO
			end
			if TRP_Module_Documents[ID]["Images"]["Image2"] == nil then
				TRP_Module_Documents[ID]["Images"]["Image2"] = {};
				TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"] = "";
				TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"] = 165;
				TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"] = 220;
				TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"] = 100;
			else
				-- TO DO
			end
			if TRP_Module_Documents[ID]["Images"]["Image3"] == nil then
				TRP_Module_Documents[ID]["Images"]["Image3"] = {};
				TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"] = "";
				TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"] = 100;
				TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"] = 165;
				TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"] = 220;
				TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"] = 100;
			else
				-- TO DO
			end
		end
	else
		TRPError("Internal error : CheckDocumentIntegrity(ID) failed : Document inexistant.\nID = "..ID);
	end
end

function createDocumentWithID(ID)
	if TRP_Module_Documents[ID] == nil then
		TRP_Module_Documents[ID] = {};
		TRP_Module_Documents[ID]["Createur"] = Joueur;
		TRP_Module_Documents[ID]["VignetteIcone"] = "INV_Scroll_12";
		TRP_Module_Documents[ID]["VignetteTitre"] = "New document";
		TRP_Module_Documents[ID]["VignetteAuteur"] = Joueur;
		TRP_Module_Documents[ID]["VignetteDate"] = date("%d/%m \195\160 %Hh%M");
		TRP_Module_Documents[ID]["Texte"] = {};
		TRP_Module_Documents[ID]["Texte"]["Texte"] = {};
		TRP_Module_Documents[ID]["Texte"]["Font"] = 1;
		TRP_Module_Documents[ID]["Texte"]["Taille"] = 11;
		TRP_Module_Documents[ID]["Texte"]["Surligner"] = 1;
		TRP_Module_Documents[ID]["Texte"]["Ombre"] = 100;
		TRP_Module_Documents[ID]["Texte"]["Alignement"] = 1;
		TRP_Module_Documents[ID]["Titre"] = {};
		TRP_Module_Documents[ID]["Titre"]["Titre"] = "New document";
		TRP_Module_Documents[ID]["Titre"]["Font"] = 1;
		TRP_Module_Documents[ID]["Titre"]["Taille"] = 11;
		TRP_Module_Documents[ID]["Titre"]["Surligner"] = 1;
		TRP_Module_Documents[ID]["Titre"]["Ombre"] = 100;
		TRP_Module_Documents[ID]["Titre"]["Alignement"] = 2;
		TRP_Module_Documents[ID]["Titre"]["DifX"] = 165;
		TRP_Module_Documents[ID]["Titre"]["DifY"] = 360;
		TRP_Module_Documents[ID]["Background"] = 1;
		TRP_Module_Documents[ID]["Signature"] = {};
		TRP_Module_Documents[ID]["Signature"]["Auteur"] = Joueur;
		TRP_Module_Documents[ID]["Signature"]["Font"] = 1;
		TRP_Module_Documents[ID]["Signature"]["Taille"] = 11;
		TRP_Module_Documents[ID]["Signature"]["Surligner"] = 1;
		TRP_Module_Documents[ID]["Signature"]["Ombre"] = 100;
		TRP_Module_Documents[ID]["Signature"]["Alignement"] = 2;
		TRP_Module_Documents[ID]["Signature"]["DifX"] = 165;
		TRP_Module_Documents[ID]["Signature"]["DifY"] = 50;
		TRP_Module_Documents[ID]["Images"] = {};
		TRP_Module_Documents[ID]["Images"]["Image1"] = {};
		TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"] = "";
		TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"] = 165;
		TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"] = 220;
		TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image2"] = {};
		TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"] = "";
		TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"] = 165;
		TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"] = 220;
		TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image3"] = {};
		TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"] = "";
		TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"] = 100;
		TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"] = 165;
		TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"] = 220;
		TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"] = 100;
	else
		TRPError("Internal error : creer document deja existant");
	end
end

function createEmptyDocumentWithOtherID(oID)
	if TRP_Module_Documents[oID] ~= nil then
		local ID = GenerateID();
		
		TRP_Module_Documents[ID] = {};
		TotalRP_tcopy(TRP_Module_Documents[ID], TRP_Module_Documents[oID])
		TRP_Module_Documents[ID]["Createur"] = Joueur;

		PanelOpen("FicheJoueurOngletDocument","DocumentsPanelModifier",ID);
	else
		TRPError("Internal error : créer document 'depuis', oID inconnu.\noID : "..tostring(oID));
	end
	PanelDocumentsFromHidden:SetText("");
end

function createEmptyDocument()
	local ID = GenerateID();
	createDocumentWithID(ID);
	PanelOpen("FicheJoueurOngletDocument","DocumentsPanelModifier",ID);
end

function deleteDocuments(ID)
	if TRP_Module_Documents[ID] ~= nil then
		StaticPopupDialogs["TRP_INV_DELETE_DOCU"].text = setTRPColorToString(TRP_ENTETE.." \n "..DeleteMessages["DELETEDOCUMENT"]);
		TRP_ShowStaticPopup("TRP_INV_DELETE_DOCU",nil,nil,ID);
	else
		TRPError("Internal error : delete document inexistant.");
	end
end

function afficheDocumentModifier(ID)
	if TRP_Module_Documents[ID] ~= nil then
		DocumentApercu:Hide();
		PanelDocumentEditIDStock:SetText(ID);
		DocumentCreateTitreVignette:SetText(TRP_Module_Documents[ID]["VignetteTitre"]);
		DocumentCreateAuteurVignette:SetText(TRP_Module_Documents[ID]["VignetteAuteur"]);
		DocumentCreateDateVignette:SetText(TRP_Module_Documents[ID]["VignetteDate"]);
		DocumentCreateIconVignette:SetText(TRP_Module_Documents[ID]["VignetteIcone"]);
		DocumentCreateTexteScrollTexte:SetText(RecollageDocument(TRP_Module_Documents[ID]));
		DocumentCreateTexteFontSlider:SetValue(TRP_Module_Documents[ID]["Texte"]["Font"]);
		DocumentCreateTexteTailleSlider:SetValue(TRP_Module_Documents[ID]["Texte"]["Taille"]);
		DocumentCreateTexteContoursSlider:SetValue(TRP_Module_Documents[ID]["Texte"]["Surligner"]);
		DocumentCreateTexteOmbreSlider:SetValue(TRP_Module_Documents[ID]["Texte"]["Ombre"]);
		DocumentCreateTexteAlignSlider:SetValue(TRP_Module_Documents[ID]["Texte"]["Alignement"]);
		
		DocumentCreateTitreSet:SetText(TRP_Module_Documents[ID]["Titre"]["Titre"]);
		DocumentCreateTitrePoliceSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["Font"]);
		DocumentCreateTitreTailleSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["Taille"]);
		DocumentCreateTitreOmbreSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["Ombre"]);
		DocumentCreateTitreAlignementSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["Alignement"]);
		DocumentCreateTitreContoursSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["Surligner"]);
		DocumentCreateTitrePosXSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["DifX"]);
		DocumentCreateTitrePosYSlider:SetValue(TRP_Module_Documents[ID]["Titre"]["DifY"]);
		
		DocumentCreateSignatureSet:SetText(TRP_Module_Documents[ID]["Signature"]["Auteur"]);
		DocumentCreateSignaturePoliceSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["Font"]);
		DocumentCreateSignatureTailleSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["Taille"]);
		DocumentCreateSignatureOmbreSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["Ombre"]);
		DocumentCreateSignatureAlignementSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["Alignement"]);
		DocumentCreateSignatureContoursSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["Surligner"]);
		DocumentCreateSignaturePosXSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["DifX"]);
		DocumentCreateSignaturePosYSlider:SetValue(TRP_Module_Documents[ID]["Signature"]["DifY"]);
		
		DocumentCreateBackgroundSlider:SetValue(TRP_Module_Documents[ID]["Background"]);
		
		DocumentCreateImage1SizeX:SetValue(TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"]);
		DocumentCreateImage1SizeY:SetValue(TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"]);
		DocumentCreateImage1PosX:SetValue(TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"]);
		DocumentCreateImage1PosY:SetValue(TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"]);
		DocumentCreateImage1Nom:SetText(TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"]);
		DocumentCreateImage1Alpha:SetValue(TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"]);
		
		DocumentCreateImage2SizeX:SetValue(TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"]);
		DocumentCreateImage2SizeY:SetValue(TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"]);
		DocumentCreateImage2PosX:SetValue(TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"]);
		DocumentCreateImage2PosY:SetValue(TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"]);
		DocumentCreateImage2Nom:SetText(TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"]);
		DocumentCreateImage2Alpha:SetValue(TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"]);
		
		DocumentCreateImage3SizeX:SetValue(TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"]);
		DocumentCreateImage3SizeY:SetValue(TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"]);
		DocumentCreateImage3PosX:SetValue(TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"]);
		DocumentCreateImage3PosY:SetValue(TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"]);
		DocumentCreateImage3Nom:SetText(TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"]);
		DocumentCreateImage3Alpha:SetValue(TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"]);

		CreaDocuCheckBoxLock:SetChecked(TRP_Module_Documents[ID]["Lock"] ~= nil);
		
		DocumentApercu:Show();
		if TRP_Module_Documents[ID]["Createur"] ~= Joueur then
			StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..DocumentsTexts["EDITAUTEUR"].."\n\n"..DocumentsTexts["EDITAUTEURTEXT"]);
			TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
		end
		refreshApercu();
	else
		TRPError("Internal error : Editer un document inexistant.\nId = "..ID);
	end
end

function EnregistrerDocument()
	local ID = PanelDocumentEditIDStock:GetText();
	if TRP_Module_Documents[ID] == nil then
		TRPError("Internal error : enregistrer un document inexistant");
	else
		if DecoupageDocument(ID,DocumentCreateTexteScrollTexte:GetText()) then
			TRP_Module_Documents[ID]["VignetteTitre"] = DocumentCreateTitreVignette:GetText();
			TRP_Module_Documents[ID]["VignetteAuteur"] = DocumentCreateAuteurVignette:GetText();
			TRP_Module_Documents[ID]["VignetteDate"] = DocumentCreateDateVignette:GetText();
			TRP_Module_Documents[ID]["VignetteIcone"] = DocumentCreateIconVignette:GetText();
			
			TRP_Module_Documents[ID]["Background"] = DocumentCreateBackgroundSlider:GetValue();
			
			TRP_Module_Documents[ID]["Texte"]["Font"] = DocumentCreateTexteFontSlider:GetValue();
			TRP_Module_Documents[ID]["Texte"]["Taille"] = DocumentCreateTexteTailleSlider:GetValue();
			TRP_Module_Documents[ID]["Texte"]["Surligner"] = DocumentCreateTexteContoursSlider:GetValue();
			TRP_Module_Documents[ID]["Texte"]["Ombre"] = DocumentCreateTexteOmbreSlider:GetValue();
			TRP_Module_Documents[ID]["Texte"]["Alignement"] = DocumentCreateTexteAlignSlider:GetValue();
			
			TRP_Module_Documents[ID]["Titre"]["Titre"] = DocumentCreateTitreSet:GetText();
			TRP_Module_Documents[ID]["Titre"]["Font"] = DocumentCreateTitrePoliceSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["Taille"] = DocumentCreateTitreTailleSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["Surligner"] = DocumentCreateTitreContoursSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["Ombre"] = DocumentCreateTitreOmbreSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["Alignement"] = DocumentCreateTitreAlignementSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["DifX"] = DocumentCreateTitrePosXSlider:GetValue();
			TRP_Module_Documents[ID]["Titre"]["DifY"] = DocumentCreateTitrePosYSlider:GetValue();
			
			TRP_Module_Documents[ID]["Signature"]["Auteur"] = DocumentCreateSignatureSet:GetText();
			TRP_Module_Documents[ID]["Signature"]["Font"] = DocumentCreateSignaturePoliceSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["Taille"] = DocumentCreateSignatureTailleSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["Surligner"] = DocumentCreateSignatureContoursSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["Ombre"] = DocumentCreateSignatureOmbreSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["Alignement"] = DocumentCreateSignatureAlignementSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["DifX"] = DocumentCreateSignaturePosXSlider:GetValue();
			TRP_Module_Documents[ID]["Signature"]["DifY"] = DocumentCreateSignaturePosYSlider:GetValue();
			
			TRP_Module_Documents[ID]["Images"]["Image1"]["Nom"] = DocumentCreateImage1Nom:GetText();
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeX"] = DocumentCreateImage1SizeX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image1"]["SizeY"] = DocumentCreateImage1SizeY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosX"] = DocumentCreateImage1PosX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image1"]["PosY"] = DocumentCreateImage1PosY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image1"]["Alpha"] = DocumentCreateImage1Alpha:GetValue();
			
			TRP_Module_Documents[ID]["Images"]["Image2"]["Nom"] = DocumentCreateImage2Nom:GetText();
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeX"] = DocumentCreateImage2SizeX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image2"]["SizeY"] = DocumentCreateImage2SizeY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosX"] = DocumentCreateImage2PosX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image2"]["PosY"] = DocumentCreateImage2PosY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image2"]["Alpha"] = DocumentCreateImage2Alpha:GetValue();
			
			TRP_Module_Documents[ID]["Images"]["Image3"]["Nom"] = DocumentCreateImage3Nom:GetText();
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeX"] = DocumentCreateImage3SizeX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image3"]["SizeY"] = DocumentCreateImage3SizeY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosX"] = DocumentCreateImage3PosX:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image3"]["PosY"] = DocumentCreateImage3PosY:GetValue();
			TRP_Module_Documents[ID]["Images"]["Image3"]["Alpha"] = DocumentCreateImage3Alpha:GetValue();
			
			TRP_Module_Documents[ID]["Createur"] = Joueur;
			
			if CreaDocuCheckBoxLock:GetChecked() then
				TRP_Module_Documents[ID]["Lock"] = true;
			else
				TRP_Module_Documents[ID]["Lock"] = nil;
			end
			
			local found = false;
			table.foreach(TRP_Module_ObjetsPerso,
				function(objet)
					if TRP_Module_ObjetsPerso[objet]["Utilisable"] and TRP_Module_ObjetsPerso[objet]["Utilisable"]["LierAuDoc"] == ID then
						found = true;
						return;
					end;
				end);
			if found then
				PanelOpen("FicheJoueurOngletDocument","DocumentsPanelListe");
			else
				StaticPopupDialogs["TRP_DOCU_CREATEOBJ"].text = setTRPColorToString(TRP_ENTETE.." \nThere isn't any item associated to this document. You must associate a item to this document if you want others to be able to consulte it. Do you want to create this item now ?");
				TRP_ShowStaticPopup("TRP_DOCU_CREATEOBJ",nil,nil,ID);
			end
		else
			StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"].text = setTRPColorToString(TRP_ENTETE.." \n "..TRPWARNING.."\n\n".."{r}There is a list with more than 200 consecutive characters (ie without space). This is forbidden !");
			TRP_ShowStaticPopup("TRP_TEXT_ONLY_SHADE");
		end
	end
end

function afficheDocument(ID)

	local document;

	if ID == "consulte" then
		document = Documents_Consulte;
	elseif TRP_Module_Documents[ID] then
		document = TRP_Module_Documents[ID];
	end
	
	if document then
		if not MenuPrincipal:IsVisible() then
			OpenMainMenu(true);
		end
		PanelDocumentsNomHidden:SetText(ID);
		PanelDocumentConsulteTitreCache:SetText(FicheJoueurPanelTitle:GetText());
		FicheJoueurPanelTitle:SetText(document["VignetteTitre"]);
		--Titre
		PanelDocumentConsulteTitre1:SetText(setTRPColorToString(document["Titre"]["Titre"]));
		PanelDocumentConsulteTitre1:SetShadowColor(0,0,0,(document["Titre"]["Ombre"]/100));
	    if document["Titre"]["Alignement"] == 1 then
			PanelDocumentConsulteTitre1:SetJustifyH("LEFT");
		elseif document["Titre"]["Alignement"] == 2 then
			PanelDocumentConsulteTitre1:SetJustifyH("CENTER");
		elseif document["Titre"]["Alignement"] == 3 then
			PanelDocumentConsulteTitre1:SetJustifyH("RIGHT");
		end
		if document["Titre"]["Surligner"] == 2 then
			PanelDocumentConsulteTitre1:SetFont(DocumentFont[document["Titre"]["Font"]*2], document["Titre"]["Taille"], "OUTLINE");
		elseif document["Titre"]["Surligner"] == 3 then
			PanelDocumentConsulteTitre1:SetFont(DocumentFont[document["Titre"]["Font"]*2], document["Titre"]["Taille"],"THICKOUTLINE");
		else
			PanelDocumentConsulteTitre1:SetFont(DocumentFont[document["Titre"]["Font"]*2], document["Titre"]["Taille"]);
		end
		PanelDocumentConsulteTitre1:SetPoint("CENTER", (document["Titre"]["DifX"]-165) , (document["Titre"]["DifY"]-220) );
		--Texte
		PanelDocumentConsulteScrollText:SetText(setTRPColorToString(RecollageDocument(document)));
		PanelDocumentConsulteScrollText:SetShadowColor(0,0,0,(document["Texte"]["Ombre"]/100));
	    if document["Texte"]["Alignement"] == 1 then
			PanelDocumentConsulteScrollText:SetJustifyH("LEFT");
		elseif document["Texte"]["Alignement"] == 2 then
			PanelDocumentConsulteScrollText:SetJustifyH("CENTER");
		elseif document["Texte"]["Alignement"] == 3 then
			PanelDocumentConsulteScrollText:SetJustifyH("RIGHT");
		end
		if document["Texte"]["Surligner"] == 2 then
			PanelDocumentConsulteScrollText:SetFont(DocumentFont[document["Texte"]["Font"]*2], document["Texte"]["Taille"], "OUTLINE");
		elseif document["Texte"]["Surligner"] == 3 then
			PanelDocumentConsulteScrollText:SetFont(DocumentFont[document["Texte"]["Font"]*2], document["Texte"]["Taille"],"THICKOUTLINE");
		else
			PanelDocumentConsulteScrollText:SetFont(DocumentFont[document["Texte"]["Font"]*2], document["Texte"]["Taille"]);
		end
		--Signature
		PanelDocumentConsulteAuteur1:SetText(setTRPColorToString(document["Signature"]["Auteur"]));
		PanelDocumentConsulteAuteur1:SetShadowColor(0,0,0,(document["Signature"]["Ombre"]/100));
	    if document["Signature"]["Alignement"] == 1 then
			PanelDocumentConsulteAuteur1:SetJustifyH("LEFT");
		elseif document["Signature"]["Alignement"] == 2 then
			PanelDocumentConsulteAuteur1:SetJustifyH("CENTER");
		elseif document["Signature"]["Alignement"] == 3 then
			PanelDocumentConsulteAuteur1:SetJustifyH("RIGHT");
		end
		if document["Signature"]["Surligner"] == 2 then
			PanelDocumentConsulteAuteur1:SetFont(DocumentFont[document["Signature"]["Font"]*2], document["Signature"]["Taille"], "OUTLINE");
		elseif document["Signature"]["Surligner"] == 3 then
			PanelDocumentConsulteAuteur1:SetFont(DocumentFont[document["Signature"]["Font"]*2], document["Signature"]["Taille"],"THICKOUTLINE");
		else
			PanelDocumentConsulteAuteur1:SetFont(DocumentFont[document["Signature"]["Font"]*2], document["Signature"]["Taille"]);
		end
		PanelDocumentConsulteAuteur1:SetPoint("CENTER", (document["Signature"]["DifX"]-165) , (document["Signature"]["DifY"]-220) );
		--Background
		DocumentFond1:SetTexture(DocumentBackground[document["Background"]][1]);
		DocumentFond2:SetTexture(DocumentBackground[document["Background"]][2]);
		DocumentFond3:SetTexture(DocumentBackground[document["Background"]][1]);
		DocumentFond4:SetTexture(DocumentBackground[document["Background"]][2]);
		--Images
		-- Image 1 
		if not DocumentImage1:SetTexture("Interface\\"..setTRPColorToString(document["Images"]["Image1"]["Nom"])..".blp") then
			DocumentImage1:SetTexture("");
		end
		DocumentImage1:SetWidth(128*(document["Images"]["Image1"]["SizeX"]/100));
		DocumentImage1:SetHeight(128*(document["Images"]["Image1"]["SizeY"]/100));
		DocumentImage1:SetPoint("CENTER", (document["Images"]["Image1"]["PosX"]-165) , (document["Images"]["Image1"]["PosY"]-220) );
		DocumentImage1:SetAlpha((document["Images"]["Image1"]["Alpha"]/100));
		-- Image 2
		if not DocumentImage2:SetTexture("Interface\\"..setTRPColorToString(document["Images"]["Image2"]["Nom"])..".blp") then
			DocumentImage2:SetTexture("");
		end
		DocumentImage2:SetWidth(128*(document["Images"]["Image2"]["SizeX"]/100));
		DocumentImage2:SetHeight(128*(document["Images"]["Image2"]["SizeY"]/100));
		DocumentImage2:SetPoint("CENTER", (document["Images"]["Image2"]["PosX"]-165) , (document["Images"]["Image2"]["PosY"]-220) );
		DocumentImage2:SetAlpha((document["Images"]["Image2"]["Alpha"]/100));
		-- Image 3
		if not DocumentImage3:SetTexture("Interface\\"..setTRPColorToString(document["Images"]["Image3"]["Nom"])..".blp") then
			DocumentImage3:SetTexture("");
		end
		DocumentImage3:SetWidth(128*(document["Images"]["Image3"]["SizeX"]/100));
		DocumentImage3:SetHeight(128*(document["Images"]["Image3"]["SizeY"]/100));
		DocumentImage3:SetPoint("CENTER", (document["Images"]["Image3"]["PosX"]-165) , (document["Images"]["Image3"]["PosY"]-220) );
		DocumentImage3:SetAlpha((document["Images"]["Image3"]["Alpha"]/100));
		
		DocumentCreateTitreVignette:SetFocus();
		PanelDocumentsConsulte:Show();
	else
		TRPError("Internal error : consulte un document inexistant.")
	end
end

function DecoupageDocument(ID,Texte)
	local ok = true;
	local morceaux = string.reverse(Texte);
	local tableau = {};
	local i = 1;
	
	while ok do
		local indice = string.find(morceaux," ",-200);
		
		if string.len(morceaux) < 200 then -- Dernier Morceaux
			tableau[i] = string.reverse(morceaux);
			ok = false;
		elseif indice == nil then
			if string.len(morceaux) > 200 then -- Pas d'espace dans les 200 derniers charactères : erreur
				return false;
			end
		else
			tableau[i] = string.reverse(string.sub(morceaux,indice));
			i = i + 1;
			morceaux = string.sub(morceaux,1,indice-1);
		end
	end
	
	TRP_Module_Documents[ID]["Texte"]["Texte"] = nil;
	TRP_Module_Documents[ID]["Texte"]["Texte"] = tableau;
	
	return true;
end

function RecollageDocument(tabDocu)
	TexteColle = ""; -- Renvoie au minimum un string vide.
	table.foreach(tabDocu["Texte"]["Texte"],
	function(TexteNum)
		TexteColle = TexteColle..tabDocu["Texte"]["Texte"][TexteNum];
	end);
	return TexteColle;
end

function refreshApercu()
	if not DocumentApercu:IsVisible() then
		return;
	end
	--Vignette
	ApercuPanelDocumentVignetteTitre:SetText(setTRPColorToString(DocumentCreateTitreVignette:GetText()));
	if setTRPColorToString(DocumentCreateAuteurVignette:GetText()) ~= "" then
		ApercuPanelDocumentVignetteAuteur:SetText("|cffff9900Auteur : |cffffffff"..setTRPColorToString(DocumentCreateAuteurVignette:GetText()));
	else
		ApercuPanelDocumentVignetteAuteur:SetText("");
	end
	if setTRPColorToString(DocumentCreateDateVignette:GetText()) ~= "" then
		ApercuPanelDocumentVignetteDate:SetText("|cffff9900Date : |cffffffff"..setTRPColorToString(DocumentCreateDateVignette:GetText()));
	else
		ApercuPanelDocumentVignetteDate:SetText("");
	end
	if ApercuPanelDocumentVignetteIcon:SetTexture("Interface\\Icons\\"..DocumentCreateIconVignette:GetText()..".blp") == nil then
		ApercuPanelDocumentVignetteIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark.blp");
	end
	--Texte
	ApercuPanelDocumentConsulteScrollText:SetText(setTRPColorToString(DocumentCreateTexteScrollTexte:GetText()));
	ApercuPanelDocumentConsulteScrollText:SetShadowColor(0,0,0,(DocumentCreateTexteOmbreSlider:GetValue()/100));
    if DocumentCreateTexteAlignSlider:GetValue() == 1 then
		ApercuPanelDocumentConsulteScrollText:SetJustifyH("LEFT");
		DocumentCreateTexteAlignSliderText:SetText(ALIGNTEXTE.." : Left");
	elseif DocumentCreateTexteAlignSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteScrollText:SetJustifyH("CENTER");
		DocumentCreateTexteAlignSliderText:SetText(ALIGNTEXTE.." : Center");
	elseif DocumentCreateTexteAlignSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteScrollText:SetJustifyH("RIGHT");
		DocumentCreateTexteAlignSliderText:SetText(ALIGNTEXTE.." : Right");
	end
	if DocumentCreateTexteContoursSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteScrollText:SetFont(DocumentFont[DocumentCreateTexteFontSlider:GetValue()*2], DocumentCreateTexteTailleSlider:GetValue(), "OUTLINE");
		DocumentCreateTexteContoursSliderText:SetText(SURLIGNTEXTE.." : Soft");
	elseif DocumentCreateTexteContoursSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteScrollText:SetFont(DocumentFont[DocumentCreateTexteFontSlider:GetValue()*2], DocumentCreateTexteTailleSlider:GetValue(),"THICKOUTLINE");
		DocumentCreateTexteContoursSliderText:SetText(SURLIGNTEXTE.." : Thick");
	else
		ApercuPanelDocumentConsulteScrollText:SetFont(DocumentFont[DocumentCreateTexteFontSlider:GetValue()*2], DocumentCreateTexteTailleSlider:GetValue());
		DocumentCreateTexteContoursSliderText:SetText(SURLIGNTEXTE.." : None");
	end
	
	DocumentCreateTexteOmbreSliderText:SetText(OMBRETEXTE.." : "..(100-DocumentCreateTexteOmbreSlider:GetValue()).."%");
	DocumentCreateTexteTailleSliderText:SetText(TAILLETEXTE.." : "..DocumentCreateTexteTailleSlider:GetValue());
	DocumentCreateTexteFontSliderText:SetText(POLICETEXTE.." : "..DocumentFont[DocumentCreateTexteFontSlider:GetValue()*2-1]);
	
	--Titre
	ApercuPanelDocumentConsulteTitre1:SetText(setTRPColorToString(DocumentCreateTitreSet:GetText()));
	if DocumentCreateTitreContoursSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteTitre1:SetFont(DocumentFont[DocumentCreateTitrePoliceSlider:GetValue()*2], DocumentCreateTitreTailleSlider:GetValue(), "OUTLINE");
		DocumentCreateTitreContoursSliderText:SetText(SURLIGNTITRE.." : Soft");
	elseif DocumentCreateTitreContoursSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteTitre1:SetFont(DocumentFont[DocumentCreateTitrePoliceSlider:GetValue()*2], DocumentCreateTitreTailleSlider:GetValue(), "THICKOUTLINE");
		DocumentCreateTitreContoursSliderText:SetText(SURLIGNTITRE.." : Thick");
	else
		ApercuPanelDocumentConsulteTitre1:SetFont(DocumentFont[DocumentCreateTitrePoliceSlider:GetValue()*2], DocumentCreateTitreTailleSlider:GetValue());
		DocumentCreateTitreContoursSliderText:SetText(SURLIGNTITRE.." : None");
	end
	ApercuPanelDocumentConsulteTitre1:SetShadowColor(0,0,0,(DocumentCreateTitreOmbreSlider:GetValue()/100));
    if DocumentCreateTitreAlignementSlider:GetValue() == 1 then
		ApercuPanelDocumentConsulteTitre1:SetJustifyH("LEFT");
		DocumentCreateTitreAlignementSliderText:SetText(ALIGNTITRE.." : Left");
	elseif DocumentCreateTitreAlignementSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteTitre1:SetJustifyH("CENTER");
		DocumentCreateTitreAlignementSliderText:SetText(ALIGNTITRE.." : Center");
	elseif DocumentCreateTitreAlignementSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteTitre1:SetJustifyH("RIGHT");
		DocumentCreateTitreAlignementSliderText:SetText(ALIGNTITRE.." : Right");
	end
	ApercuPanelDocumentConsulteTitre1:SetPoint("CENTER", (DocumentCreateTitrePosXSlider:GetValue()-165) , (DocumentCreateTitrePosYSlider:GetValue()-220) );

	DocumentCreateTitreOmbreSliderText:SetText(OMBRETITRE.." : "..(100-DocumentCreateTitreOmbreSlider:GetValue()).."%");
	DocumentCreateTitreTailleSliderText:SetText(TAILLETITRE.." : "..DocumentCreateTitreTailleSlider:GetValue());
	DocumentCreateTitrePoliceSliderText:SetText(POLICETITRE.." : "..DocumentFont[DocumentCreateTitrePoliceSlider:GetValue()*2-1]);
	DocumentCreateTitrePosXSliderText:SetText(POSXTITRE.." : "..(DocumentCreateTitrePosXSlider:GetValue()-100));
	DocumentCreateTitrePosYSliderText:SetText(POSYTITRE.." : "..(DocumentCreateTitrePosYSlider:GetValue()-100));
	
	--Signature
	ApercuPanelDocumentConsulteAuteur1:SetText(setTRPColorToString(DocumentCreateSignatureSet:GetText()));
	if DocumentCreateSignatureContoursSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteAuteur1:SetFont(DocumentFont[DocumentCreateSignaturePoliceSlider:GetValue()*2], DocumentCreateSignatureTailleSlider:GetValue(), "OUTLINE");
		DocumentCreateSignatureContoursSliderText:SetText(SURLIGNSIGNATURE.." : Soft");
	elseif DocumentCreateSignatureContoursSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteAuteur1:SetFont(DocumentFont[DocumentCreateSignaturePoliceSlider:GetValue()*2], DocumentCreateSignatureTailleSlider:GetValue(), "THICKOUTLINE");
		DocumentCreateSignatureContoursSliderText:SetText(SURLIGNSIGNATURE.." : Thick");
	else
		ApercuPanelDocumentConsulteAuteur1:SetFont(DocumentFont[DocumentCreateSignaturePoliceSlider:GetValue()*2], DocumentCreateSignatureTailleSlider:GetValue());
		DocumentCreateSignatureContoursSliderText:SetText(SURLIGNSIGNATURE.." : None");
	end
	ApercuPanelDocumentConsulteAuteur1:SetShadowColor(0,0,0,(DocumentCreateSignatureOmbreSlider:GetValue()/100));
    if DocumentCreateSignatureAlignementSlider:GetValue() == 1 then
		ApercuPanelDocumentConsulteAuteur1:SetJustifyH("LEFT");
		DocumentCreateSignatureAlignementSliderText:SetText(ALIGNSIGNATURE.." : Left");
	elseif DocumentCreateSignatureAlignementSlider:GetValue() == 2 then
		ApercuPanelDocumentConsulteAuteur1:SetJustifyH("CENTER");
		DocumentCreateSignatureAlignementSliderText:SetText(ALIGNSIGNATURE.." : Center");
	elseif DocumentCreateSignatureAlignementSlider:GetValue() == 3 then
		ApercuPanelDocumentConsulteAuteur1:SetJustifyH("RIGHT");
		DocumentCreateSignatureAlignementSliderText:SetText(ALIGNSIGNATURE.." : Right");
	end
	ApercuPanelDocumentConsulteAuteur1:SetPoint("CENTER", (DocumentCreateSignaturePosXSlider:GetValue()-165) , (DocumentCreateSignaturePosYSlider:GetValue()-220) );
	
	DocumentCreateSignatureOmbreSliderText:SetText(OMBRESIGNATURE.." : "..(100-DocumentCreateSignatureOmbreSlider:GetValue()).."%");
	DocumentCreateSignatureTailleSliderText:SetText(TAILLESIGNATURE.." : "..DocumentCreateSignatureTailleSlider:GetValue());
	DocumentCreateSignaturePoliceSliderText:SetText(POLICESIGNATURE.." : "..DocumentFont[DocumentCreateSignaturePoliceSlider:GetValue()*2-1]);
	DocumentCreateSignaturePosXSliderText:SetText(POSXSIGNATURE.." : "..(DocumentCreateSignaturePosXSlider:GetValue()-100));
	DocumentCreateSignaturePosYSliderText:SetText(POSYSIGNATURE.." : "..(DocumentCreateSignaturePosYSlider:GetValue()-100));
	
	--Background
	ApercuDocumentFond1:SetTexture(DocumentBackground[DocumentCreateBackgroundSlider:GetValue()][1]);
	ApercuDocumentFond2:SetTexture(DocumentBackground[DocumentCreateBackgroundSlider:GetValue()][2]);
	ApercuDocumentFond3:SetTexture(DocumentBackground[DocumentCreateBackgroundSlider:GetValue()][1]);
	ApercuDocumentFond4:SetTexture(DocumentBackground[DocumentCreateBackgroundSlider:GetValue()][2]);
	
	--Images
	-- Image 1 
	if not ApercuDocumentImage1:SetTexture("Interface\\"..setTRPColorToString(DocumentCreateImage1Nom:GetText())..".blp") then
		ApercuDocumentImage1:SetTexture("");
	end
	ApercuDocumentImage1:SetWidth(128*(DocumentCreateImage1SizeX:GetValue()/100));
	ApercuDocumentImage1:SetHeight(128*(DocumentCreateImage1SizeY:GetValue()/100));
	ApercuDocumentImage1:SetPoint("CENTER", (DocumentCreateImage1PosX:GetValue()-165) , (DocumentCreateImage1PosY:GetValue()-220) );
	ApercuDocumentImage1:SetAlpha((DocumentCreateImage1Alpha:GetValue()/100));
	DocumentCreateImage1SizeXText:SetText(SIZEX.." : "..DocumentCreateImage1SizeX:GetValue().."%");
	DocumentCreateImage1SizeYText:SetText(SIZEY.." : "..DocumentCreateImage1SizeY:GetValue().."%");
	DocumentCreateImage1PosXText:SetText(POSXSIGNATURE.." : "..(DocumentCreateImage1PosX:GetValue()-165));
	DocumentCreateImage1PosYText:SetText(POSYSIGNATURE.." : "..(DocumentCreateImage1PosY:GetValue()-220));
	DocumentCreateImage1AlphaText:SetText(ALPHAIMAGE.." : "..DocumentCreateImage1Alpha:GetValue().."%");
	-- Image 2
	if not ApercuDocumentImage2:SetTexture("Interface\\"..setTRPColorToString(DocumentCreateImage2Nom:GetText())..".blp") then
		ApercuDocumentImage2:SetTexture("");
	end
	ApercuDocumentImage2:SetWidth(128*(DocumentCreateImage2SizeX:GetValue()/100));
	ApercuDocumentImage2:SetHeight(128*(DocumentCreateImage2SizeY:GetValue()/100));
	ApercuDocumentImage2:SetPoint("CENTER", (DocumentCreateImage2PosX:GetValue()-165) , (DocumentCreateImage2PosY:GetValue()-220) );
	ApercuDocumentImage2:SetAlpha((DocumentCreateImage2Alpha:GetValue()/100));
	DocumentCreateImage2SizeXText:SetText(SIZEX.." : "..DocumentCreateImage2SizeX:GetValue().."%");
	DocumentCreateImage2SizeYText:SetText(SIZEY.." : "..DocumentCreateImage2SizeY:GetValue().."%");
	DocumentCreateImage2PosXText:SetText(POSXSIGNATURE.." : "..(DocumentCreateImage2PosX:GetValue()-165));
	DocumentCreateImage2PosYText:SetText(POSYSIGNATURE.." : "..(DocumentCreateImage2PosY:GetValue()-220));
	DocumentCreateImage2AlphaText:SetText(ALPHAIMAGE.." : "..DocumentCreateImage2Alpha:GetValue().."%");
	-- Image 3
	if not ApercuDocumentImage3:SetTexture("Interface\\"..setTRPColorToString(DocumentCreateImage3Nom:GetText())..".blp") then
		ApercuDocumentImage3:SetTexture("");
	end
	ApercuDocumentImage3:SetWidth(128*(DocumentCreateImage3SizeX:GetValue()/100));
	ApercuDocumentImage3:SetHeight(128*(DocumentCreateImage3SizeY:GetValue()/100));
	ApercuDocumentImage3:SetPoint("CENTER", (DocumentCreateImage3PosX:GetValue()-165) , (DocumentCreateImage3PosY:GetValue()-220) );
	ApercuDocumentImage3:SetAlpha((DocumentCreateImage3Alpha:GetValue()/100));
	DocumentCreateImage3SizeXText:SetText(SIZEX.." : "..DocumentCreateImage3SizeX:GetValue().."%");
	DocumentCreateImage3SizeYText:SetText(SIZEY.." : "..DocumentCreateImage3SizeY:GetValue().."%");
	DocumentCreateImage3PosXText:SetText(POSXSIGNATURE.." : "..(DocumentCreateImage3PosX:GetValue()-165));
	DocumentCreateImage3PosYText:SetText(POSYSIGNATURE.." : "..(DocumentCreateImage3PosY:GetValue()-220));
	DocumentCreateImage3AlphaText:SetText(ALPHAIMAGE.." : "..DocumentCreateImage3Alpha:GetValue().."%");
end

function Reinit_documents()
	for k=1,42,1 do --Initialisation
		getglobal("ListeDocumentsSlot"..k.."ID"):SetText("");
		getglobal("ListeDocumentsSlot"..k.."Icon"):SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled.blp");
		getglobal("ListeDocumentsSlot"..k):SetButtonState("NORMAL");
		getglobal("ListeDocumentsSlot"..k):Hide();
	end
end

function calculerListeDocument()
	local recherche = TRPDocumentListRecherche:GetText();
	local j = 0;
	
	ListeDocumentsSlider:Hide();
	ListeDocumentsSlider:SetValue(0);
	wipe(DocumentTab);
	TRPListeDocumentsEmpty:Hide();
	
	table.foreach(TRP_Module_Documents,
	function(ID)
		if recherche == "" or string.find(string.lower(TRP_Module_Documents[ID]["VignetteTitre"]),string.lower(recherche)) ~= nil then
			if not TRP_Module_Documents[ID]["Lock"] or TRP_Module_Documents[ID]["Createur"] == Joueur then
				DocumentTab[j+1] = ID;
				j = j+1;
			end
		end
	end);
	
	table.sort(DocumentTab);
	
	if j > 42 then
		local total = floor((j-1)/42);
		ListeDocumentsSlider:Show();
		ListeDocumentsSlider:SetMinMaxValues(0,total);
	elseif j == 0 then
		TRPListeDocumentsEmpty:Show();
	end
	
	ChargerSliderListeDocuments(0);
end

function ChargerSliderListeDocuments(num)
	Reinit_documents();
	
	if DocumentTab ~= nil then
		for k=1,42,1 do 
			local i = num*42 + k;
			if DocumentTab[i] then
				getglobal("ListeDocumentsSlot"..k):Show();
				getglobal("ListeDocumentsSlot"..k.."ID"):SetText(DocumentTab[i]);
				getglobal("ListeDocumentsSlot"..k.."Icon"):SetTexture("Interface\\Icons\\"..TRP_Module_Documents[DocumentTab[i]]["VignetteIcone"]..".blp");
			
			end
		end
	end
end
