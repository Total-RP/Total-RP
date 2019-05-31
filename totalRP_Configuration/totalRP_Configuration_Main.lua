function AdaptConfiguration(panel,arg0)
	FicheJoueurOngletOptions:Disable();
	FicheJoueurOngletOptionsIcon:SetAlpha(0.5);
	FicheJoueurFond:SetTexture("Interface\\Stationery\\Stationery_OG1.blp");
	FicheJoueurFondDroite:SetTexture("Interface\\Stationery\\Stationery_OG2.blp");
	PanelConfigurationOngletGeneralIcon:SetTexture("Interface\\ICONS\\INV_Gizmo_01.blp");
	PanelConfigurationOngletRegistreIcon:SetTexture("Interface\\ICONS\\INV_Misc_Book_04.blp");
	PanelConfigurationOngletInventaireIcon:SetTexture("Interface\\ICONS\\INV_Misc_Bag_BigBagofEnchantments.blp");
	PanelConfigurationOngletDocumentsIcon:SetTexture("Interface\\ICONS\\INV_Letter_06.blp");
	PanelConfigurationOngletTooltipIcon:SetTexture("Interface\\ICONS\\INV_Enchant_FormulaSuperior_01.blp");
	PanelConfigurationOngletActionIcon:SetTexture("Interface\\ICONS\\Spell_Holy_LayOnHands.blp");
	PanelConfigurationOngletCommunicationIcon:SetTexture("Interface\\ICONS\\Spell_Shadow_SoothingKiss.blp");
	PanelConfigurationOngletSonsIcon:SetTexture("Interface\\ICONS\\INV_Misc_Ear_Human_01.blp");
	PanelConfigurationOngletGeneral:Enable();
	PanelConfigurationOngletInventaire:Enable();
	PanelConfigurationOngletRegistre:Enable();
	PanelConfigurationOngletDocuments:Enable();
	PanelConfigurationOngletTooltip:Enable();
	PanelConfigurationOngletAction:Enable();
	PanelConfigurationOngletCommunication:Enable();
	PanelConfigurationOngletSons:Enable();
	PanelConfigurationOngletGeneralIcon:SetAlpha(1);
	PanelConfigurationOngletRegistreIcon:SetAlpha(1);
	PanelConfigurationOngletInventaireIcon:SetAlpha(1);
	PanelConfigurationOngletDocumentsIcon:SetAlpha(1);
	PanelConfigurationOngletTooltipIcon:SetAlpha(1);
	PanelConfigurationOngletActionIcon:SetAlpha(1);
	PanelConfigurationOngletCommunicationIcon:SetAlpha(1);
	PanelConfigurationOngletSonsIcon:SetAlpha(1);
	PanelConfigurationPanelGeneral:Hide();
	PanelConfigurationPanelRegistre:Hide();
	PanelConfigurationPanelDocuments:Hide();
	PanelConfigurationPanelInventaire:Hide();
	PanelConfigurationPanelTooltip:Hide();
	FicheJoueurPanelConfiguration:Show();
	PanelConfigurationPanelActions:Hide();
	PanelConfigurationPanelCommunication:Hide();
	PanelConfigurationPanelSons:Hide();
	
	ChargerConfiguration();
	
	if panel == nil or panel == "General" then
		PanelConfigurationOngletGeneral:Disable();
		PanelConfigurationOngletGeneralIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..GENERAL_TEXT);
		PanelConfigurationPanelGeneral:Show();
	elseif panel == "Registre" then
		PanelConfigurationOngletRegistre:Disable();
		PanelConfigurationOngletRegistreIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..ANNUAIRE);
		PanelConfigurationPanelRegistre:Show();
	elseif panel == "Inventaire" then
		PanelConfigurationOngletInventaire:Disable();
		PanelConfigurationOngletInventaireIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..INVENTAIRE);
		PanelConfigurationPanelInventaire:Show();
	elseif panel == "Documents" then
		PanelConfigurationOngletDocuments:Disable();
		PanelConfigurationOngletDocumentsIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..DOCUMENT);
		PanelConfigurationPanelDocuments:Show();
	elseif panel == "Tooltip" then
		PanelConfigurationOngletTooltip:Disable();
		PanelConfigurationOngletTooltipIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..TOOLTIPTEXTE);
		PanelConfigurationPanelTooltip:Show();
	elseif panel == "Actions" then
		PanelConfigurationOngletAction:Disable();
		PanelConfigurationOngletActionIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..ACTIONSTEXT);
		PanelConfigurationPanelActions:Show();
	elseif panel == "Communication" then
		PanelConfigurationOngletCommunication:Disable();
		PanelConfigurationOngletCommunicationIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..COMMUTEXT);
		PanelConfigurationPanelCommunication:Show();
	elseif panel == "Sons" then
		PanelConfigurationOngletSons:Disable();
		PanelConfigurationOngletSonsIcon:SetAlpha(0.5);
		FicheJoueurPanelTitle:SetText(PARAMETRES.." : "..SONSTEXT);
		PanelConfigurationPanelSons:Show();
	end
