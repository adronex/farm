package com.company.interpreters;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaError;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.JsePlatform;

import javax.script.ScriptException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

public class LuaInterpreterCaller implements InterpreterCaller {

	private final LuaValue setStateFunction;
	private final LuaValue executeCommandFunction;

	public LuaInterpreterCaller() {
		Globals globals = JsePlatform.standardGlobals();
		globals.get("dofile").call("lua/libs/json.lua");
		globals.get("dofile").call("lua/game/utils.lua");

		globals.get("dofile").call("lua/game/items/item.lua");
		globals.get("dofile").call("lua/game/items/ground/field.lua");
		globals.get("dofile").call("lua/game/items/pickable/seed.lua");
		globals.get("dofile").call("lua/game/items/ground/spawnBox.lua");
		globals.get("dofile").call("lua/game/items/ground/stand.lua");
		globals.get("dofile").call("lua/game/items/ground/caravan.lua");
		globals.get("dofile").call("lua/game/items/ground/caravanParkingPlace.lua");
		globals.get("dofile").call("lua/game/items/ground/road.lua");
		globals.get("dofile").call("lua/game/staticData.lua");

		globals.get("dofile").call("lua/game/service/itemService.lua");
		globals.get("dofile").call("lua/game/service/workerService.lua");
		globals.get("dofile").call("lua/game/service/farmService.lua");

		globals.get("dofile").call("lua/game/bag.lua");
//		globals.get("dofile").call("lua/game/shop.lua");
		globals.get("dofile").call("lua/game/api.lua");

		loadFarm(globals, "lua/game/levels/farm1.json");
		loadFarm(globals, "lua/game/levels/farm2.json");
		globals.get("farmService").get("loadFarmByName").call("farm2");
		setStateFunction = globals.get("setState");
		executeCommandFunction = globals.get("commandHandler");
	}

	private void loadFarm(Globals luaGlobals, String path) {
		String result = new BufferedReader(new InputStreamReader(ClassLoader.getSystemResourceAsStream(path)))
				.lines()
				.collect(Collectors.joining());
		luaGlobals.get("farmService").get("exportFarm").call(result);
	}

	@Override
	public void setState(String savedState) {
		if (savedState == null) {
			savedState = "{}";
		}
		setStateFunction.call(LuaValue.valueOf(savedState));
	}

	@Override
	public String executeCommand(String requestBody) throws ScriptException {
		try {
			return executeCommandFunction.call(LuaValue.valueOf(requestBody)).tojstring();
		} catch (LuaError e) {
			throw new ScriptException(e);
		}
	}
}
