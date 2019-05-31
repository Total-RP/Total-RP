-------------------------------------------------------------------------------
-- [ Variables Systeme de l'add-on ] -- 
-------------------------------------------------------------------------------
TRP_version = "1107";
TRP_version_EN = "1.000";
hasBeenAlerted = false;
Joueur = UnitName("player");
Royaume = GetRealmName();
seqtime = 0;
seqtimeRixeGauche = 0;
seqtimeRixeDroite = 0;
animationPlayed = 1;
animationPlayedRixeGauche = 1;
animationPlayedRixeDroite = 1;
anim_humeur = {73,77,60,68,83,70,3,186,185};
			
relation_texture = {"Interface\\ICONS\\INV_Misc_Bone_HumanSkull_02.blp",
					"Interface\\ICONS\\Ability_DualWield.blp",
					"Interface\\ICONS\\Achievement_Reputation_01.blp",
					"Interface\\ICONS\\Achievement_Reputation_05.blp",
					"Interface\\ICONS\\Achievement_Reputation_06.blp",
					"Interface\\ICONS\\INV_ValentinesCandy.blp",
					"Interface\\ICONS\\Achievement_Reputation_08.blp"};
					
relation_color = {"|cff555555","|cffff0000","|cffaaaaff","|cffffffff","|cff00ff00","|cffff7fff","|cffff7f00"};
relation_color_RGB = {{0.3,0.3,0.3},{1,0,0},{0.5,0.5,1},{1,1,1},{0,1,0},{1,0.5,1},{1,0.5,0}};
humeur_color = {"|cffff0000","|cffaaaaff","|cffc69c6d","|cff82ca9c","|cffff7fff","|cfffff799","|cffffffff"};
moral_color = {"|cffff0000","|cffffffff","|cff00ff00","|cffaaaaaa"};
statut_color = {"|cffff0000","|cff00ff00","|cffffffff"};

preTabDiscu = {
	["CHAT_MSG_SAY"] = "",
	["CHAT_MSG_YELL"] = "",
	["CHAT_MSG_PARTY"] = "|Hchannel:group|h[Party]|h",
	["CHAT_MSG_RAID"] = "|Hchannel:raid|h[Raid]|h",
	["CHAT_MSG_GUILD"] = "|Hchannel:guilde|h[Guild]|h",
	["CHAT_MSG_OFFICER"] = "|Hchannel:officer|h[Officer]|h",
	["CHAT_MSG_RAID_LEADER"] = "|Hchannel:raid|h[Raid Leader]|h",
	["CHAT_MSG_WHISPER"] = "From ",
	["CHAT_MSG_WHISPER_INFORM"] = "To ",
	["CHAT_MSG_TEXT_EMOTE"] = "",
	["CHAT_MSG_PARTY_LEADER"] = "|Hchannel:group|h[Party Leader]|h",
}

postTabDiscu = {
	["CHAT_MSG_SAY"] = "|r] says :  ",
	["CHAT_MSG_YELL"] = "|r] yells :  ",
	["CHAT_MSG_PARTY"] = "|r]:  ",
	["CHAT_MSG_RAID"] = "|r]:  ",
	["CHAT_MSG_GUILD"] = "|r]:  ",
	["CHAT_MSG_OFFICER"] = "|r]:  ",
	["CHAT_MSG_RAID_LEADER"] = "|r]:  ",
	["CHAT_MSG_WHISPER"] = "|r] whispers :  ",
	["CHAT_MSG_WHISPER_INFORM"] = "|r]:  ",
	["CHAT_MSG_TEXT_EMOTE"] = "",
	["CHAT_MSG_PARTY_LEADER"] = "|r]:  ",
}

classes_color = {
	["HUNTER"] = "|cffabd473",
	["WARLOCK"] = "|cff9482c9",
	["PRIEST"] = "|cffffddff",
	["PALADIN"] = "|cfff58cba",
	["MAGE"] = "|cff69ccf0",
	["ROGUE"] = "|cfffff569 ",
	["DRUID"] = "|cffff7d0a",
	["SHAMAN"] = "|cff2459ff",
	["WARRIOR"] = "|cffc79c6e",
	["DEATHKNIGHT"] = "|cffc41f3b",
}

textureRace = {
		["Human"] = "Human",
		["Gnome"] = "Gnome",
		["Scourge"] = "Undead",
		["NightElf"] = "Nightelf",
		["Dwarf"] = "Dwarf",
		["Draenei"] = "Draenei",
		["Orc"] = "Orc",
		["BloodElf"] = "Bloodelf",
		["Troll"] = "Troll",
		["Tauren"] = "Tauren",
	};
	
textureSex = {
	"Neutral",
	"Male",
	"Female",
};

Saved_ChatFrame_OnEvent = nil;
SavedFCF_OpenNewWindow = nil;
SavedSendChatMessage = nil;

compagnonPrefixe = {
	"Serviteur d",
	"Familier d",
	"Compagnon d",
	"Gardien d",
	"'s Pet",
	"'s Guardian",
	"'s Minion",
	"'s Companion",
};

RSPInit = false;
CourrierInit = false;

PersoTab = {};
CoffreTab = {};
DocumentsTab = {};
ObjPersoTab = {};
IconeTab = {};
ObjetTab = {};
DocumentTab = {};
PersonnageTab = {};
SoundTab = {};
PlaySoundTab = {};
ModeleTab = {};
TabMember = {};
TabInvToDelete = nil;
FindPlanqueTab = nil;

ExchangeTarget = nil;
ExchangeRefTarget = nil;
TRPWaitingForInfos = nil;
TRPWaitingForShow = nil;

TRPFrameUI = {};

TRPCHATNAME = nil;
TRPLASTSOUND = nil;

--Rixe :
RixeNextTurnTimer = nil;
RixeActionTab = nil;
RixeReponseTab = nil;
RixeTurnTo = nil;
RixeVieGauche = nil;
RixeVieDroite = nil;
RixeAPGauche = nil;
RixeAPDroite = nil;
RixeNomOpponent = nil;
RixeObjetGauche = nil;
RixeObjetDroite = nil;
RixeLastInsulte = nil;
RixeLastDiversion = nil;
RixeSexGauche = nil;
RixeSexDroite = nil;
RixeModeGauche = nil;
RixeModeDroite = nil;
RixeActionGauche = nil;
RixeActionDroite = nil;
RixeTimerGauche = nil;
RixeTimerDroite = nil;
RixeNextTimerGauche = nil;
RixeNextTimerDroite = nil;
RixeNextActionGauche = nil;
RixeNextActionDroite = nil;
RixeTimerReponseGauche = nil;
RixeTimerReponseDroite = nil;

IconeFaction = {
	["Alliance"] = "|TInterface\\BattlefieldFrame\\Battleground-Alliance.blp:35:35|t",
	["Horde"] = "|TInterface\\BattlefieldFrame\\Battleground-Horde.blp:35:35|t",
}

DocumentFont = {
	"Friz",
	"Fonts\\FRIZQT__.TTF",
	"Arial",
	"Fonts\\ARIALN.TTF",
	"Skurri",
	"Fonts\\skurri.ttf",
	"Morpheus",
	"Fonts\\MORPHEUS.ttf",
	"Courrier New",
	"Interface\\AddOns\\totalRP\\Fonts\\cour.ttf"
}

DocumentBackground = {
	{
		"Interface\\Stationery\\StationeryTest1.blp",
		"Interface\\Stationery\\StationeryTest2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_Val1.blp",
		"Interface\\Stationery\\Stationery_Val2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_UC1.blp",
		"Interface\\Stationery\\Stationery_UC2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_TB1.blp",
		"Interface\\Stationery\\Stationery_TB2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_OG1.blp",
		"Interface\\Stationery\\Stationery_OG2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_ill1.blp",
		"Interface\\Stationery\\Stationery_ill2.blp",
	},
	{
		"Interface\\Stationery\\Stationery_Chr1.blp",
		"Interface\\Stationery\\Stationery_Chr2.blp",
	},
	{
		"Interface\\Stationery\\GMStationery1.blp",
		"Interface\\Stationery\\GMStationery2.blp",
	},
}

IconeZone = {
	{--Kalimdor
		"Interface\\Icons\\Achievement_Zone_Azshara_01.blp",
		"Interface\\Icons\\Achievement_Zone_Winterspring.blp",
		"Interface\\Icons\\Achievement_Zone_UnGoroCrater_01.blp",
		"Interface\\Icons\\Achievement_Zone_Darnassus.blp",
		"Interface\\Icons\\Achievement_Zone_Desolace.blp",
		"Interface\\Icons\\Achievement_Zone_Durotar.blp",
		"Interface\\Icons\\Achievement_Zone_Feralas.blp",
		"Interface\\Icons\\Achievement_Zone_Felwood.blp",
		"Interface\\Icons\\Achievement_Zone_AzuremystIsle_01.blp",
		"Interface\\Icons\\Achievement_Zone_AzuremystIsle_01.blp",
		"Interface\\Icons\\Achievement_Zone_Mulgore_01.blp",
		"Interface\\Icons\\Achievement_Zone_Stonetalon_01.blp",
		"Interface\\Icons\\Achievement_Zone_Barrens_01.blp",
		"Interface\\Icons\\Achievement_Zone_DustwallowMarsh.blp",
		"Interface\\Icons\\Achievement_Zone_ThousandNeedles_01.blp",
		"Interface\\Icons\\Achievement_Zone_Mulgore_01.blp",
		"Interface\\Icons\\Achievement_Zone_Durotar.blp",
		"Interface\\Icons\\Achievement_Zone_Ghostlands.blp",
		"Interface\\Icons\\Achievement_Zone_Ashenvale_01.blp",
		"Interface\\Icons\\SPELL_ARCANE_TELEPORTMOONGLADE.BLP",
		"Interface\\Icons\\Achievement_Zone_Silithus_01.blp",
		"Interface\\Icons\\Achievement_Zone_Darkshore_01.blp",
		"Interface\\Icons\\Achievement_Zone_Tanaris_01.blp",
		"Interface\\Icons\\Achievement_Zone_Darnassus.blp",
	},
	{--Royaume de l'est
		"Interface\\Icons\\Achievement_Zone_Duskwood.blp",
		"Interface\\Icons\\Achievement_Zone_EversongWoods.blp",
		"Interface\\Icons\\Achievement_Zone_TirisfalGlades_01.blp",
		"Interface\\Icons\\Achievement_Zone_HillsbradFoothills.blp",
		"Interface\\Icons\\Achievement_Zone_DeadwindPass.blp",
		"Interface\\Icons\\Achievement_Zone_DunMorogh.blp",
		"Interface\\Icons\\Achievement_Zone_ElwynnForest.blp",
		"Interface\\Icons\\Achievement_Zone_Silverpine_01.blp",
		"Interface\\Icons\\Achievement_Zone_Ironforge.blp",
		"Interface\\Icons\\Achievement_Zone_TirisfalGlades_01.blp",
		"Interface\\Icons\\Achievement_Zone_SearingGorge_01.blp",
		"Interface\\Icons\\Achievement_Zone_ArathiHighlands_01.blp",
		"Interface\\Icons\\Achievement_Zone_ElwynnForest.blp",
		"Interface\\Icons\\Achievement_Zone_IsleOfQuelDanas.blp",
		"Interface\\Icons\\Achievement_Zone_RedridgeMountains.blp",
		"Interface\\Icons\\Achievement_Zone_Hinterlands_01.blp",
		"Interface\\Icons\\Achievement_Zone_Wetlands_01.blp",
		"Interface\\Icons\\Achievement_Zone_Ghostlands.blp",
		"Interface\\Icons\\Achievement_Zone_LochModan.blp",
		"Interface\\Icons\\Achievement_Zone_IsleOfQuelDanas.blp",
		"Interface\\Icons\\Achievement_Zone_EasternPlaguelands.blp",
		"Interface\\Icons\\Achievement_Zone_WesternPlaguelands_01.blp",
		"Interface\\Icons\\Achievement_Zone_WestFall_01.blp",
		"Interface\\Icons\\Achievement_Zone_AlteracMountains_01.blp",
		"Interface\\Icons\\Achievement_Zone_BurningSteppes_01.blp",
		"Interface\\Icons\\Achievement_Zone_BlastedLands_01.blp",
		"Interface\\Icons\\Achievement_Zone_Badlands_01.blp",
		"Interface\\Icons\\Achievement_Zone_Stranglethorn_01.blp",
	},
	{--Outreterre
		"Interface\\Icons\\Achievement_Zone_Terrokar.blp",
		"Interface\\Icons\\Achievement_Zone_BladesEdgeMtns_01.blp",
		"Interface\\Icons\\Achievement_Zone_Zangarmarsh.blp",
		"Interface\\Icons\\Achievement_Zone_Nagrand_01.BLP",
		"Interface\\Icons\\Achievement_Zone_HellfirePeninsula_01.blp",
		"Interface\\Icons\\Achievement_Zone_Netherstorm_01.blp",
		"Interface\\Icons\\Achievement_Zone_Tanaris_01.blp",
		"Interface\\Icons\\Spell_Arcane_TeleportShattrath.blp",
	},
	{--Norfendre
		"Interface\\Icons\\Achievement_Zone_Sholazar_02.blp",
		"Interface\\Icons\\Spell_Arcane_TeleportDalaran.blp",
		"Interface\\Icons\\Achievement_Zone_DragonBlight_03.blp",
		"Interface\\Icons\\Achievement_Zone_HowlingFjord_03.BLP",
		"Interface\\Icons\\Achievement_Zone_CrystalSong_01.blp",
		"Interface\\Icons\\INV_EssenceOfWintergrasp.blp",
		"Interface\\Icons\\Achievement_Zone_IceCrown_01.blp",
		"Interface\\Icons\\Achievement_Zone_GrizzlyHills_03.blp",
		"Interface\\Icons\\Achievement_Zone_StormPeaks_03.blp",
		"Interface\\Icons\\Achievement_Zone_BoreanTundra_01.blp",
		"Interface\\Icons\\Achievement_Zone_ZulDrak_01.blp",
	},
};

Documents_Consulte = {
		["Createur"] = Joueur,
		["VignetteIcone"] = "INV_Scroll_12",
		["VignetteTitre"] = "New Document",
		["VignetteAuteur"] = Joueur,
		["VignetteDate"] = date("%d/%m \195\160 %Hh%M"),
		["Texte"] = {
			["Texte"] = {},
			["Font"] = 1,
			["Taille"] = 11,
			["Surligner"] = 1,
			["Ombre"] = 100,
			["Alignement"] = 1,
		},
		["Titre"] = {
			["Titre"] = "New Document",
			["Font"] = 1,
			["Taille"] = 11,
			["Surligner"] = 1,
			["Ombre"] = 100,
			["Alignement"] = 2,
			["DifX"] = 165,
			["DifY"] = 360,
		},
		["Background"] = 1,
		["Signature"] = {
			["Auteur"] = Joueur,
			["Font"] = 1,
			["Taille"] = 11,
			["Surligner"] = 1,
			["Ombre"] = 100,
			["Alignement"] = 2,
			["DifX"] = 165,
			["DifY"] = 50,
		},
		["Images"] = {
			["Image1"] = {
				["Nom"] = "",
				["SizeX"] = 100,
				["SizeY"] = 100,
				["PosX"] = 165,
				["PosY"] = 220,
				["Alpha"] = 100,
			},
			["Image2"] = {
				["Nom"] = "",
				["SizeX"] = 100,
				["SizeY"] = 100,
				["PosX"] = 165,
				["PosY"] = 220,
				["Alpha"] = 100,
			},
			["Image3"] = {
				["Nom"] = "",
				["SizeX"] = 100,
				["SizeY"] = 100,
				["PosX"] = 165,
				["PosY"] = 220,
				["Alpha"] = 100,
			},
		},
};