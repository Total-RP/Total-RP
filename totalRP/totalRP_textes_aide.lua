-------------------------------------------------------------------------------
-- [ Texte - Localisation - Boutons d'aide] --
-------------------------------------------------------------------------------

CHARACTERENBR = " characters are available for this attribute.\n{o}Warning: one special character counts as two.";
CHRACTEREINTERDIT = "{r}These special characters are not allowed.\n^ $ ( ) % . [ ] * + - ? | {w}";
MUSTSAISIR = "{o}You must specify a value for this attribute.{w}";
NOMUSTSAISIR = "{v}This attribute is optional.{w}"
CAREFULL = "\n\n|cffffaa00This action can not be canceled.\n\nDo you really want to perform this action ?";
TRP_ENTETE = "|TInterface\\AddOns\\totalRP\\Images\\TRPlogo.tga:75:125|t\n";
CHATFRAMEEXPLICATION = "Chat Frame : \n1 - Main\n2 - Combat Log\n3 à 7 - Additional windows"

TEXTE_AIDE_BUTTON = {
	-- Création d'objets
	CreaObjReference = {
		Nom = "Item ID";
		Texte = "The ID of an item is the key that allows TotalRP to recognize an item from another.\n"
			  .."When you exchange an item with someone else, it keeps its ID.\nThe ID is a 16 digits number generated automatically by TRP.\n"
			  .."\n{o}You can't change the ID, you just can copy/paste it, for a use in the slash command for example.";
	},
	CreaObjNom = {
		Nom = "Item Name";
		Texte = "This is the name of the item.\n\n{o}Note: Two different items can have the same name."..MUSTSAISIR.."\n\n50"..CHARACTERENBR.."\n\n"..CHRACTEREINTERDIT;
	},
	CreaObjButinOnly = {
		Nom = "Do not allow manual addition";
		Texte = "This option allows you to prevent someone to add this item in its inventory at will (by maj+clicking on a item information). Only you, the author, can do it."..
		"\n\nWith this option, you can control the quantity of an item on your realm.";
	},
	CreaObjIcone = {
		Nom = "Item Icon";
		Texte = "This is the icon that is attributed to the item in the inventory.\n\nWhen you click the button, a window will prompt asking you to select an icon. "
				.."You can use the search feature.";
	},
	CreaObjModele = {
		Nom = "Item 3D model";
		Texte = "You can associate a 3D model to your item. This model will be visible when moving the mouse on the icon of the item.\n\n"..NOMUSTSAISIR;
	},
	CreaObjDescri = {
		Nom = "Item Description";
		Texte = "This is the description that will be shown in the item tooltip.\n\n"..NOMUSTSAISIR.."\n\n200"..CHARACTERENBR;
	},
	CreaObjPoids = {
		Nom = "Item Weight";
		Texte = "Determines the weight in grams, of a unit of this item. \n\nThis weight is used to calculate the total weight of your Backpack and Safe. "
				.."The weight is an informative attribute.\n\n"
				.."{o}The weight can be zero (0) or a maximum of 10 tons.";
	},
	CreaObjUnique = {
		Nom = "Item : Unique";
		Texte = "Determines whether the item can be possessed only on a limited amount.\n\n"..NOMUSTSAISIR.."\n\n"
				.."The Unique feature is global to all your bags (Backpack + Safe + Hiding places).\n\n"
				.."{v}Zero means infinity (no limit).\nThe maximum is 999.";
	},
	CreaObjCategorie = {
		Nom = "Item Category";
		Texte = "The category and subcategory of the item displayed in the info window (tooltip) of the item. The category allow users to easily sort the item in their inventory.\n\n{o}The Category is obligatory, as "
				.."the Subcategory is optional (select \"None\" for no Subcategory).";
	},
	CreaObjUtilisable = {
		Nom = "Usable Item";
		Texte = "Determines whether the item can be used or not.\n\nEnable this option unlock the associated options and panel \"Util. : Conditions\".";
	},
	CreaObjLock = {
		Nom = "Lock";
		Texte = "If you are locking the item, only you, the creator, can edit it.\n\nThis can be useful if your item contains information you don't want the user to see by editing it."
				.."\n\n{o}Be aware, however, that locking an item is anti-educational and prevents others to correct your item if it contains errors.";
	},
	CreaObjCharges = {
		Nom = "Charges";
		Texte = "Charges are the number of times an item can be used {o}before being automatically deleted{w}.\n\n{v}0 means infinity !\n\n"
				..MUSTSAISIR.."\n\nYou are limited to 999 charges at maximum.";
	},
	CreaObjOnUseMessage = {
		Nom = "When using : Message";
		Texte = "This message will appear in the chat window when the player use the item. {o}Only the player using the item will see this message, it is not shared.\n\n"
				..NOMUSTSAISIR.."\n\n200 "..CHARACTERENBR;
	},
	CreaObjOnUseEmote = {
		Nom = "When using : Emote";
		Texte = "This will make the player do a emote when he uses the item. This is an /e emote (but you don't have to write the \"/e\" anyway).\n\n"
				.."Example : \nEmote 'is confused.'\nDisplay: 'PlayerName is confused.'\n\n"
				..NOMUSTSAISIR.."\n\n100 "..CHARACTERENBR;
	},
	CreaObjOnDeathMessage = {
		Nom = "Once discharged : Message";
		Texte = "This message will appear in the chat window when the item is discharged (When its charges reach 0). {o}Only the player using the item vera this message, it is not shared.\n\n"
				.."{o}This message will appear in addition to the \"When using : Message\".\n\n"
				..NOMUSTSAISIR.."\n\n200 "..CHARACTERENBR;
	},
	CreaObjOnDeathEmote = {
		Nom = "Once discharged : Emote";
		Texte = "This emote will be played by the player when the item is discharged (When its charges reach 0).This is an /e emote (but you don't have to write the \"/e\" anyway).\n\n"
				.."Example : \nEmote 'is confused.'\nDisplay: 'PlayerName is confused.'\n\n"
				.."{o}This emote will be done in addition to the \"When using : Emote\".\n\n"
				..NOMUSTSAISIR.."\n\n100 "..CHARACTERENBR;
	},
	CreaObjOnUseCreate = {
		Nom = "When using : Receive item";
		Texte = "When using the item, the character will receive a number of units of the selected item.\n\n"..NOMUSTSAISIR.."\n\n{v}Left-click on the button to show "
				.."the items selection window. This window contains all the items that are not locked and all the add-on pre-built items.\nRight-click on the button to select the number of units that will be given.";
	},
	CreaObjOnDeathCreate = {
		Nom = "Once discharged: Receive item";
		Texte = "When the item is discharged (When its charges reach 0), the character will receive a number of units of the selected item.\n\n"..NOMUSTSAISIR
				.."\n\n{o}This item will be received in addition to the \"When using : Receive item\".\n\n{v}Left-click on the button to show "
				.."the items selection window. This window contains all the items that are not locked and all the add-on pre-built items.\nRight-click on the button to select the number of units that will be given.";
	},
	CreaObjOnUseSound = {
		Nom = "When using : Sound";
		Texte = "When using the item, the sound will be played. This is a local sound who will be heard by any TRP user in the party/raid (or by the target).\n\n"..NOMUSTSAISIR.."\n\n{v}Click on the List button to show "
				.."the sounds window selection. You can write yourself a path of a sound if its not in the list.";
	},
	CreaObjOnDeathSound = {
		Nom = "Once discharged : Sound";
		Texte = "When the item is discharged (When its charges reach 0), the sound will be played. This is a local sound who will be heard by any TRP user in the party/raid (or by the target).\n\n"
				.."{o}Warning, this sound will replace the sound to \"When using : Sound\".\n\n"
				..NOMUSTSAISIR.."\n\n{v}Click on the List button to show "
				.."the sounds window selection. You can write yourself a path of a sound if its not in the list.";
	},
	CreaObjTooltipUse = {
		Nom = "Tooltip green using text";
		Texte = "This text is added in the tooltip behind the word \"{v}Use : {w}\". By convention, start with a verb.\n\n"..NOMUSTSAISIR.."\n\n50 "..CHARACTERENBR;
	},
	CreaObjLierDocu = {
		Nom = "Associated document";
		Texte = "You can link a document to the item. When using the item, the player will see the document.\n\n"..NOMUSTSAISIR.."\n\n{v}Click on the button to show "
				.."the documents selection window. This window contains all the documents that haven't been locked by their creator.";
	},
	CreaObjCooldown = {
		Nom = "Cooldown";
		Texte = "You can set a waiting time, in seconds, between two uses of the item.\n\n"..NOMUSTSAISIR.."\n\nThe cooldown is saved, even if you quit the game. So you can set days if you want it. :)";
	},
	CreaObjConditions = {
		Nom = "Conditions for using";
		Texte = "Allow you to add conditions that have to be verify in order to use your item.\n\n"..NOMUSTSAISIR;
	},
	CreaObjCiblage = {
		Nom = "Must have a target";
		Texte = "Determines whether the user must target a character (himself or another person, or even a monster/NPC) in order to use the item.\n\n{r}If it does not, a message \"You don't have any target\" will be displayed and the item will not be used.\n\n"..NOMUSTSAISIR;
	},
	CreaObjCiblageCondSupp = {
		Nom = "Target conditions";
		Texte = "You can perform a series of tests on (o) the target of the user of the item (w). The item can be used only if all tests succeed.\n\n{r}If not, a message \"Target error\" will be displayed and the item will not be used.\n\n"..NOMUSTSAISIR.."\n\n"
				.."{o}For more information about testing syntax, visit the forum Total RP :\n{c}http://forums.telkostrasz.be/index.php\n{o}Section \"Tutorial\", topic \"[Tutoriel 1.103] Tests\".(only in french at this time)";
	},
	CreaObjUserCondSupp = {
		Nom = "User conditions";
		Texte = "You can perform a series of tests on {o}user of the item{w}. The item can be used only if all tests succeed.\n\n{r}If not, a message \"You can not use this item\" will be displayed and the item will not be used.\n\n"..NOMUSTSAISIR.."\n\n"
				.."{o}For more information about testing syntax, visit the forum Total RP :\n{c}http://forums.telkostrasz.be/index.php\n{o}Section \"Tutoriel\", discussion \"[Tutoriel 1.103] Les Tests\".(only in french at this time)";
	},
	CreaObjInventaire = {
		Nom = "Needed components";
		Texte = "You can add components that are needed in order to use the item.\n\n{r}If the user does not have all of the components required, a message \"Missing Component : [Component Name]\" will be displayed and the item will not be used.\n\n"..NOMUSTSAISIR.."\n\n"
				.."{o}For more information about components syntax, visit the forum Total RP :\n{c}http://forums.telkostrasz.be/index.php\n{o}Section \"Tutoriel\", discussion \"[Tutoriel 1.103] Les composants d'utilisation\".(only in french at this time)";
	},
	-- Création de documents
	CreaDocuVignetteTitre = {
		Nom = "Document Title";
		Texte = "This is the title of the document.\n\n"..MUSTSAISIR.."\n\n50 "..CHARACTERENBR;
	},
	CreaDocuVignetteDate = {
		Nom = "Document Date";
		Texte = "This is the date on which the document was created. {o}This does not correspond to the date when you created the document in TRP,{v} this is an RP information !\n\n"..NOMUSTSAISIR.."\n\n50 "..CHARACTERENBR;
	},
	CreaDocuVignetteAuteur = {
		Nom = "Document Author";
		Texte = "It is the author of the document. {o}This should not necessarily be your character, {v}this is an RP information !\n\n"..NOMUSTSAISIR.."\n\n50 "..CHARACTERENBR;
	},
	CreaDocuVignetteIcone = {
		Nom = "Document icon";
		Texte = "This is the icon that will be assigned to the document thumbnail.\n\nWhen you click on the button, a window will prompt asking you to select an icon.";
	},
	CreaDocuLier = {
		Nom = "Associated to an item";
		Texte = "{r}This option isn't used anymore.";
	},
	CreaDocuLock = {
		Nom = "Lock";
		Texte = "If you are locking the document, only you, the creator, can edit it.\n\nThis can be useful if your document contains information you don't want the user to see by editing it."
				.."\n\n{o}Be aware, however, that locking an document is anti-educational and prevents others to correct your document if it contains errors.";
	},
};

TRP_TEXT_STATIC_POPUP = {
	TRP_REG_EPURER_LISTE = "This action will remove from the Register every character "
							.."you never cross with one of your characters in this Realm.";
	TRP_REG_DELETE_PERSO = "This action will remove this person from the Register. Remind that notes and relationship aren't erased. So you can delete a ignored character, he will be still ignored.";
	TRP_AVERT_USE_CHAT = "You have disable the improving chat frame feature. But some links cannot be disable without reloading the interface. We recommend you to restart your interface to eliminate these links.\n\n{v}Restart Interface ?";
}

TRPCheckOptionTooltip = {
	USEPERSOTOOL = " Allows you to use a improved tooltip for the players. The new tooltip contains information specific to TotalRP "
					.."and you can choose his composition through the list below.";
	COMMUPARENT = " Allows you to automatically cover your sentences with parenthesis when you speak with an OOC status in a RP channel (/say, /group /guild, /w and /yell).";
	RACCALPHA = " Determines the transparency of the shortcuts bar.";
	RACCREINIT = " Reset the position of the shortcuts bar, if you'd lost it. ;)";
	TOOLSTATUT = " Displays the character's status (IC or OOC) in his tooltip.";
	RACCLOCK = " Locks the shortcuts bar, preventing you from moving in by error.";
	TOOLST = " Displays the character's title in his tooltip.";
	TOOLACTUELLE = " Displays the character's \"current\" description in his tooltip.";
	TOOLDESCRI = " Displays the beginning of the character's physical description (the first 200 characters) in his tooltip.";
	TOOLRELATION = " Shows the relationship between the character and you as an icon in his tooltip.";
	TOOLALIGNEMENT = " Shows the character's Alignment in his tooltip.";
	TOOLHUMEUR = " Displays the character's mood in his tooltip.";
	TOOLGUILD = " Displays character's guild information (Name, Rank) in his tooltip.";
	TOOLIMAGE = " Displays the character's faction and PvP status in his tooltip.";
	TOOLCOUPERNOM = " If the character's full name (prefix + first and last names) to is too large and exceeds the limit you selected, it will be cut.";
	TOOLCOUPERST = " If the character's title to is too large and exceeds the limit you selected, it will be cut.";
	TOOLINVAIDE = " Displays the list of possible interactions with items in their tooltip. (Remove, prepare a package, give to ... etc.)";
	TOOLINVDOCU = " If a item is associated to a document, the document thumbnail will be displayed in the tooltip.";
	CHECKRESUME = " When selecting a character, displays a window containing the character's information summary. (As a FlagRSP window style)";
	RESUMEPERSIS = " If this option is enabled, the summary window will not close automatically even after deselecting the character. It will have to be manually closed.";
	RESUMEOPACITE = " Determines the summary window opacity";
	ALIGNEPUBLIC = " Determines if your character's Alignment (Morality and Ethics) will be shown to other players.";
	ALIGNAFFICHE = " Determines if you can see the Alignment (Morallity and Ethics) of other characters.";
	NOTIFYAJOUT = " When a character is added to your Register, a message will be displayed to notify you.";
	COMPATFLAG = " Connects you to the FlagRSP channel and allows you to retrieve information about FlagRSP/MyRP/ImmersionRP users. Each character using FlagRSP (or TotalRP and having this option enabled) will"
				.." automatically be added to the Register and its information RSP (Name, Title, Prefix and Description) will be recovered. Your RSP information will also be sent over the channel, "
				.."allowing the player using FlagRSP/MyRP/ImmersionRP (or TotalRP and having enabled this option) to recover them.";
	FORCEMAJ = " When you consult a character's sheet, TRP will try to update them, event if the character is not connected.";
	RAPPELINFO = " Show you a reminder of the main information of your character (PR Status, Current Description  ..) at your connection.";
	DEBUG = " Displays debugging messages. Useful for beta testers.";
	ICONPOS = " Determines distance between the TotalRP minimap icon and the center of the minimap.";
	ICONROT = " Determines the rotation of the TotalRP icon around the minimap.";
	COMBATCLOSE = " Automatically close all TotalRP windows if your character comes into battle.";
	NEWVERSION = " Show you a message notifying you of the availability of a new version of TotalRP if someone with a newer version than yours tries to interact with you.";
	CHATAMELIO = " Allows Total RP to improve the display of chat windows.";
	HRPDETECT = " Total RP will detect any words in brackets and display it in another color (darker) by placing a tag [OOC] in front of it.";
	EMOTEDETECT = " Total RP will detect any words between stars (**) or between cones (<>) and display it as if it were a personal emote (/ me).";
	SPAMDETECT = " Total RP will detect and will not display messages containing a combination of letters you have marked as prohibited.";
	NAMEINCHAT = " Display the characters last names in the chat windows.";
	DEBUGFRAME = " If you want to display debug messages in a specific chat window.\n\n"..CHATFRAMEEXPLICATION;
	HRPDETECTFRAME = " If you want the catched OOC sentences to be placed in another chat window than when they first appeared, please enter the number of the chat window target. Otherwise, leave blank.\n\n"..CHATFRAMEEXPLICATION;
	SPAMDETECTFRAME = " If you want the catched spam messages to be placed in another chat window rather than not to be shown at all, please indicate the number of the chat window target.\n\n"..CHATFRAMEEXPLICATION;
	SPAMLISTEXPLAIN = " Please enter a sequence of groups of characters that are usually found only in spam messages. Any message"
						.." containing at least one of its panels will be considered as spam and will not be displayed (or displayed depending on your options above)."
						.." Separate each group with a newline! All non-alphanumeric characters (.,,:!? ...etc) MUST be preceded by '%' ! Use Escape to exit and save.";
	SPAMLISTEXPLAINB = " If you are not comfortable with the concept of \"string pattern\", do not try to edit this list, you could create lua errors. ;)";
	ACTIVATESOUND = " Allow TotalRP to play sounds. The sounds can be triggered by the use of an item or by using the list of sounds.";
	SONSATFLOOD = " Allow you to limit the flow of sounds played by TotalRP. \n When activated, you can specify in the box below the number of seconds that have to"
				.." pass between two sounds. This applies to the sounds received from other players as much as those emitted by the use of items.";
	SONSCOOLDOWN = " Indicate the number of seconds that have to to pass between two sounds.";
	SONSLOG = " Allow you to create a log in a chat window. This log will contains all the sounds that are played by other players.\N So you can easily track down and mute flooder.\n( ctrl + right click on their name => Mute)";
	SONSLOGFRAME = " The chat window how will be used for the sound log.\n\n"..CHATFRAMEEXPLICATION;
	INVFRAME = "Enter here the chat window in which you want the messages specific to the use of items to be displayed.\n\n"..CHATFRAMEEXPLICATION;
	NAMECOLOR = " Show character's names in the color on their relationship.";
	BARREVIE = " Show the character's life bar below the tooltip.";
	ICONRELATION = " Displays an icon before the name of the person who speaks showing the relationship between him and your character. The relation \"none\" will not be displayed.";
	LOREFRAMECHECK = " You can choose in which chat window TRP will put the translations received by the add-Lore.\n\n"..CHATFRAMEEXPLICATION.."\n\nWarning: This applies only to translations of other characters. Translations of your own words (via the \"Translate to self\" Lore) will be placed in the General window. Its coded in the Lore add-on, I can not do anything about it. ;(";
}

ExchangeError = {
	NOTARGET = "You must select a character in range.";
	NORANGE = "The target is too far from you.";
	REFUSAL = "{r}Exchange refused ";
	CANTUNIQUE = " can not carry more unit of this item.";
	CANTUNIQUESELF = "You can not carry more unit of this item.";
	HASNOTREF = "{r}This player does not have the reference of this item: his version of TRP is older than yours.";
	MUSTINSAC = "You can only exchange items that are in your backpack.";
	ALREADYEXCHNAGE = Joueur.." is busy.";
	REFCIBLE = "You must select a character.";
	ISFINGHTING = " is busy because he's fighting!";
	SHOW = "You can not show that item to this person.";
}

Exchange = {
	ECHANGEREF = "Sending information : in process ...";
	ECHANGEREFDONE = "Sending information : over.";
	SENDED = "An exchange request has been sent to ";
	SENDEDREF = "A request to send item information has been sent to ";
	REFASKING = "Item Information : Receive";
	REFASKINGMAJ = "Item Information : Update";
	REFASKINGD = " wants to give you {o}an update{w} of the information about an item you already own :\n\n";
	REFASKINGE = " wants to give you {o}an update{w} of the information about his item :\n\n";
	REFASKINGB = " wants to send you information about an item :\n\n";
	REFASKINGBWARNINGB = "\n\n{o}Warning{w} : The creator of this update is the creator of the version of the item you have, however there is always a risk that this version is earlier than the one you have"
						..".\n\n{v}Accept the update ?";
	REFASKINGBWARNING = "\n\n{o}Warning{w} : The creator of this update is different from the version you have.\n\n{v}Accept the update ?";
	REFASKINGC = "\n\nSending/Updating data is required if you want to be able to exchange this kind of item.\n\n{v}Do you accept ?";
	
	DOCUREFASKING = "Document Information : Receive";
	DOCUREFASKINGMAJ = "Document Information : Update";
	DOCUREFASKINGD = " wants to give you {o}an update{w} of a document you already own :\n\n";
	DOCUREFASKINGE = " wants to give you {o}an update{w} of his document :\n\n";
	DOCUREFASKINGB = " wants to give you a document :\n\n";
	DOCUREFASKINGBWARNINGB = "\n\n{o}Warning{w} : The creator of this update is the creator of the version of the document you have, however there is always a risk that this version is earlier than the one you have"
						..".\n\n{v}Accept the update ?";
	DOCUREFASKINGBWARNING = "\n\n{o}Warning{w} : The creator of this update is not the creator of the version you have.\n\n{v}Accept the update ?";
	DOCUREFASKINGC = "\n\n{v}Do you accept ?";
}

ObjectError = {
	NOMOUNT = "You do not have access to your safe, you have to be on your mount.";
	MUSTBOONMOUNT = "You must be on your mount.";
	NOPLANQUE = "You have no hiding place here.";
}

DeleteMessages = {
	DELETEPLANQUE = "This action will destroy the hiding place, {o}and any items still remaining into.{w}\n\n"
					.."{o}This action is not reversible.\n\n{w}Are you sure you want to delete this hiding place ?";
	DELETEPLANQUEWARN = "You have to stay near your hiding place in order to destroy it !";
	DELETEDOCUMENT = "This action will delete the document.\n\n{o}This action is not reversible.\n\n{w}Are you sure you want to delete this document ?"
}

DocumentsTexts = {
	ECHANGETITRE = "Exchange a document";
	ECHANGE1 = " wants to send you a document whose title is :\n\n{o}\"";
	ECHANGE2 = " wants to send you an update of a document {o}that you already own{w} whose title is :\n\n{o}\"";
	ECHANGE2WARNING = "\"{w}\n\nBeware, the update has not been made by the creator of the version you have the document."
					.."\n\nWould you still accept this update document?";
	ECHANGEACCEPT = "\"{w}\n\nWould you accept this document ?";
	EDITAUTEUR = "Edit Document";
	EDITAUTEURTEXT = "Be careful, you are not the creator of this document. {o}If you would make changes and save, you become the creator.";
	CREATEUR = "Document Creator : ";
	YOUCREATEUR = "You are the creator of the document";
}

CONFIGINVCONFIRM = {
	" Automatically deny any request receive item and/or item information.",
	" {o}Always{w} display a prompt if anyone wants to send you an item or a reference or an update of a reference that you already have.",
	" {o}Always{w} display a prompt if anyone wants to send an item or a reference unless the reference is known, and the sender is the creator of the item. If this is the case"
	.." the request is automatically accepted.{v} ({v}default and recommended Setting !)",
	" Receiving / updating reference are always accepted, regardless of the creator {r}(!not recommended!).",
}

CONFIGDOCUCONFIRM = {
	" Automatically deny any request receive document and/or document information.",
	" {o}Always{w} display a prompt if anyone wants to send you an document or a reference or an update of a reference that you already have.",
	" {o}Always{w} display a prompt if anyone wants to send an item or a reference unless the reference is known, and the sender is the creator of the document. If this is the case"
	.." the request is automatically accepted.{v} ({v}default and recommended Setting !)",
	" Receiving / updating reference are always accepted, regardless of the creator {r}(!not recommended!).",
}

CONFIGDOCUCONFIRMTITLE = {
	"{r}Niveau 1 : Total blocking",
	"{o}Niveau 2 : Always ask",
	"{w}Niveau 3 : Yes, if creator",
	"{v}Niveau 4 : Always yes",
}

CONFIGINVCONFIRMTITLE = {
	"{r}Niveau 1 : Total blocking",
	"{o}Niveau 2 : Always ask",
	"{w}Niveau 3 : Yes, if creator",
	"{v}Niveau 4 : Always yes",
}

Courrier = {
	DELETEA = "{w}Are you sure you want to destroy this package ?\n\n{o}You will lose forever its contents !";
	DELETEB = "{w}Are you sure you want to destroy this package ?\n\n{v}You will recover automatically its contents.";
}
