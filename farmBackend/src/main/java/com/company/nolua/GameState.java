package com.company.nolua;

import com.company.nolua.inventory.InventoryItem;
import com.company.nolua.worker.Worker;

import java.util.List;

public class GameState {
	private List<InventoryItem> bag;
	private Farm farm;
	private List<Worker> workers;

	public GameState(List<InventoryItem> bag, Farm farm, List<Worker> workers) {
		this.bag = bag;
		this.farm = farm;
		this.workers = workers;
	}

	public List<InventoryItem> getBag() {
		return bag;
	}

	public Farm getFarm() {
		return farm;
	}

	public List<Worker> getWorkers() {
		return workers;
	}
}
