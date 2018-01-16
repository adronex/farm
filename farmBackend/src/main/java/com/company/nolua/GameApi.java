package com.company.nolua;

import com.company.nolua.inventory.Inventory;
import com.company.nolua.worker.Worker;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class GameApi {

	private static final Logger LOGGER = LoggerFactory.getLogger(Farm.class);
	private static final ObjectMapper JSON = new ObjectMapper();

	private Inventory inventory = new Inventory();
	private List<Farm> farms = new ArrayList<>();
	private List<Worker> workers = new ArrayList<>();
	private Farm currentFarm;

	public GameApi() {
		farms.add(loadFarm("lua/game/levels/farm1.json"));
		farms.add(loadFarm("lua/game/levels/farm2.json"));
		currentFarm = farms.get(0);
		// todo: WTF? +1?
		workers.add(new Worker("Uasya", null, new Worker.Position(2, 3)));
	}

	private static Farm loadFarm(String path) {
		String farmAsJson = new BufferedReader(new InputStreamReader(ClassLoader.getSystemResourceAsStream(path)))
				.lines()
				.collect(Collectors.joining());
		return new Farm(farmAsJson);
	}

	public String executeCommand(String json) {
		try {
			JsonNode commandsArray = JSON.readTree(json);
			for (JsonNode commandJson : commandsArray) {
				Command command = Command.valueOf(commandJson.get("command").asText());
				switch (command) {
					case GET:
						return JSON.writeValueAsString(new GameState(inventory.getInventoryItems(), currentFarm, workers));
					case MOVE:
						// todo: move it
						break;
					default:
						throw new IllegalArgumentException("Illegal command " + command);
				}
			}
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
		return "ok";
	}

	public Inventory getInventory() {
		return inventory;
	}

	public List<Farm> getFarms() {
		return farms;
	}
}
