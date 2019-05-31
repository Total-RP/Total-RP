function OpenMainMenu(bOpen)
	if bOpen then
		MenuPrincipal:Show();
		FicheJoueurPanelTitle:SetText(MESSAGE_MENU);
		FicheJoueurOngletFiche:Enable();
		FicheJoueurOngletInventaire:Enable();
		FicheJoueurOngletRegistre:Enable();
		FicheJoueurOngletDocument:Enable();
		FicheJoueurOngletOptions:Enable();
		FicheJoueurOngletFicheIcon:SetAlpha(1);
		FicheJoueurOngletInventaireIcon:SetAlpha(1);
		FicheJoueurOngletRegistreIcon:SetAlpha(1);
		FicheJoueurOngletDocumentIcon:SetAlpha(1);
		FicheJoueurOngletOptionsIcon:SetAlpha(1);
	else
		MenuPrincipal:Hide();
		FicheJoueur:Hide();
	end
end

function OpenActionsBar(bOpen)
	if bOpen then
		TRPActionsBar:Show();
		ActionBarPosition();
	else
		TRPActionsBar:Hide();
	end
end

function ShadeSecondPlan(alpha)
	FicheJoueur:SetAlpha(alpha);
end

function CloseAll()
	FicheJoueur:Hide();
	InventaireFrame:Hide();
	CreateObjetFrame:Hide();
	TRPAideFrame:Hide();
	InfoBox:Hide();
	TRPListeIcones:Hide();
	CommentaireBox:Hide();
	PanelDocumentsConsulte:Hide();
	SendMailBox:Hide();
	TRPListePersonnages:Hide();
	TRPListeSound:Hide();
	SendPersoBox:Hide();
	ConfigCommuSpamListFrame:Hide();
	TRP_Objet_3D_Apercu:Hide();
	
	reinitVariableTransfert();

	PanelObjetPersoListeRecherche:SetText("");
	PanelDocumentListeRecherche:SetText("");
	ArgentText:SetText("");
end

function PanelOpen(Onglet,Panel,Arg0)

	if FicheJoueurPanelRegistreGeneralEdition:IsVisible() or FicheJoueurPanelRegistreDescriptionEdition:IsVisible() then
		EnregistrerDonneesJoueur();
	end
	
	CloseAll();
	FicheJoueur:Show();
	MenuPrincipal:Show();
	
	FicheJoueurOngletFiche:Enable();
	FicheJoueurOngletInventaire:Enable();
	FicheJoueurOngletRegistre:Enable();
	FicheJoueurOngletDocument:Enable();
	FicheJoueurOngletOptions:Enable();
	FicheJoueurOngletFicheIcon:SetAlpha(1);
	FicheJoueurOngletInventaireIcon:SetAlpha(1);
	FicheJoueurOngletRegistreIcon:SetAlpha(1);
	FicheJoueurOngletDocumentIcon:SetAlpha(1);
	FicheJoueurOngletOptionsIcon:SetAlpha(1);
	RegistreFicheButtonPanelListeIcon:SetAlpha(1);
	RegistreFicheButtonPanelGeneralIcon:SetAlpha(1);
	RegistreFicheButtonPanelDescriptionIcon:SetAlpha(1);
	InventaireOngletCoffreIcon:SetAlpha(1);
	InventaireOngletCreationIcon:SetAlpha(1);
	
	FicheJoueurPanelFiche:Hide();
	FicheJoueurPanelInventaire:Hide();
	FicheJoueurPanelRegistre:Hide();
	FicheJoueurPanelDocuments:Hide();
	FicheJoueurPanelConfiguration:Hide();
	
	if Onglet == "FicheJoueurOngletFiche" then
		FicheJoueurOpen(Panel,Arg0);	
	elseif Onglet == "FicheJoueurOngletInventaire" then
		PanelObjetPersoSliderSousCategorie:SetValue(0);
		PanelObjetPersoSliderCategorie:SetValue(0);
		PanelObjetSliderSousCategorie:SetValue(0);
		PanelObjetSliderCategorie:SetValue(0);
		InventaireOpen(Panel,Arg0);
	elseif Onglet == "FicheJoueurOngletRegistre" then
		RegistreOpen(Panel,Arg0);
	elseif Onglet == "FicheJoueurOngletDocument" then
		DocumentsOpen(Panel,Arg0);
	elseif Onglet == "FicheJoueurOngletOptions" then
		AdaptConfiguration(Panel,Arg0);
	end
end

