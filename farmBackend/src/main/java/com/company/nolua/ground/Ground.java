package com.company.nolua.ground;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Date;

public class Ground {

	private static final Logger LOGGER = LoggerFactory.getLogger(Ground.class);

	private String id;
	private GroundType type;
	private Date readyTime;

	public Ground(String json) {
		try {
			JsonNode ground = new ObjectMapper().readTree(json);
			id = ground.get("id").asText();
			type = GroundType.valueOf(ground.get("type").asText());
			readyTime = new Date(ground.path("readyTime").asLong(0));
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
	}

	public String getId() {
		return id;
	}

	public GroundType getType() {
		return type;
	}

	public Date getReadyTime() {
		return readyTime;
	}
}
