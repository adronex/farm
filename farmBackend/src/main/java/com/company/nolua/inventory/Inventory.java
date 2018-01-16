package com.company.nolua.inventory;

import java.util.ArrayList;
import java.util.List;

public class Inventory {

	private List<InventoryItem> inventoryItems = new ArrayList<>();

	public Inventory() {
		inventoryItems.add(new InventoryItem("softMoney", InventoryItemType.CURRENCY, 20));
	}

	public List<InventoryItem> getInventoryItems() {
		return inventoryItems;
	}
}