function TRP_Reinit(num)
	if num == 1 then -- ALL
		TRP_Module_Registre = nil;
		TRP_Module_PlayerInfo = nil;
		TRP_Module_Documents = nil;
		TRP_Module_ObjetsPerso = nil;
		TRP_Module_Inventaire = nil;
	elseif num == 2 then -- REGISTRE
		TRP_Module_Registre = nil;
		TRP_Module_Registre = {};
		TRP_Module_Registre[Royaume] = {};
	elseif num == 3 then -- JOURNAL
		TRP_Module_Documents = nil;
	elseif num == 4 then -- INVENTAIRE
		TRP_Module_Inventaire[Royaume][Joueur] = nil;
		TRP_Module_Inventaire[Royaume][Joueur] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Or"] = {};
		TRP_Module_Inventaire[Royaume][Joueur]["Or"]["SacADos"] = 0;
		TRP_Module_Inventaire[Royaume][Joueur]["Or"]["Monture"] = 0;
		TRP_Module_Inventaire[Royaume][Joueur]["Or"]["Planques"] = {};	
	elseif num == 5 then -- OBJET CREE
		TRP_Module_ObjetsPerso = nil;
		TRP_Module_ObjetsPerso = {};
	end
	ReloadUI();
end

function setDoubleClicSurPortrait()
	TRPActionsBar:SetClampedToScreen(true);
	TRPListePlaySound:SetClampedToScreen(true);
	MenuPrincipal:SetClampedToScreen(true);
	TRPActionsBar:EnableMouse(not TRP_Module_Configuration["Modules"]["Actions"]["Lock"]);
	PlayerFrame:SetScript("OnDoubleClick", function()
		PanelOpen("FicheJoueurOngletFiche");
	end);
end

function anchorRegistreIcon()
	if	XPerl_Target ~= nil then
		TargetPortraitButton:SetPoint("CENTER", "XPerl_Target", "CENTER", 64, -45);
	elseif Perl_Target_Frame ~= nil then
		TargetPortraitButton:SetPoint("CENTER", "Perl_Target_Frame", "CENTER", -115, -25);
	else
		TargetPortraitButton:SetPoint("CENTER", "TargetFrame", "CENTER", -135, 10);
	end
end

function SetTargetPortraitButton()
	local cible = UnitName("target");

	TargetPortraitButton:Show();
	anchorRegistreIcon();

	if cible==Joueur then -- UTILISATEUR
		local race,enRace = UnitRace("player");
		TargetPortraitButton:SetNormalTexture("Interface\\ICONS\\Achievement_Character_"..textureRace[enRace].."_"..textureSex[UnitSex("player")]..".blp");
	elseif TRP_Module_Registre[Royaume][cible] == nil then -- JOUEUR NON REPERTORIE
		TargetPortraitButton:SetNormalTexture("Interface\\ICONS\\INV_Misc_GroupNeedMore.blp");
	elseif TRP_Module_Registre[Royaume][cible] ~= nil then --Joueur de la DB
		if TRP_Module_PlayerInfo_Relations[Royaume][cible][Joueur] == nil then -- Premiere rencontre avec ce perso -> neutre
			TRP_Module_PlayerInfo_Relations[Royaume][cible][Joueur] = 3;
		end
		TargetPortraitButton:SetNormalTexture(relation_texture[TRP_Module_PlayerInfo_Relations[Royaume][cible][Joueur]]);
	end
end

function IconePosition()
	local x = sin(TRP_Module_Configuration["Modules"]["General"]["MiniMapIconDegree"])*TRP_Module_Configuration["Modules"]["General"]["MiniMapIconPosition"];
	local y = cos(TRP_Module_Configuration["Modules"]["General"]["MiniMapIconDegree"])*TRP_Module_Configuration["Modules"]["General"]["MiniMapIconPosition"];
	MinimapButton:SetPoint("CENTER",x,y);
end

function ActionBarPosition()
	TRPActionsBar:SetAlpha(TRP_Module_Configuration["Modules"]["Actions"]["Alpha"]/100);
end

