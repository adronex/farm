package com.company.interpreters;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.JsePlatform;

public class LuaInterpreterCaller implements InterpreterCaller {

	private final LuaValue setStateFunction;
	private final LuaValue executeCommandFunction;

	public LuaInterpreterCaller() {
		Globals globals = JsePlatform.standardGlobals();
		globals.get("dofile").call("lua/libs/json.lua");
		globals.get("dofile").call("lua/game/utils.lua");

		globals.get("dofile").call("lua/game/items/item.lua");
		globals.get("dofile").call("lua/game/items/field.lua");
		globals.get("dofile").call("lua/game/items/seed.lua");
		globals.get("dofile").call("lua/game/items/stand.lua");

		globals.get("dofile").call("lua/game/staticData.lua");
		globals.get("dofile").call("lua/game/bag.lua");
		globals.get("dofile").call("lua/game/farm.lua");
		globals.get("dofile").call("lua/game/shop.lua");
		globals.get("dofile").call("lua/game/worker.lua");
		globals.get("dofile").call("lua/game/api.lua");
		setStateFunction = globals.get("setState");
		executeCommandFunction = globals.get("commandHandler");
	}

	@Override
	public void setState(String savedState) {
		if (savedState == null) {
			savedState = "{}";
		}
		setStateFunction.call(LuaValue.valueOf(savedState));
	}

	@Override
	public String executeCommand(String requestBody) {
		return executeCommandFunction.call(LuaValue.valueOf(requestBody)).tojstring();
	}
}
