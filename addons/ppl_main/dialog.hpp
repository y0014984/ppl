/*

STRG + I für den Import aus dem Config File:
	configfile >> "PPL_Main_Dialog"

*/

class RscListbox;
class RscText;
class RscEdit;
class RscButton;

class PPL_Main_Dialog
{
	idd = 24984;
	movingEnable = true;
	enableSimulation = true;
	class controls
	{	
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by y0014984|Sebastian, v1.063, #Wytyno)
		////////////////////////////////////////////////////////

		class PPL_RscText_1000: RscText
		{
			idc = 1000;
			text = $STR_PPL_Main_Dialog_Head;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class PPL_RscText_1001: RscText
		{
			idc = 1001;
			text = $STR_PPL_Main_Dialog_Server_Status;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.25};
		};
		class PPL_RscText_1002: RscText
		{
			idc = 1002;
			text = $STR_PPL_Main_Dialog_Player_Status;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.25};
		};
		class RscText_1006: RscText
		{
			idc = 1006;
			text = $STR_PPL_Main_Dialog_Players;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class RscText_1007: RscText
		{
			idc = 1007;
			text = $STR_PPL_Main_Dialog_Templates;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class RscText_1008: RscText
		{
			idc = 1008;
			text = $STR_PPL_Main_Dialog_Loadouts;
			x = 20 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class PPL_RscEdit_1400: RscEdit
		{
			idc = 1400;
			text = "";
			x = 6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
		};
		class PPL_RscEdit_1401: RscEdit
		{
			idc = 1401;
			text = "";
			x = 6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
		};
		class PPL_RscEdit_1402: RscEdit
		{
			idc = 1402;
			text = "";
			x = 26.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 13.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
		};
		class PPL_RscListbox_1500: RscListbox
		{
			idc = 1500;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 19 * GUI_GRID_W;
			h = 6.5 * GUI_GRID_H;
		};
		class PPL_RscListbox_1501: RscListbox
		{
			idc = 1501;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 19 * GUI_GRID_W;
			h = 6.5 * GUI_GRID_H;
		};
		class PPL_RscListbox_1502: RscListbox
		{
			idc = 1502;
			x = 20 * GUI_GRID_W + GUI_GRID_X;
			y = 5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 16.5 * GUI_GRID_H;
		};
		class PPL_RscButton_1600: RscButton
		{
			idc = 1600;
			text = $STR_PPL_Main_Dialog_Button_Login;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonPlayerLoginExec;";
		};
		class PPL_RscButton_1610: RscButton
		{
			idc = 1610;
			text = $STR_PPL_Main_Dialog_Button_Promote;
			x = 6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonPlayerPromoteExec;";
		};
		class PPL_RscEdit_1603: RscEdit
		{
			idc = 1603;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
		};
		class PPL_RscButton_1602: RscButton
		{
			idc = 1602;
			text = $STR_PPL_Main_Dialog_Button_Template_Save;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonTemplateSaveExec;";
		};
		class RscButton_1607: RscButton
		{
			idc = 1607;
			text = $STR_PPL_Main_Dialog_Button_Template_Load;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 24 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;

			action = "[] call PPL_fnc_dialogButtonTemplateLoadExec;";
		};
		class PPL_RscButton_1606: RscButton
		{
			idc = 1606;
			text = $STR_PPL_Main_Dialog_Button_Template_Rename;
			x = 6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 24 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonTemplateRenameExec;";
		};
		class RscButton_1608: RscButton
		{
			idc = 1608;
			text = $STR_PPL_Main_Dialog_Button_Template_Delete;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 24 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonTemplateDeleteExec;";
		};		
		class PPL_RscButton_1604: RscButton
		{
			idc = 1604;
			text = $STR_PPL_Main_Dialog_Button_Loadout_Assign;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonLoadoutAssignExec;";
		};
		class PPL_RscButton_1605: RscButton
		{
			idc = 1605;
			text = $STR_PPL_Main_Dialog_Button_Loadout_Export;
			x = 27.5 * GUI_GRID_W + GUI_GRID_X;
			y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonLoadoutExportExec;";
		};
		class PPL_RscButton_1609: RscButton
		{
			idc = 1609;
			text = $STR_PPL_Main_Dialog_Button_Loadout_Update;
			x = 34 * GUI_GRID_W + GUI_GRID_X;
			y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "[] call PPL_fnc_dialogButtonLoadoutUpdateExec;";
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};

class PPL_Export_Dialog
{
	idd = 14985;
	movingEnable = true;
	enableSimulation = true;
	class controls
	{
		class PPL_RscText_2000: RscText
		{
			idc = 2000;
			text = $STR_PPL_Export_Dialog_Head;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class PPL_RscEdit_2500: RscEdit
		{
			idc = 2500;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 22 * GUI_GRID_H;
			
			style = ST_MULTI;		
			lineSpacing = 1;
			colorBackground[] = {0,0,0,0.25};
		};
		class PPL_RscButton_2600: RscButton
		{
			idc = 2600;
			text = $STR_PPL_Export_Dialog_Button_Close;
			x = 34 * GUI_GRID_W + GUI_GRID_X;
			y = 24 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			
			action = "closeDialog 1;";
		};
	};
};