function MouseOverTooltip(bForce) -- Inspiriré de l'algorithme de FlagRSP2
	
	if TRP_Module_Configuration["Modules"]["Tooltip"]["Use"] then
		--GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		local nom = UnitName("mouseover");
		local tailleMax = TRP_Module_Configuration["Modules"]["Tooltip"]["Couper"];
		local tailleMaxTitre = TRP_Module_Configuration["Modules"]["Tooltip"]["CouperTitre"];
		if nom ~= nil then -- NPC or Joueur
			local infoTab = {};
			local i = GameTooltip:NumLines();
			for j = 1, GameTooltip:NumLines() do
				infoTab[j] = getglobal("GameTooltipTextLeft" ..  j):GetText();
			end
			
			if (i > 0 and infoTab[1] and not string.find(infoTab[1],"|c00000000")) or bForce then
				if UnitIsPlayer("mouseover") then -- JOUEUR
					i = 1;
					if nom == Joueur then
						local nomTotal = "|cff7777ff";
						if string.len(nomComplet(nom)) > tailleMax then
							nomTotal = nomTotal..string.sub(nomComplet(nom),1,tailleMax).."[...]"
						else
							nomTotal = nomTotal..nomComplet(nom);
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"] then
							nomTotal = nomTotal..statut_color[tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"])].." ( "..STATUTRPSMALL[tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["StatutRP"])].." )";
						end
						if UnitIsAFK("player") then
							nomTotal = "|cffffffff(AFK) "..nomTotal;
						elseif UnitIsDND("player") then
							nomTotal = "|cffff9900(DND) "..nomTotal;
						end
						infoTab[i] = nomTotal;
						if TRP_Module_Configuration["Modules"]["Tooltip"]["SousTitre"] then
							if TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"] ~= "" then
								i = i + 1;
								if string.len(TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"]) > tailleMaxTitre then
									infoTab[i] = "|cff7777ff< "..string.sub(TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"],1,tailleMaxTitre).."[...] >"
								else
									infoTab[i] = "|cff7777ff< "..TRP_Module_PlayerInfo[Royaume][Joueur]["SousTitre"].." >";
								end
							elseif UnitPVPName("player") ~= nom then
								i = i + 1;
								infoTab[i] = "|cff7777ff< "..UnitPVPName("mouseover").." >";
							end
						end
						i = i + 1;
						local Localclass,englishClass = UnitClass("mouseover");
						infoTab[i] = "|cffffffff"..UnitRace("mouseover").." "..classes_color[englishClass]..Localclass.."|cffffffff (Level "..UnitLevel("mouseover")..")";
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Guilde"] and GetGuildInfo("player") ~= nil then
							i = i + 1;
							local guilde, grade = GetGuildInfo("player");
							infoTab[i] = "|cffffffff"..grade.." of |cffff8000"..guilde;
						end
						if TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"] and TRP_Module_Configuration["Modules"]["Tooltip"]["Alignement"] then
								local texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique = getNameAndColorAlignement(Joueur);
								i = i + 1;
								infoTab[i] = "|cff"..deciToHexa(rougeEthique)..deciToHexa(vertEthique).."00Ethics : "..texteEthique;
								i = i + 1;
								infoTab[i] = "|cff"..deciToHexa(rougeMorale)..deciToHexa(vertMorale).."00Morality : "..texteMorale;
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Humeur"] and tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"]) ~= 7 then
							i = i + 1;
							infoTab[i] = "|cffffffff"..HUMEUR.." : "..humeur_color[tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"])]..HUMEUR_SET[tonumber(TRP_Module_PlayerInfo[Royaume][Joueur]["Humeur"])];
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Actuellement"] then
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"] ~= nil and string.gsub(TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"]," ","") ~= "" then
								i = i + 1;
								infoTab[i] = "|cffffffff"..ACTUELLEMENT.." :";
								local ok = true;
								local morceaux = "\""..setTRPColorToString(TRP_Module_PlayerInfo[Royaume][Joueur]["Actuellement"],true).."\"";
								local taille = 35;
								while ok do
									local indice = string.find(morceaux," ",taille);
									local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
									if passageLigne ~= nil then -- On a trouvé un passage à la ligne
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
										morceaux = "  "..string.sub(morceaux,passageLigne+1);
									elseif indice == nil then
										ok = false;
										i = i + 1;
										infoTab[i] = "|cffff9900  "..morceaux;
									else
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
										if string.len(string.sub(morceaux,1,indice)) > taille then
											taille = string.len(string.sub(morceaux,1,indice))
										end
										morceaux = string.sub(morceaux,indice);
									end
								end
							end
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Description"] then
							if RecollageDescription(Joueur,false) ~= "" then
								i = i + 1;
								infoTab[i] = "|cffffffff"..DESCRIPTIONTEXT.." :";
								local ok = true;
								local morceaux = "\""..string.gsub(TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][1],"\n"," ");
								if TRP_Module_PlayerInfo[Royaume][Joueur]["Description"][2] ~= nil then
									morceaux = morceaux.." [...]\"";
								else
									morceaux = morceaux.."\"";
								end
								local taille = 35
								while ok do
									local indice = string.find(morceaux," ",taille);
									local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
									if passageLigne ~= nil then -- On a trouvé un passage à la ligne
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
										morceaux = "  "..string.sub(morceaux,passageLigne+1);
									elseif indice == nil then
										ok = false;
										i = i + 1;
										infoTab[i] = "|cffff9900   "..morceaux;
									else
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
										if string.len(string.sub(morceaux,1,indice)) > taille then
											taille = string.len(string.sub(morceaux,1,indice))
										end
										morceaux = string.sub(morceaux,indice);
									end
								end
							end
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] then
							infoTab[1] = IconeFaction[UnitFactionGroup("mouseover")]..infoTab[1];
						else
							i = i + 1;
							infoTab[i] = "|cff00ff00("..UnitFactionGroup("mouseover")..")";
						end
						if UnitIsDeadOrGhost("mouseover") then
							i = i + 1;
							if UnitIsGhost("mouseover") then
								infoTab[i] = "|cff00ffff< Ghost >";
							else
								infoTab[i] = "|cffff0000< KO >";
							end
						end
						
						local monture = GetActualMountName();
						if monture and TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture] then
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Nom"] ~= "" then
								i = i + 1;
								infoTab[i] = " ";
								i = i + 1;
								infoTab[i] = "{o}Mount : {v}"..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Nom"];
							elseif TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Description"] ~= "" then
								i = i + 1;
								infoTab[i] = " ";
								i = i + 1;
								infoTab[i] = "{o}Mount : {v}"..monture;
							end
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Description"] ~= "" then
								i = i + 1;
								infoTab[i] = "|cffffffff"..DESCRIPTIONTEXT.." :";
								local ok = true;
								local morceaux = "\""..TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][monture]["Description"].."\"";
								local taille = 35;
								while ok do
									local indice = string.find(morceaux," ",taille);
									local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
									if passageLigne ~= nil then -- On a trouvé un passage à la ligne
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
										morceaux = "  "..string.sub(morceaux,passageLigne+1);
									elseif indice == nil then
										ok = false;
										i = i + 1;
										infoTab[i] = "|cffff9900  "..morceaux;
									else
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
										if string.len(string.sub(morceaux,1,indice)) > taille then
											taille = string.len(string.sub(morceaux,1,indice))
										end
										morceaux = string.sub(morceaux,indice);
									end
								end
							end
						end
					else -- Personnage joueur
						if TRP_Module_Registre[Royaume][nom] ~= nil then
							local race, raceEn = UnitRace("mouseover");
							local faction = UnitFactionGroup("mouseover");
							TRP_Module_Registre[Royaume][nom]["Faction"] = faction;
							TRP_Module_Registre[Royaume][nom]["Race"] = raceEn;
							TRP_Module_Registre[Royaume][nom]["Sex"] = UnitSex("mouseover");
							TRP_Module_Registre[Royaume][nom]["Connu"] = true;
						end
						local myNomComplet = "";
						if TRP_Module_Registre[Royaume][nom] ~= nil and TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] ~= nil then
							myNomComplet = relation_color[TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur]];
						elseif UnitFactionGroup("mouseover") ~= UnitFactionGroup("player") then
							myNomComplet = "|cffff0000";
						else
							myNomComplet = "|cff7777ff";
						end
						if string.len(nomComplet(nom)) > tailleMax then
							myNomComplet = myNomComplet..string.sub(nomComplet(nom),1,tailleMax).."[...]"
						else
							myNomComplet = myNomComplet..nomComplet(nom);
						end
						if UnitIsAFK("mouseover") then
							myNomComplet = "|cffffffff(AFK) "..myNomComplet;
						elseif UnitFactionGroup("mouseover") == UnitFactionGroup("player") and UnitIsDND("mouseover") then
							nomTotal = "|cffff9900(DND) "..myNomComplet;
						end
						if TRP_Module_Registre[Royaume][nom] and TRP_Module_Registre[Royaume][nom]["StatutRP"] and TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"] then
							myNomComplet = myNomComplet..statut_color[tonumber(TRP_Module_Registre[Royaume][nom]["StatutRP"])].." ( "..STATUTRPSMALL[tonumber(TRP_Module_Registre[Royaume][nom]["StatutRP"])].." )";
						end
						infoTab[i] = myNomComplet;
						if TRP_Module_Configuration["Modules"]["Tooltip"]["SousTitre"] then
							if TRP_Module_Registre[Royaume][nom] and TRP_Module_Registre[Royaume][nom]["SousTitre"] and TRP_Module_Registre[Royaume][nom]["SousTitre"] ~= "" then
								i = i + 1;
								infoTab[i] = "|cff7777ff< "..TRP_Module_Registre[Royaume][nom]["SousTitre"].." >";
							elseif UnitPVPName("mouseover") and UnitPVPName("mouseover") ~= nom then
								i = i + 1;
								infoTab[i] = "|cff7777ff< "..UnitPVPName("mouseover").." >";
							end
						end
						i = i + 1;
						local Localclass,englishClass = UnitClass("mouseover");
						infoTab[i] = "|cffffffff"..UnitRace("mouseover").." "..classes_color[englishClass]..Localclass.."|cffffffff (Level "..UnitLevel("mouseover")..")";
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Guilde"] and GetGuildInfo("mouseover") ~= nil then
							i = i + 1;
							local guilde, grade = GetGuildInfo("mouseover");
							infoTab[i] = "|cffffffff"..grade.." from |cffffaa00"..guilde;
						end
						if TRP_Module_Registre[Royaume][nom] ~= nil and TRP_Module_Registre[Royaume][nom]["Morale"] ~= nil then -- Personnages TRP
							if TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"] and TRP_Module_Configuration["Modules"]["Tooltip"]["Alignement"] and TRP_Module_Registre[Royaume][nom]["Ethique"] ~= 0 then
								local texteMorale,texteEthique,vertMorale,rougeMorale,vertEthique,rougeEthique = getNameAndColorAlignement(nom);
								i = i + 1;
								infoTab[i] = "|cff"..deciToHexa(rougeEthique)..deciToHexa(vertEthique).."00Ethics : "..texteEthique;
								i = i + 1;
								infoTab[i] = "|cff"..deciToHexa(rougeMorale)..deciToHexa(vertMorale).."00Morality : "..texteMorale;
							end
							if TRP_Module_Configuration["Modules"]["Tooltip"]["Humeur"] and tonumber(TRP_Module_Registre[Royaume][nom]["Humeur"]) ~= 7 then
								i = i + 1;
								infoTab[i] = "|cffffffff"..HUMEUR.." : "..humeur_color[tonumber(TRP_Module_Registre[Royaume][nom]["Humeur"])]..HUMEUR_SET[tonumber(TRP_Module_Registre[Royaume][nom]["Humeur"])];
							end
							if TRP_Module_Configuration["Modules"]["Tooltip"]["Actuellement"] then
								if TRP_Module_Registre[Royaume][nom]["Actuellement"] ~= nil and string.gsub(string.gsub(TRP_Module_Registre[Royaume][nom]["Actuellement"],"\n","")," ","") ~= "" then
									i = i + 1;
									infoTab[i] = "|cffffffff"..ACTUELLEMENT.." :";
									local ok = true;
									local morceaux = "\""..setTRPColorToString(TRP_Module_Registre[Royaume][nom]["Actuellement"],true).."\"";
									local taille = 35
									while ok do
										local indice = string.find(morceaux," ",taille);
										local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
										if passageLigne ~= nil then -- On a trouvé un passage à la ligne
											i = i + 1;
											infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
											morceaux = "  "..string.sub(morceaux,passageLigne+1);
										elseif indice == nil then
											ok = false;
											i = i + 1;
											infoTab[i] = "|cffff9900  "..morceaux;
										else
											i = i + 1;
											infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
											if string.len(string.sub(morceaux,1,indice)) > taille then
												taille = string.len(string.sub(morceaux,1,indice))
											end
											morceaux = string.sub(morceaux,indice);
										end
									end
								end
							end
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Description"] and TRP_Module_Registre[Royaume][nom] ~= nil then
							if RecollageDescription(nom,false) ~= "" then
								i = i + 1;
								infoTab[i] = "|cffffffff"..DESCRIPTIONTEXT.." :";
								local ok = true;
								local morceaux = "\""..string.gsub(TRP_Module_Registre[Royaume][nom]["Description"][1],"\n"," ").."\"";
								if TRP_Module_Registre[Royaume][nom]["Description"][2] ~= nil then
									morceaux = morceaux.." [...]\"";
								else
									morceaux = morceaux.."\"";
								end
								local taille = 35
								while ok do
									local indice = string.find(morceaux," ",taille);
									local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
									if passageLigne ~= nil then -- On a trouvé un passage à la ligne
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
										morceaux = "  "..string.sub(morceaux,passageLigne+1);
									elseif indice == nil then
										ok = false;
										i = i + 1;
										infoTab[i] = "|cffff9900  "..morceaux;
									else
										i = i + 1;
										infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
										if string.len(string.sub(morceaux,1,indice)) > taille then
											taille = string.len(string.sub(morceaux,1,indice))
										end
										morceaux = string.sub(morceaux,indice);
									end
								end
							end
						end
						if TRP_Module_Configuration["Modules"]["Tooltip"]["Relation"] and TRP_Module_Registre[Royaume][nom] ~= nil and TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur] ~= nil then
							i = i + 1;
							infoTab[i] = "|cffffffff"..RELATIONTEXT.."|T"..relation_texture[TRP_Module_PlayerInfo_Relations[Royaume][nom][Joueur]]..":35:35:10:-5|t";
						end
						if UnitFactionGroup("mouseover") ~= UnitFactionGroup("player") then
							if UnitFactionGroup("mouseover") ~= nil then
								if TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] then
									infoTab[1] = IconeFaction[UnitFactionGroup("mouseover")]..infoTab[1];
								else
									i = i + 1;
									infoTab[i] = "|cffff0000("..UnitFactionGroup("mouseover")..")";
								end
							else
								i = i + 1;
								infoTab[i] = "|cffff0000(Player)";
							end
						else
							if TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] then
								infoTab[1] = IconeFaction[UnitFactionGroup("mouseover")]..infoTab[1];
							else
								i = i + 1;
								infoTab[i] = "|cff00ff00("..UnitFactionGroup("mouseover")..")";
							end
						end
						if UnitIsPVP("mouseover") then
							if TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"] then
								infoTab[1] = "|TInterface\\GossipFrame\\BattleMasterGossipIcon.blp:25:25|t"..infoTab[1];
							else
								infoTab[i] = "|cffffffffJcJ "..infoTab[i];
							end
						end
						if UnitIsDead("mouseover") then
							i = i + 1;
							if UnitIsGhost("mouseover") then
								infoTab[i] = "|cff00ffff< Ghost >";
							else
								infoTab[i] = "|cffff0000< KO >";
							end
						end
						
						if TRP_Module_Registre[Royaume][nom] and TRP_Module_Registre[Royaume][nom]["Pet"] then
							local monture;
							for i=1,20 do
								monture = UnitBuff("mouseover", i);
								-- Hax, merci blibli ...
								if monture then
									monture = string.gsub(monture,"Sabre%-de%-givre de Berceau%-de%-l%'Hiver","Sabre%-de%-givre du Berceau%-de%-l%'Hiver");
								end
								if monture and TRP_Module_Registre[Royaume][nom]["Pet"][monture] then
									break;
								end
							end
							
							if monture and TRP_Module_Registre[Royaume][nom]["Pet"][monture] then
								if TRP_Module_Registre[Royaume][nom]["Pet"][monture]["Nom"] ~= "" then
									i = i + 1;
									infoTab[i] = " ";
									i = i + 1;
									infoTab[i] = "{o}Mount : {v}"..TRP_Module_Registre[Royaume][nom]["Pet"][monture]["Nom"];
								elseif TRP_Module_Registre[Royaume][nom]["Pet"][monture]["Description"] ~= "" then
									i = i + 1;
									infoTab[i] = " ";
									i = i + 1;
									infoTab[i] = "{o}Mount : {v}"..monture;
								end
								if TRP_Module_Registre[Royaume][nom]["Pet"][monture]["Description"] ~= "" then
									i = i + 1;
									infoTab[i] = "|cffffffff"..DESCRIPTIONTEXT.." :";
									local ok = true;
									local morceaux = "\""..TRP_Module_Registre[Royaume][nom]["Pet"][monture]["Description"].."\"";
									local taille = 35;
									while ok do
										local indice = string.find(morceaux," ",taille);
										local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
										if passageLigne ~= nil then -- On a trouvé un passage à la ligne
											i = i + 1;
											infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
											morceaux = "  "..string.sub(morceaux,passageLigne+1);
										elseif indice == nil then
											ok = false;
											i = i + 1;
											infoTab[i] = "|cffff9900  "..morceaux;
										else
											i = i + 1;
											infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
											if string.len(string.sub(morceaux,1,indice)) > taille then
												taille = string.len(string.sub(morceaux,1,indice))
											end
											morceaux = string.sub(morceaux,indice);
										end
									end
								end
							end
						end
					end
				else -- NPC
					-- detection de FAMILIER
					if infoTab[2] and foundInTableString(compagnonPrefixe,infoTab[2]) then
						local nomMaitre = infoTab[2];
						local DeuxiemeLigne = infoTab[2];
						local nomPet = infoTab[1];
						local nomFinalPet = nomPet;
						local descriPet;
						local niveau = infoTab[3];
						nomMaitre = string.gsub(nomMaitre,"Serviteur de ","");
						nomMaitre = string.gsub(nomMaitre,"Serviteur d'","");
						nomMaitre = string.gsub(nomMaitre,"Familier de ",""); -- 's Pet
						nomMaitre = string.gsub(nomMaitre,"Familier d'","");
						nomMaitre = string.gsub(nomMaitre,"Compagnon de ",""); -- 's Companion
						nomMaitre = string.gsub(nomMaitre,"Compagnon d'","");
						nomMaitre = string.gsub(nomMaitre,"Gardien de ",""); -- 's Minion
						nomMaitre = string.gsub(nomMaitre,"Gardien d'","");
						nomMaitre = string.gsub(nomMaitre,"'s Guardian","");
						nomMaitre = string.gsub(nomMaitre,"'s Companion","");
						nomMaitre = string.gsub(nomMaitre,"'s Minion","");
						nomMaitre = string.gsub(nomMaitre,"'s Pet","");
						
						if nomMaitre == Joueur and TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nomPet] then
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nomPet]["Nom"] ~= "" then
								nomFinalPet = TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nomPet]["Nom"];
							end
							if TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nomPet]["Description"] ~= "" then
								descriPet = TRP_Module_PlayerInfo[Royaume][Joueur]["Pet"][nomPet]["Description"];
							end
						elseif TRP_Module_Registre[Royaume][nomMaitre] and TRP_Module_Registre[Royaume][nomMaitre]["Pet"] and TRP_Module_Registre[Royaume][nomMaitre]["Pet"][nomPet] then
							if TRP_Module_Registre[Royaume][nomMaitre]["Pet"][nomPet]["Nom"] ~= "" then
								nomFinalPet = TRP_Module_Registre[Royaume][nomMaitre]["Pet"][nomPet]["Nom"];
							end
							if TRP_Module_Registre[Royaume][nomMaitre]["Pet"][nomPet]["Description"] ~= "" then
								descriPet = TRP_Module_Registre[Royaume][nomMaitre]["Pet"][nomPet]["Description"];
							end
						end
						
						local realName = nomMaitre;
						if nomMaitre == Joueur and TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"] then
							realName = TRP_Module_PlayerInfo[Royaume][Joueur]["Prenom"];
						elseif TRP_Module_Registre[Royaume][nomMaitre] and TRP_Module_Registre[Royaume][nomMaitre]["Prenom"] then
							realName = TRP_Module_Registre[Royaume][nomMaitre]["Prenom"];
						end
						
						if UnitIsFriend("mouseover","player") then
							infoTab[1] = "|cff00ff00"..nomFinalPet;
							infoTab[2] = "|cffffffff"..tostring(UnitCreatureType("mouseover"));
							if TRP_Module_Registre[Royaume][nomMaitre] and TRP_Module_PlayerInfo_Relations[Royaume][nomMaitre][Joueur] ~= nil then
								infoTab[3] = string.gsub(DeuxiemeLigne,nomMaitre,relation_color[TRP_Module_PlayerInfo_Relations[Royaume][nomMaitre][Joueur]]..realName);
							elseif nomMaitre == Joueur then
								infoTab[3] = string.gsub(DeuxiemeLigne,nomMaitre,"|cff00ff00"..realName);
							else
								infoTab[3] = string.gsub(DeuxiemeLigne,nomMaitre,"|cff7777ff"..realName);
							end
						else
							infoTab[1] = "|cffff0000"..nomFinalPet;
							infoTab[2] = "|cffffffff"..tostring(UnitCreatureType("mouseover"));
							if TRP_Module_Registre[Royaume][nomMaitre] and TRP_Module_PlayerInfo_Relations[Royaume][nomMaitre][Joueur] ~= nil then
								infoTab[3] = string.gsub(DeuxiemeLigne,nomMaitre,relation_color[TRP_Module_PlayerInfo_Relations[Royaume][nomMaitre][Joueur]]..realName);
							else
								infoTab[3] = string.gsub(DeuxiemeLigne,nomMaitre,"|cffff0000"..realName);
							end
						end
						i = 3;
						
						if descriPet then
							i = i + 1;
							infoTab[i] = "|cffffffff"..DESCRIPTIONTEXT.." :";
							local ok = true;
							local morceaux = "\""..descriPet.."\"";
							local taille = 35;
							while ok do
								local indice = string.find(morceaux," ",taille);
								local passageLigne = string.find(string.sub(morceaux,1,indice),"\n",1,taille);
								if passageLigne ~= nil then -- On a trouvé un passage à la ligne
									i = i + 1;
									infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,passageLigne-1);
									morceaux = "  "..string.sub(morceaux,passageLigne+1);
								elseif indice == nil then
									ok = false;
									i = i + 1;
									infoTab[i] = "|cffff9900  "..morceaux;
								else
									i = i + 1;
									infoTab[i] = "|cffff9900  "..string.sub(morceaux,1,indice);
									if string.len(string.sub(morceaux,1,indice)) > taille then
										taille = string.len(string.sub(morceaux,1,indice))
									end
									morceaux = string.sub(morceaux,indice);
								end
							end
						end
					elseif infoTab[1] ~= nil then
						local reaction = UnitReaction("mouseover","player");
						if reaction == 1 then -- Vraiment hai ;)
							infoTab[1] = "|cffff0000"..infoTab[1];
						elseif reaction == 2 then -- Hai
							infoTab[1] = "|cffff3300"..infoTab[1];
						elseif reaction == 3 then -- Hostile
							infoTab[1] = "|cffff5500"..infoTab[1];
						elseif reaction == 4 then -- Neutre
							infoTab[1] = "|cffffdd00"..infoTab[1];
						elseif reaction == 5 then -- Amical
							infoTab[1] = "|cff00cc00"..infoTab[1];
						elseif reaction == 6 then -- Honor\195\169
							infoTab[1] = "|cff00dd00"..infoTab[1];
						elseif reaction == 7 then -- Revere
							infoTab[1] = "|cff00ee00"..infoTab[1];
						elseif reaction == 8 then -- Exalt\195\169
							infoTab[1] = "|cff00ff00"..infoTab[1];
						end
						local creatureFamille = UnitCreatureFamily("mouseover");
						local creatureType = UnitCreatureType("mouseover");
						local creatureNiveau = UnitLevel("mouseover");
						local creatureMorte = UnitIsDead("mouseover");
						local creatureJcj = UnitIsPVP("mouseover");
						local creatureFaction = UnitFactionGroup("mouseover");
						local creatureRace = UnitRace("mouseover");
					end
					--NPC
				end
			end
			--Affichage
			GameTooltip:Hide();
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
			if infoTab[1] then
				infoTab[1] = "|c00000000"..infoTab[1];
			end
			for j = 1, i do
				if infoTab[j] then
					GameTooltip:AddLine(setTRPColorToString("{w}"..infoTab[j]));
				end
			end
			if UnitName("mouseover") and TRP_Module_Configuration["Modules"]["Tooltip"]["BarreDeVie"] then
				TRP_ShowStatusBar(GameTooltip, 0, UnitHealthMax("mouseover"), UnitHealth("mouseover"), HEALTH.." : "..UnitHealth("mouseover").." / "..UnitHealthMax("mouseover"));
			end
			GameTooltip:Show();
		end
	end
