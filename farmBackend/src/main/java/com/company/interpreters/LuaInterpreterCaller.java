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
		globals.get("dofile").call("lua/utils.lua");
		globals.get("dofile").call("lua/item.lua");
		globals.get("dofile").call("lua/staticData.lua");
		globals.get("dofile").call("lua/bag.lua");
		globals.get("dofile").call("lua/farm.lua");
		globals.get("dofile").call("lua/shop.lua");
		globals.get("dofile").call("lua/api.lua");
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
