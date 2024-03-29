class CfgFunctions
{
	class PPL
	{
		tag = "PPL"; //Custom tag name
		class pplFunctions
		{
			requiredAddons[] = {}; //Optional requirements of CfgPatches classes. When some addons are missing, functions won't be compiled.
			file = "y\ppl\addons\ppl_main\functions";

			class serverInit
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 1; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class serverEventHandlerInit
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class unitEventHandlerInit
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 1; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class unitInit
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class playerInit
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class log
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class generateId
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogOpen
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogUpdate
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonPlayerLoginExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonPlayerPromoteExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonTemplateSaveExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonTemplateLoadExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonTemplateRenameExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonTemplateDeleteExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonLoadoutAssignExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonLoadoutUpdateExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogButtonLoadoutExportExec
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class dialogEventHandlerKeyUpAdd
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class hintLocalized
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
			class triggerServerDialogUpdate
			{
				preInit = 0; //(formerly known as "forced") 1 to call the function upon mission start, before objects are initialized. Passed arguments are ["preInit"]
				postInit = 0; //1 to call the function upon mission start, after objects are initialized. Passed arguments are ["postInit", didJIP]
				preStart = 0; //1 to call the function upon game start, before title screen, but after all addons are loaded (config.cpp only)
				ext = ".sqf"; //Set file type, can be ".sqf" or ".fsm" (meaning scripted FSM). Default is ".sqf".
				headerType = -1; //Set function header type: -1 - no header; 0 - default header; 1 - system header.
				//recompile = 1; //1 to recompile the function upon mission start (config.cpp only; functions in description.ext are compiled upon mission start already)
			};
		};
	};
};