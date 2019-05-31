function TRP_InitialiseStaticPopup()
	StaticPopupDialogs["TRP_REG_EPURER_LISTE"] = {
	  text = TRP_ENTETE..EPURERLISTE.."\n\n"..TRP_TEXT_STATIC_POPUP.TRP_REG_EPURER_LISTE..CAREFULL,
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function()
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function()
			epurerListe();
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_REG_DELETE_PERSO"] = {
	  text = TRP_ENTETE..DELETEPERSO.."\n\n"..TRP_TEXT_STATIC_POPUP.TRP_REG_DELETE_PERSO..CAREFULL,
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			deletePersonnage(self.trparg1);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_REG_GLOBAL_RELATION"] = {
	  text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
	  button1 = "Ok",
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_OBJECT"] = {
	  text = "\n\n\n\n\n\n\n",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			proceedDeleteObject(self.trparg1,self.trparg2);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_OBJECT_AMOUNT"] = {
	  text = "\n\n\n\n\n\n\n\n",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" and tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText()) > 0 then
				proceedDeleteObject(self.trparg1,tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText()));
			end
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1
	};
	
	StaticPopupDialogs["TRP_EMOTEGLOBAL"] = {
	  text = TRP_ENTETE.."Enter No-targeted emote to play. \n\nA No-targeted emote is an emote that is not played by a character. \nExample: \"A sound is heard.\"",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				texte = setTRPColorToString(texte,true);
				SendChatMessage("|| "..texte,"EMOTE");
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() and self:GetText() ~= "" then
				local texte = self:GetText();
				texte = setTRPColorToString(texte,true);
				SendChatMessage("|| "..texte,"EMOTE");
			end
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_EMOTENAMEDIRE"] = {
	  text = TRP_ENTETE.."Enter the name of the person who will speak.",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				texte = setTRPColorToString(texte,true);
				StaticPopupDialogs["TRP_EMOTENPCDIRE"].text = TRP_ENTETE.."Enter the dialogue "..texte.." will tell.\nThis is a spoken dialogue (/ say).";
				TRP_ShowStaticPopup("TRP_EMOTENPCDIRE",nil,nil,texte);
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() and self:GetText() ~= "" then
				local texte = self:GetText();
				texte = setTRPColorToString(texte,true);
				StaticPopupDialogs["TRP_EMOTENPCDIRE"].text = TRP_ENTETE.."Enter the dialogue "..texte.." will tell.\nThis is a spoken dialogue (/ say).";
				TRP_ShowStaticPopup("TRP_EMOTENPCDIRE",nil,nil,texte);
			end
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_EMOTENAME"] = {
	  text = TRP_ENTETE.."Enter the name of the person who will perform the emote.",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				texte = setTRPColorToString(texte,true);
				StaticPopupDialogs["TRP_EMOTENPC"].text = TRP_ENTETE.."Enter the emote"..texte.." will play.\nIt is an emote /me.";
				TRP_ShowStaticPopup("TRP_EMOTENPC",nil,nil,texte);
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() and self:GetText() ~= "" then
				local texte = self:GetText();
				texte = setTRPColorToString(texte,true);
				StaticPopupDialogs["TRP_EMOTENPC"].text = TRP_ENTETE.."Enter the emote"..texte.." will play.\nIt is an emote /me.";
				TRP_ShowStaticPopup("TRP_EMOTENPC",nil,nil,texte);
			end
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_EMOTENPC"] = {
	  text = TRP_ENTETE.."Enter the emote to play by the selected character. \nIt an emote /e.",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				texte = setTRPColorToString(texte,true);
				while strfind(texte," ") == 1 do
					texte = strsub(texte,2,strlen(texte));
				end
				if texte ~= "" then
					SendChatMessage("|| "..self.trparg1.." "..texte,"EMOTE");
				end
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() then
				local texte = self:GetText();
				texte = setTRPColorToString(texte,true);
				while strfind(texte," ") == 1 do
					texte = strsub(texte,2,strlen(texte));
				end
				if texte ~= "" then
					SendChatMessage("|| "..self:GetParent().trparg1.." "..texte,"EMOTE");
				end
			end
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_EMOTENPCDIRE"] = {
	  text = TRP_ENTETE.."Enter the dialogue that the target will tell. \nIt's a spoken dialogue (/say).",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				texte = setTRPColorToString(texte,true);
				while strfind(texte," ") == 1 do
					texte = strsub(texte,2,strlen(texte));
				end
				if texte ~= "" then
					SendChatMessage("|| "..self.trparg1.." says : "..texte,"EMOTE");
				end
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() then
				local texte = self:GetText();
				texte = setTRPColorToString(texte,true);
				while strfind(texte," ") == 1 do
					texte = strsub(texte,2,strlen(texte));
				end
				if texte ~= "" then
					SendChatMessage("|| "..self:GetParent().trparg1.." says : "..texte,"EMOTE");
				end
			end
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_SAISIESOUND"] = {
	  text = TRP_ENTETE.."Enter the path of the sound (from the root of the game and without the extension \".wav\".).\nPress Enter for preview.",
	  button1 = "Local",
	  button2 = "Cancel",
	  button3 = "Global",
	  OnShow = function(self)
			
	  end,
	  OnAccept = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				TRPPlaySoundGlobal(texte,false,true);
				TRPPlaySound(texte);
			end
	  end,
	  EditBoxOnEnterPressed = function(self)
			if self:GetText() and self:GetText() ~= "" then
				local texte = self:GetText();
				TRPPlaySound(texte)
			end
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  OnAlt = function(self)
			if getglobal(this:GetParent():GetName().."EditBox"):GetText() and getglobal(this:GetParent():GetName().."EditBox"):GetText() ~= "" then
				local texte = getglobal(this:GetParent():GetName().."EditBox"):GetText();
				TRPPlaySoundGlobal(texte,"1",true)
				TRPPlaySound(texte);
			end
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_REF_ASKING"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			ProceedObjetRefExchange(1,self.trparg1,self.trparg2,self.trparg3,self.trparg4);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ProceedObjetRefExchange(0);
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_OBJ_ASKING"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			ProceedObjetExchange(1,self.trparg1,self.trparg2,self.trparg3,self.trparg4);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ProceedObjetExchange(0);
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_DOC_ASKING"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			ProceedDocument(self.trparg1,self.trparg2,1,self.trparg3);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ProceedDocument(nil,nil,0,nil);
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_REF"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			DeleteObjetPerso(self.trparg1);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_CREATE_PLANQUE"] = {
	  text = TRP_ENTETE.."Create a hiding place: \n\nPlease enter a short description of your hiding place. This description will help you remember exactly where it is.",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)

	  end,
	  OnAccept = function(self)
				CreerPlanque(getglobal(this:GetParent():GetName().."EditBox"):GetText());
	  end,
	  EditBoxOnEnterPressed = function(self)
			CreerPlanque(getglobal(this:GetParent():GetName().."EditBox"):GetText());
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_TEXT_ONLY_SHADE"] = {
	  text = "",
	  button1 = "Ok",
	  OnShow = function()
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function()
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_ECRASE_SLOT"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			TRP_ShowStaticPopup("TRP_SAVE_PERSO",nil,nil,self.trparg1);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_GIVE_AMOUNT"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			local qte = tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText());
			if qte == nil then
				qte = 0;
			end
			if qte > self.trparg4 then
				qte = self.trparg4;
			end
			if qte > 0 then
				DonnerObjet(self.trparg1,self.trparg2,self.trparg3,qte);
			end
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_DOCU"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			wipe(TRP_Module_Documents[self.trparg1]);
			TRP_Module_Documents[self.trparg1] = nil;
			PanelOpen("FicheJoueurOngletDocument","DocumentsPanelListe");
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_AJOUT_OBJ_PERSO"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			local qte = tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText());
			if qte == nil then
				qte = 0;
			end
			if qte > 0 then
				GetObjets(self.trparg1,-1,qte);
			end
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_REF"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			DeleteObjetPerso(self.trparg1);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_PLANQUE"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			DeletePlanque();
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_INV_DELETE_COURRIER"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			deleteCourrier(self.trparg1,self.trparg2);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_AVERT_USE_CHAT"] = {
	  text = setTRPColorToString(TRP_ENTETE..TRP_TEXT_STATIC_POPUP["TRP_AVERT_USE_CHAT"]),
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			ReloadUI();
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};
	
	StaticPopupDialogs["TRP_SAVE_PERSO"] = {
	  text = TRP_ENTETE.."Enter the name of the profile.",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)

	  end,
	  OnAccept = function(self)
				SavePerso(self.trparg1,getglobal(this:GetParent():GetName().."EditBox"):GetText());
	  end,
	  EditBoxOnEnterPressed = function(self)
			SavePerso(self:GetParent().trparg1,getglobal(this:GetParent():GetName().."EditBox"):GetText());
			self:GetParent():Hide();
	  end,
	  OnCancel = function(arg1,arg2)
			
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1,
	  hideOnEscape = 1,
	};
	
	StaticPopupDialogs["TRP_OBJCREA_QTE"] = {
	  text = "",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			local qte = tonumber(getglobal(this:GetParent():GetName().."EditBox"):GetText());
			if qte == nil or qte < 1 then
				qte = 1;
			end
			self.trparg1.Qte = qte;
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	  hasEditBox = 1
	};
	
	StaticPopupDialogs["TRP_DOCU_CREATEOBJ"] = {
	  text = "",
	  button1 = "Yes",
	  button2 = "No",
	  OnShow = function(self)
			ShadeSecondPlan(0.5);
	  end,
	  OnAccept = function(self)
			PanelOpen("FicheJoueurOngletInventaire","InventaireOngletCreation");
			createEmptyObjetForDocument(self.trparg1);
			ShadeSecondPlan(1);
	  end,
	  OnCancel = function(arg1,arg2)
			PanelOpen("FicheJoueurOngletDocument","DocumentsPanelListe");
			ShadeSecondPlan(1);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1
	};

end

function TRP_ShowStaticPopup(popuptoshow,titre,message,trparg1,trparg2,trparg3,trparg4,bNumeric,Init)
	local dialog = StaticPopup_Show(popuptoshow);
    if(dialog) then
		if trparg1 then
			dialog.trparg1 = trparg1;
		end
		if trparg2 then
			dialog.trparg2 = trparg2;
		end
		if trparg3 then
			dialog.trparg3 = trparg3;
		end
		if trparg4 then
			dialog.trparg4 = trparg4;
		end
		if bNumeric then
			getglobal(dialog:GetName().."EditBox"):SetNumeric(bNumeric);
		else
			getglobal(dialog:GetName().."EditBox"):SetNumeric(0);
		end
		if Init then
			getglobal(dialog:GetName().."EditBox"):SetText(Init);
			getglobal(dialog:GetName().."EditBox"):HighlightText();
		else
			getglobal(dialog:GetName().."EditBox"):SetText("");
		end
    end
end