end

function setTooltipDocuLevel(slider,value)
	if slider:IsVisible() then
		GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT");
		GameTooltip:AddLine("Filtering level :",1,0.75,0);
		GameTooltip:AddLine(" ",1,0.75,0);
		GameTooltip:AddLine(setTRPColorToString(CONFIGDOCUCONFIRMTITLE[value]),1,0.75,0);
		GameTooltip:AddLine(" ",1,0.75,0);
		decouperForTooltip(CONFIGDOCUCONFIRM[value],35,1,1,1,true);
		GameTooltip:Show();
	end
end

function setTooltipInventaireLevel(slider,value)
	if slider:IsVisible() then
		GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT");
		GameTooltip:AddLine("Filtering level :",1,0.75,0);
		GameTooltip:AddLine(" ",1,0.75,0);
		GameTooltip:AddLine(setTRPColorToString(CONFIGINVCONFIRMTITLE[value]),1,0.75,0);
		GameTooltip:AddLine(" ",1,0.75,0);
		decouperForTooltip(CONFIGINVCONFIRM[value],35,1,1,1,true);
		GameTooltip:Show();
	end
end

function ChargerConfiguration()
	--GENERAL
	ConfigGeneralDebugCheck:SetChecked(TRP_Module_Configuration["Modules"]["General"]["bDebug"]);
	ConfigGeneralMinimapPosSlider:SetValue(TRP_Module_Configuration["Modules"]["General"]["MiniMapIconPosition"]);
	ConfigGeneralMinimapRotSlider:SetValue(TRP_Module_Configuration["Modules"]["General"]["MiniMapIconDegree"]);
	ConfigGeneralCloseCombatCheck:SetChecked(TRP_Module_Configuration["Modules"]["General"]["bCloseInCombat"]);
	ConfigGeneralRappelVersionCheck:SetChecked(TRP_Module_Configuration["Modules"]["General"]["bNotifyNewVersion"]);
	ConfigGeneralDebugFrame:SetText(tostring(TRP_Module_Configuration["Modules"]["General"]["DebugFrame"]));
	--REGISTRE
	ConfigRegistreUseResumeCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyle"]);
	ConfigRegistreResumeAutoCloseCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStylePersistant"]);
	ConfigRegistreResumeAlphaSlider:SetValue(TRP_Module_Configuration["Modules"]["Registre"]["bRSPDescriStyleAlpha"]);
	ConfigRegistreAlignSendCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bSendAlignement"]);
	ConfigRegistreAlignShowCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bShowAlignement"]);
	ConfigRegistreNotifyAjoutCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bNotifyAjout"]);
	ConfigRegistreRSPCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bCompatibiliteRSP"]);
	ConfigRegistreForceCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bForceUpdate"]);
	ConfigRegistreRappelCheck:SetChecked(TRP_Module_Configuration["Modules"]["Registre"]["bRappel"]);
	--INVENTAIRE
	ConfigInventaireNiveauSlider:SetValue(TRP_Module_Configuration["Modules"]["Inventaire"]["Niveau"]);
	ConfigInventaireFrameGet:SetText(tostring(TRP_Module_Configuration["Modules"]["Inventaire"]["Frame"]));
	--DOCUMENTS
	ConfigDocumentsNiveauSlider:SetValue(TRP_Module_Configuration["Modules"]["Documents"]["Niveau"]);
	--TOOLTIP
	ConfigTooltipUseCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Use"]);
	ConfigTooltipStatutCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["StatutRP"]);
	ConfigTooltipSousTitreCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["SousTitre"]);
	ConfigTooltipAlignementCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Alignement"]);
	ConfigTooltipActuellementCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Actuellement"]);
	ConfigTooltipDescriptionCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Description"]);
	ConfigTooltipRelationCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Relation"]);
	ConfigTooltipHumeurCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Humeur"]);
	ConfigTooltipGuildeCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["Guilde"]);
	ConfigTooltipCouperSlider:SetValue(TRP_Module_Configuration["Modules"]["Tooltip"]["Couper"]);
	ConfigTooltipCouperTitreSlider:SetValue(TRP_Module_Configuration["Modules"]["Tooltip"]["CouperTitre"]);
	ConfigTooltipImagesCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["UseImageIn"]);
	ConfigTooltipAideInvCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["AideInventaire"]);
	ConfigTooltipDocuInvCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["DocuInventaire"]);
	ConfigTooltipBarreVieCheck:SetChecked(TRP_Module_Configuration["Modules"]["Tooltip"]["BarreDeVie"]);
	--ACTIONS
	ConfigActionsAlphaSlider:SetValue(TRP_Module_Configuration["Modules"]["Actions"]["Alpha"]);
	ConfigActionLockCheck:SetChecked(TRP_Module_Configuration["Modules"]["Actions"]["Lock"]);
	--COMMUNICATION
	ConfigCommuParentheseCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["AutoParenthese"]);
	ConfigCommuUseTRPChatCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["UseTRPChat"]);
	ConfigCommuHRPDetectCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["HRPDetect"]);
	ConfigCommuEmoteDetectCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["EmoteDetect"]);
	ConfigCommuSpamDetectCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["SpamDetect"]);
	ConfigCommuNameInChatCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["NameInChat"]);
	ConfigCommuHRPDetectFrame:SetText(tostring(TRP_Module_Configuration["Modules"]["Communication"]["HRPDetectFrame"]));
	ConfigCommuSpamDetectFrame:SetText(tostring(TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectFrame"]));
	ConfigCommuSpamListFrameEditbox:SetText(tostring(TRP_Module_Configuration["Modules"]["Communication"]["SpamDetectList"]));
	ConfigCommuColorNameCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["UseColorName"]);
	ConfigCommuLoreFrameCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["LoreFrameCheck"]);
	ConfigCommuLoreFrameEditbox:SetText(tostring(TRP_Module_Configuration["Modules"]["Communication"]["LoreFrame"]));
	ConfigCommuIconeCheck:SetChecked(TRP_Module_Configuration["Modules"]["Communication"]["IconeRelation"]);
	--SONS
	ConfigSonsActivateCheck:SetChecked(TRP_Module_Configuration["Modules"]["Sons"]["Activate"]);
	ConfigSonsAntiSpamCheck:SetChecked(TRP_Module_Configuration["Modules"]["Sons"]["AntiSpam"]);
	ConfigSonsLogCheck:SetChecked(TRP_Module_Configuration["Modules"]["Sons"]["Log"]);
	ConfigSonsAntiSpamTime:SetText(tostring(TRP_Module_Configuration["Modules"]["Sons"]["AntiSpamCooldown"]));
	ConfigSonsLogFrame:SetText(tostring(TRP_Module_Configuration["Modules"]["Sons"]["LogFrame"]));
end