end

function TRP_ShowStatusBar(self, min, max, value, text)
	--self:AddLine(" ", 1.0, 1.0, 1.0);
	local numLines = self:NumLines();
	if ( not self.numStatusBars ) then
		self.numStatusBars = 0;
	end
	if ( not self.shownStatusBars ) then
		self.shownStatusBars = 0;
	end
	local index = self.shownStatusBars+1;
	local name = self:GetName().."StatusBar"..index;
	local statusBar = _G[name];
	if ( not statusBar ) then
		self.numStatusBars = self.numStatusBars+1;
		statusBar = CreateFrame("StatusBar", name, self, "TooltipStatusBarTemplate");
	end
	if ( not text ) then
		text = "";
	end
	_G[name.."Text"]:SetText(text);
	statusBar:SetMinMaxValues(min, max);
	statusBar:SetValue(value);
	statusBar:Show();
	if getglobal(self:GetName().."TextLeft"..numLines) then
		statusBar:SetPoint("LEFT", self:GetName().."TextLeft"..numLines, "LEFT", 0, -25);
	end
	statusBar:SetPoint("RIGHT", self, "RIGHT", -9, -15);
	statusBar:Show();
	self.shownStatusBars = index;
	self:SetMinimumWidth(140);
	statusBar:SetScript("OnUpdate",function(self) 
		if UnitName("mouseover") then
			self:SetMinMaxValues(0, UnitHealthMax("mouseover"));
			self:SetValue(UnitHealth("mouseover"));
			self:Show();
			_G[name.."Text"]:SetText(HEALTH.." : "..UnitHealth("mouseover").."/"..UnitHealthMax("mouseover").." ("..math.floor((UnitHealth("mouseover")/UnitHealthMax("mouseover")*100)).."%)");
		end
	end);
end
