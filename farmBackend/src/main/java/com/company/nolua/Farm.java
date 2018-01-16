package com.company.nolua;

import com.company.nolua.ground.Ground;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class Farm {

	private static final Logger LOGGER = LoggerFactory.getLogger(Farm.class);

	private String name;
	private Integer height;
	private Integer width;
	private Ground[][] cells;

	public Farm(Integer height, Integer width) {
		this.height = height;
		this.width = width;
		cells = new Ground[height][width];
	}

	public Farm(String json) {
		try {
			JsonNode farm = new ObjectMapper().readTree(json);
			name = farm.get("name").asText();
			height = farm.get("height").asInt();
			width = farm.get("width").asInt();
			cells = new Ground[height][width];
			for (int row = 0; row < farm.get("cells").size(); row++){
				JsonNode rowNode = farm.get("cells").get(row);
				for (int col = 0; col < rowNode.size(); col++) {
					cells[row][col] = new Ground(rowNode.get(col).toString());
				}
			}
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
	}

	public String getName() {
		return name;
	}

	public Integer getHeight() {
		return height;
	}

	public Integer getWidth() {
		return width;
	}

	public Ground[][] getCells() {
		return cells;
	}
}
